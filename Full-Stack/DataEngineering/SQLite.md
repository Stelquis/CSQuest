# [SQLite 从入门到精通：一篇文章掌握轻量级数据库的核心能力](https://mp.weixin.qq.com/s/WH_6PhfS8bgLUapDGpfN9w)

> 自由开发者陆离决定给自己的"拾光笔记"应用彻底重做本地存储。他不想引入一台笨重的数据库服务器，而是带着一个 `notes.db` 文件，从零开始学习 SQLite：建表、约束、事务、索引、WAL、FTS5 全文搜索，一路把个人笔记应用打磨成支持全文检索、可备份可迁移的可靠本地数据库。这篇文章就跟随陆离的笔记应用之旅，把 SQLite 从入门到精通的完整路线走一遍。

---

## 一、SQLite 到底是什么？

SQLite 是一个嵌入式关系型数据库。

它与 MySQL、PostgreSQL 最大的区别是：SQLite 不需要单独启动数据库服务器，也不需要配置端口、用户名和密码。应用程序直接通过 SQLite 库读写数据库文件。

一个完整的 SQLite 数据库，通常就是一个文件：

```text
notes.db
```

应用程序打开这个文件后，就可以执行建表、查询、更新和事务等操作。

SQLite 的核心特点：

- 零配置：不需要部署数据库服务。
- 单文件存储：复制数据库文件即可迁移数据。
- 跨平台：支持 Windows、macOS、Linux、Android、iOS 和众多嵌入式系统。
- 支持事务：具备原子性、一致性、隔离性和持久性。
- 体积小：非常适合嵌入应用程序。
- SQL 功能完整：支持索引、视图、触发器、子查询、公共表表达式和窗口函数等。
- 扩展能力强：支持 JSON、FTS5 全文搜索、R-Tree 空间索引等功能。

截至 2026 年 7 月，SQLite 官网发布的稳定版本为 3.53.3。本文所讲的内容面向现代 SQLite 3.x。

## 二、SQLite 适合哪些场景？

SQLite 特别适合以下场景：

1. 手机 App 本地数据

Android 和 iOS 应用经常使用 SQLite 保存：

- 用户设置
- 离线文章
- 聊天记录
- 下载任务
- 浏览历史
- 缓存数据
- 游戏存档

2. 桌面应用

很多桌面软件都需要一个不依赖服务器的本地数据库，例如：

- 笔记软件
- 音乐播放器
- 下载工具
- 财务管理软件
- 开发者工具
- 本地知识库

3. 浏览器与客户端缓存

浏览器、桌面客户端和同步工具经常使用 SQLite 管理结构化缓存。

4. 嵌入式与边缘设备

在资源有限的设备上，部署完整数据库服务器往往不现实，而 SQLite 可以直接嵌入程序。

5. 中小型网站或内部工具

如果写入并发不高，SQLite 也可以承担服务端数据库角色。对于个人博客、后台管理工具、原型系统、低流量 API 和定时任务，SQLite 往往足够好用。

SQLite 不太适合什么？

SQLite 并不是所有场景的最佳答案。

以下情况通常更适合 MySQL、PostgreSQL 等客户端—服务器数据库：

- 大量客户端通过网络直接连接数据库；
- 持续存在很高的并发写入；
- 需要复杂的用户、角色和权限体系；
- 需要大型集群、分片或跨区域复制；
- 需要数据库服务器集中管理大量租户；
- 数据库文件必须放在不可靠的网络文件系统中。

需要记住一句话：

SQLite 擅长"把数据库嵌入应用"，而不是"让很多远程客户端直接连接数据库服务器"。

## 三、安装 SQLite

macOS

macOS 通常已经自带 SQLite，可以在终端中执行：

```bash
sqlite3 --version
```

也可以使用 Homebrew 安装较新的版本：

```bash
brew install sqlite
```

Ubuntu / Debian

```bash
sudo apt update
sudo apt install sqlite3
```

Windows

可以从 SQLite 官方下载页面获取命令行工具压缩包，解压后将 `sqlite3.exe` 加入环境变量。

安装完成后执行：

```bash
sqlite3 --version
```

## 四、创建第一个数据库

在终端中执行：

```bash
sqlite3 notes.db
```

如果 `notes.db` 不存在，SQLite 会在写入数据后创建它。

进入交互式命令行后，可以执行：

```sql
SELECT sqlite_version();
```

退出 SQLite：

```bash
.quit
```

常用命令行指令

SQLite 命令行中，以点号开头的是 Shell 命令，而不是 SQL。

```text
.help                  查看帮助
.databases             查看已连接数据库
.tables                查看所有表
.schema                查看完整表结构
.schema users          查看 users 表结构
.headers on            显示列名
.mode column           使用表格形式显示结果
.mode box              使用边框表格显示结果
.timer on              显示 SQL 执行耗时
.eqp on                自动显示查询计划
.read init.sql         执行 SQL 文件
.output result.txt     将输出写入文件
.quit                  退出
```

推荐进入命令行后执行：

```bash
.headers on
.mode box
.timer on
```

这样查询结果更容易阅读。

## 五、理解 SQLite 的数据类型

SQLite 支持五种基础存储类型：

| 类型 | 含义 |
| --- | --- |
| NULL | 空值 |
| INTEGER | 有符号整数 |
| REAL | 浮点数 |
| TEXT | UTF-8、UTF-16 文本 |
| BLOB | 二进制数据 |

与一些传统数据库不同，SQLite 采用动态类型系统。类型主要附着在"值"上，而不是完全附着在"列"上。

例如：

```sql
CREATE TABLE demo (
    value INTEGER
);
```

在普通表中，SQLite 可能仍然允许向 `value` 列写入某些文本值。

类型亲和性

SQLite 会根据列声明推导类型亲和性：

- 名称中包含 INT：INTEGER 亲和性；
- 包含 CHAR、CLOB、TEXT：TEXT 亲和性；
- 包含 REAL、FLOA、DOUB：REAL 亲和性；
- 包含 BLOB 或没有声明类型：BLOB 亲和性；
- 其他情况：NUMERIC 亲和性。

因此，下面这些声明并不是完全独立的底层类型：

