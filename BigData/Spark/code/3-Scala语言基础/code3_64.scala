object Demo {
     def main(args: Array[String]) {
      
        //创建映射
        val capitals = Map("France" -> "Paris", "Japan" -> "Tokyo")
      
        //查找记录的具体值
        println("show(capitals.get( \"Japan\")) : " + show(capitals.get( "Japan")) )
        println("show(capitals.get( \"India\")) : " + show(capitals.get( "India")) )
      }
   
    //定义可选值分离函数
    def show(x: Option[String]) = x match {
       case Some(s) => s
       case None => "?"
    }

}
