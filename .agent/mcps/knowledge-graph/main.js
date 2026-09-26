/**
 * Knowledge Graph MCP Server
 * SQLite + sqlite-vec + FTS5 hybrid search for arrangement knowledge.
 *
 * Capabilities:
 *   Tools (13):
 *     store_knowledge, connect_knowledge, forget_knowledge, memory_stats,
 *     search_memory, get_knowledge, traverse_graph, list_knowledge, update_knowledge,
 *     record_experience, recall_experience, maintain_graph, crystallize_skill
 *   Resources:
 *     knowledge://graph/stats   — graph statistics
 *     knowledge://node/{id}     — a single knowledge node with its 1-hop edges
 */

import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';
import { registerKnowledgeTools } from './tools/knowledge-tools.js';
import { registerSearchTools } from './tools/search-tools.js';
import { registerEpisodeTools } from './tools/episode-tools.js';
import { registerMaintenanceTools } from './tools/maintenance-tools.js';
import { registerKnowledgeResources } from './resources.js';
import { getDb, closeDb } from './lib/db.js';

// Initialize database on startup
try {
  getDb();
} catch (e) {
  console.error('[knowledge-graph] Database initialization failed:', e.message);
  process.exit(1);
}

// Start loading embedding model in background (non-blocking)
import('./lib/embeddings.js').then(async (mod) => {
  try {
    // Trigger model download/load by embedding a test string
    await mod.embed('test');
    console.error('[knowledge-graph] Embedding model ready');
  } catch (e) {
    console.error('[knowledge-graph] Embedding model failed to load:', e.message);
    console.error('[knowledge-graph] Falling back to FTS5 + graph search only');
  }
});

const server = new McpServer({
  name: 'knowledge-graph',
  version: '1.0.0',
  description: 'Knowledge Graph — hybrid search for arrangement knowledge'
});

// Register tools
registerKnowledgeTools(server);
registerSearchTools(server);
registerEpisodeTools(server);
registerMaintenanceTools(server);

// Register resources
registerKnowledgeResources(server);

// Graceful shutdown
process.on('SIGINT', () => { closeDb(); process.exit(0); });
process.on('SIGTERM', () => { closeDb(); process.exit(0); });

// Start server
try {
  const transport = new StdioServerTransport();
  await server.connect(transport);
  console.error('[knowledge-graph] MCP server started');
} catch (e) {
  console.error('[knowledge-graph] Failed to start MCP server:', e.message);
  process.exit(1);
}
