/**
 * Procedural memory tools: record_experience, recall_experience
 */

import { randomUUID } from 'node:crypto';
import { z } from 'zod';
import { getDb } from '../lib/db.js';
import { safeJsonParse } from '../lib/json.js';

/** Values better-sqlite3 can bind; anything else would throw at query time. */
function isBindableScalar(v) {
  return v === null || ['string', 'number', 'boolean'].includes(typeof v);
}

export function registerEpisodeTools(server) {

  // ─── record_experience ───
  server.registerTool(
    'record_experience',
    {
      title: 'Record Experience',
      description: 'Record a workflow experience (success, failure, or lesson) with steps.',
      inputSchema: {
        type: z.enum(['success', 'failure', 'lesson']).describe('Experience type'),
        context: z.record(z.unknown()).optional().describe('Context: {bpm, key, genre, mood, ...}'),
        summary: z.string().max(2000).describe('Brief summary of what happened'),
        outcome: z.string().max(2000).optional().describe('Result or lesson learned'),
        session_id: z.string().max(200).optional().describe('Session identifier'),
        steps: z.array(z.object({
          element: z.string().max(100).optional().describe('Which element (kick, 808, etc.)'),
          action: z.string().max(1000).describe('What was done'),
          decision: z.string().max(1000).optional().describe('Decision made'),
          reason: z.string().max(1000).optional().describe('Why this decision'),
          result: z.string().max(1000).optional().describe('What happened'),
        })).max(50).describe('Workflow steps'),
      },
      outputSchema: {
        episodeId: z.string(),
        type: z.string(),
        summary: z.string(),
        stepsRecorded: z.number(),
      },
      annotations: {
        readOnlyHint: false,
        destructiveHint: false,
        idempotentHint: false,
        openWorldHint: false,
      },
    },
    async ({ type, context, summary, outcome, session_id, steps }) => {
      const db = getDb();
      const episodeId = randomUUID();
      const now = new Date().toISOString();

      db.prepare(`
        INSERT INTO episodes (id, type, context, summary, outcome, session_id, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?)
      `).run(episodeId, type, context ? JSON.stringify(context) : null, summary, outcome || null, session_id || null, now);

      const insertStep = db.prepare(`
        INSERT INTO episode_steps (id, episode_id, step_order, element, action, decision, reason, result)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      `);

      for (let i = 0; i < steps.length; i++) {
        const s = steps[i];
        insertStep.run(
          randomUUID(), episodeId, i + 1,
          s.element || null, s.action,
          s.decision || null, s.reason || null, s.result || null
        );
      }

      const payload = {
        episodeId,
        type,
        summary,
        stepsRecorded: steps.length
      };

      return {
        structuredContent: payload,
        content: [{
          type: 'text',
          text: JSON.stringify(payload, null, 2)
        }]
      };
    }
  );

  // ─── recall_experience ───
  server.registerTool(
    'recall_experience',
    {
      title: 'Recall Experience',
      description: 'Find past experiences by context (genre, bpm, key, mood, element).',
      inputSchema: {
        context: z.record(z.unknown()).optional().describe('Context filter: {genre, bpm, key, mood, ...}'),
        element: z.string().max(100).optional().describe('Filter by element name'),
        type: z.enum(['success', 'failure', 'lesson']).optional().describe('Filter by experience type'),
        limit: z.number().min(1).max(20).default(5).describe('Max results'),
      },
      annotations: {
        readOnlyHint: true,
        destructiveHint: false,
        idempotentHint: true,
        openWorldHint: false,
      },
    },
    async ({ context, element, type, limit }) => {
      const db = getDb();

      let query = 'SELECT * FROM episodes WHERE 1=1';
      const params = [];

      if (type) {
        query += ' AND type = ?';
        params.push(type);
      }

      // Context filtering via JSON extraction
      //  - key validated against an identifier pattern (prevents SQL injection via key)
      //  - value must be a bindable scalar, otherwise better-sqlite3 throws TypeError
      if (context) {
        for (const [key, value] of Object.entries(context)) {
          if (!/^[a-zA-Z_]\w*$/.test(key)) continue; // skip invalid keys
          if (!isBindableScalar(value)) continue;     // skip objects/arrays
          query += ` AND json_extract(context, '$.${key}') = ?`;
          params.push(value);
        }
      }

      query += ' ORDER BY created_at DESC LIMIT ?';
      params.push(limit);

      const episodes = db.prepare(query).all(...params);

      if (episodes.length === 0) {
        return { content: [{ type: 'text', text: 'No matching experiences found.' }] };
      }

      // Fetch steps for each episode, optionally filtered by element
      const results = [];
      for (const ep of episodes) {
        let stepsQuery = 'SELECT * FROM episode_steps WHERE episode_id = ?';
        const stepsParams = [ep.id];

        if (element) {
          stepsQuery += ' AND element = ?';
          stepsParams.push(element);
        }

        stepsQuery += ' ORDER BY step_order';
        const steps = db.prepare(stepsQuery).all(...stepsParams);

        // Skip episodes with no matching steps if element filter is set
        if (element && steps.length === 0) continue;

        results.push({
          id: ep.id,
          type: ep.type,
          context: ep.context ? safeJsonParse(ep.context, null) : null,
          summary: ep.summary,
          outcome: ep.outcome,
          created_at: ep.created_at,
          steps: steps.map(s => ({
            order: s.step_order,
            element: s.element,
            action: s.action,
            decision: s.decision,
            reason: s.reason,
            result: s.result
          }))
        });
      }

      if (results.length === 0) {
        return { content: [{ type: 'text', text: 'No matching experiences found.' }] };
      }

      const formatted = results.map((r, i) => {
        let text = `[${i + 1}] ${r.type.toUpperCase()}: ${r.summary}\n`;
        if (r.context) text += `    Context: ${JSON.stringify(r.context)}\n`;
        if (r.outcome) text += `    Outcome: ${r.outcome}\n`;
        text += `    Steps:\n`;
        for (const s of r.steps) {
          text += `      ${s.order}. [${s.element || '-'}] ${s.action}`;
          if (s.decision) text += ` → ${s.decision}`;
          if (s.result) text += ` (${s.result})`;
          text += '\n';
        }
        return text;
      });

      return {
        content: [{ type: 'text', text: `Found ${results.length} experiences:\n\n${formatted.join('\n')}` }]
      };
    }
  );
}
