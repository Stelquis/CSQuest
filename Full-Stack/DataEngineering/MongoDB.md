# [MongoDB从入门到精通：从文档模型、CRUD到索引、聚合、事务与分布式架构](https://mp.weixin.qq.com/s/nJQCYsydzdI6Q8zJmd2U2w)

> 这是一个关于"青梧小铺"的故事——刚起步的电商团队把订单数据全塞在一个巨大的 MySQL 宽表里，第一次大促就撞上了迁移、扩容和慢查询三重危机。新来的后端工程师沈舟接手存储架构，选择用 MongoDB 重建订单系统，并借此完成从"会调 insertOne()"到理解文档建模、索引、聚合、事务与分布式架构的完整成长。读完你会发现：MongoDB 的难点从来不是 API，而是围绕访问模式的数据设计。

---

很多人第一次接触 MongoDB，只记住了两句话："它是 NoSQL 数据库""它可以直接存 JSON"。
但真正进入生产环境后，你会发现：MongoDB 的难点从来不是 `insertOne()`，而是如何设计文档结构、如何建立正确的索引、如何理解查询计划、如何保证一致性，以及如何让系统在数据量增长后仍然稳定运行。

MongoDB 是一种面向文档的数据库。它使用 BSON 文档保存数据，支持灵活的数据模型、丰富的查询语言、聚合管道、多文档事务、复制集自动故障转移以及分片集群水平扩展。

截至 2026 年 7 月，MongoDB 官方文档将 8.3 系列列为当前稳定版本。实际部署时，不要机械照抄某个固定小版本号，而应选择适合自身支持策略的版本系列，并始终安装该系列的最新稳定补丁版本。

这篇文章将用一个"电商订单系统"贯穿讲解，带你完成从入门到生产实践的完整学习路径。

## 一、先建立全局认识：MongoDB究竟是什么

### 1. 关系型数据库的思维

在 MySQL、PostgreSQL 等关系型数据库中，数据通常被拆分到多张表：

- `users`：用户表
- `orders`：订单表
- `order_items`：订单明细表
- `products`：商品表

查询完整订单时，需要通过外键和 JOIN 将多张表关联起来。

### 2. MongoDB的思维

MongoDB 将一条业务记录保存为一个"文档"。一个订单文档可以长这样：

```javascript
{
  _id: ObjectId("..."),
  orderNo: "202607280001",
  user: {
    id: 10001,
    name: "小王"
  },
  items: [
    {
      sku: "KB-001",
      name: "机械键盘",
      price: Decimal128("499.00"),
      quantity: 1
    },
    {
      sku: "MS-002",
      name: "无线鼠标",
      price: Decimal128("199.00"),
      quantity: 2
    }
  ],
  totalAmount: Decimal128("897.00"),
  status: "PAID",
  createdAt: ISODate("2026-07-28T08:00:00Z")
}
```

用户摘要、商品快照和订单信息被放在同一个文档中。读取订单详情时，通常只需要一次查询。

这体现了 MongoDB 数据建模的核心思想：

> 经常一起读取的数据，尽量存放在一起；数据模型应围绕访问模式设计，而不是简单照搬关系型数据库的表结构。

### 3. MongoDB和MySQL不是谁取代谁

| 对比维度 | MongoDB | MySQL / PostgreSQL |
| --- | --- | --- |
| 数据模型 | BSON 文档 | 行、表、关系 |
| Schema | 灵活，可逐步演进 | 通常预先定义，约束明确 |
| 关联方式 | 嵌入、引用、$lookup | 外键、JOIN |
| 扩展方式 | 原生复制集与分片 | 主从、读写分离、分库分表等 |
| 事务支持 | 单文档原子操作和多文档事务 | 强项，成熟完整 |
| 典型优势 | 快速迭代、层次化数据、海量扩展 | 强关系、复杂约束、标准化数据 |

正确的问题不是"MongoDB 和 MySQL 哪个更好"，而是：

> 当前业务的数据形态、访问模式、一致性要求和扩展方式，更适合哪种数据库？

### 4. 适合MongoDB的场景

MongoDB 通常适合：

- 内容管理、文章、评论、商品目录；
- 用户画像、设备数据、事件数据；
- 结构经常变化的业务对象；
- 日志、埋点、物联网和时间序列数据；
- 需要高可用和水平扩展的在线业务；
- 原型开发后逐步扩展的互联网应用；
- 需要地理空间检索、全文检索或向量检索的应用。

### 5. 不要盲目使用MongoDB的场景

以下情况应谨慎评估：

- 数据之间存在大量强关系和复杂联表；
- 业务主要依赖复杂 SQL 报表；
- 数据模型高度稳定，且数据库级约束非常重要；
- 团队没有 MongoDB 运维、索引和分布式系统经验；
- 只是因为"不想设计表结构"而选择 MongoDB。

灵活 Schema 不等于没有 Schema。生产系统仍然需要字段规范、类型约束、版本演进和数据治理。

## 二、MongoDB的核心概念

### 1. 数据库、集合和文档

关系型数据库和 MongoDB 的概念可以粗略对应为：

| 关系型数据库 | MongoDB |
| --- | --- |
| Database | Database |
| Table | Collection |
| Row | Document |
| Column | Field |
| Primary Key | `_id` |
| Index | Index |
| JOIN | 嵌入、引用、$lookup |

MongoDB 的基本层级如下：

```text
MongoDB Server
└── Database
    └── Collection
        └── Document
            └── Field
```

### 2. BSON不是普通JSON

MongoDB 文档在展示时很像 JSON，但内部使用 BSON，也就是 Binary JSON。

BSON 支持比标准 JSON 更丰富的类型，例如：

- ObjectId
- Date
- Decimal128
- Int32
- Int64
- Binary
- 正则表达式
- 时间戳
- 数组和嵌套文档

因此，不要把所有数字都当成同一种类型，也不要把日期保存为普通字符串。

错误示例：

```javascript
{
  price: "499.00",
  createdAt: "2026-07-28 16:00:00"
}
```

更合理的示例：

```javascript
{
  price: Decimal128("499.00"),
  createdAt: ISODate("2026-07-28T08:00:00Z")
}
```

### 3. `_id`字段

每个 MongoDB 文档必须有 `_id` 字段，并且在集合内唯一。

如果插入时没有指定 `_id`，驱动或服务器通常会自动生成一个 ObjectId：

```javascript
{
  _id: ObjectId("68886f1f9f85b83301c2a001"),
  name: "MongoDB"
}
```

ObjectId 适合大多数通用场景，但并不意味着所有系统都必须使用它。业务也可以使用订单号、UUID 或其他唯一值作为 `_id`。

需要注意：一旦插入，文档的 `_id` 不能直接修改。

### 4. 文档大小限制

单个 BSON 文档最大为 16 MiB。超过该限制的大文件不应直接塞进一个普通文档，可使用对象存储，或在适合的场景下使用 GridFS。

这也提醒我们：

- 不要让数组无限增长；
- 不要把所有历史记录都嵌入一个用户文档；
- 不要把视频、压缩包等大文件直接作为单文档字段保存；
- 设计时 要考虑文档未来的增长上限。

## 三、搭建MongoDB学习环境

学习 MongoDB 有三种常见方式：

1. MongoDB Atlas 云数据库；
2. Docker 本地运行；
3. 在 Windows、macOS 或 Linux 上原生安装。

### 1. 使用MongoDB Atlas

Atlas 是 MongoDB 官方的托管云服务，适合不想自己安装和运维的开发者。

基本流程：

1. 注册 Atlas；
2. 创建项目和集群；
3. 创建数据库用户；
4. 配置网络访问白名单；
5. 获取连接字符串；
6. 使用 mongosh、Compass 或应用驱动连接。

连接字符串通常类似：

```text
mongodb+srv://appUser:<password>@cluster0.example.mongodb.net/shop
```

