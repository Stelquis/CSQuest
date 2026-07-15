object Demo {
     def main(args: Array[String]) {
  
       //创建映射
        val colors = Map("red" -> "#FF0000", "azure" -> "#F0FFFF", "peru" -> "#CD853F")
        val nums: Map[Int, Int] = Map()

        //输出映射中的键
        println( "Keys in colors : " + colors.keys )

        //输出映射中的值
        println( "Values in colors : " + colors.values )

        //判断映射是否为空
        println( "Check if colors is empty : " + colors.isEmpty )
        println( "Check if nums is empty : " + nums.isEmpty )
     }
}
