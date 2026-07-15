object Demo {
     def main(args: Array[String]) {

        //创建Set
        val fruit = Set("apples", "oranges", "pears")
        val nums: Set[Int] = Set()

        //输出Set的第一个元素
        println( "Head of fruit : " + fruit.head )

        //输出Set的除第一个元素之外的所有元素
        println( "Tail of fruit : " + fruit.tail )

       //判断Set是否为空
        println( "Check if fruit is empty : " + fruit.isEmpty )
        println( "Check if nums is empty : " + nums.isEmpty )
     }
}
