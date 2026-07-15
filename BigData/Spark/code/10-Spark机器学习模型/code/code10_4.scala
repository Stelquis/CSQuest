
import org.apache.spark.ml.Pipeline
import org.apache.spark.ml.evaluation.RegressionEvaluator
import org.apache.spark.ml.feature.VectorIndexer
import org.apache.spark.ml.regression.DecisionTreeRegressionModel
import org.apache.spark.ml.regression.DecisionTreeRegressor
import org.apache.spark.sql.SparkSession

object DecisionTreeRegressionExample {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession
      .builder
	  .master("local")
      .appName("DecisionTreeRegressionExample")
      .getOrCreate()

    // 把以LIBSVM格式存储的数据加载为DataFrame
    val data = spark.read.format("libsvm").load("data/mllib/sample_libsvm_data.txt")

    // 自动识别分类特征并设置索引
    val featureIndexer = new VectorIndexer()
      .setInputCol("features")
      .setOutputCol("indexedFeatures")
	  //将具有> 4个不同值的特征视为连续的。
      .setMaxCategories(4)
      .fit(data)

    // 将数据拆分为训练集和测试集（30％用于测试）
    val Array(trainingData, testData) = data.randomSplit(Array(0.7, 0.3))

    // 新建一个决策树回归模型。
    val dt = new DecisionTreeRegressor()
      .setLabelCol("label")
      .setFeaturesCol("indexedFeatures")

    // 链接pipeline中的索引和树
    val pipeline = new Pipeline()
      .setStages(Array(featureIndexer, dt))

    // 训练决策树回归模型
    val model = pipeline.fit(trainingData)

    // 用测试集来评估训练好的模型
    val predictions = model.transform(testData)

    // 选择要显示的列和总行数（这里设置为5行）
    predictions.select("prediction", "label", "features").show(5)

    // 比较prediction和label列的数据并计算预测误差
    val evaluator = new RegressionEvaluator()
      .setLabelCol("label")
      .setPredictionCol("prediction")
      .setMetricName("rmse")
	//打印均方根误差
    val rmse = evaluator.evaluate(predictions)
    println(s"Root Mean Squared Error (RMSE) on test data = $rmse")
	//打印生成的决策树
    val treeModel = model.stages(1).asInstanceOf[DecisionTreeRegressionModel]
    println(s"Learned regression tree model:\n ${treeModel.toDebugString}")
    spark.stop()
  }
}
