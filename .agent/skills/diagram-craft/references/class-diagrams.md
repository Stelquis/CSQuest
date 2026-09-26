# 类图（Class Diagram）

对面向对象设计与领域模型建模，表达类（实体）、其属性/方法以及类之间的关系。

用于画数据结构、设计模式结构与领域模型；数据库表结构请用 [erd-diagrams.md](erd-diagrams.md)。

## 基础语法

```mermaid
classDiagram
    ClassName
```

## 定义类与成员

```mermaid
classDiagram
    class BankAccount {
        +String owner
        +Decimal balance
        -String accountNumber
        +deposit(amount)
        +withdraw(amount)
        +getBalance() Decimal
    }
```

| 可见性修饰符 | 含义             |
| ------------ | ---------------- |
| `+`        | public           |
| `-`        | private          |
| `#`        | protected        |
| `~`        | package/internal |

成员写法：

- `+type attribute`：带类型的属性
- `+method(params) ReturnType`：带参数与返回值的方法

## 关系类型

| 关系 | 语法     | 含义                                                         |
| ---- | -------- | ------------------------------------------------------------ |
| 关联 | `--`   | 松散关系，双方可独立存在                                     |
| 组合 | `*--`  | 强拥有，父删除则子删除（如`Order *-- LineItem`）           |
| 聚合 | `o--`  | 弱拥有，子可独立存在（has-a，如`Department o-- Employee`） |
| 继承 | `<\|--` | is-a，子类继承父类                                           |
| 依赖 | `<..`  | 一方依赖另一方，通常作为参数或局部变量                       |
| 实现 | `<\|..` | 类实现接口                                                   |

```mermaid
classDiagram
    Animal <|-- Dog
    Animal <|-- Cat
    Order *-- LineItem
    Department o-- Employee
    OrderProcessor <.. PaymentGateway

    class Animal {
        +String name
        +makeSound()
    }

    class Drawable {
        <<interface>>
        +draw()
    }
    Drawable <|.. Circle
    Drawable <|.. Rectangle
```

## 多重性（Multiplicity）

标出关系中各方的实例数量：

```mermaid
classDiagram
    Customer "1" --> "0..*" Order : 下单
    Order "1" *-- "1..*" LineItem : 包含
    Author "1..*" -- "1..*" Book : 合著
```

| 写法             | 含义       |
| ---------------- | ---------- |
| `1`            | 恰好一个   |
| `0..1`         | 零或一个   |
| `0..*` / `*` | 零或多个   |
| `1..*`         | 一个或多个 |
| `m..n`         | m 到 n 个  |

关系标签写在关系末尾：`Customer --> Order : 下单`。

## 类型标注（Stereotype）

用 `<<...>>` 标注类的类型：

```mermaid
classDiagram
    class IRepository {
        <<interface>>
        +save(entity)
        +findById(id)
    }

    class UserService {
        <<service>>
        +createUser()
    }

    class UserDTO {
        <<dataclass>>
        +String name
        +String email
    }
```

## 抽象类与泛型

```mermaid
classDiagram
    class Shape {
        <<abstract>>
        +int x
        +int y
        +draw()* abstract
        +move(x, y)
    }

    class List~T~ {
        +add(item: T)
        +get(index: int) T
    }

    Shape <|-- Circle
    Shape <|-- Rectangle
    List~String~ <-- StringProcessor
```

方法名后加 `*` 表示抽象方法；`~T~` 声明类型参数，实例化时写 `List~String~`。

## 完整示例：电商领域模型

```mermaid
classDiagram
    %% 核心实体
    class Customer {
        +UUID id
        +String email
        +String name
        +Address shippingAddress
        +placeOrder(cart: Cart) Order
        +getOrderHistory() List~Order~
    }

    class Order {
        +UUID id
        +DateTime orderDate
        +OrderStatus status
        +Decimal total
        +calculateTotal() Decimal
        +ship()
        +cancel()
    }

    class LineItem {
        +int quantity
        +Decimal pricePerUnit
        +getSubtotal() Decimal
    }

    class Product {
        +UUID id
        +String name
        +String description
        +Decimal price
        +int stockQuantity
        +reduceStock(quantity: int)
        +isAvailable() bool
    }

    class Cart {
        +addItem(product: Product, quantity: int)
        +removeItem(product: Product)
        +getTotal() Decimal
        +clear()
    }

    class OrderStatus {
        <<enumeration>>
        PENDING
        PAID
        SHIPPED
        DELIVERED
        CANCELLED
    }

    %% 关系
    Customer "1" --> "0..*" Order : 下单
    Customer "1" --> "1" Cart : 持有
    Order "1" *-- "1..*" LineItem : 包含
    LineItem "1" --> "1" Product : 引用
    Product "0..*" --> "1" Category : 归属
    Cart "1" o-- "0..*" Product : 加入
    Order --> OrderStatus
```

## 领域驱动设计（DDD）标注

| 模式   | 标注                   | 要点                                       |
| ------ | ---------------------- | ------------------------------------------ |
| 实体   | `<<entity>>`         | 有唯一标识，如`User`                     |
| 值对象 | `<<value object>>`   | 不可变、按值比较，如`Money`、`Address` |
| 聚合根 | `<<aggregate root>>` | 内部一致性边界，外部只引用根               |

```mermaid
classDiagram
    class Money {
        <<value object>>
        +Decimal amount
        +String currency
        +add(other: Money) Money
    }

    class Order {
        <<aggregate root>>
        -UUID id
        +addLineItem(item)
        +removeLineItem(item)
    }

    Order *-- LineItem
```

## 常用设计模式

**仓储模式（Repository）**

```mermaid
classDiagram
    class IRepository~T~ {
        <<interface>>
        +save(entity: T)
        +findById(id: UUID) T
        +delete(entity: T)
    }

    class UserRepository {
        +findByEmail(email: String) User
    }

    IRepository~User~ <|.. UserRepository
```

**工厂模式（Factory）**

```mermaid
classDiagram
    class ShapeFactory {
        +createShape(type: String) Shape
    }

    class Shape {
        <<abstract>>
        +draw()*
    }

    ShapeFactory ..> Shape : 创建
    Shape <|-- Circle
    Shape <|-- Rectangle
```

**策略模式（Strategy）**

```mermaid
classDiagram
    class PaymentProcessor {
        -PaymentStrategy strategy
        +setStrategy(strategy: PaymentStrategy)
        +processPayment(amount: Decimal)
    }

    class PaymentStrategy {
        <<interface>>
        +pay(amount: Decimal)*
    }

    PaymentStrategy <|.. CreditCardPayment
    PaymentStrategy <|.. PayPalPayment
    PaymentProcessor --> PaymentStrategy
```

## 最佳实践

1. 从核心实体起步，逐步补属性和方法
2. 只画有信息量的成员，显而易见的 getter/setter 可省略
3. 谨慎区分关联、聚合与组合，避免一律用 `-->`
4. 标注多重性，明确各方实例数量
5. 用 `<<interface>>`、`<<abstract>>` 表达设计意图
6. 用 `%%` 注释说明业务规则与不变量
7. 图过大时按 `SKILL.md`《选型》拆分或升级 D2

## 相关参考

- 数据库表结构 → [erd-diagrams.md](erd-diagrams.md)
- 对象状态流转 → [state-diagrams.md](state-diagrams.md)