生产环境不要把用户名和密码硬编码进源代码，应通过环境变量或密钥管理系统注入。

### 2. 使用Docker启动

本地学习最方便的方式之一是 Docker：

```bash
docker run -d \
  --name mongodb \
  -p 27017:27017 \
  -v mongodb_data:/data/db \
  -e MONGO_INITDB_ROOT_USERNAME=root \
  -e MONGO_INITDB_ROOT_PASSWORD='ChangeThisPassword' \
  mongo:8.3
```

连接：

```bash
mongosh "mongodb://root:ChangeThisPassword@localhost:27017/admin"
```

更适合长期使用的 `compose.yaml`：

```yaml
services:
  mongodb:
    image: mongo:8.3
    container_name: mongodb
    restart: unless-stopped
    ports:
      - "127.0.0.1:27017:27017"
    environment:
      MONGO_INITDB_ROOT_USERNAME: root
      MONGO_INITDB_ROOT_PASSWORD: ChangeThisPassword
    volumes:
      - mongodb_data:/data/db

volumes:
  mongodb_data:
```

启动：

```bash
docker compose up -d
```

这里将端口绑定到 127.0.0.1，可避免数据库直接暴露到公网。

### 3. macOS使用Homebrew

MongoDB 官方提供 Homebrew Tap。安装命令会随版本变化，建议以官方安装页面为准。常见流程如下：

```bash
brew tap mongodb/brew
brew install mongodb-community
brew services start mongodb-community
```

连接：

```bash
mongosh
```

### 4. Windows安装

Windows 可使用官方 MSI 安装程序。安装时通常可以选择将 MongoDB 注册为 Windows 服务，并安装 MongoDB Compass。

安装完成后，可在终端执行：

```bash
mongosh
```

### 5. Ubuntu安装

Ubuntu 应使用 MongoDB 官方软件源，而不是直接依赖系统仓库中可能过旧的包。

由于发行版和 MongoDB 版本不同，仓库地址、签名密钥和包名可能变化，应按照官方对应版本安装文档操作。

### 6. 推荐的学习工具

- mongosh：官方命令行 Shell；
- MongoDB Compass：图形化管理工具；
- VS Code MongoDB 扩展：在编辑器中连接数据库；
- 语言驱动：Node.js、Python、Java、Go、C# 等。

## 四、mongosh快速入门

### 1. 查看数据库

```javascript
show dbs
```

### 2. 切换数据库

```javascript
use shop
```

如果数据库不存在，MongoDB 不会立即在磁盘上创建它。通常要等到第一次写入数据后才真正出现。

### 3. 查看当前数据库

```javascript
db
```

### 4. 查看集合

```javascript
show collections
```

### 5. 创建集合

```javascript
db.createCollection("products")
```

通常不需要手动创建集合。第一次插入数据时，MongoDB 可以自动创建。

### 6. 删除集合和数据库

```javascript
db.products.drop()
db.dropDatabase()
```

删除操作不可逆，生产环境执行前必须确认数据库、集合和连接地址。

## 五、CRUD：掌握MongoDB最基本的操作

我们先向 `products` 集合插入商品数据。

### 1. 插入一条文档

```javascript
db.products.insertOne({
  sku: "KB-001",
  name: "机械键盘",
  category: "keyboard",
  price: NumberDecimal("499.00"),
  stock: 120,
  tags: ["机械轴", "有线", "RGB"],
  specs: {
    switch: "青轴",
    layout: "87键"
  },
  isActive: true,
  createdAt: new Date()
})
```

### 2. 插入多条文档

```javascript
db.products.insertMany([
  {
    sku: "MS-001",
    name: "有线鼠标",
    category: "mouse",
    price: NumberDecimal("99.00"),
    stock: 300,
    tags: ["有线", "办公"],
    isActive: true,
    createdAt: new Date()
  },
  {
    sku: "MS-002",
    name: "无线鼠标",
    category: "mouse",
    price: NumberDecimal("199.00"),
    stock: 180,
    tags: ["无线", "蓝牙"],
    isActive: true,
    createdAt: new Date()
  },
  {
    sku: "MON-001",
    name: "27英寸显示器",
    category: "monitor",
    price: NumberDecimal("1599.00"),
    stock: 50,
    tags: ["4K", "IPS"],
    isActive: true,
    createdAt: new Date()
  }
])
```

### 3. 查询全部文档

```javascript
db.products.find()
```

### 4. 条件查询

```javascript
db.products.find({ category: "mouse" })
```

### 5. 查询单条文档

```javascript
db.products.findOne({ sku: "KB-001" })
```

### 6. 字段投影

只返回商品名和价格：

```javascript
db.products.find(
  { category: "mouse" },
  { _id: 0, name: 1, price: 1 }
)
```

投影规则要点：

- `1` 表示包含字段；
- `0` 表示排除字段；
- 除 `_id` 外，不应在同一个普通投影中混合包含和排除模式。

### 7. 排序、分页和限制

按价格降序：

```javascript
db.products.find().sort({ price: -1 })
```

跳过前 10 条，取 10 条：

```javascript
db.products.find().sort({ _id: 1 }).skip(10).limit(10)
```

`skip()` 在页数很深时会越来越慢。大数据分页更适合使用游标式分页：

```javascript
db.products.find({
  _id: { $gt: ObjectId("68886f1f9f85b83301c2a001") }
}).sort({ _id: 1 }).limit(10)
```

### 8. 更新一条文档

```javascript
db.products.updateOne(
  { sku: "KB-001" },
  {
    $set: { "specs.switch": "茶轴" },
    $inc: { stock: -1 },
    $currentDate: { updatedAt: true }
  }
)
```

### 9. 更新多条文档

```javascript
db.products.updateMany(
  { category: "mouse" },
  { $set: { promotion: true } }
)
```

### 10. Upsert

当数据存在时更新，不存在时插入：

```javascript
db.products.updateOne(
  { sku: "PAD-001" },
  {
    $set: {
      name: "桌面鼠标垫",
      category: "accessory",
      price: NumberDecimal("39.00"),
      stock: 500,
      isActive: true
    },
    $setOnInsert: {
      createdAt: new Date()
    }
  },
  { upsert: true }
)
```

### 11. 删除文档

```javascript
db.products.deleteOne({ sku: "PAD-001" })
db.products.deleteMany({ isActive: false })
```

不要在生产环境随意执行空条件删除：

```javascript
// 极度危险：删除集合中的全部文档
db.products.deleteMany({})
```

## 六、查询操作符：写出真正有用的查询

### 1. 比较操作符

```javascript
db.products.find({ price: { $gt: NumberDecimal("100.00") } })
```

常用操作符：

| 操作符 | 含义 |
| --- | --- |
| $eq | 等于 |
| $ne | 不等于 |
| $gt | 大于 |
| $gte | 大于等于 |
| $lt | 小于 |
| $lte | 小于等于 |
| $in | 在指定集合中 |
| $nin | 不在指定集合中 |

例如：

```javascript
db.products.find({
  category: { $in: ["mouse", "keyboard"] },
  stock: { $gte: 100 }
})
```

### 2. 逻辑操作符

```javascript
db.products.find({
  $or: [
    { price: { $lt: NumberDecimal("100.00") } },
    { stock: { $lt: 60 } }
  ]
})
```

常用逻辑操作符：`$and`、`$or`、`$nor`、`$not`。

很多情况下不需要显式写 `$and`：

```javascript
db.products.find({
  category: "mouse",
  stock: { $gt: 100 }
})
```

### 3. 查询嵌套字段

```javascript
db.products.find({ "specs.switch": "茶轴" })
```

点号路径是 MongoDB 中非常重要的语法。

### 4. 查询数组

包含某个标签：

```javascript
db.products.find({ tags: "无线" })
```

同时包含多个标签：

```javascript
db.products.find({ tags: { $all: ["无线", "蓝牙"] } })
```

按数组长度查询：

