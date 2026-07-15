import org.apache.spark.SparkConf
import org.apache.spark.rdd.RDD
import org.apache.spark.streaming._
object RDD_Queue_Stream {
    def main(args:Array[String]){
      val sparkConf = new SparkConf().setAppName("RDDQueue").setMaster("local[2]")
      val ssc = new StreamingContext(sparkConf,Seconds(4)) //Set to monitor every four seconds
      val rddQueue = new scala.collection.mutable.SynchronizedQueue[RDD[Int]]()//Create an RDD queue
      val queueStream = ssc.queueStream(rddQueue) //Create an input RDD queue stream
      val mapStream = queueStream.map(r=>(r%10,1)) //Transform data into (data%10,1) form
      val reduceStream = mapStream.reduceByKey(_+_)
      reduceStream.print()
      ssc.start()
      //Push RDD into the queue
      for(i<-1 to 10){
        rddQueue+=ssc.sparkContext.makeRDD(1 to 100)//set the number of 1-100 as a RDD
        Thread.sleep(1000)//Time pause for 1s
      }
      ssc.stop()//Program stop
    }
}


