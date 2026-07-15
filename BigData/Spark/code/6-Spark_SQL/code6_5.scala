//引用spark.implicits._用于将RDD隐式转换为DataFrame

scala>import spark.implicits._

// 创建一个的DataFrame，存储到一个分区目录（data/test_table/key=1）

scala>val squaresDF = spark.sparkContext.makeRDD(1 to 5).map(i => (i, i * i)).toDF("value", "square")
scala>squaresDF.write.parquet("data/test_table/key=1")

// 创建一个新的DataFrame，将其存储到相同表下的新的分区目录（data/test_table/key=2）
// 增加了一个cube列，去掉了一个已存在的square列

scala>val cubesDF = spark.sparkContext.makeRDD(6 to 10).map(i => (i, i * i * i)).toDF("value", "cube")
scala>cubesDF.write.parquet("data/test_table/key=2")

//读取分区表，自动实现了两个分区（key=1/2）的合并

scala>val mergedDF = spark.read.option("mergeSchema", "true").parquet("data/test_table")

//通过基础DataFrame函数，以树格式打印Schema，包含分区目录下全部的分区表

scala>mergedDF.printSchema()
// root
//  |-- value: int (nullable = true)
//  |-- square: int (nullable = true)
//  |-- cube: int (nullable = true)
//  |-- key: int (nullable = true)