```javascript
db.products.find({ tags: { $size: 2 } })
```

### 5. `$elemMatch`

假设订单中有多个商品：

```javascript
{
  orderNo: "202607280001",
  items: [
    { sku: "KB-001", price: 499, quantity: 1 },
    { sku: "MS-002", price: 199, quantity: 2 }
  ]
}
```

查询"同一个数组元素中，价格大于 300 且数量大于等于 1"的订单：

```javascript
db.orders.find({
  items: {
    $elemMatch: {
      price: { $gt: 300 },
      quantity: { $gte: 1 }
    }
  }
})
```

没有 `$elemMatch` 时，多个条件可能分别命中不同数组元素，从而得到不符合业务语义的结果。

### 6. 字段存在和类型判断

```javascript
db.products.find({ promotion: { $exists: true } })
db.products.find({ stock: { $type: "int" } })
```

### 7. 正则表达式

```javascript
db.products.find({
  name: { $regex: "鼠标", $options: "i" }
})
```

正则查询要谨慎。无法使用有效索引的模糊匹配容易触发全表扫描。面向搜索的业务应考虑专门的全文检索能力，而不是把复杂搜索全部压在普通正则上。

## 七、更新操作符与单文档原子性

MongoDB 的单文档写操作具有原子性。也就是说，即使一次更新修改了文档中的多个字段，其他客户端也不会看到"只改了一半"的中间状态。

### 1. 常用字段更新操作符

```javascript
db.products.updateOne(
  { sku: "KB-001" },
  {
    $set: { isActive: true },
    $unset: { oldField: "" },
    $rename: { desc: "description" },
    $inc: { stock: 10 },
    $mul: { score: 1.1 },
    $min: { lowestPrice: NumberDecimal("399.00") },
    $max: { highestPrice: NumberDecimal("599.00") }
  }
)
```

### 2. 数组更新操作符

添加元素：

```javascript
db.products.updateOne(
  { sku: "KB-001" },
  { $push: { tags: "热销" } }
)
```

避免重复：

```javascript
db.products.updateOne(
  { sku: "KB-001" },
  { $addToSet: { tags: "热销" } }
)
```

删除指定元素：

```javascript
db.products.updateOne(
  { sku: "KB-001" },
  { $pull: { tags: "有线" } }
)
```

弹出首尾元素：

```javascript
// 删除最后一个元素
db.products.updateOne(
  { sku: "KB-001" },
  { $pop: { tags: 1 } }
)
```

### 3. 带条件扣减库存

不要先查询库存，再单独执行扣减。两个请求可能同时读到相同库存，造成超卖。

更安全的做法是把判断条件放入更新过滤器：

```javascript
const result = db.products.updateOne(
  {
    sku: "KB-001",
    stock: { $gte: 2 }
  },
  {
    $inc: { stock: -2 }
  }
)
```

然后检查 `matchedCount` 或 `modifiedCount`。如果为 0，说明库存不足或商品不存在。

这种模式利用了单文档原子性，比"查询后再更新"更可靠。

### 4. 数组过滤器

更新订单中某个商品项：

```javascript
db.orders.updateOne(
  { orderNo: "202607280001" },
  {
    $set: {
      "items.$[item].quantity": 3
    }
  },
  {
    arrayFilters: [
      { "item.sku": "MS-002" }
    ]
  }
)
```

## 八、数据建模：MongoDB真正的核心能力

会写 CRUD，只能算"会使用 MongoDB"；会根据访问模式设计文档，才算真正入门。

### 1. 嵌入还是引用

MongoDB 中的关联关系主要有两种表达方式：

- 嵌入：把相关数据放进同一个文档；
- 引用：在文档中保存另一个文档的 `_id` 或业务标识。

嵌入示例：

```javascript
{
  orderNo: "202607280001",
  shippingAddress: {
    receiver: "小王",
    phone: "138****0000",
    province: "浙江省",
    city: "绍兴市",
    detail: "某某路 1 号"
  }
}
```

订单地址应该保存下单时的快照。即使用户后来修改默认地址，历史订单也不能随之变化，因此适合嵌入。

引用示例：

```javascript
{
  userId: ObjectId("..."),
  productId: ObjectId("..."),
  createdAt: new Date()
}
```

当数据会被很多对象共享、独立更新，或者体积会无限增长时，引用通常更合适。

### 2. 适合嵌入的情况

- 数据总是一起读取；
- 子数据依赖父数据存在；
- 子数据数量有明确上限；
- 需要单文档原子更新；
- 希望减少跨集合查询。

### 3. 适合引用的情况

- 子数据数量可能无限增长；
- 数据被多个文档共享；
- 数据更新频繁，不能接受大量冗余修改；
- 需要独立访问和独立生命周期；
- 嵌入后可能接近 16 MiB 限制。

### 4. 冗余不是错误，失控的冗余才是错误

在关系型数据库中，我们倾向于规范化，尽量减少重复数据。

在 MongoDB 中，为了提升读取性能，可以有意识地保存冗余字段。例如订单项中同时保存：

```javascript
{
  productId: ObjectId("..."),
  sku: "KB-001",
  productName: "机械键盘",
  unitPrice: NumberDecimal("499.00")
}
```

这里的商品名和价格不是"重复垃圾"，而是下单时的业务快照。

### 5. 避免无限增长数组

危险模型：

```javascript
{
  userId: 10001,
  loginLogs: [
    // 数年内不断追加，可能越来越大
  ]
}
```

更合理的方式：

- 单独建立 `login_logs` 集合；
- 按月份分桶；
- 只在用户文档中保留最近若干条；
- 将完整日志写入专门的日志或分析系统。

### 6. Schema验证

灵活 Schema 并不妨碍我们为关键集合添加验证规则：

```javascript
db.createCollection("users", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["name", "email", "createdAt"],
      properties: {
        name: {
          bsonType: "string",
          minLength: 1,
          description: "用户名必须是非空字符串"
        },
        email: {
          bsonType: "string",
          description: "邮箱必须是字符串"
        },
        age: {
          bsonType: ["int", "null"],
          minimum: 0,
          maximum: 150
        },
        createdAt: {
          bsonType: "date"
        }
      }
    }
  },
  validationLevel: "strict",
  validationAction: "error"
})
```

需要注意：数据库验证不能替代应用层验证。合理做法是两层都做：

- 应用层提供友好的错误提示；
- 数据库层守住最终数据底线。

### 7. Schema版本迁移

MongoDB 结构可以演进，但仍应进行版本管理：

```javascript
{
  schemaVersion: 2,
  name: "小王",
  contact: {
    email: "user@example.com",
    phone: "13800000000"
  }
}
```

常见迁移策略：

1. 读时兼容：代码同时兼容旧字段和新字段；
2. 写新读旧：新写入使用新结构，读取兼容旧结构；
3. 后台回填：分批迁移历史文档；
4. 双写过渡：短期内同时写新旧字段；
5. 完成后清理：确认无旧客户端后删除旧字段。

不要一次性对超大集合执行无条件全量更新，应按 `_id` 或时间范围分批处理，并观察复制延迟、磁盘、锁和业务延迟。

## 九、索引：MongoDB性能的分水岭

没有索引时，MongoDB 可能需要扫描集合中的大量文档。数据量小时不明显，数据增长后延迟会快速恶化。

### 1. 查看索引

```javascript
db.products.getIndexes()
```

每个集合默认都会有 `_id` 唯一索引。

### 2. 单字段索引

```javascript
db.products.createIndex({ sku: 1 })
```

`1` 表示升序，`-1` 表示降序。对于单字段等值查询，方向通常不重要；对于排序和复合索引，方向可能影响可用性。

### 3. 唯一索引

```javascript
db.products.createIndex(
  { sku: 1 },
  { unique: true, name: "uk_products_sku" }
)
```

唯一索引既能加速查询，也能在数据库层防止重复值。

### 4. 复合索引

假设高频查询是：

