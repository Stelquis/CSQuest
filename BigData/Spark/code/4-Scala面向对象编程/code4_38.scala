//通过HashMap=>_,类便被隐藏起来
import java.util.{ HashMap=>_,_ }
import scala.collection.mutable.HashMap

  object ClassHiddenUsage{

      def main(args:Array[String]): Unit={

          //HashMap更无歧义地指向scala.collection.mutable.HashMap
          val scalaHashMap =new HashMap[String,String]
          scalaHashMap.put("Spark","excellent" )
          scalaHashMap.put("MapReduce","good")

          scalaHashMap.foreach(e =>{
              val (k,v)=e
              println(k+":"+v)
              })
       }
 }
