object Demo {

     def main(args: Array[String]) {
        println( factorial(3) )
     }

     //璁＄畻闃朵箻
     def factorial(i: Int): Int = {
        def fact(i: Int, accumulator: Int): Int = {
           if (i <= 1)
              accumulator
           else
              fact(i - 1, i * accumulator)    
         }
    
    //璋冪敤鍐呴儴鍑芥暟
        fact(i, 1) 
     }
}
