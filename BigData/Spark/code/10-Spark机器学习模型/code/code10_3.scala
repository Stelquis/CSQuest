import org.apache.spark.ml.Pipeline
import org.apache.spark.ml.classification.{DecisionTreeClassificationModel, DecisionTreeClassifier}
import org.apache.spark.ml.evaluation.MulticlassClassificationEvaluator
import org.apache.spark.ml.feature.{IndexToString, StringIndexer, VectorIndexer}
import org.apache.spark.sql.SparkSession

object DecisionTreeClassificationExample {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession
      .builder
      .appName("DecisionTreeClassificationExample")
      .master("local")
      .getOrCreate()
    //把以libsvm格式存储的数据加载为DataFrame
    val data = spark.read.format("libsvm").load("data/mllib/sample_libsvm_data.txt")

    //索引标签，添加元数据到标签列
    //训练整个数据集来包含所有索引中的标签
    val labelIndexer = new StringIndexer()
      .setInputCol("label")
      .setOutputCol("indexedLabel")
      .fit(data)
    //自动识别分类特征并设置索引
    val featureIndexer = new VectorIndexer()
      .setInputCol("features")
      .setOutputCol("indexedFeatures")
      .setMaxCategories(4) //将具有超过4个值的特征视为连续的
      .fit(data)

    //把数据划分成训练数据集和测试数据集，30%用作测试
    val Array(trainingData, testData) = data.randomSplit(Array(0.7, 0.3))

    //训练一个决策树模型
    val dt = new DecisionTreeClassifier()
      .setLabelCol("indexedLabel")
      .setFeaturesCol("indexedFeatures")

    //把索引标签转换回原始标签
    val labelConverter = new IndexToString()
      .setInputCol("prediction")
      .setOutputCol("predictedLabel")
      .setLabels(labelIndexer.labels)

    //把pipeline中的索引和数链接起来
    val pipeline = new Pipeline()
      .setStages(Array(labelIndexer, featureIndexer, dt, labelConverter))

    //训练决策树模型
    val model = pipeline.fit(trainingData)

    //用测试数据集测试决策树
    val predictions = model.transform(testData)

    //选择要显示的列和总行数（此处为5行）
    predictions.select("predictedLabel", "label", "features").show(5)

    //比较真实值和预测值，并计算误差
    val evaluator = new MulticlassClassificationEvaluator()
      .setLabelCol("indexedLabel")
      .setPredictionCol("prediction")
      .setMetricName("accuracy")
    val accuracy = evaluator.evaluate(predictions)
    println(s"Test Error = ${(1.0 - accuracy)}")
    //打印决策树
    val treeModel = model.stages(2).asInstanceOf[DecisionTreeClassificationModel]
    println(s"Learned classification tree model:\n ${treeModel.toDebugString}")
    spark.stop()
  }
}
