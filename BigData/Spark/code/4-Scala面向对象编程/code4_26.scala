trait PhoneId{
   var id: Int
   def currentId(): Int     //定义了一个抽象方法
}

trait PhoneGreeting{
   def greeting(msg: String) { println(msg) }  
}

//使用extends关键字混入第1个特质，后面可以反复使用with关键字混入更多特质
class ApplePhoneId extends PhoneId with PhoneGreeting{
     override var id = 10000  //Apple手机编号从10000开始
     def currentId(): Int = {id += 1; id}  //返回手机编号
}

//使用extends关键字混入第1个特质，后面可以反复使用with关键字混入更多特质
class HuaWeiPhoneId extends PhoneId with PhoneGreeting{ 
    override var id = 20000  //HuaWei手机编号从10000开始
    def currentId(): Int = {id += 1; id}  //返回手机编号
} 


object TraitPhone_02{ 

   def main(args: Array[String]){
        val myPhone1 = new ApplePhoneId()       
        val myPhone2 = new HuaWeiPhoneId ()
        myPhone1.greeting("Welcome my first phone.")
        printf("My first PhoneId is %d.\n",myPhone1.currentId)        
        myPhone2.greeting("Welcome my second phone.")
        printf("My second PhoneId is %d.\n",myPhone2.currentId)
    }
}