```javascript
db.orders.find({
  userId: ObjectId("..."),
  status: "PAID"
}).sort({ createdAt: -1 })
```

可以建立：

```javascript
db.orders.createIndex({
  userId: 1,
  status: 1,
  createdAt: -1
})
```

复合索引字段顺序非常重要。

实务中常使用 ESR 思路作为起点：

- Equality：等值过滤字段；
- Sort：排序字段；
- Range：范围查询字段。

但 ESR 是经验法则，不是无需测试的绝对定律。最终仍要根据真实查询、数据分布和 `explain()` 结果决定。

### 5. 最左前缀

索引：

```javascript
{ userId: 1, status: 1, createdAt: -1 }
```

通常可以有效支持：

```javascript
{ userId: ... }
{ userId: ..., status: ... }
{ userId: ..., status: ... } + sort(createdAt)
```

但只按 `status` 查询时，通常无法充分利用该索引的前缀结构。

### 6. 多键索引

当索引字段是数组时，MongoDB 会建立多键索引：

```javascript
db.products.createIndex({ tags: 1 })
```

一个文档中的多个数组元素会生成多个索引键。数组过大时，索引体积和写入成本也会增大。

### 7. TTL索引

自动清理过期会话：

```javascript
db.sessions.createIndex(
  { expireAt: 1 },
  { expireAfterSeconds: 0 }
)
```

文档：

```javascript
{
  token: "...",
  expireAt: ISODate("2026-07-29T08:00:00Z")
}
```

TTL 删除不是严格的定时任务，过期文档通常会在后台监控周期内被清理，不应依赖它实现毫秒级准时过期。

### 8. 部分索引

只为有效商品建立索引：

```javascript
db.products.createIndex(
  { category: 1, price: 1 },
  {
    partialFilterExpression: {
      isActive: true
    }
  }
)
```

部分索引可以减少索引体积和维护成本，但查询条件必须与部分过滤条件相容，优化器才能使用它。

### 9. 稀疏索引与通配符索引

稀疏索引只包含拥有被索引字段的文档：

```javascript
db.users.createIndex(
  { optionalCode: 1 },
  { sparse: true }
)
```

通配符索引适合字段结构变化较大的文档：

```javascript
db.products.createIndex({ "attributes.$**": 1 })
```

通配符索引不是"给所有字段无脑加索引"的替代品。稳定的高频查询仍应建立明确的普通索引。

### 10. 地理空间索引

保存 GeoJSON 点：

```javascript
{
  name: "绍兴仓库",
  location: {
    type: "Point",
    coordinates: [120.58, 30.01]
  }
}
```

建立索引：

```javascript
db.warehouses.createIndex({ location: "2dsphere" })
```

查询附近仓库：

```javascript
db.warehouses.find({
  location: {
    $near: {
      $geometry: {
        type: "Point",
        coordinates: [120.60, 30.00]
      },
      $maxDistance: 10000
    }
  }
})
```

GeoJSON 坐标顺序是 经度在前、纬度在后。

### 11. 索引不是越多越好

每增加一个索引，都意味着：

- 插入时需要额外写索引；
- 更新索引字段时需要维护索引；
- 占用更多磁盘和内存；
- 备份、恢复和重建时间增加；
- 优化器需要在更多候选计划中选择。

索引设计应围绕真实查询，而不是围绕字段列表。

## 十、用explain读懂查询计划

### 1. 查看执行统计

```javascript
db.orders.find({
  userId: ObjectId("..."),
  status: "PAID"
}).sort({ createdAt: -1 }).explain("executionStats")
```

重点关注：

- `winningPlan`：最终选择的执行计划；
- `totalKeysExamined`：扫描的索引键数量；
- `totalDocsExamined`：扫描的文档数量；
- `nReturned`：返回的文档数量；
- `executionTimeMillis`：执行耗时；
- 是否出现 `COLLSCAN`；
- 是否出现额外 `SORT`；
- 是否使用 `IXSCAN`。

### 2. 常见阶段

| 阶段 | 含义 |
| --- | --- |
| COLLSCAN | 全集合扫描 |
| IXSCAN | 索引扫描 |
| FETCH | 根据索引结果读取完整文档 |
| SORT | 内存或磁盘排序 |
| LIMIT | 限制返回数量 |
| PROJECTION_COVERED | 覆盖查询，无需读取完整文档 |

### 3. 不能只看"是否走索引"

走索引不等于查询一定快。

假设返回 10 条数据，却扫描了 100 万个索引键，这仍然可能很慢。

一个健康查询通常希望：

```text
totalKeysExamined ≈ nReturned
totalDocsExamined ≈ nReturned
```

当然，范围查询、低选择性字段和业务条件不同，不能机械要求完全相等。

### 4. 覆盖查询

索引：

```javascript
db.products.createIndex({ category: 1, price: 1, name: 1 })
```

查询：

```javascript
db.products.find(
  { category: "mouse" },
  { _id: 0, price: 1, name: 1 }
)
```

如果过滤字段和返回字段都可以从索引中获得，MongoDB 可能不需要读取原始文档，这就是覆盖查询。

## 十一、聚合管道：MongoDB的数据处理引擎

聚合管道由多个阶段组成，数据像流水一样经过每个阶段：

```text
原始文档
  ↓ $match
过滤后的文档
  ↓ $group
分组统计结果
  ↓ $sort
排序结果
  ↓ $project
最终输出
```

### 1. 基本聚合示例

统计每种订单状态的数量和金额：

```javascript
db.orders.aggregate([
  {
    $group: {
      _id: "$status",
      orderCount: { $sum: 1 },
      totalAmount: { $sum: "$totalAmount" }
    }
  },
  {
    $sort: {
      totalAmount: -1
    }
  }
])
```

### 2. $match尽量前置

统计 2026 年 7 月已支付订单：

```javascript
db.orders.aggregate([
  {
    $match: {
      status: "PAID",
      createdAt: {
        $gte: ISODate("2026-07-01T00:00:00Z"),
        $lt: ISODate("2026-08-01T00:00:00Z")
      }
    }
  },
  {
    $group: {
      _id: null,
      orderCount: { $sum: 1 },
      revenue: { $sum: "$totalAmount" },
      avgOrderValue: { $avg: "$totalAmount" }
    }
  }
])
```

越早过滤，后续阶段要处理的数据通常越少。管道开头的 `$match` 也更有机会利用索引。

### 3. $project

```javascript
db.orders.aggregate([
  {
    $project: {
      _id: 0,
      orderNo: 1,
      status: 1,
      itemCount: { $size: "$items" },
      totalAmount: 1,
      orderDate: {
        $dateToString: {
          format: "%Y-%m-%d",
          date: "$createdAt",
          timezone: "Asia/Shanghai"
        }
      }
    }
  }
])
```

### 4. $unwind

订单中的 `items` 是数组。要统计每个 SKU 的销量，需要先展开：

```javascript
db.orders.aggregate([
  { $match: { status: "PAID" } },
  { $unwind: "$items" },
  {
    $group: {
      _id: "$items.sku",
      productName: { $first: "$items.name" },
      salesQuantity: { $sum: "$items.quantity" },
      salesAmount: {
        $sum: {
          $multiply: ["$items.price", "$items.quantity"]
        }
      }
    }
  },
  { $sort: { salesQuantity: -1 } },
  { $limit: 10 }
])
```

### 5. $lookup

用户集合：

```javascript
{
  _id: ObjectId("..."),
  name: "小王",
  level: "VIP"
}
```

订单集合：

```javascript
{
  orderNo: "202607280001",
  userId: ObjectId("..."),
  totalAmount: NumberDecimal("897.00")
}
```

关联查询：

```javascript
db.orders.aggregate([
  {
    $lookup: {
      from: "users",
      localField: "userId",
      foreignField: "_id",
      as: "user"
    }
  },
  {
    $unwind: {
      path: "$user",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $project: {
      orderNo: 1,
      totalAmount: 1,
      userName: "$user.name",
      userLevel: "$user.level"
    }
  }
])
```

