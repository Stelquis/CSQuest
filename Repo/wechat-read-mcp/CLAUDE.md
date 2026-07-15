# Weixin MCP Server (weixin-mcp-rs)

微信公众号文章阅读器 — Rust 实现的 MCP (Model Context Protocol) 服务器。

## 功能

输入一个微信公众号文章 URL（`https://mp.weixin.qq.com/s/xxx`），返回：

- **title** — 文章标题
- **author** — 作者
- **publish_time** — 发布时间（部分文章不可用，因 JS 动态渲染）
- **content** — 纯文本正文
- **content_markdown** — Markdown 格式正文（保留标题/粗体/列表/引用/图片）
- **images** — 图片 URL 列表

## 使用方式

### 作为 MCP 服务器启动

```bash
./target/release/weixin-mcp-rs
```

通过 stdio 传输层与 MCP 客户端（如 Claude Desktop）通信。

### 测试

```bash
python3 test_mcp.py
```

## 架构

```
src/
├── main.rs      — 入口：初始化日志，启动 MCP 服务
├── server.rs    — MCP 工具注册（read_weixin_article）
├── scraper.rs   — HTTP 请求获取文章 HTML（reqwest）
├── parser.rs    — HTML → 结构化数据（Markdown + 图片提取）
└── error.rs     — 统一错误类型
```

## 技术栈

| 依赖 | 用途 |
|------|------|
| `rmcp` | Anthropic 官方 Rust MCP SDK |
| `reqwest` | HTTP 客户端（不带浏览器，轻量可靠） |
| `scraper` | HTML 解析 + CSS 选择器 |
| `regex` | 文本清理 |
| `tokio` | 异步运行时 |
| `serde` / `schemars` | 序列化 + JSON Schema |

## 改进历程

从原版 `Wechat-Read-MCP-in-Rust`（Headless Chrome + 纯文本）优化而来：

| 改动 | 说明 |
|------|------|
| `chromiumoxide` → `reqwest` | 去掉 Chrome 依赖，二进制从 200MB 降至 20MB，避免反爬拦截 |
| 纯文本 → Markdown | 递归 DOM 遍历转换，保留标题/列表/引用/粗体/图片 |
| 图片 URL 提取 | 提取 `<img>` 的 `data-src`/`src`，过滤 base64 占位 |
| 多选择器兜底 | 标题/作者/时间/正文各配 2-3 个 CSS 选择器 |
| 标题反补 | 从 Markdown 第一个 `#` 标题反补完整标题 |
| 错误类型简化 | 去掉 Chrome 相关错误 |

## 构建

```bash
cargo build --release
```

需要 Rust 工具链（`rustup` 安装）和 OpenSSL 开发库（`libssl-dev`）。
