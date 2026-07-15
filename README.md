# ☀️ CSQuest

A multi-language development environment with integrated **408 Postgraduate Entrance Exam** review system, powered by AI agent skills and knowledge graph MCP.

> **Core**: Computer Science 408 (Data Structures, Computer Organization, OS, Computer Networks)

---

## 📦 Project Structure

```
/workspace
├── .agent/                    ← AI agent assets (skills, MCP, commands, rules)
│   ├── mcp/knowledge-graph/   ← Knowledge Graph MCP (Qwen3 Chinese embedding)
│   ├── skills/                ← 6 community skills for 408 review
│   ├── commands/review408.md  ← /review408 unified entry
│   └── rules/                 ← 408-learning-loop methodology & git commit msg
├── .atomcode/                 ← AtomCode config (symlinks pointing to .agent/)
├── .mcp.json                  ← MCP server registration
├── 408/                       ← 408 exam methodology & notes
│   ├── learning-loop-system.md  ← Core methodology v5.5
│   └── README.md                ← Subject overview & progress
├── scripts/                   ← One-click setup scripts
│   └── setup-408.sh           ← Install all skills & MCP
├── BigData/                   ← Big Data notes
├── Blockchain/                ← Blockchain notes
├── Python/                    ← Python exam notes
├── Tools/                     ← Git & other tools
└── docs/                      ← Additional docs
```

---

## 🧠 408 Review System

A complete, battle-tested exam preparation methodology for the **408 Postgraduate Entrance Exam** (Computer Science, 150 pts).

### 6 AI Skills

| Skill | Source | Purpose |
|-------|--------|---------|
| **book-study** | sanyuan0704/sanyuan-skills | Reading coach: Socratic testing, knowledge compilation, spaced repetition |
| **excalidraw** | NousResearch/hermes-agent | Hand-drawn concept structure diagrams |
| **mermaid-diagrams** | softaworks/agent-toolkit | Data flow diagrams (class, sequence, flow, ER, C4, etc.) |
| **quiz-maker** | OneWave-AI/claude-skills | Auto quiz generation & grading (A/B/C classification) |
| **memento-flashcards** | NousResearch/hermes-agent | Spaced repetition flashcard system (local JSON) |
| **baoyu-infographic** | NousResearch/hermes-agent | Infographic generator (21 layouts × 21 styles) |

### Knowledge Graph MCP

| Feature | Detail |
|---------|--------|
| **Engine** | ChenLiangChong/knowledgeGraph |
| **Embedding** | Qwen3-Embedding-0.6B (Chinese #1 on MTEB, 560MB, local ONNX) |
| **Storage** | SQLite + sqlite-vec + FTS5 |
| **Tools** | 12 MCP tools: store, connect, search, traverse, maintain |
| **Hooks** | 6 auto hooks: recall, capture, decay, repair, correct, enforce |
| **Decay** | CortexGraph two-component × FSRS stability (Anki-derived) |
| **Search** | Hybrid: vector + keyword + graph + memoryScore |

### Quick Start

```bash
# One-click setup (installs all skills + MCP)
bash /workspace/scripts/setup-408.sh

# Start the knowledge graph MCP server
cd /workspace/.agent/mcp/knowledge-graph && node main.js

# Then in AtomCode session:
/review408 学习 Cache     → Start learning a topic
/review408 做题 页表       → Practice with quizzes
/review408 缝合 Cache 页表 → Cross-subject stitching
/review408 规划            → Today's study plan
/review408 瓶颈            → Find the bottleneck
```

---

## 🛠️ Development Environment

| Component | Version | Verify |
|-----------|---------|--------|
| ☕ Java | OpenJDK 21 | `java --version` |
| ⚡ C++ | g++-14 (C++20) | `g++ --version` |
| 🔧 C | gcc-14 (C17) | `gcc --version` |
| 🐍 Python | 3.12 + numpy + pandas | `python --version` |
| 📦 Git | (built-in) | `git --version` |
| 🐳 Docker | (built-in) | `docker --version` |
| 💻 VS Code | code-server | - |
| 🟢 Node.js | v22.23.1 | `node --version` |
| 🔵 uvx | 0.11.25 | `uvx --version` |

---

## 📚 Notes

- 🐍 [Python Exam](./Python/HW.md)
- 🌳 [Git Notes](./Tools/Git.md)
- 🏗️ [Blockchain](./Blockchain/)
- 📊 [Big Data](./BigData/)

---

> ☀️ Built for Cloud Native Development & 408 Exam Preparation