`$lookup` 很强大，但不要因此完全照搬关系型数据库的高度规范化模型。频繁跨集合关联可能增加系统复杂度和资源消耗。

### 6. $facet

一次聚合同时得到分页数据和总数：

```javascript
db.products.aggregate([
  {
    $match: {
      isActive: true,
      category: "mouse"
    }
  },
  {
    $facet: {
      metadata: [
        { $count: "total" }
      ],
      data: [
        { $sort: { createdAt: -1 } },
        { $skip: 0 },
        { $limit: 20 },
        {
          $project: {
            name: 1,
            price: 1,
            stock: 1
          }
        }
      ]
    }
  }
])
```

### 7. 窗口函数

计算每个分类中的商品价格排名：

```javascript
db.products.aggregate([
  {
    $setWindowFields: {
      partitionBy: "$category",
      sortBy: { price: -1 },
      output: {
        priceRank: {
          $denseRank: {}
        }
      }
    }
  },
  {
    $project: {
      name: 1,
      category: 1,
      price: 1,
      priceRank: 1
    }
  }
])
```

### 8. 聚合优化原则

- 尽早 `$match`；
- 尽早减少不需要的字段；
- 为 `$match` 和 `$sort` 设计合适索引；
- 小心 `$unwind` 导致数据量爆炸；
- `$lookup` 的关联字段要有索引；
- 大排序和大分组要关注内存及磁盘临时文件；
- 使用 `explain()` 检查管道执行计划；
- 不要把所有离线分析任务都放在业务主库上执行。

## 十二、多文档事务与一致性

### 1. 什么时候不需要事务

MongoDB 的单文档写操作具有原子性。如果能把需要一起更新的数据设计到一个文档中，通常不需要多文档事务。

例如，订单状态、支付信息摘要和订单操作时间都在同一个订单文档里时，可以一次原子更新。

### 2. 什么时候需要事务

典型场景：

- 创建订单，同时扣减多个商品库存；
- 账户 A 扣款，账户 B 入账；
- 同时修改多个集合，且必须全部成功或全部失败；
- 数据模型无法通过单文档原子性满足一致性要求。

### 3. mongosh事务示例

多文档事务需要在复制集或分片集群上运行，不能依赖普通独立节点完成完整事务能力。

```javascript
const session = db.getMongo().startSession()
const shopDb = session.getDatabase("shop")

try {
  session.startTransaction({
    readConcern: { level: "snapshot" },
    writeConcern: { w: "majority" }
  })

  const productResult = shopDb.products.updateOne(
    {
      sku: "KB-001",
      stock: { $gte: 1 }
    },
    {
      $inc: { stock: -1 }
    }
  )

  if (productResult.modifiedCount !== 1) {
    throw new Error("库存不足")
  }

  shopDb.orders.insertOne({
    orderNo: "202607280002",
    sku: "KB-001",
    quantity: 1,
    status: "CREATED",
    createdAt: new Date()
  })

  session.commitTransaction()
} catch (error) {
  session.abortTransaction()
  throw error
} finally {
  session.endSession()
}
```

生产代码应使用驱动提供的事务回调和重试机制，因为事务提交、主节点切换和网络抖动可能产生可重试错误。

### 4. 不要滥用事务

事务会带来：

- 更长的资源占用时间；
- 更复杂的错误处理；
- 更高的冲突概率；
- 对复制和分片的额外协调成本；
- 长事务可能影响缓存、快照和系统吞吐。

优先级通常是：

1. 通过文档建模使用单文档原子性；
2. 使用幂等、唯一索引和条件更新；
3. 确有必要时再使用多文档事务。

### 5. Write Concern

写关注决定"写到什么程度才算成功"。

```javascript
{ w: "majority", j: true, wtimeout: 5000 }
```

常见含义：

- `w: 1`：主节点确认；
- `w: "majority"`：多数投票节点确认；
- `j: true`：等待日志落盘确认；
- `wtimeout`：等待超时时间。

更强确认通常意味着更高可靠性，也可能增加延迟。

### 6. Read Concern与Read Preference

Read Concern 关注"读到的数据一致性等级"；Read Preference 关注"从哪个节点读取"。

常见 Read Preference：

- primary
- primaryPreferred
- secondary
- secondaryPreferred
- nearest

从 Secondary 读取可能降低主节点压力，但也可能读到稍旧的数据。是否可接受取决于业务语义。

## 十三、复制集：高可用的基础

复制集是一组保存相同数据集的 `mongod` 实例。

典型三节点架构：

```text
              ┌──────────────┐
写请求 ──────>│   Primary    │
              └──────┬───────┘
                     │ oplog
            ┌────────┴────────┐
            ↓                 ↓
    ┌──────────────┐  ┌──────────────┐
    │  Secondary   │  │  Secondary   │
    └──────────────┘  └──────────────┘
```

### 1. Primary和Secondary

- Primary 接收写请求；
- Secondary 通过操作日志复制变更；
- Primary 故障后，符合条件的成员会发起选举；
- 新 Primary 产生后，驱动可自动重新选择服务器。

### 2. 为什么推荐三个数据节点

三成员复制集可以在一个节点故障时保留多数派。常见推荐是：

```text
Primary + Secondary + Secondary
```

在成本受限时，也可以使用仲裁节点参与投票，但仲裁节点不保存数据。生产环境优先考虑三个数据节点，因为它提供更完整的数据冗余。

### 3. 本地创建学习用复制集

创建三个数据目录：

```bash
mkdir -p ~/mongodb-rs/{db1,db2,db3}
```

分别启动：

```bash
mongod --replSet rs0 --port 27017 --dbpath ~/mongodb-rs/db1 --bind_ip localhost
mongod --replSet rs0 --port 27018 --dbpath ~/mongodb-rs/db2 --bind_ip localhost
mongod --replSet rs0 --port 27019 --dbpath ~/mongodb-rs/db3 --bind_ip localhost
```

连接一个节点：

```bash
mongosh --port 27017
```

初始化：

```javascript
rs.initiate({
  _id: "rs0",
  members: [
    { _id: 0, host: "localhost:27017" },
    { _id: 1, host: "localhost:27018" },
    { _id: 2, host: "localhost:27019" }
  ]
})
```

查看状态：

```javascript
rs.status()
```

连接字符串：

```text
mongodb://localhost:27017,localhost:27018,localhost:27019/shop?replicaSet=rs0
```

这只是本地学习配置。生产环境必须配置认证、TLS、持久化、独立机器、故障域和监控。

### 4. 复制延迟

Secondary 异步复制 Primary 的操作。以下情况可能导致复制延迟：

- Secondary 磁盘性能不足；
- 大批量写入；
- 长时间占用资源的查询；
- 网络延迟或丢包；
- 索引不一致或节点配置不合理；
- oplog 窗口不足。

必须持续监控复制延迟、oplog 时间窗口和成员状态。

## 十四、分片：当单机容量和吞吐到达极限

分片是把数据分布到多台机器上的方法。

典型结构：

```text
                ┌─────────────┐
客户端 ─────────>│   mongos    │ 查询路由
                └──────┬──────┘
                       │
          ┌─────────────┼─────────────┐
          ↓             ↓             ↓
      Shard A       Shard B       Shard C
    复制集节点组   复制集节点组   复制集节点组

          Config Server Replica Set
              保存集群元数据
```

### 1. 什么时候考虑分片

- 数据量超过单个复制集的存储能力；
- 工作集远大于单机内存；
- 单节点 CPU、磁盘 I/O 或网络成为瓶颈；
- 写入吞吐无法继续纵向扩容；
- 业务需要跨区域或大规模水平扩展。

不要因为数据只有几 GB 就急着上分片。分片会显著提高部署、监控、备份、故障处理和查询分析的复杂度。

