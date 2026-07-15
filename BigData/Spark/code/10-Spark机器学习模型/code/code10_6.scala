import org.apache.spark.ml.fpm.FPGrowth
import org.apache.spark.sql.SparkSession

object FPGrowthExample {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder
    .master("local")
    .appName(s"${this.getClass.getSimpleName}")
    .getOrCreate()
	//隐式将RDD转换为DataFrame需要的包
    import spark.implicits._
	//隐式创建DataFrame，列名为items
    val dataset = spark.createDataset(Seq(
      "I1 I2 I5",
      "I2 I4",
      "I3 I4 I5",
      "I1 I2 I4 I5",
      "I4 I5")).map(t => t.split(" ")).toDF("items")
    //创建FPGrowth示例，
    //设置Items列（输入列）名为items，最小支持度为0.4，最小置信度为0.6
    val fpgrowth = new FPGrowth().setItemsCol("items")
    .setMinSupport(0.4).setMinConfidence(0.6)
    //调用fit()方法，生成FPGrowthModel（Transformer）
    val model = fpgrowth.fit(dataset)
    //调用model的freqItemsets.show打印输出频繁项集
    model.freqItemsets.show()
    //调用model的associationRules.show打印关联规则
    model.associationRules.show()
    //调用model的transform方法，生成结果，show方法
    model.transform(dataset).show()
    spark.stop()
  }
}