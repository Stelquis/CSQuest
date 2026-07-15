import org.apache.log4j.{Level, Logger}
import org.apache.spark.SparkConf
import org.apache.spark.SparkContext
import org.apache.spark.graphx.{Edge, Graph, TripletFields, VertexId}
import scala.reflect.ClassTag
object Paths {        //单源最短路径
  def dijkstra[VD: ClassTag](g : Graph[VD, Double], origin: VertexId) = {
    //初始化，其中属性为（boolean, double，Long）类型，boolean用于标记是否访问过，double为顶点距离原点的距离，Long是上一个顶点的id
    var g2 = g.mapVertices((vid, _) => (false, if(vid == origin) 0 else Double.MaxValue, -1L))
    for(i <- 1L to g.vertices.count()) {
      //从没有访问过的顶点中找出距离原点最近的点
      val currentVertexId = g2.vertices.filter(! _._2._1).reduce((a,b) => if (a._2._2 < b._2._2) a else b)._1
      //更新currentVertexId邻接顶点的‘double’值
      val newDistances = g2.aggregateMessages[(Double, Long)](
        triplet => if(triplet.srcId == currentVertexId && !triplet.dstAttr._1) {    //只给未确定的顶点发送消息
          triplet.sendToDst((triplet.srcAttr._2 + triplet.attr, triplet.srcId))
        },(x, y) => if(x._1 < y._1) x else y ,
        TripletFields.All)
      g2 = g2.outerJoinVertices(newDistances) {       //更新图形
        case (vid, vd, Some(newSum)) => (vd._1 ||
          vid == currentVertexId, math.min(vd._2, newSum._1), if(vd._2 <= newSum._1) vd._3 else newSum._2 )
        case (vid, vd, None) => (vd._1|| vid == currentVertexId, vd._2, vd._3)
      }
    }
    g.outerJoinVertices(g2.vertices)( (vid, srcAttr, dist) => (srcAttr, dist.getOrElse(false, Double.MaxValue, -1)._2) )
  }
  def main(args: Array[String]): Unit ={
    val conf = new SparkConf().setAppName("ShortPaths").setMaster("local[4]")//指定四个本地线程数目，来模拟分布式集群
    val sc = new SparkContext(conf) //屏蔽日志
    Logger.getLogger("org.apache.spark").setLevel(Level.WARN)
    Logger.getLogger("org.eclipse.jetty.server").setLevel(Level.OFF)
    val myVertices = sc.makeRDD(Array((1L, "A"), (2L, "B"), (3L, "C"), (4L, "D"), (5L, "E"), (6L, "F"), (7L, "G")))
    val initialEdges = sc.makeRDD(Array(Edge(1L, 2L, 7.0), Edge(1L, 4L, 5.0),
      Edge(2L, 3L, 8.0), Edge(2L, 4L, 9.0), Edge(2L, 5L, 7.0),Edge(3L, 5L, 5.0), Edge(4L, 5L, 15.0), Edge(4L, 6L, 6.0),Edge(5L, 6L, 8.0), Edge(5L, 7L, 9.0), Edge(6L, 7L, 11.0)))
    val myEdges = initialEdges.filter(e => e.srcId != e.dstId).flatMap(e => Array(e, Edge(e.dstId, e.srcId, e.attr))).distinct()  //去掉自循环边，有向图变为无向图，去除重复边
    val myGraph = Graph(myVertices, myEdges).cache()
    println(dijkstra(myGraph, 1L).vertices.map(x => (x._1, x._2)).collect().mkString(" | "))
  }
}
