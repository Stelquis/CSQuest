object Demo {
     def main(args: Array[String]) {
         var myList = Array(1.9, 2.9, 3.4, 3.5)

         // 直接数组遍历输出所有元素
         for ( x <- myList ) {
            println( x )
         }

        // 所有元素求和
         var total = 0.0;
      
        //索引遍历所有元素，进行累加操作
        for ( i <- 0 to (myList.length - 1)) {
              total += myList(i)  
         }

        println("Total is " + total)

        // 索引遍历所有元素，寻找数组最大值
        var max = myList(0)
        for ( i <- 1 to (myList.length - 1) ) {
           if (myList(i) > max) max = myList(i)
        }

        println("Max is " + max);
     }
}
