# 流程图（Flowchart）

表达流程、算法、决策树与用户旅程，展示逐步推进的过程。

`flowchart` 是 Mermaid 默认选择：笔记内的流程、算法、判断分支都用它。

## 基础语法

```mermaid
flowchart TD
    A --> B
```

| 方向关键字      | 方向             |
| --------------- | ---------------- |
| `TD` / `TB` | 从上到下（默认） |
| `BT`          | 从下到上         |
| `LR`          | 从左到右         |
| `RL`          | 从右到左         |

## 节点形状

| 形状         | 语法                                        | 常用场景       |
| ------------ | ------------------------------------------- | -------------- |
| 矩形         | `A[处理步骤]`                             | 默认，普通步骤 |
| 圆角矩形     | `B([圆角处理])`                           | 处理           |
| 胶囊/Stadium | `C([开始或结束])`                         | 起止节点       |
| 子程序       | `D[[子程序]]`                             | 调用子过程     |
| 圆柱         | `E[(数据库)]`                             | 数据存储       |
| 圆形         | `F((圆形节点))`                           | 连接点         |
| 非对称/旗帜  | `G>旗帜节点]`                             | 特殊标记       |
| 菱形         | `H{判断?}`                                | 分支判断       |
| 六边形       | `I{{六边形}}`                             | 准备/循环      |
| 平行四边形   | `J[/输入或输出/]` `K[\另一种输入输出\]` | 输入输出       |
| 梯形         | `L[/梯形\]` `M[\反向梯形/]`             | 人工操作       |

同一流程中，同类动作应使用同一种形状。

## 连线

| 类型       | 语法                                           |
| ---------- | ---------------------------------------------- |
| 实线箭头   | `A --> B`                                    |
| 实线无箭头 | `A --- B`                                    |
| 带标签     | `A -->\|标签\| B`、`C ---\|"含空格的标签"\| D` |
| 虚线       | `A -.-> B`、`C -.- D`、`E -.标签.-> F`   |
| 粗线       | `A ==> B`、`C === D`、`E ==标签==> F`    |

链式与一对多写法：

```mermaid
flowchart LR
    A --> B --> C --> D
    E --> F & G --> H
    I --> J & K & L
```

## 子图（Subgraph）

用子图对相关节点分组，可嵌套，也可单独指定内部方向：

```mermaid
flowchart TB
    A[开始]

    subgraph 处理阶段
        direction TB
        B[步骤 1]
        C[步骤 2]
        subgraph 内层阶段
            D[子步骤]
        end
    end

    A --> B
    C --> D
```

## 样式

```mermaid
flowchart LR
    A[普通节点]
    B[强调节点]:::highlight
    A --> B

    style A fill:#fff,stroke:#333,stroke-width:2px
    classDef highlight fill:#ff6b6b,stroke:#333,stroke-width:4px,color:#fff
    linkStyle 0 stroke:#ff3,stroke-width:4px,color:red
```

`linkStyle` 的下标对应已存在的连线；图里没有连线时使用它会直接报错。

- `style <节点ID>`：设置单个节点
- `classDef <类名>`：定义样式类，节点用 `:::` 引用，适合批量复用
- `linkStyle <连线序号>`：按下标设置连线样式

更多主题与布局配置见 [styling-and-config.md](styling-and-config.md)。

## 完整示例

### 算法流程：二分查找

```mermaid
flowchart TD
    Start([开始二分查找]) --> Init["low = 0, high = 数组长度 - 1"]
    Init --> Check{"low <= high?"}

    Check -->|否| NotFound["返回 -1：未找到"]
    NotFound --> End([结束])

    Check -->|是| CalcMid["mid = low + (high - low) / 2"]
    CalcMid --> Compare{"array[mid] == target?"}

    Compare -->|是| Found["返回 mid：已找到"]
    Found --> End

    Compare -->|否| CheckLess{"array[mid] < target?"}
    CheckLess -->|是| MoveLow["low = mid + 1"]
    MoveLow --> Check
    CheckLess -->|否| MoveHigh["high = mid - 1"]
    MoveHigh --> Check

    style Start fill:#90EE90
    style End fill:#90EE90
    style Found fill:#FFD700
    style NotFound fill:#FF6B6B
```