```text
VARCHAR(100)
BOOLEAN
DATE
DATETIME
DECIMAL(10, 2)
```

它们最终仍会映射到 SQLite 的类型亲和性规则。

使用 STRICT 表获得更严格的类型检查

现代 SQLite 支持 `STRICT` 表：

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    username TEXT NOT NULL,
    age INTEGER,
    score REAL,
    avatar BLOB
) STRICT;
```

STRICT 表会执行更严格的类型约束，适合新项目。

STRICT 表常用的列类型包括：

```text
INT
INTEGER
REAL
TEXT
BLOB
ANY
```

## 六、设计第一个业务表

我们从一个用户表开始：

```sql
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    status INTEGER NOT NULL DEFAULT 1
        CHECK (status IN (0, 1)),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
) STRICT;
```

这里使用了多个重要约束。

PRIMARY KEY

```sql
id INTEGER PRIMARY KEY
```

在普通 rowid 表中，`INTEGER PRIMARY KEY` 会成为内部 `rowid` 的别名，通常是最简单、高效的整数主键方案。

插入数据时可以不指定 `id`：

```sql
INSERT INTO users (username, email)
VALUES ('alice', 'alice@example.com');
```

SQLite 会自动生成主键。

AUTOINCREMENT 是否必要？

很多人习惯写：

```sql
id INTEGER PRIMARY KEY AUTOINCREMENT
```

但大多数项目只需要：

```sql
id INTEGER PRIMARY KEY
```

`AUTOINCREMENT` 的主要作用不是"让主键自动增长"，而是尽量保证历史上出现过的最大 rowid 不被重新使用。它会带来额外的空间和写入开销。

除非业务明确要求"已使用过的主键值永不再次出现"，否则通常不需要 `AUTOINCREMENT`。

NOT NULL

```sql
username TEXT NOT NULL
```

表示该字段不能为 NULL。

UNIQUE

```sql
email TEXT NOT NULL UNIQUE
```

保证邮箱不重复。

DEFAULT

```sql
status INTEGER NOT NULL DEFAULT 1
```

插入时没有提供 `status`，就自动使用 1。

CHECK

```sql
CHECK (status IN (0, 1))
```

限制状态值只能是 0 或 1。

## 七、CRUD：增删改查

CRUD 分别代表：

- Create：新增；
- Read：查询；
- Update：修改；
- Delete：删除。

1. 插入数据

```sql
INSERT INTO users (username, email)
VALUES ('alice', 'alice@example.com');
```

一次插入多行：

```sql
INSERT INTO users (username, email)
VALUES
    ('bob', 'bob@example.com'),
    ('carol', 'carol@example.com'),
    ('david', 'david@example.com');
```

插入后立即返回数据：

```sql
INSERT INTO users (username, email)
VALUES ('emma', 'emma@example.com')
RETURNING id, username, created_at;
```

2. 查询数据

查询所有列：

```sql
SELECT *
FROM users;
```

生产代码中更推荐明确列名：

```sql
SELECT id, username, email, status
FROM users;
```

按条件查询：

```sql
SELECT id, username, email
FROM users
WHERE status = 1;
```

排序和限制数量：

```sql
SELECT id, username, created_at
FROM users
ORDER BY created_at DESC
LIMIT 10;
```

分页：

```sql
SELECT id, username
FROM users
ORDER BY id
LIMIT 20 OFFSET 40;
```

对于深分页，更推荐使用游标式分页：

```sql
SELECT id, username
FROM users
WHERE id > 1000
ORDER BY id
LIMIT 20;
```

3. 更新数据

```sql
UPDATE users
SET status = 0
WHERE id = 3;
```

更新并返回结果：

```sql
UPDATE users
SET email = 'new-alice@example.com'
WHERE id = 1
RETURNING id, username, email;
```

永远注意 WHERE 条件。下面的语句会更新整张表：

```sql
UPDATE users
SET status = 0;
```

4. 删除数据

```sql
DELETE FROM users
WHERE id = 4;
```

删除所有数据：

```sql
DELETE FROM users;
```

删除表：

```sql
DROP TABLE users;
```

## 八、使用 UPSERT 处理冲突

假设用户名已经存在，再次插入时希望更新邮箱：

```sql
INSERT INTO users (username, email)
VALUES ('alice', 'alice-new@example.com')
ON CONFLICT(username)
DO UPDATE SET
    email = excluded.email;
```

`excluded.email` 表示本次原本准备插入的值。

如果冲突时什么都不做：

```sql
INSERT INTO users (username, email)
VALUES ('alice', 'alice@example.com')
ON CONFLICT(username) DO NOTHING;
```

UPSERT 很适合：

- 同步数据；
- 导入数据；
- 更新缓存；
- 保存配置；
- 维护统计表。

## 九、表关联与外键

下面创建笔记表：

```sql
PRAGMA foreign_keys = ON;

CREATE TABLE notes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL DEFAULT '',
    is_deleted INTEGER NOT NULL DEFAULT 0
        CHECK (is_deleted IN (0, 1)),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) STRICT;
```

为什么要显式开启外键？

不要假设外键检查已经开启。应用每次建立数据库连接后，都应该显式执行：

```sql
PRAGMA foreign_keys = ON;
```

验证是否开启：

```sql
PRAGMA foreign_keys;
```

返回 1 表示开启。

ON DELETE CASCADE

当用户被删除时，其笔记也会自动删除：

```sql
DELETE FROM users
WHERE id = 1;
```

如果不希望级联删除，可以选择：

```text
RESTRICT
NO ACTION
SET NULL
SET DEFAULT
CASCADE
```

实际选择取决于业务规则。

## 十、JOIN：关联查询

插入一些笔记：

```sql
INSERT INTO notes (user_id, title, body)
VALUES
    (1, '学习 SQLite', '今天开始学习 SQLite。'),
    (1, '索引笔记', '索引可以加速查询。'),
    (2, '旅行计划', '周末去爬山。');
```

INNER JOIN

只返回两张表中可以匹配的数据：

```sql
SELECT
    notes.id,
    notes.title,
    users.username
