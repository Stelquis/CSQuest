import scala.collection.mutable.ArrayBuffer
object Demo {
     def main(args: Array[String]) {
         //定义动态数组z
         val z=ArrayBuffer[String]()

        //向数组中添加元素
         z+="Zara"
         println(z.length)

        //一次添加多个元素
         z+=("Nuha", "Ayan")
         println(z.length)
 
        //在数组索引为1地位置插入元素"Amy"
         z.insert(1,"Amy")
         println(z(1))

        //删除索引为2的"Nuha",输出新的索引为2 的元素
         z.remove(2,1)//从索引2开始删除1个元素
         println(z(2))
        }
   }
