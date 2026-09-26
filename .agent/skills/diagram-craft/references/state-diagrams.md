# 状态图（State Diagram）

表达对象或系统在生命周期内的状态与状态迁移，用 `stateDiagram-v2`。

典型用途：进程状态机、TCP 连接状态、线程生命周期、订单状态流转。若只是"步骤推进"而非"状态停留"，用 [flowcharts.md](flowcharts.md)。

## 基础语法

```mermaid
stateDiagram-v2
    [*] --> 就绪
    就绪 --> 运行: 被调度
    运行 --> [*]: 进程退出
```

- `[*]` 表示起点或终点
- `A --> B: 标签` 表示一次状态转换
- 状态名可直接用中文

## 状态别名

状态名含空格或较长时，用 `state "描述" as 别名`：

```mermaid
stateDiagram-v2
    state "等待 I/O" as 阻塞
    [*] --> 就绪
    就绪 --> 阻塞: 发起 I/O
    阻塞 --> 就绪: I/O 完成
```

## 复合状态（嵌套）

```mermaid
stateDiagram-v2
    [*] --> 运行
    state 运行 {
        [*] --> 用户态
        用户态 --> 内核态: 系统调用
        内核态 --> 用户态: 返回
    }
    运行 --> 终止: 结束
```

## 并发区域

用 `--` 分隔并发的子状态机：

```mermaid
stateDiagram-v2
    state 并发展开 {
        [*] --> 读数据
        --
        [*] --> 写日志
    }
```

## 选择与分叉汇合

```mermaid
stateDiagram-v2
    state 判断 <<choice>>
    state 分叉 <<fork>>
    state 汇合 <<join>>

    [*] --> 判断
    判断 --> 分叉: 条件成立
    判断 --> [*]: 条件不成立

    分叉 --> 任务A
    分叉 --> 任务B
    任务A --> 汇合
    任务B --> 汇合
    汇合 --> [*]
```

## 方向

```mermaid
stateDiagram-v2
    direction LR
    [*] --> 就绪
    就绪 --> 运行
    运行 --> 终止
```

## 注释

```mermaid
stateDiagram-v2
    [*] --> 运行
    note right of 运行
        时间片耗尽会回到就绪态
    end note
    运行 --> 终止
```

## 样式

```mermaid
stateDiagram-v2
    state "运行" as running
    classDef emphasis fill:#ff6b6b,color:#fff

    [*] --> 就绪
    就绪 --> running
    class running emphasis
```

状态图的 `classDef` / `class` 只接受 ASCII 标识符：中文状态需先用 `state "中文名" as 别名` 声明，再对别名施加样式。

## 完整示例

### 进程状态机（408 高频考点）

```mermaid
stateDiagram-v2
    [*] --> 创建
    创建 --> 就绪: 创建完成
    就绪 --> 运行: 调度
    运行 --> 就绪: 时间片耗尽
    运行 --> 阻塞: 等待 I/O 或事件
    阻塞 --> 就绪: I/O 完成 / 事件到达
    运行 --> 终止: 正常结束
    运行 --> 终止: 异常终止
    终止 --> [*]

    note right of 阻塞
        阻塞态只能回到就绪态，
        不能直接回到运行态
    end note
```

### TCP 连接状态机

```mermaid
stateDiagram-v2
    [*] --> CLOSED
    CLOSED --> LISTEN: 被动打开
    CLOSED --> SYN_SENT: 主动打开

    LISTEN --> SYN_RCVD: 收到 SYN
    SYN_SENT --> ESTABLISHED: 收到 SYN+ACK
    SYN_RCVD --> ESTABLISHED: 收到 ACK

    ESTABLISHED --> FIN_WAIT_1: 主动关闭
    ESTABLISHED --> CLOSE_WAIT: 收到 FIN

    FIN_WAIT_1 --> TIME_WAIT: 收到 FIN+ACK
    CLOSE_WAIT --> LAST_ACK: 应用关闭
    LAST_ACK --> CLOSED: 收到 ACK
    TIME_WAIT --> CLOSED: 等待 2MSL 超时
```

### 订单状态流转

```mermaid
stateDiagram-v2
    [*] --> 待支付
    待支付 --> 已支付: 支付成功
    待支付 --> 已取消: 超时未支付
    待支付 --> 已取消: 用户取消

    已支付 --> 已发货: 仓库出库
    已发货 --> 已完成: 用户确认收货
    已发货 --> 退款中: 申请退款
    退款中 --> 已退款: 审核通过
    退款中 --> 已发货: 审核驳回

    已完成 --> [*]
    已取消 --> [*]
    已退款 --> [*]
```

## 最佳实践

1. 状态名用"形容词/名词"（就绪、运行、阻塞），迁移标签用"动作/事件"
2. 迁移标签写清触发条件，避免无标签的裸连线
3. 状态与迁移太多时，用复合状态分层，而不是把几十个状态平铺
4. `[*]` 起点可有多个，终点也可有多个
5. 状态超过 15 个时按 `SKILL.md`《选型》拆分或升级 D2

## 相关参考

- 流程、分支、算法 → [flowcharts.md](flowcharts.md)
- 消息交互顺序 → [sequence-diagrams.md](sequence-diagrams.md)