FROM notes
JOIN users
    ON users.id = notes.user_id;
```

可以使用别名简化：

```sql
SELECT
    n.id,
    n.title,
    u.username
FROM notes AS n
JOIN users AS u
    ON u.id = n.user_id;
```

LEFT JOIN

即使用户没有笔记，也保留用户记录：

```sql
SELECT
    u.id,
    u.username,
    n.title
FROM users AS u
LEFT JOIN notes AS n
    ON n.user_id = u.id;
```

统计每个用户的笔记数量

```sql
SELECT
    u.id,
    u.username,
    COUNT(n.id) AS note_count
FROM users AS u
LEFT JOIN notes AS n
    ON n.user_id = u.id
   AND n.is_deleted = 0
GROUP BY u.id, u.username
ORDER BY note_count DESC;
```

## 十一、聚合查询

SQLite 常用聚合函数包括：

```text
COUNT()
SUM()
AVG()
MIN()
MAX()
```

统计笔记总数：

```sql
SELECT COUNT(*) AS total
FROM notes;
```

按用户统计：

```sql
SELECT
    user_id,
    COUNT(*) AS total
FROM notes
WHERE is_deleted = 0
GROUP BY user_id;
```

筛选笔记数量不少于 5 条的用户：

```sql
SELECT
    user_id,
    COUNT(*) AS total
FROM notes
WHERE is_deleted = 0
GROUP BY user_id
HAVING COUNT(*) >= 5;
```

`WHERE` 在分组前过滤行，`HAVING` 在分组后过滤聚合结果。

## 十二、子查询与公共表表达式

子查询

找出笔记数量高于平均值的用户：

```sql
SELECT user_id, COUNT(*) AS note_count
FROM notes
GROUP BY user_id
HAVING COUNT(*) > (
    SELECT AVG(user_note_count)
    FROM (
        SELECT COUNT(*) AS user_note_count
        FROM notes
        GROUP BY user_id
    )
);
```

CTE：让复杂 SQL 更清晰

```sql
WITH user_note_stats AS (
    SELECT
        user_id,
        COUNT(*) AS note_count
    FROM notes
    WHERE is_deleted = 0
    GROUP BY user_id
)
SELECT
    u.username,
    s.note_count
FROM user_note_stats AS s
JOIN users AS u
    ON u.id = s.user_id
ORDER BY s.note_count DESC;
```

递归 CTE

生成 1 到 10：

```sql
WITH RECURSIVE numbers(n) AS (
    SELECT 1
    UNION ALL
    SELECT n + 1
    FROM numbers
    WHERE n < 10
)
SELECT n
FROM numbers;
```

递归 CTE 常用于：

- 树形结构；
- 分类层级；
- 组织架构；
- 路径遍历；
- 序列生成。

## 十三、窗口函数

窗口函数可以在保留明细行的同时执行排名、累计和分组计算。

为每个用户的笔记排序：

```sql
SELECT
    id,
    user_id,
    title,
    created_at,
    ROW_NUMBER() OVER (
        PARTITION BY user_id
        ORDER BY created_at DESC
    ) AS row_number
FROM notes;
```

每个用户只取最新一篇笔记：

```sql
WITH ranked_notes AS (
    SELECT
        id,
        user_id,
        title,
        created_at,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY created_at DESC, id DESC
        ) AS rn
    FROM notes
    WHERE is_deleted = 0
)
SELECT *
FROM ranked_notes
WHERE rn = 1;
```

常见窗口函数包括：

```text
ROW_NUMBER()
RANK()
DENSE_RANK()
LAG()
LEAD()
FIRST_VALUE()
LAST_VALUE()
SUM() OVER (...)
AVG() OVER (...)
```

## 十四、事务：保证数据一致性

假设用户转出 100 元，同时另一个账户转入 100 元。这两个操作必须一起成功或一起失败。

```sql
BEGIN;

UPDATE accounts
SET balance = balance - 100
WHERE id = 1;

UPDATE accounts
SET balance = balance + 100
WHERE id = 2;

COMMIT;
```

发生异常时：

```sql
ROLLBACK;
```

SQLite 事务的四个特性

原子性 Atomicity

事务中的操作要么全部完成，要么全部撤销。

一致性 Consistency

事务执行前后，数据库约束和业务规则保持有效。

隔离性 Isolation

并发事务之间不会随意看到对方尚未提交的中间状态。

持久性 Durability

事务提交后，即使程序退出或系统重启，数据也应保留下来。

DEFERRED、IMMEDIATE 和 EXCLUSIVE

默认形式：

```sql
BEGIN;
```

等价于：

```sql
BEGIN DEFERRED;
```

它不会立刻申请写锁，而是在真正写入时再尝试升级为写事务。

如果已经确定接下来要写数据，可以使用：

```sql
BEGIN IMMEDIATE;
```

这样会尽早取得写事务，减少执行到一半才遇到"database is locked"的情况。

```sql
BEGIN EXCLUSIVE;
```

会申请更强的锁。实际项目中通常优先考虑 DEFERRED 或 IMMEDIATE。

SAVEPOINT：局部回滚

```sql
BEGIN;

INSERT INTO users (username, email)
VALUES ('frank', 'frank@example.com');

SAVEPOINT create_notes;

INSERT INTO notes (user_id, title)
VALUES (9999, '无效笔记');

ROLLBACK TO create_notes;
RELEASE create_notes;

COMMIT;
```

SAVEPOINT 适合：

- 嵌套业务流程；
- 批处理；
- 允许局部失败的导入任务；
- 在大事务中设置恢复点。

## 十五、索引：性能优化的核心

没有合适索引时，SQLite 可能需要扫描整张表。

例如：

```sql
SELECT id, title
FROM notes
WHERE user_id = 100;
```

可以创建索引：

```sql
CREATE INDEX idx_notes_user_id
ON notes(user_id);
```

复合索引

查询经常同时按用户过滤并按更新时间排序：

```sql
SELECT id, title, updated_at
FROM notes
WHERE user_id = ?
  AND is_deleted = 0