### 2. 分片键决定集群上限

分片键决定文档如何分布。一个糟糕的分片键可能导致：

- 数据分布不均；
- 热点分片；
- 写请求集中到单个分片；
- 大量广播查询；
- 块迁移频繁；
- 后期调整成本高。

### 3. 分片键选择原则

理想分片键通常需要综合考虑：

- 基数高：可取值足够多；
- 分布均匀：数据不会集中；
- 查询隔离性好：高频查询携带分片键；
- 写入分散：避免单调递增造成持续热点；
- 未来稳定：字段不会频繁变化。

### 4. 范围分片和哈希分片

范围分片有利于范围查询，但单调递增键可能造成写热点。

哈希分片可以让写入更均匀：

```javascript
sh.shardCollection(
  "shop.events",
  { userId: "hashed" }
)
```

代价是连续范围查询可能需要访问多个分片。

### 5. 定向查询与广播查询

如果查询包含完整分片键，`mongos` 往往可以将请求路由到特定分片。

如果没有分片键信息，查询可能被发送到多个分片，再汇总结果，这称为 scatter-gather。少量广播并不可怕，但高频核心查询长期广播会显著消耗资源。

## 十五、安全：绝不能把MongoDB裸奔在公网

MongoDB 安全事故常常不是数据库漏洞，而是错误配置：

- 没有启用认证；
- 监听所有网卡；
- 直接暴露 27017；
- 使用弱密码；
- 应用使用超级管理员账户；
- 没有 TLS；
- 没有备份或审计。

### 1. 创建管理员

在安全的初始化环境中：

```javascript
use admin

db.createUser({
  user: "siteAdmin",
  pwd: passwordPrompt(),
  roles: [
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "readWriteAnyDatabase", db: "admin" },
    { role: "clusterAdmin", db: "admin" }
  ]
})
```

实际生产中，应根据职责拆分管理员角色，而不是让所有管理员都拥有全部权限。

### 2. 为应用创建最小权限账户

```javascript
use shop

db.createUser({
  user: "shopApp",
  pwd: passwordPrompt(),
  roles: [
    { role: "readWrite", db: "shop" }
  ]
})
```

连接：

```text
mongodb://shopApp:<password>@db1.example.com:27017/shop?authSource=shop
```

### 3. 限制网络暴露

配置文件示例：

```yaml
net:
  port: 27017
  bindIp: 127.0.0.1,10.0.0.10

security:
  authorization: enabled
```

只允许应用服务器所在内网访问。数据库不应直接对整个互联网开放。

### 4. 使用TLS

TLS 用于加密客户端和服务器之间的网络流量。生产环境应使用受信任证书，并验证服务器身份。

概念性配置：

```yaml
net:
  tls:
    mode: requireTLS
    certificateKeyFile: /etc/mongodb/server.pem
    CAFile: /etc/mongodb/ca.pem
```

### 5. 凭据管理

不要这样写：

```javascript
const uri = "mongodb://admin:123456@db.example.com/admin"
```

应该使用环境变量或密钥服务：

```javascript
const uri = process.env.MONGODB_URI
```

并确保：

- 日志不打印完整 URI；
- CI/CD 不泄露凭据；
- 不把 `.env` 提交到 Git；
- 定期轮换密码和证书；
- 不同环境使用不同账户。

### 6. 安全检查清单

- 启用认证和访问控制；
- 使用基于角色的最小权限；
- 限制监听地址和防火墙规则；
- 启用 TLS；
- 使用强密码或证书认证；
- 更新到受支持的稳定补丁版本；
- 开启必要的审计和日志；
- 对敏感字段实施加密策略；
- 定期进行恢复演练；
- 监控异常登录和权限变更。

## 十六、备份、恢复与灾难演练

没有验证过恢复流程的备份，不算可靠备份。

### 1. mongodump

```bash
mongodump \
  --uri="mongodb://backupUser:password@localhost:27017/shop?authSource=admin" \
  --out="./backup-20260728"
```

压缩为归档：

```bash
mongodump \
  --uri="$MONGODB_URI" \
  --archive="shop-20260728.archive" \
  --gzip
```

### 2. mongorestore

```bash
mongorestore \
  --uri="$MONGODB_URI" \
  --archive="shop-20260728.archive" \
  --gzip
```

恢复前应确认：

- 目标集群和目标数据库；
- 是否需要 `--drop`；
- 是否会覆盖现有数据；
- 用户、角色和索引是否完整；
- 应用是否需要停写或进入维护模式。

### 3. 逻辑备份并不适合所有规模

`mongodump` 适合中小规模数据、迁移和逻辑导出，但大型生产集群通常还需要：

- 存储快照；
- 云厂商或 Atlas 连续备份；
- 时间点恢复；
- 跨区域备份；
- 自动保留策略；
- 定期恢复验证。

### 4. 定义RPO和RTO

- RPO：最多能接受丢失多长时间的数据；
- RTO：故障后最多允许多长时间恢复服务。

只有明确 RPO 和 RTO，才能设计正确的复制、备份和灾难恢复方案。

## 十七、Node.js连接MongoDB

安装驱动：

```bash
npm install mongodb
```

### 1. 建立连接

```javascript
import { MongoClient } from "mongodb"

const uri = process.env.MONGODB_URI

if (!uri) {
  throw new Error("缺少 MONGODB_URI 环境变量")
}

const client = new MongoClient(uri, {
  maxPoolSize: 20,
  minPoolSize: 2,
  serverSelectionTimeoutMS: 5000
})

async function main() {
  try {
    await client.connect()

    const db = client.db("shop")
    const products = db.collection("products")

    const product = await products.findOne({ sku: "KB-001" })
    console.log(product)
  } finally {
    await client.close()
  }
}

main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})
```

### 2. Web服务中不要每次请求都创建连接

错误模式：

```javascript
app.get("/products", async (req, res) => {
  const client = new MongoClient(uri)
  await client.connect()
  // 每个请求都重新创建连接，性能和资源使用会很差
})
```

正确思路：

- 应用启动时创建 MongoClient；
- 让驱动管理连接池；
- 请求之间复用客户端；
- 应用关闭时再释放连接。

### 3. CRUD示例

```javascript
const products = client.db("shop").collection("products")

await products.insertOne({
  sku: "USB-001",
  name: "USB-C扩展坞",
  price: 299,
  stock: 80,
  createdAt: new Date()
})

const list = await products
  .find({ stock: { $gt: 0 } })
  .project({ name: 1, price: 1, stock: 1 })
  .sort({ createdAt: -1 })
  .limit(20)
  .toArray()

await products.updateOne(
  { sku: "USB-001", stock: { $gte: 1 } },
  { $inc: { stock: -1 } }
)
```

### 4. Node.js事务

```javascript
const session = client.startSession()

try {
  await session.withTransaction(async () => {
    const db = client.db("shop")

    const result = await db.collection("products").updateOne(
      { sku: "KB-001", stock: { $gte: 1 } },
      { $inc: { stock: -1 } },
      { session }
    )

    if (result.modifiedCount !== 1) {
      throw new Error("库存不足")
    }

    await db.collection("orders").insertOne(
      {
        orderNo: crypto.randomUUID(),
        sku: "KB-001",
        quantity: 1,
        status: "CREATED",
        createdAt: new Date()
      },
      { session }
    )
  })
} finally {
  await session.endSession()
}
```

## 十八、Python连接MongoDB

安装驱动：

```bash
pip install pymongo
```

### 1. 基础示例

```python
import os
from pymongo import MongoClient

uri = os.environ.get("MONGODB_URI")
if not uri:
    raise RuntimeError("缺少 MONGODB_URI 环境变量")

client = MongoClient(
    uri,
    maxPoolSize=20,
    minPoolSize=2,
    serverSelectionTimeoutMS=5000,
)

try:
    db = client["shop"]
    products = db["products"]

    product = products.find_one({"sku": "KB-001"})
    print(product)
finally:
    client.close()
```

