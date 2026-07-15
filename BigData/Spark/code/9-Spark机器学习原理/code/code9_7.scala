import java.util.Arrays
import org.apache.spark.ml.attribute.{Attribute, AttributeGroup, NumericAttribute}
import org.apache.spark.ml.feature.VectorSlicer
import org.apache.spark.ml.linalg.Vectors
import org.apache.spark.sql.{Row, SparkSession}
import org.apache.spark.sql.types.StructType

object VectorSlicerExample {
  def main(args: Array[String]): Unit = {
	//SparkSession.builder创建实例，并设置运行模式等配置信息
    val spark = SparkSession.builder
      .master("local")
      .appName("VectorSlicerExample")
      .getOrCreate()
	  
    //创建行向量数组
	//向量分为稠密向量（dense vector）和稀疏向量（sparse vector）
	//其中稀疏向量创建有两种方式：
	//Vector.sparse(向量大小，索引数组，与索引数组对应的数值数组)
	//Vector.sparse(向量大小，Seq((索引，数值)，(索引，数值)，…，(索引，数值))
    val data = Arrays.asList(
	//等同于Vectors.dense(-2.0,2.3,0)
      Row(Vectors.sparse(3, Seq((0, -2.0), (1, 2.3)))),
      Row(Vectors.dense(-2.0, 2.3, 0.0)) //Creates a dense vector from a double array
    )
    
	//设置字符串索引
    val defaultAttr = NumericAttribute.defaultAttr
    val attrs = Array("f1", "f2", "f3").map(defaultAttr.withName)
    val attrGroup = new AttributeGroup("userFeatures",
      attrs.asInstanceOf[Array[Attribute]])
    //创建数据集。createDataFrame()方法创建DataFrame，设置列名为userFeatures
    val dataset = spark.createDataFrame(data,
      StructType(Array(attrGroup.toStructField())))
	  
    //创建VectorSlicer实例，
	//设置输入列（操作列）名为userFeatures，输出列名为features
    val slicer = new VectorSlicer().setInputCol("userFeatures").setOutputCol("features")
    //设置整数索引1，即取整数索引为1的数值（整数索引从0开始）
	//设置字符串索引为"f3"，即取字符串索引为"f3"的数值
    slicer.setIndices(Array(1)).setNames(Array("f3"))
    val output = slicer.transform(dataset)
    output.show(false)
    spark.stop()
  }
}