ORDER BY updated_at DESC
LIMIT 20;
```

可以创建：

```sql
CREATE INDEX idx_notes_user_updated
ON notes(user_id, updated_at DESC);
```

部分索引

如果绝大多数查询只关心未删除笔记：

```sql
CREATE INDEX idx_notes_active_user_updated
ON notes(user_id, updated_at DESC)
WHERE is_deleted = 0;
```

部分索引只保存满足条件的行，通常更小。

唯一索引

```sql
CREATE UNIQUE INDEX idx_users_email
ON users(email);
```

如果表结构里已经写了 `UNIQUE`，SQLite 通常会自动建立相应索引，不必重复创建。

覆盖索引

假设查询只读取：

```sql
SELECT title, updated_at
FROM notes
WHERE user_id = ?
ORDER BY updated_at DESC;
```

可考虑：

```sql
CREATE INDEX idx_notes_cover
ON notes(user_id, updated_at DESC, title);
```

查询所需数据全部位于索引中时，SQLite 可能无需回表，这就是覆盖索引。

复合索引的列顺序

复合索引：

```sql
CREATE INDEX idx_demo
ON notes(user_id, is_deleted, updated_at);
```

更容易支持：

```sql
WHERE user_id = ?
```

以及：

```sql
WHERE user_id = ?
  AND is_deleted = ?
```

但通常不能高效支持仅按 `is_deleted` 查询。

设计复合索引时，应重点考虑：

1. 高频查询条件；
2. 等值过滤列；
3. 范围查询列；
4. 排序需求；
5. 返回列；
6. 数据选择性。

索引不是越多越好

索引会增加：

- 数据库文件体积；
- 插入成本；
- 更新成本；
- 删除成本；
- 维护复杂度。

原则是：

为真实的高频查询建立索引，而不是为每一列都建立索引。

## 十六、查看查询计划

使用：

```sql
EXPLAIN QUERY PLAN
SELECT id, title
FROM notes
WHERE user_id = 100
ORDER BY updated_at DESC;
```

结果中常见关键词：

- SCAN：扫描表或索引；
- SEARCH：通过索引定位；
- USING INDEX：使用索引；
- USING COVERING INDEX：使用覆盖索引；
- USE TEMP B-TREE：可能为排序或分组创建临时 B-Tree。

例如：

```text
SEARCH notes USING INDEX idx_notes_user_updated (user_id=?)
```

说明查询使用了索引。

如果看到：

```text
SCAN notes
```

不一定代表有问题。小表、需要读取大部分数据、索引选择性低时，全表扫描可能反而更高效。

在命令行自动显示查询计划

```bash
.eqp on
```

之后执行查询，SQLite CLI 会自动显示查询计划。

## 十七、让查询优化器获得更准确的信息

SQLite 会根据统计信息选择查询计划。

推荐在适当时机运行：

```sql
PRAGMA optimize;
```

可以在以下时机执行：

- 数据库连接关闭前；
- 应用启动后偶尔执行；
- 创建索引后；
- 大量导入或删除数据后；
- 数据分布发生明显变化后。

现代 SQLite 会判断是否有必要执行相关分析，因此 `PRAGMA optimize` 通常比无条件频繁执行完整 ANALYZE 更适合作为日常维护手段。

## 十八、WAL 模式与并发

SQLite 默认通常使用回滚日志模式。可以切换为 WAL：

```sql
PRAGMA journal_mode = WAL;
```

成功后返回：

```text
wal
```

WAL 是 Write-Ahead Logging，即预写式日志。

WAL 的基本思想

传统回滚日志模式会先保存旧数据，再修改数据库文件。

WAL 模式则先把新修改追加写入 `-wal` 文件，之后再通过检查点将内容合并回主数据库。

数据库旁边可能出现：

```text
notes.db
notes.db-wal
notes.db-shm
```

这是正常现象。

WAL 的优势

- 读操作通常不会阻塞写操作；
- 写操作通常不会阻塞已有读操作；
- 顺序追加写入，很多场景下性能更好；
- 适合存在多个读取连接的本地应用。

WAL 的限制

SQLite 即使处于 WAL 模式，通常仍然只有一个写事务可以同时执行。

也就是说：

- 多读：很好；
- 一写多读：很好；
- 多个持续高并发写入：不是 SQLite 的强项。

设置忙等待时间

多个连接竞争写锁时，可以设置：

```sql
PRAGMA busy_timeout = 5000;
```

表示遇到锁竞争时最多等待 5000 毫秒，而不是立即失败。

在程序中应为每个连接配置：

```sql
PRAGMA foreign_keys = ON;
PRAGMA busy_timeout = 5000;
```

`journal_mode=WAL` 一般会持久保存到数据库文件，但程序仍应检查设置是否成功。

检查点

WAL 数据最终需要合并回主数据库：

```sql
PRAGMA wal_checkpoint(PASSIVE);
```

还可以使用：

```sql
PRAGMA wal_checkpoint(FULL);
PRAGMA wal_checkpoint(RESTART);
PRAGMA wal_checkpoint(TRUNCATE);
```

一般情况下 SQLite 会自动执行检查点，不需要频繁手工干预。只有在数据库文件管理、备份或 WAL 文件持续增大时，才需要进一步分析。

不要把 WAL 数据库随意放到网络文件系统

WAL 依赖共享内存和文件锁机制，通常要求相关进程位于同一台主机上。对于网络共享目录，应仔细验证文件系统锁和一致性语义。

## 十九、批量写入为什么一定要用事务？

低效写法：

```sql
INSERT INTO logs(message) VALUES ('message 1');
INSERT INTO logs(message) VALUES ('message 2');
INSERT INTO logs(message) VALUES ('message 3');
```

如果应用让每条语句单独提交，数据库可能需要为每条记录完成一次持久化流程。

高效写法：

```sql
BEGIN IMMEDIATE;

INSERT INTO logs(message) VALUES ('message 1');
INSERT INTO logs(message) VALUES ('message 2');
INSERT INTO logs(message) VALUES ('message 3');

