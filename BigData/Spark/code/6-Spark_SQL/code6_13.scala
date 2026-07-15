//导入Spark SQL的data types包

scala> import org.apache.spark.sql.types._
import org.apache.spark.sql.types._

//导入Spark SQL的Row包
scala> import org.apache.spark.sql.Row
import org.apache.spark.sql.Row

// 创建peopleRDD
scala> val stuRDD = spark.sparkContext.textFile("/home/ubuntu/student.txt")
stuRDD: org.apache.spark.rdd.RDD[String] = /home/ubuntu/student.txt MapPartitionsRDD[19] at textFile at <console>:30

// schema字符串
scala> val schemaString = "name age country"
schemaString: String = name age country

//将schema字符串按空格分隔返回字符串数组，对字符串数组进行遍历，并对数组中的每一个元素进一步封装成StructField对象，进而构成了Array[StructField]
scala> val fields = schemaString.split(" ").map(fieldName => StructField(fieldName,StringType,nullable = true))
fields: Array[org.apache.spark.sql.types.StructField] = Array(StructField(name,StringType,true), StructField(age,StringType,true), StructField(country,StringType,true))

//将fields强制转换为StructType对象，形成了可用于构建DataFrame对象的Schema
scala> val schema = StructType(fields)
schema: org.apache.spark.sql.types.StructType = StructType(StructField(name,StringType,true), StructField(age,StringType,true), StructField(country,StringType,true))

//将peopleRDD（RDD[String]）转化为RDD[Rows]
scala> val rowRDD = stuRDD.map(_.split(",")).map(elements => Row(elements(0),elements(1).trim,elements(2)))
rowRDD: org.apache.spark.rdd.RDD[org.apache.spark.sql.Row] = MapPartitionsRDD[21] at map at <console>:32

//将schema应用到rowRDD上，完成DataFrame的转换
scala> val stuDF = spark.createDataFrame(rowRDD,schema)
stuDF: org.apache.spark.sql.DataFrame = [name: string, age: string ... 1 more field]

//可以对stuDF直接操作
scala> stuDF.show(9)
+-------+-----+----------+
|name|age|country|
+-------+-----+----------+
|  MI| 20 |  china |
|  MU| 21|  Spain|
|  MY| 25|Portugal|
|  MK| 19|  Japan|
|  Ab | 24| France |
|  Ar | 21|  Russia|
|  Ad | 20| Geneva|
|  Am| 20|  china|
|  Bo | 20|  Spain|
+-------+----+-----------+
//也可将stuDF注册成临时表“student”， 调用sql接口，运行SQL表达式，进行SQL
//查询，sql()返回值依然是DataFrame对象。
scala> stuDF.createOrReplaceTempView("student")
scala> val results = spark.sql("SELECT name,age,country FROM student WHERE age BETWEEN 13 and 19").show()
+-------+-----+----------+
|name|age|country|
+-------+-----+----------+
|  MK| 19|  Japan|
|  CT | 18 | France |
+-------+-----+----------+