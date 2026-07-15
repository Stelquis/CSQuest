import org.apache.spark.SparkConf
import org.apache.spark.streaming.{Seconds, StreamingContext}

object reduceByKeyAndWindow_op {
  def main(arg: Array[String]): Unit = {
    val conf = new SparkConf().setMaster("local[2]").setAppName("reduceByKeyAndWIndowtest")
    val ssc = new StreamingContext(conf, Seconds(10))
    ssc.checkpoint("/home/ubuntu/Desktop/checkpoint") //set checkpoint
    val lines = ssc.socketTextStream("192.168.201.139", 9999)
    val words = lines.flatMap(_.split(" "))
    //The first method: set windowLength = 30s ,slideInterval = 10s
    //val wordCounts = words.map(x => (x, 1)).reduceByKeyAndWindow((a:Int,b:Int) => (a + b),Seconds(30),Seconds(10),2)
    val wordCounts = words.map(x => (x, 1)).reduceByKeyAndWindow(_+_,_-_,Seconds(30),Seconds(10),2)
    wordCounts.print()
    ssc.start()
    ssc.awaitTermination()
  }
}
