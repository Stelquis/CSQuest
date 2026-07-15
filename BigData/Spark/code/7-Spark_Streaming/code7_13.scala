import org.apache.spark.SparkConf
import org.apache.spark.streaming._
object Socket_Stream {
  def main(arg: Array[String]): Unit = {
    val conf = new SparkConf().setMaster("local[2]").setAppName("Socket_Stream")
    val ssc = new StreamingContext(conf, Seconds(10))
    //The first parameter is the host IP and the second is the port
    val lines = ssc.socketTextStream("192.168.201.139", 9999)
    //monitor data execute WordCount
    val words = lines.flatMap(_.split(" "))
    val wordCounts = words.map(x => (x, 1)).reduceByKey(_ + _)
    wordCounts.print()
    ssc.start()
    ssc.awaitTermination()
  }
}
