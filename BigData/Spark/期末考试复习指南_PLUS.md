# 大数据编程（Scala版）期末考试复习指南 — 详细扩展版

> 基于课堂复习录音 + 课本全部10章源码 + 知识点梳理整合而成
> 每个知识点标注：⭐ 必考 | 🔥 高频 | ⚠️ 易错 | 📝 代码补全重点

---

## 目录

- [一、考试基本信息](#一考试基本信息)
- [二、试卷结构与分值分布](#二试卷结构与分值分布)
- [三、出题原则与复习策略](#三出题原则与复习策略)
- [第一章 Spark概述](#第一章-spark概述)
- [第二章 搭建Spark开发环境](#第二章-搭建spark开发环境)
- [第三章 Scala语言基础](#第三章-scala语言基础)
- [第四章 Scala面向对象编程](#第四章-scala面向对象编程)
- [第五章 RDD编程](#第五章-rdd编程)
- [第六章 Spark SQL与DataFrame](#第六章-spark-sql与dataframe)
- [第七章 Spark Streaming流式计算](#第七章-spark-streaming流式计算)
- [第八章 Spark GraphX图计算](#第八章-spark-graphx图计算)
- [第九章 Spark机器学习原理](#第九章-spark机器学习原理)
- [第十章 Spark机器学习模型](#第十章-spark机器学习模型)
- [附录：考试技巧与速查表](#附录考试技巧与速查表)

---

## 一、考试基本信息

| 项目 | 内容 |
|------|------|
| **考试日期** | **6月18日（星期一）下午7-8节** |
| **考试形式** | **开卷考试**（可携带课本） |
| **教材出版社** | 中南大学出版社 |
| **总分** | 100分 |

---

## 二、试卷结构与分值分布

| 序号 | 题型 | 分值（估） | 难度 | 说明 |
|------|------|:---------:|:----:|------|
| **一** | 填空题 | ~20分 | ⭐⭐ | 课本原文挖空，约10个空，其中1~2个较难 |
| **二** | 选择题 | 20~30分 | ⭐⭐⭐ | **含多选题**，多选/少选均不得分 |
| **三** | 简答题/问答题 | 20~30分 | ⭐ | 概念解释或比较，按要点给分，1~2道题 |
| **四** | 代码补全题 | 20~30分 | ⭐⭐⭐⭐ | 2道大题，约10个空，抠掉关键行/半行 |
| **五** | 代码写作题 | 20~30分 | ⭐⭐⭐⭐ | 1道大任务含多个小问，按小问给分 |

> ⚠️ **代码补全题关键提示**：一个空里可能不止填一个操作，可能是 `操作1.操作2.操作3` 的链式调用！

---

## 三、出题原则与复习策略

> **核心原则："以课本为中心，不超纲。"** — 90%考题来自课本

1. **重点看每章的综合实例**（每章最后一节）— 考试会改编，不会原样照抄
2. **看懂课本上的所有代码**，做到"换一个场景也能写出来"
3. **代码补全题要学会查课本中的操作表格**（Transformation表/Action表）
4. **代码写作题千万不要空着**— 按小问给分，即使前面不会后面也可能得分

---

## 第一章 Spark概述

> ⭐⭐⭐⭐⭐ **"百分之百会考"** — 填空、选择、甚至简答题的重要来源

### 1.1 Spark是什么？发源于哪里？⭐

- **2009年**诞生于加州大学伯克利分校 **AMP实验室**（Algorithms, Machines and People Lab）
- 由 Lester 和 Matei 创建
- Spark = "电光火石"，表示运行速度极快
- 内存读取速度可达 Hadoop MapReduce 的 **100多倍**

### 1.2 Spark的六大特点 ⭐🔥

| 特点 | 说明 | 考点提示 |
|------|------|----------|
| **运算效率高** | DAG执行计划，中间结果缓存在内存；MapReduce在Shuffle前大量排序，Spark不需要对所有场景排序 | 填空：Spark采用____执行计划 |
| **容错性高** | 引入 **RDD**（弹性分布式数据集），通过父RDD自动重建失败分区 | 简答："弹性"的含义 |
| **更加通用** | 提供丰富的Transformation和Action操作；不只Shuffle一种通信模型 | 对比Hadoop只有Map/Reduce |
| **丰富的API** | 支持Scala/Python/Java/R，代码量比MapReduce**少50%~80%** | 填空：支持哪四种语言 |
| **良好兼容性** | 可使用YARN、Mesos、Standalone模式；可处理HDFS、Cassandra、HBase等 | 选择：哪些是Spark支持的资源管理器 |
| **一体化架构** | 集批处理、实时流处理、交互式查询与图计算为一体 | 简答重点 |

### 1.3 Spark生态系统 ⭐🔥

> 课本第4页生态系统图 — 某年考过"解释Spark生态系统"

```
                    ┌──────────────────────────────────────┐
                    │         Spark SQL + DataFrames        │
                    │    (结构化数据处理 / Catalyst优化器)    │
                    ├──────────────────────────────────────┤
                    │   Spark Streaming    │    GraphX      │
                    │   (实时流处理/微批)    │  (图计算)      │
                    ├──────────────────────┴────────────────┤
                    │            MLlib / ML                 │
                    │        (机器学习算法库)                 │
                    ├──────────────────────────────────────┤
                    │           Spark Core                  │
                    │  (核心引擎: 任务调度/内存管理/错误恢复)   │
                    ├──────────────────────────────────────┤
                    │    YARN / Mesos / Standalone          │
                    │    HDFS / HBase / Cassandra / S3      │
                    └──────────────────────────────────────┘
```

| 组件 | 功能 | 考点 |
|------|------|------|
| **Spark Core** | 核心引擎，实现MapReduce算子、任务调度、内存管理 | 最基本组件 |
| **Spark SQL** | 结构化数据处理，DataFrame API，Catalyst优化器 | 第六章重点 |
| **Spark Streaming** | 准实时微批处理，支持Kafka/Flume/TCP | 第七章重点 |
| **MLlib/ML** | 分类、回归、聚类、协同过滤、特征工程 | 第九/十章重点 |
| **GraphX** | 图计算，PageRank、三角形计数、Pregel API | 第八章重点 |

**MLBase四层架构**（从上到下）：
1. **ML Optimizer** — 自动选择最佳算法和参数
2. **MLI** — 特征抽取和高级ML编程抽象API
3. **MLlib** — 已实现的机器学习算法库
4. **MLRuntime** — 分布式内存计算框架

### 1.4 Spark运行架构 ⭐🔥

#### 核心术语表

| 术语 | 说明 | 类比/考点 |
|------|------|-----------|
| **Client** | 客户端进程，负责提交作业到Master | |
| **Driver** | 运行Application的main函数，生成**SparkContext** | Spark入口 |
| **Cluster Manager** | 外部服务，管理集群（YARN/Mesos/Standalone） | |
| **Master** | 接收作业，管理Worker，命令Worker启动Executor | Standalone模式 |
| **Worker** | 工作节点，管理本节点资源，启动Executor | |
| **Executor** | 执行进程，运行Task，一个Worker可启动多个Executor | |
| **Application** | 用户编写的Spark应用程序 | |
| **Job** | 由**Action操作**触发 | 一个Application多个Job |
| **Stage** | Job按**Shuffle边界**划分 | DAGScheduler划分 |
| **Task** | Stage最小执行单元，每个**Partition**对应一个Task | |

#### 运行流程（重要！简答题可能考）

```
Application → Job(一个Action触发) → Stage(Shuffle边界) → Task(一个Partition)
```

**WordCount执行流程分析**：
1. `count`（Action）触发Job提交
2. RDD根据依赖关系形成DAG
3. DAGScheduler将DAG划分为Stage（按Shuffle边界）
4. Shuffle之前：5个Partition → 5个Task
5. Shuffle之后：3个Partition → 3个Task
6. `reduceByKey`触发Shuffle，但先在Map端做本地聚合

#### 运行模式

| 模式 | Master URL | 说明 |
|------|-----------|------|
| 本地模式 | `local` | 单机单线程 |
| 本地多线程 | `local[N]` / `local[*]` | N线程/全部CPU |
| Standalone | `spark://host:port` | Spark自带集群 |
| YARN | `yarn` | Hadoop YARN |
| Mesos | `mesos://host:port` | Apache Mesos |

### 1.5 Word Count源码精讲 ⭐📝

> 这是**全书最经典的案例**，考试代码补全/写作题的基础模板

**Scala版** ([code1_1.scala](BigData/Spark/code/1-Spark概述/code1_1.scala))：

```scala
import org.apache.spark.{SparkConf, SparkContext}

object code1_1 {
    def main(args: Array[String]): Unit = {
        // 第一步：初始化配置 — 填空常考！
        val conf = new SparkConf().setMaster("local").setAppName("wordcount")

        // 第二步：创建SparkContext — Spark所有功能的入口
        val sc = new SparkContext(conf)

        // 第三步：创建初始RDD — textFile读取文件
        val lines = sc.textFile("./src/word")

        // 第四步：Transformation操作链
        val words = lines.flatMap(line => line.split(" "))    // 扁平化拆分单词
        val word_transform = words.map(word => (word, 1))     // 映射为(单词, 1)
        val count = word_transform.reduceByKey(_ + _)         // 按Key聚合

        // 输出结果
        println(count.collect().mkString("\n"))
    }
}
```

**数据文件** (`word`):
```
a b
d e
c c
a c
e e
```

**执行结果**：
```
(a,2)  (b,1)  (c,3)  (d,1)  (e,3)
```

**⚠️ 代码补全重点**：
- `SparkConf().setMaster("local").setAppName("wordcount")` — 初始化配置
- `new SparkContext(conf)` — 创建入口
- `sc.textFile(path)` — 读取文件创建RDD
- `flatMap(line => line.split(" "))` — 拆分单词并扁平化
- `map(word => (word, 1))` — 映射为键值对
- `reduceByKey(_ + _)` — 按Key聚合（触发Shuffle）
- `collect()` — Action操作，收集结果

---
### 📝 第一章课后习题（课本 1.6 节）

#### Q1：Spark 有哪些优点？
**答：** 六大优点——①**运算效率高**（DAG执行计划、内存计算，比Hadoop快100倍）；②**容错性高**（RDD血缘关系自动恢复）；③**更加通用**（丰富Transformation/Action，不止Shuffle一种通信模型）；④**丰富的API**（支持Scala/Python/Java/R，代码量少50%~80%）；⑤**良好兼容性**（YARN/Mesos/Standalone，HDFS/HBase/Cassandra）；⑥**一体化架构**（批处理+流处理+交互查询+图计算+ML一套搞定）。

#### Q2：Spark 包含哪些组件？
**答：** ①**Spark Core**（核心引擎：任务调度、内存管理、错误恢复）；②**Spark SQL**（结构化数据处理，Catalyst优化器）；③**Spark Streaming**（实时流处理）；④**MLlib/ML**（机器学习算法库）；⑤**GraphX**（图计算）。

#### Q3：为什么要采用第三方资源管理器管理集群？
**答：** Spark自带的Standalone模式管理功能有限，采用第三方资源管理器（如YARN/Mesos）可以实现：①**统一资源调度**（与Hadoop等框架共享集群资源）；②**更好的隔离性**（多租户资源隔离）；③**成熟的调度策略**（队列管理、优先级调度等企业级特性）。

#### Q4：Job、Stage、Task 之间有什么关系？
**答：** 层级关系：**Application → Job → Stage → Task**。一个Application可包含多个Job（每个Action触发一个Job）；Job按**Shuffle边界**划分为多个Stage（由DAGScheduler划分）；每个Stage由多个Task组成（每个Partition对应一个Task）。即：**Task是Stage的最小执行单元，Stage是Job的Shuffle有界子集，Job由Action触发。**

#### Q5：Standalone 模式中 Driver 可以在哪里运行？
**答：** 两种方式——①**Client模式**：Driver运行在提交应用的客户机上（适用于交互式调试）；②**Cluster模式**：Driver运行在集群的某个Worker节点上（Master随机选择，适用于生产环境）。

#### Q6：DAGScheduler 在 Spark 运行过程中有什么作用？
**答：** DAGScheduler是**Stage划分调度器**。作用：①接收RDD DAG；②根据**Shuffle边界**将DAG划分为Stage；③将Stage按依赖顺序提交给TaskScheduler；④**窄依赖**的RDD划在同一Stage中以流水线方式执行。

#### Q7：Mesos 模式中 Mesos Slave 有什么作用？
**答：** Mesos Slave运行在集群的**每台工作节点**上，负责：①接收Master分配的任务；②在本节点启动和管理Executor进程；③向Master汇报资源使用情况（CPU、内存等）。

#### Q8：概述 Spark 的执行流程。
**答：** ①用户提交Application → ②启动Driver，创建SparkContext → ③Cluster Manager分配资源，启动Executor → ④DAGScheduler构建DAG，划分Stage → ⑤TaskScheduler将Task分发到Executor执行 → ⑥Executor执行Task并上报结果 → ⑦所有Task完成，释放资源。

#### Q9：ResourceManager（RM）和 NodeManager（NM）在 YARN 模式中的作用？
**答：** **RM**：YARN主节点，负责全局资源管理和调度（接收作业提交、为ApplicationMaster分配资源）。**NM**：YARN从节点（每台机器一个），负责单节点资源监控和容器管理（启动/停止Container，向RM上报心跳和资源状态）。

#### Q10：解释 WordCount 的运行过程。
**答：** 以Scala版为例：
1. `sc.textFile("路径")` → 读取文件创建初始RDD（每行一个元素）
2. `flatMap(line => line.split(" "))` → 按空格拆分单词，扁平化为单词RDD
3. `map(word => (word, 1))` → 每个单词映射为(单词, 1)键值对
4. `reduceByKey(_ + _)` → 按Key聚合计数（触发Shuffle，Map端先本地聚合）
5. `collect()` → Action操作，触发实际计算，收集结果到Driver
6. 最终输出每个单词的出现次数，如 `(a,2) (b,1) (c,3)...`

---

## 第二章 搭建Spark开发环境

> ⭐ 非重点，约1~2个小题

### 2.1 核心要点 ⭐

- **spark-shell**启动后自动创建 `SparkContext` 对象 `sc`
- Web UI 默认端口：**4040**
- 主要软件：JDK 8、Spark 2.3.0、Scala 2.11.8

### 2.2 spark-submit提交命令

```bash
spark-submit \
  --class "WordCount" \
  --master local[*] \
  target/scala-2.11/wordcount_2.11-1.0.jar \
  input.txt
```

### 2.3 Spark Shell中的代码 ([code2_1.scala](BigData/Spark/code/2-搭建Spark开发环境/code2_1.scala))

```scala
import org.apache.spark.{SparkConf, SparkContext}

object WordCount {
  def main(args: Array[String]): Unit = {
    val conf = new SparkConf().setAppName("mySpark").setMaster("local")
    val sc = new SparkContext(conf)
    val rdd = sc.textFile(args(0))                            // 从命令行参数读取文件
    val wordcount = rdd.flatMap(_.split("\t")).map((_,1)).reduceByKey(_ + _)
    for(arg <- wordcount.collect())
      print(arg + " ")
    sc.stop()
  }
}
```

> ⚠️ 注意：这里的 `_.split("\t")` 使用Tab分隔，与第一章的空格分隔不同。考试可能考察不同分隔符的使用。

---
### 📝 第二章课后习题（精选）

#### Q2：简述推荐用 Linux 系统搭建 Spark 开发环境的原因
**答：** ①Spark 最初为 Linux 设计，在 Linux 上**兼容性最佳**（Hadoop/Spark 的原生运行环境）；②Linux 服务器是**企业主流**生产环境，便于学完直接上手真实环境；③命令行工具（SSH、shell 脚本）更适合集群管理和自动化部署；④开源组件对 Linux 的支持优于 Windows。

#### Q3：在 spark-shell 中编程与在 IDEA 中编程有什么区别？
| 维度 | spark-shell | IDEA |
|:----|:-----------|:----|
| **运行方式** | 交互式（逐行执行） | 编译后提交运行 |
| **适用场景** | 数据探索、快速验证、学习测试 | 正式项目开发 |
| **SparkContext** | 自动创建 `sc` | 需手动 `new SparkContext(conf)` |
| **代码复用** | 不方便，需 `:paste` 粘贴 | 可打包为 JAR，方便复用 |
| **调试能力** | 弱 | 强（断点、变量查看） |

#### Q4：Spark Web UI 可以查看哪些信息？
**答：** 端口 **4040**（默认）。可查看：①**Jobs**（作业列表、Stage 划分、执行时间）；②**Stages**（各 Stage 的 Task 数、Shuffle 读写量）；③**Storage**（缓存的 RDD/DataFrame 的内存占用）；④**Environment**（Spark 配置参数、JVM 参数、Classpath）；⑤**Executors**（各 Executor 的 CPU/内存使用、Task 完成情况）。

#### Q5：为什么 `val rdd1 = sc.textFile("file:///usr/local/sparkwc")` 在 sparkwc 路径不存在时也不报错？
**答：** 这体现了 Spark 的**惰性机制（Lazy Evaluation）**。`textFile()` 是 **Transformation 操作**，不会立即读取文件数据——只构建 RDD 的血缘关系记录。只有在后续调用 **Action 操作**（如 `rdd1.collect()` 或 `rdd1.count()`）时，Spark 才真正去读取文件，此时若路径不存在才会报错。同理，即使路径存在，数据也仅在 Action 触发时才被加载到内存中。

---

## 第三章 Scala语言基础

> ⭐⭐⭐ 较重要 — 语法是后面编程的基础，不会单独考语法背诵，但会给代码让你**计算结果**

### 3.1 三种变量类型 ⭐⚠️

| 类型 | 关键字 | 说明 | 类比Java |
|------|--------|------|-----------|
| 不可变变量 | `val` | 赋值后不可改变 | `final` |
| 可变变量 | `var` | 赋值后可修改 | 普通变量 |
| 惰性变量 | `lazy val` | 使用时才赋值 | 无直接对应 |

**⚠️ 易错点**：
- `var` 变量可重新赋值，但**不能改变类型**
- `lazy` 关键字**只能修饰 `val`**，不能修饰 `var`
- Scala自动类型推断：`val s = "Hello"` 推断为String，`val n = 42` 推断为Int

### 3.2 基本数据类型

| 类型 | 位数 | 说明 |
|------|------|------|
| Byte | 8位 | -128 ~ 127 |
| Short | 16位 | -32768 ~ 32767 |
| Int | 32位 | 整数（默认） |
| Long | 64位 | 后缀L（如 `42L`） |
| Float | 32位 | 后缀F（如 `3.14F`） |
| Double | 64位 | 浮点默认 |
| Char | 16位 | 单引号 `'A'` |
| Boolean | 8位 | true/false |

**特殊字面量**（[code3_2.scala](BigData/Spark/code/3-Scala语言基础/code3_2.scala)）:
```scala
val hex = 0x29       // 十六进制 → 41
val pi = 3.14159     // Double（默认）
val f = 3.14159F     // Float
val c = 'A'          // Char
```

### 3.3 程序控制结构 ⭐

#### if-else（是表达式，有返回值！）⚠️

```scala
// ⚠️ Scala的if-else是表达式，有返回值！这和Java不同！
val result = if (x > 0) "positive" else "non-positive"

// 块表达式
val result = if (x > 0) {
  println("positive branch")
  "positive"    // 最后一个表达式是返回值
} else {
  "non-positive"
}
```

#### 循环（来自源码 [code3_33.scala](BigData/Spark/code/3-Scala语言基础/code3_33.scala) ~ [code3_36.scala](BigData/Spark/code/3-Scala语言基础/code3_36.scala)）

```scala
// while 循环
var i = 9
while (i > 0) {
  i -= 3
  printf("here is %d\n", i)
}

// do-while 循环
var i = 9
do {
  i -= 3
  printf("here is %d\n", i)
} while (i > 0)

// for 循环 — 多种形态
for (i <- 1 to 5) println(i)       // 1,2,3,4,5（包含5）
for (i <- 1 until 5) println(i)    // 1,2,3,4（不包含5）

// 带守卫的for（if条件过滤）
for (i <- 1 to 5 if i > 3) {       // 只输出4,5
  for (j <- 5 to 7 if j == 6) {
    println(s"i=$i, j=$j")
  }
}

// for-yield：生成新集合 ⭐
val doubled = for (i <- 1 to 5) yield i * 2
// 结果：Vector(2, 4, 6, 8, 10)
```

#### 模式匹配 match-case ⭐🔥

来自源码 [code3_37.scala](BigData/Spark/code/3-Scala语言基础/code3_37.scala) ~ [code3_41.scala](BigData/Spark/code/3-Scala语言基础/code3_41.scala)：

```scala
// 1. 基本匹配 — code3_37.scala
def matchTest(x: Int): String = x match {
  case 1 => "one"
  case 2 => "two"
  case _ => "many"          // 下划线 _ 是通配符
}

// 2. 变量绑定 — code3_38.scala ⚠️
def matchTest(x: Int): String = x match {
  case 1 => "one"
  case unexpected => unexpected + " is Not Allowed"  // 绑定到变量
}
// matchTest(5) → "5 is Not Allowed"

// 3. 类型匹配 — code3_39.scala ⚠️
def matchTest(x: Any): Any = x match {
  case 1        => "one"
  case "two"    => 2
  case y: Int   => "scala.Int"    // 匹配Int类型
  case _        => "many"
}

// 4. 带守卫的匹配 — code3_40.scala
for (elem <- List(1,2,3,4)) {
  elem match {
    case _ if (elem % 2 == 0) => println(elem + " is even.")
    case _                    => println(elem + " is odd.")
  }
}

// 5. Case Class匹配/解构 — code3_41.scala ⚠️
case class Person(name: String, age: Int)
person match {
  case Person("Alice", 25) => println("Hi Alice!")
  case Person(name, age)   => println(s"$name is $age years old")
}
```

### 3.4 集合类型 ⭐🔥

#### Array / ArrayBuffer

来自源码 [code3_42.scala](BigData/Spark/code/3-Scala语言基础/code3_42.scala) ~ [code3_46.scala](BigData/Spark/code/3-Scala语言基础/code3_46.scala)：

```scala
// 定长数组 Array
val arr = Array(1, 2, 3)
arr(0)          // 访问元素：1（用小括号不是中括号！）

// ⚠️ 变长数组 ArrayBuffer — 需要import
import scala.collection.mutable.ArrayBuffer
val buf = ArrayBuffer[String]()
buf += "Zara"               // 追加单个
buf += ("Nuha", "Ayan")     // 追加多个
buf.insert(1, "Amy")        // 在索引1处插入
buf.remove(2, 1)            // 从索引2开始删除1个

// 遍历 — code3_43.scala
for (x <- myList) println(x)                  // 直接遍历
for (i <- 0 to (myList.length - 1))           // 索引遍历
  total += myList(i)

// yield生成新数组 — code3_44.scala
var myList2 = for (x <- myList1) yield x + 1  // 每个元素+1

// range生成数组 — code3_45.scala
var myList1 = range(10, 20, 2)   // 10,12,14,16,18
var myList2 = range(10, 20)      // 10,11,...,19

// 二维数组 — code3_46.scala
var myMatrix = ofDim[Int](3,3)
myMatrix(0)(0) = 1
```

#### List（不可变链表）⭐

来自源码 [code3_49.scala](BigData/Spark/code/3-Scala语言基础/code3_49.scala) ~ [code3_51.scala](BigData/Spark/code/3-Scala语言基础/code3_51.scala)：

```scala
// 创建 — code3_49.scala
val fruit = List.fill(3)("apples")  // List(apples, apples, apples)
val num = List.fill(10)(2)          // 10个2

// 基本操作 — code3_50.scala
val fruit = "apples" :: ("oranges" :: ("pears" :: Nil))
fruit.head       // "apples"（首个元素）
fruit.tail       // List("oranges", "pears")
fruit.isEmpty    // false

// 连接 — code3_51.scala
fruit1 ::: fruit2                    // ::: 操作符连接
fruit1.:::(fruit2)                   // 方法形式
List.concat(fruit1, fruit2)          // concat方法
```

#### Set（不可变集合）⭐

来自源码 [code3_54.scala](BigData/Spark/code/3-Scala语言基础/code3_54.scala) ~ [code3_57.scala](BigData/Spark/code/3-Scala语言基础/code3_57.scala)：

```scala
val fruit = Set("apples", "oranges", "pears")
fruit.head       // 第一个元素
fruit.tail       // 除第一个外的所有元素

// 集合运算 — code3_56.scala ⚠️
num1.&(num2)             // 交集（注意&的特殊写法）
num1.intersect(num2)     // 交集（推荐写法）

// 并集 — code3_57.scala
fruit1 ++ fruit2         // 并集
fruit1.++(fruit2)        // 并集方法形式
```

#### Map（不可变映射）⭐

来自源码 [code3_60.scala](BigData/Spark/code/3-Scala语言基础/code3_60.scala) ~ [code3_64.scala](BigData/Spark/code/3-Scala语言基础/code3_64.scala)：

```scala
val colors = Map("red" -> "#FF0000", "azure" -> "#F0FFFF")

// 基本操作 — code3_60.scala
colors.keys        // 所有键
colors.values      // 所有值
colors.isEmpty     // 是否为空

// 查找 — code3_61.scala
colors.contains("red")    // true

// 遍历 — code3_62.scala
for ((k, v) <- colors) printf("Color is : %s and the code is: %s\n", k, v)
colors.keys.foreach { i =>
  print("Key = " + i)
  println(" Value = " + colors(i))
}
```

#### Option 类型 ⭐🔥⚠️

来自源码 [code3_63.scala](BigData/Spark/code/3-Scala语言基础/code3_63.scala) ~ [code3_66.scala](BigData/Spark/code/3-Scala语言基础/code3_66.scala)：

```scala
// Map.get 返回 Option — code3_63.scala
capitals.get("France")   // Some(Paris)
capitals.get("India")    // None

// 模式匹配处理Option — code3_64.scala ⚠️
def show(x: Option[String]) = x match {
  case Some(s) => s
  case None    => "?"
}

// getOrElse 安全获取 — code3_65.scala ⚠️
val a: Option[Int] = Some(5)
val b: Option[Int] = None
a.getOrElse(0)     // 5（有值返回值）
b.getOrElse(10)    // 10（无值返回默认值）

// isEmpty判断 — code3_66.scala
a.isEmpty   // false
b.isEmpty   // true
```

#### Tuple（元组）

来自源码 [code3_70.scala](BigData/Spark/code/3-Scala语言基础/code3_70.scala)：

```scala
val tuple = ("BigData", 2019, 45.0)
tuple._1    // "BigData"（索引从1开始！）
tuple._2    // 2019
tuple._3    // 45.0
```

#### Iterator（迭代器）⭐⚠️

来自源码 [code3_67.scala](BigData/Spark/code/3-Scala语言基础/code3_67.scala) ~ [code3_68.scala](BigData/Spark/code/3-Scala语言基础/code3_68.scala)：

```scala
// 创建Iterator
val iter = Iterator("Hadoop", "Spark", "Scala")

// 方式1：while + hasNext/next 遍历 — code3_67.scala
while (iter.hasNext) {
  println(iter.next())
}

// 方式2：for 遍历 — code3_68.scala
for (elem <- iter) {
  println(elem)
}
```

> ⚠️ **易错点**：Iterator是一次性的！遍历完后不可再次遍历，需要重新创建。`hasNext`检查是否有下一个元素，`next`返回当前元素并移动到下一个。

**Set的min/max操作**（来自 [code3_55.scala](BigData/Spark/code/3-Scala语言基础/code3_55.scala)）：

```scala
val num = Set(5, 6, 9, 20, 30, 45)
num.min    // 5
num.max    // 45
```

### 3.5 函数式编程 ⭐🔥

#### 递归与尾递归 ⚠️

来自源码 [code3_77.scala](BigData/Spark/code/3-Scala语言基础/code3_77.scala) ~ [code3_79.scala](BigData/Spark/code/3-Scala语言基础/code3_79.scala)：

```scala
// 普通递归 — code3_77.scala
def factorial(n: BigInt): BigInt = {
  if (n <= 1) 1
  else n * factorial(n - 1)
}

// 尾递归 — code3_78.scala ⚠️ 加 @annotation.tailrec
@annotation.tailrec
def factorial(n: Int, m: Int): Int = {
  if (n <= 0) m
  else factorial(n - 1, m * n)
}
// 尾递归由编译器优化为循环，避免栈溢出
// ⚠️ 如果尾递归条件不满足（非尾调用位置），编译器会报错！

// 内部函数 — code3_79.scala ⚠️
def factorial(i: Int): Int = {
  def fact(i: Int, accumulator: Int): Int = {
    if (i <= 1) accumulator
    else fact(i - 1, i * accumulator)
  }
  fact(i, 1)
}
```

#### 高阶函数 ⭐

来自源码 [code3_80.scala](BigData/Spark/code/3-Scala语言基础/code3_80.scala)：

```scala
// 函数作为参数 — 高阶函数
def apply(f: Int => String, v: Int) = f(v)
def layout[A](x: A) = "[" + x.toString() + "]"

println(apply(layout, 10))   // 输出: [10]
// layout函数作为参数传给apply
```

---


### 📝 第三章课后习题

#### Q1：res 变量是 val 还是 var？
**答：`val`（不可变引用）。** Scala REPL 每次计算后自动用 `res0`、`res1`…存储结果，这些变量都是 `val`，**不能被重新赋值**，永指向第一次计算的结果。

#### Q2：键入 "3." 后按 Tab 显示什么？
**答：显示 `Int` 类型所有可用方法的列表**，包括方法名称、方法签名（参数和返回类型）、部分方法附功能说明。如 `toDouble`、`toString`、`+`、`-`、`*`、`/`、`%` 等。

#### Q3：`val a = 10` 怎样转为 Double、String？
```scala
val a = 10
val doubleVal: Double = a.toDouble   // → 10.0
val stringVal: String = a.toString   // → "10"
// 或者：String.valueOf(a)
```

#### Q4：使用循环表达式输出九九乘法表
```scala
for (i <- 1 to 9) {
  for (j <- 1 to i) {
    print(s"$j × $i = ${i * j}\t")
  }
  println()
}
// 也可单行写法：for (i <- 1 to 9; j <- 1 to i) print(...)，但嵌套更清晰
```

#### Q5：List 创建及集合操作 🔥
给定 `val lst1 = List(1, 7, 9, 8, 0, 3, 5, 4, 6, 2)`

**(1) 每个元素乘 20 生成新集合：**
```scala
val newList = lst1.map(_ * 20)
// 结果: List(20, 140, 180, 160, 0, 60, 100, 80, 120, 40)
```

**(2) 取出所有奇数：**
```scala
val oddList = lst1.filter(_ % 2 != 0)
// 结果: List(1, 7, 9, 3, 5)
```

**(3) 定义阶乘函数后计算 lst1 所有元素阶乘的和：**
```scala
def factorial(n: Int): Int = {
  if (n <= 1) 1           // 注意：0! = 1
  else n * factorial(n - 1)
}
val sumFactorials = lst1.map(factorial).sum
// = 1! + 7! + 9! + 8! + 0! + 3! + 5! + 4! + 6! + 2!
```
> 💡 链式调用模式：`集合.map(变换).sum` / `集合.filter(条件).map(变换)`，是考试代码补全高频模式。

#### Q6：什么是闭包？🔥
**答：** 闭包是一个函数，其**返回值依赖于函数外部声明的自由变量**。关键在于：函数"捕获"的是变量的**引用**（而非当时的值）——外部变量变化后，闭包的行为也随之改变。

```scala
var factor = 2
val multiplier = (i: Int) => i * factor   // factor 是自由变量
factor = 3
println(multiplier(5))   // 输出 15（而非 10！捕获的是引用）
```
> ⚠️ **考点**：如果问"factor 从 2 改成 3 后 multiplier(5) 等于几？"答案是 **15** 而非 10。

#### Q7：需不需要显式调用 return？⚠️
**答：不需要。** Scala 自动将方法体**最后一行的表达式值**作为返回值。
```scala
def add(x: Int, y: Int): Int = {
  x + y      // 最后一行，自动作为返回值
}
```
**不推荐 `return` 的原因：**
- 必须同时显式声明返回类型，否则编译报错
- 嵌套函数中使用 `return` 会直接跳出外层函数（非局部返回），改变控制流
- 不符合 Scala 函数式编程风格

#### Q8：map 和 flatMap 的区别？🔥⚠️
> **考试高频！** 这是从 Scala 基础贯穿到 RDD 编程的核心概念。

| 维度 | `map` | `flatMap` |
|:----|:-----|:---------|
| 映射关系 | 一对一（每个输入→一个输出） | 一对多 + **拍平**（每个输入→多个输出→展平） |
| 元素个数 | 不变 | 可能变化 |
| 典型用途 | 变换每个元素（如 `_ * 2`） | 拆分+展平（如 WordCount 拆词） |

**具体示例（区分关键）：**
```scala
val list = List("Hello", "World")

// map：每个字符串 → 一个字符数组
list.map(_.toCharArray)
// 结果：List([H,e,l,l,o], [W,o,r,l,d])  ← 2个元素，每个是数组

// flatMap：每个字符串 → 拆成字符 → 展平为一个大集合
list.flatMap(_.toCharArray)
// 结果：List(H, e, l, l, o, W, o, r, l, d)  ← 10个元素，全部拍平
```
```scala
// 分割字符串（WordCount中的核心操作）
lines.flatMap(_.split(" "))    // "a b c" → [a,b,c]（拆词后展平）
// 若用 map：["a b", "c d"] → [[a,b], [c,d]]（仍然是嵌套结构）
```

#### Q9：编写高阶函数，求连续整数的 2 的幂次和（2^1 + 2^2 + ... + 2^n）
```scala
// 直接实现
def sumPowerOfTwo(n: Int): Int = {
  (1 to n).map(i => Math.pow(2, i).toInt).sum
}
// 调用：sumPowerOfTwo(5) → 2+4+8+16+32 = 62

// 通用高阶函数版本（接受任意计算函数 f）：
def sumWithFunc(n: Int, f: Int => Int): Int = {
  (1 to n).map(f).sum        // f 作为参数传入，体现"高阶函数"
}
// 调用：sumWithFunc(5, i => Math.pow(2, i).toInt)  // 62
// 也可传其他函数：sumWithFunc(5, i => i * i)       // 1+4+9+16+25=55
```

#### Q10：给定三个温度数组，求每个城市的平均温度 🔥
```scala
val data1 = Array(("Changsha", 35.1), ("Beijing", 27.7), ("Shanghai", 32.8), ("Shenyang", 24.6))
val data2 = Array(("Changsha", 36.3), ("Beijing", 30.4), ("Shanghai", 33.5))
val data3 = Array(("Changsha", 34.5), ("Beijing", 31.1), ("Shanghai", 32.0), ("Shenyang", 22.7))

val allData = data1 ++ data2 ++ data3                  // Array拼接
val avgTemp = allData
  .groupBy(_._1)                                       // 按城市名分组 → Map(城市, Array(记录...))
  .mapValues(_.map(_._2))                              // 提取温度 → Map(城市, Array(35.1, 36.3, ...))
  .mapValues(tempList => tempList.sum / tempList.length) // 求平均

// 输出：Map(Beijing -> 29.73, Changsha -> 35.3, Shanghai -> 32.77, Shenyang -> 23.65)
```
> ⚠️ `.mapValues` 返回的是**视图（lazy view）**，若后续需要多次使用应加 `.view.force` 或改用 `.map` 替代，避免每次访问都重新计算。

---

## 第四章 Scala面向对象编程

> ⭐⭐⭐ 较重要 — 类、对象、继承等基本概念

### 4.1 类的基本定义 ⚠️

来自源码 [code4_3.scala](BigData/Spark/code/4-Scala面向对象编程/code4_3.scala)：

```scala
class Student {
  private var age = 18       // 私有成员变量（自动生成getter/setter）
  val name = "Scala"         // 公有成员变量

  def increase(): Unit = { age += 1 }
  def current(): Int = { age }
}

object TestStudent_01 {
  def main(args: Array[String]) {
    val student = new Student
    student.increase()
    println(student.current)   // 输出: 19
  }
}
```

> ⚠️ **易错点**：`private var age` 自动生成 `age` (getter) 和 `age_=` (setter)，但private修饰后getter/setter也是私有的。

### 4.2 构造函数 ⭐🔥

#### 辅助构造函数（[code4_7.scala](BigData/Spark/code/4-Scala面向对象编程/code4_7.scala)）⚠️

```scala
class Student {
  private var age = 18
  private var name = ""
  private var classNum = 1

  def this(name: String) {            // 第一个辅助构造函数
    this()                             // ⚠️ 必须调用主构造函数！
    this.name = name
  }

  def this(name: String, classNum: Int) {  // 第二个辅助构造函数
    this(name)                         // ⚠️ 调用前一个辅助构造函数
    this.classNum = classNum
  }
}

// 三种调用方式
val myStudent1 = new Student                    // 主构造函数
val myStudent2 = new Student("ZhangSan")         // 第一个辅助构造函数
val myStudent3 = new Student("LiSi", 75)         // 第二个辅助构造函数
```

> ⚠️ **关键规则**：辅助构造函数的第一条语句**必须**调用另一个构造函数（`this(...)`）！

#### 主构造函数（[code4_8.scala](BigData/Spark/code/4-Scala面向对象编程/code4_8.scala)）⚠️

```scala
// 参数直接放在类名后面，加val/var自动升级为成员变量
class Student(val name: String, val classNum: Int) {
  private var age = 18
  def increase(step: Int): Unit = { age += step }
  def current(): Int = { age }
  def info(): Unit = { printf("Name:%s and classNum is %d\n", name, classNum) }
}

val myStudent = new Student("ZhangSan", 67)
myStudent.info    // 输出: Name:ZhangSan and classNum is 67
```

> ⚠️ **主构造函数特点**：参数加`val`/`var`自动成为成员变量；类体中除方法外的所有语句都会在主构造器调用时执行。

### 4.3 单例对象与伴生对象 ⭐🔥

#### 单例Object（[code4_10.scala](BigData/Spark/code/4-Scala面向对象编程/code4_10.scala)）

```scala
object TestStudents_02 {
  private var studentNum = 0
  def newStuNum = {
    studentNum += 1
    studentNum
  }
  def main(args: Array[String]) {
    println("New num is " + TestStudents_02.newStuNum)
  }
}
```

#### 伴生类+伴生对象（[code4_11.scala](BigData/Spark/code/4-Scala面向对象编程/code4_11.scala)）⚠️

```scala
// 伴生类
class Students {
  val id = Students.newStuId()     // 调用了伴生对象中的方法
  private var number = 0
  def aClass(number: Int) { this.number = number }
}

// 伴生对象 — 同名、同文件
object Students {
  private var StuId = 0
  def newStuId() = {
    StuId += 1
    StuId
  }
  def main(args: Array[String]) {
    println(Students.newStuId)     // 输出: 1
    println(Students.newStuId)     // 输出: 2
  }
}
```

> ⚠️ **重要考点**：伴生类和伴生对象可以**互相访问私有成员**！`object`是单例，不能`new`，类似Java的static。

### 4.4 抽象类 ⭐

来自源码 [code4_19.scala](BigData/Spark/code/4-Scala面向对象编程/code4_19.scala)：

```scala
abstract class Phone {
  val phoneBrand: String         // 抽象成员变量（必须声明类型！）
  def info()                     // 抽象方法（不需要abstract关键字，省去方法体即可）
  def greeting() {               // 具体方法（有实现）
    println("Welcome to use phone!")
  }
}

class Apple extends Phone {
  override val phoneBrand = "Apple"    // 重写抽象成员
  def info() {
    printf("This is a/an %s phone. It is expensive.\n", phoneBrand)
  }
  override def greeting() {            // 重写非抽象方法必须加override
    println("Welcome to use Apple Phone!")
  }
}
```

> ⚠️ **抽象类规则**：抽象方法不需要`abstract`关键字（省去方法体即可）；抽象成员变量必须**声明类型**；重写非抽象方法必须用`override`。

### 4.5 继承与多态 ⭐🔥⚠️

来自源码 [code4_20.scala](BigData/Spark/code/4-Scala面向对象编程/code4_20.scala) ~ [code4_22.scala](BigData/Spark/code/4-Scala面向对象编程/code4_22.scala)：

```scala
// 继承时的构造函数调用顺序 — code4_20.scala ⚠️
class Phone(var phoneBrand: String, var price: Int) {
  println("执行Phone类的主构造函数")
}

class Apple(phoneBrand: String, price: Int) extends Phone(phoneBrand, price) {
  println("执行Apple类的主构造函数")
}
// 输出顺序：先父类主构造函数 → 再子类主构造函数

// 多态 — code4_22.scala ⚠️
val p1: Phone = new HuaWei("huawei", 4500)
p1.buy()    // 调用HuaWei重写的buy()（运行时多态）

val p2: Phone = new Apple("iphone", 6400)
p2.buy()    // Apple未重写buy()，调用父类Phone的buy()
```

> ⚠️ **继承规则**：
> 1. 重写非抽象方法**必须**用 `override`
> 2. 只有主构造函数可调用父类主构造函数
> 3. 重写抽象方法可不用 `override`
> 4. 不允许多继承（一个类只能继承一个父类）
> 5. 创建子类对象时，先调用父类主构造函数，再调用子类
> 6. **动态绑定**：调用的方法是根据运行时实际对象类型决定的，而非编译时声明的引用类型（多态原理）

#### toString重写示例（[code4_21.scala](BigData/Spark/code/4-Scala面向对象编程/code4_21.scala)）⚠️

```scala
class Phone(var phoneBrand: String, var price: Int) {
  override def toString = s"Phone($phoneBrand,$price)"
  // 使用字符串插值 s"..." 重写toString
}

class Apple(phoneBrand: String, price: Int, var place: String) extends Phone(phoneBrand, price) {
  override def toString = s"Apple($phoneBrand,$price,$place)"
  // 子类继续重写，调用的是自身的toString
}

// 测试
println(new Apple("iphone", 5400, "Shenzhen"))
// 输出: Apple(iphone,5400,Shenzhen)
```

> ⚠️ **考点**：`override def toString` 是Scala中最常用的方法重写之一。`s"..."` 是Scala字符串插值语法，`$变量名` 可直接嵌入变量值。

### 4.6 Trait（特质）⭐🔥

来自源码 [code4_25.scala](BigData/Spark/code/4-Scala面向对象编程/code4_25.scala) ~ [code4_26.scala](BigData/Spark/code/4-Scala面向对象编程/code4_26.scala)：

```scala
// 单个Trait — code4_25.scala
trait PhoneId {
  var id: Int
  def currentId(): Int    // 抽象方法
}

class ApplePhoneId extends PhoneId {
  override var id = 10000
  def currentId(): Int = { id += 1; id }
}

// 多个Trait混入 — code4_26.scala ⚠️
trait PhoneGreeting {
  def greeting(msg: String) { println(msg) }  // 具体方法
}

// extends混入第1个Trait，with混入更多Trait
class ApplePhoneId extends PhoneId with PhoneGreeting {
  override var id = 10000
  def currentId(): Int = { id += 1; id }
}
```

**Trait vs Abstract Class** 🔥:

| 特性 | Trait | Abstract Class |
|------|-------|----------------|
| 多继承 | ✅ `extends` + `with` 混入多个 | ❌ 只能继承一个 |
| 构造器参数 | ❌ 不支持 | ✅ 支持 |
| 使用场景 | 定义行为接口 | 定义基类（有构造参数时） |

### 4.7 包导入技巧 ⭐

来自源码 [code4_37.scala](BigData/Spark/code/4-Scala面向对象编程/code4_37.scala) ~ [code4_38.scala](BigData/Spark/code/4-Scala面向对象编程/code4_38.scala)：

```scala
// 重命名导入 — code4_37.scala
import java.util.{ HashMap => JavaHashMap }   // 重命名避免冲突
import scala.collection.mutable.HashMap

val javaHashMap = new JavaHashMap[String, String]()

// 隐藏导入 — code4_38.scala ⚠️
import java.util.{ HashMap => _, _ }   // 隐藏HashMap，导入其余所有
// 现在HashMap无歧义地指向scala.collection.mutable.HashMap
```

---


### 📝 第四章课后习题

#### Q1：构造函数有什么作用？
**答：** 构造函数用于**初始化对象的状态**。Scala 中有两种：
- **主构造器**：直接写在类名后面，接收参数、初始化成员变量，类体中除字段/方法定义外的语句都会在主构造器调用时执行
- **辅助构造器**（`def this(...)`）：提供多种创建对象的方式，但**第一行必须调用** `this()`（主构造器或前一个辅助构造器）

```scala
class Employee(initialSalary: Double) {       // 主构造器
  private var salary = initialSalary          // 用参数初始化字段
}
def this() { this(0.0) }                      // 辅助构造器，第一行必须 this()
```

#### Q2：编写 BankAccount 类 🔥
加入 `deposit` 和 `withdraw` 方法，以及一个**只读**的 `balance` 属性。

```scala
class BankAccount {
  private var _balance: Double = 0.0          // 私有可变字段

  def balance: Double = _balance             // ⚠️ 只读属性：只有 getter，无 setter

  def deposit(amount: Double): Unit = {
    _balance += amount
  }

  def withdraw(amount: Double): Unit = {
    if (amount <= _balance) _balance -= amount
    else println("余额不足")
  }
}

// 使用
val acc = new BankAccount
acc.deposit(100)
acc.withdraw(30)
println(acc.balance)    // 70.0
// acc.balance = 200    // ❌ 编译错误！balance 是只读的
```
> ⚠️ **考点**：`def balance = _balance` 仅提供 getter，没有 `balance_=` setter → **只读**。这是考试中"设计只读属性"的标准做法。

#### Q3：扩展 Employee 类 — Programmer 收取 20 元手续费 🔥⚠️
```scala
class Employee(initialSalary: Double) {
  private var salary = initialSalary
  def tax(amount: Double) = { salary -= amount; salary }
  def bonus(amount: Double) = { salary += amount; salary }
}

// ⚠️ 子类重写，每次操作收取 20 元手续费
class Programmer(initialSalary: Double) extends Employee(initialSalary) {
  override def tax(amount: Double) = super.tax(amount + 20)    // ⚠️ 手续费加在扣款上
  override def bonus(amount: Double) = super.bonus(amount - 20) // ⚠️ 手续费从奖金扣
}
// 效果：每次 tax(100) 实际扣 120；每次 bonus(100) 实际加 80
```
> ⚠️ **考点**：`override` + `super.方法()` 调用父类实现 + 理解手续费对 tax/bonus 的不同影响方向。

#### Q4：设计 Point 类及 Dimension 子类
```scala
// 父类 Point：x,y,z 通过主构造器提供
class Point(val x: Int, val y: Int, val z: Int) {
  override def toString: String = s"Point($x, $y, $z)"
}

// 子类 Dimension：增加标签字段 label
class Dimension(val label: String, x: Int, y: Int, z: Int) extends Point(x, y, z) {
  override def toString: String = s"Dimension($label, $x, $y, $z)"
}

// 使用
val dim = new Dimension("Cube", 100, 100, 100)
println(dim)    // Dimension(Cube, 100, 100, 100)
```

#### Q5：抽象方法与具体方法的重写区别
| 重写类型 | 是否需要 `override` | 说明 |
|:--------|:------------------:|:-----|
| **重写抽象方法** | 可省略（但建议加） | 父类无实现，子类必须提供实现 |
| **重写具体方法** | **必须加**，否则编译报错 | 父类有默认实现，子类覆盖需显式声明 |

> ⚠️ 重写具体方法时想调用父类版本，用 `super.方法名()`。

#### Q6：定义抽象类的注意事项
- 使用 `abstract class` 关键字，**不能被实例化**（不能 `new`）
- 可包含**抽象字段**（未初始化的 `val`/`var`，**必须声明类型**）和**抽象方法**（无方法体，省去 = 和实现即可）
- 也可包含**具体实现**（已初始化字段、已实现方法）
- 主构造器参数若不 `加 val`/`var`，则默认为 `private[this]` 私有字段，子类无法直接访问
- 子类必须实现**所有**抽象成员，除非子类本身也是抽象的

#### Q7：什么是多态？多态存在的条件？🔥
**答：多态**指同一类型的引用（父类或特质）在运行时可以指向不同子类的对象，同一方法调用表现出**不同的行为**（动态绑定）。

**三个必要条件：**
1. **继承关系** — 子类继承父类或实现特质（`extends` / `with`）
2. **方法重写** — 子类用 `override` 重写父类方法
3. **父类引用指向子类对象** — `val p: ParentType = new ChildType(...)`

```scala
val p1: Phone = new HuaWei("huawei", 4500)   // 父类引用 → 子类对象
p1.buy()    // 调用 HuaWei 重写的 buy()（动态绑定到运行时类型）
val p2: Phone = new Apple("iphone", 6400)
p2.buy()    // Apple 若未重写 buy()，则调用父类 Phone 的 buy()
```
> 源码印证：`code4_22.scala` — 决定调用哪个方法的是**运行时实际对象类型**，而非编译时声明的引用类型。

#### Q8：特质（Trait）的作用
**答：** 特质是 Scala 中**代码复用的核心机制**，主要有四大作用：
1. **定义接口** — 声明抽象方法，供实现类实现
2. **提供默认实现** — 在特质中直接给出方法的默认实现（Java 接口做不到）
3. **混入（Mixin）多继承** — 一个类可通过 `extends ... with ... with ...` 混入多个特质
4. **实现高级设计模式** — 如依赖注入、装饰器模式（通过**堆叠特质**实现"蛋糕模式"）

```scala
trait Flyable { def fly(): Unit = println("flying") }
trait Swimmable { def swim(): Unit = println("swimming") }
class Duck extends Flyable with Swimmable   // 混入多个特质
```

#### Q9：特质与类的相同点和不同点 🔥
| 对比维度 | 相同点 | 不同点（类有，特质无） |
|:--------|:------|:--------------------|
| **成员定义** | 都可定义字段、方法、抽象成员 | 特质**不能有带参数构造器**（`trait T(x: Int)` ❌） |
| **继承机制** | 都可以被继承 | 类只能**单继承**；特质可**多混入**（多个 `with`） |
| **实例化** | — | 特质不能直接 `new`，但可通过匿名类：`new Trait { ... }` |
| **初始化顺序** | — | 特质按**从左到右线性化**顺序，类父类先于子类 |
| **使用场景** | — | 类适合有构造参数的基类；特质适合无状态的行为接口 |

#### Q10：Scala 中 import 关键字的功能
- **导入包或类** — `import scala.collection.mutable.ListBuffer`
- **导入对象所有成员** — `import math._`
- **花括号选取** — `import math.{Pi, sqrt}`
- **重命名** — `import java.util.{HashMap => JavaHashMap}`（避免命名冲突）
- **隐藏** — `import java.util.{ArrayList => _, _}`（隐藏 ArrayList，导入其余）
- **局部导入** — 可在函数内部、类内部导入，精细控制作用域
- 所有导入默认**相对路径**，从 `_root_` 根包开始

---

## 第五章 RDD编程

> ⭐⭐⭐⭐⭐ **"非常重要！后面所有编程都基于RDD"**

### 5.1 RDD核心概念 ⭐🔥

**RDD** = **Resilient Distributed Dataset**（弹性分布式数据集）

| 字母 | 含义 | 说明 |
|------|------|------|
| **R (Resilient)** | 弹性/容错 | 通过Lineage（血缘）恢复丢失数据，"任何时候都能重算" |
| **D (Distributed)** | 分布式 | 数据分布在集群多个节点，并行计算 |
| **D (Dataset)** | 数据集 | 数据的集合，只读对象集合 |

**RDD五大特征**：
1. **分区（Partitions）**：数据划分为多个分区，并行计算的基本单位
2. **函数（Compute）**：每个分区有一个计算函数
3. **依赖（Dependency）**：RDD间依赖关系，分窄依赖和宽依赖
4. **分区策略（Partitioner）**：Key-Value RDD根据哈希分区
5. **优先位置（Preferred Location）**：数据不动代码动

**关键特性**：
- **不可变（Immutable）**：每次转换生成新RDD
- **惰性（Lazy）**：Transformation不立即执行，Action时才计算

### 5.2 RDD创建方式 ⭐

```scala
// 1. 从集合创建
val rdd = sc.parallelize(Array(1, 2, 3, 4, 5))
val rdd = sc.makeRDD(Array(1, 2, 3))

// 2. 从文件创建 ⚠️ 注意路径格式
val rdd = sc.textFile("file:///local/path")
val rdd = sc.textFile("hdfs://namenode:9000/path")
val rdd = sc.textFile("class1.txt,class2.txt,class3.txt")  // 读取多个文件

// 3. 指定分区数
val rdd = sc.textFile("path/to/file", 4)
```

### 5.3 Transformation 操作（转换操作）⭐🔥📝

> **懒执行**，返回新RDD，不触发计算。这是代码补全题的核心！

#### Value型算子（作用于单个RDD）

| 算子 | 说明 | 示例 | 考点 |
|------|------|------|------|
| `map(f)` | 一对一映射 | `rdd.map(x => x * 2)` | 最常用 |
| `flatMap(f)` | 一对多+扁平化 | `rdd.flatMap(_.split(" "))` | ⚠️ 与map的区别 |
| `filter(f)` | 过滤 | `rdd.filter(_.length > 0)` | 保留返回true的 |
| `distinct()` | 去重 | `rdd.distinct()` | |
| `union(rdd2)` | 求并集 | `rdd.union(rdd2)` | |
| `intersection(rdd2)` | 求交集 | `rdd.intersection(rdd2)` | |
| `sortBy(f, asc)` | 排序 | `rdd.sortBy(x => x, false)` | |
| `sortByKey(asc)` | 按Key排序 | `rdd.sortByKey(false)` | 仅Key-Value RDD |

#### Key-Value型算子

| 算子 | 说明 | 考点 |
|------|------|------|
| `reduceByKey(f)` | 按Key聚合，**有Map端预聚合** | ⭐ 首选！ |
| `groupByKey()` | 按Key分组，**无预聚合** | ⚠️ 性能差 |
| `mapValues(f)` | 只映射Value | `rdd.mapValues(_ * 2)` |
| `keys` / `values` | 提取Key/Value | |
| `join(rdd2)` | 内连接 | ⭐ 常用 |
| `leftOuterJoin(rdd2)` | 左外连接 | |
| `cogroup(rdd2)` | 协分组 | |
| `coalesce(n)` | 减少分区（窄依赖，不Shuffle） | ⚠️ |
| `repartition(n)` | 重分区（宽依赖，会Shuffle） | ⚠️ 与coalesce区别 |

### 5.4 Action 操作（行动操作）⭐🔥📝

> **触发计算**，返回结果或写入外部存储。

| 操作 | 说明 | 考点 |
|------|------|------|
| `collect()` | 收集所有元素到Driver | ⚠️ 数据量大时慎用 |
| `count()` | 返回元素个数 | |
| `first()` | 返回第一个元素 | |
| `take(n)` | 返回前n个元素 | |
| `reduce(f)` | 聚合所有元素 | |
| `foreach(f)` | 对每个元素执行操作 | |
| `saveAsTextFile(path)` | 保存为文本文件 | |
| `countByKey()` | 按Key计数 | |

### 5.5 reduceByKey vs groupByKey 🔥⚠️

> **面试+考试高频考点！**

```scala
// reduceByKey：Map端有本地聚合（Combiner），推荐！
rdd.reduceByKey(_ + _)

// groupByKey：无本地聚合，所有数据Shuffle，可能OOM
rdd.groupByKey().mapValues(_.sum)
```

**为什么reduceByKey更优？**
- `reduceByKey`在Map端先做局部聚合（如`(c,1)(c,1)` → `(c,2)`），大幅减少Shuffle数据量
- `groupByKey`将所有Value全部通过网络传输，Shuffle数据量大

### 5.6 RDD依赖关系 ⭐🔥

#### 窄依赖（Narrow Dependency）
- 父RDD每个分区**最多**对应子RDD的一个分区
- 可在同一节点以**流水线（pipeline）**形式执行
- 数据恢复高效
- 示例：`map`、`filter`、`union`、`coalesce`

#### 宽依赖（Wide Dependency）
- 父RDD每个分区可能被子RDD的**多个分区**使用
- 需要**Shuffle**（数据混洗）
- 数据恢复可能有冗余计算
- 示例：`groupByKey`、`reduceByKey`、`join`、`repartition`

**Stage划分依据**：窄依赖的RDD划在同一Stage，宽依赖产生Stage边界。

```
窄依赖（Pipeline执行）：
  RDD_A → map → RDD_B → filter → RDD_C    [同一Stage]

宽依赖（Shuffle边界）：
  RDD_C → reduceByKey | Shuffle | → RDD_D
  Stage 1                          Stage 2
```

### 5.7 综合实例详解 ⭐📝

> 🎯 **"老师明确说：重点看每章的综合实例！考试会改编，不会原样照抄"** — 两个实例的数据、代码、结果对照看。

#### 实例1：学生成绩排名 — 全校前 n 名（[code5_34.scala](BigData/Spark/code/5-RDD编程/第五章实例1/code5_34.scala)）

**数据文件**（三个班，逗号分隔 `序号,学号,成绩,班级`）：

```
class1.txt:                    class2.txt:                    class3.txt:
1,1001,50,2018001              1,2001,55,2018002              1,3001,99,2018003
2,1002,60,2018001              2,2002,56,2018002              2,3002,84,2018003
3,1003,70,2018001              3,2003,88,2018002              3,3003,59,2018003
4,1004,20,2018001              4,2004,60,2018002              4,3004,71,2018003
5,1005,80,2018001              5,2005,78,2018002              5,3005,69,2018003
6,1006,66,2018001              6,2006,62,2018002              6,3006,100,2018003
7,1007,99,2018001
```

**代码详解**：

```scala
import org.apache.spark.{SparkConf, SparkContext}
object rank {
  def main(args: Array[String]): Unit = {
    val conf = new SparkConf().setAppName("rank").setMaster("local")
    val sc = new SparkContext(conf)
    sc.setLogLevel("ERROR")

    // ⚠️ 一次读取多个文件：逗号分隔路径
    val lines = sc.textFile("class1.txt,class2.txt,class3.txt")

    var num = 0
    val result = lines
      // ⚠️ filter过滤：去掉空行和格式不正确的行
      .filter(line => (line.trim().length > 0) && (line.split(",").length == 4))
      // map提取字段，重组结构：(成绩, (班级, 学号))
      .map(line => {
        val fields = line.split(",")
        val userid = fields(1)            // 学号
        val core = fields(2).toInt        // 成绩（转Int）
        val classs = fields(3)            // 班级
        (core, (classs, userid))          // 以成绩为Key
      })

    // ⚠️ sortByKey(false) — false=降序；take(10) — Action，取前10
    val result1 = result.sortByKey(false).take(10).foreach(x => {
      num = num + 1
      println(num + "\t\t" + x._2._1 + "\t\t" + x._2._2 + "\t" + x._1)
    })
  }
}
```

**运行结果**：

| rank | class | userid | core |
|:----:|-------|--------|:----:|
| 1 | 2018003 | 3006 | 100 |
| 2 | 2018001 | 1007 | 99 |
| 3 | 2018003 | 3001 | 99 |
| 4 | 2018002 | 2003 | 88 |
| 5 | 2018003 | 3002 | 84 |
| 6 | 2018001 | 1005 | 80 |
| 7 | 2018002 | 2005 | 78 |
| 8 | 2018003 | 3004 | 71 |
| 9 | 2018001 | 1003 | 70 |
| 10 | 2018003 | 3005 | 69 |

**⚠️ 代码补全要点**：
1. `sc.textFile("class1.txt,class2.txt,class3.txt")` — **多文件逗号拼接读取**
2. `.filter(line => (line.trim().length > 0) && (line.split(",").length == 4))` — 数据清洗
3. `fields(2).toInt` — String转Int
4. `(core, (classs, userid))` — 嵌套元组结构，成绩为 key 便于排序
5. `.sortByKey(false)` — 按 Key（成绩）**降序**（false=降序, true=升序）
6. `.take(10)` — Action 取前 n 名，结果为本地数组

#### 实例2：基站追踪 — 手机号位置与停留时长（[code5_35.scala](BigData/Spark/code/5-RDD编程/第五章实例2/code5_35.scala)）⭐📝

**数据文件**：
- **A.txt（日志）**：`手机号,时间戳,基站ID,连接类型`（1=建立连接，0=断开连接）
- **B.txt（基站表）**：`基站ID,经度,纬度,信号类型`

A.txt 完整数据（20行）：
```
18688888888,20160327082400,16030401EAFB68F1E3CDF819735E1C66,1
18611132889,20160327082500,16030401EAFB68F1E3CDF819735E1C66,1
18688888888,20160327170000,16030401EAFB68F1E3CDF819735E1C66,0
18611132889,20160327180000,16030401EAFB68F1E3CDF819735E1C66,0
18611132889,20160327075000,9F36407EAD0629FC166F14DDE7970F68,1
18688888888,20160327075100,9F36407EAD0629FC166F14DDE7970F68,1
18611132889,20160327081000,9F36407EAD0629FC166F14DDE7970F68,0
18688888888,20160327081300,9F36407EAD0629FC166F14DDE7970F68,0
18688888888,20160327175000,9F36407EAD0629FC166F14DDE7970F68,1
18611132889,20160327182000,9F36407EAD0629FC166F14DDE7970F68,1
18688888888,20160327220000,9F36407EAD0629FC166F14DDE7970F68,0
18611132889,20160327223000,9F36407EAD0629FC166F14DDE7970F68,0
18611132889,20160327081100,CC0710CC94ECC657A8561DE549D940E0,1
18688888888,20160327081200,CC0710CC94ECC657A8561DE549D940E0,1
18688888888,20160327081900,CC0710CC94ECC657A8561DE549D940E0,0
18611132889,20160327100000,CC0710CC94ECC657A8561DE549D940E0,0
18688888888,20160327171000,CC0710CC94ECC657A8561DE549D940E0,1
18688888888,20160327171600,CC0710CC94ECC657A8561DE549D940E0,0
18611132889,20160327180500,CC0710CC94ECC657A8561DE549D940E0,1
18611132889,20160327181500,CC0710CC94ECC657A8561DE549D940E0,0
```

B.txt 完整数据（3行）：
```
9F36407EAD0629FC166F14DDE7970F68,116.304864,40.050645,6
CC0710CC94ECC657A8561DE549D940E0,116.303955,40.041935,6
16030401EAFB68F1E3CDF819735E1C66,116.296302,40.032296,6
```

**核心思路**：
> 连接状态为 1 时取**负时间**，为 0 时取**正时间** → 同一手机在同一基站的连接时间 `+` 断开时间 → 时间相加（正负抵消）= **停留时长**

**代码详解**：

```scala
import org.apache.spark.rdd.RDD
import org.apache.spark.{SparkConf, SparkContext}

object mobineNum {
  def main(args: Array[String]) {
    val conf = new SparkConf().setAppName("mobineNum").setMaster("local")
    val sc = new SparkContext(conf)
    val lines = sc.textFile("A.txt")                      // 日志文件

    // ⚠️ 第一步：解析日志，计算停留时间
    // 核心技巧：连接(1)取负时间，断开(0)取正时间
    val splited = lines.map(line => {
      val fields = line.split(",")
      val mobile = fields(0)          // 手机号
      val lac = fields(2)             // 基站ID
      val tp = fields(3)              // 连接状态（1=连接, 0=断开）
      val time = if (tp == "1") -fields(1).toLong else fields(1).toLong
      ((mobile, lac), time)           // ((手机号, 基站ID), 正负时间)
    })

    // ⚠️ 第二步：reduceByKey 聚合
    val reduced = splited.reduceByKey(_ + _)
    // 同一手机+同一基站的正负时间相加 = 总停留时长

    // ⚠️ 第三步：转换结构 — 以基站ID为Key准备join
    val lmt = reduced.map(x => {
      // x._1._2 = lac, x._1._1 = mobile, x._2 = time
      (x._1._2, (x._1._1, x._2))     // (基站ID, (手机号, 时长))
    })

    // ⚠️ 第四步：读取基站经纬度信息
    val lacInfo = sc.textFile("B.txt")
    val splitedLacInfo = lacInfo.map(line => {
      val fields = line.split(",")
      (fields(0), (fields(1), fields(2)))    // (基站ID, (经度, 纬度))
    })

    // ⚠️ 第五步：join 关联
    val joined = lmt.join(splitedLacInfo)
    // 输出格式：(基站ID, ((手机号, 时长), (经度, 纬度)))
    println(joined.collect().toBuffer)
    sc.stop()
  }
}
```

**运行结果**（格式：`(基站ID, ((手机号, 停留时长秒), (经度, 纬度)))`）：

```
ArrayBuffer(
(CC0710CC94ECC657A8561DE549D940E0,((18688888888,1300),(116.303955,40.041935))),
(CC0710CC94ECC657A8561DE549D940E0,((18611132889,1900),(116.303955,40.041935))),
(9F36407EAD0629FC166F14DDE7970F68,((18611132889,54000),(116.304864,40.050645))),
(9F36407EAD0629FC166F14DDE7970F68,((18688888888,51200),(116.304864,40.050645))),
(16030401EAFB68F1E3CDF819735E1C66,((18611132889,97500),(116.296302,40.032296))),
(16030401EAFB68F1E3CDF819735E1C66,((18688888888,87600),(116.296302,40.032296)))
)
```

**⚠️ 代码补全要点**（考试高频填空位置）：
1. `if (tp == "1") -fields(1).toLong else fields(1).toLong` — **时间正负技巧**（连接=负，断开=正）
2. `reduceByKey(_ + _)` — 聚合同一手机同一基站的时间（正负相加=停留时长）
3. `(x._1._2, (x._1._1, x._2))` — 嵌套元组结构转换，注意 `._1`/`._2` 层级
4. `lmt.join(splitedLacInfo)` — join 操作，按基站 ID 关联经纬度
5. `.toLong` — String 转 Long（时间戳太长，Int 存不下）

> ⚠️ **调试技巧**：`println(joined.collect().toBuffer)` 仅适用于**小数据量调试**，大数据量应使用 `.take(n)` 而非 `.collect()`。
>
> ⚠️ **资源释放**：程序结束时调用 `sc.stop()` 释放 SparkContext 资源。

---


### 📝 第五章课后习题

#### Q1：RDD 是什么？能处理什么样的数据？处理方式相同吗？🔥
**答：RDD（弹性分布式数据集）** 是 Spark 的核心数据抽象。
- **定义**：一个**不可变**、**可分区**、**可并行计算**的分布式数据集合。三个关键属性——Resilient（弹性容错，通过 Lineage 恢复）、Distributed（分布在多节点）、Dataset（只读数据集合）
- **能处理的数据**：结构化（如 CSV 表）、半结构化（如 JSON）、非结构化（如日志文本、图像）——**任何能用 `textFile` 或 `parallelize` 加载的数据**
- **处理方式**：**不同数据有不同的处理方式**。非结构化数据直接用 Value 型算子（`map`/`filter`）；结构化 Key-Value 数据使用 ByKey 型算子（`reduceByKey`/`groupByKey`）；图数据用 GraphX；流数据用 Streaming

#### Q2：简述创建 RDD 的方式
**答：三种方式——**
```scala
// 方式1：从集合创建
val rdd = sc.parallelize(Array(1, 2, 3))       // 并行化集合
val rdd = sc.makeRDD(List(1, 2, 3))             // 等价方式

// 方式2：从外部存储创建（最常用）
val rdd = sc.textFile("file:///path/file.txt")   // 本地文件
val rdd = sc.textFile("hdfs://host:9000/path")   // HDFS 文件
val rdd = sc.textFile("f1.txt,f2.txt,f3.txt")    // ⚠️ 一次读取多个文件

// 方式3：从其他 RDD 转换而来（通过 Transformation）
val rdd2 = rdd.map(...)
```

#### Q3：什么是 Transformation 操作的惰性机制？🔥
**答：惰性机制（Lazy Evaluation）** 指 Transformation（`map`、`filter`、`reduceByKey` 等）**不会立即执行计算**，只构建**计算图（Lineage Graph / DAG）**记录操作间的"血缘关系"。只有当 **Action**（`collect`、`count`、`reduce`）被调用、真正需要结果时，Spark 才一次性触发整个 DAG 的计算。

**好处**：Spark 可以在真正执行前做**全局优化**——合并相邻操作、避免不必要计算、选择最优执行计划。
> 📝 经典实例：`sc.textFile("不存在的路径")` 在定义时不报错，只有执行 Action 时才报 FileNotFoundException。

#### Q4：在依赖关系中，为什么说窄依赖要比宽依赖好？🔥
**答：窄依赖无需 Shuffle（跨网络数据混洗），宽依赖需要 Shuffle。**

| 对比维度 | 窄依赖 | 宽依赖 |
|:--------|:------|:------|
| **数据传输** | 同一节点内完成，无需网络 | 需 **Shuffle**（跨节点传输大量数据） |
| **执行效率** | 支持**流水线（pipeline）执行** | 需等所有父分区数据就绪，有额外同步开销 |
| **容错恢复** | 丢失分区可**快速**从父分区重建 | 恢复成本高，可能需要重算多个分区及 Shuffle 结果 |
| **典型操作** | `map`、`filter`、`flatMap`、`union`、`coalesce` | `reduceByKey`、`groupByKey`、`join`、`repartition` |

**一句话**：窄依赖避免了昂贵的 Shuffle 开销，性能显著更优。**Stage 划分依据**就是窄依赖→同一 Stage，宽依赖→Stage 边界。

#### Q5：创建 RDD 并实现代码要求 🔥
```scala
val rdd: RDD[String] = sc.parallelize(List("Hello", "Spark", "World", "BigData"))
```

**(1) 求出每个元素（字符串）的长度：**
```scala
rdd.map(_.length).collect()           // Array(5, 5, 5, 7)
```

**(2) 筛选包含 "spark" 的元素（忽略大小写）：**
```scala
rdd.filter(_.toLowerCase.contains("spark")).collect()   // Array("Spark")
```

**(3) 对 RDD 中每个元素乘 2：**
```scala
val rddInt = sc.parallelize(1 to 10)
rddInt.map(_ * 2).collect()           // Array(2,4,6,...,20)
```

**(4) 筛选出偶数：**
```scala
rddInt.filter(_ % 2 == 0).collect()   // Array(2,4,6,8,10)
```

#### Q6：A: List(1,2,3,4), B: List(3,4,5,6)，求并集、交集、去重
```scala
val rddA = sc.parallelize(List(1, 2, 3, 4))
val rddB = sc.parallelize(List(3, 4, 5, 6))

// 并集（保留重复）
rddA.union(rddB).collect()               // {1, 2, 3, 4, 3, 4, 5, 6}

// 交集
rddA.intersection(rddB).collect()        // {3, 4}

// 去重
rddA.union(rddB).distinct().collect()    // {1, 2, 3, 4, 5, 6}
```

#### Q7：Array(1,2,3,4,5) 创建成并行集合并求和
```scala
sc.parallelize(Array(1, 2, 3, 4, 5)).reduce(_ + _)   // 结果: 15
```

#### Q8：自选一篇文章，统计该篇文章的词频（WordCount）🔥
```scala
sc.textFile("article.txt")
  .flatMap(_.split(" "))          // 按空格拆分单词并展平
  .map((_, 1))                    // 映射为 (单词, 1)
  .reduceByKey(_ + _)             // 按 Key 聚合计数
  .collect()
  .foreach(println)
```
> 💡 源码对比：`code1_1.scala`（空格 `split(" ")`）vs `code2_1.scala:8`（Tab `split("\t")`）。分隔符不同是考试常见的变形考察点。

#### Q9：给定键值对，求每个键对应的平均值 🔥⚠️
```scala
val sales = sc.parallelize(Seq(
  ("iPhone", 2), ("Huawei", 6), ("Xiaomi", 5), ("OPPO", 4),
  ("iPhone", 1), ("Huawei", 4), ("Xiaomi", 3), ("OPPO", 6)
))

// ⚠️ 经典三步法：mapValues((_,1)) → reduceByKey求和+计数 → mapValues求平均
val avgRDD = sales
  .mapValues((_, 1))                                   // (key, (value, 1))
  .reduceByKey((x, y) => (x._1 + y._1, x._2 + y._2))  // (key, (sum, count))
  .mapValues { case (sum, count) => sum.toDouble / count }

avgRDD.collect()
// 输出: (iPhone,1.5), (Huawei,5.0), (Xiaomi,4.0), (OPPO,5.0)
```
> ⚠️ **三步法模式**是求平均数的最经典套路，考试代码补全/写作高频出现。

#### Q10：统计 1000 万人口的平均年龄 🔥
```scala
val lines = sc.textFile("age_data.txt")       // 格式: "ID age"
val ages = lines.map(line => line.split(" ")(1).toInt)  // 提取年龄列
val count = ages.count()                       // 总人数
val totalAge = ages.reduce(_ + _)             // 总年龄
val averageAge = totalAge.toDouble / count     // 求平均
println(s"平均年龄是: $averageAge")
```
> ⚠️ 注意：`(1)` 不是 `(0)`，年龄在第 **1** 个索引位置。`count()` 和 `reduce()` 都是 Action，分别触发两次独立计算。

---

## 第六章 Spark SQL与DataFrame

> ⭐⭐⭐⭐⭐ **"大题最有可能来源于第6/7/8章"** — 重点关注DataFrame操作链

### 6.1 Spark SQL概述 ⭐

- 处理**结构化数据**的高级模块
- 提供**DataFrame**编程抽象（有Schema = 列名+类型）
- 支持SQL语句交互式查询
- Catalyst优化器深度优化

#### Catalyst优化器流程 ⭐🔥

```
SQL/Python/R → SQLParser → Unresolved Logical Plan
               ↓
            Analyzer → Resolved Logical Plan（绑定元数据）
               ↓
            Optimizer → Optimized Logical Plan（谓词下推、列裁剪）
               ↓
            Planner → Physical Plan
               ↓
            CostModel → 选择最佳物理计划 → Spark DAG执行
```

### 6.2 SparkSession — 统一入口 ⭐

来自 [code6_1.scala](BigData/Spark/code/6-Spark_SQL/code6_1.scala)：

```scala
import org.apache.spark.sql.SparkSession

val spark = SparkSession.builder()
  .master("local")
  .appName("Spark SQL basic example")
  .config("spark.some.config.option", "some-value")
  .getOrCreate()

// ⚠️ 必须引入！用于RDD和DataFrame之间的隐式转换
import spark.implicits._
```

### 6.3 DataFrame创建方式 ⭐🔥📝

> ⚠️ 5种创建方式是代码补全题的**核心考点**！

#### 方式1：从JSON读取（自动推断Schema）

来自 [code6_3.scala](BigData/Spark/code/6-Spark_SQL/code6_3.scala)：

```scala
val df = spark.read.json("/home/ubuntu/student.json")
// 或者：val df = spark.read.format("json").load("/path/to/file")

df.printSchema()   // 打印Schema
df.show(6)         // 显示前6行
```

#### 方式2：从Parquet读取（默认数据源）

来自 [code6_4.scala](BigData/Spark/code/6-Spark_SQL/code6_4.scala)：

```scala
// 写入Parquet（自动保存Schema）
peopleDF.write.parquet("people.parquet")

// 读取Parquet
val parquetFileDF = spark.read.parquet("people.parquet")
// 或：val parquetFileDF = spark.read.load("people.parquet")  ← Parquet是默认格式

// ⚠️ SQL直接查询Parquet文件
val sqlDF = spark.sql("SELECT * FROM parquet.`/home/ubuntu/people.parquet`")

// Schema合并
val mergedDF = spark.read.option("mergeSchema", "true").parquet("data/test_table")
```

#### 方式3：使用Case Class + toDF()

来自 [code6_12.scala](BigData/Spark/code/6-Spark_SQL/code6_12.scala) ⚠️：

```scala
// ⚠️ 先定义case class
case class student(name: String, age: Int, Height: Int, Weight: Int)

import spark.implicits._

// 读文本 → split → map到case class → toDF
val stuRDD = spark.sparkContext.textFile("/home/ubuntu/student.txt")
  .map(_.split(","))
  .map(elements => student(
    elements(0),
    elements(1).trim.toInt,    // ⚠️ String转Int，记得trim！
    elements(4).trim.toInt,
    elements(5).trim.toInt
  ))

val stuDF = stuRDD.toDF()      // ⚠️ RDD转DataFrame

// 注册临时视图，用SQL查询
stuDF.createOrReplaceTempView("student")
val result = spark.sql("SELECT name, age, Height, Weight FROM student WHERE age BETWEEN 13 AND 19")
result.show()
```

#### 方式4：编程方式指定Schema（StructType）

来自 [code6_13.scala](BigData/Spark/code/6-Spark_SQL/code6_13.scala) ⚠️：

```scala
import org.apache.spark.sql.types._
import org.apache.spark.sql.Row

// 创建RDD
val stuRDD = spark.sparkContext.textFile("/home/ubuntu/student.txt")

// ⚠️ 定义schema字符串，split转成字段数组
val schemaString = "name age country"
val fields = schemaString.split(" ")
  .map(fieldName => StructField(fieldName, StringType, nullable = true))

// ⚠️ 构建StructType
val schema = StructType(fields)

// ⚠️ RDD[String] → RDD[Row]
val rowRDD = stuRDD.map(_.split(","))
  .map(elements => Row(elements(0), elements(1).trim, elements(2)))

// ⚠️ 创建DataFrame
val stuDF = spark.createDataFrame(rowRDD, schema)
```

#### 方式5：从JDBC读取

来自 [code6_10.scala](BigData/Spark/code/6-Spark_SQL/code6_10.scala)：

```scala
import java.util.Properties

val jdbcDF = spark.read
  .format("jdbc")
  .option("url", "jdbc:mysql://localhost:3306/student")
  .option("driver", "com.mysql.jdbc.Driver")
  .option("dbtable", "stu")
  .option("user", "root")
  .option("password", "mysql")
  .load()

// ⚠️ 写入模式
addstu.write
  .mode("append")     // append / overwrite / error / ignore
  .jdbc("jdbc:mysql://localhost:3306/student", "student.stu", connectionProperties)
```

### 6.4 DataFrame操作 ⭐🔥📝

> 这些操作是代码补全题的重要来源！可能考察链式调用：`df.操作1.操作2.操作3`

#### 基本操作

```scala
df.show()                // 显示前20行
df.show(10)              // 显示前10行
df.printSchema()         // 打印Schema结构
df.count()               // 总行数
df.columns               // 列名数组
df.dtypes                // 列名和数据类型
```

#### 选择与过滤 ⚠️

```scala
// 选择指定列
df.select("name", "age").show()
df.select($"name", $"age" + 1).show()    // ⚠️ $符号引用列

// 过滤
df.filter("age > 20").show()             // 字符串表达式
df.filter($"age" > 20).show()            // $-语法
df.where($"age" > 20).show()             // where = filter别名

// 去重
df.distinct().show()
```

#### 聚合与分组

```scala
df.groupBy("country").count().show()
df.groupBy("country").avg("age").show()
df.groupBy("country").agg(avg("age"), max("Height")).show()
```

#### 排序

```scala
df.orderBy($"age".desc).show()          // 降序
df.orderBy($"age".desc, $"name".asc).show()  // 多列排序
```

#### Join连接 ⚠️

```scala
// 内连接
df1.join(df2, df1("id") === df2("id"), "inner")
// ⚠️ 注意用 === 而不是 == ！

// 用Seq简化
df1.join(df2, Seq("id"), "left")        // 左连接
```

#### SQL查询

```scala
// 注册临时视图
df.createOrReplaceTempView("students")

// SQL查询
spark.sql("SELECT * FROM students WHERE age > 20").show()
```

### 6.5 DataFrame vs RDD ⭐🔥

> 课本第185页的对比图 — 简答题高频考点！

| 特性 | RDD | DataFrame |
|------|-----|-----------|
| 数据结构 | 分布式Java对象集合 | 分布式Row对象集合 |
| Schema | **无结构信息** | **有Schema（列名+类型）** |
| 优化 | 仅Stage层面流水线优化 | Catalyst优化器深度优化 |
| API | 低级API（函数式） | 高级API（SQL接口） |
| 数据处理 | 任意数据 | 结构化/半结构化数据 |
| 序列化 | Java/Kryo | Tungsten二进制 |

**DataFrame优势**：
- 有Schema，Spark SQL可洞察数据结构进行针对性优化
- 列式存储 + 代码生成，减少内存占用
- 列裁剪（只读需要的列）+ 谓词下推（提前过滤）

### 6.6 分区写入与Schema合并 ⭐

来自 [code6_5.scala](BigData/Spark/code/6-Spark_SQL/code6_5.scala)：

```scala
// ⚠️ 创建DataFrame并写入分区目录 data/test_table/key=1
val squaresDF = spark.sparkContext.makeRDD(1 to 5)
  .map(i => (i, i * i)).toDF("value", "square")
squaresDF.write.parquet("data/test_table/key=1")

// ⚠️ 创建结构不同的DataFrame写入 data/test_table/key=2
// 列名变为cube，且没有square列！
val cubesDF = spark.sparkContext.makeRDD(6 to 10)
  .map(i => (i, i * i * i)).toDF("value", "cube")
cubesDF.write.parquet("data/test_table/key=2")

// ⚠️ 读取时启用Schema合并 — mergeSchema
val mergedDF = spark.read.option("mergeSchema", "true").parquet("data/test_table")
mergedDF.printSchema()
// root
//  |-- value: int (nullable = true)
//  |-- square: int (nullable = true)   ← 只在key=1分区中有
//  |-- cube: int (nullable = true)     ← 只在key=2分区中有
//  |-- key: int (nullable = true)      ← 分区列自动添加
```

> ⚠️ **核心考点**：不同分区目录中的Parquet文件可以有不同的Schema；读取时通过 `option("mergeSchema", "true")` 自动合并；分区列（目录名）会被自动识别并添加到Schema末尾。

### 6.7 Hive集成 ⭐📝

来自 [code6_6.scala](BigData/Spark/code/6-Spark_SQL/code6_6.scala) — **课本中重要的集成模块**：

```scala
import java.io.File
import org.apache.spark.sql.{Row, SaveMode, SparkSession}

// ⚠️ 启用Hive支持
val warehouseLocation = new File("spark-warehouse").getAbsolutePath
val spark = SparkSession.builder()
  .appName("Spark Hive Example")
  .config("spark.sql.warehouse.dir", warehouseLocation)
  .enableHiveSupport()          // ⚠️ 关键方法：启用Hive支持
  .getOrCreate()

import spark.implicits._
import spark.sql

// ⚠️ 使用HiveQL创建表
sql("CREATE TABLE IF NOT EXISTS src (key INT, value STRING) USING hive")
sql("LOAD DATA LOCAL INPATH 'examples/src/main/resources/kv1.txt' INTO TABLE src")

// ⚠️ HiveQL查询 — 结果本身就是DataFrame
sql("SELECT * FROM src").show()
sql("SELECT COUNT(*) FROM src").show()

// ⚠️ Row类型数据提取
val sqlDF = sql("SELECT key, value FROM src WHERE key < 10 ORDER BY key")
val stringsDS = sqlDF.map {
  case Row(key: Int, value: String) => s"Key: $key, Value: $value"
}

// ⚠️ DataFrame临时表与Hive表做Join
val recordsDF = spark.createDataFrame((1 to 100).map(i => Record(i, s"val_$i")))
recordsDF.createOrReplaceTempView("records")
sql("SELECT * FROM records r JOIN src s ON r.key = s.key").show()

// ⚠️ SaveMode 写入模式
df.write.mode(SaveMode.Overwrite).saveAsTable("hive_records")
// SaveMode: Append / Overwrite / ErrorIfExists / Ignore

// ⚠️ Hive外部表
val dataDir = "/tmp/parquet_data"
spark.range(10).write.parquet(dataDir)
sql(s"CREATE EXTERNAL TABLE hive_ints(key int) STORED AS PARQUET LOCATION '$dataDir'")

// ⚠️ Hive动态分区
spark.sqlContext.setConf("hive.exec.dynamic.partition", "true")
spark.sqlContext.setConf("hive.exec.dynamic.partition.mode", "nonstrict")
df.write.partitionBy("key").format("hive").saveAsTable("hive_part_tbl")
// 分区列'key'自动移至schema末尾
```

> ⚠️ **Hive集成考点**：
> - `enableHiveSupport()` — 启用Hive支持的关键方法
> - `SaveMode` — 4种写入模式（Overwrite/Append/ErrorIfExists/Ignore）
> - 外部表 vs 托管表 — `CREATE EXTERNAL TABLE ... LOCATION '...'`
> - 动态分区 — `partitionBy("key")` + `hive.exec.dynamic.partition=true`
> - Row类型 — `case Row(key: Int, value: String) =>` 模式匹配提取列值

### 6.8 数据文件格式总览 ⭐

> 本章涉及多个数据文件，了解其格式有助于考场快速理解题意

| 文件名 | 格式 | 字段（按顺序） | 说明 |
|--------|------|------|------|
| `student.json` | JSON | name, age, country, institute, Height, Weight | 11条记录，正常Schema |
| `student.txt` | CSV | name, age, country, institute, Height, Weight | 22条记录，6列逗号分隔 |
| `exStudent.json` | JSON | 部分字段缺失 | ⚠️ 含空记录`{}`和缺失字段，用于测试Schema推断 |
| `newstudent.json` | JSON | 完整字段 | 单条记录 |
| `joininfo.json` | JSON | 含math_score等 | 用于演示join操作 |
| 学生表(student.txt) | CSV | Sno, Sname, Ssex, Sbirthday, SClass | 6条记录 |
| 教师表(teacher.txt) | CSV | Tno, Tname, Tsex, Tbirthday, Prof, Depart | 5条记录 |
| 课程表(course.txt) | CSV | Cno, Cname, Tno | 5条记录 |
| 成绩表(score.txt) | CSV | Sno, Cno, Degree | 成绩字段为Int类型 |

### 6.9 综合实例详解（[code6_42.scala](BigData/Spark/code/6-Spark_SQL/第六章实例/code6_42.scala)）⭐📝

> 🎯 **"第六章综合实例重点看！大题最可能来源"** — 学生-教师-课程-成绩四表关联，考试代码写作题的必考模板。

#### 6.9.1 四张业务数据表（完整数据）

**student 表**（6 条）：`Sno, Sname, Ssex, Sbirthday, SClass`
```
108,ZhangSan,male,1995/9/1,95033
105,KangWeiWei,female,1996/6/1,95031
107,GuiGui,male,1992/5/5,95033
101,WangFeng,male,1993/8/8,95031
106,LiuBing,female,1996/5/20,95033
109,DuBingYan,male,1995/5/21,95031
```
**teacher 表**（5 条）：`Tno, Tname, Tsex, Tbirthday, Prof, Depart`
```
825,LinYu,male,1958/1/1,Associate professor,department of computer
804,DuMei,female,1962/1/1,Assistant professor,computer science department
888,RenLi,male,1972/5/1,Lecturer,department of electronic engineering
852,GongMOMO,female,1986/1/5,Associate professor,computer science department
864,DuanMu,male,1985/6/1,Assistant professor,department of computer
```
**course 表**（5 条）：`Cno, Cname, Tno（教师编号外键）`
```
3-105,Introduction to computer,825
3-245,The operating system,804
6-101,Spark SQL,888
6-102,Spark,852
9-106,Scala,864
```
**score 表**（18 条）：`Sno（学生外键）, Cno（课程外键）, Degree`
```
108,3-105,99  105,3-105,88  107,3-105,77  105,3-245,87
108,3-245,89  107,3-245,82  106,3-245,74  107,6-101,75
108,6-101,82  106,6-101,65  109,6-102,99  101,6-102,79
105,9-106,81  106,9-106,97  107,9-106,65  108,9-106,100
109,9-106,82  105,6-102,85
```

#### 6.9.2 建表标准模式（StructType 方式）

> ⚠️ **四张表完全一样的建表套路**，考试代码补全高频出现。以 score 表为例：

```scala
// ① 读文本 → RDD[String]
val scoreRDD = spark.sparkContext.textFile("/path/score.txt")
// ② 定义 Schema
val ScoreSchema = StructType(mutable.ArraySeq(
  StructField("Sno", StringType, nullable = false),
  StructField("Cno", StringType, nullable = false),
  StructField("Degree", IntegerType, nullable = true)   // ⚠️ 成绩是 IntegerType！
))
// ③ RDD[String] → RDD[Row]（拆分+类型匹配）
val scoreData = scoreRDD.map(_.split(","))
  .map(attrs => Row(attrs(0), attrs(1), attrs(2)))
// ④ createDataFrame → 注册临时视图
val scoreDF = spark.createDataFrame(scoreData, ScoreSchema)
scoreDF.createOrReplaceTempView("score")
```

> 📌 四张表的 Schema 字段速记：student(5列:Sno/Sname/Ssex/Sbirthday/SClass)、teacher(6列:Tno/Tname/Tsex/Tbirthday/Prof/Depart)、course(3列:Cno/Cname/Tno)、score(3列:Sno/Cno/Degree)

#### 6.9.3 9 种查询模式速查表 🔥📝

> 以下模式覆盖了 DataFrame API + SQL 的全部考察形式。

| # | 类型 | 操作 | 代码 | 关键点 |
|:--|:----|:-----|:-----|:------|
| 1 | SQL | **排序** | `spark.sql("SELECT * FROM student ORDER BY SClass DESC")` | ORDER BY + DESC/ASC |
| 2 | SQL | **UNION** | `spark.sql("SELECT ... FROM Student WHERE ssex='female' UNION SELECT ... FROM Teacher WHERE tsex='female'")` | ⚠️ 两表列数、类型一致 |
| 3 | SQL | **子查询** | `spark.sql("SELECT ... WHERE prof NOT IN (SELECT ... JOIN ...)")` | NOT IN + 自连接 |
| 4 | SQL | **聚合** | `spark.sql("SELECT SClass,AVG(Degree) FROM student JOIN score ON Sno GROUP BY SClass")` | JOIN + GROUP BY |
| 5 | API | **count** | `println(studentDF.count())` → 6 | Action，返回 Long |
| 6 | API | **select** | `studentDF.select("Sname","Ssex").show()` | 多列逗号分隔 |
| 7 | API | **filter/where** | `teacherDF.filter("Tsex='male'")` `studentDF.where("Sno='101'")` | 两者是别名 |
| 8 | API | **distinct** | `teacherDF.select("Depart").distinct()` | 先 select 再 distinct |
| 9 | API | **collectAsList** | `teacherDF.collectAsList()` | 全量拉到 Driver |

**关键查询输出速查**（验证理解用）：
```
count: student=6, teacher=5
filter male teacher → LinYu(825), RenLi(888), DuanMu(864) 共3人
distinct depart → department of computer, computer science dept, electronic engineering 共3个
Sno='101' → WangFeng, male, 1993/8/8, 95031
UNION female → GongMOMO + KangWeiWei + LiuBing + DuMei 共4人
filter SClass='95033' → ZhangSan(108), GuiGui(107), LiuBing(106) 共3人
```

---

### 📝 第六章课后习题

#### Q1：Spark SQL 有哪些特点？
**答：** ①易整合（SQL + Spark 编程无缝结合）；②统一数据访问（同一接口连接 Hive/JSON/Parquet/JDBC）；③兼容 Hive（直接运行 HiveQL）；④标准连接（JDBC/ODBC）；⑤**Catalyst 优化器**高性能（列裁剪、谓词下推）。

#### Q2：支持哪些数据源？
| 类型 | 格式与短名称 |
|:----|:-----------|
| 列式存储 | Parquet（默认）、ORC |
| 文本格式 | JSON、CSV、TXT |
| 关系数据库 | JDBC（MySQL/PostgreSQL 等） |
| 其他 | Hive、Avro、libsvm |

#### Q3：DataFrame 与 RDD 的区别？🔥
| 维度 | RDD | DataFrame |
|:----|:---:|:---------:|
| Schema | 无结构 | **有 Schema（列名+类型）** |
| 类型安全 | ✅ 编译时检查 | ❌ 运行时才报错 |
| 优化能力 | 简单流水线 | **Catalyst 深度优化** |
| API 风格 | 函数式（map/filter） | 声明式 SQL + DSL |
| 序列化 | Java/Kryo | Tungsten 二进制 |

#### Q4：RDD 转 DataFrame 的两种方法
- **反射方式**（已知 Schema）：定义 `case class` → `rdd.map(...).toDF()`
- **编程方式**（运行时 Schema）：`StructType` → `RDD[Row]` → `spark.createDataFrame(rowRDD, schema)`
> 💡 详见 6.9.2 节建表标准模式，四张表均为编程方式的标准范例。

#### Q5：从外部数据源创建 DataFrame
```scala
spark.read.json("x.json")                              // JSON 自动推断 Schema
spark.read.parquet("x.parquet")                        // Parquet（默认格式）
spark.read.option("header","true").csv("x.csv")        // CSV 含表头
spark.read.format("jdbc").option("url",...).load()     // JDBC 数据库
```

#### Q6：save 的默认数据源？不同源转存储？
**默认：Parquet**（可通过 `spark.sql.sources.default` 修改）。
```scala
spark.read.json("in.json").write.save("out.parquet")           // JSON→Parquet
spark.read.csv("in.csv").write.mode("overwrite").save("out")   // CSV→Parquet
```
> `SaveMode` 四种：`Overwrite`（覆盖）/ `Append`（追加）/ `ErrorIfExists` / `Ignore`

#### Q7：对 6.4 节示例，用 DataFrame API 查询 95033 班学生信息 🔥
```scala
import spark.implicits._

// 方式一：filter + $ 语法
studentDF.filter($"SClass" === "95033").show()

// 方式二：SQL 表达式
studentDF.where("SClass = '95033'").show()

// 方式三：纯 SQL
spark.sql("SELECT * FROM student WHERE SClass = '95033'").show()
// 结果：ZhangSan(108), GuiGui(107), LiuBing(106)
```
> ⚠️ 注意：`filter($"col" === "val")` 用 `===`；`where("col = 'val'")` 用 `=`

#### Q8：对 6.4 节示例，用 DataFrame API 求班级平均成绩和课程平均成绩 🔥⚠️
> ⚠️ **关键陷阱**：score 表中**没有班级字段**，求班级平均必须先 JOIN student 表！

```scala
import org.apache.spark.sql.functions.avg

// (1) 按班级显示每个班级的平均成绩（需 JOIN student 获取班级）
val classAvg = studentDF
  .join(scoreDF, "Sno")                        // 按学号关联
  .groupBy("SClass")                           // 按班级分组
  .agg(avg("Degree").alias("avg_score"))       // 求成绩均值
classAvg.show()

// (2) 按课程显示每门课的平均成绩（score 表有 Cno，可不 JOIN）
val courseAvg = scoreDF
  .groupBy("Cno")
  .agg(avg("Degree").alias("avg_score"))
courseAvg.show()
```
> 💡 **考试套路**：题目表面问"按班级平均"，但给出的表没有班级列 → 必须 **JOIN**！

#### Q9：创建一个完整案例：Transformation + Action + 保存操作 🔥
```scala
import org.apache.spark.sql.SparkSession
import org.apache.spark.sql.functions._

object SparkSQLDemo {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder()
      .appName("Demo").master("local[2]").getOrCreate()
    import spark.implicits._

    // 准备数据
    case class Employee(name: String, dept: String, salary: Double)
    val df = spark.sparkContext.parallelize(Seq(
      Employee("张三","技术部",15000), Employee("李四","技术部",18000),
      Employee("王五","市场部",12000), Employee("赵六","市场部",14000),
      Employee("孙七","财务部",16000)
    )).toDF()

    // ---- Transformation（惰性，不执行） ----
    val result = df.filter($"salary" >= 15000)
      .groupBy("dept").agg(avg("salary").alias("avg_salary"))
      .orderBy($"avg_salary".desc)

    // ---- Action（触发执行） ----
    result.show()                // 打印表格
    println(s"部门数: ${result.count()}")

    // ---- 保存（Action） ----
    result.write.mode("overwrite").save("output/dept_avg")
    result.write.json("output/dept_avg.json")

    spark.stop()
  }
}
```
> ⚠️ `show()` 和 `write.save()` 都是 Action，不能链式串联（`show()` 返回 Unit）。正确：先 show 查看，再 write 保存。

## 第七章 Spark Streaming流式计算

> ⭐⭐⭐⭐⭐ **"三种特殊数据之二：流式数据"** — 7.3节滑动窗口是难点

### 7.1 核心概念 ⭐🔥

**Spark Streaming**：准实时微批处理框架。

**工作流程**：
```
实时数据流 → 按批处理间隔切分 → 批数据（DStream中的RDD）
  → Spark Engine处理 → 批结果输出
```

| 概念 | 说明 |
|------|------|
| **DStream** | 离散流（Discretized Stream），一系列连续RDD的序列 |
| **批处理间隔** | 数据切分的时间段（如1秒、10秒） |
| **StreamingContext** | 流处理的入口对象 |
| **DStream = RDD序列** | 每个批处理间隔内的数据对应一个RDD |

### 7.2 StreamingContext创建 ⭐📝

```scala
import org.apache.spark.streaming._

// ⚠️ 方式1：从SparkConf创建
val conf = new SparkConf().setMaster("local[2]").setAppName("Streaming")
val ssc = new StreamingContext(conf, Seconds(10))   // 批处理间隔10秒

// ⚠️ 方式2：从SparkContext创建
val ssc = new StreamingContext(sc, Seconds(1))

// 启动和停止
ssc.start()               // ⚠️ 启动流计算
ssc.awaitTermination()    // ⚠️ 等待终止
ssc.stop()                // 手动停止
```

> ⚠️ **注意**：`local[2]`表示至少2个线程（1个接收数据，1个处理数据），不能少于2！

### 7.3 输入源类型 ⭐📝

#### 基础输入源

| 输入源 | 创建方法 | 代码文件 |
|--------|----------|----------|
| **Socket流** | `ssc.socketTextStream(host, port)` | [code7_13.scala](BigData/Spark/code/7-Spark_Streaming/code7_13.scala) |
| **文件流** | `ssc.textFileStream(dir)` | [code7_11.scala](BigData/Spark/code/7-Spark_Streaming/code7_11.scala) |
| **RDD队列流** | `ssc.queueStream(rddQueue)` | [code7_12.scala](BigData/Spark/code/7-Spark_Streaming/code7_12.scala) |
| **Kafka流** | `KafkaUtils.createStream(...)` | [code7_16.scala](BigData/Spark/code/7-Spark_Streaming/code7_16.scala) |

#### Socket流示例（[code7_13.scala](BigData/Spark/code/7-Spark_Streaming/code7_13.scala)）⚠️

```scala
val conf = new SparkConf().setMaster("local[2]").setAppName("Socket_Stream")
val ssc = new StreamingContext(conf, Seconds(10))

val lines = ssc.socketTextStream("192.168.201.139", 9999)
val words = lines.flatMap(_.split(" "))
val wordCounts = words.map(x => (x, 1)).reduceByKey(_ + _)
wordCounts.print()

ssc.start()
ssc.awaitTermination()
```

#### 文件流示例（[code7_11.scala](BigData/Spark/code/7-Spark_Streaming/code7_11.scala)）⚠️

```scala
val ssc = new StreamingContext(conf, Seconds(30))   // 监控间隔30秒
val lines = ssc.textFileStream("/home/ubuntu/Desktop/File_Stream")
// ⚠️ 监控目录下的新文件，已存在的文件不会被处理！
```

#### RDD队列流（[code7_12.scala](BigData/Spark/code/7-Spark_Streaming/code7_12.scala)）⚠️

```scala
val rddQueue = new scala.collection.mutable.SynchronizedQueue[RDD[Int]]()
val queueStream = ssc.queueStream(rddQueue)

// 向队列中推RDD
for (i <- 1 to 10) {
  rddQueue += ssc.sparkContext.makeRDD(1 to 100)
  Thread.sleep(1000)
}
```

### 7.4 窗口操作 ⭐🔥⚠️

> **7.3节核心难点！**"这个窗口滑来滑去很容易搞错"

#### 基本窗口操作

来自 [code7_6.scala](BigData/Spark/code/7-Spark_Streaming/code7_6.scala)：

```scala
// window(windowLength, slideInterval)
// ⚠️ 窗口长度和滑动步长必须是批处理间隔的倍数！
val windowwords = words.window(Seconds(30), Seconds(10))
// 窗口长度30秒，滑动间隔10秒 → 窗口重叠20秒
```

#### countByWindow（[code7_7.scala](BigData/Spark/code/7-Spark_Streaming/code7_7.scala)）

```scala
ssc.checkpoint("/home/ubuntu/Desktop/checkpoint")  // ⚠️ 必须设置checkpoint！
val windowwords = words.countByWindow(Seconds(30), Seconds(10))
```

#### reduceByKeyAndWindow 的两种变体对比 ⚠️

```scala
// ⚠️ 变体1：不带反向函数（简单但性能差）
// val wordCounts = words.map(x => (x, 1))
//   .reduceByKeyAndWindow((a:Int,b:Int) => (a + b), Seconds(30), Seconds(10), 2)
//   末尾的 2 是 filter 参数（最少分区数）

// ⚠️ 变体2：带反向函数（高效版本，只计算新增和移除的数据）
val wordCounts = words.map(x => (x, 1))
  .reduceByKeyAndWindow(
    _ + _,           // 加入新数据（加函数）
    _ - _,           // 移除旧数据（减函数）
    Seconds(30),     // 窗口长度
    Seconds(10),     // 滑动间隔
    2                // filter参数：最少分区数
  )
```

> ⚠️ **性能差异**：不带反向函数的版本会重复计算窗口内所有数据；带反向函数的版本只计算新增和移除的数据，大幅减少计算量。**带反向函数的版本必须设置checkpoint！**

**窗口参数图解**：
```
时间轴：0    10   20   30   40   50   60
        |----|----|----|----|----|----|
        
窗口1(0-30):  [============]
窗口2(10-40):      [============]
窗口3(20-50):           [============]

窗口长度=30s, 滑动间隔=10s → 每10秒产生一个新窗口，相邻窗口重叠20秒
```

### 7.5 updateStateByKey（有状态操作）⭐🔥⚠️

来自 [code7_9.scala](BigData/Spark/code/7-Spark_Streaming/code7_9.scala)：

```scala
ssc.checkpoint("/home/ubuntu/Desktop/checkpoint")  // ⚠️ 必须设置！

socketLines.flatMap(_.split(" ")).map(word => (word, 1))
  .updateStateByKey(
    (currValues: Seq[Int], preValue: Option[Int]) => {  // ⚠️ 两个参数
      val currValue = currValues.sum                     // 当前批次新值求和
      Some(currValue + preValue.getOrElse(0))            // 新值 + 旧状态
    }
  ).print()
```

**⚠️ updateStateByKey 三个要点**：
1. 必须设置 checkpoint
2. 第一个参数是当前批次的值序列（Seq），第二个参数是历史状态（Option）
3. 返回值必须包装在 `Some()` 中

### 7.6 输出操作

```scala
// print — 打印前10条
wordCounts.print()

// saveAsTextFiles — 自动生成时间戳文件
lines.saveAsTextFiles("/home/ubuntu/Desktop/file/test", "txt")
// 生成文件：test-<timestamp>.txt
```

### 7.8 Kafka端到端示例 ⭐📝

> Kafka集成包含**生产者端**和**消费者端**两段代码，考试可能考察完整流程中的一环。

#### Kafka生产者（[code7_14.scala](BigData/Spark/code/7-Spark_Streaming/code7_14.scala)）⚠️

```scala
import java.util.HashMap
import org.apache.kafka.clients.producer.{KafkaProducer, ProducerConfig, ProducerRecord}

// ⚠️ KafkaProducer配置
val props = new HashMap[String, Object]()
props.put(ProducerConfig.BOOTSTRAP_SERVERS_CONFIG, brokers)      // Kafka集群地址
props.put(ProducerConfig.VALUE_SERIALIZER_CLASS_CONFIG,
  "org.apache.kafka.common.serialization.StringSerializer")      // 值序列化
props.put(ProducerConfig.KEY_SERIALIZER_CLASS_CONFIG,
  "org.apache.kafka.common.serialization.StringSerializer")      // 键序列化

val producer = new KafkaProducer[String, String](props)

// ⚠️ 循环发送消息
while (true) {
  (1 to messages.toInt).foreach { messageNum =>
    val str = (1 to words.toInt)
      .map(x => scala.util.Random.nextInt(10).toString)  // 随机生成0-9的数字
      .mkString(" ")
    val message = new ProducerRecord[String, String](topic, null, str)
    producer.send(message)                                // ⚠️ 发送消息
  }
  Thread.sleep(1000)  // 每秒发送一批
}
```

#### Kafka消费者（[code7_16.scala](BigData/Spark/code/7-Spark_Streaming/code7_16.scala)）⭐

```scala
import org.apache.spark.streaming.kafka.KafkaUtils

// ⚠️ StreamingExamples.setStreamingLogLevels() 的作用：
// 设置日志级别为WARN，减少控制台冗余输出（Kafka、Spark Streaming示例的标准配置）

val zkQuorum = "localhost:2181"        // Zookeeper地址
val group = "kafka_test"               // Consumer Group
val topics = "sender"                  // Topic名称
val numThreads = 1                     // 线程数

// ⚠️ 创建Kafka DStream
val topicMap = topics.split(",").map((_, numThreads.toInt)).toMap
val lineMap = KafkaUtils.createStream(ssc, zkQuorum, group, topicMap)
val lines = lineMap.map(_._2)          // 提取消息体

// 后续与普通流处理相同
val words = lines.flatMap(_.split(" "))
val pair = words.map(x => (x, 1))
val wordCount = pair.reduceByKey(_ + _)
wordCount.print()
```

---


### 📝 第七章课后习题

#### Q1：简要介绍静态数据与流数据及对它们的处理方法
| 类型 | 特征 | 处理方式 |
|:----|:----|:--------|
| **静态数据** | 静止不动、相对稳定，数据量已知 | **批量计算**（攒够一批一起处理，时间充裕） |
| **流数据** | 大量、快速、持续到达，价值随时间流逝 | **实时计算**（到达后立即处理，低延迟） |

> 核心区别：流数据经处理后**仅部分**转为静态数据存入数据库，大部分实时消费后丢弃。

#### Q2：简要介绍什么是 DStream
**答：DStream（Discretized Stream，离散流）** 是 Spark Streaming 对**流式数据的基本抽象**。它将连续不断的实时数据流按**批处理间隔**（如每 10 秒）切分为一系列不连续的 **RDD**。本质：`DStream = RDD 序列 + 时间维度`。每个 DStream 操作最终会转换为底层 RDD 操作。

#### Q3：DStream 中按批处理间隔划分的元素与 RDD 的关系？
**答：一一对应关系。** 每个**批处理间隔**内到达的数据，会被封装为一个独立的 **RDD**。DStream 内部就是一个连续的 RDD 序列——每隔一个时间间隔产生一个新 RDD 追加到序列中。

> 💡 源码：`new StreamingContext(conf, Seconds(10))` → 每隔 10 秒生成一个 RDD。

#### Q4：Spark Streaming 有哪三种基本输入源？🔥
| 输入源 | 方法 | 说明 |
|:------|:-----|:----|
| **文件流** | `ssc.textFileStream(dir)` | ⚠️ 只监控**新文件**，已存在的不处理 |
| **Socket 流** | `ssc.socketTextStream(host, port)` | 从 TCP 套接字接收文本数据 |
| **Akka Actor** | `ssc.actorStream(...)` | 从 Akka Actor 接收数据 |

> 扩展（非基本但高频）：**Kafka 流** — `KafkaUtils.createDirectStream(...)` / `KafkaUtils.createStream(...)`

#### Q5：什么是 DStream 的窗口操作？
**答：** 窗口操作是在 DStream 上应用**滑动窗口**进行转换计算。两个核心参数：
- **窗口长度（windowLength）**：看多久的数据（如 30 秒）
- **滑动间隔（slideInterval）**：每隔多久算一次（如 10 秒）

```
时间轴:  0    10    20    30    40    50
窗口1:  [============]                 ← 监测 0~30s 的数据
窗口2:        [============]           ← 监测 10~40s 的数据
窗口3:              [============]     ← 监测 20~50s 的数据
```

> ⚠️ **必须条件**：窗口长度和滑动间隔必须是**批处理间隔的整数倍**！

#### Q6：为什么要设置合适的批次大小？🔥
**答：** 批次大小（批处理间隔）是 Streaming 的**核心权衡参数**：
- **太短**（如 1 秒）→ 数据可能处理不完，导致**延迟堆积、OOM 内存溢出**
- **太长**（如 1 分钟）→ **实时性差**，失去流处理意义
- **建议**：从 5~10 秒保守值开始，监控处理延迟，确保**批处理时间 < 批处理间隔**

#### Q7：什么是有状态转换操作？什么是无状态转换操作？🔥⚠️
| 类型 | 定义 | 特点 | 典型操作 |
|:----|:----|:----|:--------|
| **无状态** | 当前批次独立处理，不依赖历史 | 每个批次计算结果只取决于**当前批次** | `map`、`filter`、`reduceByKey`、`flatMap` |
| **有状态** | 当前批次处理**依赖历史数据** | 需维护跨批次的中间结果 | **滑动窗口**、**`updateStateByKey`** |

**有状态转换的两种形式：**
1. **滑动窗口**：只看最近一段时间（如最近 30 秒），旧数据自然"过期"
2. **updateStateByKey**：从程序启动开始累计所有历史数据，持续维护"总榜"

> 💡 记忆口诀：无状态=各算各的，有状态=得记着以前的事。

#### Q8：在 IDEA 中运行 window 操作 🔥📝
```scala
import org.apache.spark.SparkConf
import org.apache.spark.streaming._

object Window_op {
  def main(arg: Array[String]): Unit = {
    val conf = new SparkConf().setMaster("local[2]").setAppName("Windowtest")
    val ssc = new StreamingContext(conf, Seconds(10))               // 间隔10s

    val lines = ssc.socketTextStream("192.168.201.139", 9999)      // 数据源
    val words = lines.flatMap(_.split(" "))
    val windowwords = words.window(Seconds(30), Seconds(10))       // ⚠️ 窗口30s，滑动10s
    windowwords.print()

    ssc.start()
    ssc.awaitTermination()
  }
}
```
> 源码：`code7_6.scala`。考题可能把 `window(30,10)` 的参数变成填空。

#### Q9：在 IDEA 中运行 reduceByKeyAndWindow 操作 🔥⚠️
> ⚠️ **高效版 vs 普通版**：高效版用加减函数只算新增/移除数据，**必须设置 checkpoint**。

```scala
ssc.checkpoint("/path/to/checkpoint")    // ⚠️ 必须先设！

val wordCounts = words.map(x => (x, 1))
  .reduceByKeyAndWindow(
    _ + _,           // 加函数：处理新进入窗口的数据
    _ - _,           // 减函数：移除滑出窗口的数据（高效版独有！）
    Seconds(30),     // 窗口长度
    Seconds(10),     // 滑动间隔
    2                // filter参数：最少分区数
  )
wordCounts.print()
```
> 普通版不带减函数：`.reduceByKeyAndWindow((a:Int,b:Int) => a+b, Seconds(30), Seconds(10))` — 每次都重算整个窗口，性能差。

#### Q10：在 IDEA 中运行 updateStateByKey 操作 🔥⚠️
> ⚠️ **3 个必须**：①必须设 checkpoint；②第一个参数是 `Seq[Int]`（当前批次的值序列）；③返回值必须包在 `Some()` 中。

```scala
ssc.checkpoint("/path/to/checkpoint")    // ⚠️ 必须！

def updateFunc(currValues: Seq[Int], preValue: Option[Int]): Option[Int] = {
  val currSum = currValues.sum                // 当前批次新值的和
  Some(currSum + preValue.getOrElse(0))       // + 历史累计值 → 新状态
}

val stateDStream = words.map((_, 1))
  .updateStateByKey(updateFunc)               // 跨批次累计

stateDStream.print()
```

#### Q11：配置并运行 Kafka 实例，在 Streaming 中处理 Kafka 流式数据 🔥
**环境准备**：搭建 Kafka 集群 → 创建 Topic → 添加 `spark-streaming-kafka-0-10` 依赖。

**消费者端关键代码**（考试补全高频）：
```scala
import org.apache.spark.streaming.kafka.KafkaUtils

val zkQuorum = "localhost:2181"            // Zookeeper 地址
val group = "kafka_test"                   // Consumer Group
val topics = "sender"                      // Topic 名称

val topicMap = topics.split(",").map((_, 1)).toMap
val lineMap = KafkaUtils.createStream(ssc, zkQuorum, group, topicMap)
val lines = lineMap.map(_._2)              // ⚠️ 提取消息体（_._2 是 value）

// 后续与普通流处理相同
val wordCount = lines.flatMap(_.split(" ")).map((_, 1)).reduceByKey(_ + _)
wordCount.print()
```
> 源码：`code7_16.scala`（消费者）、`code7_14.scala`（生产者）。考试重点在消费者端连接+提取。

---

## 第八章 Spark GraphX图计算

> ⭐⭐⭐⭐⭐ **"三种特殊数据之三：图数据"** — 图构建+图操作必考

### 8.1 GraphX核心概念 ⭐

- 核心抽象：**Resilient Distributed Property Graph**（点和边都带属性的有向多重图）
- 扩展RDD抽象，依赖RDD容错性

**三种基本数据结构**：

```scala
// Vertex: (VertexId, VD)
(1L, "Tom")           // Long类型的ID + 顶点属性

// Edge: Edge(srcId, dstId, ED)
Edge(1L, 2L, "Colleague")   // 源ID + 目标ID + 边属性

// Triplet: 边 + 两端顶点数据
// (srcVertex, dstVertex, edgeAttr)
```

**三层架构**：
```
算法层：PageRank、TriangleCount、ConnectedComponents、Pregel
  ↓
操作层：Graph（抽象类）、GraphImpl、GraphOps
  ↓
存储层：VertexRDD[VD]、EdgeRDD[ED]、EdgeTriplet
```

### 8.2 图构建 ⭐🔥📝

> **"给定一个图，用代码转换成Spark能识别的图结构" — 最基本的操作，拿到第一步分数**

```scala
import org.apache.spark.graphx._

// ⚠️ 创建顶点RDD: RDD[(VertexId, 顶点属性)]
val vertices: RDD[(VertexId, String)] = sc.parallelize(Array(
  (1L, "Tom"),
  (2L, "Marry"),
  (3L, "Jack")
))

// ⚠️ 创建边RDD: RDD[Edge[边属性]]
val edges: RDD[Edge[String]] = sc.parallelize(Array(
  Edge(1L, 2L, "Colleague"),
  Edge(2L, 3L, "Child")
))

// ⚠️ 构建Graph对象
val graph = Graph(vertices, edges, "defaultUser")
//                                       ↑ 默认顶点属性（用于缺失顶点）
```

### 8.3 图基本属性操作 ⭐📝

```scala
// ⚠️ 基本属性 — 用代码获取，不能"手指头点着图去点"
graph.vertices          // 顶点RDD: VertexRDD[VD]
graph.edges             // 边RDD: EdgeRDD[ED]
graph.triplets          // 三元组RDD
graph.numVertices       // 顶点数量
graph.numEdges          // 边数量
graph.inDegrees         // 入度
graph.outDegrees        // 出度
graph.degrees           // 总度
```

### 8.4 图操作 ⭐📝

```scala
// 子图 — 过滤顶点
graph.subgraph(vpred = (id, attr) => attr != "spam")

// 顶点映射
graph.mapVertices((id, attr) => attr.toUpperCase)

// 边映射
graph.mapEdges(e => e.attr.toUpperCase)

// ⚠️ mapTriplets（已废弃） → 使用 aggregateMessages
```

### 8.5 aggregateMessages（核心消息聚合）⭐🔥📝

来自 [8-12.txt](BigData/Spark/code/8-Spark_GraphX/8-12.txt)：

```scala
def aggregateMessages[Msg: ClassTag](
  sendMsg: EdgeContext[VD, ED, Msg] => Unit,  // 发送消息函数
  mergeMsg: (Msg, Msg) => Msg,                // 合并消息函数
  tripletFields: TripletFields = TripletFields.All
): VertexRDD[Msg]
```

**使用示例**：
```scala
// 计算每个顶点的邻居数量
val msgRDD = graph.aggregateMessages[Int](
  triplet => {
    triplet.sendToDst(1)     // ⚠️ 向目标顶点发送消息
    triplet.sendToSrc(1)     // ⚠️ 向源顶点发送消息
  },
  (a, b) => a + b            // ⚠️ 合并同一顶点收到的消息
)
```

### 8.6 Pregel API ⭐🔥⚠️

来自 [8-14.txt](BigData/Spark/code/8-Spark_GraphX/8-14.txt)：

```scala
def pregel[A](
  initialMsg: A,                                  // 初始消息
  maxIter: Int = Int.MaxValue,                    // 最大迭代次数
  activeDir: EdgeDirection = EdgeDirection.Out    // 消息发送方向
)(
  vprog: (VertexId, VD, A) => VD,                // ⚠️ 顶点程序：处理消息
  sendMsg: EdgeTriplet[VD, ED] => Iterator[(VertexId, A)], // ⚠️ 发送消息
  mergeMsg: (A, A) => A                           // ⚠️ 合并消息
): Graph[VD, ED]
```

**Pregel工作流程**：
1. 所有顶点收到初始消息 → 执行`vprog`
2. 活跃顶点通过`sendMsg`向邻居发消息
3. 同一顶点的多条消息通过`mergeMsg`合并
4. 重复2-3直到无消息或达到最大迭代次数

### 8.7 内置图算法 ⭐📝

#### PageRank（[8_17.scala](BigData/Spark/code/8-Spark_GraphX/8_17.scala)）

```scala
import org.apache.spark.graphx.GraphLoader

// ⚠️ 从边列表文件加载图
val graph = GraphLoader.edgeListFile(sc, "followers.txt")

// ⚠️ 运行PageRank，误差容忍度0.0001
val ranks = graph.pageRank(0.0001).vertices

// 关联用户名
val users = sc.textFile("users.txt").map { line =>
  val fields = line.split(",")
  (fields(0).toLong, fields(1))
}
val ranksByUsername = users.join(ranks).map {
  case (id, (username, rank)) => (username, rank)
}
```

**数据文件格式**：
- `followers.txt`：`源节点ID 目标节点ID`（每行一条边）
- `users.txt`：`ID,用户名,全名`

#### 三角形计数（[8_18.scala](BigData/Spark/code/8-Spark_GraphX/8_18.scala)）

```scala
val graph = GraphLoader.edgeListFile(sc, "followers.txt", true)
  .partitionBy(PartitionStrategy.RandomVertexCut)

val triCounts = graph.triangleCount().vertices
val triCountByUsername = users.join(triCounts).map {
  case (id, (username, tc)) => (username, tc)
}
```

### 8.8 经典图算法详解（考试变形来源）⚠️📝

> ⚠️ 复习指南明确说："经典算法的代码实现**会有变形，不会照抄课本**，复习时最好把代码都看一遍，能应变"

#### Dijkstra最短路径（[8_22.scala](BigData/Spark/code/8-Spark_GraphX/8_22.scala)）⭐

**核心数据结构**：顶点属性 = `(visited: Boolean, distance: Double, prevVertex: Long)`

```scala
// ⚠️ 初始化：起点距离为0，其他为无穷大
var g2 = g.mapVertices((vid, _) =>
  (false, if (vid == origin) 0 else Double.MaxValue, -1L)
)

for (i <- 1L to g.vertices.count()) {
  // ⚠️ 找未访问顶点中距离最小的
  val currentVertexId = g2.vertices
    .filter(!_._2._1)  // visited == false
    .reduce((a, b) => if (a._2._2 < b._2._2) a else b)._1

  // ⚠️ 通过 aggregateMessages 发送到邻居的距离
  val newDistances = g2.aggregateMessages[(Double, Long)](
    triplet => if (triplet.srcId == currentVertexId && !triplet.dstAttr._1) {
      triplet.sendToDst((triplet.srcAttr._2 + triplet.attr, triplet.srcId))
    },
    (x, y) => if (x._1 < y._1) x else y,   // 取最短距离
    TripletFields.All
  )

  // ⚠️ 用 outerJoinVertices 更新图
  g2 = g2.outerJoinVertices(newDistances) { ... }
}
```

> ⚠️ **关键步骤**：① 初始化 `(false, 0/∞, -1)`；② 循环选最近未访问顶点；③ `aggregateMessages` 松弛邻居；④ `outerJoinVertices` 更新。

#### Prim最小生成树（[8_24.scala](BigData/Spark/code/8-Spark_GraphX/8_24.scala)）

**与Dijkstra结构相似但语义不同**：

```scala
// ⚠️ 初始化中的double含义不同：加入当前顶点的最小边权代价
var g2 = g.mapVertices((vid, _) =>
  (false, if (vid == origin) 0 else Double.MaxValue, -1L)
)

// ⚠️ 消息发送的是 triplet.attr（边权），而非累加距离
val newDistances = g2.aggregateMessages[(Double, Long)](
  triplet => if (triplet.srcId == currentVertexId && !triplet.dstAttr._1) {
    triplet.sendToDst((triplet.attr, triplet.srcId))  // 直接传边权
  },
  (x, y) => if (x._1 < y._1) x else y,
  TripletFields.All
)
```

#### TSP旅行商-贪心策略（[8_23.scala](BigData/Spark/code/8-Spark_GraphX/8_23.scala)）

**核心**：使用 `mapTriplets` 标记已用边，每次选当前顶点的最小未用邻边。

```scala
// ⚠️ 图状态：顶点Boolean标记是否访问，边(Double, Boolean)标记(权值, 是否已用)
var g2: Graph[Boolean, (Double, Boolean)] = g
  .mapVertices((vid, vd) => vid == origin)
  .mapTriplets { et => (et.attr, false) }

// ⚠️ 自定义比较器找最小边
val smallestEdge = availableEdges.min()(new Ordering[tripletType]() {
  override def compare(a: tripletType, b: tripletType) =
    Ordering[Double].compare(a.attr._1, b.attr._1)
})
```

#### 影响力传播-BFS（[8_28.scala](BigData/Spark/code/8-Spark_GraphX/8_28.scala)）

**数据格式**（`twitter-graph-data.txt`）：`((User47,86566510),(User83,15647839))`

```scala
// ⚠️ 解析twitter数据：提取followee和follower
val followeeVertices = twitterData.map(_.split(",")).map { arr =>
  val user = arr(0).replace("((", "")      // 去掉左括号
  val id = arr(1).replace(")", "")          // 去掉右括号
  (id.toLong, user)
}

// ⚠️ Pregel BFS 影响力传播
val subGraph = graph.pregel("", 2, EdgeDirection.In)(
  (_, attr, msg) => attr + "," + msg,                          // vprog：拼接属性
  triplet => Iterator((triplet.srcId, triplet.dstAttr)),       // sendMsg：沿入边传播
  (a, b) => (a + "," + b)                                      // mergeMsg：拼接消息
)

// ⚠️ 找影响力最大的用户
val lengthRDD = subGraph.vertices
  .map(vertex => (vertex._1, vertex._2.split(",").distinct.length - 2))
  .max()(new Ordering[Tuple2[VertexId, Int]]() { ... })
```

### 8.9 图分割方式 ⭐

| 分割 | 存储策略 | 优点 | 缺点 |
|------|----------|------|------|
| **边分割** | 每个顶点存一次，边可能跨节点 | 节省存储 | 内网通信量大 |
| **点分割** | 每条边存一次，顶点可能重复 | **减少通信** | 增加存储 |

> ⚠️ **GraphX使用点分割** — 原因：磁盘便宜，内网带宽宝贵（空间换时间）；网络多为无尺度网络（幂律分布），边分割导致高邻居节点的边跨机器。

---


### 📝 第八章课后习题

#### Q1：GraphX 基本数据结构包含哪些 RDD？
| 结构 | 说明 | 格式 |
|:----|:----|:----|
| **VertexRDD[VD]** | 顶点表 | `(VertexId, VD)` |
| **EdgeRDD[ED]** | 边表 | `(srcId, dstId, ED)` |
| **Triplet** | 逻辑视图 | `(srcAttr, dstAttr, edgeAttr)` |

#### Q2：GraphX 存储方式？
**答：** 分布式图存储 + **点分割**（Vertex-cut）。顶点分布式存储，边按分区策略存储。

#### Q3：GraphX 实现架构？
**答：** Graph API 层 → Graph Operator 层 → Execution Engine（RDD DAG）→ Storage Layer（VertexRDD + EdgeRDD）。本质：Spark RDD + 图计算封装。

#### Q4：aggregateMessages vs Pregel API？
**相同：** 都用于图消息传递，都基于迭代模型。
**不同：** aggregateMessages 更底层灵活但无内置迭代；Pregel 内置 superstep 迭代，更封装。

#### Q5：PageRank 计算流程？
1. 初始化 rank = 1.0
2. 每节点将 rank 均分给出边邻居
3. $rank(v) = (1-d) + d 	imes \sum rac{rank(u)}{outDegree(u)}$
4. 收敛或达到迭代次数
> 💡 源码 `8_17.scala:16`：`graph.pageRank(0.0001).vertices`

#### Q6：标签传播算法？
**答：** 每个节点初始化为自身 id，迭代收集邻居频率最高的 label，直到不再变化。
```scala
graph.labelPropagation.maxIter(10).run()
```

#### Q7：Dijkstra 最短路径？
**答：** 初始化 source=0其余=∞ → 选最近未访问顶点 → aggregateMessages 松弛 → outerJoinVertices 更新。通常用 Pregel API 实现。

#### Q8：Kruskal 最小生成树？
**答：** 边按权重排序 → 依次选最小边 → 并查集判环 → 不成环则加入 MST。

#### Q9：图构建与查询 🔥📝

**数据：** 5 个节点（名字+年龄），7 条有向边（带关系属性）。

| ID | 姓名 | 年龄 | | 边 |
|:--|:----|:---:|---|:---|
| 1 | Ann | 25 | | 1→3 friend |
| 2 | Bill | 43 | | 1→2 family |
| 3 | Charles | 28 | | 2→3 none |
| 4 | Diane | 31 | | 2→4 friend |
| 5 | Lily | 16 | | 3→4 friend, 3→5 family, 4→5 teach |

**(1) 构建关系图 graph：**
```scala
import org.apache.spark.graphx._

val vertices = sc.parallelize(Seq(
  (1L, ("Ann", 25)), (2L, ("Bill", 43)), (3L, ("Charles", 28)),
  (4L, ("Diane", 31)), (5L, ("Lily", 16))
))
val edges = sc.parallelize(Seq(
  Edge(1L, 3L, "friend"), Edge(1L, 2L, "family"), Edge(2L, 3L, "none"),
  Edge(2L, 4L, "friend"), Edge(3L, 4L, "friend"), Edge(3L, 5L, "family"),
  Edge(4L, 5L, "teach")
))
val graph = Graph(vertices, edges, "defaultUser")
```

**(2) 找年龄 20~30 的顶点，输出 "name is age"：**
```scala
graph.vertices
  .filter { case (_, (_, age)) => age > 20 && age < 30 }
  .map { case (_, (name, age)) => s"$name is $age" }
  .collect().foreach(println)

// 输出：
// Ann is 25
// Charles is 28
```

**(3) 所有顶点年龄 +15，输出 "Id is (name,age)"：**
```scala
graph.vertices.mapValues { case (name, age) => (name, age + 15) }
  .map { case (id, (name, age)) => s"$id is ($name,$age)" }
  .collect().foreach(println)

// 输出：
// 1 is (Ann,40)  2 is (Bill,58)  3 is (Charles,43)
// 4 is (Diane,46)  5 is (Lily,31)
```

**(4) 构建年龄 > 30 的子图并输出：**
```scala
val subG = graph.subgraph(vpred = (_, attr) => attr._2 > 30)
// 输出顶点
subG.vertices.map { case (_, (name, age)) => s"$name is $age" }
  .collect().foreach(println)
// Bill is 43, Diane is 31  (Lily=16 → 被过滤，Ann=25→被过滤)

// 输出边（只保留两端均 >30 的）
subG.triplets.map(t => s"${t.srcId} to ${t.dstId} attr ${t.attr}")
  .collect().foreach(println)
// 2 to 4 attr friend  (Bill→Diane，唯一两端都>30的边)
```
> ⚠️ `subgraph` 只保留 `vpred` 过滤后两端都存在的边。

#### Q10：设计书籍推荐系统（协同过滤思想）📝
> 用户对书籍的评分（0~10），预测 User4 对 Book1 的评分。

数据：User1→Book1=10, User1→Book2=8, User2→Book1=8, User2→Book3=4, User3→Book2=8, User3→Book3=10, User4→Book2=8, User4→Book3=6

**思路**：将用户和书籍作为图的**两类节点**，评分作为**边权**。构建二分图后用 **Pregel** 或**邻居加权平均**预测未知评分。

```scala
// 构建二分图：用户ID(1~4) + 书籍ID(1001~1003)
val vertices = sc.parallelize(Seq(
  (1L, ("User1")),  (2L, ("User2")),  (3L, ("User3")), (4L, ("User4")),
  (1001L, ("Book1")), (1002L, ("Book2")), (1003L, ("Book3"))
))
val edges = sc.parallelize(Seq(
  Edge(1L, 1001L, 10.0), Edge(1L, 1002L, 8.0),
  Edge(2L, 1001L, 8.0),  Edge(2L, 1003L, 4.0),
  Edge(3L, 1002L, 8.0),  Edge(3L, 1003L, 10.0),
  Edge(4L, 1002L, 8.0),  Edge(4L, 1003L, 6.0)
))
val graph = Graph(vertices, edges, "unknown")
```

> 💡 预测思路：基于 User4 与 User2 都评过 Book2(8 vs 8) 和 Book3(6 vs 4)，计算 User4 与其他用户的相似度，加权预测 Book1 的评分。这是图在推荐系统中的典型应用。

---

### 8.10 综合实例详解 ⭐📝

> 🎯 **老师明确说"8.6 实例分析案例都要看"** — 本章两个综合实例一个用 PageRank，一个用 Pregel API。

#### 实例1：寻找"最有影响力"论文（PageRank 引用分析）

**数据**（`cit-HepTh.txt`）：高能物理理论论文引用网络，27770 节点 + 352807 边，每行 `源ID 目标ID`（新论文引用旧论文）。

**(1) 找出被引用最多的论文**（入度最大）：
```scala
import org.apache.spark.graphx._
val graph = GraphLoader.edgeListFile(sc, "/home/ubuntu/Cit-HepTh.txt")
// ⚠️ edgeListFile：边列表文件加载，顶点属性默认值=1
graph.inDegrees.reduce((a, b) => if (a._2 > b._2) a else b)
// 结果：(9711200, 2414) → ID 9711200 被引 2414 次
```

**(2) PageRank 找出最具影响力论文**：
```scala
graph.vertices.take(5)   // (9405166,1), (108150,1)... 顶点属性默认=1
val v = graph.pageRank(0.001).vertices          // 容忍度 0.001
v.reduce((a, b) => if (a._2 > b._2) a else b)
// 结果：(9207016, 85.27) → ID 9207016 PR值最高
```

**(3) 个性化 PageRank — 谁对某论文影响最大**：
```scala
graph.personalizedPageRank(9207016, 0.001)      // 以 9207016 为目标
  .vertices.filter(_._1 != 9207016)
  .reduce((a, b) => if (a._2 > b._2) a else b)
// 结果：(9201015, 0.0921) → 9201015 对 9207016 最重要
```

#### 实例2：寻找 Twitter"影响力用户"（Pregel BFS 传播）🔥📝

**数据**（`twitter-graph-data.txt`）：每行 `((followee名称,ID),(follower名称,ID))`，逗号+括号分隔需要**手动清洗**。

```
((User47,86566510),(User83,15647839))
((User47,86566510),(User42,197134784))
...
```

**代码详解**（[code8_28.scala](BigData/Spark/code/8-Spark_GraphX/8_28.scala)）：

```scala
// ⚠️ 第一步：数据清洗 — 解析 followee 和 follower 的 (ID, 用户名)
val followeeVertices = twitterData.map(_.split(",")).map { arr =>
  val user = arr(0).replace("((", "")        // 去掉 "(("
  val id = arr(1).replace(")", "")           // 去掉 ")"
  (id.toLong, user)
}
val followerVertices = twitterData.map(_.split(",")).map { arr =>
  val user = arr(2).replace("(", "")
  val id = arr(3).replace("))", "")          // 去掉 "))"
  (id.toLong, user)
}
val vertices = followeeVertices.union(followerVertices) // ⚠️ 合并去重

// ⚠️ 第二步：构建边 — followee → follower
val edges = twitterData.map(_.split(",")).map { arr =>
  Edge(arr(1).replace(")", "").toLong,        // followee ID → srcId
       arr(3).replace("))", "").toLong,       // follower ID → dstId
       "follow")
}
val graph = Graph(vertices, edges, "")

// ⚠️ 第三步：Pregel BFS 传播 — 2 级影响力（followers of followers）
val subGraph = graph.pregel("", 2, EdgeDirection.In)(
  (_, attr, msg) => attr + "," + msg,                   // vprog：拼接粉丝名
  triplet => Iterator((triplet.srcId, triplet.dstAttr)), // sendMsg：沿入边传播
  (a, b) => (a + "," + b)                                // mergeMsg：拼接消息
)

// ⚠️ 第四步：统计唯一粉丝数，找影响力最大用户
val lengthRDD = subGraph.vertices.map(v =>
  (v._1, v._2.split(",").distinct.length - 2))
  .max()(new Ordering[Tuple2[VertexId, Int]]() {
    override def compare(x: (VertexId, Int), y: (VertexId, Int)) =
      Ordering[Int].compare(x._2, y._2)
  })
// 结果：User36 has maximum influence on network with 95 influencers.
```
> 💡 **Pregel 三要素复习**：`vprog` 顶点收到消息怎么更新 / `sendMsg` 更新完发什么给邻居 / `mergeMsg` 多条消息怎么合并。`EdgeDirection.In` 表示沿**入边**方向传播。

---

## 第九章 Spark机器学习原理

> ⭐⭐⭐⭐⭐ **"百分之百会考！"** — ML完整流程代码要会写

### 9.1 spark.ml vs spark.mllib ⭐

| 特性 | spark.ml（主推） | spark.mllib（维护） |
|------|:---:|:---:|
| API级别 | 高级（DataFrame） | 低级（RDD） |
| Pipeline | ✅ 支持 | ❌ 不支持 |
| 状态 | 持续更新 | 2.0后进入维护 |

### 9.2 ML Pipeline核心概念 ⭐🔥

| 概念 | 方法 | 说明 |
|------|------|------|
| **DataFrame** | — | ML数据格式，支持多列 |
| **Transformer** | `transform()` | DataFrame → DataFrame（如Tokenizer、模型本身） |
| **Estimator** | `fit()` | DataFrame → Transformer（如LogisticRegression、KMeans） |
| **Pipeline** | `fit()` | 串联多个stage的工作流 |
| **Parameter** | setter/ParamMap | 参数设置有两种方式 |

### 9.3 Estimator vs Transformer ⭐🔥📝

来自 [code9_1.scala](BigData/Spark/code/9-Spark机器学习原理/code/code9_1.scala)：

```scala
// ⚠️ LogisticRegression是Estimator
val lr = new LogisticRegression()

// ⚠️ 参数设置的两种方式
// 方式1：setter方法
lr.setMaxIter(10).setRegParam(0.01)

// 方式2：ParamMap
val paramMap = ParamMap(lr.maxIter -> 20)
  .put(lr.regParam -> 0.1, lr.threshold -> 0.55)

// ⚠️ Estimator.fit() → 生成Transformer（模型）
val model1 = lr.fit(training)           // 方式1
val model2 = lr.fit(training, paramMapCombined)  // 方式2

// ⚠️ Transformer.transform() → 生成带预测列的DataFrame
model2.transform(test)
  .select("features", "label", "myProbability", "prediction")
  .collect()
  .foreach { case Row(features: Vector, label: Double,
                       prob: Vector, prediction: Double) =>
    println(s"($features, $label) -> prob=$prob, prediction=$prediction")
  }
```

### 9.4 Pipeline完整示例 ⭐🔥📝

来自 [code9_2.scala](BigData/Spark/code/9-Spark机器学习原理/code/code9_2.scala)：

```scala
import org.apache.spark.ml.{Pipeline, PipelineModel}
import org.apache.spark.ml.classification.LogisticRegression
import org.apache.spark.ml.feature.{HashingTF, Tokenizer}

// ⚠️ 创建训练数据：(id, text, label)
val training = spark.createDataFrame(Seq(
  (0L, "a b c d e spark", 1.0),
  (1L, "b d", 0.0),
  (2L, "spark f g h", 1.0),
  (3L, "hadoop mapreduce", 0.0)
)).toDF("id", "text", "label")

// ⚠️ Stage 1: Tokenizer（Transformer）
val tokenizer = new Tokenizer()
  .setInputCol("text")
  .setOutputCol("words")

// ⚠️ Stage 2: HashingTF（Transformer）
val hashingTF = new HashingTF()
  .setNumFeatures(1000)
  .setInputCol(tokenizer.getOutputCol)
  .setOutputCol("features")

// ⚠️ Stage 3: LogisticRegression（Estimator）
val lr = new LogisticRegression()
  .setMaxIter(10)
  .setRegParam(0.001)

// ⚠️ 组装Pipeline
val pipeline = new Pipeline()
  .setStages(Array(tokenizer, hashingTF, lr))

// ⚠️ Pipeline.fit() → PipelineModel
val model = pipeline.fit(training)

// ⚠️ 保存和加载
model.write.overwrite().save("/tmp/spark-logistic-regression-model")
val sameModel = PipelineModel.load("/tmp/spark-logistic-regression-model")

// ⚠️ 预测
model.transform(test)
  .select("id", "text", "probability", "prediction")
  .collect()
  .foreach { case Row(id: Long, text: String, prob: Vector, prediction: Double) =>
    println(s"($id, $text) --> prob=$prob, prediction=$prediction")
  }
```

**Pipeline执行流程**：
```
训练阶段：
  原始DataFrame → Tokenizer.transform() → HashingTF.transform()
    → LogisticRegression.fit() → PipelineModel

测试阶段：
  测试DataFrame → PipelineModel.transform() → 带prediction列的DataFrame
```

### 9.5 特征工程速查 ⭐

#### TF-IDF（[code9_3.scala](BigData/Spark/code/9-Spark机器学习原理/code/code9_3.scala)）

```scala
val tokenizer = new Tokenizer().setInputCol("sentence").setOutputCol("words")
val hashingTF = new HashingTF()
  .setInputCol("words").setOutputCol("rawFeatures").setNumFeatures(20)
val idf = new IDF().setInputCol("rawFeatures").setOutputCol("features")

val wordsData = tokenizer.transform(sentenceData)
val featurizedData = hashingTF.transform(wordsData)
val idfModel = idf.fit(featurizedData)        // ⚠️ IDF是Estimator
val rescaledData = idfModel.transform(featurizedData)
```

#### VectorSlicer（[code9_7.scala](BigData/Spark/code/9-Spark机器学习原理/code/code9_7.scala)）⚠️

```scala
import org.apache.spark.ml.feature.VectorSlicer
import org.apache.spark.ml.linalg.Vectors

// ⚠️ 创建稠密向量和稀疏向量
val data = Arrays.asList(
  Row(Vectors.sparse(3, Seq((0, -2.0), (1, 2.3)))),    // 稀疏向量：(大小, Seq((索引,值),...))
  Row(Vectors.dense(-2.0, 2.3, 0.0))                   // 稠密向量：(值数组)
)

// ⚠️ VectorSlicer：通过索引或名称提取子集
val slicer = new VectorSlicer()
  .setInputCol("userFeatures")
  .setOutputCol("features")

slicer.setIndices(Array(1))          // ⚠️ 整数索引方式：取索引1的元素（从0开始）
     .setNames(Array("f3"))          // ⚠️ 字符串名称方式：取名为"f3"的元素

val output = slicer.transform(dataset)
```

> ⚠️ **关键点**：`VectorSlicer` 是 Transformer（直接调用 `transform`），支持两种指定方式——整数索引或列名字符串。向量分稠密向量 `Vectors.dense(...)` 和稀疏向量 `Vectors.sparse(size, Seq((idx,val),...))`。

#### Word2Vec（[code9_4.scala](BigData/Spark/code/9-Spark机器学习原理/code/code9_4.scala)）

```scala
val word2Vec = new Word2Vec()
  .setInputCol("text")
  .setOutputCol("result")
  .setVectorSize(3)          // 向量维度
  .setMinCount(0)            // 最小词频

val model = word2Vec.fit(documentDF)  // ⚠️ Word2Vec是Estimator
val result = model.transform(documentDF)
```

#### 常用特征转换器

| 转换器 | 功能 | 关键参数 |
|--------|------|----------|
| **Binarizer** | 连续值→二值 | `threshold`（阈值） |
| **MinMaxScaler** | 归一化到[min, max] | `min`(默认0), `max`(默认1) |
| **StandardScaler** | 标准化（均值0方差1） | `withStd`, `withMean` |
| **VectorSlicer** | 从向量中提取指定特征子集 | `indices`(整数索引), `names`(字符串名称) |
| **StringIndexer** | 字符串→数值索引 | `inputCol`, `outputCol` |
| **VectorAssembler** | 多列合并为向量 | `inputCols`, `outputCol` |
| **RFormula** | R风格公式 | `formula` |
| **ChiSqSelector** | 卡方特征选择 | `numTopFeatures` |

### 9.6 模型选择与调参 ⭐🔥

#### 交叉验证（[code9_10.scala](BigData/Spark/code/9-Spark机器学习原理/code/code9_10.scala)）⚠️

```scala
import org.apache.spark.ml.tuning.{CrossValidator, ParamGridBuilder}

// ⚠️ 参数网格
val paramGrid = new ParamGridBuilder()
  .addGrid(hashingTF.numFeatures, Array(10, 100, 1000))  // 3种取值
  .addGrid(lr.regParam, Array(0.1, 0.01))                // 2种取值
  .build()  // 共3×2=6种组合

// ⚠️ 交叉验证
val cv = new CrossValidator()
  .setEstimator(pipeline)
  .setEvaluator(new BinaryClassificationEvaluator)   // 默认评估指标AUC
  .setEstimatorParamMaps(paramGrid)
  .setNumFolds(2)          // 2折交叉验证
  .setParallelism(2)       // 并行评估2组参数

val cvModel = cv.fit(training)  // 训练，自动选最优参数

// ⚠️ 获取最优模型参数
val bestModel = cvModel.bestModel.asInstanceOf[PipelineModel]
val lrModel = bestModel.stages(2).asInstanceOf[LogisticRegressionModel]
println(lrModel.getRegParam)
```

#### 训练-验证拆分（[code9_11.scala](BigData/Spark/code/9-Spark机器学习原理/code/code9_11.scala)）

```scala
val trainValidationSplit = new TrainValidationSplit()
  .setEstimator(lr)
  .setEvaluator(new RegressionEvaluator)
  .setEstimatorParamMaps(paramGrid)
  .setTrainRatio(0.8)      // ⚠️ 80%训练，20%验证
  .setParallelism(2)

val model = trainValidationSplit.fit(training)
```

| 方法 | 优点 | 缺点 |
|------|------|------|
| **CrossValidator** | 结果可靠 | 计算慢（K倍时间） |
| **TrainValidationSplit** | 计算快 | 结果依赖单次拆分 |

---


### 📝 第九章课后习题

#### Q1：阐述 Spark 在机器学习方面的优势 🔥
**答：** Spark 的核心优势源于**内存计算 + DAG 调度**：
1. **高速迭代**：ML 算法通常需要大量迭代（如梯度下降），Spark 将中间结果缓存在内存中，避免 Hadoop MapReduce 的反复磁盘读写，性能提升 **10~100 倍**
2. **DAG 优化**：DAG 调度器可优化任务依赖关系，合并操作、减少不必要的 Shuffle
3. **丰富的 MLlib 库**：内置分类/回归/聚类/协同过滤/特征工程等全套算法
4. **Pipeline API**：提供 Transformer + Estimator + Pipeline 的统一高级 API，构建 ML 流程直观便捷
5. **分布式数据处理**：原生支持海量数据的分布式训练，单机无法处理的数据也能高效建模

#### Q2：spark.ml 和 spark.mllib 的区别与联系 🔥
| 维度 | spark.ml（主推） | spark.mllib（维护） |
|:----|:----|:----|
| **API 级别** | **高级 API**（基于 DataFrame） | 低级 API（基于 RDD） |
| **Pipeline** | ✅ 支持 | ❌ 不支持 |
| **状态** | 持续更新，官方推荐 | Spark 2.0 后仅修复 Bug |
| **抽象层级** | Transformer/Estimator 统一抽象 | 各算法独立 API |
| **联系** | 都是 MLlib 库的组成部分，部分技术（如降维）可跨 API 混用 |

#### Q3：简述 Pipeline 的原理
**答：** Pipeline 将多个 **Transformer** 和 **Estimator** 按顺序串成一条**机器学习工作流**。
- **训练阶段**：数据（DataFrame）按阶段顺序流过 → 遇 Transformer 调 `transform()` → 遇 Estimator 调 `fit()` 生成模型（也是一个 Transformer）→ 最终输出 **PipelineModel**
- **预测阶段**：新数据 → `PipelineModel.transform()` → 直接得到带预测列的结果

#### Q4：简述 Transformer 和 Estimator 的区别与联系 🔥
| 角色 | 核心方法 | 输入 → 输出 | 像什么 |
|:----|:------|:-----------|:------|
| **Transformer** | `transform()` | DataFrame → DataFrame | **榨汁机**：苹果进苹果汁出 |
| **Estimator** | `fit()` | DataFrame → Transformer | **厨师**：学完菜谱变成"会做菜的厨师" |
| **联系** | Estimator 的 `fit()` 训练后**产生一个 Transformer**（即模型），两者都是 Pipeline 的 Stage |

#### Q5：保存到本地且未训练的 Pipeline 如何调用？🔥
以代码 9-2 为例（`Pipeline_Example.scala`）：
```scala
// ① 保存未训练的 Pipeline（Estimator）
pipeline.write.overwrite().save("/tmp/unfit-lr-model")

// ② 从本地加载该 Pipeline
val loadedPipeline = Pipeline.load("/tmp/unfit-lr-model")

// ③ 调用 fit() 训练
val pipelineModel = loadedPipeline.fit(trainingData)

// ④ 用训练好的模型预测
pipelineModel.transform(testData).select("prediction").show()
```
> 💡 源码：`code9_2.scala:47` — `pipeline.write.overwrite().save(...)` 保存未训练 Pipeline。

#### Q6：使用 MaxAbsScaler 处理代码 9-6 中的 DataFrame 🔥📝
`MaxAbsScaler`：每个特征除以最大绝对值，**缩放到 [-1, 1]** 范围。
```scala
import org.apache.spark.ml.feature.MaxAbsScaler
import org.apache.spark.ml.linalg.Vectors

// 代码 9-6 中的 DataFrame（MinMaxScalerExample 的数据）
val dataFrame = spark.createDataFrame(Seq(
  (0, Vectors.dense(1.0, 0.1, -1.0)),
  (1, Vectors.dense(2.0, 1.1, 1.0)),
  (2, Vectors.dense(3.0, 10.1, 3.0))
)).toDF("id", "features")

val scaler = new MaxAbsScaler()
  .setInputCol("features")
  .setOutputCol("scaledFeatures")

val scalerModel = scaler.fit(dataFrame)          // ⚠️ MaxAbsScaler 是 Estimator
val scaledData = scalerModel.transform(dataFrame) // 调用 fit 后用 transform
scaledData.select("features", "scaledFeatures").show(false)
```
> ⚠️ 对比：`MinMaxScaler` 缩放到 [0,1]；`MaxAbsScaler` 缩放到 [-1,1]。注意区分。

#### Q7：使用 StringIndexer + IndexToString 完成字符串索引与还原 🔥📝
```scala
import org.apache.spark.ml.feature.{StringIndexer, IndexToString}

val df = spark.createDataFrame(Seq(
  (0, "cat"), (1, "dog"), (2, "cat"), (3, "mouse"), (4, "dog")
)).toDF("id", "category")

// ① 字符串 → 数值索引（按频率排序，最高频→0）
val indexer = new StringIndexer()
  .setInputCol("category").setOutputCol("categoryIndex")
val indexerModel = indexer.fit(df)
val indexedDF = indexerModel.transform(df)
// cat→0, dog→1, mouse→2

// ② 数值索引 → 原始字符串（⚠️ 必须传入 labelsArray）
val converter = new IndexToString()
  .setInputCol("categoryIndex")
  .setOutputCol("originalCategory")
  .setLabels(indexerModel.labelsArray(0))        // ⚠️ 关键：传入标签映射表
val restoredDF = converter.transform(indexedDF)
// categoryIndex 列被还原为原始的 "cat"/"dog"/"mouse"
```

#### Q8：使用 TrainValidationSplit 找代码 9-1 中最佳参数 🔥
```scala
import org.apache.spark.ml.tuning.{TrainValidationSplit, ParamGridBuilder}

// 假设代码 9-1 中已有 lr（LogisticRegression）和 trainingData
val paramGrid = new ParamGridBuilder()
  .addGrid(lr.maxIter, Array(10, 20))             // 2 种迭代次数
  .addGrid(lr.regParam, Array(0.1, 0.01))         // 2 种正则化参数
  .build()                                         // 共 2×2 = 4 种组合

val tvs = new TrainValidationSplit()
  .setEstimator(lr)
  .setEvaluator(new MulticlassClassificationEvaluator())
  .setEstimatorParamMaps(paramGrid)
  .setTrainRatio(0.8)                              // ⚠️ 80% 训练，20% 验证

val tvsModel = tvs.fit(trainingData)               // 训练并自动选最优参数
val bestModel = tvsModel.bestModel                 // 获取最优模型
```

---

### 📝 第十章课后习题

#### Q1：spark.ml 提供了哪些机器学习模型？
| 类别 | 包含算法 |
|:----|:--------|
| **分类** | 逻辑回归、决策树、随机森林、梯度提升树（GBT）、朴素贝叶斯、MLP、SVM |
| **回归** | 线性回归、广义线性回归、决策树回归、随机森林回归、GBT 回归、保序回归 |
| **聚类** | K-Means、二分 K-Means、高斯混合模型（GMM）、LDA |
| **协同过滤** | ALS（交替最小二乘法） |
| **频繁模式** | FP-Growth、PrefixSpan |
| **特征工程** | MaxAbsScaler、MinMaxScaler、Word2Vec、PCA、OneHotEncoder、StringIndexer、VectorAssembler 等 |

#### Q2：分类与回归的区别？分类与聚类的区别？🔥
| 对比维度 | 分类 | 回归 | 聚类 |
|:----|:----|:----|:----|
| **学习类型** | 监督学习 | 监督学习 | **无监督学习** |
| **标签类型** | **离散**（买/不买） | **连续**（房价/温度） | 无标签，自动分簇 |
| **目标** | 预测类别 | 预测数值 | 按相似度自然分组 |
| **评估指标** | Accuracy、AUC | RMSE、R² | Silhouette（轮廓系数） |

#### Q3：回归树与分类树的区别？🔥
| 维度 | 分类树 | 回归树 |
|:----|:------|:------|
| **目标变量** | 离散型（类别） | 连续型（数值） |
| **分裂标准** | 信息增益、基尼系数、熵 | **均方误差（MSE）**、绝对误差 |
| **节点输出** | 出现次数最多的类别 | 样本目标变量的**平均值** |
| **预测方式** | 投票决定 | 取叶子节点均值 |
> 💡 源码：`code10_3.scala`（决策树分类，含 StringIndexer Pipeline）、`code10_4.scala`（决策树回归，直接用 RegressionEvaluator 评估 RMSE）。

#### Q4：使用 spark.ml 线性回归预测房价 🔥📝
**特征**：总面积、房间数、是否近地铁、位于哪个区 → 注意"区"是分类变量需 `OneHotEncoder`。

```scala
import org.apache.spark.ml.feature.{StringIndexer, OneHotEncoder, VectorAssembler}
import org.apache.spark.ml.regression.LinearRegression
import org.apache.spark.ml.evaluation.RegressionEvaluator
import org.apache.spark.ml.Pipeline

// 1. 加载数据（假设 CSV：totalArea, rooms, nearSubway, district, price）
val df = spark.read.option("header","true").option("inferSchema","true")
  .csv("house_data.csv")

// 2. 对 district 列 → 索引 + 独热编码
val indexer = new StringIndexer()
  .setInputCol("district").setOutputCol("districtIndex")
val encoder = new OneHotEncoder()
  .setInputCol("districtIndex").setOutputCol("districtVec")

// 3. 组装特征向量
val assembler = new VectorAssembler()
  .setInputCols(Array("totalArea", "rooms", "nearSubway", "districtVec"))
  .setOutputCol("features")

// 4. Pipeline + 拆分训练/测试
val pipeline = new Pipeline().setStages(Array(indexer, encoder, assembler))
val data = pipeline.fit(df).transform(df)
val Array(train, test) = data.randomSplit(Array(0.8, 0.2), seed = 42)

// 5. 训练线性回归
val lr = new LinearRegression()
  .setLabelCol("price").setFeaturesCol("features")
  .setRegParam(0.1).setElasticNetParam(0.8)       // 弹性网络混合
val lrModel = lr.fit(train)

// 6. 评估
val predictions = lrModel.transform(test)
val rmse = new RegressionEvaluator()
  .setLabelCol("price").setMetricName("rmse").evaluate(predictions)
println(s"RMSE = $rmse")
```
> 💡 源码：`code10_2.scala`（线性回归 + 弹性网络参数）。

#### Q5：使用 spark.ml 决策树分类器构造决策树（带样本权重）🔥⚠️
完整 14 行数据表（含"计数"作为样本权重 `weightCol`）：

| 计数 | 年龄 | 收入 | 学生 | 信誉 | 购买 |
|:---:|:---:|:---:|:---:|:---:|:---:|
| 64 | 青年 | 高 | 否 | 良 | 否 |
| 64 | 青年 | 高 | 否 | 优 | 否 |
| 128 | 中年 | 高 | 否 | 良 | 买 |
| 60 | 老年 | 中 | 否 | 良 | 买 |
| 64 | 老年 | 低 | 是 | 良 | 买 |
| 64 | 老年 | 低 | 是 | 优 | 否 |
| 64 | 中年 | 低 | 是 | 优 | 买 |
| 128 | 青年 | 中 | 否 | 良 | 否 |
| 64 | 青年 | 低 | 是 | 良 | 买 |
| 132 | 老年 | 中 | 是 | 良 | 买 |
| 64 | 青年 | 中 | 是 | 优 | 买 |
| 32 | 中年 | 中 | 否 | 优 | 买 |
| 32 | 中年 | 高 | 是 | 良 | 买 |
| 64 | 老年 | 中 | 否 | 优 | 否 |

```scala
val data = Seq(
  ("青年","高","否","良","否",64), ("青年","高","否","优","否",64),
  ("中年","高","否","良","买",128), ("老年","中","否","良","买",60),
  ("老年","低","是","良","买",64), ("老年","低","是","优","否",64),
  ("中年","低","是","优","买",64), ("青年","中","否","良","否",128),
  ("青年","低","是","良","买",64), ("老年","中","是","良","买",132),
  ("青年","中","是","优","买",64), ("中年","中","否","优","买",32),
  ("中年","高","是","良","买",32), ("老年","中","否","优","否",64)
).toDF("age","income","student","credit","buy","count")

// StringIndexer 处理所有字符串列
val featureCols = Array("age", "income", "student", "credit")
val indexers = featureCols.map(col =>
  new StringIndexer().setInputCol(col).setOutputCol(s"${col}_idx"))
val labelIndexer = new StringIndexer().setInputCol("buy").setOutputCol("label")

val assembler = new VectorAssembler()
  .setInputCols(Array("age_idx","income_idx","student_idx","credit_idx"))
  .setOutputCol("features")

val dt = new DecisionTreeClassifier()
  .setLabelCol("label").setFeaturesCol("features")
  .setWeightCol("count")              // ⚠️ 关键：计数列作为样本权重！
  .setImpurity("gini").setMaxDepth(5)

val pipeline = new Pipeline()
  .setStages(indexers ++ Array(labelIndexer, assembler, dt))
val model = pipeline.fit(data)
val treeModel = model.stages.last
  .asInstanceOf[org.apache.spark.ml.classification.DecisionTreeClassificationModel]
println(treeModel.toDebugString)       // 打印决策树结构
```
> 💡 源码：`code10_3.scala`。`setWeightCol("count")` 是本题核心考点。

#### Q6：使用 spark.ml 中 K-Means 划分数据点（k=2）🔥📝

| 点 | X | Y | | 点 | X | Y |
|:--|:--|:--|---|:--|:--|:--|
| P1 | 0 | 0 | | P4 | 8 | 8 |
| P2 | 1 | 2 | | P5 | 9 | 10 |
| P3 | 3 | 1 | | P6 | 10 | 7 |

```scala
import org.apache.spark.ml.clustering.KMeans
import org.apache.spark.ml.linalg.Vectors

val data = Seq(
  Vectors.dense(0.0, 0.0), Vectors.dense(1.0, 2.0), Vectors.dense(3.0, 1.0),
  Vectors.dense(8.0, 8.0), Vectors.dense(9.0, 10.0), Vectors.dense(10.0, 7.0)
).map(Tuple1.apply).toDF("features")

val kmeans = new KMeans().setK(2).setSeed(1L)
val model = kmeans.fit(data)
model.transform(data).show(false)

// 肉眼预判：左下三点(0,0)(1,2)(3,1)→一类，右上三点(8,8)(9,10)(10,7)→另一类
// 输出：
// +--------------+----------+
// |features      |prediction|
// +--------------+----------+
// |[0.0,0.0]     |0         |
// |[1.0,2.0]     |0         |
// |[3.0,1.0]     |0         |
// |[8.0,8.0]     |1         |
// |[9.0,10.0]    |1         |
// |[10.0,7.0]    |1         |
// +--------------+----------+
```
> 💡 源码：`code10_5.scala`。`setSeed(1L)` 固定随机种子保证结果可复现。

#### Q7：使用 spark.ml 中 FP-Growth 找出频繁项集（min_sup=60%）🔥📝
5 笔交易，60% 支持度 → 最小支持次数 = 5 × 0.6 = **3.0**

| TID | 购买商品 | 去重后 |
|:---|:--------|:------|
| T100 | M,O,N,K,E,Y | M,O,N,K,E,Y |
| T200 | D,O,N,K,E,Y | D,O,N,K,E,Y |
| T300 | M,A,K,E | M,A,K,E |
| T400 | M,U,C,K,Y | M,U,C,K,Y |
| T500 | C,O,O,K,E | C,O,K,E |

```scala
import org.apache.spark.ml.fpm.FPGrowth
import org.apache.spark.sql.functions.split

val transactions = Seq(
  "M O N K E Y", "D O N K E Y", "M A K E",
  "M U C K Y", "C O K E"        // T500 去重后为 C,O,K,E
).map(Tuple1.apply).toDF("items")

val df = transactions.withColumn("items", split($"items", " "))

val fpGrowth = new FPGrowth()
  .setItemsCol("items")
  .setMinSupport(0.6)
  .setMinConfidence(0.0)        // 只关心频繁项集，不关心置信度

val model = fpGrowth.fit(df)
model.freqItemsets.show(false)

// 输出频繁项集：
// [K] freq=5, [E] freq=4, [K,E] freq=4, [M] freq=3, [O] freq=3,
// [Y] freq=3, [K,M] freq=3, [K,O] freq=3, [K,Y] freq=3,
// [E,O] freq=3, [K,E,O] freq=3
```
> 💡 源码：`code10_6.scala`。注意 T500 中 `C,O,O,O,K,,E` 去重后为 `C,O,K,E`，空字符串需处理。

---

## 第十章 Spark机器学习模型

> ⭐⭐⭐⭐⭐ 需要真正用代码实现ML算法！

### 10.1 朴素贝叶斯分类 ⭐🔥📝

来自 [code10_1.scala](BigData/Spark/code/10-Spark机器学习模型/code/code10_1.scala)：

```scala
import org.apache.spark.ml.classification.NaiveBayes
import org.apache.spark.ml.evaluation.MulticlassClassificationEvaluator

// ⚠️ libsvm格式加载数据
val data = spark.read.format("libsvm").load("data/sample_libsvm_data.txt")

// ⚠️ 划分训练集和测试集（7:3）
val Array(trainingData, testData) = data.randomSplit(Array(0.7, 0.3), seed = 1234L)

// ⚠️ 训练模型
val model = new NaiveBayes().fit(trainingData)

// ⚠️ 预测
val predictions = model.transform(testData)

// ⚠️ 评估 — MulticlassClassificationEvaluator
val evaluator = new MulticlassClassificationEvaluator()
  .setLabelCol("label")
  .setPredictionCol("prediction")
  .setMetricName("accuracy")       // 准确率

val accuracy = evaluator.evaluate(predictions)
println(s"Test set accuracy = $accuracy")
```

**朴素贝叶斯公式**：$P(A|B) = \frac{P(B|A) \cdot P(A)}{P(B)}$

**两个假设**：特征之间条件独立；特征分布假设

### 10.2 线性回归 ⭐📝

来自 [code10_2.scala](BigData/Spark/code/10-Spark机器学习模型/code/code10_2.scala)：

```scala
import org.apache.spark.ml.regression.LinearRegression

val training = spark.read.format("libsvm")
  .load("data/sample_linear_regression_data.txt")

// ⚠️ 弹性网络参数
val lr = new LinearRegression()
  .setMaxIter(10)            // 最大迭代次数
  .setRegParam(0.3)          // 正则化参数
  .setElasticNetParam(0.8)   // 弹性网络参数：0=纯L2(Ridge), 1=纯L1(Lasso)

val lrModel = lr.fit(training)

// ⚠️ 模型摘要 — 额外的评估信息
val trainingSummary = lrModel.summary
println(s"numIterations: ${trainingSummary.totalIterations}")          // 迭代次数
println(s"objectiveHistory: [${trainingSummary.objectiveHistory.mkString(",")}]")  // 每次迭代目标值
println(s"RMSE: ${trainingSummary.rootMeanSquaredError}")
println(s"r2: ${trainingSummary.r2}")
trainingSummary.residuals.show()   // ⚠️ 残差：(label - predicted)
```

**Elastic Net参数**：
- `0`：纯L2正则化（Ridge回归）
- `1`：纯L1正则化（Lasso回归）
- `0~1`：L1/L2混合

### 10.3 决策树分类 ⭐📝

来自 [code10_3.scala](BigData/Spark/code/10-Spark机器学习模型/code/code10_3.scala)：

```scala
import org.apache.spark.ml.classification.DecisionTreeClassifier
import org.apache.spark.ml.feature.{StringIndexer, VectorIndexer, IndexToString}

// ⚠️ 决策树分类的完整Pipeline
// 1. StringIndexer：标签字符串→数值
val labelIndexer = new StringIndexer()
  .setInputCol("label")
  .setOutputCol("indexedLabel")
  .fit(data)

// 2. VectorIndexer：自动识别分类特征
val featureIndexer = new VectorIndexer()
  .setInputCol("features")
  .setOutputCol("indexedFeatures")
  .setMaxCategories(4)     // ⚠️ 超过4个不同值的特征视为连续
  .fit(data)

// 3. DecisionTreeClassifier
val dt = new DecisionTreeClassifier()
  .setLabelCol("indexedLabel")
  .setFeaturesCol("indexedFeatures")

// 4. IndexToString：预测数值→原始标签
val labelConverter = new IndexToString()
  .setInputCol("prediction")
  .setOutputCol("predictedLabel")
  .setLabels(labelIndexer.labels)

// ⚠️ Pipeline组装
val pipeline = new Pipeline()
  .setStages(Array(labelIndexer, featureIndexer, dt, labelConverter))

val model = pipeline.fit(trainingData)
val predictions = model.transform(testData)

// 打印决策树
val treeModel = model.stages(2).asInstanceOf[DecisionTreeClassificationModel]
println(treeModel.toDebugString)
```

### 10.4 决策树回归 ⭐📝

来自 [code10_4.scala](BigData/Spark/code/10-Spark机器学习模型/code/code10_4.scala)：

```scala
import org.apache.spark.ml.Pipeline
import org.apache.spark.ml.evaluation.RegressionEvaluator
import org.apache.spark.ml.feature.VectorIndexer
import org.apache.spark.ml.regression.{DecisionTreeRegressionModel, DecisionTreeRegressor}

val data = spark.read.format("libsvm").load("data/mllib/sample_libsvm_data.txt")

// ⚠️ VectorIndexer：自动识别分类特征
val featureIndexer = new VectorIndexer()
  .setInputCol("features")
  .setOutputCol("indexedFeatures")
  .setMaxCategories(4)     // ⚠️ 超过4个不同值的特征视为连续
  .fit(data)

// ⚠️ 划分训练/测试集
val Array(trainingData, testData) = data.randomSplit(Array(0.7, 0.3))

// ⚠️ DecisionTreeRegressor（与分类器的关键区别）
val dt = new DecisionTreeRegressor()
  .setLabelCol("label")
  .setFeaturesCol("indexedFeatures")

// ⚠️ Pipeline组装
val pipeline = new Pipeline().setStages(Array(featureIndexer, dt))
val model = pipeline.fit(trainingData)

// ⚠️ 评估 — RegressionEvaluator（RMSE指标）
val predictions = model.transform(testData)
val evaluator = new RegressionEvaluator()
  .setLabelCol("label").setPredictionCol("prediction").setMetricName("rmse")
val rmse = evaluator.evaluate(predictions)
println(s"Root Mean Squared Error (RMSE) on test data = $rmse")

// ⚠️ 获取回归树模型并打印
val treeModel = model.stages(1).asInstanceOf[DecisionTreeRegressionModel]
println(s"Learned regression tree model:\n ${treeModel.toDebugString}")
```

> ⚠️ **决策树分类 vs 回归对比**：
> - 分类用 `DecisionTreeClassifier` + `MulticlassClassificationEvaluator`(accuracy)
> - 回归用 `DecisionTreeRegressor` + `RegressionEvaluator`(rmse)
> - 分类Pipeline含 `StringIndexer` + `IndexToString`；回归Pipeline不需要这两步

### 10.5 K-Means聚类 ⭐🔥📝

来自 [code10_5.scala](BigData/Spark/code/10-Spark机器学习模型/code/code10_5.scala)：

```scala
import org.apache.spark.ml.clustering.KMeans
import org.apache.spark.ml.evaluation.ClusteringEvaluator

// ⚠️ 加载数据
val dataset = spark.read.format("libsvm").load("data/sample_kmeans_data.txt")

// ⚠️ 训练K-Means
val kmeans = new KMeans().setK(2)      // 设置K=2
val model = kmeans.fit(dataset)

// ⚠️ 预测
val predictions = model.transform(dataset)

// ⚠️ 评估 — 轮廓系数（Silhouette Coefficient）
val evaluator = new ClusteringEvaluator()
val silhouette = evaluator.evaluate(predictions)  // 范围[-1,1]，越接近1越好
println(s"Silhouette with squared euclidean distance = $silhouette")

// ⚠️ 输出聚类中心
println("Cluster Centers: ")
model.clusterCenters.foreach(println)
```

**K-Means算法流程**：
1. 随机选K个初始中心点
2. 各点分配到最近的中心
3. 重新计算各簇中心
4. 重复2-3直到收敛

### 10.6 FP-Growth频繁模式挖掘 ⭐

来自 [code10_6.scala](BigData/Spark/code/10-Spark机器学习模型/code/code10_6.scala)：

```scala
import org.apache.spark.ml.fpm.FPGrowth

// ⚠️ 数据格式：每行一个购物篮
val dataset = spark.createDataset(Seq(
  "I1 I2 I5",
  "I2 I4",
  "I3 I4 I5",
  "I1 I2 I4 I5",
  "I4 I5"
)).map(t => t.split(" ")).toDF("items")

// ⚠️ 创建FPGrowth
val fpgrowth = new FPGrowth()
  .setItemsCol("items")
  .setMinSupport(0.4)         // 最小支持度
  .setMinConfidence(0.6)      // 最小置信度

val model = fpgrowth.fit(dataset)

// ⚠️ 输出结果
model.freqItemsets.show()        // 频繁项集
model.associationRules.show()    // 关联规则
model.transform(dataset).show()  // 对原始数据的预测
```

### 10.7 评估指标总结 ⭐🔥

| 任务 | 评估器 | 常用指标 |
|------|--------|----------|
| 二分类 | `BinaryClassificationEvaluator` | AUC-ROC (默认) |
| 多分类 | `MulticlassClassificationEvaluator` | accuracy, f1 |
| 回归 | `RegressionEvaluator` | RMSE, R², MAE |
| 聚类 | `ClusteringEvaluator` | silhouette (轮廓系数) |

---

## 附录：考试技巧与速查表

### A. 时间分配建议

| 题型 | 建议时间 | 策略 |
|------|:------:|------|
| 填空题 | 10分钟 | 快速定位课本页码 |
| 选择题 | 20分钟 | 多选题不确定不随意猜 |
| 简答题 | 20分钟 | 按要点写，尽量写 |
| 代码补全 | 30分钟 | 查操作表，注意链式调用 |
| 代码写作 | 40分钟 | 先写框架，再补细节 |

### B. 代码补全题高频操作链

**RDD链**：
```scala
sc.textFile(path).flatMap(_.split(" ")).map((_, 1)).reduceByKey(_ + _).collect()
```

**DataFrame链**：
```scala
spark.read.json(path).select("col1", "col2").filter($"age" > 20).groupBy("country").count().show()
```

**ML Pipeline链**：
```scala
new Pipeline().setStages(Array(tokenizer, hashingTF, lr)).fit(training).transform(test)
```

### C. 常用API速查 🔥

**RDD Transformation**：`map` `flatMap` `filter` `reduceByKey` `groupByKey` `join` `sortByKey` `union` `distinct` `mapValues` `coalesce` `repartition`

**RDD Action**：`collect` `count` `first` `take` `reduce` `foreach` `saveAsTextFile` `countByKey`

**DataFrame**：`show` `printSchema` `select` `filter` `where` `groupBy` `orderBy` `join` `distinct` `withColumn` `drop` `createOrReplaceTempView`

**ML特征**：`Tokenizer` `HashingTF` `IDF` `Word2Vec` `Binarizer` `MinMaxScaler` `StandardScaler` `StringIndexer` `VectorAssembler` `ChiSqSelector` `RFormula`

**ML算法**：`LogisticRegression` `NaiveBayes` `DecisionTreeClassifier` `LinearRegression` `DecisionTreeRegressor` `KMeans` `FPGrowth`

**ML工具**：`Pipeline` `CrossValidator` `TrainValidationSplit` `ParamGridBuilder`

### D. 关键易错点汇总 ⚠️

1. **Scala**：`if-else`是表达式有返回值；`match`的`_`是通配符；辅助构造函数首行必须`this()`；重写非抽象方法必须`override`
2. **RDD**：Transformation是懒执行；`reduceByKey`优于`groupByKey`；宽依赖产生Shuffle
3. **DataFrame**：需要`import spark.implicits._`；`===`不是`==`；Case Class方式与StructType方式两种创建
4. **Streaming**：`local[2]`至少2个线程；窗口操作需checkpoint；`updateStateByKey`返回`Some()`
5. **GraphX**：顶点ID是`Long`类型；`aggregateMessages`替代旧API；点分割减少通信
6. **ML**：Estimator有`fit()`返回Transformer；Transformer有`transform()`返回DataFrame；Pipeline将多个stage串联

---

> 📌 最后更新：2026年6月17日 | 整合课堂录音+全部10章源码
>
> ⚠️ 本文档基于老师课堂复习录音和课本源码整理，仅代表"高概率"考察方向。请以课本为核心全面复习！
>
> 🤖 整理协助：Claude Code | Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>
