// import java.util.Arrays;
// import java.util.Iterator;
// import org.apache.spark.SparkConf;
// import org.apache.spark.api.java.JavaPairRDD;
// import org.apache.spark.api.java.JavaRDD;
// import org.apache.spark.api.java.JavaSparkContext;
// import org.apache.spark.api.java.function.FlatMapFunction;
// import org.apache.spark.api.java.function.Function2;
// import org.apache.spark.api.java.function.PairFunction;
// import org.apache.spark.api.java.function.VoidFunction;
// import scala.Tuple2;

// public class code1_3 {
//     public static void main(String[] args) {
//         // 第一步：初始化配置
//         SparkConf conf = new SparkConf().setMaster("local").setAppName("wordcount");

//         // 第二步：创建JavaSparkContext对象，SparkContext是Spark的所有功能的入口
//         JavaSparkContext sc = new JavaSparkContext(conf);

//         // 第三步：创建一个初始的RDD
//         // SparkContext中，用于根据文件类型的输入源创建RDD的方法，叫做textFile()方法
//         JavaRDD<String> lines = sc.textFile("./src/word");

//         // 第四步：对初始的RDD进行transformation操作，也就是一些计算操作
//         // 首先把单词用空格拆开
//         JavaRDD<String> words = lines.flatMap(new FlatMapFunction<String, String>() {
//             private static final long serialVersionUID = 1L;
//             @Override
//             public Iterator<String> call(String line) throws Exception {
//                 return Arrays.asList(line.split(" ")).iterator();
//             }
//         });

//         // 将每一个单词，映射为（单词，1）的这种格式
//         JavaPairRDD<String, Integer> pairs = words.mapToPair(new PairFunction<String, String, Integer>() {
//             private static final long serialVersionUID = 1L;
//             @Override
//             public Tuple2<String, Integer> call(String word) throws Exception {
//                 return new Tuple2<String, Integer>(word, 1);
//             }
//         });

//         // 以单词作为key，统计每个单词出现的次数
//         JavaPairRDD<String, Integer> wordCounts = pairs.reduceByKey(new Function2<Integer, Integer, Integer>() {
//             private static final long serialVersionUID = 1L;
//             @Override
//             public Integer call(Integer v1, Integer v2) throws Exception {
//                 return v1 + v2;
//             }
//         });

//         // 用action操作foreach来执行
//         wordCounts.foreach(new VoidFunction<Tuple2<String,Integer>>() {
//             private static final long serialVersionUID = 1L;
//             @Override
//             public void call(Tuple2<String, Integer> wordCount) throws Exception {
//                 System.out.println(wordCount);
//             }
//         });
//         sc.close();
//     }
// }