COMMIT;
```

批量导入上万条数据时，事务常常能带来数量级的性能提升。

进一步优化：

- 使用预编译语句；
- 复用同一条 INSERT；
- 分批提交；
- 避免每行都建立和关闭连接；
- 不要在循环中重复创建索引；
- 先导入数据，再创建非必要索引。

## 二十、预编译语句与 SQL 注入

错误做法：

```python
sql = f"SELECT * FROM users WHERE username = '{username}'"
```

如果用户名包含恶意 SQL，可能造成 SQL 注入。

正确做法是参数绑定：

```python
cursor.execute(
    "SELECT id, username, email FROM users WHERE username = ?",
    (username,)
)
```

SQLite 常见占位符形式包括：

```text
?
?1
:name
@name
$name
```

参数绑定不仅更安全，还可以复用预编译语句。

需要注意：

参数只能绑定"值"，不能直接绑定表名、列名或 SQL 关键字。

需要动态列名时，必须通过白名单映射：

```python
allowed_columns = {
    "name": "username",
    "time": "created_at",
}

order_column = allowed_columns.get(sort_key, "created_at")
sql = f"SELECT id, username FROM users ORDER BY {order_column}"
```

## 二十一、使用 Python 操作 SQLite

Python 标准库内置 `sqlite3`：

```python
import sqlite3

conn = sqlite3.connect("notes.db")
conn.row_factory = sqlite3.Row

conn.execute("PRAGMA foreign_keys = ON")
conn.execute("PRAGMA busy_timeout = 5000")
conn.execute("PRAGMA journal_mode = WAL")

conn.execute("""
CREATE TABLE IF NOT EXISTS tasks (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    completed INTEGER NOT NULL DEFAULT 0
        CHECK (completed IN (0, 1)),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
) STRICT
""")

with conn:
    cursor = conn.execute(
        "INSERT INTO tasks (title) VALUES (?) RETURNING id",
        ("学习 SQLite",)
    )
    task_id = cursor.fetchone()[0]

rows = conn.execute("""
SELECT id, title, completed, created_at
FROM tasks
WHERE completed = ?
ORDER BY id DESC
""", (0,)).fetchall()

for row in rows:
    print(dict(row))

conn.close()
```

Python 工程实践

1. 使用参数绑定；
2. 使用上下文管理事务；
3. 不要跨线程随意共享同一个连接；
4. 对长时间运行的应用建立清晰的连接生命周期；
5. 为每个新连接开启外键并设置超时；
6. 捕获异常后确保事务回滚；
7. 在日志中记录 SQL 类型、耗时和错误，但不要记录敏感参数。

## 二十二、JSON 数据

SQLite 提供 JSON 函数，可以在 TEXT 中存储和查询 JSON。

创建事件表：

```sql
CREATE TABLE events (
    id INTEGER PRIMARY KEY,
    event_type TEXT NOT NULL,
    payload TEXT NOT NULL CHECK (json_valid(payload)),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
) STRICT;
```

插入 JSON：

```sql
INSERT INTO events (event_type, payload)
VALUES (
    'user_login',
    json_object(
        'user_id', 1001,
        'device', 'iPhone',
        'success', 1
    )
);
```

读取字段：

```sql
SELECT
    id,
    json_extract(payload, '$.user_id') AS user_id,
    json_extract(payload, '$.device') AS device
FROM events;
```

也可以使用运算符：

```sql
SELECT
    payload -> '$.device' AS device_json,
    payload ->> '$.device' AS device_text
FROM events;
```

展开 JSON 数组：

```sql
SELECT value
FROM json_each('["SQLite", "MySQL", "PostgreSQL"]');
```

更新 JSON：

```sql
UPDATE events
SET payload = json_set(
    payload,
    '$.processed',
    1
)
WHERE id = 1;
```

什么时候适合使用 JSON？

适合：

- 属性结构经常变化；
- 保存外部 API 原始响应；
- 事件日志；
- 非核心扩展字段；
- 不需要频繁关联的配置数据。

不适合：

- 核心查询字段全部塞入 JSON；
- 需要大量 JOIN；
- 需要严格外键约束；
- 经常按内部字段过滤但没有建立表达式索引；
- 数据结构非常稳定，拆成普通列更清晰。

可以为 JSON 字段创建表达式索引：

```sql
CREATE INDEX idx_events_user_id
ON events(
    CAST(json_extract(payload, '$.user_id') AS INTEGER)
);
```

查询表达式应尽量与索引表达式保持一致。

## 二十三、FTS5 全文搜索

普通模糊查询：

```sql
SELECT *
FROM notes
WHERE body LIKE '%数据库%';
```

当数据量增大、关键词搜索变复杂时，可以使用 FTS5。

创建全文搜索表

```sql
CREATE VIRTUAL TABLE note_fts
USING fts5(
    title,
    body,
    content='notes',
    content_rowid='id'
);
```

将已有数据写入索引：

```sql
INSERT INTO note_fts(note_fts)
VALUES ('rebuild');
```

使用触发器保持同步

```sql
CREATE TRIGGER notes_ai
AFTER INSERT ON notes
BEGIN
    INSERT INTO note_fts(rowid, title, body)
    VALUES (new.id, new.title, new.body);
END;

CREATE TRIGGER notes_ad
AFTER DELETE ON notes
BEGIN
    INSERT INTO note_fts(note_fts, rowid, title, body)
    VALUES ('delete', old.id, old.title, old.body);
END;

CREATE TRIGGER notes_au
AFTER UPDATE ON notes
BEGIN
    INSERT INTO note_fts(note_fts, rowid, title, body)
    VALUES ('delete', old.id, old.title, old.body);

    INSERT INTO note_fts(rowid, title, body)
    VALUES (new.id, new.title, new.body);
END;
```

执行全文搜索

```sql
SELECT
    n.id,
    n.title,
    n.body,
    bm25(note_fts) AS score
FROM note_fts
JOIN notes AS n
    ON n.id = note_fts.rowid
