object Demo {
     def main(args: Array[String]) {
      
        // 重复元素apples ,3次
        val fruit = List.fill(3)("apples") 
        println( "fruit : " + fruit  )

       //重复元素2 ,10 次 
       val num = List.fill(10)(2)        
       println( "num : " + num)
     }
}
