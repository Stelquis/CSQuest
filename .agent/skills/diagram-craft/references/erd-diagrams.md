# ER 图（Entity Relationship Diagram）

对数据库模式建模，表达表（实体）、列（属性）以及表之间的关系。适用于数据库设计与文档化。

若画的是面向对象结构而非表结构，用 [class-diagrams.md](class-diagrams.md)。

## 基础语法

```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
```

## 定义实体与属性

```mermaid
erDiagram
    CUSTOMER {
        int id PK
        string email UK
        string name
        string phone
        datetime created_at
    }
```

属性写法为 `类型 名称 约束`：

| 约束 | 含义   |
| ---- | ------ |
| `PK` | 主键   |
| `FK` | 外键   |
| `UK` | 唯一键 |
| `NN` | 非空   |

约束之外还可加引号描述，如 `decimal subtotal "COMPUTED"`。

## 关系

### 基数符号

| 符号    | 含义       |
| ------- | ---------- |
| `\|\|`  | 恰好一个   |
| `\|o`   | 零或一个   |
| `}\|`   | 一个或多个 |
| `}o`    | 零或多个   |

符号分别写在关系线两端，例如 `||--o{` 表示"一端恰好一个，另一端零或多个"。

关系线用 `--`（非标识关系）；`..` 表示标识关系，实践中较少使用。

### 常见关系写法

```mermaid
erDiagram
    %% 一对一
    USER ||--|| PROFILE : has

    %% 一对多
    CUSTOMER ||--o{ ORDER : places

    %% 多对多（显式中间表）
    STUDENT }o--o{ COURSE : enrolls
    STUDENT ||--o{ ENROLLMENT : has
    COURSE ||--o{ ENROLLMENT : includes

    %% 可选关系
    EMPLOYEE |o--o{ DEPARTMENT : manages
```

### 关系标签

```mermaid
erDiagram
    AUTHOR ||--o{ BOOK : writes
    BOOK }o--|| PUBLISHER : "published by"
    READER }o--o{ BOOK : reads
```

标签可直接写，含空格时需加引号。

## 数据类型

沿用数据库常用类型：`int`、`bigint`、`smallint`、`varchar`、`text`、`char`、`decimal`、`float`、`double`、`boolean`、`date`、`datetime`、`timestamp`、`json`、`jsonb`、`uuid`、`blob`、`bytea`。

## 完整示例：电商数据库

```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    CUSTOMER ||--o{ REVIEW : writes
    CUSTOMER ||--o{ ADDRESS : has
    ORDER ||--|{ LINE_ITEM : contains
    PRODUCT ||--o{ LINE_ITEM : "ordered in"
    PRODUCT }o--|| CATEGORY : "belongs to"
    PRODUCT ||--o{ REVIEW : receives
    PRODUCT ||--o{ INVENTORY : tracks
    ORDER ||--|| PAYMENT : "paid by"
    ORDER ||--o| SHIPMENT : "shipped via"

    CUSTOMER {
        uuid id PK
        varchar email UK "NOT NULL"
        varchar name "NOT NULL"
        varchar phone
        timestamp created_at "DEFAULT NOW()"
        timestamp updated_at
    }

    ADDRESS {
        uuid id PK
        uuid customer_id FK "NOT NULL"
        varchar street "NOT NULL"
        varchar city "NOT NULL"
        varchar postal_code
        varchar country "NOT NULL"
        boolean is_default
    }

    ORDER {
        uuid id PK
        uuid customer_id FK "NOT NULL"
        decimal total "NOT NULL"
        varchar status "NOT NULL"
        timestamp order_date "DEFAULT NOW()"
        timestamp shipped_date
        timestamp delivered_date
    }

    LINE_ITEM {
        uuid id PK
        uuid order_id FK "NOT NULL"
        uuid product_id FK "NOT NULL"
        int quantity "NOT NULL"
        decimal price_per_unit "NOT NULL"
        decimal subtotal "COMPUTED"
    }

    PRODUCT {
        uuid id PK
        varchar sku UK "NOT NULL"
        varchar name "NOT NULL"
        text description
        decimal price "NOT NULL"
        uuid category_id FK
        boolean is_active "DEFAULT TRUE"
        timestamp created_at "DEFAULT NOW()"
    }

    CATEGORY {
        uuid id PK
        varchar name UK "NOT NULL"
        text description
        uuid parent_category_id FK
    }

    INVENTORY {
        uuid id PK
        uuid product_id FK "NOT NULL"
        int quantity "DEFAULT 0"
        varchar warehouse_location
        timestamp last_updated
    }

    REVIEW {
        uuid id PK
        uuid customer_id FK "NOT NULL"
        uuid product_id FK "NOT NULL"
        int rating "CHECK 1-5"
        text comment
        timestamp created_at "DEFAULT NOW()"
    }

    PAYMENT {
        uuid id PK
        uuid order_id FK "NOT NULL"
        varchar payment_method "NOT NULL"
        decimal amount "NOT NULL"
        varchar status "NOT NULL"
        varchar transaction_id UK
        timestamp processed_at
    }

    SHIPMENT {
        uuid id PK
        uuid order_id FK "NOT NULL"
        varchar carrier
        varchar tracking_number
        timestamp shipped_date
        timestamp estimated_delivery
        timestamp actual_delivery
    }
```

