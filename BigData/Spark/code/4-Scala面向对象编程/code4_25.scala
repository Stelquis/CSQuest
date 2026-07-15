trait PhoneId{
    var id: Int
    def currentId(): Int     //定义了一个抽象方法
}

class ApplePhoneId extends PhoneId{  //使用extends关键字
   override var id = 10000  //Apple手机编号从10000开始
   def currentId(): Int = {id += 1; id}  //返回手机编号
}

class HuaWeiPhoneId extends PhoneId{ //使用extends关键字
     override var id = 20000  //HuaWei手机编号从20000开始     
     def currentId(): Int = {id += 1; id}  //返回手机编号
} 


object TraitPhone_01 { 
    def main(args: Array[String]){
        val myPhone1 = new ApplePhoneId()       
        val myPhone2 = new HuaWeiPhoneId ()
        printf("My first PhoneId is %d.\n",myPhone1.currentId)
        printf("My second PhoneId is %d.\n",myPhone2.currentId)
     }
}
