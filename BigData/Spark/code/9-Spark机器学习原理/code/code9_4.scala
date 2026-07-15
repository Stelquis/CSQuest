
package org.apache.spark.examples.ml

// $example on$
import org.apache.spark.ml.feature.Word2Vec
import org.apache.spark.ml.linalg.Vector
import org.apache.spark.sql.Row
// $example off$
import org.apache.spark.sql.SparkSession

object Word2VecExample {
  def main(args: Array[String]) {
	//SparkSession.builder创建实例，设置运行模式等配置信息
    val spark = SparkSession
      .builder
      .master("local")
      .appName("Word2Vec example")
      .getOrCreate()

    //数据集创建DataFrame，列名为text
    val documentDF = spark.createDataFrame(Seq(
      "Hi I heard about Spark".split(" "),
      "I wish Java could use case classes".split(" "),
      "Logistic regression models are neat".split(" "),
      "Logistic regression models are like".split(" ")
    ).map(Tuple1.apply)).toDF("text")

    //创建Word2vec（Estimator）实例，
	//并设置输入列（操作列）名为text，输出列名为result，向量维数为3，
	//setMinCount(0)设置为0，词频少于设定值（0）的词会被丢弃

    val word2Vec = new Word2Vec()
      .setInputCol("text")
      .setOutputCol("result")
      .setVectorSize(3)
      .setMinCount(0)
	//word2Vec调用fit()方法，生成Word2VecModel（Transformer）
    val model = word2Vec.fit(documentDF)
	//model调用transform()方法，将文档转变为向量。
    val result = model.transform(documentDF)
	//打印输出结果
    result.select("text", "result").show(false)

    spark.stop()
  }
}
