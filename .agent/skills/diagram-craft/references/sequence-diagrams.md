# 时序图（Sequence Diagram）

表现参与者之间随时间的交互，适合协议流程、API 调用链与系统组件协作。

## 基础语法

```mermaid
sequenceDiagram
    participant A
    participant B
    A->>B: 消息
```

## 参与者与角色

```mermaid
sequenceDiagram
    actor 用户
    participant 前端
    participant API
    participant 数据库

    用户->>前端: 点击按钮
    前端->>API: POST /data
```

- `participant`：系统组件（服务、类、数据库）
- `actor`：外部实体（用户、第三方系统）

参与者顺序决定泳道顺序，建议按 `用户 → 前端 → 后端 → 数据库` 排列。

## 消息类型

| 语法   | 含义                     |
| ------ | ------------------------ |
| `->>`  | 实线箭头，同步请求       |
| `-->>` | 虚线箭头，响应/返回      |
| `-)`   | 实线开口箭头，异步消息   |
| `--)`  | 虚线开口箭头，异步响应   |
| `-x`   | 叉号箭头，表示删除或终止 |

```mermaid
sequenceDiagram
    Client->>Server: 同步请求
    Server-->>Client: 同步响应
    Client-)Server: 异步消息
    Server--)Client: 异步响应
    Server-xClient: 连接关闭
```

## 激活块（Activation）

用 `+` / `-` 标出参与者正在处理的时间段：

```mermaid
sequenceDiagram
    Client->>+Server: 请求
    Server->>+Database: 查询
    Database-->>-Server: 数据
    Server-->>-Client: 响应
```

`->>+` 在箭头后加 `+` 开始激活，`-->>-` 在箭头前加 `-` 结束激活。

## 条件分支：alt / else

```mermaid
sequenceDiagram
    用户->>API: POST /login
    API->>数据库: 查询用户
    数据库-->>API: 用户数据

    alt 凭证有效
        API-->>用户: 200 OK + Token
    else 凭证无效
        API-->>用户: 401 Unauthorized
    else 账号已锁定
        API-->>用户: 403 Forbidden
    end
```

## 可选分支：opt

```mermaid
sequenceDiagram
    用户->>API: POST /order
    API->>支付服务: 处理支付

    opt 支付成功
        API->>邮件服务: 发送确认邮件
    end

    API-->>用户: 订单结果
```

## 并行：par

```mermaid
sequenceDiagram
    API->>订单服务: 处理订单

    par 发送邮件
        订单服务->>邮件服务: 发送确认
    and 扣减库存
        订单服务->>库存服务: 减少库存
    and 记录日志
        订单服务->>日志服务: 写入事件
    end

    订单服务-->>API: 完成
```

## 循环：loop

```mermaid
sequenceDiagram
    Client->>Server: 批量请求

    loop 逐条处理
        Server->>数据库: 处理单条
        数据库-->>Server: 结果
    end

    Server-->>Client: 全部结果
```

循环条件直接写在 `loop` 后，例如 `loop 每 5 秒`。

## 提前退出：break

```mermaid
sequenceDiagram
    用户->>API: 提交表单
    API->>校验器: 校验输入

    break 输入非法
        API-->>用户: 400 Bad Request
    end

    API->>数据库: 保存数据
    数据库-->>API: 成功
    API-->>用户: 200 OK
```

## 注释（Note）

```mermaid
sequenceDiagram
    用户->>API: 请求
    Note over API: 校验 JWT
    Note over 用户,API: 走 HTTPS 加密
    Note right of API: 写入审计日志
    Note left of 用户: 更新界面
    API-->>用户: 响应
```

`over` 覆盖单个或多个参与者（`over A,B`），`right of` / `left of` 贴在指定参与者一侧。

## 自动编号与链接

```mermaid
sequenceDiagram
    autonumber
    participant A as 服务 A
    link A: 监控面板 @ https://dashboard.example.com

    用户->>A: 登录
    A-->>用户: 登录成功
```

