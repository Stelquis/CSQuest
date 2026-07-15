class Student(val name: String, val classNum: Int) {  //参数列表放在类名后面
    private var age = 18  //age用来存储学生年纪的起始值    
    def increase(step: Int): Unit = {age += step}
    def current(): Int = {age}
    def info(): Unit = {printf("Name:%s and classNum is %d\n",name,classNum)}
}


object TestStudent_03{

 def main(args:Array[String]){  
          val myStudent = new Student("ZhangSan",67)
          myStudent.info  //显示学生信息
          myStudent.increase(1)  //设置步长  
          printf("Current age is: %d\n",myStudent.current) //显示学生年纪 
  }
}
