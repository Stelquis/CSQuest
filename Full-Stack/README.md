# 🚀Full-Stack — 全栈工程师技能体系 🧑‍💻

> ✨一套面向全栈工程师的技能维度划分，用于知识沉淀、文章归档与能力自检。📚

---

## 设计原则 🏛️

1. **边界清晰** 🎯：每个维度定位 + 可验证的能力项；能力项即文章归档时的子主题。
2. **四层结构** 🏗️：交付层 / 运行层 / 质量层 / 治理层；治理层（架构与安全）跨层就近归档，避免目录膨胀。

---

## 体系结构 🗺️

```
┌─ 交付层：前端工程 / 后端工程 / 数据工程
├─ 运行层：基础设施工程
├─ 质量层：工程实践
└─ 治理层：系统架构与设计 / 安全工程（跨层，就近归档）
```

### 交付层 🎁

把产品从想法变成可运行的服务：界面、业务逻辑与数据。

| 目录                                              | 中文名   | 定位                       |
| ------------------------------------------------- | -------- | -------------------------- |
| [`FrontendEngineering/`](./FrontendEngineering/) | 前端工程 | 从页面到应用的前端全链路   |
| [`BackendEngineering/`](./BackendEngineering/)   | 后端工程 | 服务端应用的设计与实现     |
| [`DataEngineering/`](./DataEngineering/)         | 数据工程 | 一切数据的存取、加速与流转 |

#### 🎨 FrontendEngineering 前端工程

| 能力项     | 覆盖内容                                         |
| ---------- | ------------------------------------------------ |
| 语言基础   | HTML / CSS / JavaScript / TypeScript             |
| 框架与状态 | React / Vue、组件设计、状态管理（Redux / Pinia） |
| 构建工程化 | Vite / Webpack、包管理、Lint / 格式化、代码分割  |
| 渲染与性能 | 浏览器原理、重排重绘、性能优化、SSR / SSG        |
| 体验       | 响应式、可访问性、动效、移动端适配               |

#### 🛠️ BackendEngineering 后端工程

| 能力项       | 覆盖内容                                |
| ------------ | --------------------------------------- |
| 语言与运行时 | Go / Java / Python / Node、内存模型、GC |
| Web 框架     | 路由 / 中间件 / 依赖注入                |
| API 设计     | REST / GraphQL / gRPC、版本化、OpenAPI  |
| 应用分层     | Controller / Service / DAO、领域驱动    |
| 认证授权     | Session / JWT / OAuth2 / RBAC           |
| 并发模型     | 协程 / 线程池、异步、事件驱动           |
| 服务治理     | 微服务、网关、服务发现、限流熔断        |

#### 📊 DataEngineering 数据工程

| 能力项   | 覆盖内容                                      |
| -------- | --------------------------------------------- |
| 关系型   | MySQL / PostgreSQL、SQL、索引、事务隔离、锁   |
| 数据建模 | 范式 / 反范式、ER 设计、迁移                  |
| 缓存     | Redis、缓存策略（穿透 / 击穿 / 雪崩）、一致性 |
| NoSQL    | MongoDB、图数据库、时序库                     |
| 搜索     | Elasticsearch 索引 / 分词 / 查询              |
| 消息队列 | Kafka / RabbitMQ、消息可靠性与顺序            |
| 大数据量 | 分库分表、读写分离、备份恢复                  |

### 运行层 🏃

让交付出来的服务跑起来、跑得稳、可观测。

| 目录                                                          | 中文名       | 定位                         |
| ------------------------------------------------------------- | ------------ | ---------------------------- |
| [`InfrastructureEngineering/`](./InfrastructureEngineering/) | 基础设施工程 | 让应用跑起来、跑得稳、可观测 |

#### 🧱 InfrastructureEngineering 基础设施工程

| 能力项     | 覆盖内容                         |
| ---------- | -------------------------------- |
| 系统与脚本 | Linux、Shell、系统调优           |
| 网络       | TCP/IP、DNS、HTTPS、Nginx / 网关 |
| 容器与编排 | Docker、Kubernetes、Helm         |
| CI/CD      | 流水线、灰度发布、回滚           |
| IaC        | Terraform、Ansible、配置管理     |
| 可观测性   | 监控、日志、链路追踪、告警       |
| 云平台     | AWS / 阿里云、Serverless、成本   |