## 常见建模模式

**自引用（层级结构）**

```mermaid
erDiagram
    CATEGORY ||--o{ CATEGORY : "parent of"

    CATEGORY {
        uuid id PK
        varchar name "NOT NULL"
        uuid parent_id FK "NULLABLE"
    }
```

**多对多中间表**

```mermaid
erDiagram
    STUDENT }o--o{ COURSE : enrolls
    STUDENT ||--o{ ENROLLMENT : has
    COURSE ||--o{ ENROLLMENT : includes

    ENROLLMENT {
        uuid student_id PK "FK"
        uuid course_id PK "FK"
        date enrolled_date
        varchar grade
    }
```

**多态关联**

```mermaid
erDiagram
    COMMENT {
        uuid id PK
        uuid user_id FK
        varchar commentable_type "NOT NULL"
        uuid commentable_id "NOT NULL"
        text content
    }

    POST {
        uuid id PK
        varchar title
    }

    VIDEO {
        uuid id PK
        varchar title
    }
```

**软删除**

```mermaid
erDiagram
    USER {
        uuid id PK
        varchar email UK
        varchar name
        timestamp deleted_at "NULLABLE"
    }
```

**审计轨迹（版本表）**

```mermaid
erDiagram
    DOCUMENT ||--o{ DOCUMENT_VERSION : has

    DOCUMENT {
        uuid id PK
        varchar title "NOT NULL"
        int current_version "DEFAULT 1"
    }

    DOCUMENT_VERSION {
        uuid id PK
        uuid document_id FK "NOT NULL"
        int version_number "NOT NULL"
        text content "NOT NULL"
        uuid modified_by FK
        timestamp created_at "DEFAULT NOW()"
    }
```

## 最佳实践

1. 实体名用**大写**、**单数**形式（`USER` 而非 `USERS`）
2. 完整标注约束：PK、FK、UK、NOT NULL
3. 基数符号要准确，严格区分一对多与多对多
4. 加入 `created_at` / `updated_at` 便于审计
5. 计算列、派生列要显式标注（如 `"COMPUTED"`）
6. 多对多关系显式建模中间表，而不是只画一条 `}o--o{`
7. 用引号补充约束与说明，把业务规则写进图里
8. 数据类型与目标数据库保持一致

## 数据库设计要点

1. 适度范式化，在范式化与查询性能间取平衡
2. 用代理键（UUID 或自增整数）作主键
3. 为外键建索引，保证连接性能
4. 预留软删除（`deleted_at`）而非直接物理删除
5. 关键数据做版本留痕
6. 为 `created_at`、`status`、布尔标志设置合理默认值
7. 计数、缓存类字段可适度反范式化
8. 用枚举/CHECK 约束在数据库层兜住取值范围
