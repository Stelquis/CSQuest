object Demo {
     def main(args: Array[String]) {

        //创建映射
        val colors = Map("red" -> "#FF0000", "azure" -> "#F0FFFF","peru" -> "#CD853F")
      
        //使用for循环输出键值对
        for ((k,v) <- colors) printf("Color is : %s and the code is: %s\n",k,v)

        //使用foreach输出键值对
        colors.keys.foreach{ i =>  
            print( "Key = " + i )
            println(" Value = " + colors(i) )
        }

    } 
}
