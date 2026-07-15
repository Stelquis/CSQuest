scala> import org.apache.spark.graphx.{GraphLoader, PartitionStrategy}
import org.apache.spark.graphx.{GraphLoader, PartitionStrategy}

scala> val graph = GraphLoader.edgeListFile(sc, "/usr/local/spark-2.3.0-bin-hadoop2.7/data/graphx/followers.txt", true).partitionBy(PartitionStrategy.RandomVertexCut)
graph: org.apache.spark.graphx.Graph[Int,Int] = org.apache.spark.graphx.impl.GraphImpl@428169d

scala> val triCounts = graph.triangleCount().vertices //对每个顶点计算三角形数
triCounts: org.apache.spark.graphx.VertexRDD[Int] = VertexRDDImpl[128] at RDD at VertexRDD.scala:57
//将三角形数和用户名相联系
scala> val users = sc.textFile("/usr/local/spark-2.3.0-bin-hadoop2.7/data/graphx/users.txt").map {line =>
     | val fields = line.split(",")
     | (fields(0).toLong, fields(1))
     | }
users: org.apache.spark.rdd.RDD[(Long, String)] = MapPartitionsRDD[133] at map at <console>:27

scala> val triCountByUsername = users.join(triCounts).map { case (id, (username, tc)) =>
     | (username, tc)
     | }
triCountByUsername: org.apache.spark.rdd.RDD[(String, Int)] = MapPartitionsRDD[137] at map at <console>:30
//输出结果
scala> println(triCountByUsername.collect().mkString("\n"))
(justinbieber,0)
(BarackObama,0)
(matei_zaharia,1)
(jeresig,1)
(odersky,1)
(ladygaga,0)
