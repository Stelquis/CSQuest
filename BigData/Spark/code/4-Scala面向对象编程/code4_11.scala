//定义类Students
class Students{   
     val id = Students.newStuId() //调用了伴生对象中的方法
     private var number =0
     def aClass(number: Int) { this.number= number}
}

//定义类Students的伴生对象object Students
object Students {  
     private var StuId = 0  //学号
     def newStuId() = {
          StuId +=1
          StuId 
     }

     def main(args: Array[String]){
//直接调用伴生对象Students的方法newStuId
          println(Students.newStuId)
          //再次调用newStuId方法，学号StuId在加1
          println(Students.newStuId)
     }
}
