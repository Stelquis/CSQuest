# [MySQL从入门到精通：一篇文章吃透SQL、索引、事务与高可用](https://mp.weixin.qq.com/s/LHi0h67ofyWMeT-0oGFYlQ)

> 这是一个关于"微风商城"的故事——一个由三个年轻人维护的电商小站。新入职的阿泽接手数据库的那天，线上订单查询已经慢到用户骂街，而全站连一份可用的备份都没有。你会跟着阿泽一起，从"会写 SELECT"走到真正理解索引、事务、锁、执行计划、备份恢复与高可用。读完之后你会发现：真正掌握 MySQL，不只是记住语法，而是要建立一套完整的数据库思维。

---

## 故事的起点：订单页卡了三天，备份从未验证过

阿泽入职"微风商城"的第一周，就接到了一个让人头大的任务：**线上订单查询越来越慢，老板让他查清楚。**

微风商城是个电商小站：用户、商品、订单、订单明细，数据量不算大，但查询慢得像蜗牛。阿泽打开数据库，随手敲了一句：

```sql
SELECT * FROM orders WHERE user_id = 100;
```

三秒才出结果。再翻翻代码，发现到处是 `SELECT *`、循环里套查询、没有任何索引设计。

更让他后背发凉的是另一件事：前任 DBA 留下一句话——"备份脚本在跑"。阿泽去验证了一下，发现备份脚本半年前就报错了，**从来没有人发现，更没有人做过一次恢复演练**。也就是说，如果今天误删一张表，整个商城的数据就没了。

阿泽列了列团队遇到的典型问题：

- 能写 SQL，却不知道为什么查询越来越慢；
- 建了索引，却发现优化器根本不用；
- 知道事务，却说不清脏读、幻读和 MVCC；
- 遇到死锁，只会重启服务；
- 数据误删之后，才发现备份从未真正验证过。

他决定系统学一遍 MySQL。这个故事，就是他从"会写 SELECT"到撑起生产数据库的完整路线图。

真正掌握 MySQL，需要建立五层能力：

1. **如何正确建模和设计表结构；**
2. **如何写出准确、高效、可维护的 SQL；**
3. **如何利用索引与执行计划定位性能瓶颈；**
4. **如何理解事务、锁与并发控制；**
5. **如何保障数据安全、可恢复和高可用。**

---

## 第一站：MySQL 到底是什么？

阿泽的第一课，是搞清楚 MySQL 的本质。

MySQL 是一款**关系型数据库管理系统**。它把数据组织成一张张二维表，并通过主键、外键和关联查询描述数据之间的关系。

一个电商系统至少会包含以下几类数据：

- 用户；
- 商品；
- 订单；
- 订单明细；
- 支付记录；
- 库存流水。

这些数据不应该全部塞进一个文件，更不能简单堆进一张"大宽表"。合理的做法是把不同实体拆分成多张表，再通过字段建立关系：

```
users  1 ───── N  orders
orders 1 ───── N  order_items
products 1 ─── N  order_items
```

这里的 `1 ─ N` 表示一对多关系：一个用户可以有多个订单；一个订单可以包含多条商品明细；一个商品也可能出现在多个订单中。

### MySQL 解决了什么问题？

相比普通文本文件或 Excel，MySQL 提供了：

- 结构化的数据模型；
- SQL 查询语言；
- 并发访问控制；
- 事务与崩溃恢复；
- 索引与查询优化器；
- 权限、安全与审计能力；
- 备份、复制和高可用方案。

### 当前应该选择哪个版本？

阿泽查资料时发现，MySQL 官方目前采用两条发布轨道：

- **LTS（长期支持版）**：功能集合更稳定，适合生产系统；
- **Innovation（创新版）**：更快获得新功能，适合充分测试后的快速迭代环境。

截至 2026 年 7 月，MySQL 官方文档已经提供 9.7 系列参考手册；与此同时，**MySQL 8.4 LTS 仍是大量现有生产系统的重要选择**。MySQL 8.0 已于 2026 年 4 月结束生命周期，因此新项目和升级项目不应再把 8.0 当作长期目标版本。

生产环境选型时，不要只追求"最新"，而应优先考虑：

- 业务依赖是否兼容；
- 驱动和 ORM 是否兼容；
- 备份、监控和运维工具是否兼容；
- 是否完成完整回归与压力测试。

---

## 第二站：快速搭建环境——五分钟跑起一个 MySQL

学习阶段最省事的方式，是使用 Docker 启动一个独立实例——阿泽在 Docker 篇学到的本事正好用上了。

### 用 Docker 启动 MySQL

```bash
docker run -d \
  --name mysql84 \
  -p 3306:3306 \
  -e MYSQL_ROOT_PASSWORD='ChangeMe_123!' \
  -e MYSQL_DATABASE='shop' \
  -v mysql84-data:/var/lib/mysql \
  mysql:8.4
```

查看容器状态：

```bash
docker ps
```

进入 MySQL：

```bash
docker exec -it mysql84 mysql -uroot -p
```

输入密码后，执行：

```sql
SELECT VERSION();
```

### 用 Docker Compose 启动

创建 `compose.yml`：

```yaml
services:
  mysql:
    image: mysql:8.4
    container_name: mysql84
    restart: unless-stopped
    environment:
      MYSQL_ROOT_PASSWORD: ChangeMe_123!
      MYSQL_DATABASE: shop
      TZ: Asia/Shanghai
    ports:
      - "3306:3306"
    volumes:
      - mysql84-data:/var/lib/mysql
    command:
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_0900_ai_ci

volumes:
  mysql84-data:
```

启动：

```bash
docker compose up -d
```

### 创建业务账号——别让应用用 root

阿泽学到的第一个生产教训：**不要让应用程序直接使用 `root` 账号。**

```sql
CREATE USER 'shop_app'@'%' IDENTIFIED BY 'App_Strong_Password_2026!';
GRANT SELECT, INSERT, UPDATE, DELETE
ON shop.*
TO 'shop_app'@'%';
```

查看授权：

```sql
SHOW GRANTS FOR 'shop_app'@'%';
```

生产环境应进一步限制来源地址，例如只允许应用服务器网段连接，而不是使用 `%`。

---

## 第三站：数据库、表、行和列——先理解"电子表格"

理解 MySQL，可以先把它想象成一个**结构严格的电子表格系统**：

```
数据库 Database
└── 表 Table
    ├── 列 Column：字段定义
    └── 行 Row：一条具体记录
```

创建数据库：

```sql
CREATE DATABASE IF NOT EXISTS shop
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE shop;
```

查看当前数据库和全部数据库：

```sql
SELECT DATABASE();
SHOW DATABASES;
```

