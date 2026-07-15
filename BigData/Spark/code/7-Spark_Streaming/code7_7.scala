import org.apache.spark.SparkConf
import org.apache.spark.streaming.{Seconds, StreamingContext}
object countByWindow_op {
  def main(arg: Array[String]): Unit = {
    val conf = new SparkConf()
      .setMaster("local[2]")
      .setAppName("CountByWindowtest")
    val ssc = new StreamingContext(conf, Seconds(10))
    //set checkpoint
    ssc.checkpoint("/home/xiongfan/Spark_Streaming/checkpoint")
    val lines = ssc.socketTextStream("192.168.28.135", 9999)
    val words = lines.flatMap(_.split(" "))
    //Count the number of DStream elements according to the window size
    val windowwords = words.countByWindow(Seconds(30), Seconds(10))
    windowwords.print()
    ssc.start()
    ssc.awaitTermination()
  }
}
