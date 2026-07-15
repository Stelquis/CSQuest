object Demo {
     def main(args: Array[String]) {

        //瀹氫箟Option
        val a:Option[Int] = Some(5)
        val b:Option[Int] = None 
      
       //鍒ゆ柇Option鏄惁涓虹┖
        println("a.isEmpty: " + a.isEmpty )
        println("b.isEmpty: " + b.isEmpty )
    }
}
