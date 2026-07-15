import Array._
object Demo {
    def main(args: Array[String]) {

      //使用Range生成数组
      var myList1 = range(10, 20, 2)
      var myList2 = range(10,20)

      // 打印所有数组元素
       for ( x <- myList1 ) {
         print( " " + x )
       }
      println()

       for ( x <- myList2 ) {
         print( " " + x )
       }
    }
}
