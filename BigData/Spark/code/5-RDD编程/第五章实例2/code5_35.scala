import org.apache.spark.rdd.RDD
import org.apache.spark.{SparkConf, SparkContext}

object mobineNum {
  def main(args: Array[String]) {
// AppName 参数是应用程序的名字，可以在 Spark 内置 UI 上看到它。
val conf = new SparkConf().setAppName("mobineNum")
// Master 是 Spark、Mesos、或者 YARN 集群的 URL，或者使用一个专用的字符串“Local”设定其在本地模式下运行。
conf.setMaster("local")
//sc是SparkContext，指的是“上下文”，也就是运行的环境，需要把conf当参数传进去
val sc = new SparkContext(conf)
//通过sc获取一个文本文件，传入本地文本的路径，将输入文件转换成RDD
// path是该文本文件在该项目所在文件中的路径
val lines = sc.textFile("A.txt")
//切分 
val splited = lines.map(line => {
   //将每行记录以逗号进行分割
       val fields = line.split(",")
       //其中第一个属性值表示手机号
       val mobile = fields(0)
       //第二个属性值为基站信息
       val lac = fields(2)
       //第三个属性值为连接状态
       val tp = fields(3)
       //第四个属性值为时间，将其转换为数据类型。
       val time = if(tp == "1") -fields(1).toLong else fields(1).toLong
       //拼接数据，将其拼接为以下格式组成新的RDD
       ((mobile, lac), time)
    })
//分组聚合，将同一个基站中同一个手机号的时间进行相加
    val reduced= splited.reduceByKey(_+_)
val lmt = reduced.map(x => {
    //x._1._2表示((mobile, lac), time)格式中lac，x._1._1表示mobine，x._2表示time，(基站id,(手机号,时间))
        (x._1._2, (x._1._1, x._2))
    })

//获取各个基站的信息
    val lacInfo = sc.textFile("B.txt")
    //整理基站数据
    val splitedLacInfo = lacInfo.map(line => {
      val fields = line.split(",")
      //基站信息中第一个属性值为基站的id
      val id = fields(0)
      //基站信息中第二个属性值为基站的经度
      val x = fields(1)
      //基站信息中第三个属性值为基站的纬度
      val y = fields(2)
      //拼接为（基站id，（经度，纬度））
      (id, (x, y))
    })
    //将两个RDD进行连接join操作
    val joined = lmt.join(splitedLacInfo)
    println(joined.collect().toBuffer)
    sc.stop()
  }
}
