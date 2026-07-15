import org.apache.spark.{SparkConf,SparkContext}

object code1_1 {
    def main(args: Array[String]): Unit = {

        // 第一步：初始化配置
        val conf = new SparkConf().setMaster("local").setAppName("wordcount")

        // 第二步：创建SparkContext对象,SparkContext是Spark的所有功能的入口
        val sc = new SparkContext(conf)

        // 第三步：创建一个初始的RDD
        val lines = sc.textFile("./src/word")   //括号中为文件路径
        println(lines.collect().mkString("\n"))

        // 第四步：对初始的RDD进行transformation操作，也就是一些计算操作
        // 把单词用空格拆开
        val words = lines.flatMap(line => line.split(" "))
        println(words.collect().mkString("\n"))

        // 将每一个单词映射为（单词,1）的这种格式
        val word_transform = words.map(word => (word,1))
        println(word_transform.collect().mkString("\n"))

        // 以单词作为key,统计每个单词出现的次数
        val count = word_transform.reduceByKey{case(x,y) => x+y}
        println(count.collect().mkString("\n"))

        // 空格拆分单词并统计单词数目的另一种写法
        // val count = words.map(word => (word,1)).reduceByKey{case(x,y) => x+y}
    }
}
