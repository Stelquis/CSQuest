
import org.apache.log4j.{Level, Logger}
import org.apache.spark.ml.feature.RFormula
import org.apache.spark.sql.SparkSession

object RFormulaExample {
  def main(args: Array[String]): Unit = {
    Logger.getLogger("org.apache.spark").setLevel(Level.WARN)
    Logger.getLogger("org.eclipse.jetty.server").setLevel(Level.OFF)
	//SparkSession.builder创建实例，设置运行模式等配置信息
    val spark = SparkSession
      .builder
        .master("local")
      .appName("RFormulaExample")
      .getOrCreate()

    //创建数据集。createDataFrame()方法创建数据集，列名为id、country、hour、clicked
    val dataset = spark.createDataFrame(Seq(
      (7, "US", 18, 1.0),
      (8, "CA", 12, 0.0),
      (9, "NZ", 15, 0.0)
    )).toDF("id", "country", "hour", "clicked")
	//创建RFormula实例
	//设置R公式为：clicked ~ country + hour，特征列名为features，标签列为label
    val formula = new RFormula()
      .setFormula("clicked ~ country + hour")
      .setFeaturesCol("features")
      .setLabelCol("label")
	
	//调用formula的fit方法生成RFormulaModel（Transformer），
	//再调用transform()方法，生成结果
    val output = formula.fit(dataset).transform(dataset)
    output.select("features", "label").show()
    
	//打印输出结果
    spark.stop()
  }
}
