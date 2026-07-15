import org.apache.spark.SparkConf
import org.apache.spark.streaming._
object Window_op {
  def main(arg: Array[String]): Unit ={
    val conf = new SparkConf().setMaster("local[2]").setAppName("Windowtest")
    //Initialize the Streaming object and set the batch interval to 10s
    val ssc = new StreamingContext(conf,Seconds(10))
    //Specify the connected IP port with a socket stream
    val lines = ssc.socketTextStream("192.168.201.139",9999)
    val words = lines.flatMap(_.split(" "))
    //windowLength = 30s ; slideInterval = 10s
    val windowwords = words.window(Seconds(30),Seconds(10))
    windowwords.print()
    ssc.start()
    ssc.awaitTermination()
  }
}
