object Demo {
     def main(args: Array[String]) {

        //定义Option
        val a:Option[Int] = Some(5)
        val b:Option[Int] = None 
      
        //设置没有值时默认为0
        println("a.getOrElse(0): " + a.getOrElse(0) )
      
        //设置没有值时默认为10
        println("b.getOrElse(10): " + b.getOrElse(10) )
     }
}
