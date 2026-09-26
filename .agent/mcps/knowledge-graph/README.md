# Knowledge Graph MCP Server

简体中文 | [English](README.en.md)

AI agent 的长期记忆系统。通过师徒制教学或专业实践，让 agent 累积领域知识、自动回忆、从学徒逐步成长为独立专家。

适用于任何需要**持续学习 + 知识演化**的场景：软件开发、音乐制作、设计、医疗诊断、法律分析等。只要有「专家教学 → 学生实践 → 逐步内化」的知识传递模式，这套系统都能用。

## 为什么需要这个

Claude 每次对话从零开始。在专业知识的学徒制教学中：

- **专家教的会忘** — context compaction 后关键教训消失，同样的错重复犯
- **AI 会发明术语** — 没有 ground truth，从单次示范过度推论成永久规则
- **知识不会演化** — 新教学跟旧知识矛盾时无法取代
- **搜索靠路径** — 换个说法就找不到相关知识
- **永远是学生** — 没有机制让 AI 自己的发现成长为持久知识

## 安装

```bash
cd mcp/knowledge-graph
npm install
```

首次启动会自动下载 Qwen3-Embedding-0.6B ONNX 模型（~560MB，只下载一次）。

### MCP 设置

在项目 `.mcp.json`：

```json
{
  "mcpServers": {
    "knowledge-graph": {
      "command": "node",
      "args": ["/absolute/path/to/mcp/knowledge-graph/main.js"]
    }
  }
}
```

### Hooks 设置