WHERE note_fts MATCH 'SQLite'
ORDER BY score;
```

搜索短语：

```sql
WHERE note_fts MATCH '"query planner"'
```

限定列：

```sql
WHERE note_fts MATCH 'title:SQLite'
```

组合查询：

```sql
WHERE note_fts MATCH 'SQLite AND index'
```

FTS5 适合：

- 文章搜索；
- 笔记搜索；
- 聊天记录搜索；
- 本地文档库；
- 商品标题搜索；
- 离线知识库。

对于中文全文搜索，需要特别关注分词器。默认 tokenizer 对中文语义分词能力有限，实际项目可能需要预分词、N-gram 方案或自定义 tokenizer。

## 二十四、日期与时间

SQLite 通常使用以下方式保存时间：

1. ISO 8601 文本

```text
2026-07-23 12:30:00
```

优点是直观、可排序、易调试。

2. Unix 时间戳

```text
1784809800
```

适合计算和跨语言传输。

3. Julian Day

主要用于特定日期计算场景。

常用函数：

```sql
SELECT date('now');
SELECT time('now');
SELECT datetime('now');
SELECT unixepoch('now');
SELECT julianday('now');
```

本地时间：

```sql
SELECT datetime('now', 'localtime');
```

七天后：

```sql
SELECT datetime('now', '+7 days');
```

查询最近七天数据：

```sql
SELECT *
FROM events
WHERE created_at >= datetime('now', '-7 days');
```

工程上建议统一保存 UTC 时间，在展示层转换为用户时区。

## 二十五、视图

视图可以封装常用查询：

```sql
CREATE VIEW active_notes AS
SELECT
    n.id,
    n.user_id,
    u.username,
    n.title,
    n.body,
    n.updated_at
FROM notes AS n
JOIN users AS u
    ON u.id = n.user_id
WHERE n.is_deleted = 0;
```

之后可以像查询表一样使用：

```sql
SELECT *
FROM active_notes
WHERE user_id = 1;
```

视图适合：

- 隐藏复杂 JOIN；
- 统一过滤逻辑；
- 提供稳定的查询接口；
- 减少重复 SQL。

普通视图本身不保存查询结果，每次读取时仍会执行底层查询。

## 二十六、触发器

自动更新时间：

```sql
CREATE TRIGGER notes_set_updated_at
AFTER UPDATE OF title, body, is_deleted ON notes
FOR EACH ROW
WHEN new.updated_at = old.updated_at
BEGIN
    UPDATE notes
    SET updated_at = CURRENT_TIMESTAMP
    WHERE id = new.id;
END;
```

触发器可以用于：

- 维护审计日志；
- 同步全文索引；
- 自动更新统计；
- 保持派生字段一致；
- 实现复杂约束。

但触发器也会隐藏副作用。大型项目应控制触发器数量，并为触发器建立测试和文档。

## 二十七、软删除还是物理删除？

物理删除：

```sql
DELETE FROM notes
WHERE id = ?;
```

软删除：

```sql
UPDATE notes
SET is_deleted = 1
WHERE id = ?;
```

软删除的优点

- 可以恢复；
- 便于审计；
- 降低误删风险；
- 适合同步系统。

软删除的缺点

- 每个查询都要记得过滤；
- 唯一约束更复杂；
- 表会持续膨胀；
- 关联和统计容易遗漏条件。

可以利用部分唯一索引处理软删除后的唯一性：

```sql
CREATE UNIQUE INDEX idx_active_note_title
ON notes(user_id, title)
WHERE is_deleted = 0;
```

## 二十八、WITHOUT ROWID 表

普通 SQLite 表通常带有隐藏的 rowid。

某些以复合主键为核心、且不需要整数 rowid 的表，可以使用：

```sql
CREATE TABLE user_tags (
    user_id INTEGER NOT NULL,
    tag_id INTEGER NOT NULL,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (user_id, tag_id)
) WITHOUT ROWID;
```

适合：

- 复合主键表；
- 关联表；
- 主键不是整数；
- 希望避免额外 rowid 存储。

不要为了"高级"而盲目使用。普通业务实体表继续使用 `INTEGER PRIMARY KEY` 通常更简单。

## 二十九、数据库备份

方法一：SQLite CLI 的 `.backup`

进入 SQLite：

```bash
sqlite3 notes.db
```

执行：

```sql
.backup backup-notes.db
```

方法二：VACUUM INTO

```sql
VACUUM INTO 'backup-notes.db';
```

它会创建一个压缩整理后的新数据库文件。

方法三：导出 SQL

```bash
sqlite3 notes.db .dump > notes.sql
```

恢复：

```bash
sqlite3 restored.db < notes.sql
```

`.dump` 适合：

- 迁移；
- 版本控制测试数据；
- 查看数据库逻辑结构；
- 跨环境恢复。

对于大型生产数据库，应用程序还可以使用 SQLite Online Backup API，在数据库运行期间进行一致性备份。

不要直接复制正在写入的单个数据库文件

如果数据库正处于 WAL 模式并有活动连接，只复制主数据库文件可能遗漏尚未检查点的数据。

更可靠的方案是：

- `.backup`；
- `VACUUM INTO`；
- Online Backup API；
- 正确复制主文件、WAL 和 SHM，并严格管理连接状态。

## 三十、数据库完整性检查

检查数据库结构和页面：

```sql
PRAGMA integrity_check;
```

正常时返回：

```text
ok
```

更快的检查：

```sql
PRAGMA quick_check;
```

检查外键：

```sql
PRAGMA foreign_key_check;
```

注意：`integrity_check` 不能代替 `foreign_key_check`。

查看数据库基本信息：

```sql
PRAGMA page_size;
PRAGMA page_count;
PRAGMA freelist_count;
PRAGMA journal_mode;
PRAGMA synchronous;
```

估算数据库页面空间：

```sql
SELECT
    page_count * page_size AS database_bytes
FROM
    pragma_page_count(),
    pragma_page_size();
