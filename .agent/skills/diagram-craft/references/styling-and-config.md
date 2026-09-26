# 样式与配置（主题、布局、导出）

适用于**所有** Mermaid 图型：主题、样式、布局引擎、导出与可访问性。图型专属语法见各自文件。

配置用图内块 frontmatter 声明，只影响当前这一张图。

## Frontmatter 配置

```mermaid
---
config:
  theme: dark
  themeVariables:
    primaryColor: "#ff6b6b"
---
flowchart TD
    A --> B
```

## 内置主题

| 主题      | 风格                       |
| --------- | -------------------------- |
| `default` | 标准蓝色主题               |
| `forest`  | 绿色自然色调               |
| `dark`    | 深色模式                   |
| `neutral` | 灰阶专业风                 |
| `base`    | 最小化基础主题，便于自定义 |

```mermaid
---
config:
  theme: forest
---
flowchart LR
    A[开始] --> B[处理]
    B --> C{判断}
    C -->|是| D[动作 1]
    C -->|否| E[动作 2]
```

## 自定义主题变量

用 `theme: base` 打底，再逐个覆盖变量：

```mermaid
---
config:
  theme: base
  themeVariables:
    primaryColor: "#ff6b6b"
    primaryTextColor: "#fff"
    primaryBorderColor: "#d63031"
    lineColor: "#74b9ff"
    secondaryColor: "#00b894"
    tertiaryColor: "#fdcb6e"
    background: "#f0f0f0"
    mainBkg: "#ffffff"
    textColor: "#333333"
    nodeBorder: "#333333"
    clusterBkg: "#f9f9f9"
    clusterBorder: "#666666"
---
flowchart TD
    A --> B --> C
```

常用变量：`primaryColor`（主节点底色）、`primaryTextColor`（主节点文字）、`lineColor`（连线）、`secondaryColor`/`tertiaryColor`（次级节点）、`background`/`mainBkg`（画布与节点背景）、`clusterBkg`/`clusterBorder`（子图）。

## 布局引擎

**dagre（默认）**

```mermaid
---
config:
  layout: dagre
---
flowchart TD
    A --> B
```

**elk（复杂图更优）**

```mermaid
---
config:
  layout: elk
  elk:
    mergeEdges: true
    nodePlacementStrategy: BRANDES_KOEPF
---
flowchart TD
    A --> B
```

| 节点放置策略      | 说明             |
| ----------------- | ---------------- |
| `SIMPLE`          | 基础放置         |
| `NETWORK_SIMPLEX` | 网络优化         |
| `LINEAR_SEGMENTS` | 线性排列         |
| `BRANDES_KOEPF`   | 均衡放置（默认） |

dagre 出现大量交叉线或节点超过 20 个时，改用 elk，并开启 `mergeEdges` 减少连线杂乱。

## 视觉风格（look）

```mermaid
---
config:
  look: handDrawn
---
flowchart LR
    A --> B --> C
```

- `classic`：传统 Mermaid 观感
- `handDrawn`：手绘草图风，适合非正式场合

## 完整配置示例

```mermaid
---
config:
  theme: base
  look: handDrawn
  layout: dagre
  themeVariables:
    primaryColor: "#ff6b6b"
    primaryTextColor: "#fff"
    primaryBorderColor: "#d63031"
    lineColor: "#74b9ff"
    secondaryColor: "#00b894"
    tertiaryColor: "#fdcb6e"
---
flowchart TD
    Start([开始处理]) --> Input[收集数据]
    Input --> Process{校验通过?}
    Process -->|是| Store[(写入数据库)]
    Process -->|否| Error[展示错误]
    Store --> Notify[发送通知]
    Error --> Input
    Notify --> End([完成])
```

## 逐元素样式

**样式类（推荐，可复用）**

```mermaid
flowchart TD
    A[成功]:::success
    B[警告]:::warning
    C[失败]:::error

    classDef success fill:#00b894,stroke:#00a383,color:#fff
    classDef warning fill:#fdcb6e,stroke:#e8b923,color:#333
    classDef error fill:#ff6b6b,stroke:#ee5253,color:#fff

    A --> B --> C
```

**单节点与单连线**

```mermaid
flowchart LR
    A[节点 A] --> B[节点 B]
    B --> C[节点 C]

    style B fill:#ff6b6b,stroke:#333,stroke-width:4px
    linkStyle 0 stroke:#4ecdc4,stroke-width:2px
```

- `classDef 类名 ...` 定义样式类，节点用 `:::类名` 引用
- `style <节点ID> ...` 只作用于单个节点
- `linkStyle <连线序号> ...` 按下标设置连线样式

**子图样式与分组配色**

```mermaid
flowchart TB
    subgraph 前端
        A[Web 应用]
        B[移动端]
    end

    subgraph 后端
        C[API]
        D[数据库]
    end

    A & B --> C
    C --> D

    style 前端 fill:#e3f2fd,stroke:#2196f3,stroke-width:2px
    style 后端 fill:#fff3e0,stroke:#ff9800,stroke-width:2px
```

