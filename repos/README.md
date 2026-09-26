# 📂 repos

本目录管理 **本地文档资源** 和通过 **git submodule** 引入的第三方仓库。

---

## 📚 目录内容

| 目录 | 类型 | 来源 | 说明 |
|------|------|------|------|
| `UAXE/` | 📁 本地目录 | [uaxe](https://github.com/uaxe) | 极客时间专栏 Markdown 文档（AI-大数据 / 后端-架构 / 计算机基础） |
| `WeRead-MCP/` | 📦 子模块 | [Stelquis/WeRead-MCP](https://github.com/Stelquis/WeRead-MCP) | 基于 Rust 的 MCP 服务器，抓取微信公众号文章 |

---

### 📁 UAXE — 极客时间文档

内部为 `geektime-docs/`（来自 [uaxe/geektime-docs](https://github.com/uaxe/geektime-docs) 稀疏检出，已并入本仓库直接维护）：

| 目录 | md 数量 | 内容示例 |
|------|:-----:|----------|
| `AI-大数据/` | 1353 | AI 大模型、RAG / LangChain、PyTorch、大数据 |
| `后端-架构/` | 3630 | Go / Java / Python、MySQL、Redis、Kafka、分布式 |
| `计算机基础/` | 1094 | 408 初试四科系列 + 编译原理等扩展 |

> 📌 详细说明见 [`UAXE/README.md`](./UAXE/README.md)
### 📦 WeRead-MCP — 微信文章 MCP 阅读器

基于 Rust 的 MCP 服务器，纯 HTTP 抓取微信公众号文章，输出结构化 Markdown。构建：`cargo build --release`，产物在 `target/release/weread-mcp`。

> 📌 详细说明见 [`WeRead-MCP/README.md`](./WeRead-MCP/README.md)

---

## 🚀 子模块操作

```bash
# 首次克隆后初始化
git submodule update --init --recursive

# 更新到远程最新提交（更新后需一并提交指针变更）
git submodule update --remote --recursive
```

## ⚠️ 注意事项

- 🎯 子模块记录的是具体 commit，远程更新后需手动拉取并提交变更。
- 📤 子模块内容修改后，先在子模块内提交推送，再回主仓库提交指针变更。
- 📁 `UAXE/` 为本仓库直接维护的本地文档目录，修改后直接提交即可。
- 🧭 子模块清单以根目录 `.gitmodules` 为准。
