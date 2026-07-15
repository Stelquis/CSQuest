class Phone(var phoneBrand:String,var price:Int){
    //瀵圭埗绫籄ny涓殑toString鏂规硶杩涜閲嶅啓
   override def toString=s"Phone($phoneBrand,$price)"
}

class Apple(phoneBrand:String,price:Int,var place:String)extends Phone(phoneBrand,price){
   //瀵圭埗绫籔hone涓殑toString鏂规硶杩涜閲嶅啓
   override def toString=s"Apple($phoneBrand,$price,$place)"
}

object TestPhone_02{
     def main(args:Array[String]){
      //璋冪敤Apple绫昏嚜韬殑toString鏂规硶杩斿洖缁撴灉
     println(new Apple("iphone",5400,"Shenzhen"))
     }
}
