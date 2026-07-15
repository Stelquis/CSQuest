import java.io.PrintWriter
import org.apache.spark.graphx.{Edge, EdgeDirection, Graph, VertexId}
import org.apache.spark.rdd.RDD
import org.apache.spark.{SparkConf, SparkContext}
object Twitter_test {
  def main(args: Array[String]): Unit = {
    val conf = new SparkConf().setAppName("Twittter Influencer").setMaster("local[*]")
    val sparkContext = new SparkContext(conf)
    sparkContext.setLogLevel("ERROR")
    //文本文件的路径根实际存放的位置决定
    val twitterData = sparkContext.textFile("twitter-graph-data.txt")
    //分别从文本文件中提取followee和follower的数据
    val followeeVertices: RDD[(VertexId, String)] = twitterData.map(_.split(",")).map { arr =>
      val user = arr(0).replace("((", "")
      val id = arr(1).replace(")", "")
      (id.toLong, user)
    }
    val followerVertices: RDD[(VertexId, String)] = twitterData.map(_.split(",")).map { arr =>
      val user = arr(2).replace("(", "")
      val id = arr(3).replace("))", "")
      (id.toLong, user)
    }
    //接下来，我们使用Spark GraphX API从上面提取的数据创建图形。
    val vertices = followeeVertices.union(followerVertices)
    val edges: RDD[Edge[String]] = twitterData.map(_.split(",")).map { arr =>
      val followeeId = arr(1).replace(")", "").toLong
      val followerId = arr(3).replace("))", "").toLong
      Edge(followeeId, followerId, "follow")
    }
    val defaultUser = ("") //提供了一个默认输入
    val graph = Graph(vertices, edges, defaultUser)
    //使用Spark GraphX的Pregel API和广度优先遍历算法
    val subGraph = graph.pregel("", 2, EdgeDirection.In)((_, attr, msg) =>
      attr + "," + msg,
      triplet => Iterator((triplet.srcId, triplet.dstAttr)),
      (a, b) => (a + "," + b))
    //找到拥有最多followers of followers的用户
    val lengthRDD = subGraph.vertices.map(vertex => (vertex._1, vertex._2.split(",").distinct.length - 2))
      .max()(new Ordering[Tuple2[VertexId, Int]]() {
        override def compare(x: (VertexId, Int), y: (VertexId, Int)): Int =
          Ordering[Int].compare(x._2, y._2)
      })
    val userId = graph.vertices.filter(_._1 == lengthRDD._1).map(_._2).collect().head
    println(userId + " has maximum influence on network with " + lengthRDD._2 + " influencers.")
    val pw = new PrintWriter("Twitter_graph.gexf");
    //pw.write(toGexf(graph))
    pw.close()
    sparkContext.stop()
  }
}