在 `~/.claude/settings.json` 的 `hooks` 中加入（见下方 [Hooks 章节](#hooks自动化) 的完整设置）。

### 导入既有知识（可选）

```bash
node scripts/import-skills.js <skills-directory>   # 将 markdown 导入为 KG 节点
node scripts/backfill-embeddings.js                 # 补向量索引
node scripts/backfill-decay.js                      # 补 stability + memory_level
```

---

## 核心设计

### 为什么自建

研究了 25+ 个 Claude Code 记忆系统（Claude-Recall、A-MEM、Mnemon、Graphiti、memsearch 等），没有一个同时满足：

| 需求 | 现有方案的问题 | 本系统的做法 |
|------|-------------|-------------|
| 领域专属边类型 | 只有通用边 | 10 种语义边（must_precede, aligns_to 等）|
| 信任等级区分 | 不区分知识来源 | principle（专家教的）> pattern（观察的）> inference（推测的）|
| Anti-fabrication | 无防护 | principle 必须附带专家原话 quote |
| 基本功 vs 创意空间 | 一视同仁 | fundamental 永不衰退，creative 可挑战 |
| 记忆衰退 + 成长路径 | 有衰退但无成长 | FSRS desirable difficulty + Benna-Fusi 4 level |
| 自动化 | 依赖用户操作 | 5 hooks 覆盖完整生命周期 |

### 借鉴来源

| 来源 | 借鉴了什么 |
|------|-----------|
| **Claude-Recall** | Hook 架构（search enforcer, correction detector）|
| **A-MEM** | 边的数据模型（relation_type + reasoning + weight）|
| **CortexGraph** | 两阶段衰退（快衰退 + 慢长尾）|
| **FSRS (Anki)** | Desirable difficulty（快忘的记忆被想起 → 更大稳定性增强）|
| **Benna-Fusi** | 记忆级联（4 level 耐久度，独立于知识来源）|
| **Stanford Generative Agents** | 三信号检索（recency + importance + relevance）|
| **Graphiti/Zep** | 时间感知（valid_from / valid_until）|

---

## 三层架构

```
┌──────────────────────────────────────────────┐
│ Layer 1: 人格层（CLAUDE.md）                   │
│ Agent 身份 + 行为准则                          │
│ → 每个 turn 都加载，保证行为一致               │
├──────────────────────────────────────────────┤
│ Layer 2: 记忆层（Knowledge Graph MCP）         │
│ SQLite + sqlite-vec + FTS5                    │
│ 13 MCP 工具 + 三合一混合搜索                    │
│ → 按需调用，不占 context                       │
├──────────────────────────────────────────────┤
│ Layer 3: 自动化层（Hooks）                     │
│ 5 hooks 覆盖完整生命周期                       │
│ → 专家不需要提醒，全自动                        │
└──────────────────────────────────────────────┘
```

---

## 记忆衰退与成长系统

### 设计哲学

```
学徒阶段：专家说的权重最高 → 学基础
成长阶段：自己的观察被验证 → 形成判断力
专家阶段：自己的推论经实践确认 → 有自己的见解
```

**trust 是来源标记（谁说的），不是永久等级。** AI 自己验证过的知识也能持久。

### 衰退：CortexGraph 两阶段 × FSRS Stability

```
R = W_fast × e^(-λ_fast × t) + W_slow × e^(-λ_slow × t)
```

- **快衰退**（半衰期 = S 天）：「刚学的容易忘」
- **慢衰退**（半衰期 = S×10 天）：「存活下来的记得很久」
- **S（stability）**：由 trust + category 决定初始值，被访问后通过 FSRS 增长

| 知识类型 | 初始 S | 快半衰期 | 慢半衰期 |
|---------|:------:|:-------:|:-------:|
| 基本功（fundamental） | 365 天 | — | — |
| 专家的创意选择 | 30 天 | 30天 | 300天 |
| 观察到的模式 | 7 天 | 7天 | 70天 |
| AI 推测 | 3 天 | 3天 | 30天 |

### 强化：FSRS Desirable Difficulty

```
stabilityGain = e^(1 - R) × gradeMultiplier
```

核心洞察：**快要忘掉的记忆被想起来时，稳定性增强更大。**

- R = 0.9（刚查过）→ 1.11× 增长
- R = 0.3（快忘了）→ 2.01× 增长

### 成长路径：Benna-Fusi 记忆级联

trust（来源标记）不变，memory_level（耐久度）独立成长：

| Level | 条件 | 自动过期? |
|:-----:|------|:--------:|
| 1 新学 | 默认 | ✅ R < 0.02 |
| 2 验证中 | 跨 3 sessions 访问 | ✅ R < 0.02 |
| 3 巩固 | 14天 + access ≥ 5 | ❌ 永不 |
| 4 核心 | fundamental 或 access ≥ 50 | ❌ 永不 |

### 基本功 vs 创意空间

| 类型 | metadata.category | 行为 |
|------|:-----------------:|------|
| 基本功 | `"fundamental"` | R = 1.0 永不衰退。有对错，违反就是错 |
| 创意空间 | `"creative"` | 可衰退、可被挑战。没对错，只有合适与否 |

---

## 搜索系统

### 三合一混合搜索

```
score = 0.4 × vector + 0.2 × keyword + 0.3 × graph + memoryScore
```

| 层 | 机制 | 擅长 |
|---|------|------|
| Vector | sqlite-vec cosine KNN (Qwen3 1024d) | 换了说法但意思一样 |
| Keyword | FTS5 BM25 (unicode61) | 精确匹配多语言 |
| Graph | Recursive CTE 沿边展开 1 跳 | 找因果关联 |
| memoryScore | R × 0.1 + levelBonus | 越常用越重要 |

### Embedding 设计

- **模型**：Qwen3-Embedding-0.6B（ONNX 量化，~560MB）
- **本地运行**：零 API 依赖、离线可用
- **为什么 Qwen3**：MTEB 多语排行第一、C-MTEB 中文第一

---

## Anti-Fabrication（防虚构）

| 规则 | 机制 |
|------|------|
| principle 必须有 quote | 没给专家原话 → 拒绝存入 |
| inference 不能建因果边 | must_precede / reason_for 拒绝 inference 节点 |
| trust 不自动升级 | inference 不会变 principle（需要专家确认 + quote）|
| level 独立于 trust | inference 可巩固到 level 4 但仍标记为「AI 的想法」|

---

## 工具一览（13 个）

### 知识管理
| 工具 | 用途 |
|------|------|
| `store_knowledge` | 存知识节点。自动 embedding/FTS + 建议连边 + 初始化衰退参数 |
| `connect_knowledge` | 建因果边。含 anti-fabrication 验证 |
| `update_knowledge` | 原地更新节点。保留 ID 和所有边，自动更新索引 |
| `forget_knowledge` | 标记过时。自动 expire 边 + 清索引 |

### 搜索
| 工具 | 用途 |
|------|------|
| `search_memory` | 混合搜索（vector + keyword + graph + memoryScore）|
| `get_knowledge` | 按 ID 取完整详情（内容 + 1-hop 边）|
| `traverse_graph` | 沿因果边遍历（支持方向/深度/边类型过滤）|
| `list_knowledge` | 按条件列出（trust/type/element/source 筛选，时间/访问/strength 排序）|

### 经验
| 工具 | 用途 |
|------|------|
| `record_experience` | 记录工作流轨迹（步骤 + 决策 + 结果）|
| `recall_experience` | 依情境找类似经验 |

### 维护
| 工具 | 用途 |
|------|------|
| `maintain_graph` | Memory Enzyme — prune / merge / validate / orphan |
| `crystallize_skill` | 检查 KG 与 skill 文件的同步状态 |
| `memory_stats` | 图谱统计 |

---

## Hooks（自动化）

### 生命周期覆盖

```
[新 Session]
  └─ session-start → 自动修复 + 记忆衰退 + consolidation 检测 + 边 review

[用户送消息]
  └─ auto-recall → 查 KG → 注入相关知识
                 → correction detector → 检测纠正

[AI 准备操作]
  └─ search-enforcer → 特定模式下挡住没查记忆的操作

[AI 回复完]
  └─ auto-capture → 分析学习信号 → 挡住 → 主 Claude 用 MCP 存

[Context 压缩]
  └─ post-compact → 重注入核心知识
```

### settings.json 设置示例

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup",
        "hooks": [{
          "type": "command",
          "command": "node /path/to/hooks/session-start.js",
          "timeout": 10
        }]
      },
      {
        "matcher": "compact",
        "hooks": [{
          "type": "command",
          "command": "node /path/to/hooks/post-compact.js",
          "timeout": 10
        }]
      }
    ],
    "UserPromptSubmit": [{
      "hooks": [{
        "type": "command",
        "command": "node /path/to/hooks/auto-recall.js",
        "timeout": 10
      }]
    }],
    "Stop": [{
      "hooks": [{
        "type": "agent",
        "model": "claude-opus-4-6",
        "prompt": "Auto-Capture prompt（见 settings.json 完整内容）",
        "timeout": 60
      }]
    }],
    "PreToolUse": [{
      "hooks": [{
        "type": "command",
        "command": "node /path/to/hooks/search-enforcer.js",
        "timeout": 5
      }]
    }]
  }
}
```

### Auto-Capture 设计

Agent hook 不能呼叫 MCP 工具。解法：agent 分析对话 → 输出 `<auto-capture>` 指令 → 挡住主 Claude → 主 Claude 用 MCP 存知识 → 再次触发 Stop → `stop_hook_active=true` → 放行。

体感：主 AI 突然「想到」要存知识，自然地用 MCP 工具存入。

---

## Session-Start 自动维护

每次新 session 执行。**默认只报告** —— 破坏性步骤（expire / prune / 索引清理）
仅在设置 `KG_AUTO_MAINTENANCE=1` 时才实际执行，因此启动 session 绝不会静默销毁知识。

1. 修复 dangling edges
2. 清理 expired 节点的残留索引
3. 报告孤儿节点
4. 记忆衰退 — R < 0.02 且 level < 3 → expire
5. 衰退报告 — 显示 R < 0.3 的节点
6. Consolidation 检测 — vector similarity < 0.25 的节点对
7. 弱边清理 — weight < 0.3 → expire
8. 最近边 review — 24 小时内新增的边

> 其中第 1、2、4、7 步仅在 `KG_AUTO_MAINTENANCE=1` 时才会写库，否则只报告「将会」发生什么。

---

## 数据模型

### 节点

| 栏位 | 说明 |
|------|------|
| type | rule / procedure / observation / insight / core / preference |
| trust | principle（专家教的）/ pattern（观察的）/ inference（推测的）|
| stability | FSRS S（天数），控制衰退速度 |
| memory_level | Benna-Fusi level 1-4，控制耐久度 |
| metadata.category | fundamental（基本功）/ creative（创意空间）|
| source | session ID / "teacher" / "auto-capture" |
| quote | 专家原话（principle 必填）|

### 边

| 边 | 意义 |
|----|------|
| `must_precede` | A 必须在 B 之前 |
| `requires_reading` | 操作 A 前要读 B |
| `refines` | A 细化 B |
| `contradicts` | A 跟 B 矛盾 |
| `reason_for` | A 是做 B 的原因 |
| `causes` / `implies` / `aligns_to` / `tends_to` / `observed_in` | 其他语义关联 |

---

## 安全性

| 风险 | 防护 |
|------|------|
| SQL injection | 参数化查询 + 白名单验证 |
| FTS5 特殊字符 | sanitize + 双引号包装 |
| store 非 atomic | node + FTS 包进 transaction |
| 无效 ID timeout | 移入 try/except 回传明确错误 |
| Stability 溢出 | cap 365 天 |
| Level 单 session 灌水 | metadata.sessions 追踪跨 session |
| skill 文件路径逃逸 | `crystallize_skill` 用 realpath 解析路径，拒绝超出 `KG_SKILL_ROOT`（默认 cwd）的文件；单文件上限 1 MiB |
| metadata 损坏 | 所有 JSON 列统一经 `lib/json.js` 解析 —— 单行坏数据不会中断搜索／遍历 |
| 并发写入 | 每条连接（server / hooks / scripts）都设置 `busy_timeout=5000` |
| 静默数据丢失 | session-start 维护默认只报告，除非设置 `KG_AUTO_MAINTENANCE=1` |

---

## 搭配使用

### 推荐的 Skill 结构

Knowledge Graph 存储「知识」，Skill 文件定义「行为」。两者互补：

```
skills/
├── <domain>/                    # 领域知识
│   ├── principles.md            # 核心原则
│   ├── elements/                # 各元素的操作流程
│   │   ├── <element>/
│   │   │   └── workflow.md      # 可执行的工具操作步骤
│   │   └── checklist.md         # 元素列表 + 依赖图
│   └── evaluation/              # 质量评估标准
├── specialty/                   # 专业分支覆写
├── tools/                       # 工具使用知识
│   ├── gotchas/                 # 危险操作 / 陷阱
│   └── batch/                   # 批量工具对照
└── preflight.md                 # 做事前必读列表
```

**关键**：skill 文件必须「可执行」— agent 读完后能直接操作，不需要猜。

### 搭配其他 MCP Server

Knowledge Graph 是记忆层，搭配**领域操作 MCP** 来执行工作：

| 组合 | Knowledge Graph 负责 | 领域 MCP 负责 |
|------|---------------------|--------------|
| 程序开发 | 架构决策、code review 经验、bug 模式 | IDE / Git / CI 操作 |
| 设计 | 设计原则、品牌规范、用户反馈 | Figma / 设计工具操作 |
| 数据分析 | 分析方法论、领域知识、过去经验 | DB / BI 工具操作 |
| 任何专业领域 | 领域知识、工作流经验、专家教学 | 对应的操作工具 |

---

## 参考资料

### 学术论文
| 论文 | 贡献 |
|------|------|
| [FSRS Algorithm](https://github.com/open-spaced-repetition/fsrs4anki/wiki/The-Algorithm) | Power-law forgetting curve + desirable difficulty |
| [MemoryBank (AAAI 2024)](https://arxiv.org/abs/2305.10250) | LLM 长期记忆 + Ebbinghaus forgetting curve |
| [Benna & Fusi (Nature Neuroscience 2016)](https://www.nature.com/articles/nn.4401) | 突触级联模型 |
| [Generative Agents (Stanford, UIST 2023)](https://dl.acm.org/doi/fullHtml/10.1145/3586183.3606763) | 三信号检索 + Reflection 机制 |
| [Zep: Temporal KG Architecture](https://arxiv.org/abs/2501.13956) | 双时间模型 |
| [Synaptic Memory Consolidation](https://arxiv.org/html/2405.16922v1) | EWC + Synaptic Intelligence |
| [Mem0: AI Agent Memory](https://arxiv.org/html/2504.19413v1) | Production-ready agent memory |

### 开源实现
| 项目 | 借鉴 |
|------|------|
| [CortexGraph](https://github.com/prefrontal-systems/cortexgraph) | 两阶段衰退、consolidation、sub-linear frequency |
| [Claude-Recall](https://github.com/anthropics/claude-recall) | search enforcer、correction detector |
| [A-MEM](https://github.com/a-mem/a-mem) | typed edges、memory enzyme |
| [Mnemon](https://github.com/mnemon-dev/mnemon) | 4 图架构、importance decay |
| [memsearch (Zilliz)](https://github.com/zilliztech/memsearch) | Hybrid dense+BM25+RRF |
| [second-brain (jugaad-lab)](https://github.com/jugaad-lab/second-brain) | Category-weighted decay |
| [Graphiti (Zep)](https://github.com/getzep/graphiti) | Temporal knowledge graph |

### 认知科学
| 概念 | 应用 |
|------|------|
| [Ebbinghaus Forgetting Curve](https://en.wikipedia.org/wiki/Forgetting_curve) | 记忆衰退基础模型 |
| [SM-2 Algorithm](https://super-memory.com/english/ol/sm2.htm) | 间隔重复经典算法 |
| [Desirable Difficulty](https://en.wikipedia.org/wiki/Desirable_difficulty) | FSRS 的核心理论基础 |

---

## 致谢

本系统融合了多个开源社群和学术研究的智慧。特别感谢：

- **[open-spaced-repetition](https://github.com/open-spaced-repetition)** 的 FSRS 算法
- **[prefrontal-systems](https://github.com/prefrontal-systems)** 的 CortexGraph
- **[Anthropic](https://github.com/anthropics)** 的 Claude-Recall
- **Stanford HCI Group** 的 Generative Agents 论文
- **Benna & Fusi** 的突触级联模型
- **[Zilliz](https://github.com/zilliztech)**、**[jugaad-lab](https://github.com/jugaad-lab)**、**[Zep](https://github.com/getzep)** 等开源项目

---

## 部署

### 包含在 repo 中
- 所有 `lib/`、`tools/`、`hooks/`、`scripts/` 程序码
- Hooks 设置示例

### 用户自己产生
- `knowledge.db` — 首次启动自动建立
- Qwen3 ONNX 模型 — 首次 embed 时自动下载
- `node_modules/` — `npm install`

### 首次使用
1. `npm install`
2. 设置 `.mcp.json` + `~/.claude/settings.json` hooks
3. 启动 Claude Code → MCP 自动启动 → 模型自动下载
4. 开始对话 → hooks 自动运作 → 知识自动累积

## License

MIT
