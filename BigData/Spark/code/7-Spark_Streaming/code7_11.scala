import org.apache.spark.SparkConf
import org.apache.spark.streaming._
object File_Stream {
  def main(arg: Array[String]): Unit = {
    val conf = new SparkConf().setMaster("local[2]").setAppName("File_Stream")
    val ssc = new StreamingContext(conf, Seconds(30))//Set the monitor interval to 30s
    //Set the monitor folder
    val lines = ssc.textFileStream("/home/ubuntu/Desktop/File_Stream")
    //monitor files execute WordCount
    val words = lines.flatMap(_.split(" "))
    val wordCounts = words.map(x=>(x,1)).reduceByKey(_+_)
    wordCounts.print()
    ssc.start()//begin execution
    ssc.awaitTermination()//waiting for execution to end
  }
}
