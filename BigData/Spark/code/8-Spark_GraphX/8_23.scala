import org.apache.log4j.{Level, Logger}
import org.apache.spark.{SparkConf, SparkContext}
import org.apache.spark.graphx._
object TSP {
  def greedy[VD](g: Graph[VD, Double], origin: VertexId) = {
    var g2: Graph[Boolean, (Double, Boolean)] = g.mapVertices((vid, vd) => vid == origin).mapTriplets {
      et => (et.attr, false)
    }
    var nextVertexId = origin
    var edgesAreAvailable = true
    type tripletType = EdgeTriplet[Boolean, (Double, Boolean)]
    do {
      val availableEdges = g2.triplets.filter { et => !et.attr._2 && (et.srcId == nextVertexId && !et.dstAttr || et.dstId == nextVertexId && !et.srcAttr) }
      edgesAreAvailable = availableEdges.count > 0
      if (edgesAreAvailable) {
        val smallestEdge = availableEdges.min()(new Ordering[tripletType]() {
          override def compare(a: tripletType, b: tripletType) = {
            Ordering[Double].compare(a.attr._1, b.attr._1)
          }
       })
        nextVertexId = Seq(smallestEdge.srcId, smallestEdge.dstId).filter(_ != nextVertexId).head
        g2 = g2.mapVertices((vid, vd) => vd || vid == nextVertexId).mapTriplets { et =>
          (et.attr._1, et.attr._2 ||
            (et.srcId == smallestEdge.srcId
              && et.dstId == smallestEdge.dstId))
        }
      }
    } while (edgesAreAvailable)
    g2
  }
  def main(args: Array[String]): Unit = {
    val conf = new SparkConf().setAppName("ShortPaths").setMaster("local[4]")
    val sc = new SparkContext(conf) //灞忚斀鏃ュ織
    Logger.getLogger("org.apache.spark").setLevel(Level.WARN)
    Logger.getLogger("org.eclipse.jetty.server").setLevel(Level.OFF)
    val myVertices = sc.makeRDD(Array((1L, "A"), (2L, "B"), (3L, "C"), (4L, "D"), (5L, "E"), (6L, "F"), (7L, "G")))
    val initialEdges = sc.makeRDD(Array(Edge(1L, 2L, 7.0), Edge(1L, 4L, 5.0),
      Edge(2L, 3L, 8.0), Edge(2L, 4L, 9.0), Edge(2L, 5L, 7.0), Edge(3L, 5L, 5.0), Edge(4L, 5L, 15.0), Edge(4L, 6L, 6.0),
      Edge(5L, 6L, 8.0), Edge(5L, 7L, 9.0), Edge(6L, 7L, 11.0)))
    val myEdges = initialEdges.filter(e => e.srcId != e.dstId).flatMap(e => Array(e, Edge(e.dstId, e.srcId, e.attr))).distinct()
    val myGraph = Graph(myVertices, myEdges).cache()
    println(greedy(myGraph, 1L).vertices.map(x => (x._1, x._2)).collect().mkString(" | "))
  }
}