```

## 三十一、VACUUM 是做什么的？

删除大量数据后，SQLite 数据库文件通常不会立即缩小，而是把页面放入空闲列表，等待以后复用。

执行：

```sql
VACUUM;
```

可以：

- 重建数据库；
- 回收空闲空间；
- 整理页面；
- 在某些情况下改善局部性。

但 `VACUUM` 需要额外磁盘空间，并可能持有较长时间的锁，不应在高峰期随意执行。

查看空闲页面：

```sql
PRAGMA freelist_count;
```

可以根据业务特点考虑自动增量回收：

```sql
PRAGMA auto_vacuum = INCREMENTAL;
```

需要注意，`auto_vacuum` 的模式通常应在数据库创建早期规划，改变模式后可能需要执行 VACUUM 才能重建生效。

## 三十二、数据库迁移

当应用升级时，表结构也会变化。

推荐维护数据库版本：

```sql
PRAGMA user_version;
```

设置版本：

```sql
PRAGMA user_version = 2;
```

应用启动时读取版本，根据版本执行迁移：

```text
version 1 -> version 2
version 2 -> version 3
version 3 -> version 4
```

简单修改可以使用：

```sql
ALTER TABLE users
ADD COLUMN display_name TEXT;
```

复杂修改建议使用重建表流程：

```sql
BEGIN;

CREATE TABLE users_new (
    id INTEGER PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    display_name TEXT,
    status INTEGER NOT NULL DEFAULT 1,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
) STRICT;

INSERT INTO users_new (
    id,
    username,
    email,
    status,
    created_at
)
SELECT
    id,
    username,
    email,
    status,
    created_at
FROM users;

DROP TABLE users;

ALTER TABLE users_new
RENAME TO users;

PRAGMA user_version = 2;

COMMIT;
```

迁移前应：

1. 备份数据库；
2. 在真实数据副本上测试；
3. 把迁移放入事务；
4. 检查索引、触发器和视图；
5. 执行完整性检查；
6. 准备失败回滚方案。

## 三十三、常见性能误区

误区一：每次操作都打开和关闭连接

频繁连接会增加文件打开、初始化和配置成本。

更合理的方式是根据应用架构管理连接生命周期。

误区二：循环中每条 INSERT 都单独提交

应使用事务批量提交。

误区三：所有字段都建立索引

索引会拖慢写入，应该根据查询建立。

误区四：只看 SQL，不看查询计划

一条看起来很简单的 SQL，可能执行了全表扫描、临时排序或低效关联。

误区五：使用 `SELECT *`

明确字段可以：

- 减少数据读取；
- 减少对象转换；
- 增强接口稳定性；
- 提高覆盖索引机会。

误区六：对索引列进行不匹配的函数运算

已有索引：

```sql
CREATE INDEX idx_users_created
ON users(created_at);
```

下面的查询可能难以直接利用普通索引：

```sql
WHERE date(created_at) = '2026-07-23'
```

更推荐范围查询：

```sql
WHERE created_at >= '2026-07-23 00:00:00'
  AND created_at <  '2026-07-24 00:00:00'
```

误区七：滥用 OFFSET 深分页

```sql
LIMIT 20 OFFSET 100000
```

SQLite 仍需要跳过前面的大量记录。

更推荐：

```sql
WHERE id > ?
ORDER BY id
LIMIT 20
```

误区八：没有处理锁竞争

多连接写入时，应配置合理的事务、`busy_timeout` 和重试策略。

## 三十四、一套实用的 SQLite 初始化配置

下面是一套常见的本地应用配置起点：

```sql
PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;
PRAGMA busy_timeout = 5000;
PRAGMA synchronous = NORMAL;
```

含义：

- `foreign_keys=ON`：启用外键约束；
- `journal_mode=WAL`：改善读写并发；
- `busy_timeout=5000`：锁竞争时等待；
- `synchronous=NORMAL`：WAL 场景中常见的性能与持久性折中。

这不是适合所有项目的固定答案。

如果是财务、医疗、关键配置等对持久性极其敏感的数据，应仔细评估 `synchronous` 设置、存储设备、断电风险和备份策略，而不是机械照抄配置。

## 三十五、完整的笔记应用数据库结构

下面把前面的内容整理成一份可以直接执行的初始化脚本。

```sql
PRAGMA foreign_keys = ON;
PRAGMA journal_mode = WAL;
PRAGMA busy_timeout = 5000;

CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY,
    username TEXT NOT NULL UNIQUE,
    email TEXT NOT NULL UNIQUE,
    status INTEGER NOT NULL DEFAULT 1
        CHECK (status IN (0, 1)),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
) STRICT;

CREATE TABLE IF NOT EXISTS notes (
    id INTEGER PRIMARY KEY,
    user_id INTEGER NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL DEFAULT '',
    is_deleted INTEGER NOT NULL DEFAULT 0
        CHECK (is_deleted IN (0, 1)),
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id)
        REFERENCES users(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) STRICT;

CREATE INDEX IF NOT EXISTS idx_notes_active_user_updated
ON notes(user_id, updated_at DESC)
WHERE is_deleted = 0;

CREATE VIRTUAL TABLE IF NOT EXISTS note_fts
USING fts5(
    title,
    body,
    content='notes',
    content_rowid='id'
);

CREATE TRIGGER IF NOT EXISTS notes_ai
AFTER INSERT ON notes
BEGIN
    INSERT INTO note_fts(rowid, title, body)
    VALUES (new.id, new.title, new.body);
END;

CREATE TRIGGER IF NOT EXISTS notes_ad
AFTER DELETE ON notes
BEGIN
    INSERT INTO note_fts(note_fts, rowid, title, body)
    VALUES ('delete', old.id, old.title, old.body);
END;

CREATE TRIGGER IF NOT EXISTS notes_au
AFTER UPDATE ON notes
BEGIN
    INSERT INTO note_fts(note_fts, rowid, title, body)
    VALUES ('delete', old.id, old.title, old.body);

    INSERT INTO note_fts(rowid, title, body)
    VALUES (new.id, new.title, new.body);
END;

CREATE TRIGGER IF NOT EXISTS notes_set_updated_at
AFTER UPDATE OF title, body, is_deleted ON notes
FOR EACH ROW
WHEN new.updated_at = old.updated_at
BEGIN
    UPDATE notes
    SET updated_at = CURRENT_TIMESTAMP
    WHERE id = new.id;
END;

