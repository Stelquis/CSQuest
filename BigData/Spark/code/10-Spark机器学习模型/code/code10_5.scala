import org.apache.spark.ml.clustering.KMeans
import org.apache.spark.ml.evaluation.ClusteringEvaluator
import org.apache.spark.sql.SparkSession

object KMeansExample {

  def main(args: Array[String]): Unit = {
    val spark = SparkSession
      .builder
      .appName(s"${this.getClass.getSimpleName}")
      .master("local")
      .getOrCreate()

    // 把以libsvm格式存储加载为DataFrame
    val dataset = spark.read.format("libsvm").load("data/sample_kmeans_data.txt")
    dataset.show(false)
    // 训练一个K-means模型，设置K=2并设置一个随机数种子
    val kmeans = new KMeans().setK(2)
    val model = kmeans.fit(dataset)

    // 用训练好的模型对数据集进行聚类
    val predictions = model.transform(dataset)

    // 评估聚类结果
    val evaluator = new ClusteringEvaluator()
    val silhouette = evaluator.evaluate(predictions)
	// 打印通过欧氏距离得出的轮廓系数
    println(s"Silhouette with squared euclidean distance = $silhouette")

    // 打印聚类中心点
    println("Cluster Centers: ")
    model.clusterCenters.foreach(println)

    spark.stop()
  }
}
