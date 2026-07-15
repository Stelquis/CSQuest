import org.apache.spark.SparkConf
import org.apache.spark.streaming._
import org.apache.spark.streaming.kafka.KafkaUtils

object KafkaWordCount {
  def main(args:Array[String]){
    StreamingExamples.setStreamingLogLevels()//Set the log4j log level
    val sc = new SparkConf().setAppName("KafkaWordCount").setMaster("local[2]")
    val ssc = new StreamingContext(sc,Seconds(10))
    ssc.checkpoint("/home/ubuntu/Desktop/checkpoint") //set checkpoint
    val zkQuorum = "localhost:2181" //Zookeeper server address
    val group = "kafka_test"  //set Consumer group
    val topics = "sender"  //topic name
    val numThreads = 1  //number of threads
    val topicMap =topics.split(",").map((_,numThreads.toInt)).toMap //Set per-topic number of Kafka partitions to consume
    val lineMap = KafkaUtils.createStream(ssc,zkQuorum,group,topicMap) //Create a Kafka-based Dstream
    val lines = lineMap.map(_._2)  //WordCount example
    val words = lines.flatMap(_.split(" "))
    val pair = words.map(x => (x,1))
    val WordCount = pair.reduceByKey(_+_)
    WordCount.print
    ssc.start
    ssc.awaitTermination
  }
}

