import org.apache.spark.ml.regression.LinearRegression
import org.apache.spark.sql.SparkSession
import org.graphframes
object LinearRegressionWithElasticNetExample {

  def main(args: Array[String]): Unit = {
    val spark = SparkSession
      .builder
      .appName("LinearRegressionWithElasticNetExample")
      .master("local")
      .getOrCreate()

    // 把以libsvm格式存储的数据加载为DataFrame
    val training = spark.read.format("libsvm")
      .load("data/sample_linear_regression_data.txt")

    //新建线性回归实例
    val lr = new LinearRegression()
      .setMaxIter(10)//最大迭代次数10
      .setRegParam(0.3)//正则化参数0.3
      .setElasticNetParam(0.8)//弹性网络参数0.8

    // 训练线性回归模型
    val lrModel = lr.fit(training)

    // 打印线性回归的系数和截距
    println(s"Coefficients: ${lrModel.coefficients} Intercept: ${lrModel.intercept}")

    // 提取训练集上的模型摘要并打印评估指标
    val trainingSummary = lrModel.summary
	//打印迭代次数
    println(s"numIterations: ${trainingSummary.totalIterations}")
	//打印每次迭代的结果
    println(s"objectiveHistory: [${trainingSummary.objectiveHistory.mkString(",")}]")
	//输出残差（label - predicted）
    trainingSummary.residuals.show()
	//打印均方根误差RMSE
    println(s"RMSE: ${trainingSummary.rootMeanSquaredError}")
	//打印R平方系数
    println(s"r2: ${trainingSummary.r2}")
    spark.stop()
  }
}
