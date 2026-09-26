# 🧭 CSQuest

**408 · Full-Stack · BigData · Algorithm · Blockchain**

个人技术仓库 —— 以「学 → 练 → 沉淀」为主线，由 AI Agent Skill 与知识图谱 MCP 辅助生产与检索。

---

#### 🧠 408 复习系统

面向 408 的系统性复习：不是零散笔记堆叠，而是先搭知识框架、再逐层填充细节。

- **四科覆盖**：数据结构 · 计算机组成原理 · 操作系统 · 计算机网络
- **方法论**：时间分配、四轮复习节奏、错题复盘与真题取舍策略
- **笔记形态**：每科按「考点 → 原理 → 例题 → 易错点」组织，便于冲刺期快速回查

> 📌 详见 [`408/`](./408/)

#### 🧰 全栈技能体系

用一套分层模型收纳工程知识，既能沉淀文章，也能作为能力自检清单。

| 层级   | 内容                                                                  |
| :----- | :-------------------------------------------------------------------- |
| 交付层 | 🎨 前端（HTML5 / CSS）· ⚙️ 后端（Python / C）· 🗄️ 数据（MySQL） |
| 运行层 | 🐳 基础设施（Docker / Linux）                                         |
| 质量层 | 🔀 工程实践（Git）                                                    |
| 治理层 | 系统架构与设计 · 安全工程（跨层就近归档）                            |

> 📌 详见 [`Full-Stack/README.md`](./Full-Stack/README.md)

#### 📊 大数据学习路线图

项目驱动，每天 4-6 小时，项目驱动：每阶段都有可展示的产出，而非只看教程。

- **第 1 周**：Java / Python / SQL / Linux 基础补强
- **第 2-4 周**：Hadoop 生态 → Spark → Flink，打通离线与实时两条链路
- **第 5-6 周**：数据仓库建模与治理，配合项目实战、简历优化与面试准备

> 📌 详见 [`BigData/README.md`](./BigData/README.md)

#### ☕ Algorithm

力扣 [Hot 100](https://leetcode.cn/studyplan/top-100-liked/) 题解笔记，追求「读完能自己写出来」的讲解质量。

- **每题结构**：题目描述 → 思路推导 → 复杂度分析 → 多语言实现
- **代码标准**：完整的 ACM 输入输出程序，可直接复制运行；Java / Python / C++ / C 四语言
- **质量控制**：文档中的每个代码块都会**实际编译运行验证**，覆盖官方示例与边界用例（空树、全负数、溢出等）

> 📌 题解索引与文档规范见 [`LeetCode/README.md`](./LeetCode/README.md)

#### 🔗 区块链课程

课程的三次作业与一个综合项目，作为区块链方向的入门实践记录。

> 📌 详见 [`Blockchain/README.md`](./Blockchain/README.md)

---

#### 🤖 AI Agent 基础设施

仓库的「自动化笔杆子」，负责图表生产与知识检索。

**📊 Skill：`diagram-craft`**

- 用源码描述图表：流程图、时序图、状态图、类图、ER、C4、架构图
- 内置 Mermaid / D2 的渲染兼容性约束，避免写完渲染不出来
- 统一维护在 `.agent/skills/`，由 `.atomcode/skills/` 软链同步

**🕸️ 知识图谱 MCP**

- 本地嵌入模型 Qwen3-Embedding-0.6B（可选 ONNX 推理），无需联网
- SQLite + 向量检索 + 全文检索 + 图谱遍历的混合搜索
- 13 个工具覆盖知识存取、检索遍历、关联与经验记录、图谱维护

```bash
# 1) 初始化 Agent 环境（按所用 CLI 任选其一）
bash /workspace/scripts/init-codebuddy.sh    # 另有 claude / codex / atomcode

# 2) 拉取第三方仓库（git 子模块）
git submodule update --init --recursive

# 3) 启动知识图谱 MCP
cd /workspace/.agent/mcps/knowledge-graph && npm install && node main.js
```

---

#### 📂 其他

- [`repos/`](./repos/)：极客时间笔记（UAXE）· 微信文章阅读器（WeRead-MCP）
- [`docs/`](./docs/)：CNB 配置 · 子模块镜像同步等环境与协作说明

---

#### 📜 License

[MIT](./LICENSE)
