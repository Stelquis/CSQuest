class Student {
    private var age= 18  //age用来存储学生的年纪
    private var name = ""  //表示学生的名字
    private var classNum = 1  //ClassNum用来表示学生的班级

    def this(name: String){  //第一个辅助构造函数
        this()  //调用主构造函数this
        this.name = name //给name赋值
     }

    def this (name: String, classNum: Int){  //第二个辅助构造函数
        this(name)  //调用前一个辅助构造函数
        this.classNum = classNum
    }

   def increase(step: Int): Unit = { age += step}  //增加年龄
   def current(): Int = {age}
   def info(): Unit = {
      printf("Name:%s and classNum is %d\n",name,classNum)
   }
}

object TestStudent_02{

     def main(args:Array[String]){
         val myStudent1 = new Student  //主构造函数
 
         //第一个辅助构造函数，学生名字设置为ZhangSan
         val myStudent2 = new Student("ZhangSan") 

         //第二个辅助构造函数，学生名字设置为LiSi，班级为75班
         val myStudent3 = new Student("LiSi",75)

         myStudent1.info  //显示学生信息
         myStudent1.increase(1)     //设置步长  
         printf("Current age is: %d\n",myStudent1.current) //显示学生年纪

         myStudent2.info  //显示学生信息
         myStudent2.increase(2)     //设置步长  
         printf("Current age is: %d\n",myStudent2.current) //显示学生年纪

         myStudent3.info  //显示学生信息
         myStudent3.increase(3)     //设置步长  
         printf("Current age is: %d\n",myStudent3.current) //显示学生年纪
    }
}
