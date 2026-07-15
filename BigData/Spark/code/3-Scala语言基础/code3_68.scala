object Demo {
     def main(args: Array[String]) {

        //创建迭代器
  	    val iter = Iterator("Hadoop","Spark","Scala")

        //循环输出迭代器指向对象中的所有元素
        for (elem <- iter) {
    			println(elem)
                   }
      }
 }
