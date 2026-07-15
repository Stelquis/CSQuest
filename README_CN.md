# ☀️ CSQuest

多语言开发环境，集成 **408 考研** 复习系统，由 AI agent skill 和知识图谱 MCP 驱动。

> **核心**：计算机 408 统考（数据结构、组成原理、操作系统、计算机网络）

---

## 📦 项目结构

```
/workspace
├── .agent/                    ← AI agent 资产（skill、MCP、命令、规则）
│   ├── mcp/knowledge-graph/   ← 知识图谱 MCP（Qwen3 中文嵌入）
│   ├── skills/                ← 6 个 408 复习社区 skill
│   ├── commands/review408.md  ← /review408 统一入口
│   └── rules/                 ← 408 学习方法论 & git 提交规范
├── .atomcode/                 ← AtomCode 配置（软链接指向 .agent/）
├── .mcp.json                  ← MCP 服务器注册
├── 408/                       ← 408 考试方法论与笔记
│   ├── learning-loop-system.md  ← 核心方法论 v5.5
│   └── README.md                ← 科目概览与进度
├── scripts/                   ← 一键配置脚本
│   └── setup-408.sh           ← 安装所有 skill 和 MCP
├── BigData/                   ← 大数据笔记
├── Blockchain/                ← 区块链笔记
├── Python/                    ← Python 机考笔记
├── Tools/                     ← Git 等工具
└── docs/                      ← 其他文档
```

---

## 🧠 408 复习系统

针对 **408 计算机统考**（150 分）的完整、经过实战检验的备考方法论。

### 6 个 AI Skill

| Skill | 来源 | 用途 |
|-------|------|------|
| **book-study** | sanyuan0704/sanyuan-skills | 阅读教练：苏格拉底测试、知识编译、间隔重复 |
| **excalidraw** | NousResearch/hermes-agent | 手绘风格概念结构图 |
| **mermaid-diagrams** | softaworks/agent-toolkit | 数据流图（类图、时序图、流程图、ER、C4 等） |
| **quiz-maker** | OneWave-AI/claude-skills | 自动出题与批改（A/B/C 三级错题分类） |
| **memento-flashcards** | NousResearch/hermes-agent | 间隔重复闪卡系统（本地 JSON） |
| **baoyu-infographic** | NousResearch/hermes-agent | 信息图生成器（21 种布局 × 21 种风格） |

### 知识图谱 MCP

| 特性 | 详情 |
|------|------|
| **引擎** | ChenLiangChong/knowledgeGraph |
| **嵌入模型** | Qwen3-Embedding-0.6B（中文 MTEB 排名第一，560MB，本地 ONNX） |
| **存储** | SQLite + sqlite-vec + FTS5 |
| **工具** | 12 个 MCP 工具：存储、连接、搜索、遍历、维护 |
| **自动 Hook** | 6 个：召回、捕获、衰减、修复、纠正、强制 |
| **衰减算法** | 双指数 × FSRS 稳定性（源自 Anki） |
| **搜索** | 混合：向量 + 关键词 + 图谱 + 记忆分 |

### 快速开始

```bash
# 一键配置（安装所有 skill + MCP）
bash /workspace/scripts/setup-408.sh

# 启动知识图谱 MCP 服务
cd /workspace/.agent/mcp/knowledge-graph && node main.js

# 然后在 AtomCode 会话中使用：
/review408 学习 Cache     → 开始学习新主题
/review408 做题 页表       → 刷题巩固
/review408 缝合 Cache 页表 → 跨科缝合
/review408 规划            → 今日学习计划
/review408 瓶颈            → 约束理论找短板
```

---

## 🛠️ 开发环境

| 组件 | 版本 | 验证命令 |
|------|------|----------|
| ☕ Java | OpenJDK 21 | `java --version` |
| ⚡ C++ | g++-14 (C++20) | `g++ --version` |
| 🔧 C | gcc-14 (C17) | `gcc --version` |
| 🐍 Python | 3.12 + numpy + pandas | `python --version` |
| 📦 Git | 系统内置 | `git --version` |
| 🐳 Docker | 系统内置 | `docker --version` |
| 💻 VS Code | code-server | - |
| 🟢 Node.js | v22.23.1 | `node --version` |
| 🔵 uvx | 0.11.25 | `uvx --version` |

---

## 📚 笔记导航

- 🐍 [Python 机考](./Python/HW.md)
- 🌳 [Git 笔记](./Tools/Git.md)
- 🏗️ [区块链](./Blockchain/)
- 📊 [大数据](./BigData/)

---

> ☀️ 为云原生开发与 408 考研备考而生