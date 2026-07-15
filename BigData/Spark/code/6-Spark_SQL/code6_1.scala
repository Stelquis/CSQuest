import org.apache.spark.sql.SparkSession
val spark = SparkSession.builder().appName("Spark SQL basic example").config("spark.some.config.option", "some-value").getOrCreate()
// 引入spark.implicits._，以便于RDDs和DataFrames之间的隐式转换
import spark.implicits._