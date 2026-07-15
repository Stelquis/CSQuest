import Array._
object Demo {
    def main(args: Array[String]) {
       //定义三行三列的整型二维数组
       var myMatrix = ofDim[Int](3,3)

       //给各元素赋值
       for (i <- 0 to 2) {
          for ( j <- 0 to 2) {
              myMatrix(i)(j) = j
          }
       }

       // 打印二维数组
       for (i <- 0 to 2) {
          for ( j <- 0 to 2) {
             print(" " + myMatrix(i)(j))
           }
          println()
        }
     }
}