### 为什么推荐 utf8mb4？

MySQL 中的 `utf8mb4` 能表示完整的 Unicode 字符，包括中文、生僻字和 Emoji。新系统通常不应再选择历史上的 `utf8` 三字节字符集。

### 字符集与排序规则的区别

- **字符集**决定字符如何编码；
- **排序规则**决定字符串如何比较和排序。

例如，不同排序规则可能影响：是否区分大小写、是否区分重音、中文/英文/特殊字符的排序方式。

> 不要在同一套业务表中随意混用字符集和排序规则，否则关联、比较和索引使用都可能出现额外开销或异常行为。

---

## 第四站：从零设计一个电商数据库——好结构比后期补救更重要

微风商城的核心数据，由四张表构成：`users`（用户）、`products`（商品）、`orders`（订单）、`order_items`（订单明细）。

### 用户表

```sql
CREATE TABLE users (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  username VARCHAR(50) NOT NULL,
  email VARCHAR(255) NOT NULL,
  status TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1正常 2禁用',
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
    ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uk_users_username (username),
  UNIQUE KEY uk_users_email (email),
  KEY idx_users_status_created (status, created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

### 商品表

```sql
CREATE TABLE products (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  sku VARCHAR(64) NOT NULL,
  name VARCHAR(200) NOT NULL,
  price DECIMAL(12, 2) NOT NULL,
  stock INT UNSIGNED NOT NULL DEFAULT 0,
  status TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT '1上架 2下架',
  attributes JSON NULL,
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
    ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uk_products_sku (sku),
  KEY idx_products_status_price (status, price),
  CONSTRAINT chk_products_price CHECK (price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

### 订单表

```sql
CREATE TABLE orders (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_no VARCHAR(32) NOT NULL,
  user_id BIGINT UNSIGNED NOT NULL,
  status TINYINT UNSIGNED NOT NULL DEFAULT 10
    COMMENT '10待支付 20已支付 30已发货 40已完成 90已取消',
  total_amount DECIMAL(12, 2) NOT NULL,
  paid_at DATETIME(3) NULL,
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  updated_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3)
    ON UPDATE CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  UNIQUE KEY uk_orders_order_no (order_no),
  KEY idx_orders_user_created (user_id, created_at),
  KEY idx_orders_status_created (status, created_at),
  CONSTRAINT fk_orders_user
    FOREIGN KEY (user_id) REFERENCES users(id),
  CONSTRAINT chk_orders_total_amount CHECK (total_amount >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

### 订单明细表

```sql
CREATE TABLE order_items (
  id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  order_id BIGINT UNSIGNED NOT NULL,
  product_id BIGINT UNSIGNED NOT NULL,
  product_name VARCHAR(200) NOT NULL,
  unit_price DECIMAL(12, 2) NOT NULL,
  quantity INT UNSIGNED NOT NULL,
  subtotal DECIMAL(12, 2) NOT NULL,
  created_at DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id),
  KEY idx_order_items_order (order_id),
  KEY idx_order_items_product (product_id),
  CONSTRAINT fk_order_items_order
    FOREIGN KEY (order_id) REFERENCES orders(id),
  CONSTRAINT fk_order_items_product
    FOREIGN KEY (product_id) REFERENCES products(id),
  CONSTRAINT chk_order_items_quantity CHECK (quantity > 0),
  CONSTRAINT chk_order_items_subtotal CHECK (subtotal >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
```

### 字段类型怎么选？

#### 整数类型

- `TINYINT`：状态、布尔值、小范围枚举；
- `INT`：库存、计数；
- `BIGINT`：大规模业务主键、订单关联 ID。

> 不要为了"省空间"而把未来可能增长的主键设计得过小，也不要把数字 ID 存成字符串。

#### 金额类型

金额应优先使用 `DECIMAL`：

```sql
price DECIMAL(12, 2)
```

**不要使用 `FLOAT` 或 `DOUBLE` 保存需要精确计算的金额**，因为二进制浮点数可能产生精度误差。

#### 字符串类型

- `CHAR`：长度固定；
- `VARCHAR`：长度可变；
- `TEXT`：较长文本。

能明确限定长度时，优先使用合理长度的 `VARCHAR`，不要机械地把所有文本都设为 `VARCHAR(255)`。

#### 时间类型

- `DATE`：日期；
- `DATETIME`：日期与时间；
- `TIMESTAMP`：时间戳语义，受时区与范围等因素影响；
- `DATETIME(3)`：保留毫秒。

> 业务系统应统一时区策略。常见做法是数据库统一保存 UTC，展示时再转换为用户所在时区；也可以统一保存业务所在时区，但必须在团队内保持一致。

#### JSON 类型

`JSON` 适合保存结构灵活、查询频率较低的扩展属性，例如商品规格：

```json
{ "color": "black", "memory": "16GB", "storage": "1TB" }
```

但不要把应该结构化建模、经常过滤和关联的数据全部塞进 JSON。**JSON 是补充，不是关系模型的替代品。**

---

## 第五站：SQL 增删改查——真正打好基本功

表建好了，阿泽开始学最基本的增删改查。

### 插入数据 INSERT

```sql
INSERT INTO users (username, email)
VALUES ('alice', 'alice@example.com');
```

批量插入商品：

```sql
INSERT INTO products (sku, name, price, stock, attributes)
VALUES
  ('P1001', '机械键盘', 399.00, 100, JSON_OBJECT('switch', 'red')),
  ('P1002', '无线鼠标', 199.00, 200, JSON_OBJECT('color', 'black')),
  ('P1003', '27英寸显示器', 1899.00, 30, JSON_OBJECT('resolution', '4K'));
```

查看刚插入的自增 ID：

```sql
SELECT LAST_INSERT_ID();
```

### 查询数据 SELECT

查询全部商品：

```sql
SELECT id, sku, name, price, stock
FROM products;
```

带条件查询：

```sql
SELECT id, name, price
FROM products
WHERE status = 1
  AND price BETWEEN 100 AND 500
ORDER BY price DESC;
```

模糊查询：

```sql
SELECT id, name
FROM products
WHERE name LIKE '%鼠标%';
```

> 注意：以 `%` 开头的普通 `LIKE` 条件通常难以有效利用 B-Tree 索引。全文检索、搜索引擎或专门的倒排索引，往往更适合大规模文本搜索。

### 更新数据 UPDATE

```sql
UPDATE products
SET price = 179.00,
    stock = stock + 50
WHERE sku = 'P1002';
```

执行更新前，最好先用相同条件查询确认范围：

```sql
SELECT id, sku, name, price, stock
FROM products
WHERE sku = 'P1002';
```

没有 `WHERE` 的 `UPDATE` 会修改整张表：

```sql
UPDATE products SET status = 2;
```

这类语句在生产环境中风险极高。

### 删除数据 DELETE

```sql
DELETE FROM products
WHERE sku = 'P1003';
```

`DELETE`、`TRUNCATE`、`DROP` 的区别：

- `DELETE`：删除满足条件的行；
- `TRUNCATE TABLE`：快速清空整张表；
- `DROP TABLE`：删除表结构和数据。

> 线上操作前必须明确影响范围，并准备可验证的恢复方案。

### 去重、限制与分页

去重：

```sql
SELECT DISTINCT status
FROM orders;
```

限制返回数量：

```sql
SELECT id, name, price
FROM products
ORDER BY id DESC
LIMIT 20;
```

传统分页：

```sql
SELECT id, name, price
FROM products
ORDER BY id
LIMIT 100000, 20;
```

当偏移量很大时，数据库仍可能扫描并丢弃大量记录。更高效的方式是**游标分页**（Keyset Pagination）：

```sql
SELECT id, name, price
FROM products
WHERE id > 100000
ORDER BY id
LIMIT 20;
```

---

## 第六站：多表查询——JOIN 是关系型数据库的灵魂

单表查询只是热身。微风商城的报表和页面，几乎全是多表查询。

### INNER JOIN：只返回两边匹配的记录

查询订单及其用户信息：

```sql
SELECT
  o.order_no,
  o.total_amount,
  o.status,
  u.username,
  u.email
FROM orders AS o
JOIN users AS u ON u.id = o.user_id
ORDER BY o.created_at DESC;
```

### LEFT JOIN：保留左边全部

查询所有用户及其订单数，即使某些用户没有下过单：

```sql
SELECT
  u.id,
  u.username,
  COUNT(o.id) AS order_count
FROM users AS u
LEFT JOIN orders AS o ON o.user_id = u.id
GROUP BY u.id, u.username;
```

### 多表关联

查询订单详情：

```sql
SELECT
  o.order_no,
  u.username,
  oi.product_name,
  oi.unit_price,
  oi.quantity,
  oi.subtotal
FROM orders AS o
JOIN users AS u ON u.id = o.user_id
JOIN order_items AS oi ON oi.order_id = o.id
WHERE o.order_no = '202607220001';
```

### JOIN 优化原则

- 关联字段类型必须一致；
- 被关联字段通常应建立索引；
- 避免无条件笛卡尔积；
- 只查询真正需要的列；
- 先确认结果正确，再进行性能优化；
- 不要用大量应用层循环代替数据库能够高效完成的关联。

---

## 第七站：聚合、分组与统计分析

商城的运营报表，离不开聚合查询。

### 常用聚合函数

- `COUNT()`：计数；
- `SUM()`：求和；
- `AVG()`：平均值；
- `MAX()`：最大值；
- `MIN()`：最小值。

统计已支付订单数量与金额：

```sql
SELECT
  COUNT(*) AS order_count,
  SUM(total_amount) AS total_sales,
  AVG(total_amount) AS avg_order_amount
FROM orders
WHERE status >= 20
  AND status < 90;
```

### GROUP BY：按组统计

按用户统计消费金额：

```sql
SELECT
  user_id,
  COUNT(*) AS order_count,
  SUM(total_amount) AS total_spent
FROM orders
WHERE status >= 20
  AND status < 90
GROUP BY user_id;
```

### HAVING：过滤分组结果

筛选累计消费超过 1000 元的用户：

```sql
SELECT
  user_id,
  SUM(total_amount) AS total_spent
FROM orders
WHERE status >= 20
  AND status < 90
GROUP BY user_id
HAVING SUM(total_amount) > 1000;
```

可以这样理解：

- `WHERE`：分组前过滤行；
- `HAVING`：分组后过滤聚合结果。

### CASE WHEN：按条件计数

统计不同订单状态的数量：

```sql
SELECT
  SUM(CASE WHEN status = 10 THEN 1 ELSE 0 END) AS pending_count,
  SUM(CASE WHEN status = 20 THEN 1 ELSE 0 END) AS paid_count,
  SUM(CASE WHEN status = 30 THEN 1 ELSE 0 END) AS shipped_count,
  SUM(CASE WHEN status = 40 THEN 1 ELSE 0 END) AS completed_count
FROM orders;
```

---

## 第八站：进阶 SQL——子查询、CTE 和窗口函数

### 子查询

查询消费金额高于平均订单金额的订单：

```sql
SELECT id, order_no, total_amount
FROM orders
WHERE total_amount > (
  SELECT AVG(total_amount)
  FROM orders
);
```

> 子查询并不一定慢。性能取决于数据规模、相关性、索引、优化器改写能力和执行计划，不能只凭语法形式判断。

### 公共表表达式 CTE

```sql
WITH user_sales AS (
  SELECT
    user_id,
    SUM(total_amount) AS total_spent
  FROM orders
  WHERE status >= 20
    AND status < 90
  GROUP BY user_id
)
SELECT
  u.username,
  us.total_spent
FROM user_sales AS us
JOIN users AS u ON u.id = us.user_id
WHERE us.total_spent > 1000
ORDER BY us.total_spent DESC;
```

CTE 能提高复杂 SQL 的可读性，还可以用于递归查询。

### 窗口函数

按消费金额为用户排名：

```sql
SELECT
  user_id,
  total_spent,
  DENSE_RANK() OVER (ORDER BY total_spent DESC) AS spending_rank
FROM (
  SELECT
    user_id,
    SUM(total_amount) AS total_spent
  FROM orders
  WHERE status >= 20
    AND status < 90
  GROUP BY user_id
) AS t;
```

窗口函数不会像普通 `GROUP BY` 那样把多行压缩成一行，适合排名、累计值、同比环比和分组内 Top N。

查询每个用户最近一笔订单：

```sql
WITH ranked_orders AS (
  SELECT
    id,
    order_no,
    user_id,
    total_amount,
    created_at,
    ROW_NUMBER() OVER (
      PARTITION BY user_id
      ORDER BY created_at DESC, id DESC
    ) AS rn
  FROM orders
)
SELECT *
FROM ranked_orders
WHERE rn = 1;
```

---

## 第九站：索引——MySQL 性能优化的第一道门

阿泽终于迎来了性能问题的核心：索引。

索引类似书籍目录。没有目录时，寻找内容往往需要从头翻到尾；有了目录，就能快速定位目标页。

### InnoDB 索引结构

InnoDB 的常规索引采用 B-Tree 类结构。表的主键索引同时也是**聚簇索引**，叶子节点保存完整行数据；普通二级索引的叶子节点通常保存索引列和主键值。

因此，**使用很长的字符串作为主键，会让多个二级索引变得更大。**

### 常见索引类型

- 主键索引：`PRIMARY KEY`；
- 唯一索引：`UNIQUE KEY`；
- 普通索引：`KEY` 或 `INDEX`；
- 联合索引：多个列组成一个索引；
- 全文索引：`FULLTEXT`；
- 空间索引：`SPATIAL`。

### 创建、删除、查看索引

```sql
CREATE INDEX idx_products_status_price
ON products (status, price);

DROP INDEX idx_products_status_price
ON products;

SHOW INDEX FROM products;
```

### 联合索引与最左前缀

假设存在联合索引：

```sql
KEY idx_orders_user_status_created (user_id, status, created_at)
```

通常较容易利用该索引的条件包括：

```sql
WHERE user_id = 100
```

```sql
WHERE user_id = 100 AND status = 20
```

```sql
WHERE user_id = 100
  AND status = 20
  AND created_at >= '2026-07-01'
```

而只使用：

```sql
WHERE status = 20
```

通常无法直接利用该联合索引最左侧的定位能力。

> 联合索引的顺序应由真实查询模式决定，而不是简单遵循"区分度最高的字段永远放最前面"。需要综合考虑：等值条件、范围条件、排序与分组、查询频率、索引选择性、是否能够形成覆盖索引。

### 覆盖索引

如果查询所需列全部包含在索引中，存储引擎可能不必再回到聚簇索引读取完整数据行：

```sql
CREATE INDEX idx_orders_user_created_amount
ON orders (user_id, created_at, total_amount);
```

```sql
SELECT created_at, total_amount
FROM orders
WHERE user_id = 100
ORDER BY created_at DESC
LIMIT 20;
```

该查询有机会通过索引直接获得所需数据。

### 常见索引失效或低效场景

#### 对索引列做函数计算

```sql
WHERE DATE(created_at) = '2026-07-22'
```

更好的写法：

```sql
WHERE created_at >= '2026-07-22 00:00:00'
  AND created_at <  '2026-07-23 00:00:00'
```

#### 隐式类型转换

字段是字符串，却用数字比较：

```sql
WHERE order_no = 202607220001
```

应保持类型一致：

```sql
WHERE order_no = '202607220001'
```

#### 前导模糊匹配

```sql
WHERE name LIKE '%键盘'
```

普通 B-Tree 索引通常难以用于快速定位。

#### 查询返回比例过高

即使有索引，如果条件会返回表中大部分数据，优化器也可能判断全表扫描成本更低。

### 索引不是越多越好

每增加一个索引，都意味着：

- 占用更多磁盘与缓存；
- 插入、更新、删除需要维护更多结构；
- 优化器需要评估更多候选路径；
- 表结构变更和备份恢复成本可能增加。

> 索引应该围绕高频、关键查询建立，并持续验证实际收益。阿泽把这句记在了本子上："加索引之前先问：这条查询真的慢吗？慢在索引吗？"

---

## 第十站：EXPLAIN——读懂 SQL 执行计划

优化 SQL 不能靠猜，必须看执行计划。阿泽学会的第一件事，就是给慢查询加 `EXPLAIN`：

```sql
EXPLAIN
SELECT id, order_no, total_amount
FROM orders
WHERE user_id = 100
ORDER BY created_at DESC
LIMIT 20;
```

常见关注项：

- `type`：访问方式；
- `possible_keys`：可能使用的索引；
- `key`：实际使用的索引；
- `key_len`：使用的索引长度；
- `rows`：预计检查行数；
- `filtered`：预计过滤比例；
- `Extra`：额外执行信息。

### 常见访问类型

从较理想到较重，常见类型包括：

- `const`：通过主键或唯一索引定位单行；
- `eq_ref`：关联时通过唯一索引精确匹配；
- `ref`：通过普通索引等值匹配；
- `range`：索引范围扫描；
- `index`：扫描整个索引；
- `ALL`：全表扫描。

> 但不要机械地认为出现 `ALL` 就一定错误。小表全表扫描可能比索引访问更快，关键要结合数据量、返回行数和真实耗时判断。

### EXPLAIN ANALYZE

```sql
EXPLAIN ANALYZE
SELECT id, order_no, total_amount
FROM orders
WHERE user_id = 100
ORDER BY created_at DESC
LIMIT 20;
```

`EXPLAIN ANALYZE` 会**真实执行语句**，并显示实际耗时、循环次数和返回行数。它比传统估算计划更接近真实情况，但也因此要谨慎对待修改数据的语句和高成本查询。

### 优化 SQL 的基本流程

```
发现慢查询
   ↓
确认 SQL 与参数
   ↓
查看执行计划
   ↓
检查索引、扫描行数、排序和临时表
   ↓
改写 SQL 或调整索引
   ↓
在接近生产的数据量下压测
   ↓
观察上线后的真实指标
```

> 不能只在一张几十行的测试表上验证优化效果。

---

## 第十一站：事务——保证一组操作要么都成功，要么都失败

假设创建订单需要执行：

1. 扣减商品库存；
2. 创建订单；
3. 创建订单明细；
4. 写入库存流水。

如果只完成一半，系统数据就会不一致。**事务就是用来保证一组操作的整体性。**

### 基本事务语法

```sql
START TRANSACTION;

UPDATE products
SET stock = stock - 1
WHERE id = 1
  AND stock >= 1;

INSERT INTO orders (
  order_no, user_id, status, total_amount
) VALUES (
  '202607220001', 1, 10, 399.00
);

COMMIT;
```

发生错误时：

```sql
ROLLBACK;
```

### ACID

事务的四个核心属性：

- **Atomicity，原子性**：事务中的操作不可再分，要么全部成功，要么全部失败；
- **Consistency，一致性**：事务前后数据满足约束和业务规则；
- **Isolation，隔离性**：并发事务之间按照隔离级别减少相互干扰；
- **Durability，持久性**：事务提交后，结果应能够在故障恢复后保留。

### 四种隔离级别

MySQL/InnoDB 支持常见的四种隔离级别：

1. `READ UNCOMMITTED`；
2. `READ COMMITTED`；
3. `REPEATABLE READ`；
4. `SERIALIZABLE`。

InnoDB 默认隔离级别通常是 **`REPEATABLE READ`**。

查看当前隔离级别：

```sql
SELECT @@transaction_isolation;
```

设置当前会话隔离级别：

```sql
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
```

### 并发读取异常

**脏读**：一个事务读到了另一个尚未提交事务的数据。

**不可重复读**：同一事务中，两次读取同一行，结果发生变化。

**幻读**：同一事务中，两次按范围查询，返回的行集合发生变化。

> 真实系统中，不要只背概念，还要结合：普通一致性读、当前读、MVCC、行锁、间隙锁、Next-Key Lock、不同隔离级别。

---

## 第十二站：MVCC、Undo Log、Redo Log 和 Binlog

这一部分是从"会用事务"走向"理解数据库内核"的关键。

### MVCC 是什么？

MVCC 是**多版本并发控制**。它允许读取操作在很多情况下不阻塞写入，写入也不必阻塞普通快照读。

可以把一行数据想象成存在多个历史版本。事务根据自己的可见性规则读取合适的版本，而不是总去争抢同一份最新数据。

### Undo Log

Undo Log 主要用于：

- 事务回滚；
- 为 MVCC 提供历史版本信息。

当事务修改一行数据时，系统需要保留足够的信息，以便在回滚或一致性读取时恢复旧版本。

### Redo Log

Redo Log 记录 InnoDB 数据页修改相关的**重做信息**，服务于崩溃恢复。

提交事务时，并不一定需要立即把所有修改后的数据页完整写回磁盘。先持久化日志，再在后台逐步刷新脏页，可以提高写入效率并保障恢复能力。

### Binlog

Binary Log 是 MySQL Server 层的二进制日志，主要用于：

- 主从复制；
- 基于时间点恢复；
- 数据变更订阅等场景。

> Redo Log 与 Binlog 不应混为一谈：Redo Log 更偏向 InnoDB 崩溃恢复；Binlog 更偏向逻辑变更记录、复制与恢复链路。

### Buffer Pool

InnoDB Buffer Pool 是内存中的核心缓存区域，用于缓存数据页和索引页。

数据库查询快不快，很大程度上取决于热点数据能否留在内存，以及磁盘 I/O、访问模式和 SQL 是否合理。

> 但不能简单地认为"内存越大越好"。还要给操作系统、连接、排序、临时表、日志和其他进程保留空间。

---

## 第十三站：锁——并发正确性的代价

### 悲观锁

在读取后准备修改数据时，可以使用锁定读：

```sql
START TRANSACTION;

SELECT stock
FROM products
WHERE id = 1
FOR UPDATE;

UPDATE products
SET stock = stock - 1
WHERE id = 1;

COMMIT;
```

`FOR UPDATE` 会对匹配记录加排他性质的锁，具体锁范围与索引、隔离级别和扫描范围有关。

### 更推荐的库存扣减方式

很多场景不需要先查再改，可以使用**条件更新**：

```sql
UPDATE products
SET stock = stock - 1
WHERE id = 1
  AND stock >= 1;
```

应用程序再检查受影响行数：影响 1 行说明扣减成功；影响 0 行说明商品不存在或库存不足。这种写法更短，也减少了竞态窗口。

### 乐观锁

为表增加版本号：

```sql
ALTER TABLE products
ADD COLUMN version INT UNSIGNED NOT NULL DEFAULT 0;
```

更新时带上旧版本：

```sql
UPDATE products
SET price = 189.00,
    version = version + 1
WHERE id = 1
  AND version = 3;
```

如果影响行数为 0，说明数据已经被其他事务修改，应用程序可以重新读取并决定是否重试。

### 死锁

两个事务分别持有对方需要的锁，并相互等待，就可能形成死锁：

```
事务A：先锁商品1，再锁商品2
事务B：先锁商品2，再锁商品1
```

InnoDB 能检测许多死锁，并回滚其中一个事务。但应用程序仍应具备处理死锁错误并有限重试的能力。

减少死锁的方法：

- 多行更新时保持统一加锁顺序；
- 让事务尽可能短；
- 不要在事务中执行远程网络调用；
- 为查询建立合适索引，缩小锁扫描范围；
- 避免一次事务修改过多数据；
- 捕获死锁错误，使用退避策略重试。

查看最近一次死锁信息：

```sql
SHOW ENGINE INNODB STATUS\G
```

还可以结合 Performance Schema 的锁等待信息进行分析。

---

## 第十四站：表设计——好结构比后期补救更重要

阿泽接手后做的第一件事，其实是回头审视那些已经跑了一年的表。他说："索引能救性能，但救不了烂结构。"

### 每张表都应有主键

InnoDB 表建议显式定义稳定、非空、尽量短的主键。

常见选择：

- 自增 `BIGINT`；
- 有序分布式 ID；
- 业务唯一键另建唯一索引。

> 随机、超长主键可能增加页分裂、索引体积和缓存压力。

### 不要滥用 NULL

`NULL` 表示未知或不存在，**不等于空字符串，也不等于 0**。

查询时应使用：

```sql
WHERE paid_at IS NULL
```

而不是：

```sql
WHERE paid_at = NULL
```

是否允许 `NULL`，应由业务语义决定，而不是简单追求"所有字段都 NOT NULL"或"全部允许 NULL"。

### 适度反范式

订单明细表中保存 `product_name` 和 `unit_price`，看起来和商品表重复，但这是**有意保存"下单时快照"**。

如果完全依赖商品表当前价格，商品改价后，历史订单金额就可能被错误解释。

> 数据库设计不是机械套用范式，而是在一致性、可维护性、性能和历史语义之间做权衡。

### 状态字段要可读

可以用整数保存状态，但必须：

- 在代码中定义枚举；
- 在表注释或数据字典中记录含义；
- 避免同一状态码在不同系统中含义不一致；
- 明确允许的状态迁移。

订单状态不是一个可以任意修改的数字，而是一台状态机：

```
待支付 → 已支付 → 已发货 → 已完成
   └──────────────→ 已取消
```

### 外键该不该用？

外键能直接在数据库层保障引用完整性，但也会带来：

- 写入检查成本；
- 变更和迁移复杂度；
- 分库分表后的限制；
- 运维操作顺序要求。

> 中小型单体系统、内部系统可以积极使用；超大规模分布式系统往往在应用层保证关系一致性。不要把"永远用外键"或"永远不用外键"当作教条。

---

## 第十五站：慢查询优化——从现象到根因

订单页慢的根源，阿泽一层层挖了出来。

### 开启慢查询日志

查看配置：

```sql
SHOW VARIABLES LIKE 'slow_query_log';
SHOW VARIABLES LIKE 'long_query_time';
SHOW VARIABLES LIKE 'slow_query_log_file';
```

测试环境可以临时设置：

```sql
SET GLOBAL slow_query_log = ON;
SET GLOBAL long_query_time = 1;
```

> 生产配置应写入配置文件并纳入变更管理，同时控制日志量、磁盘空间和敏感信息暴露风险。

### 常见性能问题

#### SELECT *

```sql
SELECT * FROM orders WHERE user_id = 100;
```

问题可能包括：读取不需要的大字段、增加网络传输、更难形成覆盖索引、表结构变化影响接口。

应明确列名：

```sql
SELECT id, order_no, status, total_amount, created_at
FROM orders
WHERE user_id = 100;
```

#### N+1 查询

先查 100 个订单，再循环查询每个订单的用户，可能产生 **101 次数据库请求**。

应该通过 JOIN、批量查询、数据加载策略或适当缓存减少往返次数。

#### 深分页

```sql
LIMIT 500000, 20
```

应考虑游标分页、延迟关联或基于稳定排序键的翻页。

#### 大事务

一次更新几十万行，会长时间持有锁、产生大量日志、拖慢复制并增加回滚成本。通常应：分批处理、控制每批行数、记录处理进度、保证任务可重入、监控锁等待与复制延迟。

#### 在索引列上计算

```sql
WHERE YEAR(created_at) = 2026
```

更好：

```sql
WHERE created_at >= '2026-01-01'
  AND created_at <  '2027-01-01'
```

### 查看系统中的高成本 SQL

可以使用 Performance Schema 和 `sys` Schema 分析语句统计：

```sql
SELECT
  query,
  exec_count,
  total_latency,
  avg_latency,
  rows_examined,
  rows_sent
FROM sys.statement_analysis
ORDER BY total_latency DESC
LIMIT 20;
```

> 不同版本、配置和权限下可用列可能有所差异，实际使用时应先查看表结构。

### 性能优化优先级

通常优先处理：

1. 错误的数据访问方式；
2. 缺失或错误索引；
3. 一次读取过多数据；
4. 应用层 N+1 和频繁往返；
5. 大事务与热点竞争；
6. 参数和硬件配置；
7. 最后才是微小语法技巧。

> 阿泽的感悟："不要在一条本来只执行 1 毫秒的 SQL 上花数天时间，却忽略每秒执行十万次的无意义查询。"

---

## 第十六站：常用服务器参数——理解比照抄更重要

### 查看配置

```sql
SHOW VARIABLES LIKE 'innodb_buffer_pool_size';
SHOW VARIABLES LIKE 'max_connections';
SHOW VARIABLES LIKE 'tmp_table_size';
SHOW VARIABLES LIKE 'binlog_format';
```

### innodb_buffer_pool_size

这是 InnoDB 最重要的内存配置之一。专用数据库服务器通常会给 Buffer Pool 分配较大比例内存，但具体比例不能脱离环境照抄。

还要考虑：操作系统缓存、连接内存、排序和临时表、复制线程、监控代理、同机部署的其他进程、容器内存限制。

### max_connections

连接数并不是越高越好。每个连接都有资源成本，过高的并发连接可能导致上下文切换、内存膨胀和数据库雪崩。

应用端应使用连接池，并设置：合理的最大连接数、连接获取超时、SQL 超时、空闲连接回收、熔断与限流。

### 不要在线上随意改参数

参数变更需要：

1. 明确问题与目标；
2. 记录修改前指标；
3. 在测试环境验证；
4. 确认动态或重启生效方式；
5. 准备回滚方案；
6. 观察延迟、吞吐、I/O、内存和错误率。

---

## 第十七站：备份与恢复——没有恢复演练的备份等于没有备份

阿泽入职时发现的"备份从未验证"问题，是这一站的核心教训。

### 逻辑备份 mysqldump

备份单个数据库：

```bash
mysqldump \
  -h 127.0.0.1 \
  -u root \
  -p \
  --single-transaction \
  --routines \
  --triggers \
  --events \
  --set-gtid-purged=OFF \
  shop > shop_20260722.sql
```

恢复：

```bash
mysql -h 127.0.0.1 -u root -p shop < shop_20260722.sql
```

`mysqldump` 灵活、直观，适合中小规模数据、迁移和开发测试。但对于超大数据量，它的备份与恢复速度可能不足，特别是恢复阶段需要重新执行大量 SQL、写入数据和构建索引。

### MySQL Shell Dump Utilities

MySQL Shell 提供实例、Schema 和表级别的并行导出与加载能力：

```javascript
util.dumpSchemas(["shop"], "/backup/shop", {
  threads: 8,
  compression: "zstd"
})
```

加载：

```javascript
util.loadDump("/backup/shop", {
  threads: 8
})
```

> 具体选项应以目标版本的 MySQL Shell 文档为准，并在恢复演练中验证。

### 物理备份

对于大规模数据库，物理备份通常恢复更快，因为它直接处理数据文件或页，而不是重新执行所有逻辑 SQL。

选择备份方案时要确认：

- 是否支持热备；
- 是否支持增量备份；
- 是否支持加密和压缩；
- 是否与当前版本兼容；
- 是否能做时间点恢复；
- 恢复速度是否满足 RTO。

### 时间点恢复 PITR

完整备份只能恢复到备份时刻。若需要恢复到误操作之前的某一秒，通常还需要 Binlog：

```
全量备份 + 备份之后的 Binlog
   ↓
恢复到指定时间点
```

### RPO 与 RTO

- **RPO**：最多允许丢失多长时间的数据；
- **RTO**：发生故障后，最多允许多长时间恢复服务。

例如：`RPO = 5分钟`、`RTO = 30分钟`。

> 备份策略必须从业务目标反推，而不是简单规定"每天备份一次"。

### 一套合格的备份体系

至少应包含：

- 定期全量备份；
- Binlog 或增量链路；
- 异地或跨可用区副本；
- 备份加密；
- 保留周期；
- 自动校验；
- **定期恢复演练**；
- 备份失败告警；
- 明确的恢复操作手册。

---

## 第十八站：复制——读扩展、容灾与数据分发

微风商城的用户涨起来之后，单库开始吃力。MySQL 复制可以把源库上的数据变更同步到一个或多个副本：

```
┌── Replica 1：只读查询
Source ─────┼── Replica 2：报表分析
            └── Replica 3：容灾备用
```

### 复制能做什么？

- 读写分离；
- 容灾；
- 备份卸载；
- 报表查询隔离；
- 数据迁移；
- 滚动升级辅助。

### 复制默认不等于强一致

异步复制存在延迟。主库刚提交的数据，副本可能尚未重放完成。

因此"写入后立即从副本读取"可能读不到最新数据。常见处理方式：

- 写后读主库；
- 关键请求等待复制位点；
- 使用一致性路由策略；
- 根据业务容忍度选择半同步或更强的高可用方案。

### GTID

GTID 为每个事务提供**全局唯一标识**，可以简化复制拓扑管理、故障切换和位点定位。

> 新建复制体系时，通常应认真评估并优先考虑 GTID，而不是长期依赖人工管理文件名与偏移量。

### 复制不是备份

如果误删一张表，删除操作也会同步到副本。**复制提高可用性，但不能代替独立备份和时间点恢复。**

---

## 第十九站：高可用——从单机到 InnoDB Cluster

单机数据库存在明显问题：

- 宿主机故障；
- 磁盘损坏；
- 进程崩溃；
- 网络中断；
- 维护升级需要停机。

MySQL Group Replication 可以组成具备成员管理、故障检测和主节点选举能力的复制组。**InnoDB Cluster** 则把 MySQL Server、Group Replication、MySQL Shell 和 MySQL Router 组合成更完整的高可用方案：

```
Application
    │
MySQL Router
    │
┌─────────── InnoDB Cluster ───────────┐
│  Primary   Secondary   Secondary     │
└──────────────────────────────────────┘
```

### 单主模式

同一时间主要由一个节点处理写入，其他节点提供副本与故障接管能力。

优点：写入冲突更少、应用模型相对简单、更符合多数业务系统习惯。

### 多主模式

多个成员都可以接受写入，但冲突处理、热点数据、应用约束和容量规划会更加复杂。

> 不要因为"多主听起来更高级"就默认选择它。

### 高可用不只是搭集群

真正可用的 HA 体系还需要：

- 客户端自动重连；
- 连接路由；
- 健康检查；
- 故障演练；
- 脑裂和网络分区处理；
- 监控告警；
- 容量与延迟评估；
- 备份恢复；
- 明确的人工接管流程。

> 集群能减少单点故障，但无法自动修复错误 SQL、业务逻辑 Bug 和人为误操作。

---

## 第二十站：安全——不要让数据库裸奔

### 最小权限原则

应用账号只授予业务所需权限：

```sql
GRANT SELECT, INSERT, UPDATE, DELETE
ON shop.*
TO 'shop_app'@'10.0.10.%';
```

普通应用通常不需要：`DROP`、`ALTER`、`GRANT OPTION`、全局权限、系统库写权限。

### 防止 SQL 注入

错误示例：

```sql
"SELECT * FROM users WHERE email = '" + userInput + "'"
```

正确做法是使用**参数化查询或预编译语句**：

```sql
SELECT id, username, email
FROM users
WHERE email = ?;
```

> SQL 注入不能靠手工替换引号解决。

### 网络安全

- 不要直接把 3306 端口暴露到公网；
- 使用安全组、防火墙和私有网络；
- 限制允许连接的主机；
- 需要时启用 TLS；
- 定期轮换密码和密钥；
- 禁止应用使用 root；
- 审计异常登录与权限变更。

### 敏感数据

密码不能明文保存，应保存经过**专用密码哈希算法**处理的结果。身份证号、手机号、银行卡号等敏感字段要根据法规和业务要求进行加密、脱敏、访问控制与审计。

### 删除与变更操作

线上高风险操作应具备：工单或审批记录、影响行数预估、备份或回滚方案、分批执行、双人复核、变更窗口、实时监控。

---

## 第二十一站：线上故障排查清单

当数据库突然变慢，阿泽总结了一套按顺序排查的清单。

### 1. 先看现象

- 是所有请求慢，还是某个接口慢？
- 是延迟升高，还是错误率升高？
- 是读慢、写慢，还是连接不上？
- 是持续问题，还是周期性抖动？
- 是否刚刚发布、迁移或改过配置？

### 2. 看连接和运行状态

```sql
SHOW FULL PROCESSLIST;
```

重点观察：大量长时间运行 SQL、锁等待、连接数激增、大量 `Sleep` 连接、复制线程异常、DDL 阻塞。

### 3. 看 InnoDB 状态

```sql
SHOW ENGINE INNODB STATUS\G
```

检查：最近死锁、事务与锁等待、Buffer Pool、I/O、后台线程状态。

### 4. 看系统资源

数据库问题不一定只在数据库内部：

- CPU 是否打满；
- 内存是否不足或发生 Swap；
- 磁盘延迟是否升高；
- IOPS 是否达到上限；
- 文件系统是否接近满盘；
- 网络是否丢包；
- 容器是否触发资源限制。

### 5. 看变更

很多故障都与变更相关：新 SQL、新索引或删索引、数据量突增、批处理任务、参数调整、版本升级、统计信息变化、流量路由变化。

### 6. 不要一上来就重启

重启可能暂时解除连接堆积，却会丢失现场信息，并可能造成更长恢复时间。除非已经确认必须重启，否则应先保存：慢查询、进程列表、锁等待、系统指标、错误日志、复制状态、最近变更记录。

---

## 第二十二站：版本升级——数据库升级不是换一个镜像标签

版本升级可能涉及：删除或弃用的参数、保留字变化、默认认证插件变化、排序规则变化、SQL 行为变化、驱动兼容性、复制兼容性、数据字典升级、备份工具兼容性。

推荐流程：

```
阅读发行说明
   ↓
运行升级检查工具
   ↓
克隆生产数据到测试环境
   ↓
升级并执行完整回归
   ↓
对比执行计划与性能
   ↓
验证备份、恢复和复制
   ↓
制定回滚方案
   ↓
灰度或滚动升级
```

MySQL Shell 提供 **Upgrade Checker Utility**，可以在升级前检查兼容性问题。

> 千万不要直接在唯一一套生产实例上试升级。

---

## 第二十三站：一个完整的下单事务示例——把知识串起来

学到这里，阿泽终于可以把前面的知识串成一个完整的下单流程了。

假设用户购买商品 `id = 1`，数量为 2：

```sql
START TRANSACTION;

-- 1. 原子扣减库存
UPDATE products
SET stock = stock - 2
WHERE id = 1
  AND status = 1
  AND stock >= 2;

-- 应用程序必须检查受影响行数，若为 0 则回滚

-- 2. 创建订单
INSERT INTO orders (
  order_no,
  user_id,
  status,
  total_amount
) VALUES (
  '202607220001',
  1,
  10,
  798.00
);

SET @order_id = LAST_INSERT_ID();

-- 3. 保存下单时的商品快照
INSERT INTO order_items (
  order_id,
  product_id,
  product_name,
  unit_price,
  quantity,
  subtotal
)
SELECT
  @order_id,
  id,
  name,
  price,
  2,
  price * 2
FROM products
WHERE id = 1;

COMMIT;
```

真实系统还应处理：

- 订单号唯一性；
- 幂等；
- 超时取消；
- 支付回调重复通知；
- 库存释放；
- 优惠券锁定；
- 消息发送一致性；
- 异常重试；
- 分布式事务或最终一致性。

> 这说明数据库知识最终必须回到业务语义：**SQL 写得正确，只是第一步。**

---

## 第二十四站：MySQL 常见误区——别再踩了

阿泽把团队踩过的坑整理成"误区清单"，新人入职必读：

### 误区 1：加了索引就一定快

索引可能不匹配查询、选择性太低、统计信息不准确，或者返回数据比例过高。必须看执行计划和真实耗时。

### 误区 2：表越少越简单

把所有字段塞进一张表，会造成重复数据、更新异常、超宽行和难以维护的业务逻辑。

### 误区 3：事务越大越安全

大事务会增加锁持有时间、日志量、复制延迟和回滚成本。安全不等于把所有操作包进一个无限大的事务。

### 误区 4：主从复制就是备份

误删除、错误更新和恶意操作同样会被复制。复制与备份解决的是不同问题。

### 误区 5：数据库慢就加机器

如果根因是无索引查询、深分页、N+1 或大事务，盲目扩容只会推迟故障。

### 误区 6：ORM 让开发者不必学 SQL

ORM 提高开发效率，但最终生成的仍然是 SQL。不了解索引、事务和执行计划，就很难正确处理复杂性能问题。

### 误区 7：备份成功就能恢复

备份文件可能损坏、缺少权限对象、缺少 Binlog、版本不兼容或恢复时间过长。**只有恢复演练成功，才说明备份体系真正可用。**

---

## 第二十五站：30 天 MySQL 学习路线

阿泽把学习路径整理成了四周计划，供后来者参考。

### 第 1 周：SQL 基础

学习目标：

- 数据库、表、行、列；
- 数据类型；
- `CREATE TABLE`；
- `INSERT`、`SELECT`、`UPDATE`、`DELETE`；
- 条件、排序、分页；
- 聚合与分组。

实践任务：设计图书管理系统或记账系统。

### 第 2 周：进阶查询与设计

学习目标：

- `JOIN`；
- 子查询；
- CTE；
- 窗口函数；
- 主键、唯一键、外键；
- 范式与适度反范式；
- 字符集与排序规则。

实践任务：完成一个带用户、商品、订单和统计报表的数据库。

### 第 3 周：索引与事务

学习目标：

- B-Tree 索引；
- 聚簇索引与二级索引；
- 联合索引；
- 覆盖索引；
- `EXPLAIN ANALYZE`；
- ACID；
- 隔离级别；
- MVCC；
- 行锁、间隙锁与死锁。

实践任务：制造慢查询和死锁，再亲自定位和优化。

### 第 4 周：运维与架构

学习目标：

- 慢查询日志；
- Performance Schema；
- Buffer Pool；
- 备份恢复；
- Binlog 与 PITR；
- GTID 复制；
- 高可用；
- 安全与权限；
- 升级与回滚。

实践任务：

1. 做一次完整备份；
2. 删除测试数据；
3. 恢复到指定时间点；
4. 搭建一个副本；
5. 模拟主库故障；
6. 记录完整操作手册。

---

## 第二十六站：从"会用"到"精通"的能力模型

### 入门

- 能安装和连接 MySQL；
- 能创建数据库和表；
- 能写基本增删改查；
- 理解主键、唯一键和外键。

### 熟练

- 能写多表关联、聚合和窗口函数；
- 能根据查询设计联合索引；
- 会查看执行计划；
- 能正确使用事务；
- 能避免 SQL 注入和越权访问。

### 进阶

- 理解 InnoDB、MVCC、Redo、Undo 和 Binlog；
- 能定位慢查询、锁等待和死锁；
- 能进行容量评估与参数调优；
- 能设计备份恢复和复制方案；
- 能安全执行线上数据变更。

### 精通

- 能从业务模型、数据分布和访问模式出发设计数据库；
- 能在正确性、性能、成本和复杂度之间做权衡；
- 能构建监控、备份、恢复、复制、高可用和升级体系；
- 能处理真实生产事故，并通过工程制度减少事故重演；
- 知道什么时候继续使用 MySQL，什么时候引入缓存、搜索引擎、分析数据库、消息队列或分布式存储。

> 所谓"精通"，不是背下所有参数，而是面对复杂问题时，知道如何观察、验证、推理和取舍。

---

## 结语：三层台阶，缺一不可

故事讲完了。

阿泽从入职第一天那个"订单页卡三天、备份从未验证"的烂摊子开始，一路走到微风商城的数据稳如磐石。他总结道，MySQL 的学习可以分为三层：

**第一层是语法**：会建表、会查询、会更新；

**第二层是原理**：理解索引、事务、锁、MVCC 和日志；

**第三层是工程**：懂监控、备份、恢复、复制、安全、高可用和变更管理。

只会第一层，能够完成简单开发；掌握第二层，能够解决性能和并发问题；进入第三层，才真正具备支撑生产系统的能力。

学习数据库最有效的方法，不是不断收藏文章，而是亲手完成这几个动作：

- 设计一套真实表结构；
- 写出几十条有业务意义的查询；
- 构造一次慢查询并优化；
- 构造一次死锁并分析；
- 做一次完整备份与恢复；
- 模拟一次数据库故障切换。

当你能解释一条 SQL 为什么这样执行、一个索引为什么有效、一次事务为什么冲突、一份备份如何恢复时，你才真正走上了 MySQL 从入门到精通的道路。

> 建议在实际项目中逐条实践，并把备份恢复演练当成定期任务。数据库不是看会的，而是用会的、练会的。

---

## 官方参考资料

1. MySQL 9.7 Reference Manual：https://dev.mysql.com/doc/refman/9.7/en/
2. MySQL 8.4 Reference Manual：https://dev.mysql.com/doc/refman/8.4/en/
3. MySQL Releases: Innovation and LTS：https://dev.mysql.com/doc/refman/8.4/en/mysql-releases.html
4. The InnoDB Storage Engine：https://dev.mysql.com/doc/refman/8.4/en/innodb-storage-engine.html
5. InnoDB Transaction Model：https://dev.mysql.com/doc/refman/8.4/en/innodb-transaction-model.html
6. Optimizing the MySQL Server：https://dev.mysql.com/doc/refman/8.4/en/optimizing-server.html
7. mysqldump — A Database Backup Program：https://dev.mysql.com/doc/refman/9.7/en/mysqldump.html
8. MySQL Group Replication：https://dev.mysql.com/doc/refman/8.4/en/group-replication.html
9. MySQL Shell Upgrade Checker Utility：https://dev.mysql.com/doc/mysql-shell/9.7/en/mysql-shell-utilities-upgrade.html

---

> **免责声明：**本文示例用于学习和演示。生产环境中的账号权限、备份策略、参数配置、版本升级和高可用架构，应根据实际业务、数据规模、基础设施与安全要求进行验证。
