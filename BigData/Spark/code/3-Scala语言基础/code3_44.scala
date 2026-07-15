import Array._
object Demo {
     def main(args: Array[String]) {
        var myList1 = Array(1.9, 2.9, 3.4, 3.5)
           
        //生成新的数组myList2
        var myList2 = for(x<-myList1)yield x+1
      
        // 输出所有数组元素
        for ( x <- myList2) {
           println( x )
        }
     }
}