### 质量层 🔍

让交付与运行的过程质量高、协作顺、可复用。

| 目录                                              | 中文名   | 定位                         |
| ------------------------------------------------- | -------- | ---------------------------- |
| [`EngineeringPractice/`](./EngineeringPractice/) | 工程实践 | 让工程质量高、协作顺、可复用 |

#### 🧪 EngineeringPractice 工程实践

| 能力项    | 覆盖内容                             |
| --------- | ------------------------------------ |
| 版本控制  | Git 工作流（分支模型 / PR）          |
| 测试体系  | 单元 / 集成 / E2E、TDD、Mock、覆盖率 |
| 质量保障  | Code Review、Lint、规范、重构        |
| 文档      | 技术文档、知识沉淀、ADR              |
| 协作流程  | Agile / Scrum、需求与排期            |
| AI 工作流 | AI 辅助开发、提示词工程、AI Agent、Agent harness（如 Pi）、自动化 |

### 治理层 🛡️（跨层，就近归档）

架构与安全不设目录，内容按就近原则归档到相关维度。

| 主题           | 覆盖内容                       | 归档去向                                                                    |
| -------------- | ------------------------------ | --------------------------------------------------------------------------- |
| 系统架构与设计 | 高并发、分布式一致性、容量规划 | `BackendEngineering/` 或 `DataEngineering/`                             |
| 安全工程       | OWASP、加密、审计、合规        | `BackendEngineering/`（认证授权）+ `InfrastructureEngineering/`（合规） |

---

## 归档约定 📝

### 文件与流程

- 📄 每篇归档文档以**组件名**命名（如 `Docker.md`），不使用文章标题作为文件名。
- 🗂️ 当一个技能包含多篇文档时（如 `Python` 的文章 + 课程笔记），创建同名文件夹存放（如 `Python/`），文件夹内以组件名文档为主文档。
- 🔗 文档大标题按 MCP 规范使用超链接格式：`# [原标题](原始URL)`，链接回原文。
- 🖼️ 排版优化与润色时**保留除照片以外的全部原始内容**。
- 🧹 爬取完成并输出文档后，删除 `repos/WeRead-MCP/output/` 中对应的中间输出文件夹。
- ➕ 每次归档后在下方「归档记录」表中追加一行。

### 故事化改写

归档不是原文照搬，而是以故事为骨架重写全文（形态参照 `Java.md`、`Redis.md`、`Docker.md`、`HTML5.md`）：

