object Demo {
   def main(args: Array[String]) {

      //创建Set
      val num = Set(5,6,9,20,30,45)

      //在集合中查找最大值与最小值
      println( "Min element in Set(5,6,9,20,30,45) : " + num.min )
      println( "Max element in Set(5,6,9,20,30,45) : " + num.max )
     }
}
