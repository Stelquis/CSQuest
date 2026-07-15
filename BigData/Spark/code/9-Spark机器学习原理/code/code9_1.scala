import org.apache.spark.ml.classification.LogisticRegression
import org.apache.spark.ml.linalg.{Vector, Vectors}
import org.apache.spark.ml.param.ParamMap
import org.apache.spark.sql.Row
import org.apache.spark.sql.SparkSession

object EstimatorTransformerParam_Example {
  def main(args: Array[String]): Unit = {
    // SparkSession.builder创建一个SparkSession实例，设置运行模式等配置信息
    val spark = SparkSession.builder
      .master("local")
      .appName("EstimatorTransformerParamExample")
      .getOrCreate()
    
	//创建训练集。createDataFrame()方法根据元组(label，vector)的序列，
	//创建DataFrame，
	//toDF()方法设置DataFrame的两列数据的列名，分别为“label”、“features”。
    val training = spark.createDataFrame(Seq(
      (1.0, Vectors.dense(0.0, 1.1, 0.1)),
      (0.0, Vectors.dense(2.0, 1.0, -1.0)),
      (0.0, Vectors.dense(2.0, 1.3, 1.0)),
      (1.0, Vectors.dense(0.0, 1.2, -0.5))
    )).toDF("label", "features")
    //创建LogisticRegression（Estimator）实例lr。
    val lr = new LogisticRegression()
    //打印参数、文档、默认值。
    println(s"LogisticRegression parameters:\n ${lr.explainParams()}\n")
    
	//设置参数的第一种方式：setter方法
    lr.setMaxIter(10)
      .setRegParam(0.01)
    
	//training输入lr的方法fit()中，训练生成LogisticRegession模型model，属于Transformer
	//设置的参数存储在lr中

    val model1 = lr.fit(training)
    //打印lr在fit()操作中使用的参数。打印结果中，参数以(名称，值)键值对的形式呈
	//现，其中LogisticRegression实例的名称有唯一的ID

    println(s"Model 1 was fit using parameters: ${model1.parent.extractParamMap}")
    
	//设置参数的第二种方法：ParamMap方法
	//ParamMap通过参数映射的方式，改变最大迭代次数

    val paramMap = ParamMap(lr.maxIter -> 20)
      .put(lr.maxIter, 30) // Specify 1 Param. This overwrites the original maxIter.
      .put(lr.regParam -> 0.1, lr.threshold -> 0.55) // Specify multiple Params.
    
	// ParamMap也可以组合设置参数值
    val paramMap2 = ParamMap(lr.probabilityCol -> "myProbability") // Change output column name.
    val paramMapCombined = paramMap ++ paramMap2
    
	//使用paramMapCombined参数，训练生成新模型model2，属于Transformer
    val model2 = lr.fit(training, paramMapCombined)
    println(s"Model 2 was fit using parameters: ${model2.parent.extractParamMap}")
    
	//创建测试集
    val test = spark.createDataFrame(Seq(
      (1.0, Vectors.dense(-1.0, 1.5, 1.3)),
      (0.0, Vectors.dense(3.0, 2.0, -0.1)),
      (1.0, Vectors.dense(0.0, 2.2, -1.5))
    )).toDF("label", "features")
    //model2调用transform()方法，输入测试集test，输出带有预测列的新的DataFrame
    model2.transform(test)
      .select("features", "label", "myProbability", "prediction")
      .collect()
      .foreach { case Row(features: Vector, label: Double, prob: Vector, prediction: Double) => println(s"($features, $label) -> prob=$prob, prediction=$prediction")
      }
    spark.stop()
  }
}
