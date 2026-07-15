object Demo {
     def main(args: Array[String]) {
        val fruit = "apples" :: ("oranges" :: ("pears" :: Nil))
        val nums = Nil

        //输出List的第一个元素
        println( "Head of fruit : " + fruit.head )

        //输出List的除第一个元素之外的所有元素
        println( "Tail of fruit : " + fruit.tail )

        //判断List是否为空
        println( "Check if fruit is empty : " + fruit.isEmpty )
        println( "Check if nums is empty : " + nums.isEmpty )  
     }
  }
