#!/usr/bin/env node

/**
 * Session Start hook (SessionStart, matcher: startup)
 * 1. Auto-maintenance: fix dangling edges, report orphans
 * 2. Injects agent persona + recent learning summary from knowledge graph
 */

import Database from 'better-sqlite3';
import * as sqliteVec from 'sqlite-vec';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import { retrievability } from '../lib/decay.js';
import { parseMetadata } from '../lib/json.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);
const DB_PATH = join(__dirname, '..', 'knowledge.db');

// Destructive maintenance (expire / prune / cleanup) is OPT-IN.
// Default is report-only so a session start can never silently destroy knowledge.
const APPLY = /^(1|true|on|yes)$/i.test(process.env.KG_AUTO_MAINTENANCE || '');

// Agent persona is in CLAUDE.md (always loaded by Claude Code), not duplicated here.

let db;
try {
  db = new Database(DB_PATH);  // writable for auto-maintenance
  sqliteVec.load(db);
  db.pragma('journal_mode = WAL');
  db.pragma('busy_timeout = 5000'); // the MCP server may hold the write lock
} catch {
  // DB not ready, persona is in CLAUDE.md
  process.exit(0);
}

try {
  // === Phase 1: Auto-maintenance (silent, fast) ===
  const now = new Date().toISOString();
  let maintenanceReport = '';

  // 1a. Dangling edges (pointing to expired or deleted nodes)
  const DANGLING_WHERE = `
    valid_until IS NULL
      AND (
        source_id NOT IN (SELECT id FROM nodes WHERE valid_until IS NULL)
        OR target_id NOT IN (SELECT id FROM nodes WHERE valid_until IS NULL)
      )`;
  const danglingCount = db.prepare(`SELECT COUNT(*) as c FROM edges WHERE ${DANGLING_WHERE}`).get().c;

  if (danglingCount > 0) {
    if (APPLY) {
      db.prepare(`UPDATE edges SET valid_until = ? WHERE ${DANGLING_WHERE}`).run(now);
      maintenanceReport += `⚠️ 自動修復：${danglingCount} 條 dangling edges 已 expire\n`;
    } else {
      maintenanceReport += `⚠️ 發現 ${danglingCount} 條 dangling edges（僅報告，未處理）\n`;
    }
  }

  // 1b. Orphaned FTS entries (FTS pointing to expired nodes)
  const ftsOrphanCount = db.prepare(`
    SELECT COUNT(*) as c FROM fts_nodes
    WHERE node_id IN (SELECT id FROM nodes WHERE valid_until IS NOT NULL)
  `).get().c;

  if (ftsOrphanCount > 0) {
    if (APPLY) {
      db.prepare(`
        DELETE FROM fts_nodes
        WHERE node_id IN (SELECT id FROM nodes WHERE valid_until IS NOT NULL)
      `).run();
      maintenanceReport += `🧹 ${ftsOrphanCount} 條 FTS 殘留索引已清除\n`;
    } else {
      maintenanceReport += `🧹 發現 ${ftsOrphanCount} 條 FTS 殘留索引（僅報告）\n`;
    }
  }

  // 1c. Orphaned vec entries (vec pointing to expired nodes)
  try {
    const vecOrphanCount = db.prepare(`
      SELECT COUNT(*) as c FROM vec_nodes
      WHERE node_id IN (SELECT id FROM nodes WHERE valid_until IS NOT NULL)
    `).get().c;
    if (vecOrphanCount > 0) {
      if (APPLY) {
        db.prepare(`
          DELETE FROM vec_nodes
          WHERE node_id IN (SELECT id FROM nodes WHERE valid_until IS NOT NULL)
        `).run();
        maintenanceReport += `🧹 ${vecOrphanCount} 條向量殘留索引已清除\n`;
      } else {
        maintenanceReport += `🧹 發現 ${vecOrphanCount} 條向量殘留索引（僅報告）\n`;
      }
    }
  } catch { /* vec table might not support subquery delete */ }

  // 1d. Count orphan nodes (no edges) — report but don't auto-delete
  const orphanCount = db.prepare(`
    SELECT COUNT(*) as c FROM nodes n
    WHERE n.valid_until IS NULL
      AND NOT EXISTS (
        SELECT 1 FROM edges e
        WHERE (e.source_id = n.id OR e.target_id = n.id) AND e.valid_until IS NULL
      )
  `).get().c;

  if (orphanCount > 5) {
    maintenanceReport += `⚠️ ${orphanCount} 個孤兒節點（無邊），考慮用 maintain_graph("orphan") 檢查\n`;
  }

  // 1e. Memory decay — retrievability-based expire (not hardcoded 90 days)
  const activeNodes = db.prepare(`
    SELECT id, name, trust, stability, memory_level, access_count, last_accessed, created_at, metadata
    FROM nodes WHERE valid_until IS NULL
  `).all();

  let decayExpired = 0;
  const decaying = [];
  for (const node of activeNodes) {
    const meta = parseMetadata(node.metadata);
    const level = node.memory_level || 1;

    // Level 3 (consolidated) and level 4 (core) never auto-expire.
    if (level >= 3) continue;

    const R = retrievability(node);

    if (R < 0.02) {
      // Check no dependents
      const deps = db.prepare('SELECT COUNT(*) as c FROM edges WHERE target_id = ? AND valid_until IS NULL').get(node.id).c;
      if (deps === 0) {
        if (APPLY) {
          db.prepare('UPDATE nodes SET valid_until = ?, updated_at = ? WHERE id = ?').run(now, now, node.id);
          try { db.prepare('DELETE FROM fts_nodes WHERE node_id = ?').run(node.id); } catch {}
          try { db.prepare('DELETE FROM vec_nodes WHERE node_id = ?').run(node.id); } catch {}
        }
        decayExpired++;
      }
    } else if (R < 0.3 && node.trust !== 'principle') {
      decaying.push({ name: node.name, trust: node.trust, R: R.toFixed(2), level });
    }
  }

  if (decayExpired > 0) {
    maintenanceReport += APPLY
      ? `🧹 記憶衰退：${decayExpired} 個節點已 expire（R < 0.02, level < 3）\n`
      : `🧹 記憶衰退：${decayExpired} 個節點符合 expire 條件（僅報告，未處理）\n`;
  }
  if (decaying.length > 0) {
    maintenanceReport += `📉 衰退中的節點（R < 0.3）：\n`;
    for (const d of decaying.slice(0, 5)) {
      maintenanceReport += `  [${d.trust} L${d.level}] R=${d.R} ${d.name}\n`;
    }
    if (decaying.length > 5) maintenanceReport += `  ...還有 ${decaying.length - 5} 個\n`;
  }

  // 1f. Consolidation candidates (vector similarity < 0.3)
  try {
    const seen = new Set();
    const consolidationCandidates = [];
    const sampleNodes = db.prepare('SELECT id FROM nodes n JOIN vec_nodes v ON n.id = v.node_id WHERE n.valid_until IS NULL LIMIT 30').all();

    for (const { id } of sampleNodes) {
      const neighbors = db.prepare(`
        SELECT v2.node_id, v2.distance, n2.name
        FROM vec_nodes v2
        JOIN nodes n2 ON v2.node_id = n2.id
        WHERE v2.embedding MATCH (SELECT embedding FROM vec_nodes WHERE node_id = ?)
          AND k = 3 AND n2.valid_until IS NULL AND v2.node_id != ? AND v2.distance < 0.25
      `).all(id, id);

      for (const n of neighbors) {
        const key = [id, n.node_id].sort().join('|');
        if (seen.has(key)) continue;
        seen.add(key);
        const srcName = db.prepare('SELECT name FROM nodes WHERE id = ?').get(id)?.name;
        consolidationCandidates.push({ a: srcName, b: n.name, dist: n.distance.toFixed(3) });
      }
    }

    if (consolidationCandidates.length > 0) {
      maintenanceReport += `\n🔄 合併候選（語意相似度高）：\n`;
      for (const c of consolidationCandidates.slice(0, 5)) {
        maintenanceReport += `  dist=${c.dist}: "${c.a}" ↔ "${c.b}"\n`;
      }
      if (consolidationCandidates.length > 5) maintenanceReport += `  ...還有 ${consolidationCandidates.length - 5} 對\n`;
    }
  } catch { /* consolidation check failed, non-critical */ }

  // 1g. Weak edge prune (weight < 0.3)
  const weakEdgeCount = db.prepare(
    'SELECT COUNT(*) as c FROM edges WHERE weight < 0.3 AND valid_until IS NULL'
  ).get().c;
  if (weakEdgeCount > 0) {
    if (APPLY) {
      db.prepare('UPDATE edges SET valid_until = ? WHERE weight < 0.3 AND valid_until IS NULL').run(now);
      maintenanceReport += `🧹 ${weakEdgeCount} 條弱邊（weight < 0.3）已 expire\n`;
    } else {
      maintenanceReport += `🧹 發現 ${weakEdgeCount} 條弱邊（weight < 0.3，僅報告）\n`;
    }
  }

  // 1h. Show recently created edges for review (last 24 hours)
  const oneDayAgo = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString();
  const recentEdges = db.prepare(`
    SELECT e.relation_type, n1.name as src, n2.name as tgt, e.reasoning, e.source_session
    FROM edges e
    JOIN nodes n1 ON e.source_id = n1.id
    JOIN nodes n2 ON e.target_id = n2.id
    WHERE e.valid_until IS NULL AND e.created_at > ?
    ORDER BY e.created_at DESC
    LIMIT 10
  `).all(oneDayAgo);

  if (recentEdges.length > 0) {
    maintenanceReport += `\n最近新增的邊（請 review 方向和類型是否正確）：\n`;
    for (const e of recentEdges) {
      maintenanceReport += `  [${e.relation_type}] ${e.src} → ${e.tgt}\n`;
    }
  }

  // === Phase 2: Knowledge status ===
  const sevenDaysAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();

  const recentNodes = db.prepare(`
    SELECT name, content, trust, type, quote
    FROM nodes
    WHERE valid_until IS NULL
      AND created_at > ?
    ORDER BY created_at DESC
    LIMIT 5
  `).all(sevenDaysAgo);

  const recentEpisodes = db.prepare(`
    SELECT type, summary, outcome
    FROM episodes
    WHERE created_at > ?
    ORDER BY created_at DESC
    LIMIT 3
  `).all(sevenDaysAgo);

  const stats = {
    nodes: db.prepare('SELECT COUNT(*) as c FROM nodes WHERE valid_until IS NULL').get().c,
    edges: db.prepare('SELECT COUNT(*) as c FROM edges WHERE valid_until IS NULL').get().c,
    episodes: db.prepare('SELECT COUNT(*) as c FROM episodes').get().c,
  };

  // === Output ===
  let output = `<knowledge-graph-status>\n`;
  output += `知識圖譜：${stats.nodes} 節點 / ${stats.edges} 條邊 / ${stats.episodes} 段經驗\n`;
  output += APPLY
    ? `維護模式：已套用（KG_AUTO_MAINTENANCE=1）\n`
    : `維護模式：僅報告（設 KG_AUTO_MAINTENANCE=1 才會實際清理／expire）\n`;

  if (maintenanceReport) {
    output += `\n${maintenanceReport}`;
  }

  if (recentNodes.length > 0) {
    output += `\n最近學到的：\n`;
    for (const n of recentNodes) {
      output += `- [${n.trust}] ${n.name}: ${n.content.substring(0, 80)}${n.content.length > 80 ? '...' : ''}\n`;
    }
  }

  if (recentEpisodes.length > 0) {
    output += `\n最近經驗：\n`;
    for (const e of recentEpisodes) {
      output += `- [${e.type}] ${e.summary}`;
      if (e.outcome) output += ` → ${e.outcome}`;
      output += '\n';
    }
  }

  output += `</knowledge-graph-status>`;

  process.stdout.write(output);
} catch {
  // Error reading KG, persona is in CLAUDE.md
} finally {
  db.close();
}
