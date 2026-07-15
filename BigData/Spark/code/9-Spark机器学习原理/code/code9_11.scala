import org.apache.spark.ml.evaluation.RegressionEvaluator
import org.apache.spark.ml.regression.LinearRegression
import org.apache.spark.ml.tuning.{ParamGridBuilder, TrainValidationSplit}
import org.apache.spark.sql.SparkSession
object ModelSelectionViaTrainValidationSplitExample {
  def main(args: Array[String]): Unit = {
    val spark = SparkSession.builder
      .master("local")
      .appName("ModelSelectionViaTrainValidationSplitExample")
      .getOrCreate()
    //创建数据集。加载本地路径文件，按"libsvm"类型文件读取，创建DataFrame。
    val data = spark.read.format("libsvm")
      .load("data/sample_linear_regression_data.txt")
	//使用randomSplit方法，将DataFrame分为训练集和测试集
    val Array(training, test) = data.randomSplit(Array(0.9, 0.1), seed = 12345)
	//创建LinearRegression（Estimator）实例。设置最大迭代次数
    val lr = new LinearRegression()
      .setMaxIter(10)
    //创建ParamGridBuilder实例，创建参数网格
    //TrainValidationSplit将使用Evaluator尝试所有参数值的组合，并确定使用最佳模型
    val paramGrid = new ParamGridBuilder()
      .addGrid(lr.regParam, Array(0.1, 0.01))
      .addGrid(lr.fitIntercept)
      .addGrid(lr.elasticNetParam, Array(0.0, 0.5, 1.0))
      .build()
	  
    //创建TrainValidationSplit实例
    //TrainValidationSplit需要设置的参数包括：
    //一个Estimator，一组Estimator的ParamMap，一个Evaluator
    val trainValidationSplit = new TrainValidationSplit()
      .setEstimator(lr)
      .setEvaluator(new RegressionEvaluator)
      .setEstimatorParamMaps(paramGrid)
      //设置80%的数据用于训练，20%的数据用于验证
      .setTrainRatio(0.8)
	  //设置最多并行评估两个参数设置
      .setParallelism(2)
    
	//调用TrainValidationSplit（Estimator）的fit()方法，
    //训练生成TrainValidationSplitModel(Transformer)
    val model = trainValidationSplit.fit(training)
    
	//使用最优参数组合的模型预测测试集的结果，并打印输出。
    model.transform(test)
      .select("features", "label", "prediction")
      .show()
    spark.stop()
  }
}
