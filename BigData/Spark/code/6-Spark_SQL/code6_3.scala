//使用sparkSession对象提供的read()方法可读取数据源（read方法返回DataFrameReader对象），进而通过json()方法标识数据源具体类型为Json格式

scala> val df = spark.read.json("/home/ubuntu/student.json")

df: org.apache.spark.sql.DataFrame = [age: string, institute: string ... 3 more fields]

//调用SparkSession.read方法中的通用load方法也可以读取数据源。
//scala>val peopleDf = sparkSession.read.format("json").load("/home/ubuntu/student.json")

// 推导出来的schema，可用printSchema打印出来

scala> df.printSchema()

root
 |-- Height: string (nullable = true)
 |-- Weight: string (nullable = true)
 |-- age: string (nullable = true)
 |-- country: string (nullable = true)
 |-- institute: string (nullable = true)
 |-- name: string (nullable = true)
//在返回的DataFrame对象使用show(n)方法，展示数据集的前n条数据

scala> df.show(6)

+---------+----------+-----+-----------+--------------------------+--------+
| Height| Weight|age| country|          institute|name|
+---------+----------+-----+-----------+--------------------------+--------+
|   185|    75| 20|   china|computer science ...|  MI|
|   187|    70| 21|   Spain|   medical college|  MU|
|   155|    60| 25| Portugal|chemical engineer...|  MY|
|   166|    62| 19|  Japan|             SEM|  MK|
|   187|    80| 24|  France| school of materials|  Ab |
|   167|    60| 21|  Russia| school of materials|   Ar|
+----------+---------+----+------------+-------------------------+---------+
only showing top 6 rows
// 另一种方法是，用一个包含JSON字符串的RDD来创建DataFrame

scala>val otherPeopleDataset = spark.createDataset("""{"name":"Yin","address":{"city":"Columbus","state":"Ohio"}}""" :: Nil)
scala>val otherPeople = spark.read.json(otherPeopleDataset)
scala>otherPeople.show()


+----------------------+-------+
|       address|name|
+----------------------+-------+
|[Columbus,Ohio]|  Yin|
+----------------------+-------+