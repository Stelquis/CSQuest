//创建Properties类对象需要的包
scala> import java.util.Properties
import java.util.Properties
scala> val jdbcDF = spark.read
//识别读取的是JDBC数据源。
.format("jdbc") 
//要连接的JDBC URL属性，其中student是创建的数据库名。
.option("url","jdbc:mysql://localhost:3306/student")
// driver部分是Spark SQL访问数据库的具体驱动类名。
.option("driver","com.mysql.jdbc.Driver")
//dbtable部分是需要访问的student库中的表stu。
.option("dbtable","stu")
//user部分是用于访问mysql数据库的用户
.option("user","root")
//password部分是该用户访问数据库的密码
.option("password","mysql")
.load()
scala> jdbcDF.show()
+---+-------+----------+----------+---------+                                                
| id|name|country| Height|Weight|
+---+-------+----------+----------+---------+
| 1|  MI|  china|  180.0|  60.0|
| 2|  UI |    UK|  160.0|  50.0|
| 3|  DI |    UK|  165.0|  55.0|
| 4|  Bo|  china|  167.0|  45.0|
+---+-------+----------+----------+---------+      
//实例化Properties类对象，并添加相应的JDBC连接属性以键值对形式
scala> val connectionProperties = new Properties()
connectionProperties: java.util.Properties = {}
//将user属性和password属性添加至Properties类对象中。
scala> connectionProperties.put("user","root")
scala> connectionProperties.put("password","mysql")
//addstu是含有需要写入stu表中的数据的DataFrame。
scala> val addstu = spark.read.json("/home/ubuntu/Desktop/stu.json")
scala> addstu.show()
+--------+----------+----------+-------+
|Height|Weight|country|name|
+--------+----------+----------+-------+
|  168|    48|  china|  Am|
|  189|    80|  Spain|  Bo |
+--------+----------+----------+-------+
scala>addstu.write
  .mode("append")
.format("jdbc")
  .option("url", " jdbc:mysql://localhost:3306/student ")
  .option("dbtable", "stu")
  .option("user", "root")
  .option("password", "mysql")
  .save()
//与读取JDBC数据源相同，也可以将connectionProperties对象传入write.jdbc()方法中来实现数据表的写入
scala> addstu.write
.mode("append")
.jdbc("jdbc:mysql://localhost:3306/student","student.stu",connectionProperties)