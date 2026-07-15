object TestStudents_02{
   private var studentNum=0
   //定义newStuNum方法，将学号加1，返回新的学号studentNum
   def newStuNum={
       studentNum+=1
       studentNum
   } 

   //通过main方法作为程序的入口
   def main(args:Array[String]){
      println("New num is "+TestStudents_02.newStuNum)
    }
}
