import org.apache.spark.SparkConf
import org.apache.spark.streaming.{Seconds, StreamingContext}
object updateStateByKey_op {
  def main(args: Array[String]) {
    val conf = new SparkConf().setMaster("local[2]")
      .setAppName("UpdateStateByKeytest")
    val ssc = new StreamingContext(conf,Seconds(20))
    //Set checkpoint
    ssc.checkpoint("/home/ubuntu/Desktop/checkpoint")
    val socketLines = ssc.socketTextStream("192.168.201.139",9999)
    socketLines.flatMap(_.split(" ")).map(word=>(word,1))
      .updateStateByKey(     //Add the new values with the previous running count to get the new count
        (currValues:Seq[Int],preValue:Option[Int]) =>{ //Parameter settings
          val currValue = currValues.sum   //Sum the value corresponding to the current key
          Some(currValue + preValue.getOrElse(0)) //New value plus old value
        }).print()
    ssc.start()
    ssc.awaitTermination()
    ssc.stop()
  }
}
