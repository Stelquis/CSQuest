import org.apache.spark.ml.{Pipeline, PipelineModel}
import org.apache.spark.ml.classification.LogisticRegression
import org.apache.spark.ml.feature.{HashingTF, Tokenizer}
import org.apache.spark.ml.linalg.Vector
import org.apache.spark.sql.Row
import org.apache.spark.sql.SparkSession

object Pipeline_Example {

  def main(args: Array[String]): Unit = {
    //SparkSession.builder创建实例spark，并设置运行模式等配置信息
    val spark = SparkSession
      .builder
      .master("local")
      .appName("PipelineExample")
      .getOrCreate()

    //创建训练集。createDataFrame()方法创建，列名为id，text，label
    val training = spark.createDataFrame(Seq(
      (0L, "a b c d e spark", 1.0),
      (1L, "b d", 0.0),
      (2L, "spark f g h", 1.0),
      (3L, "hadoop mapreduce", 0.0)
    )).toDF("id", "text", "label")
	
    //实例化三个stage：Tokenizer、HashingTF、LogisticRegression，设置参数
    val tokenizer = new Tokenizer()
      .setInputCol("text")
      .setOutputCol("words")
    val hashingTF = new HashingTF()
      .setNumFeatures(1000)
      .setInputCol(tokenizer.getOutputCol)
      .setOutputCol("features")
    val lr = new LogisticRegression()
      .setMaxIter(10)
      .setRegParam(0.001)
	//实例化Pipeline，设置stages序列为Array(tokenizer,hashingTF,lr)
    val pipeline = new Pipeline()
      .setStages(Array(tokenizer, hashingTF, lr))
	  
    //pipeline调用fit()方法，输入训练集数据，生成pipelineModel（Transformer）。
    val model = pipeline.fit(training)
	
    //保存PipelineModel到本地路径
    model.write.overwrite().save("/tmp/spark-logistic-regression-model")
    //保存未训练的Pipeline实例（Estimator）到本地路径
    pipeline.write.overwrite().save("/tmp/unfit-lr-model")
    //加载保存本地路径的PipelineModel
    val sameModel = PipelineModel.load("/tmp/spark-logistic-regression-model")
	
    //创建测试集。createDataFrame()方法创建，列名为id和text
    val test = spark.createDataFrame(Seq(
      (4L, "spark i j k"),
      (5L, "l m n"),
      (6L, "spark hadoop spark"),
      (7L, "apache hadoop")
    )).toDF("id", "text")
	
    //model调用transform()方法，输入测试集test，输出带有预测列的新的DataFrame
    model.transform(test)
      .select("id", "text", "probability", "prediction")
      .collect()
      .foreach { case Row(id: Long, text: String, prob: Vector, prediction: Double) =>
        println(s"($id, $text) --> prob=$prob, prediction=$prediction")
      }
    spark.stop()
  }
}
