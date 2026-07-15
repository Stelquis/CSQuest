import org.apache.spark.sql.{Row, SparkSession}
import org.apache.spark.sql.types._
import scala.collection.mutable
import java.text.SimpleDateFormat

object SparkSQL01 {
  def main(args: Array[String]): Unit = {
    /** 
      * sparksession
      */
    val spark = SparkSession
      .builder()
      .master("local")
      .appName("test")
      .config("spark.sql.shuffle.partitions", "5")
      .getOrCreate()

/** ************************ student表结构*****************************/
    val studentRDD = spark.sparkContext.textFile("/home/ubuntu01/SqlExample/student.txt")
val StudentSchema: StructType = StructType(mutable.ArraySeq(  //学生表
StructField("Sno", StringType, nullable = false),           //学号
      StructField("Sname", StringType, nullable = false),         //学生姓名
      StructField("Ssex", StringType, nullable = false),          //学生性别
      StructField("Sbirthday", StringType, nullable = true),      //学生出生年月
      StructField("SClass", StringType, nullable = true)          //学生所在班级
    ))
val studentData = studentRDD.map(_.split(",")).map(attributes => Row(attributes(0),attributes(1),attributes(2),attributes(3),attributes(4)))
    val studentDF = spark.createDataFrame(studentData,StudentSchema)
    studentDF.createOrReplaceTempView("student")

/** ************************ teacher表结构*****************************/
val teacherRDD = spark.sparkContext.textFile("/home/ubuntu01/SqlExample/teacher.txt")
val TeacherSchema: StructType = StructType(mutable.ArraySeq(  //教师表
      StructField("Tno", StringType, nullable = false),           //教工编号（主键）
      StructField("Tname", StringType, nullable = false),         //教工姓名
      StructField("Tsex", StringType, nullable = false),          //教工性别
      StructField("Tbirthday", StringType, nullable = true),      //教工出生年月
      StructField("Prof", StringType, nullable = true),           //职称
StructField("Depart", StringType, nullable = false)         //教工所在部门
    ))
val teacherData = teacherRDD.map(_.split(",")).map(attributes => Row(attributes(0),attributes(1),attributes(2),attributes(3),attributes(4),attributes(5)))
    val teacherDF = spark.createDataFrame(teacherData,TeacherSchema)
    teacherDF.createOrReplaceTempView("teacher")

/** ************************ course表结构*****************************/
    val courseRDD = spark.sparkContext.textFile("/home/ubuntu01/SqlExample/course.txt")
    val CourseSchema: StructType = StructType(mutable.ArraySeq(   //课程表
      StructField("Cno", StringType, nullable = false),           //课程号
      StructField("Cname", StringType, nullable = false),         //课程名称
      StructField("Tno", StringType, nullable = false)            //教工编号
    ))
val courseData = courseRDD.map(_.split(",")).map(attributes => Row(attributes(0),attributes(1),attributes(2)))
    val courseDF = spark.createDataFrame(courseData,CourseSchema)
    courseDF.createOrReplaceTempView("course")

/** ************************ score表结构*****************************/
    val scoreRDD = spark.sparkContext.textFile("/home/ubuntu01/SqlExample/score.txt")
    val ScoreSchema: StructType = StructType(mutable.ArraySeq(    //成绩表
      StructField("Sno", StringType, nullable = false),           //学号（外键）
      StructField("Cno", StringType, nullable = false),           //课程号（外键）
StructField("Degree", IntegerType, nullable = true)         //成绩
    ))
val scoreData = scoreRDD.map(_.split(",")).map(attributes => Row(attributes(0),attributes(1),attributes(2)))
    val scoreDF = spark.createDataFrame(scoreData,ScoreSchema)
scoreDF.createOrReplaceTempView("score")

/** ************************对各表的处理*****************************/
//按照班级降序排序显示所有学生信息
spark.sql("SELECT * FROM student ORDER BY SClass DESC").show()
//+-----+---------------+-----------+------------+---------+
//|Sno|    Sname|   Ssex|Sbirthday| SClass|
//+-----+---------------+-----------+------------+---------+
//|107|    GuiGui|  male| 1992/5/5| 95033|
//|108|  ZhangSan|  male| 1995/9/1| 95033|
//|106|    LiuBing| female|1996/5/20| 95033|
//|105|KangWeiWei|female| 1996/6/1| 95031|
//|101| WangFeng|   male| 1993/8/8| 95031|
//|109| DuBingYan|   male|1995/5/21| 95031|
//+-----+---------------+-----------+--------------+---------+

//查询“计算机系”与“电子工程系“不同职称的教师的Tname和Prof。
spark.sql("SELECT tname, prof " +
        "FROM Teacher " +
        "WHERE prof NOT IN (SELECT a.prof " +
        "FROM (SELECT prof " +
        "FROM Teacher " +
        "WHERE depart = 'department of computer' " +
        ") a " +
        "JOIN (SELECT prof " +
        "FROM Teacher " +
        "WHERE depart = 'department of electronic engineering' " +
        ") b ON a.prof = b.prof) ").show(false)
//+-----------------+-------------------------+
//|tname     |prof            |
//+-----------------+-------------------------+
//|LinYu      |Associate professor|
//|DuMei     |Assistant professor|
//|RenLi      |Lecturer         |
//|GongMOMO|Associate professor|
//|DuanMu   | Assistant professor|
//+-----------------+-------------------------+

//显示student表中记录数
println(studentDF.count())
//6

//显示student表中名字和性别的信息
studentDF.select("Sname","Ssex").show()
//+-----------------+---------+
//|     Sname|  Ssex|
//+-----------------+---------+
//|   ZhangSan| male|
//|KangWeiWei|female|
//|     GuiGui| male|
//| WangFeng|  male|
//|   LiuBing| female|
//| DuBingYan|  male|
//+--------------+----------+

//显示性别为男的教师信息
teacherDF.filter("Tsex = 'male'").show(false)
//+-----+---------+------+------------+-----------------------+-------------------------------------+
//|Tno|Tname |Tsex|Tbirthday|        Prof   |          Depart       |
//+-----+---------+------+------------+------------------------+------------------------------------+
//|825|LinYu|male|1958/1/1|Associate professor|  department of computer|
//|888|RenLi |male|1972/5/1 |Lecturer |department of electronic engneering|
//|864|DuanMu|male|1985/6/1|Assistant professor|department of computer|
//+-----+---------+------+------------+------------------------+-------------------------------------+

//显示不重复的教师部门信息
teacherDF.select("Depart").distinct().show(false)
//+------------------------------------------------+
//|Depart                        |
//+------------------------------------------------+
//|department of computer          |
//|computer science department     |
//|department of electronic engneering|
//+-------------------------------------------------+

//显示学号为101的学生信息
studentDF.where("Sno = '101'").show()
//+-----+--------------+-----+-------------+--------+
//|Sno|   Sname|Ssex|Sbirthday| SClass|
//+-----+--------------+-----+-------------+---------+
//|101|WangFeng|male|1993/8/8|95031|
//+-----+--------------+-----+-------------+---------+

//将教师信息以List的形式显示
println(teacherDF.collectAsList())
//[[825,LinYu,male,1958/1/1,Associate professor,department of computer],
//[804,DuMei,female,1962/1/1,Assistant professor,computer science department],
//[888,RenLi,male,1972/5/1,Lecturer,department of electronic engineering],
//[852,GongMOMO,female,1986/1/5,Associate professor,computer science department],
//[864,DuanMu,male,1985/6/1,Assistant professor,department of computer]]

//查询所有“女”教师和“女”同学的name、sex和birthday
spark.sql("SELECT sname, ssex, sbirthday " +
"FROM Student " +
        "WHERE ssex = 'female' " +
        "UNION " +
        "SELECT tname, tsex, tbirthday " +
        "FROM Teacher " +
        "WHERE tsex = 'female'").show()
//+-----------------+----------+------------+
//|     sname|   ssex|sbirthday|
//+-----------------+----------+------------+
//| GongMOMO|female| 1986/1/5|
//|KangWeiWei|female| 1996/6/1|
//|    LiuBing|female|1996/5/20|
//|     DuMei|female| 1962/1/1|
//+----------------+----------+-------------+
  }
}