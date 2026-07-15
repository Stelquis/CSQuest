import org.apache.spark.{SparkConf, SparkContext}

object WordCount {
  def main(args: Array[String]): Unit = {
    val conf = new SparkConf().setAppName("mySpark").setMaster("local")
    val sc = new SparkContext(conf)
    val rdd = sc.textFile(args(0))
    val wordcount = rdd.flatMap(_.split("\t")).map((_,1)).reduceByKey(_ + _)
    for(arg <- wordcount.collect())
      print(arg + " ")
    println()
    sc.stop()
  }
}
