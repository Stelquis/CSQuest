# 架构图（Architecture）

架构类图有两条路线，先按下面的表选一种语法，再往下看对应章节。

| 要表达的内容                                        | 用哪一节                                      |
| --------------------------------------------------- | --------------------------------------------- |
| 软件系统的分层结构（系统 / 容器 / 组件）            | [C4 软件架构](#c4-软件架构)                    |
| 云资源与网络拓扑（VPC、负载均衡、集群）             | [基础设施拓扑](#基础设施拓扑用-d2)             |

基础设施拓扑用 **D2** 编写：节点多、嵌套深，且中文标签在 Mermaid 11.x 下不可用（原因见该节）。

---

# C4 软件架构

C4 模型用分层方式表达软件架构，从高到低为：上下文（Context）、容器（Container）、组件（Component）、代码（Code）。

| 层级       | 关注点                     | 受众         |
| ---------- | -------------------------- | ------------ |
| 系统上下文 | 系统与用户、外部系统的关系 | 非技术干系人 |
| 容器       | 系统内的应用、数据库、服务 | 架构师       |
| 组件       | 某个容器的内部结构         | 开发者       |
| 代码       | 实现细节，直接用普通类图   | 开发者       |

## 上下文图（C4Context）

```mermaid
C4Context
    title 银行系统上下文图

    Person(customer, "客户", "银行客户")
    System(banking, "银行系统", "支持客户管理账户")
    System_Ext(email, "邮件系统", "发送邮件")

    Rel(customer, banking, "使用")
    Rel(banking, email, "发送邮件经由")
```

| 元素                                  | 含义                     |
| ------------------------------------- | ------------------------ |
| `Person` / `Person_Ext`           | 内部 / 外部人员          |
| `System` / `System_Ext`           | 内部 / 外部系统          |
| `SystemDb` / `SystemDb_Ext`       | 内部 / 外部数据库系统    |
| `SystemQueue` / `SystemQueue_Ext` | 内部 / 外部消息队列      |
| `Rel(from, to, "标签")`             | 单向关系，可加技术栈参数 |
| `BiRel(a, b, "标签")`               | 双向关系                 |

`Rel` 的第四个参数写技术栈，如 `Rel(a, b, "调用", "HTTPS/REST")`。

### 完整示例：电商平台上下文

```mermaid
C4Context
    title 系统上下文 - 电商平台

    Person(customer, "客户", "在线购物")
    Person(admin, "管理员", "管理商品与订单")
    Person_Ext(delivery, "配送人员", "配送订单")

    System(ecommerce, "电商平台", "在线购物平台")

    System_Ext(payment, "支付网关", "处理支付")
    System_Ext(email, "邮件服务", "发送通知")
    System_Ext(analytics, "埋点平台", "追踪用户行为")

    Rel(customer, ecommerce, "浏览商品、下单")
    Rel(admin, ecommerce, "管理目录、审核订单")
    Rel(delivery, ecommerce, "更新配送状态")

    Rel(ecommerce, payment, "处理支付", "HTTPS/REST")
    Rel(ecommerce, email, "发送邮件", "SMTP")
    Rel(ecommerce, analytics, "上报事件", "JavaScript SDK")

    UpdateRelStyle(customer, ecommerce, $offsetX="-50", $offsetY="-30")
    UpdateRelStyle(admin, ecommerce, $offsetX="50", $offsetY="-30")
```

## 容器图（C4Container）

放大到系统内部，展示应用、数据库、服务等容器。

```mermaid
C4Container
    title 容器图 - 电商平台

    Person(customer, "客户")
    Person(admin, "管理员")
    System_Ext(payment, "支付网关")
    System_Ext(email, "邮件服务")

    Container_Boundary(frontend, "前端") {
        Container(web, "Web 应用", "React", "提供界面")
        Container(mobile, "移动端 App", "React Native", "移动界面")
    }

    Container_Boundary(backend, "后端服务") {
        Container(api, "API 网关", "Node.js/Express", "路由请求")
        Container(auth, "认证服务", "Node.js", "处理认证")
        Container(catalog, "商品服务", "Python/FastAPI", "管理商品")
        Container(order, "订单服务", "Java/Spring", "处理订单")
        Container(notification, "通知服务", "Node.js", "发送通知")
    }

    Container_Boundary(data, "数据层") {
        ContainerDb(postgres, "主库", "PostgreSQL", "核心数据")
        ContainerDb(mongo, "商品库", "MongoDB", "商品目录")
        ContainerDb(redis, "缓存", "Redis", "会话与缓存")
        ContainerQueue(queue, "消息队列", "RabbitMQ", "异步处理")
    }

    Rel(customer, web, "使用", "HTTPS")
    Rel(customer, mobile, "使用", "HTTPS")
    Rel(admin, web, "管理", "HTTPS")

    Rel(web, api, "调用", "HTTPS/JSON")
    Rel(mobile, api, "调用", "HTTPS/JSON")

    Rel(api, auth, "认证", "gRPC")
    Rel(api, catalog, "获取商品", "REST")
    Rel(api, order, "创建订单", "REST")

    Rel(auth, postgres, "读写用户", "SQL")
    Rel(catalog, mongo, "读写商品", "MongoDB Protocol")
    Rel(order, postgres, "读写订单", "SQL")

    Rel(auth, redis, "存储会话", "Redis Protocol")
    Rel(api, redis, "缓存数据", "Redis Protocol")

    Rel(order, queue, "发布事件", "AMQP")
    Rel(notification, queue, "消费事件", "AMQP")
    Rel(notification, email, "发送", "SMTP")
    Rel(order, payment, "发起支付", "HTTPS/REST")
```

容器元素：`Container(id, "名称", "技术栈", "说明")`、`ContainerDb`（数据库）、`ContainerQueue`（消息队列）、`Container_Ext`（外部容器）、`Container_Boundary(id, "名称") { ... }`（逻辑边界）。

## 组件图（C4Component）

放大到某个容器内部，展示其组件构成。

```mermaid
C4Component
    title 组件图 - 订单服务

    Container(api_gateway, "API 网关", "Node.js")
    ContainerDb(postgres, "数据库", "PostgreSQL")
    ContainerQueue(queue, "消息队列", "RabbitMQ")
    System_Ext(payment, "支付网关")
    System_Ext(inventory, "库存服务")

    Container_Boundary(order_service, "订单服务") {
        Component(controller, "REST 控制器", "Spring MVC", "HTTP 入口")
        Component(order_logic, "订单管理", "Service", "订单处理逻辑")
        Component(payment_client, "支付客户端", "REST Client", "对接支付")
        Component(inventory_client, "库存客户端", "REST Client", "对接库存")
        Component(repository, "订单仓储", "JPA", "数据库操作")
        Component(event_publisher, "事件发布器", "Component", "发布领域事件")
        Component(validator, "订单校验器", "Component", "校验订单")
    }

    Rel(api_gateway, controller, "路由请求", "HTTPS/REST")

    Rel(controller, order_logic, "委托处理")
    Rel(controller, validator, "调用校验")

    Rel(order_logic, payment_client, "发起支付")
    Rel(order_logic, inventory_client, "校验库存")
    Rel(order_logic, repository, "持久化订单")
    Rel(order_logic, event_publisher, "发布事件")

    Rel(payment_client, payment, "调用", "HTTPS/REST")
    Rel(inventory_client, inventory, "调用", "HTTPS/REST")
    Rel(repository, postgres, "读写", "JDBC/SQL")
    Rel(event_publisher, queue, "发布", "AMQP")
```

## 常见软件架构模式

**单体应用**

```mermaid
C4Container
    Person(user, "用户")

    Container_Boundary(system, "应用") {
        Container(app, "Web 应用", "Ruby on Rails", "单体应用")
        ContainerDb(db, "数据库", "PostgreSQL", "业务库")
        ContainerDb(cache, "缓存", "Redis", "会话存储")
    }

    Rel(user, app, "使用", "HTTPS")
    Rel(app, db, "读写", "SQL")
    Rel(app, cache, "缓存", "Redis Protocol")
```

**三层架构**

```mermaid
C4Container
    Person(user, "用户")

    Container_Boundary(presentation, "表现层") {
        Container(web, "Web 服务器", "Nginx", "静态资源")
        Container(app, "应用服务器", "Node.js", "应用逻辑")
    }

    Container_Boundary(business, "业务层") {
        Container(api, "API 服务器", "Java", "业务逻辑")
    }

    Container_Boundary(data, "数据层") {
        ContainerDb(db, "数据库", "MySQL", "数据存储")
    }

    Rel(user, web, "使用", "HTTPS")
    Rel(web, app, "代理", "HTTP")
    Rel(app, api, "调用", "REST")
    Rel(api, db, "读写", "SQL")
```

**事件驱动架构**

```mermaid
C4Container
    Person(user, "用户")

    Container(frontend, "前端", "React", "用户界面")
    Container(api, "API 网关", "Kong", "接口路由")

    Container_Boundary(services, "服务") {
        Container(order, "订单服务", "Java", "订单处理")
        Container(inventory, "库存服务", "Go", "库存管理")
        Container(notification, "通知服务", "Node.js", "消息告警")
    }

    ContainerQueue(events, "事件总线", "Kafka", "事件流")
    ContainerDb(db, "数据库", "各类", "各服务独立库")

    Rel(user, frontend, "使用")
    Rel(frontend, api, "调用")
    Rel(api, order, "路由到")

    Rel(order, events, "发布 OrderCreated")
    Rel(events, inventory, "消费事件")
    Rel(events, notification, "消费事件")

    Rel(order, db, "持久化")
    Rel(inventory, db, "持久化")
```

---

# 基础设施拓扑（用 D2）

表达云资源、网络分区与部署关系。

**为什么不用 Mermaid 的 `architecture-beta`**：它自 v11.1.0 才引入，且方括号标签只接受 ASCII——中文标签在 Mermaid 11.x 下直接报 `Lexer error: unexpected character: ->[<-`（本仓库渲染环境即 11.x，已实测复现）。D2 对中文标签无限制，且产物是 SVG，任何环境都能查看。

用法要点（完整语法见 [d2-essentials.md](d2-essentials.md)）：

- **分组即容器嵌套**：缩进表示层级，天然表达公网 / 内网 / VPC 边界
- **跨容器引用写全路径**：`internet.client -> internet.lb`
- **用形状标注角色**：`{shape: person | queue | cylinder | cloud}`
- **只声明拓扑**，坐标交给布局引擎

## 分组与边界

```d2
internet: 公网 {
  client: 客户端 {shape: person}
  lb: 负载均衡 {shape: queue}
}

private_net: 内网 {
  api1: API 服务器 1
  api2: API 服务器 2
  db: 主数据库 {shape: cylinder}
}

internet.client -> internet.lb: HTTPS
internet.lb -> private_net.api1
internet.lb -> private_net.api2
private_net.api1 -> private_net.db
private_net.api2 -> private_net.db
```

## 完整示例：VPC 内的主从数据库

```d2
cloud: 云环境 {
  vpc: 私有 VPC {
    lb: 负载均衡 {shape: queue}
    api1: API 服务器 1
    api2: API 服务器 2
    db: 主数据库 {shape: cylinder}
    replica: 只读副本 {shape: cylinder}
  }
}

users: 用户 {shape: person}
users -> cloud.vpc.lb
cloud.vpc.lb -> cloud.vpc.api1
cloud.vpc.lb -> cloud.vpc.api2
cloud.vpc.api1 -> cloud.vpc.db
cloud.vpc.api2 -> cloud.vpc.db
cloud.vpc.db -> cloud.vpc.replica: 异步复制
```

## 技术栈图标（可选）

D2 可用 `icon` 标注技术图标，但远程图标需联网拉取，离线环境会渲染失败：

```d2
web: Docker 容器 {
  icon: https://icons.terrastruct.com/dev/docker.svg
}
```

## 部署流程怎么画

"流水线阶段推进"不属于拓扑，用 [flowcharts.md](flowcharts.md) 的流程图表达，不要用拓扑图硬套。

---

# 最佳实践

**C4 部分**

1. 按受众选层级：上下文图给干系人，容器图给架构师，组件图给开发者
2. 一张上下文图只画一个系统；一张组件图只画一个容器
3. 只画关键关系，不要把所有可能连接都堆上去
4. 各层级命名保持一致，便于跨层追溯
5. 容器/组件层标注技术栈与协议（REST、gRPC、AMQP 等）
6. 外部系统一律用 `*_Ext` 变体，一眼区分内外

**基础设施部分（D2）**

7. 按环境（公网/内网）或层次（前端/后端）用容器分组
8. 只声明拓扑关系，不手算坐标
9. 节点超过 15 个时改用 `d2 --layout elk`，或拆成多图
10. 保持单图聚焦，复杂架构拆成多个视图

## 相关参考

- D2 画大图 → [d2-essentials.md](d2-essentials.md)
- 请求级交互细节 → [sequence-diagrams.md](sequence-diagrams.md)
- 类与模块结构 → [class-diagrams.md](class-diagrams.md)
