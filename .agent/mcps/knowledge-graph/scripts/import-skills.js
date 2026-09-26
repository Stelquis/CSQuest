#!/usr/bin/env node

/**
 * Import markdown skill files into the Knowledge Graph.
 *
 * Usage: node scripts/import-skills.js <skills-directory>
 *
 * Walks the directory tree, reads .md files, creates KG nodes + edges
 * based on content analysis (quotes, dependencies, structure).
 */

import { readFileSync, readdirSync, statSync } from 'fs';
import { join, relative, basename, extname } from 'path';
import { randomUUID } from 'node:crypto';
import { getDb, closeDb } from '../lib/db.js';
import { embed, isReady } from '../lib/embeddings.js';

const SKILLS_DIR = process.argv[2];
if (!SKILLS_DIR) {
  console.error('Usage: node scripts/import-skills.js <skills-directory>');
  console.error('Example: node scripts/import-skills.js ./skills');
  process.exit(1);
}

const SOURCE = 'skills-import';

function detectType(filePath, content) {
  const name = basename(filePath, '.md');
  if (name === 'workflow') return 'procedure';
  if (name === 'principles' || name === 'checklist') return 'rule';
  if (filePath.includes('aesthetics') || filePath.includes('preference')) return 'preference';
  if (filePath.includes('technique') || filePath.includes('pattern')) return 'procedure';
  if (/必須|禁止|不能|永遠|must|never|always/i.test(content)) return 'rule';
  return 'observation';
}

function extractQuotes(content) {
  const quotes = [];
  const patterns = [/「([^」]+)」/g, /quote:\s*"([^"]+)"/g];
  for (const p of patterns) {
    let match;
    while ((match = p.exec(content)) !== null) quotes.push(match[1].trim());
  }
  return quotes;
}

function extractDependencies(content) {
  const deps = [];
  const section = content.match(/##\s*(Related|Dependencies|相關)[\s\S]*?(?=\n##\s|$)/i);
  if (section) {
    const matches = section[0].matchAll(/`([^`]+\.md)`/g);
    for (const m of matches) deps.push(m[1]);
  }
  return deps;
}

function findMarkdownFiles(dir) {
  const files = [];
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    try {
      const stat = statSync(full);
      if (stat.isDirectory()) files.push(...findMarkdownFiles(full));
      else if (extname(entry) === '.md' && stat.isFile()) files.push(full);
    } catch { /* skip broken symlinks */ }
  }
  return files;
}

async function main() {
  const db = getDb();
  const now = new Date().toISOString();
  const files = findMarkdownFiles(SKILLS_DIR);

  console.log(`Found ${files.length} markdown files in ${SKILLS_DIR}`);

  const nodesByPath = new Map();
  let nodeCount = 0, edgeCount = 0, embeddingCount = 0;

  const insertNode = db.prepare(`
    INSERT INTO nodes (id, type, trust, name, content, source, quote, metadata, valid_from, created_at, updated_at)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);
  const insertFts = db.prepare('INSERT INTO fts_nodes (node_id, name, content) VALUES (?, ?, ?)');
  const findExisting = db.prepare(`
    SELECT id FROM nodes
    WHERE source = ? AND json_extract(metadata, '$.filePath') = ? AND valid_until IS NULL
  `);

  // Phase 1: Create nodes
  let skipped = 0;
  for (const filePath of files) {
    const content = readFileSync(filePath, 'utf-8');
    const rel = relative(SKILLS_DIR, filePath);

    // Idempotency: re-running the import must not duplicate nodes
    const existing = findExisting.get(SOURCE, rel);
    if (existing) {
      nodesByPath.set(rel, existing.id);
      skipped++;
      continue;
    }

    const type = detectType(filePath, content);
    const quotes = extractQuotes(content);
    const trust = quotes.length > 0 ? 'principle' : 'pattern';
    const name = rel.replace('.md', '').split('/').join(' > ');
    // Strip YAML frontmatter but keep the FULL body: the FTS index and the vector
    // index are both built from this text, so truncating here would let keyword
    // search match text that the stored node does not actually contain.
    const body = content.replace(/^---[\s\S]*?---\n/, '').trim();

    const id = randomUUID();
    insertNode.run(id, type, trust, name, body, SOURCE, quotes[0] || null,
      JSON.stringify({ filePath: rel }), now, now, now);
    insertFts.run(id, name, body);
    nodesByPath.set(rel, id);
    nodeCount++;

    if (isReady()) {
      try {
        const embedding = await embed(`${name} ${body}`);
        db.prepare('INSERT INTO vec_nodes (node_id, embedding) VALUES (?, ?)').run(id, embedding);
        embeddingCount++;
      } catch { /* skip */ }
    }
  }

  console.log(`Created ${nodeCount} nodes (${embeddingCount} with embeddings)`);
  if (skipped > 0) console.log(`Skipped ${skipped} already-imported files`);

  // Phase 2: Create edges from ## Dependencies / ## 相關元素 sections
  const insertEdge = db.prepare(`
    INSERT INTO edges (id, source_id, target_id, relation_type, reasoning, weight, source_session, valid_from, created_at)
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
  `);

  for (const filePath of files) {
    const content = readFileSync(filePath, 'utf-8');
    const rel = relative(SKILLS_DIR, filePath);
    const sourceId = nodesByPath.get(rel);
    if (!sourceId) continue;

    for (const dep of extractDependencies(content)) {
      const depRel = dep.startsWith('skills/') ? dep.substring(7) : dep;
      const targetId = nodesByPath.get(depRel);
      if (targetId && targetId !== sourceId) {
        insertEdge.run(randomUUID(), sourceId, targetId, 'requires_reading',
          `${basename(rel)} depends on ${basename(depRel)}`, 0.8, SOURCE, now, now);
        edgeCount++;
      }
    }
  }

  console.log(`Created ${edgeCount} edges`);

  const stats = {
    nodes: db.prepare('SELECT COUNT(*) as c FROM nodes WHERE valid_until IS NULL').get().c,
    edges: db.prepare('SELECT COUNT(*) as c FROM edges WHERE valid_until IS NULL').get().c,
  };
  console.log(`Final: ${stats.nodes} nodes, ${stats.edges} edges`);
  closeDb();
}

main().catch(console.error);
