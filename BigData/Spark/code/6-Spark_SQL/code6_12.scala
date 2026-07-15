scala> case class student(name:String,age:Int,Height:Int,Weight:Int)
defined class student

scala> import spark.implicits._
import spark.implicits._

scala> val stuRDD = spark.sparkContext.textFile("/home/ubuntu/student.txt").map(_.split(",")).map(elements=>student(elements(0),elements(1).trim.toInt,elements(4).trim.toInt,elements(5).trim.toInt))
stuRDD: org.apache.spark.rdd.RDD[student] = MapPartitionsRDD[13] at map at <console>:28

scala> val stuDF = stuRDD.toDF()
stuDF: org.apache.spark.sql.DataFrame = [name: string, age: int ... 2 more fields]

scala> stuDF.createOrReplaceTempView("student")

scala> val stu_H_W = spark.sql("SELECT name,age,Height,Weight FROM student WHERE age BETWEEN 13 AND 19")
stu_H_W: org.apache.spark.sql.DataFrame = [name: string, age: int ... 2 more fields]

scala> stu_H_W.show()
+-------+-----+---------+---------+
|name|age|Height|Weight|
+-------+-----+---------+---------+
|  MK| 19|  166|    62|
|  CT | 18|  169|    60|
+-------+----+--------+----------+