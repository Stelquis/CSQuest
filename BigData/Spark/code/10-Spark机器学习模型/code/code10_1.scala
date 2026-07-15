import org.apache.spark.ml.classification.NaiveBayes
import org.apache.spark.ml.evaluation.MulticlassClassificationEvaluator
import org.apache.spark.sql.SparkSession

object NaiveBayesExample {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession
      .builder
      .master("local")
      .appName("NaiveBayesExample")
      .getOrCreate()

    // 把以libsvm格式存储的数据加载为DataFrame
    val data = spark.read.format("libsvm").load("data/sample_libsvm_data.txt")

    //把数据集划分为训练集和测试集（30%用于测试）
    val Array(trainingData, testData) = data.randomSplit(Array(0.7, 0.3), seed = 1234L)

    // 训练一个朴素贝叶斯模型
    val model = new NaiveBayes()
      .fit(trainingData)

    // 用训练好的模型对测试集进行分类
    val predictions = model.transform(testData)
    predictions.show()

    //比较测试集的预测列和标签列，并计算测试误差
    val evaluator = new MulticlassClassificationEvaluator()
      .setLabelCol("label")
      .setPredictionCol("prediction")
      .setMetricName("accuracy")
    //打印分类的精确度
    val accuracy = evaluator.evaluate(predictions)
    println(s"Test set accuracy = $accuracy")
	
    spark.stop()
  }
}
