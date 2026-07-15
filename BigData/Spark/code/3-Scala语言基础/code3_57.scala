object Demo {
     def main(args: Array[String]) {

        //鍒涘缓Set
        val fruit1 = Set("apples", "oranges", "pears")
        val fruit2 = Set("mangoes", "banana","apples")

        // 浣跨敤++ 鎿嶄綔绗﹁繛鎺ヤ袱涓垨澶氫釜闆嗗悎
        var fruit = fruit1 ++ fruit2
        println( "fruit1 ++ fruit2 : " + fruit )

        // 浣跨敤 ++ 浣滀负鏂规硶杩炴帴涓や釜闆嗗悎
        fruit = fruit1.++(fruit2)
        println( "fruit1.++(fruit2) : " + fruit )
    }
}
