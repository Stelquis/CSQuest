import org.apache.spark.ml.{Pipeline, PipelineModel}
import org.apache.spark.ml.classification.{LogisticRegression, LogisticRegressionModel}
import org.apache.spark.ml.evaluation.BinaryClassificationEvaluator
import org.apache.spark.ml.feature.{HashingTF, Tokenizer}
import org.apache.spark.ml.linalg.Vector
import org.apache.spark.ml.tuning.{CrossValidator, ParamGridBuilder}
import org.apache.spark.sql.Row
import org.apache.spark.sql.SparkSession
object ModelSelectionViaCrossValidationExample {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder
      .master("local")
      .appName("ModelSelectionViaCrossValidationExample")
      .getOrCreate()
    //创建训练集。createDataFrame()创建DataFrame，列名为id，text，label
    val training = spark.createDataFrame(Seq(
      (0L, "a b c d e spark", 1.0),
      (1L, "b d", 0.0),
      (2L, "spark f g h", 1.0),
      (3L, "hadoop mapreduce", 0.0),
      (4L, "b spark who", 1.0),
      (5L, "g d a y", 0.0),
      (6L, "spark fly", 1.0),
      (7L, "was mapreduce", 0.0),
      (8L, "e spark program", 1.0),
      (9L, "a e c l", 0.0),
      (10L, "spark compile", 1.0),
      (11L, "hadoop software", 0.0)
    )).toDF("id", "text", "label")
	//创建Pipeline实例，包含三个stage：Tokenizer、HashingTF、LogisticRegression
    val tokenizer = new Tokenizer()
      .setInputCol("text")
      .setOutputCol("words")
    val hashingTF = new HashingTF()
      .setInputCol(tokenizer.getOutputCol)
      .setOutputCol("features")
    val lr = new LogisticRegression()
      .setMaxIter(10)
    val pipeline = new Pipeline()
      .setStages(Array(tokenizer, hashingTF, lr))
	//创建ParamGridBuilder实例，创建参数网格
    //设置hashingTF.numFeatures有三个可能值，lr.regParam有2个可能值
    //参数网格将有3 * 2 = 6个参数组合设置供CrossValidator选择。
    val paramGrid = new ParamGridBuilder()
      .addGrid(hashingTF.numFeatures, Array(10, 100, 1000))
      .addGrid(lr.regParam, Array(0.1, 0.01))
      .build()
    //创建CrossValidator（Estimator）实例
	//将Pipeline实例“嵌入”交叉验证实例中，Pipeline的中的任务都可以使用参数网格；
	//BinaryClassificationEvaluator使用的默认的评估指标是AUC（areaUnderROC）。
    val cv = new CrossValidator()
      .setEstimator(pipeline)
      .setEvaluator(new BinaryClassificationEvaluator)
      .setEstimatorParamMaps(paramGrid)
      .setNumFolds(2)
      .setParallelism(2)
    //调用cv的fit()方法，训练生成CrossValidatorModel（Transformer）。
	//得到最优参数集。
    val cvModel = cv.fit(training)
    //创建测试集。createDataFrame()创建DataFrame，仅包含两列，分别为id和text
	//模型预测产生label列
    val test = spark.createDataFrame(Seq(
      (4L, "spark i j k"),
      (5L, "l m n"),
      (6L, "mapreduce spark"),
      (7L, "apache hadoop")
    )).toDF("id", "text")
	//调用cvModel的transform()方法，生成probability列和prediction列。
	//打印输出结果。
    cvModel.transform(test)
      .select("id", "text", "probability", "prediction")
      .collect()
      .foreach { case Row(id: Long, text: String, prob: Vector, prediction: Double) =>
        println(s"($id, $text) --> prob=$prob, prediction=$prediction")
      }
	//打印输出lrModel最优参数值。在Pipeline中，LogisticRegressionModel的索引值为2
    val bestModel = cvModel.bestModel.asInstanceOf[PipelineModel]
    val lrModel = bestModel.stages(2).asInstanceOf[LogisticRegressionModel]
    println(lrModel.getRegParam)
    println(lrModel.numFeatures)
    spark.stop()
  }
}
