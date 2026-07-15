object Demo {
     def main(args: Array[String]) {
        println(matchTest(5))
      }
   
     def matchTest(x: Int): String = x match {
       case 1 => "one"
       case 2 => "two"
       case 3 => "three"
       case unexpected => unexpected + " is Not Allowed"
     }
}