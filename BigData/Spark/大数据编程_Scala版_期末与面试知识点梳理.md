# 大数据编程（Scala 版）期末 & 求职面试知识点全面梳理

> 基于课程 10 章课件与代码全面整理，覆盖 Scala 语言基础 → Spark 核心编程 → Spark SQL → Streaming → GraphX → 机器学习全链路。
> 每个知识点标注：⭐ 期末高频 | 🔥 面试高频 | 💡 实战重点

---

## 目录

- [第一章 Spark 概述](#第一章-spark-概述)
- [第二章 Spark 开发环境搭建](#第二章-spark-开发环境搭建)
- [第三章 Scala 语言基础](#第三章-scala-语言基础)
- [第四章 Scala 面向对象编程](#第四章-scala-面向对象编程)
- [第五章 RDD 编程](#第五章-rdd-编程)
- [第六章 Spark SQL](#第六章-spark-sql)
- [第七章 Spark Streaming](#第七章-spark-streaming)
- [第八章 Spark GraphX](#第八章-spark-graphx)
- [第九章 Spark 机器学习原理](#第九章-spark-机器学习原理)
- [第十章 Spark 机器学习模型](#第十章-spark-机器学习模型)
- [附录：高频面试题汇总](#附录高频面试题汇总)

---

## 第一章 Spark 概述

### 1.1 Spark 发展史 ⭐

- **2009 年**：由 Lester 和 Matei 在加州大学伯克利分校 AMP 实验室（Algorithms, Machines and People Lab）诞生
- 最初是学术研究项目，几年内成为大数据领域应用最广泛的项目之一
- Spark 含义为"电光火石"，表示运行速度极快
- 官方数据：内存读取速度可达 Hadoop MapReduce 的 **100 多倍**

### 1.2 Spark 的特点 ⭐🔥

**（1）运算效率高**
- MapReduce 在 Shuffle 前要花费大量时间排序，Spark 不需要对所有场景排序
- 采用 **DAG（有向无环图）** 执行计划，中间结果可缓存在内存
- MapReduce 计算结果保存在磁盘，Spark 减少迭代过程中数据落地

**（2）容错性高**
- 引入 **RDD（弹性分布式数据集）** 概念
- RDD 是分布在节点中的只读对象集合，如果某 RDD 失败，可通过父 RDD 自动重建
- "弹性"指任何时候都能重算——集群某台机器挂掉导致 RDD 丢失后，Spark 可重新计算该分区数据

**（3）更加通用**
- Hadoop 只提供 Map 和 Reduce 两种操作
- Spark 提供丰富的 Transformation（map、filter、flatMap、groupByKey、reduceByKey、union、join、sort 等）和 Action（collect、reduce、save 等）
- 处理节点间通信模型不止 Shuffle 一种，用户可控制中间结果的存储和分区

**（4）丰富的 API**
- 支持 Scala、Python、Java、R 语言
- 相同应用程序，Spark 代码量比 Hadoop MapReduce **少 50%~80%**

**（5）良好的兼容性**
- 可使用 Hadoop YARN、Apache Mesos 作为资源管理和调度器
- 可处理所有 Hadoop 支持的数据：HDFS、Cassandra、HBase 等
- 也可使用自带的 Standalone 模式

**（6）一体化架构**
- 集批处理、实时流处理、交互式查询与图计算为一体
- 避免多场景部署不同集群带来的资源浪费

### 1.3 Spark 生态系统 ⭐🔥

Spark 遵循"一个软件栈满足不同应用场景"的理念：

| 组件 | 功能 | 说明 |
|------|------|------|
| **Spark Core** | 核心引擎 | 实现 MapReduce 算子、任务调度、内存管理、错误恢复 |
| **Spark SQL** | 结构化数据处理 | DataFrame API，支持 SQL 查询，Catalyst 优化器 |
| **Spark Streaming** | 实时流处理 | 准实时微批处理，支持 Kafka、Flume、TCP Socket |
| **MLlib** | 机器学习 | 分类、回归、聚类、协同过滤、特征工程 |
| **GraphX** | 图计算 | 属性图、PageRank、三角形计数、Pregel API |
| **SparkR** | R 语言前端 | 为 R 提供 RDD API，解决 R 无法级联扩展的问题 |

**MLBase 四层架构：**
1. **MLRuntime**：分布式内存计算框架
2. **MLlib**：已实现的机器学习算法库
3. **ML Optimizer**：自动选择最佳算法和参数
4. **MLI**：特征抽取和高级 ML 编程抽象 API

### 1.4 Spark 运行架构 ⭐🔥

#### 核心术语

| 术语 | 说明 |
|------|------|
| **Client** | 客户端进程，负责提交作业到 Master |
| **Driver** | 运行 Application 的 main 函数，生成 SparkContext（Spark 入口） |
| **Cluster Manager** | 外部服务，管理集群，启动应用 |
| **Master** | 接收作业，管理 Worker，命令 Worker 启动 Executor |
| **Worker** | 工作节点，管理本节点资源，启动 Executor |
| **Executor** | 执行进程，运行 Task，一个 Worker 可启动多个 Executor |
| **Application** | 用户编写的 Spark 应用程序 |
| **Job** | 由 Action 操作触发，一个 Application 可包含多个 Job |
| **Stage** | Job 被 DAGScheduler 按 Shuffle 边界划分的阶段 |
| **Task** | Stage 中最小的执行单元，每个 Partition 对应一个 Task |

#### 运行模式

| 模式 | Master URL | 说明 |
|------|-----------|------|
| 本地模式 | `local` | 单机单线程，适合开发调试 |
| 本地多线程 | `local[N]` / `local[*]` | N 线程 / 全部 CPU |
| Standalone | `spark://host:port` | Spark 自带集群管理器 |
| YARN | `yarn` | Hadoop YARN 资源管理 |
| Mesos | `mesos://host:port` | Apache Mesos 资源管理 |

**YARN 模式核心组件：**
- **ResourceManager（RM）**：全局资源管理，接收任务请求，分配资源
- **NodeManager（NM）**：节点资源管理器，启动 Container 运行 Task
- **ApplicationMaster（AM）**：单个 Job 的 Task 管理和调度
- **Container**：资源分配单位，每个任务占用一个 Container

**Mesos 模式核心组件：**
- **Mesos Master**：系统核心，管理 Slave，按算法分配资源
- **Mesos Slave**：接收执行 Master 命令，管理节点任务
- **框架**：双层调度——第一层 Mesos 分配资源给框架，第二层框架分配给内部任务
- 使用 ZooKeeper 解决 Master 单点故障

### 1.5 Spark 执行流程 ⭐🔥

```
Application → Job → Stage → Task
   一个应用    一个Action触发  一个Shuffle边界  一个分区的计算
```

**WordCount 执行流程分析：**

1. `count`（Action）触发 Job 提交
2. RDD 根据依赖关系形成 DAG
3. DAGScheduler 将 DAG 划分为 Stage（按 Shuffle 边界）
4. Shuffle 之前有 5 个 Partition → 5 个 Task
5. Shuffle 之后有 3 个 Partition → 3 个 Task
6. `reduceByKey` 触发 Shuffle，但先在 Map 端做本地聚合（如 `(c,1)(c,1)` → `(c,2)`）
7. Shuffle 结果写入下游 3 个 Partition，再全局聚合生成结果 RDD

**类调用关系：**
```
count → SparkContext.runJob → DAGScheduler.submitJob
→ DAGSchedulerEventProcessLoop → handleJobSubmitted
→ 划分 Stage → submitMissingTasks → TaskScheduler
→ TaskSetManager → CoarseGrainedSchedulerBackend
→ Executor.launchTask → TaskRunner.run → Task.runTask
```

---

## 第二章 Spark 开发环境搭建

### 2.1 环境配置 ⭐

**所需软件：**
- OS：64 位 Linux（Ubuntu 16.04）
- JDK：jdk-8u171 或更高版本
- Spark：spark-2.3.0-bin-hadoop2.7
- Scala：2.11.8
- IDE：IDEA 或 Eclipse + Scala 插件

**配置步骤：**
```bash
# 1. 解压 JDK
sudo tar zxvf jdk-8u171-linux-x64.tar.gz -C /usr/local

# 2. 配置环境变量 ~/.bashrc
export JAVA_HOME=/usr/local/jdk1.8.0_171
export SPARK_HOME=/usr/local/spark-2.3.0-bin-hadoop2.7
export PATH=$PATH:$JAVA_HOME/bin:$SPARK_HOME/bin

# 3. 生效
source ~/.bashrc

# 4. 验证
java -version
spark-shell
```

### 2.2 Spark Shell ⭐

- `spark-shell` 启动后自动创建 `SparkContext` 对象 `sc`
- 支持交互式编程（REPL），表达式计算完成即输出结果
- Web UI 默认端口 **4040**：`localhost:4040`

```scala
// Spark Shell 中的 WordCount
val rdd1 = sc.textFile("file:///usr/local/sparkwc")
val rdd2 = rdd1.flatMap(_.split("\t"))
val rdd3 = rdd2.map((_, 1))
val rdd4 = rdd3.reduceByKey(_ + _)
rdd4.collect
// 输出: Array((scala,1), (spark,3), (hello,2), ...)
```

### 2.3 spark-submit 提交 ⭐

```bash
spark-submit \
  --class "WordCount" \
  --master local[*] \
  target/scala-2.11/wordcount_2.11-1.0.jar \
  input.txt
```

---

## 第三章 Scala 语言基础

### 3.1 Scala 简介 ⭐

- 由 Martin Odersky 教授于 2004 年发布
- 名称来自"Scalable Language"（可伸展的语言）
- 运行于 JVM 上，兼容现有 Java 程序
- 集**面向对象编程**与**函数式编程**于一身
- 在 Scala 中，**每个值都是对象，每个操作都是方法调用**

**Scala 特点：**
1. 强大的并发性，支持函数式编程，适合分布式系统
2. 语法简洁，提供优雅的 API
3. 无缝集成 Java，融合 Hadoop 生态圈
4. 提供 REPL（交互式解释器），提升开发效率

### 3.2 变量与类型 ⭐🔥

#### 三种变量类型

| 类型 | 关键字 | 说明 | 类比 Java |
|------|--------|------|-----------|
| 不可变变量 | `val` | 赋值后不可改变 | `final` |
| 可变变量 | `var` | 赋值后可修改 | 普通变量 |
| 惰性变量 | `lazy val` | 使用时才赋值 | 无直接对应 |

```scala
val x = 10           // 不可变，推荐
var y = 20           // 可变
lazy val z = "hello" // 惰性求值，使用时才赋值

// 类型推断：Scala 自动推断类型
val s = "Hello"      // 推断为 String
val n = 42           // 推断为 Int

// 显式类型声明
val s: String = "Hello"
val n: Int = 42
```

**重要规则：**
- `var` 变量可重新赋值，但**不能改变类型**
- `Int` 可自动转换为 `Double`，但 `String` 不能赋给 `Int`
- `lazy` 关键字**只能修饰 `val`**，不能修饰 `var`

#### 基本数据类型

| 类型 | 位数 | 说明 |
|------|------|------|
| Byte | 8 | -128 ~ 127 |
| Short | 16 | -32768 ~ 32767 |
| Int | 32 | 整数 |
| Long | 64 | 长整数（后缀 L） |
| Float | 32 | 单精度浮点（后缀 F） |
| Double | 64 | 双精度浮点 |
| Char | 16 | Unicode 字符 |
| Boolean | 8 | true/false |

**特殊类型定义：**
```scala
val hex = 0x29       // 十六进制: 41
val pi = 3.14159     // Double（默认）
val f = 3.14159F     // Float（加 F 后缀）
val c = 'A'          // Char（单引号）
val s = "Hello"      // String（双引号）
val escaped = '\"'   // 转义字符
val unicode = '"' // Unicode 编码
```

#### 命名规范

- 可使用字母、数字和操作符（`+`、`*` 等）
- 标识符不能以数字开头
- 保留字不能用作标识符（反引号除外：`` `return` ``）
- 推荐 camelCase 命名法

### 3.3 程序控制结构 ⭐

#### if-else（表达式，有返回值）
```scala
// Scala 的 if-else 是表达式，有返回值
val result = if (x > 0) "positive" else "non-positive"

// 块表达式
val result = if (x > 0) {
  "positive"
} else if (x == 0) {
  "zero"
} else {
  "negative"
}
```

#### 循环
```scala
// while 循环
var i = 10
while (i > 0) { println(i); i -= 1 }

// do-while 循环
do { println(i); i -= 1 } while (i > 0)

// for 循环
for (i <- 1 to 10) println(i)      // 1 到 10
for (i <- 1 until 10) println(i)   // 1 到 9
for (i <- 1 to 10; if i % 2 == 0) println(i)  // 带守卫

// 嵌套 for + 守卫
for (i <- 1 to 10; if i > 3;
     j <- 1 to 10; if j == 6)
  println(s"i=$i, j=$j")

// for-yield 生成新集合
val doubled = for (i <- 1 to 5) yield i * 2
// Vector(2, 4, 6, 8, 10)
```

#### 模式匹配（match）⭐🔥

```scala
// 基本匹配
x match {
  case 1 => println("one")
  case 2 => println("two")
  case _ => println("other")  // 通配符
}

// 变量绑定
x match {
  case 1 => println("one")
  case y => println(s"unexpected: $y")
}

// 类型匹配（替代 type checking）
obj match {
  case i: Int    => s"Int: $i"
  case s: String => s"String: $s"
  case _         => "Unknown"
}

// 带守卫的匹配
x match {
  case i if i % 2 == 0 => println("even")
  case i                => println("odd")
}

// Case Class 匹配（解构）
case class Person(name: String, age: Int)
person match {
  case Person("Alice", 25) => println("Found Alice")
  case Person(n, a)        => println(s"$n is $a years old")
}
```

### 3.4 集合类型 ⭐🔥

#### Array & ArrayBuffer（数组）
```scala
// 定长数组
val arr = Array(1, 2, 3)
arr(0)          // 访问: 1
arr.length      // 长度: 3

// 变长数组（ArrayBuffer）
import scala.collection.mutable.ArrayBuffer
val buf = ArrayBuffer[Int]()
buf += 4        // 追加
buf += (5, 6)   // 批量追加
buf.insert(0, 0)// 插入
buf.remove(1)   // 删除

// 二维数组
val matrix = Array.ofDim[Int](3, 3)
matrix(0)(0) = 1

// yield 转换
val arr2 = for (elem <- arr) yield elem + 1
// Array(2, 3, 4)

// 生成数组
val r = Array.range(0, 10, 2)  // Array(0, 2, 4, 6, 8)
```

#### List（不可变链表）⭐
```scala
val list = List(1, 2, 3)
list.head      // 1（首个元素）
list.tail      // List(2, 3)（除首外）
list.isEmpty   // false

// 连接
List(1, 2) ::: List(3, 4)       // List(1, 2, 3, 4)
List.concat(List(1, 2), List(3, 4))

// 填充
List.fill(3)("a")  // List(a, a, a)
```

#### Set（不可变集合）
```scala
val s = Set(1, 2, 3, 2)  // Set(1, 2, 3) 自动去重
s.min    // 1
s.max    // 3

// 集合运算
val s2 = Set(2, 3, 4)
s & s2           // 交集: Set(2, 3)
s.intersect(s2)  // 同上
s ++ s2          // 并集: Set(1, 2, 3, 4)
```

#### Map（不可变映射）⭐
```scala
val m = Map("a" -> 1, "b" -> 2)
m("a")          // 1
m.contains("a") // true
m.keys          // Set(a, b)
m.values        // Iterable(1, 2)

// 遍历
for ((k, v) <- m) println(s"$k -> $v")
m.foreach { case (k, v) => println(s"$k -> $v") }
```

#### Tuple（元组）⭐
```scala
val t = (1, "hello", 3.14)
t._1    // 1
t._2    // "hello"
t._3    // 3.14
```

#### Option 类型 ⭐🔥

```scala
val some: Option[Int] = Some(5)
val none: Option[Int] = None

some.isEmpty       // false
some.get           // 5（危险！None 时抛异常）
some.getOrElse(0)  // 5（安全，None 返回默认值）

// 与 Map.get 结合
val m = Map("a" -> 1)
m.get("a")  // Some(1)
m.get("c")  // None

// 模式匹配处理
def show(opt: Option[Int]): String = opt match {
  case Some(v) => s"Value: $v"
  case None    => "No value"
}
```

### 3.5 函数式编程 ⭐🔥

```scala
// 普通函数
def add(a: Int, b: Int): Int = a + b

// 递归函数
def factorial(n: BigInt): BigInt = {
  if (n <= 1) 1
  else n * factorial(n - 1)
}

// 尾递归（编译器优化，避免栈溢出）⭐🔥
@annotation.tailrec
def factorialTail(n: BigInt, acc: BigInt = 1): BigInt = {
  if (n <= 1) acc
  else factorialTail(n - 1, n * acc)
}

// 高阶函数（函数作为参数）⭐
def apply(f: Int => String, x: Int): String = f(x)
apply(x => s"Value: $x", 42)

// 匿名函数（Lambda）
val double = (x: Int) => x * 2
List(1, 2, 3).map(double)     // List(2, 4, 6)
```

---

## 第四章 Scala 面向对象编程

### 4.1 类与对象 ⭐

```scala
// 类定义
class Student {
  private var age = 18     // 私有成员
  val name = "Unknown"     // 公有成员（默认）
  
  def increase(): Unit = { age += 1 }
  def current(): Int = age
}

// 创建对象
val s = new Student()
s.increase()
println(s.current)  // 可省略括号
```

**Scala 类成员访问：**
- 自动生成 getter/setter 方法
- `age` = getter，`age_=` = setter
- `private` 修饰的成员 getter/setter 也是私有的

### 4.2 构造函数 ⭐🔥

#### 辅助构造函数
```scala
class Student(var name: String, var age: Int) {
  // 辅助构造函数，必须调用主构造函数
  def this(name: String) = this(name, 0)
  def this() = this("Unknown", 0)
}
```

#### 主构造函数
```scala
// 主构造函数参数直接写在类名后
class Student(val name: String, val classNum: Int) {
  // 类体中的代码 = 主构造函数执行体
  println(s"Creating student: $name")
}
```

**主构造函数特点：**
- 参数加 `val`/`var` 自动升级为成员变量
- 类体中除方法外的所有语句都会执行
- 创建子类对象时，先调用父类主构造函数，再调用子类

### 4.3 单例对象与伴生对象 ⭐🔥

```scala
// 单例 object（类似 Java 的 static）
object Counter {
  private var count = 0
  def increment(): Unit = { count += 1 }
  def getCount: Int = count
}

// 伴生类 + 伴生对象（同名，同一文件）
class Students(val name: String, val id: Int)
object Students {
  private var studentNum = 0
  def newStuId(): Int = {
    studentNum += 1
    studentNum
  }
}
// 伴生类和伴生对象可互相访问私有成员
```

**面试考点：**
- `object` 是单例，不能 `new`
- `class` + `object` 同名 = 伴生关系
- 伴生对象中的方法类似 Java 的 `static` 方法

### 4.4 抽象类与匿名类 ⭐

```scala
// 抽象类
abstract class Phone {
  val phoneBrand: String   // 抽象成员变量（必须声明类型）
  def buy(): Unit          // 抽象方法（不需要 abstract 关键字）
}

// 匿名类（只使用一次时）
val p = new Phone {
  val phoneBrand = "Apple"
  def buy(): Unit = println("Buying iPhone")
}
```

**抽象类规则：**
- 使用 `abstract` 关键字定义
- 抽象方法不需要 `abstract`，省去方法体即可
- 抽象成员变量必须声明类型，不能省略

### 4.5 继承与多态 ⭐🔥

```scala
// 继承
class Apple extends Phone {
  override val phoneBrand = "Apple"  // 重写抽象成员可省略 override
  override def buy(): Unit = println("Buying iPhone")  // 重写非抽象必须 override
}

// 多态
val p: Phone = new Apple()
p.buy()  // 运行时决定调用 Apple 的 buy()
```

**Scala 继承特点：**
1. 重写非抽象方法**必须**用 `override`
2. 只有主构造函数可调用父类主构造函数
3. 重写抽象方法可不用 `override`
4. 可重写父类成员变量
5. 不允许多继承（一个类只能继承一个父类）

### 4.6 特质（Trait）⭐🔥

```scala
// Trait 定义
trait PhoneId {
  var id: Int              // 抽象字段
  def identify(): Unit     // 抽象方法
}

trait PhoneGreeting {
  def greet(): Unit = println("Hello!")  // 具体方法
}

// 混入多个 trait
class ApplePhone extends PhoneId with PhoneGreeting {
  var id: Int = 1
  def identify(): Unit = println(s"ID: $id")
}
```

**Trait vs Abstract Class 🔥**

| 特性 | Trait | Abstract Class |
|------|-------|----------------|
| 多继承 | ✅ `extends` + `with` 混入多个 | ❌ 只能继承一个 |
| 构造器参数 | ❌ 不支持 | ✅ 支持 |
| 线性化 | 链式混入 | 单继承 |
| 使用场景 | 定义行为接口 | 定义基类 |

### 4.7 包与导入 ⭐

```scala
// 重命名导入（避免冲突）
import java.util.{HashMap => JavaHashMap}
val jMap = new JavaHashMap[String, Int]()

// 隐藏导入
import java.util.{HashMap => _, _}  // 隐藏 HashMap，导入其余
```

---

## 第五章 RDD 编程

### 5.1 RDD 核心概念 ⭐🔥

**RDD（Resilient Distributed Dataset）**：弹性分布式数据集，是 Spark 对数据的核心抽象。

| 特性 | 说明 |
|------|------|
| **Resilient（弹性）** | 容错，通过血缘（Lineage）恢复丢失数据 |
| **Distributed（分布式）** | 数据分布在集群多个节点，并行计算 |
| **Dataset（数据集）** | 数据的集合，是数据的基本抽象 |
| **Immutable（不可变）** | 每次转换生成新 RDD，不修改原 RDD |
| **Lazy（惰性）** | Transformation 不立即执行，Action 时才计算 |

### 5.2 RDD 五大特征 ⭐🔥

1. **分区（Partitions）**：RDD 划分为多个分区分布到集群节点，并行计算的基本单位
2. **函数（Compute）**：每个分区有一个计算函数，以分区为基本单位计算
3. **依赖（Dependency）**：RDD 之间的依赖关系，分为窄依赖和宽依赖
4. **分区策略（Partitioner）**：Key-Value RDD 根据哈希值分区
5. **优先位置（Preferred Location）**：数据不动代码动，任务优先分配到数据所在节点

### 5.3 RDD 创建方式 ⭐

```scala
// 1. 从集合创建
val rdd = sc.parallelize(Array(1, 2, 3, 4, 5))
val rdd = sc.makeRDD(Array(1, 2, 3))

// 2. 从文件创建
val rdd = sc.textFile("file:///local/path")
val rdd = sc.textFile("hdfs://namenode:9000/path")
val rdd = sc.textFile("path/to/file", 4)  // 指定分区数

// 3. 从其他 RDD 转换
val rdd2 = rdd.map(x => x * 2)
```

**分区数说明：**
- HDFS 默认 block 大小 128MB，每个 block 一个分区
- 文件小于 128MB 时，只有一个分区
- 可通过第二个参数手动设置分区数
- 每个分区对应一个 Task，合理设置分区数可提高并行度

### 5.4 Transformation 操作 ⭐🔥

**懒执行**，返回新 RDD，不触发计算。

#### Value 型算子（作用于单个 RDD）

| 算子 | 说明 | 示例 |
|------|------|------|
| `map(f)` | 一对一映射 | `rdd.map(x => x * 2)` |
| `flatMap(f)` | 一对多 + 扁平化 | `rdd.flatMap(_.split(" "))` |
| `filter(f)` | 过滤 | `rdd.filter(x => x > 3)` |
| `distinct()` | 去重 | `rdd.distinct()` |
| `union(rdd2)` | 并集 | `rdd.union(rdd2)` |
| `intersection(rdd2)` | 交集 | `rdd.intersection(rdd2)` |
| `sortBy(f)` | 排序 | `rdd.sortBy(x => x, false)` |
| `groupBy(f)` | 分组 | `rdd.groupBy(x => x % 2)` |

#### Key-Value 型算子

| 算子 | 说明 | 示例 |
|------|------|------|
| `reduceByKey(f)` | 按 Key 聚合 ⭐ | `rdd.reduceByKey(_ + _)` |
| `groupByKey()` | 按 Key 分组 | `rdd.groupByKey()` |
| `aggregateByKey` | 带初始值的聚合 | 更灵活 |
| `mapValues(f)` | 只映射 Value | `rdd.mapValues(_ * 2)` |
| `flatMapValues(f)` | 只扁平化 Value | `rdd.flatMapValues(_.split(","))` |
| `keys` / `values` | 提取 Key/Value | `rdd.keys` |
| `join(rdd2)` | 内连接 | `rdd.join(rdd2)` |
| `leftOuterJoin` | 左外连接 | `rdd.leftOuterJoin(rdd2)` |
| `cogroup(rdd2)` | 协分组 | `rdd.cogroup(rdd2)` |
| `partitionBy(n)` | 重新分区 | `rdd.partitionBy(new HashPartitioner(4))` |
| `coalesce(n)` | 减少分区（窄依赖） | `rdd.coalesce(2)` |
| `repartition(n)` | 重分区（宽依赖） | `rdd.repartition(4)` |

### 5.5 Action 操作 ⭐🔥

**触发计算**，返回结果或写入外部存储。

| 操作 | 说明 |
|------|------|
| `collect()` | 收集所有元素到 Driver |
| `count()` | 元素个数 |
| `first()` | 第一个元素 |
| `take(n)` | 前 n 个元素 |
| `reduce(f)` | 聚合所有元素 |
| `foreach(f)` | 对每个元素执行操作 |
| `saveAsTextFile(path)` | 保存为文本文件 |
| `countByKey()` | 按 Key 计数 |

### 5.6 reduceByKey vs groupByKey 🔥

```scala
// reduceByKey：Map 端有本地聚合（Combiner），推荐！
rdd.reduceByKey(_ + _)

// groupByKey：无本地聚合，所有数据 Shuffle，可能 OOM
rdd.groupByKey().mapValues(_.sum)
```

**为什么 reduceByKey 更优？**
- `reduceByKey` 在 Map 端先做局部聚合，减少 Shuffle 数据量
- `groupByKey` 将所有 Value 收集到一个迭代器，Shuffle 数据量大
- 两者最终结果相同，但 `reduceByKey` 性能更好

### 5.7 RDD 依赖关系 ⭐🔥

#### 窄依赖（Narrow Dependency）
- 父 RDD 每个分区**最多**只对应子 RDD 的一个分区
- 可在同一个节点内以**流水线（pipeline）** 形式执行
- 数据恢复高效：只重算丢失的父分区
- 示例：`map`、`filter`、`union`

#### 宽依赖（Wide Dependency）
- 父 RDD 每个分区可能被子 RDD 的**多个分区**使用
- 需要 **Shuffle**（数据混洗），涉及节点间数据传输
- 数据恢复可能有冗余计算
- 示例：`groupByKey`、`reduceByKey`、`join`

**Stage 划分依据：** 总是将窄依赖的 RDD 划分在同一个 Stage，宽依赖产生 Stage 边界。

```
窄依赖（pipeline 执行）：
  RDD_A → RDD_B → RDD_C  （同一 Stage）

宽依赖（Shuffle 边界）：
  RDD_A → RDD_B  | Shuffle |  RDD_C → RDD_D
  Stage 1                    Stage 2
```

### 5.8 RDD 缓存与容错 ⭐

#### 缓存
```scala
rdd.cache()     // 等价于 rdd.persist(StorageLevel.MEMORY_ONLY)
rdd.persist(StorageLevel.MEMORY_AND_DISK)  // 内存不够时写磁盘
rdd.unpersist() // 释放缓存
```

#### 容错机制
- **Lineage（血缘）**：记录 RDD 的生成路径，失败时沿血缘重算
- **Checkpoint**：将 RDD 持久化到 HDFS，截断血缘链

### 5.9 实战案例 ⭐

#### 学生成绩排名
```scala
// 读取多班级数据 → 合并 → 排序 → Top10
val all = class1.union(class2).union(class3)
val parsed = all.map { line =>
  val f = line.split(",")
  (f(1), f(2).toInt, f(3))  // (userid, score, class)
}
val top10 = parsed.sortBy(_._2, ascending = false).take(10)
```

#### 基站数据分析（join 操作）
```scala
// 日志：(手机号, 基站ID, 时间, 状态)
// 1. 计算停留时间
val phoneLacTime = lines.map { line =>
  val f = line.split(",")
  val time = if (f(3) == "1") -f(1).toLong else f(1).toLong
  ((f(0), f(2)), time)
}.reduceByKey(_ + _)

// 2. 转换为 (基站ID, (手机号, 时间))
val lacPhone = phoneLacTime.map(x => (x._1._2, (x._1._1, x._2)))

// 3. join 基站信息
val lacInfo = sc.textFile("B.txt").map { line =>
  val f = line.split(","); (f(0), (f(1), f(2)))
}
val result = lacPhone.join(lacInfo)
// (基站ID, ((手机号, 时间), (经度, 纬度)))
```

---

## 第六章 Spark SQL

### 6.1 Spark SQL 概述 ⭐🔥

- 处理**结构化数据**的高级模块
- 提供 **DataFrame** 编程抽象
- 支持 SQL 语句交互式查询
- 支持 JDBC/ODBC 连接传统关系型数据库

#### Catalyst 优化器架构 ⭐🔥

```
SQL 语句
   ↓
SQLParser → Unresolved Logical Plan（未解析逻辑计划）
   ↓
Analyzer → Resolved Logical Plan（已解析逻辑计划，绑定元数据）
   ↓
Optimizer → Optimized Logical Plan（优化后的逻辑计划）
   ↓
Planner → Physical Plan（物理计划）
   ↓
CostModel → 选择最佳物理执行计划
   ↓
Spark DAG 执行
```

**核心组件：**
1. **SQLParser**：语法解析，生成未解析的逻辑计划
2. **Analyzer**：绑定元数据（Hive metastore、Schema Catalog）
3. **Optimizer**：逻辑优化（谓词下推、列裁剪等）
4. **Planner**：转换为物理计划
5. **CostModel**：基于历史统计选择最佳物理计划

### 6.2 DataFrame 与 RDD 的区别 ⭐🔥

| 特性 | RDD | DataFrame |
|------|-----|-----------|
| 数据结构 | 分布式 Java 对象集合 | 分布式 Row 对象集合 |
| Schema | 无结构信息 | 有 Schema（列名+类型） |
| 优化 | 仅 Stage 层面流水线优化 | Catalyst 优化器深度优化 |
| API | Low-level API | High-level API（SQL 接口） |
| 数据源 | 任意数据 | 结构化/半结构化数据 |
| 内存优化 | 无 | 列式存储 + 代码生成 |

**DataFrame 优势：**
- 有 Schema 元数据，Spark SQL 可洞察数据结构
- 根据结构信息进行针对性优化
- 减少数据读取量（列裁剪）
- 执行计划优化（谓词下推）

### 6.3 SparkSession ⭐

```scala
// Spark 2.x+ 统一入口
val spark = SparkSession.builder()
  .master("local")
  .appName("SparkSQL")
  .config("spark.some.config.option", "some-value")
  .enableHiveSupport()  // 可选
  .getOrCreate()

import spark.implicits._  // 隐式转换
```

### 6.4 DataFrame 创建方式 ⭐🔥

```scala
// 1. 从 JSON（自动推断 Schema）
val df = spark.read.json("student.json")

// 2. 从 Parquet（默认数据源格式）
val df = spark.read.parquet("student.parquet")

// 3. 编程式 Schema（StructType）
import org.apache.spark.sql.types._
val schema = StructType(Array(
  StructField("name", StringType, true),
  StructField("age", IntegerType, true)
))
val rowRDD = sc.textFile("student.txt").map(_.split(","))
  .map(f => Row(f(0), f(1).trim.toInt))
val df = spark.createDataFrame(rowRDD, schema)

// 4. 从 Case Class
case class Student(name: String, age: Int)
val df = sc.textFile("student.txt")
  .map(_.split(","))
  .map(f => Student(f(0), f(1).trim.toInt))
  .toDF()

// 5. 从 JDBC（MySQL）
val df = spark.read.format("jdbc")
  .option("url", "jdbc:mysql://localhost:3306/db")
  .option("dbtable", "students")
  .option("user", "root")
  .option("password", "123456")
  .load()
```

### 6.5 DataFrame 操作 ⭐🔥

```scala
// 基本操作
df.show()              // 显示前20行
df.printSchema()       // 打印 Schema
df.count()             // 行数
df.columns             // 列名数组

// 选择与过滤
df.select("name", "age").show()
df.select($"name", $"age" + 1).show()
df.filter($"age" > 20).show()
df.where($"age" > 20).show()      // filter 别名
df.distinct().show()

// 聚合
df.groupBy("country").count().show()
df.groupBy("country").avg("age").show()

// 排序
df.orderBy($"age".desc).show()

// 连接
df1.join(df2, df1("id") === df2("id"), "inner").show()
df1.join(df2, Seq("id"), "left").show()

// SQL 查询
df.createOrReplaceTempView("students")
spark.sql("SELECT * FROM students WHERE age > 20").show()
```

### 6.6 Parquet 文件格式 ⭐

```scala
// 写入
df.write.parquet("output.parquet")
df.write.partitionBy("country").parquet("output.parquet")

// 读取
val df = spark.read.parquet("output.parquet")

// Schema 合并
val df = spark.read.option("mergeSchema", "true").parquet("output.parquet")
```

**Parquet 特性：**
- **列式存储**：按列存储，压缩率高
- **自动保存 Schema**：读取时无需手动指定
- **分区发现**：自动从目录路径提取分区信息
- **Schema 演化**：支持不同文件使用兼容的 Schema

### 6.7 数据源对比 ⭐

| 格式 | 存储方式 | 压缩 | Schema | 默认 |
|------|----------|------|--------|------|
| Parquet | 列式 | 高 | 自动保存 | Spark SQL 默认 |
| ORC | 列式 | 高 | 自动保存 | Hive 默认 |
| JSON | 行式 | 低 | 自动推断 | 否 |
| CSV | 行式 | 低 | 需指定 | 否 |
| JDBC | - | - | 自动获取 | 否 |

---

## 第七章 Spark Streaming

### 7.1 核心概念 ⭐🔥

**Spark Streaming** 是 Spark 核心 API 的扩展，支持**准实时**流数据处理。

**工作流程：**
```
实时数据流 → 按批处理间隔切分 → 批数据（DStream）
   → Spark Engine 处理 → 批结果输出
```

| 概念 | 说明 |
|------|------|
| **DStream** | 离散流，由一系列连续的 RDD 组成 |
| **批处理间隔** | 数据切分的时间段（如 1 秒） |
| **StreamingContext** | 流处理的入口 |
| **Receiver** | 接收器，从数据源接收数据存入内存 |

**DStream 与 RDD 的关系：**
- DStream 是 RDD 的序列，每个 RDD 包含特定时间间隔的数据
- DStream 上的操作最终转化为 RDD 上的操作
- DStream 是无边界集合，代表时空概念

### 7.2 StreamingContext ⭐

```scala
import org.apache.spark.streaming._

// 从 SparkContext 创建
val ssc = new StreamingContext(sc, Seconds(1))

// 独立创建
val conf = new SparkConf().setAppName("Streaming").setMaster("local[*]")
val ssc = new StreamingContext(conf, Seconds(1))

ssc.start()              // 启动
ssc.awaitTermination()   // 等待终止
ssc.stop()               // 手动停止
```

### 7.3 输入源 ⭐

#### 基础输入源

| 输入源 | 说明 | 创建方法 |
|--------|------|----------|
| 文件流 | 监控目录下新文件 | `ssc.textFileStream(dir)` |
| 套接字流 | TCP 连接 | `ssc.socketTextStream(host, port)` |
| RDD 队列流 | 测试用 | `ssc.queueStream(rddQueue)` |

```scala
// 文件流
val fileStream = ssc.textFileStream("/path/to/dir")

// 套接字流
val socketStream = ssc.socketTextStream("localhost", 9999)

// RDD 队列流
val rddQueue = new scala.collection.mutable.SynchronizedQueue[RDD[Int]]()
val queueStream = ssc.queueStream(rddQueue)
```

#### 高级输入源

| 输入源 | 依赖 |
|--------|------|
| Kafka | spark-streaming-kafka-0-8_2.11 |
| Flume | spark-streaming-flume_2.11 |
| Kinesis | spark-streaming-kinesis-asl_2.11 |

### 7.4 DStream 转换操作 ⭐🔥

#### 无状态转换
- 每个批次独立处理，不依赖之前批次
- 与 RDD 转换操作类似：`map`、`filter`、`reduceByKey` 等

#### 有状态转换 ⭐🔥

**（1）窗口操作**

```scala
// window(windowLength, slideInterval)
val windowed = stream.window(Seconds(30), Seconds(10))
// 窗口长度 30 秒，滑动间隔 10 秒

// 带聚合的窗口
stream.countByWindow(Seconds(30), Seconds(10))

// 带加减函数的窗口（优化性能）
stream.reduceByKeyAndWindow(
  _ + _,           // 加入新数据
  _ - _,           // 移除旧数据
  Seconds(30),     // 窗口长度
  Seconds(10)      // 滑动间隔
)
```

**窗口参数要求：** 窗口长度和滑动步长必须是批处理间隔的倍数。

**（2）updateStateByKey（有状态操作）**

```scala
val stateStream = stream.map(w => (w, 1))
  .updateStateByKey((newValues: Seq[Int], state: Option[Int]) => {
    Some(state.getOrElse(0) + newValues.sum)
  })
```

- 维护跨批次的状态
- 需要设置 checkpoint

### 7.5 Checkpoint ⭐

```scala
ssc.checkpoint("hdfs://checkpoint-dir")
```

**两种 Checkpoint：**
1. **元数据 Checkpoint**：保存配置、DStream 操作、未完成批次
2. **数据 Checkpoint**：保存 RDD 到 HDFS，用于状态恢复

**使用场景：** `updateStateByKey` 和带加减函数的 `reduceByKeyAndWindow` 必须设置 checkpoint。

### 7.6 性能调优 💡

1. **减少批处理间隔**：但不能太小，否则处理不过来
2. **增加并行度**：合理设置分区数
3. **Kryo 序列化**：比 Java 序列化更高效
4. **设置合理的 Receiver 数量**

---

## 第八章 Spark GraphX

### 8.1 GraphX 简介 ⭐

- Spark 的图计算组件
- 核心抽象：**Resilient Distributed Property Graph**（点和边都带属性的有向多重图）
- 扩展了 RDD 抽象，依赖 RDD 容错性

**三层架构：**
```
算法层：PageRank、TriangleCount、ConnectedComponents、Pregel
    ↑
操作层：Graph（抽象类）、GraphImpl、GraphOps
    ↑
存储层：VertexRDD、EdgeRDD、EdgeTriplet
```

### 8.2 图存储 ⭐

#### 三种基本数据结构

| 数据结构 | 说明 | 表示 |
|----------|------|------|
| **Vertex（顶点）** | 顶点 ID + 顶点数据 | `(VertexId, VD)` |
| **Edge（边）** | 源 ID + 目标 ID + 边数据 | `Edge(srcId, dstId, ED)` |
| **Triplet（三元组）** | 边 + 源顶点数据 + 目标顶点数据 | `(源顶点, 目标顶点, 边数据)` |

```scala
// 顶点 RDD
val vertices: RDD[(VertexId, String)] = sc.parallelize(Array(
  (1L, "Tom"), (2L, "Marry"), (3L, "Jack")
))

// 边 RDD
val edges: RDD[Edge[String]] = sc.parallelize(Array(
  Edge(1L, 2L, "Colleague"), Edge(2L, 3L, "Child")
))

// 构建图
val graph = Graph(vertices, edges, "defaultUser")
```

#### 图分割方式 ⭐

| 分割方式 | 存储策略 | 优点 | 缺点 |
|----------|----------|------|------|
| **边分割** | 每个顶点存一次，边可能跨节点 | 节省存储 | 内网通信量大 |
| **点分割** | 每条边存一次，顶点可能重复 | 减少通信 | 增加存储开销 |

**GraphX 使用点分割**，原因：
1. 磁盘便宜，内网带宽宝贵（空间换时间）
2. 网络多为无尺度网络（幂律分布），边分割导致高邻居节点的边跨机器

**GraphX 四种分区策略：**
1. **RandomVertexCut**：边随机分布
2. **CanonicalRandomVertexCut**：同一条边的多条副本在同一分区
3. **EdgePartition1D**：同一源顶点的边在同一分区
4. **EdgePartition2D**：边按二维坐标系统分区

### 8.3 图操作 ⭐

```scala
// 基本属性
graph.vertices       // 顶点 RDD
graph.edges          // 边 RDD
graph.triplets       // 三元组 RDD
graph.numVertices    // 顶点数
graph.numEdges       // 边数
graph.inDegrees      // 入度
graph.outDegrees     // 出度
graph.degrees        // 总度

// 子图
graph.subgraph(vpred = (id, attr) => attr != "spam")

// 映射
graph.mapVertices((id, attr) => attr.toUpperCase)
graph.mapEdges(e => e.attr.toUpperCase)
```

### 8.4 aggregateMessages ⭐🔥

**核心消息传递原语**，替代旧的 `mapReduceTriplets`。

```scala
val msgRDD = graph.aggregateMessages[Int](
  triplet => {
    triplet.sendToDst(1)   // 向目标顶点发消息
    triplet.sendToSrc(1)   // 向源顶点发消息
  },
  (a, b) => a + b          // 合并同一顶点收到的消息
)
```

### 8.5 Pregel API ⭐🔥

**迭代式图并行计算**，灵感来自 Google Pregel。

```scala
val result = graph.pregel(initialMsg, maxIter, activeDir)(
  vprog,     // 顶点程序：处理消息，更新属性
  sendMsg,   // 发送消息：决定向邻居发什么
  mergeMsg   // 合并消息：同一顶点多条消息的合并
)
```

**Pregel 工作流程：**
1. 所有顶点收到初始消息
2. 每个顶点执行 `vprog` 处理消息
3. 每个顶点通过 `sendMsg` 向邻居发消息
4. 同一顶点收到的多条消息通过 `mergeMsg` 合并
5. 重复 2-4 直到无消息或达到最大迭代次数

### 8.6 内置图算法 ⭐

#### PageRank
```scala
val ranks = graph.pageRank(0.0001).vertices
// 误差容忍度 0.0001
```

#### 三角形计数
```scala
val triCounts = graph.partitionBy(PartitionStrategy.RandomVertexCut)
  .triangleCount().vertices
```

#### 连通分量
```scala
val cc = graph.connectedComponents().vertices
```

### 8.7 经典图算法实现 💡

| 算法 | 方法 | 代码文件 |
|------|------|----------|
| Dijkstra 最短路径 | aggregateMessages 迭代 | 8_22.scala |
| 最小生成树（Prim） | aggregateMessages | 8_24.scala |
| 旅行商问题（贪心） | 贪心策略 | 8_23.scala |
| 影响力传播 | Pregel 广度优先 | 8_28.scala |

---

## 第九章 Spark 机器学习原理

### 9.1 spark.ml vs spark.mllib ⭐

| 特性 | spark.ml | spark.mllib |
|------|----------|-------------|
| API 级别 | 高级（DataFrame） | 低级（RDD） |
| 状态 | 主推，持续更新 | 2.0 后进入维护 |
| Pipeline | ✅ 支持 | ❌ 不支持 |
| 分类/回归区分 | 明确区分 | 未区分 |
| 功能 | 更丰富（概率输出等） | 较少 |

### 9.2 ML Pipeline 核心概念 ⭐🔥

| 概念 | 说明 | 示例 |
|------|------|------|
| **DataFrame** | ML 数据格式，支持多列不同类型 | 文本、特征向量、标签 |
| **Transformer** | 有 `transform()` 方法，DataFrame → DataFrame | Tokenizer, HashingTF, 模型 |
| **Estimator** | 有 `fit()` 方法，DataFrame → Transformer | LogisticRegression, KMeans |
| **Pipeline** | 串联多个 stage 的工作流 | 文本分类 Pipeline |
| **Param** | 参数，支持 setter/ParamMap 两种设置方式 | maxIter, regParam |

### 9.3 Pipeline 工作流程 ⭐🔥

```
训练阶段：
  原始 DataFrame → Tokenizer(Transformer) → HashingTF(Transformer) → LR(Estimator.fit()) → PipelineModel

预测阶段：
  测试 DataFrame → PipelineModel.transform() → 带预测列的 DataFrame
```

**关键点：**
- Pipeline 中的 Estimator 在 `fit()` 后变为 Transformer
- PipelineModel 和 Pipeline 有相同的 stage
- 确保训练和测试数据经过相同的特征处理

**三种细节：**
1. **DAG Pipeline**：stage 可以是非线性的有向无环图
2. **运行时类型检查**：不支持编译时检查，运行前做运行时检查
3. **唯一 Pipeline stage ID**：同一实例不能在 Pipeline 中使用两次

### 9.4 特征提取 ⭐

#### TF-IDF（词频-逆文档频率）
```scala
val tokenizer = new Tokenizer().setInputCol("text").setOutputCol("words")
val hashingTF = new HashingTF().setNumFeatures(20).setInputCol("words").setOutputCol("rawFeatures")
val idf = new IDF().setInputCol("rawFeatures").setOutputCol("features")
```

- **TF**：词在文档中出现的频率
- **IDF**：逆文档频率，衡量词的普遍重要性
- **TF-IDF** = TF × IDF，值越大表示词对该文档越重要

#### Word2Vec（词嵌入）
```scala
val word2Vec = new Word2Vec()
  .setInputCol("text").setOutputCol("result")
  .setVectorSize(3).setMinCount(0)
```

- 将词转换为**稠密向量**
- 语义相似的词向量距离近

### 9.5 特征转换 ⭐

| 转换器 | 功能 | 关键参数 |
|--------|------|----------|
| **Binarizer** | 连续值 → 二值 | `threshold` |
| **MinMaxScaler** | 归一化到 [min, max] | `min`, `max` |
| **StandardScaler** | 标准化（均值0，方差1） | `withStd`, `withMean` |
| **VectorSlicer** | 从向量提取指定特征 | `indices`, `names` |
| **RFormula** | R 风格公式构建特征 | `formula` |
| **StringIndexer** | 字符串 → 数值索引 | `inputCol`, `outputCol` |
| **IndexToString** | 数值索引 → 字符串 | `inputCol`, `outputCol` |
| **VectorAssembler** | 多列合并为一个向量 | `inputCols`, `outputCol` |

### 9.6 特征选择 ⭐

```scala
// ChiSqSelector：卡方检验选择最强特征
val selector = new ChiSqSelector()
  .setNumTopFeatures(1)
  .setFeaturesCol("features")
  .setLabelCol("label")
```

### 9.7 模型选择与调参 ⭐🔥

#### 交叉验证（CrossValidator）
```scala
val paramGrid = new ParamGridBuilder()
  .addGrid(hashingTF.numFeatures, Array(10, 100, 1000))
  .addGrid(lr.regParam, Array(0.1, 0.01))
  .build()

val cv = new CrossValidator()
  .setEstimator(pipeline)
  .setEvaluator(new BinaryClassificationEvaluator())
  .setEstimatorParamMaps(paramGrid)
  .setNumFolds(2)
```

#### 训练-验证拆分（TrainValidationSplit）
```scala
val tvs = new TrainValidationSplit()
  .setEstimator(lr)
  .setEvaluator(new RegressionEvaluator())
  .setEstimatorParamMaps(paramGrid)
  .setTrainRatio(0.8)
```

| 方法 | 原理 | 优点 | 缺点 |
|------|------|------|------|
| CrossValidator | K 折交叉验证 | 结果可靠 | 计算慢 |
| TrainValidationSplit | 单次拆分 | 计算快 | 结果依赖拆分 |

---

## 第十章 Spark 机器学习模型

### 10.1 分类模型 ⭐🔥

**分类问题**：输出是**离散值**（定性输出），如预测天气是晴/雨/多云。

spark.ml 支持的分类模型：
- 逻辑回归、决策树、随机森林、GBT、多层感知器、线性 SVM、OneVsRest、朴素贝叶斯

#### 朴素贝叶斯（Naive Bayes）⭐🔥

**贝叶斯定理：**
$$P(A|B) = \frac{P(B|A) \cdot P(A)}{P(B)}$$

- `P(A)`：先验概率
- `P(A|B)`：后验概率
- `P(B|A)`：似然

**朴素贝叶斯假设：**
1. 各特征之间**条件独立**
2. 特征分布假设

**示例：** 打喷嚏的建筑工人 → 感冒概率？
```
P(感冒|打喷嚏,建筑工人) = P(打喷嚏|感冒) × P(建筑工人|感冒) × P(感冒) / P(打喷嚏,建筑工人)
```

```scala
val nb = new NaiveBayes()
val model = nb.fit(trainingData)
val predictions = model.transform(testData)

val evaluator = new MulticlassClassificationEvaluator()
  .setMetricName("accuracy")
```

### 10.2 回归模型 ⭐

**回归问题**：输出是**连续值**（定量输出），如预测明天气温。

#### 线性回归 ⭐

$$f(x) = ax + b$$

- **最小二乘法**：使均方误差最小化
- **评估指标**：
  - **RMSE**（均方根误差）：越小越好
  - **R²**（决定系数）：越接近 1 越好

```scala
val lr = new LinearRegression()
  .setMaxIter(10)
  .setRegParam(0.3)          // L2 正则化
  .setElasticNetParam(0.8)   // L1/L2 混合（0=L2, 1=L1）

val model = lr.fit(trainingData)
println(s"Coefficients: ${model.coefficients}")
println(s"RMSE: ${model.summary.rootMeanSquaredError}")
println(s"R²: ${model.summary.r2}")
```

**Elastic Net：** L1 和 L2 正则化的线性组合
- `elasticNetParam = 0`：纯 L2（Ridge）
- `elasticNetParam = 1`：纯 L1（Lasso）
- `0 < elasticNetParam < 1`：混合

### 10.3 决策树 ⭐

```scala
// 分类
val dt = new DecisionTreeClassifier()
  .setLabelCol("indexedLabel")
  .setFeaturesCol("indexedFeatures")

// 回归
val dt = new DecisionTreeRegressor()
```

**决策树 Pipeline：**
```
StringIndexer → VectorIndexer → DecisionTree → IndexToString
   标签编码       特征编码        模型训练        标签解码
```

### 10.4 聚类模型 ⭐🔥

#### K-Means ⭐🔥

**算法流程：**
1. 随机选择 K 个初始中心点
2. 将每个点分配到最近的中心点
3. 重新计算每个簇的中心点
4. 重复 2-3 直到收敛

```scala
val kmeans = new KMeans().setK(2)
val model = kmeans.fit(dataset)
val predictions = model.transform(dataset)

// 评估：轮廓系数
val evaluator = new ClusteringEvaluator()
val silhouette = evaluator.evaluate(predictions)
// 范围 [-1, 1]，越接近 1 越好

// 聚类中心
model.clusterCenters.foreach(println)
```

### 10.5 频繁模式挖掘 ⭐

#### FP-Growth

```scala
val fpGrowth = new FPGrowth()
  .setItemsCol("items")
  .setMinSupport(0.4)       // 最小支持度
  .setMinConfidence(0.6)    // 最小置信度

val model = fpGrowth.fit(transactions)
model.freqItemsets.show()       // 频繁项集
model.associationRules.show()   // 关联规则
```

**关键概念：**
- **支持度（Support）**：项集出现的频率
- **置信度（Confidence）**：A 出现时 B 也出现的概率
- **提升度（Lift）**：A 对 B 的提升程度

### 10.6 评估指标总结 ⭐🔥

| 任务类型 | 指标 | 含义 | 取值范围 |
|----------|------|------|----------|
| 二分类 | AUC-ROC | ROC 曲线下面积 | [0, 1]，越大越好 |
| 二分类 | Accuracy | 准确率 | [0, 1] |
| 多分类 | Accuracy | 准确率 | [0, 1] |
| 多分类 | F1 | 精确率与召回率调和平均 | [0, 1] |
| 回归 | RMSE | 均方根误差 | [0, +∞)，越小越好 |
| 回归 | R² | 决定系数 | [0, 1]，越接近 1 越好 |
| 聚类 | Silhouette | 轮廓系数 | [-1, 1]，越接近 1 越好 |

---

## 附录：高频面试题汇总

### 一、Spark Core 面试题 🔥

**1. Spark 为什么比 MapReduce 快？**
- 基于**内存计算**，中间结果缓存在内存
- **DAG 执行计划**，优化执行顺序
- **线程级**任务调度（MapReduce 是进程级）
- 减少不必要的磁盘 I/O 和排序

**2. RDD、DataFrame、Dataset 的区别？**

| 特性 | RDD | DataFrame | Dataset |
|------|-----|-----------|---------|
| 类型安全 | ✅ 编译时 | ❌ 运行时 | ✅ 编译时 |
| 序列化 | Java/Kryo | Tungsten | Tungsten |
| 优化 | 无 | Catalyst | Catalyst |
| API | 函数式 | SQL-like | 函数式 + SQL |

**3. Spark 作业执行流程？**
```
Application → Job(一个Action) → Stage(Shuffle边界) → Task(一个Partition)
```

**4. Shuffle 是什么？如何优化？**
- **Shuffle**：数据在节点间重新分布
- **优化**：用 `reduceByKey` 代替 `groupByKey`、Broadcast Join、合理分区数

**5. Spark 内存管理？**
- **执行内存**：Shuffle、Join、Sort
- **存储内存**：RDD 缓存、Broadcast
- **统一内存管理**：执行和存储可互相借用

### 二、Scala 面试题 🔥

**1. `val` vs `var` vs `lazy val`？**
- `val`：不可变，线程安全
- `var`：可变，慎用
- `lazy val`：惰性求值，使用时才赋值

**2. Trait vs Abstract Class？**
- Trait：多继承，无构造器参数
- Abstract Class：单继承，支持构造器

**3. Option 的作用？**
- 替代 null，避免 NullPointerException
- `Some(v)` 有值，`None` 无值

**4. 模式匹配的优势？**
- 替代 switch-case，支持类型匹配、解构、守卫
- 与 case class 配合实现模式解构

### 三、Spark SQL 面试题 🔥

**1. Catalyst 优化器工作流程？**
```
SQL → SQLParser → Analyzer → Optimizer → Planner → CostModel → 执行
```

**2. DataFrame vs RDD？**
- DataFrame 有 Schema，可做深度优化
- RDD 无结构信息，仅 Stage 层面优化

**3. 如何处理数据倾斜？**
- 加盐（Salting）
- Broadcast Join
- 两阶段聚合
- 自定义分区器

### 四、Streaming 面试题 🔥

**1. Spark Streaming vs Structured Streaming vs Flink？**
- Spark Streaming：微批处理
- Structured Streaming：基于 DataFrame，支持 Event Time
- Flink：真正的流处理，低延迟

**2. 窗口操作类型？**
- 滑动窗口（Sliding Window）
- 翻滚窗口（Tumbling Window，滑动步长 = 窗口长度）
- 会话窗口（Session Window）

**3. updateStateByKey 的作用？**
- 维护跨批次的状态
- 需要设置 checkpoint

### 五、GraphX 面试题 🔥

**1. 点分割 vs 边分割？**
- 点分割：每条边存一次，顶点可能重复，减少通信
- 边分割：每个顶点存一次，边可能跨节点，节省存储
- GraphX 使用点分割

**2. Pregel API 的工作原理？**
- 迭代式图计算
- vprog → sendMsg → mergeMsg 循环
- 直到无消息或达到最大迭代次数

### 六、机器学习面试题 🔥

**1. Pipeline 的优势？**
- 标准化 ML 工作流
- 自动化特征工程 + 模型训练
- 支持保存/加载

**2. 交叉验证 vs 训练-验证拆分？**
- 交叉验证：K 折，更可靠，更慢
- 训练-验证拆分：单次，更快，不稳定

**3. 如何选择算法？**

| 任务 | 基线 | 推荐 |
|------|------|------|
| 分类 | 逻辑回归 | 随机森林/GBT |
| 回归 | 线性回归 | 决策树回归 |
| 聚类 | K-Means | DBSCAN |
| 关联规则 | - | FP-Growth |

**4. 朴素贝叶斯的假设？**
- 特征之间条件独立
- 特征分布假设

**5. K-Means 如何选择 K？**
- 肘部法则（Elbow Method）
- 轮廓系数（Silhouette Coefficient）

---

## 速查卡：常用 API 一览

### RDD API
```scala
// 创建
sc.textFile(path)    sc.parallelize(collection)

// 转换
map  flatMap  filter  distinct  union  intersection
reduceByKey  groupByKey  aggregateByKey  combineByKey
join  leftOuterJoin  rightOuterJoin  cogroup
sortByKey  partitionBy  coalesce  repartition
mapValues  flatMapValues  keys  values

// 行动
collect  count  first  take  reduce  fold  aggregate
foreach  saveAsTextFile  countByKey  takeOrdered
```

### DataFrame API
```scala
// 读取
spark.read.json(path)    spark.read.parquet(path)
spark.read.format("jdbc").options(...).load()

// 操作
show  printSchema  select  filter  where  groupBy
orderBy  join  union  distinct  withColumn  drop
createOrReplaceTempView  cache  persist

// 写入
df.write.json(path)    df.write.parquet(path)
df.write.mode("overwrite").format("jdbc").options(...).save()
```

### Spark ML API
```scala
// 特征
Tokenizer  HashingTF  IDF  Word2Vec
Binarizer  MinMaxScaler  StandardScaler
VectorAssembler  VectorSlicer  StringIndexer  IndexToString
ChiSqSelector  RFormula

// 算法
LogisticRegression  NaiveBayes  DecisionTreeClassifier
LinearRegression  DecisionTreeRegressor
KMeans  GaussianMixture
FPGrowth

// 工具
Pipeline  CrossValidator  TrainValidationSplit  ParamGridBuilder
MulticlassClassificationEvaluator  BinaryClassificationEvaluator
RegressionEvaluator  ClusteringEvaluator
```

---

> 📝 **学习建议：**
> 1. **期末复习**：重点掌握标 ⭐ 的知识点，尤其是 RDD 操作、Spark SQL、Scala 语法
> 2. **面试准备**：重点掌握标 🔥 的知识点，尤其是架构原理、Shuffle 优化、Pipeline
> 3. **动手实践**：每个代码示例都要跑一遍，理解执行流程
> 4. **理解原理**：不要只记 API，要理解背后的设计思想（如为什么用 DAG、为什么用点分割）
