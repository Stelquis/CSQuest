 class Student{
     private var age = 18  
     val name="Scala"    
     def increase(): Unit = { age+= 1} 
     def current(): Int = {age}
 }

 object TestStudent_01 {
     def main(args: Array[String]) {
         val student= new Student
         student.increase()
         println(student.current)
     }
 }