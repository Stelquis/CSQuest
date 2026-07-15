import java.io.File
import org.apache.spark.sql.{Row, SaveMode, SparkSession}
case class Record(key: Int, value: String)
// warehouseLocation指向托管数据库和表的默认位置
val warehouseLocation = new File("spark-warehouse").getAbsolutePath

val spark = SparkSession
  .builder()
  .appName("Spark Hive Example")
  .config("spark.sql.warehouse.dir", warehouseLocation)
  .enableHiveSupport()
  .getOrCreate()
import spark.implicits._
import spark.sql
sql("CREATE TABLE IF NOT EXISTS src (key INT, value STRING) USING hive")
sql("LOAD DATA LOCAL INPATH 'examples/src/main/resources/kv1.txt' INTO TABLE src")

// 使用HiveQL进行查询
sql("SELECT * FROM src").show()
// +----+-----------+
// |key|  value|
// +----+-----------+
// |238|val_238|
// | 86|  val_86|
// |311|val_311|
// ...
// 包含着Hive聚合函数COUNT()的查询依然被支持
sql("SELECT COUNT(*) FROM src").show()
// +-----------+
// |count(1)|
// +-----------+
// |   500 |
// +-----------+
// SQL查询的结果本身就是DataFrame，并支持所有正常的功能
val sqlDF = sql("SELECT key, value FROM src WHERE key < 10 ORDER BY key")

// DataFrame中的元素是Row类型的，允许按顺序访问每个列
val stringsDS = sqlDF.map {
case Row(key: Int, value: String) => s"Key: $key, Value: $value"
}

stringsDS.show()
// +-------------------------+
// |           value|
// +-------------------------+
// |Key: 0, Value: val_0|
// |Key: 0, Value: val_0|
// |Key: 0, Value: val_0|
// ...
// 也可以使用DataFrame在 SparkSession中创建临时视图
val recordsDF = spark.createDataFrame((1 to 100).map(i => Record(i, s"val_$i")))
recordsDF.createOrReplaceTempView("records")

//sql查询中可以对DataFrame注册的临时表和Hive表执行Join连接操作
sql("SELECT * FROM records r JOIN src s ON r.key = s.key").show()
// +-----+-------+-----+-------+
// |key| value|key| value|
// +-----+-------+-----+-------+
// |  2| val_2|  2| val_2|
// |  4| val_4|  4| val_4|
// |  5| val_5|  5| val_5|
// ...

//使用HQL语法而不是Spark SQL本机语法创建Hive托管Parquet表
sql("CREATE TABLE hive_records(key int, value string) STORED AS PARQUET")

//保存DataFrame到Hive托管表中
val df = spark.table("src")
df.write.mode(SaveMode.Overwrite).saveAsTable("hive_records")
sql("SELECT * FROM hive_records").show()
// +---+-------+
// |key|  value|
// +---+-------+
// |238|val_238|
// | 86| val_86|
// |311|val_311|
// ... 
val dataDir = "/tmp/parquet_data"
spark.range(10).write.parquet(dataDir)

//创建一个Hive额外的Parquet表
sql(s"CREATE EXTERNAL TABLE hive_ints(key int) STORED AS PARQUET LOCATION '$dataDir'")
sql("SELECT * FROM hive_ints").show()
// +---+
// |key|
// +---+
// |  0|
// |  1|
// |  2|
// ...
// 打开Hive动态分区的标志
spark.sqlContext.setConf("hive.exec.dynamic.partition", "true")
spark.sqlContext.setConf("hive.exec.dynamic.partition.mode", "nonstrict")

// 使用DataFrame API创建Hive分区表
df.write.partitionBy("key").format("hive").saveAsTable("hive_part_tbl")

// 分区列’key’被移至schema的末尾
sql("SELECT * FROM hive_part_tbl").show()
// +----------+-----+
// |  value|key|
// +----------+-----+
// |val_238|238|
// | val_86 | 86 |
// |val_311|311|
// ...

spark.stop()