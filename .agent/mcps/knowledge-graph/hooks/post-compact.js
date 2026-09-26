#!/usr/bin/env node

/**
 * Post-Compact hook (SessionStart, matcher: compact)
 * Re-injects core knowledge after context compaction.
 * Focuses on high-trust (principle) nodes and active production context.
 */

import Database from 'better-sqlite3';
import * as sqliteVec from 'sqlite-vec';
import { existsSync } from 'fs';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const DB_PATH = join(__dirname, '..', 'knowledge.db');
const PRODUCTION_FLAG = join(process.env.HOME, '.claude/hooks/.song-production-active');

let db;
try {
  db = new Database(DB_PATH, { readonly: true });
  sqliteVec.load(db);
} catch {
  process.stdout.write('[POST-COMPACT] Knowledge graph DB not available. Continue with caution.');
  process.exit(0);
}

try {
  let output = '<post-compact-knowledge>\n';

  // Always inject: core knowledge — high-trust principles PLUS anything that has
  // been consolidated to level 4 (durability is independent of trust, so a
  // heavily-reinforced inference deserves the same re-injection as a principle).
  const corePrinciples = db.prepare(`
    SELECT name, content, quote, trust, memory_level
    FROM nodes
    WHERE valid_until IS NULL
      AND (trust = 'principle' OR memory_level >= 4)
    ORDER BY memory_level DESC, access_count DESC
    LIMIT 10
  `).all();

  if (corePrinciples.length > 0) {
    output += '核心知識（高信任原則／已固化為 L4）：\n';
    for (const p of corePrinciples) {
      const tag = (p.memory_level || 1) >= 4 && p.trust !== 'principle' ? ` [L${p.memory_level}]` : '';
      output += `- ${p.name}${tag}: ${p.content}\n`;
      if (p.quote) output += `  原話: "${p.quote}"\n`;
    }
  }

  // If in production mode, inject recent episodes
  if (existsSync(PRODUCTION_FLAG)) {
    output += '\n[做歌模式啟用中]\n';

    const recentEpisodes = db.prepare(`
      SELECT type, summary, outcome
      FROM episodes
      ORDER BY created_at DESC
      LIMIT 3
    `).all();

    if (recentEpisodes.length > 0) {
      output += '最近經驗：\n';
      for (const e of recentEpisodes) {
        output += `- [${e.type}] ${e.summary}`;
        if (e.outcome) output += ` → ${e.outcome}`;
        output += '\n';
      }
    }
  }

  // Agent reminder
  output += '\n記憶使用提醒：操作前先 search_memory，不確定就 recall_experience。\n';
  output += '</post-compact-knowledge>';

  process.stdout.write(output);
} catch (e) {
  process.stdout.write(`[POST-COMPACT] Error reading knowledge: ${e.message}`);
} finally {
  db.close();
}
