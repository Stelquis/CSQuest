
import org.apache.log4j.{Level, Logger}
import org.apache.spark.ml.feature.MinMaxScaler
import org.apache.spark.ml.linalg.Vectors

import org.apache.spark.sql.SparkSession

object MinMaxScalerExample {
  def main(args: Array[String]): Unit = {
    Logger.getLogger("org.apache.spark").setLevel(Level.WARN)
    Logger.getLogger("org.eclipse.jetty.server").setLevel(Level.OFF)
	//SparkSession.builder创建实例，并设置运行模式等配置信息
    val spark = SparkSession
      .builder
      .master("local")
      .appName("MinMaxScalerExample")
      .getOrCreate()

    //创建数据集，createDataFrame()方法创建DataFrame，列名为id和features
    val dataFrame = spark.createDataFrame(Seq(
      (0, Vectors.dense(1.0, 0.1, -1.0)),
      (1, Vectors.dense(2.0, 1.1, 1.0)),
      (2, Vectors.dense(3.0, 10.1, 3.0))
    )).toDF("id", "features")
	//创建MinMaxScaler（Estimator）实例，
	//设置输入列（操作列）名为features，输出列为scaledFeatures

    val scaler = new MinMaxScaler()
      .setInputCol("features")
      .setOutputCol("scaledFeatures")

    //调用scaler的fit()方法，生成MinMaxScalerModel（Transformer）
    val scalerModel = scaler.fit(dataFrame)

    //调用scalerModel的transform()方法，生成结果
    val scaledData = scalerModel.transform(dataFrame)
    println(s"Features scaled to range: [${scaler.getMin}, ${scaler.getMax}]")
	//打印最小值、最大值以及最大最小值缩放后的结果。
    scaledData.select("features", "scaledFeatures").show()
    spark.stop()
  }
}