标签中含 `<`、`(`、`[` 等特殊字符时必须用引号包裹，否则 Mermaid 解析报错。

### 业务流程：用户注册

```mermaid
flowchart TD
    Start([访问注册页]) --> Form[展示注册表单]
    Form --> Input[用户填写信息]
    Input --> Validate{输入合法?}

    Validate -->|否| ShowError[提示校验错误]
    ShowError --> Form

    Validate -->|是| CheckEmail{邮箱已存在?}
    CheckEmail -->|是| EmailError[提示邮箱已注册]
    EmailError --> Form

    CheckEmail -->|否| CreateAccount[创建账号]
    CreateAccount --> Hash[哈希密码]
    Hash --> SaveDB[(写入数据库)]
    SaveDB --> GenToken[生成验证令牌]
    GenToken --> SendEmail[发送验证邮件]
    SendEmail --> Success[提示注册成功]
    Success --> End([跳转登录页])

    style Start fill:#90EE90,stroke:#333,stroke-width:2px
    style End fill:#90EE90,stroke:#333,stroke-width:2px
    style CreateAccount fill:#87CEEB,stroke:#333,stroke-width:2px
    style SaveDB fill:#FFD700,stroke:#333,stroke-width:2px
```

### 部署流程：CI/CD 流水线

```mermaid
flowchart LR
    subgraph 开发
        Commit[提交代码] --> Push[推送到仓库]
    end

    subgraph 持续集成
        Push --> Trigger[触发流水线]
        Trigger --> Checkout[拉取代码]
        Checkout --> Install[安装依赖]
        Install --> Lint[静态检查]
        Lint --> Test[运行测试]
        Test --> Build[构建产物]
    end

    subgraph 预发验证
        Build --> DeployStaging[部署到预发]
        DeployStaging --> E2E[端到端测试]
        E2E --> ManualQA{人工验收通过?}
    end

    subgraph 生产发布
        ManualQA -->|通过| DeployProd[部署生产]
        DeployProd --> HealthCheck{健康检查通过?}
        HealthCheck -->|是| Success([发布成功])
        HealthCheck -->|否| Rollback[回滚]
        Rollback --> Alert[通知团队]
    end

    ManualQA -->|驳回| FixIssues[修复问题]
    Test -->|失败| NotifyDev[通知开发者]
    NotifyDev --> FixIssues
    FixIssues --> 开发
```

## 最佳实践

1. 节点文案用明确的动作短语，避免无意义名词
2. 同类节点保持同形状；判断一律用菱形
3. 默认自上而下或自左向右，遵循自然阅读方向
4. 起止节点用胶囊形状明确标注
5. 用子图划分逻辑边界，用颜色区分动作类型
6. 减少连线交叉，必要时重排节点顺序
7. 一图一流程；节点超过 15 个时按 `SKILL.md`《选型》拆分或升级 D2

## 常用模式

**线性流程**

```mermaid
flowchart LR
    A[步骤 1] --> B[步骤 2] --> C[步骤 3] --> D[步骤 4]
```

**分支判断**

```mermaid
flowchart TD
    A[输入] --> B{条件?}
    B -->|成立| C[分支 1]
    B -->|不成立| D[分支 2]
    C --> E[汇合]
    D --> E
```

**循环**

```mermaid
flowchart TD
    A[初始化] --> B[处理]
    B --> C{继续?}
    C -->|是| B
    C -->|否| D[退出]
```

**错误处理**

```mermaid
flowchart TD
    A[执行操作] --> B{成功?}
    B -->|是| C[继续]
    B -->|否| D[处理错误]
    D --> E{重试?}
    E -->|是| A
    E -->|否| F[终止]
```

## 相关参考

- 状态流转、状态机 → [state-diagrams.md](state-diagrams.md)
- 时序交互 → [sequence-diagrams.md](sequence-diagrams.md)
