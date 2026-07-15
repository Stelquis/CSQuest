import org.apache.spark.ml.feature.Binarizer
import org.apache.spark.sql.SparkSession
object BinarizerExample {
  def main(args: Array[String]): Unit = {
    //SparkSession.builder创建实例，并设置运行模式等配置信息
    val spark = SparkSession.builder
      .master("local")
      .appName("BinarizerExample")
      .getOrCreate()
	
    //创建数据集，createDataFrame方法创建DataFrame，列名为id和feature
    val data = Array((0, 0.1), (1, 0.8), (2, 0.2))
    val dataFrame = spark.createDataFrame(data).toDF("id", "feature")
	
    //创建Binarizer（Transformer）实例，
	//设置输入列（操作列）名为feature，输出列为binarized_feature，阈值为0.5
    val binarizer: Binarizer = new Binarizer()
      .setInputCol("feature")
      .setOutputCol("binarized_feature")
      .setThreshold(0.5)
    //调用binarizer的transform()方法，生成结果。
    val binarizedDataFrame = binarizer.transform(dataFrame)
    //打印输出阈值以及二值化以后的结果
    println(s"Binarizer output with Threshold = ${binarizer.getThreshold}")
    binarizedDataFrame.show()
    spark.stop()
  }
}