PRAGMA user_version = 1;
```

保存为：

```text
init.sql
```

执行：

```bash
sqlite3 notes.db < init.sql
```

## 三十六、SQLite 工程化最佳实践清单

表结构

- 新项目优先考虑 STRICT 表；
- 主键优先使用 INTEGER PRIMARY KEY；
- 不要无理由使用 AUTOINCREMENT；
- 明确使用 NOT NULL、UNIQUE、CHECK 和外键；
- 时间统一保存为 UTC；
- 核心字段不要全部塞进 JSON；
- 为迁移维护 user_version。

连接

- 每个连接显式开启外键；
- 设置合理的 busy_timeout；
- 根据场景评估 WAL；
- 不要在多个线程中无约束地共享连接；
- 不要长时间持有写事务；
- 及时关闭游标和连接。

SQL

- 使用参数绑定；
- 避免 SELECT *；
- 批量写入放入事务；
- 用 UPSERT 处理同步冲突；
- 深分页优先使用游标式分页；
- 复杂查询用 CTE 提高可读性。

索引

- 从真实查询出发；
- 检查 EXPLAIN QUERY PLAN；
- 复合索引注意列顺序；
- 适当使用部分索引和覆盖索引；
- 定期运行 PRAGMA optimize；
- 删除不再使用或高度重复的索引。

运维

- 建立自动备份；
- 定期验证备份可恢复；
- 使用 integrity_check 和 foreign_key_check；
- 监控数据库文件与 WAL 文件大小；
- 大量删除后评估是否需要 VACUUM；
- 升级 SQLite 库前阅读官方发布说明。

## 三十七、从入门到精通的学习路线

第一阶段：基础

掌握：

- 创建数据库；
- 创建表；
- SQLite 基础类型；
- INSERT、SELECT、UPDATE、DELETE；
- WHERE、ORDER BY、LIMIT；
- 基本约束。

练习：制作一个待办事项数据库。

第二阶段：关系与查询

掌握：

- 主键与外键；
- JOIN；
- GROUP BY；
- 聚合函数；
- 子查询；
- CTE；
- 窗口函数。

练习：制作一个用户、文章、评论系统。

第三阶段：事务与索引

掌握：

- 事务；
- SAVEPOINT；
- 索引；
- 复合索引；
- 部分索引；
- 查询计划；
- 批量写入。

练习：对十万条测试数据进行查询优化。

第四阶段：高级功能

掌握：

- WAL；
- 并发模型；
- JSON；
- FTS5；
- 触发器；
- 视图；
- WITHOUT ROWID；
- 备份恢复。

练习：制作一个支持全文搜索的离线笔记应用。

第五阶段：工程化

掌握：

- 数据库迁移；
- 版本管理；
- 自动备份；
- 完整性检查；
- 性能监控；
- 故障恢复；
- 多平台集成；
- 安全审计。

练习：将 SQLite 集成到一个真实的桌面、移动端或后端项目中。

## 三十八、常见问题

SQLite 能存多少数据？

SQLite 的理论上限很高，实际可用规模主要受文件系统、页面大小、查询设计、设备性能和应用模式影响。对于手机、桌面应用和中小型业务，容量通常不是最先遇到的瓶颈。

真正需要关注的是：

- 热点查询是否有索引；
- 是否持续高并发写入；
- 是否有超大 BLOB；
- 是否缺少归档机制；
- 是否存在低效深分页；
- 备份恢复是否可控。

SQLite 能用于生产环境吗？

可以。SQLite 被广泛用于浏览器、操作系统、移动应用、桌面软件、嵌入式设备和线上服务。

判断标准不应该是"SQLite 是否专业"，而应该是：

当前业务的并发模型、可用性目标和运维需求是否与 SQLite 匹配？

SQLite 支持多线程吗？

SQLite 库支持线程相关模式，但具体行为还取决于编译选项、驱动实现和语言绑定。

工程上最安全的做法通常是：

- 不让多个线程同时随意使用同一连接；
- 每个工作线程使用明确管理的连接；
- 控制写事务长度；
- 处理锁竞争；
- 阅读所用语言驱动的线程安全说明。

SQLite 为什么提示 database is locked？

常见原因：

- 写事务持续时间太长；
- 多个连接同时写入；
- 没有设置 busy_timeout；
- 某个游标或事务未结束；
- 在事务中执行耗时网络操作；
- WAL 检查点或文件系统行为异常。

解决思路：

1. 缩短事务；
2. 设置 busy_timeout；
3. 使用 BEGIN IMMEDIATE 明确写事务；
4. 避免在事务内等待用户或网络；
5. 检查连接和游标是否及时关闭；
6. 评估是否需要 WAL；
7. 如果业务确实需要大量并发写入，考虑服务端数据库。

## 结语

SQLite 的入门门槛很低：一个文件、一条命令、几句 SQL 就能开始。

但要真正精通 SQLite，需要建立几个关键认识：

1. SQLite 是完整的关系型数据库，不只是简单文件存储；
2. 表结构和约束决定了数据质量；
3. 事务决定了数据是否可靠；
4. 索引和查询计划决定了性能；
5. WAL 改善读写并发，但不会把 SQLite 变成多写数据库；
6. 参数绑定、备份和迁移是生产工程的基本功；
7. JSON、FTS5、窗口函数等高级能力，可以让 SQLite 承担远超"本地缓存"的任务。

当你的应用需要一个可靠、轻量、可移植、无需运维的数据库时，SQLite 往往不是退而求其次，而是最合适的选择。

## 官方资料

- [SQLite 官方文档](https://sqlite.org/docs.html)
- [SQLite SQL 语法](https://sqlite.org/lang.html)
- [SQLite PRAGMA 文档](https://sqlite.org/pragma.html)
- [SQLite WAL 文档](https://sqlite.org/wal.html)
- [SQLite 查询计划](https://sqlite.org/eqp.html)
- [SQLite 查询优化器](https://sqlite.org/optoverview.html)
- [SQLite JSON 函数](https://sqlite.org/json1.html)
- [SQLite FTS5 全文搜索](https://sqlite.org/fts5.html)
- [SQLite 备份 API](https://sqlite.org/backup.html)
- [SQLite 版本变更记录](https://sqlite.org/changes.html)

建议收藏：下次遇到 SQLite 查询慢、数据库锁、外键失效、WAL 文件变大或全文搜索需求时，可以回到本文对应章节逐项排查。
