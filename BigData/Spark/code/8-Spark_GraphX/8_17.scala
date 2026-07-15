package org.apache.spark.examples.graphx
import org.apache.spark.graphx.GraphLoader
import org.apache.spark.sql.SparkSession
object PageRankExample {
  def main(args: Array[String]): Unit = {
    // 创建一个SparkSession.
    val spark = SparkSession
      .builder
	  //如果代码在本地计算机运行需要添加master("local")
      .appName(s"${this.getClass.getSimpleName}").master("local")
      .getOrCreate()
    val sc = spark.sparkContext
    // 加载边数据，创建Graph
    val graph = GraphLoader.edgeListFile(sc, "followers.txt")
    // 运行 PageRank
    val ranks = graph.pageRank(0.0001).vertices
    // 将排名与用户名连接，连接后输出结果
    val users = sc.textFile("users.txt").map { line =>
      val fields = line.split(",")
      (fields(0).toLong, fields(1))
    }
    val ranksByUsername = users.join(ranks).map {
      case (id, (username, rank)) => (username, rank)
    }
    println(ranksByUsername.collect().mkString("\n"))
    spark.stop()
  }
}
