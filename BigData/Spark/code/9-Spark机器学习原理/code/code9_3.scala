import org.apache.spark.ml.feature.{HashingTF, IDF, Tokenizer}
import org.apache.spark.sql.SparkSession

object TFIDF_Example {
  def main(args: Array[String]) {
	//SparkSession.builder创建实例，并设置运行模式等配置信息
    val spark = SparkSession.builder
      .master("local")
      .appName("TfIdfExample")
      .getOrCreate()
	  
	//创建数据集。createDataFrame()方法创建，列名为label和sentence
    val sentenceData = spark.createDataFrame(Seq(
      (0.0, "Hi I heard about Spark"),
      (0.0, "I wish Java could use case classes"),
      (1.0, "Logistic regression models are neat")
    )).toDF("label", "sentence")
	
    //创建Tokenizer（Transformer）实例，
	//并设置输入列（操作列）名为sentence，输出列名为words
    val tokenizer = new Tokenizer().setInputCol("sentence").setOutputCol("words")
    //调用tokenizer的transform()方法，生成包含words列的新的DataFrame
    val wordsData = tokenizer.transform(sentenceData)
	
    //创建HashingTF（Transformer）实例，
	//并设置输入列（操作列）名为words，输出列名为rawFeatures，维数为20
    val hashingTF = new HashingTF()
      .setInputCol("words").setOutputCol("rawFeatures").setNumFeatures(20)
    //调用hashingTF的transform()方法，生成包含rawFeatures列的新的DataFrame
    val featurizedData = hashingTF.transform(wordsData)
	
    //创建IDF（Estimator）实例，
	//并设置输入列（操作列）名为rawFeatures，输出列名为features
    val idf = new IDF().setInputCol("rawFeatures").setOutputCol("features")
    //调用idf的fit()方法，训练生成IDFModel（Transformer）
    val idfModel = idf.fit(featurizedData)
    //调用IDFModel的transform()方法，生成包含features列的新的DataFrame
    val rescaledData = idfModel.transform(featurizedData)
	//打印输出结果的label列和feature列，show()方法默认为true，只显示前20个字符
    rescaledData.select("label", "features").show(false)
    spark.stop()
  }
}
