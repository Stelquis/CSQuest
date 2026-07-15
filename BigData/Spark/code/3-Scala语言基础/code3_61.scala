object Demo {
   def main(args: Array[String]) {

      //鍒涘缓鏄犲皠
      val colors = Map("red" -> "#FF0000", "azure" -> "#F0FFFF", "peru" -> "#CD853F")

     //鍒ゆ柇鏄犲皠涓槸鍚﹀寘鍚敭"red"
      if( colors.contains( "red" )) {
         println("Red key exists with value :"  + colors("red"))
      } else {
           println("Red key does not exist")
      }

     //鍒ゆ柇鏄犲皠涓槸鍚﹀寘鍚敭"maroon"
      if( colors.contains( "maroon" )) {
         println("Maroon key exists with value :"  + colors("maroon"))
      } else {
         println("Maroon key does not exist")
      }
    }
}