- 🎭 **独立故事线**：新主角、新团队、新项目，不沿用其他文档（如 Docker.md 的书友会小林）的角色设定。
- 📖 **引言区**：标题下方只有一个故事引言块（`> 这是一个关于"XX"的故事——…读完之后你会发现…`），包含主角、团队、项目背景与全文主线；不叠加"本文的故事"或原文导语等额外引用块。
- 🧭 **章节叙事化**：章节以故事站点推进（「第 N 站：」「故事的起点：」等标题风格），故事线贯穿大部分章节正文，而非只在开头结尾包装。
- 🎬 **收束呼应**：结尾先以故事情节呼应开篇钩子，再以金句引用收尾，最后附「参考资料/官方延伸阅读」（`[名称](URL)` 格式）与版本提示。
- 💻 **代码与表格**：还原爬取产物中被压成单行的代码并标注语言（如 ```java / ```ts / ```yaml）；爬取时丢失的表格按原文语义补全。

### 完成后自检

每篇归档完成后，以**库内已有文档为基准**逐项对照检查（不能只做结构计数自检）：引言区结构、标题与叙事风格、故事线浓度、引号配对与代码块语言标注、结尾与参考资料格式，均应与库内文档一致。

---

## 归档记录 🗃️

| 日期       | 组件      | 文档                                                                            | 维度         | 来源                                                         |
| ---------- | --------- | ------------------------------------------------------------------------------- | ------------ | ------------------------------------------------------------ |
| 2026-07-31 | 🐳 Docker | [`InfrastructureEngineering/Docker.md`](./InfrastructureEngineering/Docker.md) | 容器与编排   | [微信文章](https://mp.weixin.qq.com/s/W7sF-SLx_h5d0ATxYvyVfA) |
| 2026-07-31 | 🔀 Git    | [`EngineeringPractice/Git.md`](./EngineeringPractice/Git.md)                   | 版本控制     | [微信文章](https://mp.weixin.qq.com/s/bj3WOSaIQy-nn5jFBlqkoA) |
| 2026-07-31 | 🐬 MySQL  | [`DataEngineering/MySQL.md`](./DataEngineering/MySQL.md)                       | 关系型       | [微信文章](https://mp.weixin.qq.com/s/LHi0h67ofyWMeT-0oGFYlQ) |
| 2026-07-31 | 📄 HTML5  | [`FrontendEngineering/HTML5.md`](./FrontendEngineering/HTML5.md)               | 语言基础     | [微信文章](https://mp.weixin.qq.com/s/ZBfr5Gy8xwpVA7zBVvKG_g) |
| 2026-07-31 | 🎨 CSS    | [`FrontendEngineering/CSS.md`](./FrontendEngineering/CSS.md)                   | 语言基础     | [微信文章](https://mp.weixin.qq.com/s/o6fHc8HdNtxj6sVnaXU3_w) |
| 2026-07-31 | 🐧 Linux 命令行 | [`InfrastructureEngineering/Linux/Linux-CLI.md`](./InfrastructureEngineering/Linux/Linux-CLI.md) | 系统与脚本   | [微信文章](https://mp.weixin.qq.com/s/odlsBmQNbev_QsIDdxwoDg) |
| 2026-07-31 | 🐍 Python | [`BackendEngineering/Python/Python.md`](./BackendEngineering/Python/Python.md) | 语言与运行时 | [微信文章](https://mp.weixin.qq.com/s/1sBnEMSFSM9y5fTNZxMBXg) |
| 2026-07-31 | 🔧 C      | [`BackendEngineering/C.md`](./BackendEngineering/C.md)                         | 语言与运行时 | [微信文章](https://mp.weixin.qq.com/s/c1IMjAEaRsEVRznck3s-EQ) |
| 2026-09-13 | ☕ Java   | [`BackendEngineering/Java/Java.md`](./BackendEngineering/Java/Java.md)                   | 语言与运行时 | [微信文章](https://mp.weixin.qq.com/s/eeHf_lR7JifPfVJ5yOP7Ww) |
| 2026-09-13 | ⚙️ C++  | [`BackendEngineering/C++.md`](./BackendEngineering/C++.md)                     | 语言与运行时 | [微信文章](https://mp.weixin.qq.com/s/EDZfTepyxHe5KpmDIWeLkA) |
| 2026-09-13 | 🟥 Redis | [`DataEngineering/Redis.md`](./DataEngineering/Redis.md)                       | 缓存         | [微信文章](https://mp.weixin.qq.com/s/z10bmESAOmNZRrmF5j-IJw) |
| 2026-09-13 | 🐹 Go    | [`BackendEngineering/Go.md`](./BackendEngineering/Go.md)                       | 语言与运行时 | [微信文章](https://mp.weixin.qq.com/s/41EjE86tPGa3Ux-yaR0aeg) |
| 2026-09-13 | 🌐 Netty | [`BackendEngineering/Java/Netty.md`](./BackendEngineering/Java/Netty.md)                   | 并发模型     | [微信文章](https://mp.weixin.qq.com/s/ecei443td-L_rd3WiB7s1w) |
| 2026-09-14 | 🌍 HTTP   | [`InfrastructureEngineering/HTTP.md`](./InfrastructureEngineering/HTTP.md)     | 网络         | [微信文章](https://mp.weixin.qq.com/s/I4LnWoOq2n1GEmz_CghwtA) |
| 2026-09-14 | 📡 TCP/IP | [`InfrastructureEngineering/TCP-IP.md`](./InfrastructureEngineering/TCP-IP.md) | 网络         | [微信文章](https://mp.weixin.qq.com/s/0fk8OLB2ZadEAkiLnAd7bw) |
| 2026-09-14 | 🐚 Linux 系统编程 | [`InfrastructureEngineering/Linux/Linux-System-Programming.md`](./InfrastructureEngineering/Linux/Linux-System-Programming.md) | 系统与脚本   | [微信文章](https://mp.weixin.qq.com/s/LO7pBXfyQrrxCEM6-OYAXA) |
| 2026-09-17 | 🗄️ SQLite | [`DataEngineering/SQLite.md`](./DataEngineering/SQLite.md)                     | 关系型       | [微信文章](https://mp.weixin.qq.com/s/WH_6PhfS8bgLUapDGpfN9w) |
| 2026-09-17 | 🍃 MongoDB | [`DataEngineering/MongoDB.md`](./DataEngineering/MongoDB.md)                   | NoSQL        | [微信文章](https://mp.weixin.qq.com/s/nJQCYsydzdI6Q8zJmd2U2w) |
| 2026-09-17 | 🌱 Spring | [`BackendEngineering/Spring.md`](./BackendEngineering/Spring.md)               | Web 框架     | [微信文章](https://mp.weixin.qq.com/s/xd8WyB_BREkwdsZDzbWlSQ) |
| 2026-09-17 | 🟦 TypeScript | [`FrontendEngineering/TypeScript.md`](./FrontendEngineering/TypeScript.md)     | 语言基础     | [微信文章](https://mp.weixin.qq.com/s/J7m2cUHZa6vvDnp-fsXgrw) |
| 2026-09-17 | 🟢 Node.js | [`BackendEngineering/Node.js.md`](./BackendEngineering/Node.js.md)             | 语言与运行时 | [微信文章](https://mp.weixin.qq.com/s/jW6PsxEaNJhUihOH2zzh1A) |
| 2026-09-17 | 🤖 Agent | [`EngineeringPractice/Agent.md`](./EngineeringPractice/Agent.md)               | AI 工作流    | [微信文章](https://mp.weixin.qq.com/s/Q2Fkkp8GrJ49SUeczrjZUQ)（另参考 [Pi 拆解](https://mp.weixin.qq.com/s/uW6RmcPD0pC3FzswY4xyfA)、[Pi 官方文档](https://pi.dev/docs/latest)） |
| 2026-09-18 | 🐚 Shell 编程 | [`InfrastructureEngineering/Linux/Linux-Shell.md`](./InfrastructureEngineering/Linux/Linux-Shell.md) | 系统与脚本   | [微信文章](https://mp.weixin.qq.com/s/MuOLKLsVGFT7tdGgclBBaw) |
| 2026-09-19 | 🌐 Nginx | [`InfrastructureEngineering/Nginx.md`](./InfrastructureEngineering/Nginx.md) | 网络         | [KBchulan 博客](https://kbchulan.github.io/ClBlogs/blogs-main/mystore/06-nginx.html) |
| 2026-09-19 | 🐰 RabbitMQ | [`DataEngineering/RabbitMQ.md`](./DataEngineering/RabbitMQ.md) | 消息队列 | [KBchulan 博客](https://kbchulan.github.io/ClBlogs/blogs-main/mystore/05-rabbitmq.html) |
| 2026-09-25 | ⚛️ React | [`FrontendEngineering/React.md`](./FrontendEngineering/React.md) | 语言基础 | [微信文章](https://mp.weixin.qq.com/s/HmZlvHB9MIbjRGmBpOUJTA) |
| 2026-09-25 | 🟨 JavaScript | [`FrontendEngineering/JavaScript.md`](./FrontendEngineering/JavaScript.md) | 语言基础 | [微信文章](https://mp.weixin.qq.com/s/wYw9iQd8_CVyRL23G5ZKvQ) |
| 2026-09-25 | ⚡ Vite | [`FrontendEngineering/Vite.md`](./FrontendEngineering/Vite.md) | 构建工程化 | [微信文章](https://mp.weixin.qq.com/s/ZAPZPvmcC_QrR3aCOJrm9g) |
| 2026-09-25 | 💚 Vue | [`FrontendEngineering/Vue.md`](./FrontendEngineering/Vue.md) | 框架与状态 | [微信文章](https://mp.weixin.qq.com/s/BB1WfybqKM1p0J1cACFNgg) |
