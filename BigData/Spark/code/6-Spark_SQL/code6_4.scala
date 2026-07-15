//常见类的编码器可以通过导入spark.implicits._自动提供
scala>import spark.implicits._
scala>val peopleDF = spark.read.json("/usr/local/spark-2.3.0-bin-hadoop2.7/examples/src/main/resources/people.json")

// peopleDF保存为parquet文件时，依然会保留着结构信息
scala>peopleDF.write.parquet("people.parquet")

//读取创建的people.parquet文件，Parquet文件是自描述的，所以结构信息被保留。
//读取Parquet文件的结果是已经具有完整结构信息的DataFrame对象

val parquetFileDF = spark.read.parquet("people.parquet")

//因为Spark SQL的默认数据源格式为Parquet格式，所以读取格式可为：
//val parquetFileDF = spark.read.load("people.parquet ")
//可以使用SQL直接查询Parquet文件，查询地址为该Parquet文件的存放位置。

scala> val sqlDF = spark.sql("SELECT * FROM parquet.`/home/ubuntu/people.parquet`")

sqlDF: org.apache.spark.sql.DataFrame = [age: bigint, name: string]

scala> sqlDF.show()
+-----+-----------+
| age|  name|
+-----+-----------+
|null| Michael|
| 30|   Andy|
| 19|  Justin|
+----+-----------+

// Parquet 文件也可以用来创建临时视图，然后在SQL语句中使用

scala>parquetFileDF.createOrReplaceTempView("parquetFile")
scala>val namesDF = spark.sql("SELECT name FROM parquetFile WHERE age BETWEEN 13 AND 19")
scala>namesDF.map(attributes => "Name: " + attributes(0)).show()

// +-----------------+
// |      value|
// +-----------------+
// |Name: Justin|
// +-----------------+