### 2. 查询和分页

```python
cursor = (
    products.find(
        {"stock": {"$gt": 0}},
        {"name": 1, "price": 1, "stock": 1},
    )
    .sort("_id", 1)
    .limit(20)
)

for product in cursor:
    print(product)
```

### 3. 条件扣库存

```python
result = products.update_one(
    {"sku": "KB-001", "stock": {"$gte": 2}},
    {"$inc": {"stock": -2}},
)

if result.modified_count != 1:
    raise RuntimeError("库存不足或商品不存在")
```

### 4. 金额类型

涉及金额时，不要随意使用二进制浮点数。可使用 Decimal128：

```python
from decimal import Decimal
from bson.decimal128 import Decimal128

products.insert_one({
    "sku": "KB-002",
    "name": "静音机械键盘",
    "price": Decimal128(Decimal("599.00")),
})
```

## 十九、Change Streams：实时监听数据变化

Change Streams 可以监听集合、数据库或整个部署中的数据变化，常用于：

- 缓存失效；
- 搜索索引同步；
- 审计和事件驱动；
- 实时通知；
- 数据管道。

示例：

```javascript
const changeStream = db.products.watch([
  {
    $match: {
      operationType: { $in: ["insert", "update", "delete"] }
    }
  }
])

while (changeStream.hasNext()) {
  printjson(changeStream.next())
}
```

Change Streams 依赖复制集或分片集群的变更日志能力。

生产实践中要处理：

- 网络断开与自动恢复；
- Resume Token 持久化；
- 消费幂等；
- 事件乱序和重复；
- 下游不可用时的积压；
- oplog 窗口不足导致无法恢复。

Change Streams 不是完整消息队列的无条件替代品。需要复杂路由、长期保留、重放和消费组时，应评估 Kafka、Pulsar、RabbitMQ 等系统。

## 二十、性能优化方法论

优化 MongoDB 不应从"调一个神秘参数"开始，而应从业务请求链路开始。

### 第一步：明确慢在哪里

把一次请求拆开：

```text
客户端网络
  ↓
应用排队
  ↓
连接池等待
  ↓
MongoDB服务器选择
  ↓
查询执行
  ↓
结果传输
  ↓
对象序列化
```

数据库慢只是其中一种可能。

### 第二步：记录查询形状

对于慢请求，记录：

- 数据库与集合；
- 过滤条件结构；
- 排序字段；
- 投影字段；
- 返回条数；
- 扫描条数；
- 执行计划；
- P50、P95、P99 延迟；
- 调用频率。

不要在日志中记录敏感值和完整凭据。

### 第三步：检查索引

重点问题：

- 是否发生 COLLSCAN；
- 是否使用正确复合索引；
- 是否存在额外排序；
- 是否扫描过多索引键；
- 查询条件是否与部分索引匹配；
- 是否出现低选择性字段索引；
- 是否有长期无使用索引。

### 第四步：控制返回数据量

不要默认返回完整文档：

```javascript
// 不推荐：可能返回大字段
db.products.find({ category: "mouse" })
// 更合理：只返回页面需要的字段
db.products.find(
  { category: "mouse" },
  { name: 1, price: 1, stock: 1 }
).limit(20)
```

### 第五步：避免深分页

`skip(100000)` 通常需要跳过大量结果。

优先使用稳定排序字段和上一页游标：

```javascript
db.orders.find({
  createdAt: { $lt: lastCreatedAt }
}).sort({ createdAt: -1, _id: -1 }).limit(20)
```

当排序字段可能重复时，加入 `_id` 作为稳定的第二排序键。

### 第六步：批量写入

大量写入时可使用批量操作：

```javascript
db.products.bulkWrite([
  {
    updateOne: {
      filter: { sku: "KB-001" },
      update: { $inc: { stock: 10 } }
    }
  },
  {
    updateOne: {
      filter: { sku: "MS-002" },
      update: { $inc: { stock: 20 } }
    }
  }
], { ordered: false })
```

`ordered: false` 允许某个操作失败后继续尝试其他操作，通常可以提高独立批量写入的吞吐，但错误处理也要按业务语义设计。

### 第七步：合理设置超时

应用不应无限等待：

- 服务器选择超时；
- 连接超时；
- Socket 超时；
- 查询 maxTimeMS；
- 事务超时；
- API 请求超时。

示例：

```javascript
db.orders.find({ status: "PAID" }).maxTimeMS(3000)
```

### 第八步：关注工作集

MongoDB 使用 WiredTiger 存储引擎。热点数据和索引能否有效驻留内存，会显著影响性能。

需要关注：

- 内存使用和缓存压力；
- 磁盘 IOPS 和延迟；
- 页面读取与驱逐；
- 索引大小；
- 工作集大小；
- 缺页和磁盘队列；
- 压缩收益与 CPU 开销。

### 第九步：读写分离不是万能药

把查询切到 Secondary 可能：

- 降低 Primary 的部分读压力；
- 但增加陈旧读风险；
- 可能让 Secondary 无法及时追赶复制；
- 可能把报表查询的压力转移到复制节点；
- 故障切换时改变读取行为。

首先应修复错误查询和索引，再考虑读偏好策略。

## 二十一、监控MongoDB应该看什么

### 1. 主机层

- CPU 使用率；
- 内存与 Swap；
- 磁盘容量；
- 磁盘延迟和 IOPS；
- 网络吞吐和丢包；
- 文件描述符。

### 2. 数据库层

- 连接数和连接池等待；
- 每秒查询、插入、更新和删除；
- 查询延迟分位数；
- 扫描文档与返回文档比；
- 缓存使用和驱逐；
- 锁与排队；
- 慢查询；
- 索引大小与使用情况；
- 数据库和集合增长速度。

### 3. 复制集层

- Primary 是否稳定；
- Secondary 复制延迟；
- 选举次数；
- 节点状态；
- oplog 大小和时间窗口；
- 回滚风险；
- 节点间网络延迟。

### 4. 分片层

- 各分片数据是否均衡；
- Chunk 分布；
- 热点分片；
- 迁移队列；
- 广播查询比例；
- mongos 连接和延迟；
- 配置服务器状态。

### 5. 业务层

数据库指标最终要映射到业务：

- 下单成功率；
- 查询 P99；
- 库存扣减失败率；
- 支付回调处理延迟；
- 数据同步积压；
- 错误码分布；
- 每个租户或接口的资源消耗。

## 二十二、生产环境常见错误

**错误1：因为Schema灵活，就不做数据规范**

结果：同一字段同时出现字符串、数字和空对象，后续查询、索引和聚合全部变复杂。
解决：定义字段约定、Schema 版本、应用校验和数据库验证。

**错误2：把关系型表一比一复制成集合**

结果：大量 `$lookup`，每次查询跨多个集合，失去文档模型优势。
解决：围绕访问模式重新设计，合理嵌入和冗余。

**错误3：无脑创建大量索引**

结果：写入变慢、磁盘增加、缓存被挤占、索引维护困难。
解决：按查询形状设计索引，定期审计索引使用情况。

**错误4：只在开发环境测试小数据**

结果：几千条数据时 5 毫秒，几千万条时全表扫描。
解决：使用接近生产的数据量、分布和并发进行压测。

**错误5：用字符串保存日期和金额**

结果：日期范围查询和排序错误，金额出现精度问题。
解决：日期使用 BSON Date，精确小数使用 Decimal128 或明确的最小货币单位整数。

**错误6：无限增长数组**

结果：文档不断膨胀，更新成本上升，最终接近文档限制。
解决：拆集合、分桶、限制长度或归档。

**错误7：把数据库直接暴露到公网**

结果：扫描、爆破、数据泄漏和勒索风险显著增加。
解决：认证、TLS、内网、防火墙、最小权限和安全补丁缺一不可。

**错误8：没有恢复演练**