`autonumber` 给消息自动编号；`link` 为参与者附加可点击链接（在支持的渲染环境中生效）。

## 完整示例

### 用户认证流程

```mermaid
sequenceDiagram
    autonumber
    actor 用户
    participant 前端
    participant AuthAPI
    participant 数据库
    participant Redis
    participant 邮件服务

    用户->>+前端: 输入账号密码
    前端->>+AuthAPI: POST /auth/login

    AuthAPI->>+数据库: 按邮箱查用户
    数据库-->>-AuthAPI: 用户记录

    alt 用户不存在
        AuthAPI-->>前端: 404 User not found
        前端-->>用户: 展示错误
    else 用户存在
        AuthAPI->>AuthAPI: 校验密码哈希

        alt 密码错误
            AuthAPI->>数据库: 失败次数 +1

            opt 失败次数 > 5
                AuthAPI->>数据库: 锁定账号
                AuthAPI->>邮件服务: 发送安全告警
            end

            AuthAPI-->>前端: 401 Invalid credentials
            前端-->>用户: 展示错误
        else 密码正确
            AuthAPI->>AuthAPI: 生成 JWT
            AuthAPI->>+Redis: 写入会话
            Redis-->>-AuthAPI: 确认

            par 更新登录信息
                AuthAPI->>数据库: 更新 last_login
            and 埋点统计
                AuthAPI->>数据库: 记录登录事件
            end

            AuthAPI-->>-前端: 200 OK + JWT
            前端->>前端: 令牌写入本地存储
            前端-->>-用户: 跳转首页

            opt 首次登录
                邮件服务->>用户: 发送欢迎邮件
            end
        end
    end
```

### 微服务间协作

```mermaid
sequenceDiagram
    actor 用户
    participant 网关
    participant 订单服务
    participant 支付服务
    participant 库存服务
    participant 消息队列

    用户->>+网关: POST /orders
    网关->>+订单服务: 创建订单

    订单服务->>+库存服务: 校验库存
    库存服务-->>-订单服务: 库存充足

    break 库存不足
        订单服务-->>网关: 400 Out of stock
        网关-->>用户: 返回错误
    end

    订单服务->>订单服务: 预占订单
    订单服务->>+支付服务: 发起扣款

    alt 支付成功
        支付服务-->>-订单服务: 支付已确认
        订单服务->>消息队列: 发布 OrderConfirmed 事件

        par 异步处理
            消息队列->>库存服务: 扣减库存
        and
            消息队列->>通知服务: 发送确认
            通知服务->>用户: 邮件确认
        end

        订单服务-->>-网关: 201 Created
        网关-->>用户: 下单成功
    else 支付失败
        支付服务-->>订单服务: 支付被拒
        订单服务->>订单服务: 释放预占
        订单服务-->>网关: 402 Payment Required
        网关-->>用户: 支付失败
    end
```

## 最佳实践

1. 参与者按逻辑顺序排列，通常为 `用户 → 前端 → 后端 → 数据库`
2. 用激活块标出正在处理的组件
3. 用 `alt` / `opt` / `par` 组织条件、可选与并发分支
4. 用 `Note` 解释复杂逻辑，而非堆砌消息
5. 一图一场景，避免把多个流程塞进一张图
6. 消息较多时开启 `autonumber`
7. 用 `alt/else` 显式画出失败路径
8. 异步、fire-and-forget 的消息用开口箭头

## 常见场景

| 类别     | 典型主题                                           |
| -------- | -------------------------------------------------- |
| 认证授权 | 登录、OAuth/SSO、令牌刷新、找回密码                |
| 协议交互 | TCP 握手挥手、HTTP 请求响应、DNS 解析              |
| 系统集成 | 微服务调用、第三方 API、消息队列、事件驱动架构     |
| 业务流程 | 订单履约、支付处理、审批流、通知链                 |

## 相关参考

- 状态流转 → [state-diagrams.md](state-diagrams.md)
- 整体架构 → [architecture-diagrams.md](architecture-diagrams.md)
