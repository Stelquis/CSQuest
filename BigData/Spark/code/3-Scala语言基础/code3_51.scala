object Demo {
     def main(args: Array[String]) {

        //创建List
        val fruit1 = "apples" :: ("oranges" :: ("pears" :: Nil))
        val fruit2 = "mangoes" :: ("banana" :: Nil)

        // 使用 ::: 操作符连接两个或者多个列表    
        var fruit = fruit1 ::: fruit2
        println( "fruit1 ::: fruit2 : " + fruit )
      
        // 使用集合.:::()方法连接两个列表
        fruit = fruit1.:::(fruit2)
        println( "fruit1.:::(fruit2) : " + fruit )

        // 通过两个或多个列表作为参数。
        fruit = List.concat(fruit1, fruit2)
        println( "List.concat(fruit1, fruit2) : " + fruit)
     }
}