结果：事故发生后才发现备份损坏、缺少密钥或恢复耗时远超预期。
解决：定期在隔离环境执行完整恢复，并验证数据与应用。

**错误9：滥用事务**

结果：锁定资源时间变长，吞吐下降，错误重试复杂。
解决：优先使用单文档原子性、条件更新和幂等设计。

**错误10：升级只看新功能，不看兼容性**

结果：驱动、操作系统、配置项、行为变化或功能兼容版本导致故障。
解决：阅读发布说明、兼容性变更和升级路径，先在预发布环境完成验证。

## 二十三、一个完整的订单集合设计示例

```javascript
{
  _id: ObjectId("..."),
  schemaVersion: 1,
  orderNo: "202607280001",

  userId: ObjectId("..."),
  userSnapshot: {
    name: "小王",
    level: "VIP"
  },

  items: [
    {
      productId: ObjectId("..."),
      sku: "KB-001",
      name: "机械键盘",
      unitPrice: NumberDecimal("499.00"),
      quantity: 1,
      subtotal: NumberDecimal("499.00")
    }
  ],

  shippingAddress: {
    receiver: "小王",
    phone: "138****0000",
    province: "浙江省",
    city: "绍兴市",
    district: "越城区",
    detail: "某某路 1 号"
  },

  amount: {
    goods: NumberDecimal("499.00"),
    shipping: NumberDecimal("0.00"),
    discount: NumberDecimal("20.00"),
    payable: NumberDecimal("479.00")
  },

  status: "PAID",
  payment: {
    method: "WECHAT_PAY",
    transactionId: "wx_...",
    paidAt: ISODate("2026-07-28T08:05:00Z")
  },

  timeline: [
    {
      status: "CREATED",
      at: ISODate("2026-07-28T08:00:00Z")
    },
    {
      status: "PAID",
      at: ISODate("2026-07-28T08:05:00Z")
    }
  ],

  createdAt: ISODate("2026-07-28T08:00:00Z"),
  updatedAt: ISODate("2026-07-28T08:05:00Z")
}
```

推荐索引要根据接口决定。例如：

```javascript
// 订单号唯一查询
db.orders.createIndex(
  { orderNo: 1 },
  { unique: true, name: "uk_orders_order_no" }
)

// 用户订单列表
db.orders.createIndex(
  { userId: 1, createdAt: -1, _id: -1 },
  { name: "idx_orders_user_created" }
)

// 后台按状态和时间扫描
db.orders.createIndex(
  { status: 1, createdAt: 1 },
  { name: "idx_orders_status_created" }
)

// 支付回调幂等
db.orders.createIndex(
  { "payment.transactionId": 1 },
  {
    unique: true,
    partialFilterExpression: {
      "payment.transactionId": { $exists: true }
    },
    name: "uk_orders_payment_transaction"
  }
)
```

这里没有建立一个"包含所有字段的万能索引"，而是分别服务于具体查询。

## 二十四、从入门到精通的学习路线

### 第一阶段：基础使用

目标：能够独立完成简单业务开发。

学习内容：

- 文档、集合、数据库；
- BSON 类型；
- mongosh；
- CRUD；
- 条件操作符；
- 数组和嵌套字段；
- 基础索引；
- 使用一种语言驱动。

实践项目：做一个文章、评论或商品管理 API。

### 第二阶段：数据建模与查询优化

目标：能设计可扩展的数据模型。

学习内容：

- 嵌入与引用；
- 冗余和快照；
- Schema 验证；
- 复合索引；
- 多键、TTL、部分索引；
- explain()；
- 游标分页；
- 聚合管道。

实践项目：完成电商订单、库存和销售统计系统。

### 第三阶段：一致性与高可用

目标：能理解生产系统的可靠性边界。

学习内容：

- 单文档原子性；
- 多文档事务；
- Read Concern；
- Write Concern；
- Read Preference；
- 复制集和选举；
- oplog；
- Change Streams。

实践项目：搭建三节点复制集，模拟 Primary 故障切换。

### 第四阶段：分布式与运维

目标：能够参与大型 MongoDB 系统设计和运维。

学习内容：

- 分片架构；
- 分片键选择；
- 数据均衡；
- 广播查询；
- 监控与容量规划；
- 备份恢复；
- 安全加固；
- 版本升级；
- 故障演练。

实践项目：设计一个高写入事件系统的分片方案，并说明分片键选择依据。

### 第五阶段：精通不是背命令

真正的"精通"体现在：

- 能从业务访问模式推导数据模型；
- 能用执行计划解释查询为何慢；
- 能在一致性、性能和成本之间做权衡；
- 能设计可恢复、可监控、可升级的系统；
- 能知道什么时候不该使用 MongoDB。

## 二十五、面试与自测问题

1. MongoDB 的文档和 JSON 有什么区别？
2. 为什么 `_id` 默认使用 ObjectId？
3. 单个 BSON 文档的大小限制是多少？
4. 嵌入和引用分别适合什么场景？
5. 为什么无限增长数组很危险？
6. 复合索引字段顺序为什么重要？
7. 什么是索引最左前缀？
8. COLLSCAN 和 IXSCAN 有什么区别？
9. 为什么"走索引"不代表查询一定快？
10. `$elemMatch` 解决了什么问题？
11. `$lookup` 应该在什么情况下使用？
12. 单文档原子性和多文档事务有什么区别？
13. `w: "majority"` 的含义是什么？
14. 从 Secondary 读取有什么风险？
15. 复制集如何完成自动故障转移？
16. oplog 窗口为什么重要？
17. 分片键选择错误会产生什么后果？
18. 哈希分片和范围分片如何选择？
19. 为什么数据库不应该直接暴露在公网？
20. 为什么备份必须配合恢复演练？

能够用自己的语言回答这些问题，并写出对应示例，说明你已经不再停留在"会几个命令"的阶段。

## 二十六、总结

MongoDB 的上手门槛很低：安装数据库、插入一个文档、执行一次查询，十分钟就能完成。

但 MongoDB 的能力上限很高。随着业务增长，你必须逐步掌握：

```text
CRUD
  ↓
数据建模
  ↓
索引与执行计划
  ↓
聚合与实时变化
  ↓
事务与一致性
  ↓
复制集与高可用
  ↓
分片与水平扩展
  ↓
安全、监控、备份和容量规划
```

学习 MongoDB 最容易犯的错误，是把注意力全部放在 API 上。真正决定系统质量的，是你能否回答下面四个问题：

1. 数据应该以什么结构保存？
2. 核心请求将如何访问这些数据？
3. 当节点故障、网络抖动或并发冲突时，系统会发生什么？
4. 当数据扩大一百倍时，当前方案还能不能工作？

当你开始围绕这四个问题设计系统时，才算真正从"会用 MongoDB"迈向"理解 MongoDB"。

## 官方资料

- [MongoDB Manual](https://www.mongodb.com/docs/manual/)
- [MongoDB Release Notes](https://www.mongodb.com/docs/manual/release-notes/)
- [MongoDB Versioning](https://www.mongodb.com/docs/manual/reference/versioning/)
- [CRUD Operations](https://www.mongodb.com/docs/manual/crud/)
- [Data Modeling](https://www.mongodb.com/docs/manual/data-modeling/)
- [Indexes](https://www.mongodb.com/docs/manual/indexes/)
- [Aggregation](https://www.mongodb.com/docs/manual/aggregation/)
- [Transactions](https://www.mongodb.com/docs/manual/core/transactions/)
- [Replication](https://www.mongodb.com/docs/manual/replication/)
- [Sharding](https://www.mongodb.com/docs/manual/sharding/)
- [Security Checklist](https://www.mongodb.com/docs/manual/administration/security-checklist/)
- [Installation](https://www.mongodb.com/docs/manual/installation/)

版本、支持平台、命令参数和兼容性会持续变化。正式部署或升级前，应以对应版本的官方文档、发布说明和兼容性说明为准。
