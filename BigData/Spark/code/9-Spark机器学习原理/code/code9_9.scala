
import org.apache.log4j.{Level, Logger}
import org.apache.spark.ml.feature.ChiSqSelector
import org.apache.spark.ml.linalg.Vectors
import org.apache.spark.sql.SparkSession

object ChiSqSelectorExample {
  def main(args: Array[String]) {
    Logger.getLogger("org.apache.spark").setLevel(Level.WARN)
    Logger.getLogger("org.eclipse.jetty.server").setLevel(Level.OFF)
	//SparkSession.builder创建实例，设置运行模式等配置信息
    val spark = SparkSession
      .builder
        .master("local")
      .appName("ChiSqSelectorExample")
      .getOrCreate()
	 //隐式将RDD转换成DataFrame需要的包
    import spark.implicits._
    val data = Seq(
      (7, Vectors.dense(0.0, 0.0, 18.0, 1.0), 1.0),
      (8, Vectors.dense(0.0, 1.0, 12.0, 0.0), 0.0),
      (9, Vectors.dense(1.0, 0.0, 15.0, 0.1), 0.0)
    )
	//隐式创建DataFrame，列名为id、feature、clicked。
    val df = spark.createDataset(data).toDF("id", "features", "clicked")
	//创建ChiSqSelector（Estimator）实例，
	//设置提取预测能力最强的第一个特征
	//设置特征列名为features，设置标签列名为clicked，设置输出列名为selectedFeatures

    val selector = new ChiSqSelector()
      .setNumTopFeatures(1)
      .setFeaturesCol("features")
      .setLabelCol("clicked")
      .setOutputCol("selectedFeatures")
	//调用selector的fit()方法，生成ChiSqSelectorModel（Transformer），
	//再调用transform()方法，生成结果
    val result = selector.fit(df).transform(df)

    println(s"ChiSqSelector output with top ${selector.getNumTopFeatures} features selected")
    result.show()

    spark.stop()
  }
}
