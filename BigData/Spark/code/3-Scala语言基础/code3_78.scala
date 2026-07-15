object Demo {
     def main(args: Array[String]) {
      
       //求5的阶乘
        println(factorial(5,1)) 

      //尾递归求阶乘
      @annotation.tailrec //告诉编译器要尾递归
      def factorial(n:Int,m:Int):Int={
           if(n<=0) m
           else factorial(n-1,m*n) 
        }     
    }
}
