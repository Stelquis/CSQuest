/**
 * MCP Resources — expose read-only knowledge as addressable resources.
 *
 *   knowledge://graph/stats   — graph statistics (static URI)
 *   knowledge://node/{id}     — a single knowledge node with its 1-hop edges (URI template)
 */

import { ResourceTemplate } from '@modelcontextprotocol/sdk/server/mcp.js';
import { McpError } from '@modelcontextprotocol/sdk/types.js';
import { getDb } from './lib/db.js';
import { parseMetadata } from './lib/json.js';

/** MCP spec: resource-not-found error code */
const RESOURCE_NOT_FOUND = -32002;

export function registerKnowledgeResources(server) {

  // ─── knowledge://graph/stats ───
  server.registerResource(
    'graph-stats',
    'knowledge://graph/stats',
    {
      title: 'Knowledge Graph Stats',
      description: 'Active/expired node and edge counts for the knowledge graph.',
      mimeType: 'application/json',
    },
    async (uri) => {
      const db = getDb();
      const stats = {
        activeNodes: db.prepare('SELECT COUNT(*) AS c FROM nodes WHERE valid_until IS NULL').get().c,
        activeEdges: db.prepare('SELECT COUNT(*) AS c FROM edges WHERE valid_until IS NULL').get().c,
        episodes: db.prepare('SELECT COUNT(*) AS c FROM episodes').get().c,
        expiredNodes: db.prepare('SELECT COUNT(*) AS c FROM nodes WHERE valid_until IS NOT NULL').get().c,
        expiredEdges: db.prepare('SELECT COUNT(*) AS c FROM edges WHERE valid_until IS NOT NULL').get().c,
      };
      return {
        contents: [{
          uri: uri.href,
          mimeType: 'application/json',
          text: JSON.stringify(stats, null, 2),
        }],
      };
    }
  );

  // ─── knowledge://node/{id} ───
  server.registerResource(
    'knowledge-node',
    new ResourceTemplate('knowledge://node/{id}', {
      // list() is required by ResourceTemplate even when enumeration is desired
      list: async () => {
        const db = getDb();
        const rows = db.prepare(`
          SELECT id, name, trust, type FROM nodes
          WHERE valid_until IS NULL
          ORDER BY created_at DESC
          LIMIT 200
        `).all();
        return {
          resources: rows.map(r => ({
            uri: `knowledge://node/${r.id}`,
            name: r.name,
            description: `${r.trust}/${r.type}`,
            mimeType: 'application/json',
          })),
        };
      },
    }),
    {
      title: 'Knowledge Node',
      description: 'A single knowledge node with its 1-hop edges.',
      mimeType: 'application/json',
    },
    async (uri, variables) => {
      const db = getDb();
      const id = variables.id;

      const node = db.prepare('SELECT * FROM nodes WHERE id = ? AND valid_until IS NULL').get(id);
      if (!node) {
        // Per MCP spec, a missing resource must raise -32002 rather than
        // returning a success payload that embeds the error.
        throw new McpError(RESOURCE_NOT_FOUND, `Resource not found: knowledge://node/${id}`);
      }

      const edges = db.prepare(`
        SELECT e.relation_type, e.weight, e.reasoning,
          CASE WHEN e.source_id = ? THEN 'outgoing' ELSE 'incoming' END AS direction,
          CASE WHEN e.source_id = ? THEN n2.name ELSE n1.name END AS connected_name
        FROM edges e
        LEFT JOIN nodes n1 ON e.source_id = n1.id
        LEFT JOIN nodes n2 ON e.target_id = n2.id
        WHERE (e.source_id = ? OR e.target_id = ?) AND e.valid_until IS NULL
      `).all(id, id, id, id);

      const payload = {
        ...node,
        metadata: node.metadata ? parseMetadata(node.metadata) : null,
        edges,
      };

      return {
        contents: [{
          uri: uri.href,
          mimeType: 'application/json',
          text: JSON.stringify(payload, null, 2),
        }],
      };
    }
  );
}