**整图主题覆盖**：时序图、类图这类没有逐元素样式的图型，用 `%%{init: ...}%%` 指令声明，**指令必须写在图型声明之前**：

```mermaid
%%{init: {'theme':'dark'}}%%
sequenceDiagram
    participant A
    participant B
    A->>B: 消息 1
    B->>A: 消息 2
```

**综合示例**

```mermaid
flowchart TB
    subgraph production[生产环境]
        direction LR
        lb[负载均衡]

        subgraph servers[应用服务器]
            app1[服务器 1]
            app2[服务器 2]
            app3[服务器 3]
        end

        cache[(Redis 缓存)]
        db[(PostgreSQL)]
    end

    subgraph monitoring[监控]
        logs[日志聚合]
        metrics[指标看板]
    end

    users[用户] --> lb
    lb --> app1 & app2 & app3
    app1 & app2 & app3 --> cache
    app1 & app2 & app3 --> db
    app1 & app2 & app3 --> logs
    logs --> metrics

    style production fill:#e8f5e9,stroke:#4caf50,stroke-width:3px
    style servers fill:#fff3e0,stroke:#ff9800,stroke-width:2px
    style monitoring fill:#e3f2fd,stroke:#2196f3,stroke-width:2px
    style lb fill:#ffeb3b,stroke:#fbc02d,stroke-width:2px
    style cache fill:#ce93d8,stroke:#ab47bc,stroke-width:2px
    style db fill:#ce93d8,stroke:#ab47bc,stroke-width:2px

    classDef serverClass fill:#81c784,stroke:#4caf50,stroke-width:2px,color:#000
    class app1,app2,app3 serverClass

    linkStyle 0,1,2,3 stroke:#4caf50,stroke-width:2px
    linkStyle 4,5,6,7,8,9 stroke:#ff9800,stroke-width:1px
```

## 交互元素

节点可以加跳转链接与悬浮提示（需渲染环境允许外链，Mermaid 侧对应 `securityLevel: loose`）：

```mermaid
flowchart LR
    A[GitHub]
    B[文档]
    C[服务看板]

    click A "https://github.com" "前往 GitHub"
    click B "https://mermaid.js.org" "查看文档"
    click C "https://dashboard.example.com" "服务看板"

    A --> B --> C
```

`click <节点ID> "URL" "悬浮提示"`：第二个参数是跳转地址，第三个是鼠标悬浮提示。

注意：`link <参与者>: 文本 @ URL` 是**时序图**专属写法，流程图不支持，二者不要混用，见 [sequence-diagrams.md](sequence-diagrams.md)。

## 注释

用 `%%` 写注释，仅提升源码可读性，不出现在渲染结果中：

```mermaid
flowchart TD
    %% 定义节点
    A[开始]
    B[处理]
    C[结束]

    %% 定义关系
    A --> B
    B --> C
```

## 导出与内嵌

**命令行导出 SVG**（`@mermaid-js/mermaid-cli`）：

```bash
mmdc -i diagram.mmd -o output.svg -w 1920 -H 1080    # 指定尺寸
mmdc -i diagram.mmd -o output.svg -b "#ffffff"       # 指定背景色
mmdc -i diagram.mmd -o output.svg -b "transparent"   # 透明背景
```

**Markdown 内嵌**：直接用 ```` ```mermaid ```` 代码块，无需导出：

````markdown
```mermaid
flowchart LR
    A --> B
```
````

**网页内嵌自适应**：套一层限制宽度的容器：

```html
<div style="max-width: 100%; overflow: auto;">
    <pre class="mermaid">
        flowchart LR
            A --> B --> C
    </pre>
</div>
```

## 可访问性

```mermaid
---
config:
  theme: base
  themeVariables:
    primaryColor: "#0066cc"
    primaryTextColor: "#ffffff"
    primaryBorderColor: "#003d7a"
    lineColor: "#333333"
    background: "#ffffff"
    mainBkg: "#f0f0f0"
---
flowchart TD
    A[高对比文字] --> B[清晰标签]
    B --> C[有含义的颜色]
```

- 使用高对比度配色
- 不要只靠颜色传递含义，同时给出文字标签
- 用色盲模拟器检查配色
- 必要时提供深色模式版本

## 性能

- 节点超过 20 个时改用 `layout: elk` 并开启 `mergeEdges`
- 超大图拆成多张聚焦的小图，或用子图分层组织
- 样式只施加在关键元素上，避免全图刷色

## 最佳实践

1. 同一批图使用同一套主题，保持视觉一致
2. 不过度美化，颜色过多反而降低可读性
3. 手绘风（`handDrawn`）适合非正式场景，正式文档优先 `classic`
4. 复杂配置写注释说明非直觉的样式选择
5. 导出后实测目标渲染环境（GitHub、CNB、VS Code）效果
6. 主题变更随源码一起纳入版本控制
