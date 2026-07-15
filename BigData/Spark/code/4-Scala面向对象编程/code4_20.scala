//定义Phone类，带主构造函数
class Phone(var phoneBrand:String,var price:Int){
   //类中执行语句会在调用主构造函数时执行
   println("执行Phone类的主构造函数")
}

//定义Apple类，继承自Phone类，同样也带主构造函数
class Apple(phoneBrand:String,price:Int)extends Phone(phoneBrand,price){
    //类中执行语句会在调用主构造函数时执行
     println("执行Apple类的主构造函数")
}

object TestPhone_01{
     def main(args:Array[String]){
           //创建子类对象时，先调用父类的主构造函数，然后调用子类的主构造函数
        new Apple("iphone",5400)
      }
}
