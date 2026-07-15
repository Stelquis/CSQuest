import org.apache.spark.SparkConf
import org.apache.spark.streaming.{Seconds, StreamingContext}
object saveAsTextFiles_op {
  def main(arg: Array[String]): Unit = {
    val conf = new SparkConf().setMaster("local[2]").setAppName("aveAsTextFilesTest")
    val ssc = new StreamingContext(conf, Seconds(10))
    val lines = ssc.socketTextStream("192.168.201.139", 9999)
    //Save to path,and will be automatically generated  (test+“monitor time”+.txt)file
    lines.saveAsTextFiles("/home/ubuntu/Desktop/file/test","txt")
    ssc.start()
    ssc.awaitTermination()
  }
}

