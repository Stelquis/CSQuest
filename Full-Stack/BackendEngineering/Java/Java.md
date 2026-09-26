# [Java 从入门到精通：一篇讲透语法、JVM、并发与工程化](https://mp.weixin.qq.com/s/eeHf_lR7JifPfVJ5yOP7Ww)

> 这是一个关于"青禾外卖"的故事——一个五人初创团队，和他们的后端工程师陈默从"会写几行 Java"到"能扛住午高峰"的完整旅程。你会跟着陈默一起，把 Java 的语法、面向对象、集合、并发、JVM 和工程化一条条打通。读完之后你会发现：Java 不只是一门编程语言，更是一套成熟的软件工程体系——用清晰的抽象管理复杂度，用稳定的运行时承载业务系统。

---

## 故事的起点：半价活动的夜晚，三起事故

"青禾外卖"是一家刚跑通商业模式的初创公司，五个人的团队，一个 Spring Boot 单体应用撑起了全部后端：下单、支付、骑手调度、优惠券。陈默是团队里最年轻的工程师，从培训班转正三个月，平时写代码靠"能跑就行"。

那个周五，运营策划了一场"晚市半价"活动。晚上六点，订单量冲上平日三倍，然后事情开始一件接一件地出错：

- 一笔 19.90 元的优惠券订单，结算金额显示 19.899999999999999 元，客服电话被打爆；
- 库存剩 100 份炸鸡，超卖出了 107 单，运营连夜道歉赔券；
- 服务越跑越慢，重启一下就好，可没人说得清为什么；
- 想看看到底哪行代码出了问题，满屏的 `System.out.println` 里捞不出一条有用的日志。

凌晨一点，陈默盯着满屏报错，忽然意识到一件事：**他会写 Java，但他不理解 Java。**

那些"能跑就行"的代码，在流量面前一个个露出了马脚：浮点精度、并发竞争、内存回收、日志规范——每一个坑，背后都是他没搞懂的语言机制。

第二天，技术负责人老周找他聊了一次。老周没有批评他，只在白板上写了一行字：

> Java 的核心思想始终没有改变：用清晰的抽象管理复杂度，用稳定的运行时承载业务系统。

"这些事故不是巧合，"老周说，"是同一个原因——只背语法，不写项目；只学框架，不懂底层。从下周开始，你把 Java 从头到尾重新学一遍。用咱们青禾外卖的真实系统当教材。"

陈默给自己定了个目标：**三个月，把 Java 从"会写"学到"能扛住午高峰"。**

这个故事，就是他从头到尾走完的路线图。

---
## 第 1 站：为什么青禾外卖选择 Java——语言定位与版本策略

周一早上九点，青禾外卖的会议室里坐着五个人。这是陈默入职的第一周，技术负责人老周在白板上画了一张架构草图：Spring Boot 单体、MySQL、Redis，右下角写着"月订单量破百万"。

"我们为什么用 Java？"陈默忍不住问。上一个公司的项目是别的语言写的，他对这个选择并没有概念。

老周把马克笔一放："因为我们要的是一套成熟的软件工程体系，而不只是一门编程语言。Java 从一个简单的 `Hello World`，到高并发服务、分布式系统、云原生应用，核心思想始终没有改变：用清晰的抽象管理复杂度，用稳定的运行时承载业务系统。等你被午高峰的流量冲过一次，就明白了。"

Java 诞生于 1995 年，但它并没有停留在"传统企业开发语言"的阶段。

现代 Java 已经拥有：

- Lambda 表达式与 Stream API；
- `record` 数据类；
- 密封类 `sealed class`；
- 模式匹配；
- 模块系统；
- 虚拟线程；
- 成熟的垃圾回收器；
- 强大的 JIT 即时编译器；
- Spring、Netty、MyBatis、Hibernate 等庞大生态；
- Maven、Gradle、JUnit、JMH、JFR 等完整工具链。

截至 2026 年 7 月，OpenJDK 仍采用每六个月发布一个功能版本的节奏。JDK 26 已于 2026 年 3 月正式发布，Java 25 则是长期支持版本，也就是 LTS 版本。

对于初学者，可以采用下面的版本策略：

- 学习和新项目优先使用 Java 25 LTS；
- 维护老项目时，可能仍会遇到 Java 8、11、17、21；
- 了解 JDK 26 的新特性，但不要为了追新而频繁更换生产环境。

Java 最适合以下方向：

- 企业级后端开发；
- 电商、金融、支付和交易系统；
- 大数据平台；
- Android 旧项目维护与部分基础设施；
- 中间件与开发工具；
- 高并发网络服务；
- 云原生和微服务系统。

散会时陈默看了一眼手里的入职文档，第一行就是"本机请先装 JDK 25"。他心想：先把这个搞明白再说。

## 第 2 站：JDK、JRE、JVM 到底谁包含谁——环境搭建与第一个程序

下午，陈默的工位上贴着一张便利贴，是老周留的："跑通你的第一个 Java 程序，今天就算转正摸底过关。"

陈默盯着屏幕上的三个词发懵：JDK、JRE、JVM。下载页面里好几个包，他不知道该点哪个。旁边坐着的测试同学小声提醒："别下错了，上次实习生下成 JRE，连编译都跑不起来。"

学习 Java 的第一个难点，不是代码，而是几个容易混淆的概念。

### 1. JVM

JVM 是 Java Virtual Machine，即 Java 虚拟机。

Java 源代码不会直接运行在操作系统上，而是先编译成字节码，再由 JVM 执行。

```text
Hello.java
    ↓ javac 编译
Hello.class
    ↓ JVM 加载与执行
Windows / macOS / Linux
```

这也是 Java "一次编译，到处运行"的基础。

### 2. JRE

JRE 是 Java Runtime Environment，即 Java 运行环境。

它包含 JVM 和运行 Java 程序所需的核心类库。

### 3. JDK

JDK 是 Java Development Kit，即 Java 开发工具包。

它包含：

- Java 编译器 `javac`；
- Java 启动器 `java`；
- 调试工具；
- 文档工具；
- 打包工具；
- JVM；
- 标准类库。

开发 Java 程序，安装 JDK 即可。

### 4. 验证安装

在终端中执行：

```bash
java -version
javac -version
```

如果能够正确显示版本号，说明环境已经配置成功。

常用开发工具包括：

- IntelliJ IDEA；
- Visual Studio Code；
- Eclipse。

初学者更推荐 IntelliJ IDEA，因为它对 Java 的代码补全、重构和调试支持非常完整。

### 5. 你的第一个 Java 程序

环境配好，创建文件 `HelloWorld.java`：

```java
public class HelloWorld {

    public static void main(String[] args) {
        System.out.println("Hello, Java!");
    }
}
```

编译：

```bash
javac HelloWorld.java
```

运行：

```bash
java HelloWorld
```

输出：

```text
Hello, Java!
```

### 这段代码分别表示什么？

```java
public class HelloWorld
```

定义了一个名为 `HelloWorld` 的公共类。公共类名必须与文件名一致。

```java
public static void main(String[] args)
```

这是传统 Java 程序的入口方法。

- `public`：JVM 可以访问；
- `static`：不创建对象也能调用；
- `void`：没有返回值；
- `String[] args`：接收命令行参数。

```java
System.out.println(...)
```

向控制台输出一行文本。

不要急着死记这些单词。随着后面的学习，你会逐渐理解它们为什么这样设计。

陈默的屏幕上跳出 `Hello, Java!` 那一刻，他把截图发到团队群里。老周回了两个字："过。"

## 第 3 站：变量、类型与运算——那些 0.1 + 0.2 的坑

周三下午，青禾外卖的运营群里炸了：一张满减优惠券结算出来是 59.70000000000001 元，用户截图发到了微博。排查到最后，问题落在陈默上周写的一段金额计算上——他把金额存成了 `double`。

老周把陈默叫到工位前，只说了一句话："金额用 double，是新手给生产环境埋的第一颗雷。今天下午你把 Java 基础语法重新过一遍，从变量开始。"

### 4.1 变量与常量

变量用于保存数据：

```java
int age = 18;
double price = 99.5;
boolean loggedIn = true;
char level = 'A';
String name = "Java";
```

常量使用 `final`：

```java
final double PI = 3.1415926;
```

被 `final` 修饰的变量只能赋值一次。

#### 命名规范

```java
int userAge;             // 变量：小驼峰
void calculatePrice() {} // 方法：小驼峰
class OrderService {}    // 类：大驼峰
final int MAX_SIZE = 10; // 常量：全大写
```

> 好的命名比注释更重要。

不要写：

```java
int a;
int b;
int c;
```

应该写：

```java
int unitPrice;
int quantity;
int totalAmount;
```

### 4.2 基本数据类型

Java 有 8 种基本数据类型：

| 类型 | 常见用途 |
|------|---------|
| `byte` | 小整数、二进制数据 |
| `short` | 较小整数 |
| `int` | 默认整数类型 |
| `long` | 大整数、时间戳 |
| `float` | 单精度小数 |
| `double` | 默认浮点数类型 |
| `char` | 单个字符 |
| `boolean` | 真或假 |

示例：

```java
byte status = 1;
short year = 2026;
int count = 100;
long population = 8_000_000_000L;
float ratio = 0.75F;
double amount = 199.99;
char grade = 'A';
boolean success = true;
```

下划线可以提高数字的可读性：

```java
int oneMillion = 1_000_000;
```

#### 金额不要直接使用 `double`

浮点数存在精度误差：

```java
System.out.println(0.1 + 0.2);
```

结果通常不是严格的 `0.3`。

金融金额应使用 `BigDecimal`：

```java
import java.math.BigDecimal;

BigDecimal price = new BigDecimal("19.90");
BigDecimal quantity = new BigDecimal("3");
BigDecimal total = price.multiply(quantity);

System.out.println(total);
```

创建 `BigDecimal` 时，优先传入字符串，而不是浮点数。

陈默把优惠券模块里的金额字段全部改成了 `BigDecimal`，重新编译、自测、提测。老周路过看了一眼："记住这个教训，比背十遍类型表有用。"

### 4.3 类型转换

#### 自动类型转换

小范围类型可以自动转换为大范围类型：

```java
int number = 100;
long value = number;
double result = value;
```

#### 强制类型转换

```java
double price = 19.99;
int integerPrice = (int) price;

System.out.println(integerPrice); // 19
```

强制转换可能丢失精度，也可能发生溢出。

### 4.4 运算符

#### 算术运算符

```java
int a = 10;
int b = 3;

System.out.println(a + b);
System.out.println(a - b);
System.out.println(a * b);
System.out.println(a / b);
System.out.println(a % b);
```

整数相除只保留整数部分：

```java
System.out.println(10 / 3);     // 3
System.out.println(10.0 / 3);   // 3.333...
```

#### 比较运算符

```java
a == b
a != b
a > b
a < b
a >= b
a <= b
```

#### 逻辑运算符

```java
boolean canBuy = age >= 18 && loggedIn;
boolean needLogin = !loggedIn;
boolean hasPermission = isAdmin || isOwner;
```

### 4.5 条件判断

#### if 语句

```java
int score = 86;

if (score >= 90) {
    System.out.println("优秀");
} else if (score >= 60) {
    System.out.println("及格");
} else {
    System.out.println("需要继续努力");
}
```

#### switch 表达式

现代 Java 的 `switch` 可以直接返回结果：

```java
int day = 1;

String dayName = switch (day) {
    case 1 -> "星期一";
    case 2 -> "星期二";
    case 3 -> "星期三";
    case 4 -> "星期四";
    case 5 -> "星期五";
    case 6, 7 -> "周末";
    default -> throw new IllegalArgumentException("无效日期");
};

System.out.println(dayName);
```

相比传统 `switch`，这种写法更紧凑，也能避免忘记写 `break`。

### 4.6 循环

#### for 循环

```java
for (int i = 0; i < 5; i++) {
    System.out.println(i);
}
```

#### 增强 for 循环

```java
String[] names = {"Tom", "Jack", "Alice"};

for (String name : names) {
    System.out.println(name);
}
```

#### while 循环

```java
int count = 3;

while (count > 0) {
    System.out.println(count);
    count--;
}
```

#### break 与 continue

```java
for (int i = 1; i <= 10; i++) {
    if (i == 3) {
        continue;
    }

    if (i == 8) {
        break;
    }

    System.out.println(i);
}
```

- `continue`：跳过本次循环；
- `break`：结束整个循环。

## 第 4 站：数组、字符串与方法——String 为什么不可变

周四晚上，陈默在骑手排行榜接口里拼一个名单字符串。他在循环里用 `+` 拼了几千个骑手名，接口耗时肉眼可见地涨。他在代码评审里问："不就是个字符串拼接吗？"

老周在评审意见里写道："先搞清楚 String 为什么不可变，再回去改。另外，你哪里又在用 `==` 比较字符串了？"——后者是陈默的另一个老毛病，他判断字符串相等一直用 `==`。

### 5.1 数组

数组用于保存一组相同类型的数据：

```java
int[] scores = {90, 85, 76, 92};

System.out.println(scores[0]);
System.out.println(scores.length);
```

遍历数组：

```java
for (int score : scores) {
    System.out.println(score);
}
```

数组长度固定。如果需要动态增加或删除元素，应使用集合。

### 5.2 String

字符串是 Java 中使用频率最高的类型之一。

```java
String firstName = "James";
String lastName = "Gosling";
String fullName = firstName + " " + lastName;
```

常用方法：

```java
String text = "  Hello Java  ";

System.out.println(text.length());
System.out.println(text.trim());
System.out.println(text.toUpperCase());
System.out.println(text.contains("Java"));
System.out.println(text.replace("Java", "World"));
```

#### 字符串不可变

`String` 对象一旦创建，其内容不能被修改。

```java
String name = "Java";
name = name + " 25";
```

第二行并不是修改原字符串，而是创建了新字符串。

大量拼接字符串时，使用 `StringBuilder`：

```java
StringBuilder builder = new StringBuilder();

for (int i = 0; i < 5; i++) {
    builder.append(i).append(",");
}

System.out.println(builder);
```

#### 使用 equals 比较字符串

错误写法：

```java
if (name == "Java") {
    // 不推荐
}
```

正确写法：

```java
if ("Java".equals(name)) {
    System.out.println("相同");
}
```

`==` 比较的是引用，`equals` 通常比较的是内容。

### 5.3 方法

方法用于封装可复用逻辑：

```java
public static int add(int a, int b) {
    return a + b;
}
```

调用：

```java
int result = add(10, 20);
```

#### 方法重载

同一个类中，可以存在同名但参数不同的方法：

```java
public static int add(int a, int b) {
    return a + b;
}

public static double add(double a, double b) {
    return a + b;
}

public static int add(int a, int b, int c) {
    return a + b + c;
}
```

方法签名由方法名和参数列表共同决定，不能只依靠返回值区分重载。

第二天，陈默把排行榜的拼接改成了 `StringBuilder`，把 `==` 全部换成了 `equals`。老周看完代码只补了一句："代码是给人读的，方法名起清楚点，比加十行注释都强。"

## 第 5 站：面向对象：Java 的核心——封装、继承、多态与 record/sealed

周五，青禾外卖接入了第二个支付渠道。陈默打开支付模块，发现老同事留下的代码里，订单余额字段是 `public` 的，谁都能改，哪个渠道在改根本查不出来。

老周把陈默拉到白板前："单体不可怕，可怕的是代码没有边界。Java 是一门以面向对象为核心的语言。面向对象不是'把所有代码都写进类里'，而是把现实问题拆分成具有职责的对象。今天这章，就是你以后写每一个类的地基。"

### 6.1 类与对象

```java
public class User {

    String name;
    int age;

    void introduce() {
        System.out.println("我是 " + name + "，今年 " + age + " 岁");
    }
}
```

创建对象：

```java
User user = new User();
user.name = "Alice";
user.age = 20;
user.introduce();
```

- 类是模板；
- 对象是类的实例。

### 6.2 构造方法

构造方法用于初始化对象：

```java
public class User {

    private String name;
    private int age;

    public User(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

调用：

```java
User user = new User("Alice", 20);
```

`this` 表示当前对象。

### 6.3 封装

封装的目标，是隐藏对象内部实现，只暴露必要能力。

```java
public class BankAccount {

    private long balance;

    public void deposit(long amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("存款金额必须大于 0");
        }

        balance += amount;
    }

    public void withdraw(long amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("取款金额必须大于 0");
        }

        if (amount > balance) {
            throw new IllegalStateException("余额不足");
        }

        balance -= amount;
    }

    public long getBalance() {
        return balance;
    }
}
```

这里没有直接提供 `setBalance`，因为账户余额不能被任意修改。

> 封装不是机械地生成 Getter 和 Setter，而是保护业务规则。

### 6.4 继承

```java
public class Animal {

    public void speak() {
        System.out.println("动物发出声音");
    }
}
```

```java
public class Dog extends Animal {

    @Override
    public void speak() {
        System.out.println("汪汪");
    }
}
```

继承适合表达"是一个"的关系：

```text
Dog 是一个 Animal
```

但不要滥用继承。实际项目中，组合往往比继承更灵活。

### 6.5 多态

```java
Animal animal = new Dog();
animal.speak();
```

虽然变量类型是 `Animal`，实际执行的是 `Dog` 的实现。

多态使上层代码可以依赖抽象，而不是依赖具体实现。

### 6.6 抽象类与接口

#### 抽象类

```java
public abstract class Payment {

    public abstract void pay(long amount);

    public void printReceipt() {
        System.out.println("打印支付凭证");
    }
}
```

#### 接口

```java
public interface PaymentService {

    void pay(long amount);
}
```

实现接口：

```java
public class AlipayService implements PaymentService {

    @Override
    public void pay(long amount) {
        System.out.println("支付宝支付：" + amount);
    }
}
```

接口适合定义能力和契约，抽象类适合复用一部分状态与实现。

### 6.7 record：更简洁的数据类

传统 Java 数据类往往需要编写字段、构造方法、Getter、`equals`、`hashCode` 和 `toString`。

使用 `record`：

```java
public record UserProfile(
        long id,
        String name,
        String email
) {
}
```

使用：

```java
UserProfile profile =
        new UserProfile(1L, "Alice", "alice@example.com");

System.out.println(profile.name());
System.out.println(profile);
```

`record` 非常适合：

- DTO；
- API 响应对象；
- 配置对象；
- 不可变值对象。

不过，领域实体是否使用 `record`，仍要结合业务建模和持久化框架进行判断。

### 6.8 sealed：限制继承范围

密封类可以明确规定哪些类型允许继承它：

```java
public sealed interface Result
        permits Success, Failure {
}
```

```java
public record Success(String data) implements Result {
}
```

```java
public record Failure(String message) implements Result {
}
```

配合模式匹配：

```java
public static String render(Result result) {
    return switch (result) {
        case Success success -> "成功：" + success.data();
        case Failure failure -> "失败：" + failure.message();
    };
}
```

这种写法适合表达有限状态：

- 支付结果；
- 审批状态；
- 消息类型；
- 编译器语法树；
- 业务命令。

那天晚上，陈默给支付模块补上了接口和 `sealed` 的支付结果定义。他在下班的电梯里给老周发了条消息："感觉有点明白'抽象管理复杂度'是什么意思了。"老周回得很快："下周教你另一个——复杂度不会消失，只会转移。"
## 第 6 站：一次线上崩溃引出的异常处理——try/catch 与异常设计

周四午高峰，青禾外卖的骑手端突然集体掉线，监控告警群里炸出几十条消息。陈默手忙脚乱地翻日志，最后在一个被空 `catch` 块包住的支付回调里找到了真相：异常早就发生了，只是被悄悄吞掉，订单状态一直没更新，直到下游批量重试把服务压垮。

老周把他叫到工位，只说了一句话："异常不是敌人，被吞掉的异常才是。"

异常用于描述程序运行过程中出现的异常情况。最基本的处理结构是 `try-catch-finally`：

```java
try {
    int value = Integer.parseInt("abc");
    System.out.println(value);
} catch (NumberFormatException exception) {
    System.out.println("数字格式错误");
} finally {
    System.out.println("无论是否异常都会执行");
}
```

### 7.1 Checked Exception 与 Runtime Exception

Java 异常大体可分为：

```text
Throwable
├── Error
└── Exception
    ├── RuntimeException
    └── 其他受检异常
```

- `Error`：通常表示 JVM 或系统级严重问题；
- 受检异常：编译器要求显式处理；
- 运行时异常：通常表示参数、状态或程序逻辑错误。

### 7.2 自定义异常

青禾外卖的业务里，"余额不足"这类错误不该混在系统异常里。可以定义自己的异常类：

```java
public class InsufficientBalanceException
        extends RuntimeException {

    public InsufficientBalanceException(String message) {
        super(message);
    }
}
```

使用：

```java
if (amount > balance) {
    throw new InsufficientBalanceException("账户余额不足");
}
```

### 7.3 异常处理原则

回到那次崩溃，陈默写出过这样的代码：

```java
try {
    doSomething();
} catch (Exception exception) {
}
```

这会吞掉所有异常，使问题难以排查。

更好的做法是：

- 捕获具体异常；
- 记录必要上下文；
- 不要重复打印同一个异常；
- 不要把异常当作正常流程控制；
- 业务异常和系统异常分开处理；
- 对外返回稳定错误码，不直接暴露内部堆栈。

老周在复盘会上补了一句：**线上问题十有八九，都能在一段被静默的异常里找到起点。**

## 第 7 站：集合框架——List、Set、Map 与 HashMap 的灵魂拷问

周五，产品经理提了个需求：运营后台要展示"今日下单用户榜"。陈默心想这还不简单，结果打开一年前的老代码，看到有人用数组存订单、超了就手动扩容复制，看得他头皮发麻。老周路过，敲了敲屏幕："数组长度固定，而集合可以动态管理数据。先把集合框架搞明白，再来写业务。"

Java 集合框架的核心接口包括：

```text
Collection
├── List
├── Set
└── Queue

Map
```

### 8.1 List

`List` 有序，允许重复元素。

```java
List<String> names = new ArrayList<>();

names.add("Alice");
names.add("Bob");
names.add("Alice");

System.out.println(names.get(0));
```

常用实现：

- `ArrayList`：查询快，最常用；
- `LinkedList`：链表结构，但真实项目中使用场景比想象中少；
- `CopyOnWriteArrayList`：适合读多写少的并发场景。

### 8.2 Set

`Set` 不允许重复元素。比如给订单打标签，"Java"这个标签加两遍也只有一个：

```java
Set<String> tags = new HashSet<>();

tags.add("Java");
tags.add("Spring");
tags.add("Java");

System.out.println(tags.size()); // 2
```

常用实现：

- `HashSet`：基于哈希表；
- `LinkedHashSet`：保留插入顺序；
- `TreeSet`：自动排序。

### 8.3 Map

`Map` 保存键值对，比如用户 ID 到用户名的映射：

```java
Map<Long, String> users = new HashMap<>();

users.put(1L, "Alice");
users.put(2L, "Bob");

System.out.println(users.get(1L));
```

遍历：

```java
for (Map.Entry<Long, String> entry : users.entrySet()) {
    System.out.println(entry.getKey() + ": " + entry.getValue());
}
```

常用实现：

- `HashMap`：最常见；
- `LinkedHashMap`：保留插入顺序；
- `TreeMap`：按键排序；
- `ConcurrentHashMap`：并发访问。

### HashMap 为什么重要？

面试中经常会问：

- 哈希冲突如何处理？
- 容量为什么通常是 2 的幂？
- 什么时候扩容？
- `equals` 和 `hashCode` 有什么关系？
- 为什么可变对象不适合直接作为键？

真正掌握 `HashMap`，需要同时理解数组、链表、树、哈希函数和对象相等性。

老周说：**这块不是用来背的，是用来在被面试官追问时，知道自己还有哪里没懂的。**

## 第 8 站：泛型——让错误暴露在编译期

陈默接手了一个没有泛型的老模块：一个裸 `List` 往里塞东西，取出来再强转，上线后半夜炸出一次 `ClassCastException`。他修到凌晨两点，第二天跟老周抱怨"这种错误编译器为什么不拦"。

老周说："泛型存在的意义，就是让这类错误在编译期就暴露，而不是等到线上。"

泛型让类型检查发生在编译阶段。

没有泛型时：

```java
List list = new ArrayList();
list.add("Java");

String value = (String) list.get(0);
```

使用泛型：

```java
List<String> list = new ArrayList<>();
list.add("Java");

String value = list.get(0);
```

### 9.1 泛型类

```java
public class Box<T> {

    private final T value;

    public Box(T value) {
        this.value = value;
    }

    public T getValue() {
        return value;
    }
}
```

使用：

```java
Box<String> box = new Box<>("Java");
System.out.println(box.getValue());
```

### 9.2 泛型方法

```java
public static <T> T first(List<T> values) {
    if (values.isEmpty()) {
        throw new IllegalArgumentException("列表不能为空");
    }

    return values.get(0);
}
```

### 9.3 通配符

```java
public static double sum(List<? extends Number> values) {
    double result = 0;

    for (Number value : values) {
        result += value.doubleValue();
    }

    return result;
}
```

一个常见记忆方法是 PECS：

```text
Producer Extends
Consumer Super
```

- 从集合中读取某种类型：优先考虑 `extends`；
- 向集合中写入某种类型：优先考虑 `super`。

陈默把老模块的裸 `List` 全部补上泛型，强转代码删了一片。他忽然明白老周那句话的意思：**编译器每多拦住一个错误，线上就少一次半夜的告警。**

## 第 9 站：Lambda 与 Stream——别为了函数式而函数式

月度复盘要做一份"客单价 Top 客户"报表。陈默先写了一版三层嵌套 `for` 循环加临时变量，自己回头看都嫌乱。老周看了眼，把椅子转过来："这种筛选、汇总的活，Java 早就给你准备好工具了。不过丑话说在前面——别为了函数式而函数式。"

Lambda 让 Java 可以更简洁地表达行为。

```java
List<String> names = List.of("Alice", "Bob", "Jack");

names.forEach(name -> System.out.println(name));
```

方法引用：

```java
names.forEach(System.out::println);
```

### 10.1 Stream API

假设有一组订单：

```java
public record Order(
        long id,
        String customer,
        long amount,
        boolean paid
) {
}
```

筛选已支付且金额大于 100 元的订单：

```java
List<Order> orders = List.of(
        new Order(1, "Alice", 120, true),
        new Order(2, "Bob", 80, true),
        new Order(3, "Jack", 300, false),
        new Order(4, "Alice", 220, true)
);

List<Order> result = orders.stream()
        .filter(Order::paid)
        .filter(order -> order.amount() > 100)
        .toList();
```

统计总金额：

```java
long totalAmount = orders.stream()
        .filter(Order::paid)
        .mapToLong(Order::amount)
        .sum();
```

按客户分组：

```java
Map<String, List<Order>> grouped = orders.stream()
        .collect(Collectors.groupingBy(Order::customer));
```

### Stream 的使用原则

Stream 很强大，但不要为了"函数式"而写出难以阅读的长链式调用。

当一个 Stream 包含过多步骤时，可以：

- 提取命名方法；
- 拆成多个阶段；
- 使用中间变量；
- 必要时改回普通循环。

**可读性永远优先于炫技。**

老周补了一句："代码是给人读的，Stream 链每多一行，就多一分欠下的阅读成本。"

## 第 10 站：Optional——把"可能没有"说清楚

客服那边投诉：会员查询接口偶尔返回 500。陈默排查半天，发现是老代码里一个查不到就返回 `null` 的方法，调用方忘了判空。修完 bug，老周指着那段 `if (user != null)` 说："方法签名骗了人。它看起来一定会给结果，其实不一定。这种'可能没有'，应该在类型上就说清楚。"

`Optional` 用于表达"结果可能不存在"。

```java
public Optional<User> findUser(long id) {
    return repository.findById(id);
}
```

使用：

```java
User user = findUser(1L)
        .orElseThrow(() -> new IllegalArgumentException("用户不存在"));
```

转换：

```java
String email = findUser(1L)
        .map(User::getEmail)
        .orElse("unknown@example.com");
```

不要滥用 `Optional`：

- 不建议把它用作普通字段；
- 不建议作为方法参数；
- 不要对 `Optional` 再做 `null` 判断；
- 不要无脑调用 `get()`。

它最适合作为"可能查不到结果"的返回值。

陈默把那个查询方法的返回值改成了 `Optional<User>`，所有调用方在编译期就被迫面对"可能没有"这件事。那天他没有再收到客服的投诉。

## 第 11 站：I/O 与 NIO——大文件不能一口气吞下

月底财务要对账，运营甩给陈默一个几百 MB 的交易流水文件，让他把青禾外卖的订单金额核出来。他二话不说写了句 `Files.readString(path)`，本地跑得欢，一到服务器上内存直接飙红，服务差点被他一个人打挂。老周看着监控曲线，慢悠悠地说："大文件不能一口气吞下。数据多大，内存就得多大——这笔账你算过吗？"

### 12.1 读取文本文件

```java
Path path = Path.of("data.txt");

String content = Files.readString(path);
System.out.println(content);
```

逐行读取：

```java
List<String> lines = Files.readAllLines(path);

for (String line : lines) {
    System.out.println(line);
}
```

大文件不应一次性全部读入内存：

```java
try (Stream<String> lines = Files.lines(path)) {
    lines.forEach(System.out::println);
}
```

### 12.2 写入文件

```java
Path output = Path.of("output.txt");

Files.writeString(
        output,
        "Hello Java",
        StandardOpenOption.CREATE,
        StandardOpenOption.TRUNCATE_EXISTING
);
```

### 12.3 try-with-resources

实现了 `AutoCloseable` 的资源，应使用 try-with-resources 自动关闭：

```java
try (BufferedReader reader =
             Files.newBufferedReader(Path.of("data.txt"))) {

    String line;

    while ((line = reader.readLine()) != null) {
        System.out.println(line);
    }
}
```

这样即使发生异常，资源也能被正确释放。

陈默把对账程序改成流式逐行读取，内存曲线从"珠穆朗玛"变成了"平地"。老周只提醒了一句：**资源这个东西，借了就要还，try-with-resources 是最省心的还法。**

## 第 12 站：多线程入门——run() 和 start() 的区别

大促前压测，陈默想让库存预热脚本跑快一点，自己 `new` 了几百个线程，机器立刻卡死；好不容易跑起来了，又发现某个任务压根没异步执行——因为他调的是 `run()` 而不是 `start()`。老周把这两个问题记在了白板上："并发编程是 Java 进阶的分水岭。先搞懂最基本的东西，再谈高并发。"

并发编程是 Java 进阶的分水岭。

很多人会创建线程，却不理解：

- 可见性；
- 原子性；
- 有序性；
- 竞态条件；
- 死锁；
- 线程池；
- 内存模型。

### 13.1 创建线程

```java
Thread thread = new Thread(() -> {
    System.out.println("任务在线程中执行");
});

thread.start();
```

不要直接调用 `run()`：

```java
thread.run();
```

这只是在当前线程中执行普通方法，不会启动新线程。

### 13.2 线程池

实际项目通常使用线程池，而不是不断创建平台线程。

```java
ExecutorService executor =
        Executors.newFixedThreadPool(4);

try {
    for (int i = 0; i < 10; i++) {
        int taskId = i;

        executor.submit(() -> {
            System.out.println("执行任务：" + taskId);
        });
    }
} finally {
    executor.shutdown();
}
```

线程池需要重点理解：

- 核心线程数；
- 最大线程数；
- 工作队列；
- 拒绝策略；
- 线程工厂；
- 任务类型是 CPU 密集还是 I/O 密集。

在生产项目中，应避免不加分析地直接使用默认无界队列。

陈默看着白板上"可见性、原子性、有序性"那几个词，第一次意识到：能跑起来和跑得对，中间隔着一整个并发世界。老周收起马克笔："线程池和线程只是门票，真正的硬仗在后面——下一站，我们聊聊怎么让共享数据不出错。"
## 第 13 站：库存又超卖了——synchronized、原子类与 CompletableFuture

周五午高峰，青禾外卖搞了一场"招牌酸汤饭半价"活动。活动上线十分钟，客服群里就涌进十几条投诉：有用户明明看到"库存不足"，订单却成功了；仓库盘点一算，同一个 SKU 被扣了超量。陈默盯着自己写的扣减代码——`if (stock > 0) { stock--; }`——怎么看都觉得没毛病。

老周把这段代码复制到白板上，圈住了 `stock--`："这一行在单线程里是一行，在多线程里是三步。你先查库存、再减库存，两个线程同时进来，就都过了第一道门。"

要让共享数据在并发下不出错，最直接的手段是加锁。`synchronized` 可以保证同一时刻只有一个线程进入临界区，并建立必要的内存可见性关系：

```java
public class Counter {

    private int value;

    public synchronized void increment() {
        value++;
    }

    public synchronized int getValue() {
        return value;
    }
}
```

不过如果只是简单的计数，为它配一把锁未免太重。这种场景可以使用原子类：

```java
AtomicInteger counter = new AtomicInteger();

counter.incrementAndGet();
```

原子类通常基于 CAS，也就是 Compare-And-Set：先比较当前值是否是期望值，是则更新，否则重试。

但 CAS 并不意味着所有复合操作都天然安全。多个原子操作组合后，仍可能需要加锁或重新设计状态。陈默想用 `AtomicInteger` 先 `get()` 再 `decrementAndGet()` 来实现"扣减并判断"，老周直接否了——两个原子操作拼在一起，中间照样有空档。最后库存扣减被改成了数据库层面带条件的原子更新，那是第 19 站的故事了。

> **一个操作是原子的，不代表一段逻辑是原子的。**

活动后半段，老周还顺手改掉了另一个隐患：订单详情页要同时调"用户信息"和"订单信息"两个下游服务，陈默原先是一个调用完再调另一个。老周说这两件事互不依赖，串行纯属浪费时间。用 `CompletableFuture` 可以编排异步任务：

```java
CompletableFuture<String> userFuture =
        CompletableFuture.supplyAsync(() -> "用户信息");

CompletableFuture<String> orderFuture =
        CompletableFuture.supplyAsync(() -> "订单信息");

String result = userFuture
        .thenCombine(orderFuture, (user, order) -> user + " + " + order)
        .join();

System.out.println(result);
```

两个任务并行跑，最后在 `thenCombine` 处汇合，总耗时约等于最慢的那一个。但 `CompletableFuture` 用起来也有几个必须想清楚的问题：

- 默认线程池是否合适；
- 异常是否被处理；
- 链路是否会阻塞；
- 是否设置超时；
- 上下文是否正确传递。

陈默在代码评审里被指出的正是第一条：`supplyAsync` 不传线程池时用的是默认的公共池，业务量一大就会互相挤占。

## 第 14 站：一万次骑手定位回传——虚拟线程，"一个请求一个线程"的复兴

月中的运营活动要做骑手端轨迹优化，需要批量回传上万条定位数据，每条回传之间都有一段等待服务端响应的时间。陈默起先按第 12 站的老路子，开了一个固定大小的线程池，结果任务在队列里排起了长队，回传延迟高得离谱。他想加大线程数，老周拦住了他："平台线程是昂贵的操作系统资源，堆到几千个，内存和调度开销先把你压垮。"

虚拟线程改变了这笔账。它让"一个请求对应一个线程"的编程方式重新变得可扩展：

```java
try (ExecutorService executor =
            Executors.newVirtualThreadPerTaskExecutor()) {

    for (int i = 0; i < 10_000; i++) {
        int taskId = i;

        executor.submit(() -> {
            Thread.sleep(100);
            return "任务完成：" + taskId;
        });
    }
}
```

一万个任务、每个都"睡"一百毫秒，用虚拟线程可以轻松跑完——因为虚拟线程在阻塞时会被 JVM 卸载，让出底层平台线程去干别的活。

虚拟线程适合大量阻塞式 I/O 任务，例如：

- 数据库访问；
- HTTP 调用；
- 文件读写；
- RPC 调用。

但它不是"让 CPU 计算自动变快"的工具。

对于 CPU 密集任务，并发度仍然受处理器核心数限制。陈默想用虚拟线程跑订单金额的批量计算，被老周一句话打回去了。

学习虚拟线程时，重点不是记住 API，而是理解：

```text
平台线程是昂贵的操作系统资源；
虚拟线程是由 JVM 调度的轻量级任务载体。
```

## 第 15 站：停不下来的定时任务——Java 内存模型，volatile 不是万能钥匙

青禾外卖有个夜间对账程序，陈默给它加了个"停止开关"：一个 `boolean` 字段，管理后台把开关一关，程序就该退出。可测试那天，开关明明已经是 `false`，对账程序却像没听见一样继续跑。陈默重启了三次程序，问题照旧。

下面这段代码并不安全：

```java
private boolean running = true;

public void stop() {
    running = false;
}

public void work() {
    while (running) {
        // 持续工作
    }
}
```

另一个线程修改 `running` 后，工作线程不一定能够立即看到变化。

可以使用 `volatile`：

```java
private volatile boolean running = true;
```

加上这一个关键字，工作线程每次都会去主内存里重新读取，`stop()` 的修改立刻可见。`volatile` 主要保证：

- 可见性；
- 一定程度的有序性。

但它不保证复合操作的原子性：

```java
volatile int count = 0;
count++;
```

`count++` 实际包含读取、加一、写回多个步骤，仍然不是线程安全的。陈默想把对账计数器换成 `volatile int`，老周指了指第 13 站的 `AtomicInteger`——可见性和原子性是两回事，谁也替代不了谁。

掌握并发编程，必须理解三个核心问题：

1. 原子性：操作是否不可分割；
2. 可见性：一个线程的修改能否被其他线程看到；
3. 有序性：代码执行顺序是否可能被重排。

> **volatile 能让变化被看见，但不能让变化不冲突。**

那天晚上，陈默在笔记本上写下三行字：原子性、可见性、有序性。老周路过瞥了一眼，补了一句："这三个词，够你吃五年。"

## 第 16 站：服务越跑越慢，重启就恢复——类加载、内存区域与垃圾回收

周一早上，青禾外卖的订单服务又开始变慢了。接口响应从八十毫秒涨到两秒，重启一次就好了，过两天又复发。运维同事说"要不写个定时重启脚本"，老周摆摆手："先搞清楚 Java 程序究竟是怎么跑起来的，再说重启的事。"

从源码到运行，大致经历以下过程：

```text
.java 源文件
   ↓ javac
.class 字节码
   ↓ 类加载
JVM 运行时数据区
   ↓ 解释执行 / JIT 编译
机器指令
```

### 15.1 类加载过程

类加载通常包括：

```text
加载
  ↓
验证
  ↓
准备
  ↓
解析
  ↓
初始化
```

常见类加载器包括：

- Bootstrap ClassLoader；
- Platform ClassLoader；
- Application ClassLoader；
- 自定义 ClassLoader。

双亲委派模型可以降低核心类被重复或恶意替换的风险。

### 15.2 JVM 运行时内存

老周在白板上画了第二张图。可以把 JVM 内存粗略理解为：

```text
线程共享
├── 堆
└── 方法区的实现区域

线程私有
├── 程序计数器
├── Java 虚拟机栈
└── 本地方法栈
```

**堆**：对象通常分配在堆中，垃圾回收器主要管理这里。

**虚拟机栈**：每次方法调用会创建栈帧，保存：

- 局部变量；
- 操作数栈；
- 动态链接；
- 方法返回信息。

两个著名的错误也各有归宿。递归过深可能导致：

```text
StackOverflowError
```

堆内存不足可能导致：

```text
OutOfMemoryError
```

陈默想起上个月他在 Controller 里写的那个没有终止条件的递归校验，脸上有点发热。

### 15.3 垃圾回收

服务变慢的答案，多半在垃圾回收上。垃圾回收器会识别不再可达的对象，并回收其内存。

常见概念包括：

- GC Roots；
- 可达性分析；
- 年轻代与老年代；
- Minor GC；
- Full GC；
- 停顿时间；
- 吞吐量；
- 分代假设；
- 对象晋升。

常见垃圾回收器包括：

- Serial GC；
- Parallel GC；
- G1 GC；
- ZGC；
- Shenandoah GC。

选择垃圾回收器时，不要只问"哪个最快"，而要明确目标：

- 更低延迟；
- 更高吞吐量；
- 更小内存占用；
- 更稳定的暂停时间。

老周让陈默先看了一眼服务的 GC 日志：Full GC 频繁，每次停顿都在拖累接口响应。那几次"重启就好了"，其实是把被占住的堆清空了而已。**问题不在重启的间隔，而在内存里到底住着谁。**

### 15.4 JIT 即时编译

还有一个细节让陈默意外：为什么每次重启后，前几分钟接口都偏慢？因为 Java 程序刚启动时，部分字节码可能先被解释执行。

当某段代码成为热点后，JIT 编译器会将它编译为机器码，并进行优化。

常见优化包括：

- 方法内联；
- 逃逸分析；
- 锁消除；
- 公共子表达式消除；
- 循环优化；
- 分支预测相关优化。

这也是为什么 Java 程序预热后，性能可能明显提升。

做性能测试时，不能简单地用一次 `System.nanoTime()` 就下结论。微基准测试应使用 JMH。

## 第 17 站：午高峰 CPU 飙高——jps、jcmd、jstack、jmap 与 JFR

又一个周五午高峰，订单服务的 CPU 打到 95%，告警电话直接打到老周手机上。陈默的第一反应是打开 IDE 翻代码，老周把他按住了："遇到 CPU 飙高、内存泄漏、线程阻塞时，应该先收集证据，而不是凭感觉修改代码。"

常用工具包括：

```text
jps
jcmd
jstack
jmap
jstat
```

### 16.1 查看 Java 进程

第一步，先找到出问题的进程：

```bash
jps -l
```

### 16.2 查看 JVM 信息

确认进程号后，先看 JVM 本身的状态：

```bash
jcmd <pid> VM.version
jcmd <pid> VM.flags
jcmd <pid> GC.heap_info
```

### 16.3 导出线程栈

CPU 飙高最常用的一招，是把线程栈抓下来：

```bash
jstack <pid> > thread-dump.txt
```

线程栈可以帮助定位：

- 死锁；
- 大量阻塞；
- 锁竞争；
- 无限循环；
- 线程池耗尽。

这一次，陈默在 thread-dump.txt 里连抓三份一对比，发现同一个线程组始终停在同一个方法上——一个正则匹配在特定格式的优惠券码上陷入了近乎无限的回溯。

### 16.4 导出堆转储

轮到排查那个"越跑越慢"的内存问题时，就该看堆里装了什么：

```bash
jcmd <pid> GC.heap_dump heap.hprof
```

堆转储可以用 Eclipse MAT、VisualVM 或商业分析工具查看。

### 16.5 Java Flight Recorder

如果想在服务正常运行时持续观察，而不是等出事再抓现场，JFR 能以较低开销记录：

- CPU 热点；
- 对象分配；
- GC 活动；
- 线程状态；
- 锁竞争；
- I/O 行为。

这次事故复盘会上，老周把性能优化的正确流程写在了白板上：

```text
发现问题
  ↓
建立指标
  ↓
采集数据
  ↓
定位瓶颈
  ↓
修改代码或配置
  ↓
再次测量
```

然后他在"修改代码或配置"前面画了一道重重的横线："不要把'修改 JVM 参数'当作第一步。"

> **先测量，再动手。证据不全就改代码，改的只是自己的心安。**

## 第 18 站：审计日志写满了三千行 if——注解与反射

季度安全审查前，产品经理提了个需求：所有订单操作都要记审计日志。陈默的第一版方案，是在每个 Controller 方法开头粘贴一遍 `log.info("用户xx执行了xx操作")`——写完第九个方法，他自己都看不下去了。

老周看了一眼，问他："你天天用 Spring，`@RestController` 一个注解就把一个类变成接口，想过它是怎么做到的吗？"

Java 的注解本身不执行任何逻辑，它只是贴在代码上的标记。最常见的注解大家都写过：

```java
@Override
public String toString() {
    return "User";
}
```

注解也可以自定义：

```java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface Audit {
    String value();
}
```

`@Retention` 决定注解存活到哪个阶段（这里指定为运行时），`@Target` 决定它能不能贴在方法上。使用：

```java
@Audit("创建订单")
public void createOrder() {
}
```

但注解贴上去只是个记号，真正干活的是反射。反射让程序能够在运行时检查和操作类型信息：

```java
Class<?> type = Class.forName("com.example.User");

for (Method method : type.getDeclaredMethods()) {
    System.out.println(method.getName());
}
```

老周带着陈默写了十几行代码：启动时扫描所有方法，凡是标了 `@Audit` 的，就在调用前后统一记录操作名、入参和耗时。三千行重复的 if，缩成了一个切面加一个注解。

Spring 的依赖注入、ORM、序列化框架等都大量使用反射、字节码生成或方法句柄。陈默这才明白，自己每天写的 `@Autowired`、`@Transactional`，底层都是同一套机制在运行时读取注解、操纵对象。

不过，业务代码不应为了"灵活"而滥用反射，因为它会降低可读性、可维护性和静态检查能力。

复盘会结束，陈默删掉了那第九份复制粘贴的日志代码。老周收走白板笔前留下最后一句话："框架替你做了很多事，但只有知道它怎么做的，你才配得上用它。"


## 第 19 站：数据库编程——JDBC、事务与 ORM 选型

周四下午，青禾外卖的告警群炸了。一条短信告警弹出来：`/user/query` 接口疑似被扫描出 SQL 注入风险。陈默点开日志一看，脸就绿了——他在查询接口里写的是 `"SELECT * FROM users WHERE name = '" + name + "'"`，老周三年前让他"永远别拼接 SQL"的话，他背得滚瓜烂熟，只是没往自己代码上想。

当晚他熬夜把这条查询改成了参数化写法，第二天一早又顺手翻了翻自己写的下单逻辑：扣库存、生成订单、记录支付流水，三步竟没有包在一个事务里。老周路过看了一眼，只问了一句："万一第二步挂了呢？"

陈默这才意识到，数据库编程这件事，JDBC 只是入口，后面还连着事务、连接池和 ORM 的整条选择链。

### JDBC：Java 访问数据库的基础 API

JDBC 是 Java 访问关系型数据库的基础 API。典型的查询长这样：

```java
String sql =
        "SELECT id, name, email FROM users WHERE id = ?";

try (
        Connection connection = dataSource.getConnection();
        PreparedStatement statement =
                connection.prepareStatement(sql)
) {
    statement.setLong(1, 1L);

    try (ResultSet resultSet = statement.executeQuery()) {
        if (resultSet.next()) {
            long id = resultSet.getLong("id");
            String name = resultSet.getString("name");
            String email = resultSet.getString("email");

            System.out.println(id + ", " + name + ", " + email);
        }
    }
}
```

使用参数化查询，不要拼接 SQL。

错误写法：

```java
String sql =
        "SELECT * FROM users WHERE name = '" + name + "'";
```

这可能产生 SQL 注入风险。

### 事务：ACID 与事务边界

事务的经典特性是 ACID：

- Atomicity：原子性；
- Consistency：一致性；
- Isolation：隔离性；
- Durability：持久性。

事务不是越大越好。事务范围过大可能导致：

- 锁持有时间过长；
- 吞吐量下降；
- 死锁概率增加；
- 数据库连接长期占用。

### ORM：选型不只看"代码少不少"

常见持久化方案包括：

- Spring JDBC；
- MyBatis；
- JPA；
- Hibernate；
- jOOQ。

选择技术时，不要只比较"代码少不少"，还要考虑：

- SQL 可控性；
- 查询复杂度；
- 团队熟悉度；
- 性能要求；
- 领域模型复杂度；
- 数据库特性依赖程度。

> 老周在告警复盘会上补了一句："数据库这边出了问题，永远是先看证据——日志、慢查询、锁等待，再动手改。"

## 第 20 站：Maven、Gradle、JUnit 与日志——工程化的地基

陈默接手老项目时，曾在依赖里踩过一个坑：同一个工具库，两个模块引了两个版本，本地跑得好好的，一打进 fat jar 就报 `NoSuchMethodError`。他折腾了一晚上才明白，构建工具管的不只是"把代码变成 jar"，还管着依赖从哪来、版本听谁的。

修完依赖冲突，老周让他给修好的逻辑补一个单元测试。陈默写完跑绿，准备提交，顺手往日志里打了一句 `System.out.println("here")`——上次他就是靠这个排查线上问题的。老周把这一行删了，说："工程化的地基，就四块：构建、依赖、测试、日志。少一块，项目都站不稳。"

### Maven 与 Gradle：构建工具

现代 Java 项目离不开构建工具。

#### Maven

典型 Maven 项目结构：

```text
project
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   └── resources
    └── test
        ├── java
        └── resources
```

常用命令：

```bash
mvn clean
mvn test
mvn package
mvn verify
```

依赖示例：

```xml
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <scope>test</scope>
</dependency>
```

#### Gradle

常用命令：

```bash
./gradlew clean
./gradlew test
./gradlew build
```

Maven 约定明确、生态成熟；Gradle 更灵活，构建脚本表达能力更强。

初学者先掌握其中一个即可。

### 单元测试：没有测试的代码，很难安全重构

没有测试的代码，很难安全重构。

使用 JUnit：

```java
import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class CalculatorTest {

    @Test
    void shouldAddTwoNumbers() {
        Calculator calculator = new Calculator();

        int result = calculator.add(2, 3);

        assertEquals(5, result);
    }
}
```

一个清晰的测试通常包括：

```text
Given：准备条件
When：执行行为
Then：验证结果
```

测试重点应该放在：

- 业务规则；
- 边界条件；
- 异常路径；
- 核心计算；
- 容易回归的逻辑。

不要只为了提高覆盖率而编写没有价值的测试。

### 日志：别用 System.out.println 代替生产日志

不要使用 `System.out.println` 代替生产日志。

常见日志门面与实现包括：

- SLF4J；
- Logback；
- Log4j 2。

示例：

```java
private static final Logger log =
        LoggerFactory.getLogger(OrderService.class);

public void createOrder(long userId) {
    log.info("开始创建订单，userId={}", userId);
}
```

不要这样写：

```java
log.info("开始创建订单，userId=" + userId);
```

参数化日志通常更清晰，也能减少不必要的字符串拼接。

日志中不要记录：

- 密码；
- 完整银行卡号；
- 访问令牌；
- 私钥；
- 身份证号等敏感信息。

日志应该帮助回答三个问题：

1. 发生了什么？
2. 对哪个请求、用户或业务对象发生？
3. 为什么发生？

> 老周："日志是写给三个月后的自己看的。"

## 第 21 站：Spring Boot 与 REST API 设计

青禾外卖要开放一个给运营后台用的用户查询接口。周二的接口设计评审会上，陈默把方案投到墙上：`GET /getUserById?uid=1`，出错时返回 `{"message": "系统错误"}`。会议室安静了三秒，做前端的同事先开口："‘系统错误’这四个字，让我怎么定位问题？"

老周在白板上画了四条 URL，问大家哪个更顺眼，然后讲起了资源命名、状态码和统一错误格式。陈默盯着白板上那条 `/api/orders?page=0&size=20`，忽然明白自己之前写的不是 API，只是"能用 HTTP 传数据的口子"。

评审会的最后一条结论，是老周顺手在陈默的三千行 Controller 截图上画的一个大圈："下次分层，Controller 里只留协议转换。"

### Spring Boot 入门

Spring Boot 不是 Java 的全部，但它是 Java 后端开发最常用的技术栈之一。

一个简单的 REST 接口：

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    @GetMapping("/{id}")
    public UserResponse getUser(@PathVariable long id) {
        return new UserResponse(id, "Alice");
    }
}
```

```java
public record UserResponse(
        long id,
        String name
) {
}
```

请求：

```text
GET /api/users/1
```

响应：

```json
{
  "id": 1,
  "name": "Alice"
}
```

#### 推荐分层

```text
Controller
    ↓
Application Service
    ↓
Domain / Business Logic
    ↓
Repository
    ↓
Database
```

每一层有明确职责：

- Controller：协议转换、参数校验；
- Service：业务流程编排；
- Domain：核心业务规则；
- Repository：数据访问；
- Infrastructure：外部系统适配。

不要把所有逻辑都写进 Controller，也不要把 Service 变成只会转发调用的空壳。

### REST API 设计

一个好的 API 不只是"能返回 JSON"。

需要考虑：

- 资源命名；
- HTTP 方法；
- 状态码；
- 错误格式；
- 幂等性；
- 分页；
- 版本控制；
- 鉴权；
- 限流；
- 可观测性。

示例：

```text
POST /api/orders
GET /api/orders/{id}
GET /api/orders?page=0&size=20
PUT /api/orders/{id}
DELETE /api/orders/{id}
```

统一错误响应：

```json
{
  "code": "ORDER_NOT_FOUND",
  "message": "订单不存在",
  "traceId": "7f8c2a..."
}
```

不要只返回：

```json
{
  "message": "系统错误"
}
```

错误信息既要对调用方稳定，又不能泄露内部实现细节。

## 第 22 站：缓存、消息队列与分布式系统——引入中间件是新复杂度

青禾外卖上优惠券活动那天，运营在群里喊"券没了但还能领"，陈默查了半小时，最后发现是缓存里的券余量和数据库对不上——他直接把查询结果塞进了 Redis，过期时间一拍脑袋设了十分钟。活动高峰期，同一张券被核销了三次。

老周没骂他，只是把他叫到白板前，在 Redis 和数据库之间画了几个问号："加缓存之前，这几个问题你答上来几个？"白板上写着：缓存什么、过期多久、未命中怎么办、怎么防穿透击穿雪崩、数据更新时怎么保持一致。陈默一个都没答上来。

更糟的还在后面：为了削峰，他又引入了消息队列发券，结果消息重复消费，券又超发了一轮。老周总结得干脆："**引入中间件不是架构升级，而是用新的复杂度解决已有问题。**"

当单体应用逐渐变大，常见基础设施会包括：

- Redis；
- Kafka；
- RabbitMQ；
- Elasticsearch；
- 对象存储；
- 配置中心；
- 服务注册与发现；
- 分布式追踪。

但要牢记：

> 引入中间件不是架构升级，而是用新的复杂度解决已有问题。

### 使用缓存前要回答

- 缓存什么？
- 过期时间是多少？
- 缓存未命中怎么办？
- 如何避免缓存穿透？
- 如何避免缓存击穿？
- 如何避免缓存雪崩？
- 数据更新时如何保持一致性？

### 使用消息队列前要回答

- 消息是否允许重复？
- 消费失败如何重试？
- 是否要求顺序？
- 如何保证幂等？
- 如何处理死信？
- 消息积压如何发现？
- 生产者成功、数据库失败怎么办？

分布式系统最难的部分，不是调用远程接口，而是处理失败、延迟、重复和不一致。

## 第 23 站：设计原则与设计模式——抽象要服务于变化

到了老周给陈默"出师考核"的时候。考题不写代码，只做一个 review：陈默半年前写的支付模块。一个类里，参数校验、数据库访问、文件上传、发短信、生成报表、记审计日志全在，支付方式是三米长的 `if-else`，从 `card` 判断到 `wallet` 再到 `coupon`。

老周只圈了一个问题："如果要接第四种支付方式，你要改几处？"陈默数了数，至少五处。老周让他当场把支付抽象成一个接口，把每种支付方式做成独立实现，再把 `OrderService` 里的依赖倒过来。改完之后陈默自己看着都舒服——增加一种支付，只需要加一个类。

老周最后提了一句："模式别背。工厂、策略、模板方法、观察者、适配器、装饰器、责任链，都是别人踩过坑之后起的名字。你的代码里没有那个变化点，套上去就是负担。"

### 设计原则

#### 单一职责

一个类应该有一个清晰的变化原因。

不要让一个类同时负责：

- 参数校验；
- 数据库访问；
- 文件上传；
- 发送短信；
- 生成报表；
- 记录审计日志。

#### 开闭原则

对扩展开放，对修改关闭。

例如，把支付方式抽象成接口：

```java
public interface PaymentProcessor {
    void pay(PaymentCommand command);
}
```

不同实现：

```java
public class CardPaymentProcessor
        implements PaymentProcessor {
}

public class WalletPaymentProcessor
        implements PaymentProcessor {
}
```

增加支付方式时，不需要把原有代码改成巨大的 `if-else`。

#### 依赖倒置

高层业务代码依赖抽象，不直接依赖具体实现。

```java
public class OrderService {

    private final PaymentProcessor paymentProcessor;

    public OrderService(PaymentProcessor paymentProcessor) {
        this.paymentProcessor = paymentProcessor;
    }
}
```

这会让代码更容易测试、替换和扩展。

### 常见设计模式

设计模式不是需要背诵的模板，而是对重复设计经验的命名。

#### 工厂模式

负责创建对象，隐藏具体构造逻辑。

#### 策略模式

把一组可替换算法抽象成统一接口。

#### 模板方法

在父类中定义流程骨架，让子类实现变化步骤。

#### 观察者模式

当对象状态变化时，通知订阅者。

#### 适配器模式

把不兼容接口转换为目标接口。

#### 装饰器模式

不修改原类的情况下动态增强功能。

#### 责任链模式

让请求依次经过多个处理节点。

不要因为学了模式，就到处套模式。模式应该解决真实变化点，而不是增加抽象层数。

## 第 24 站：实战项目与学习路线——订单系统 + 12 周路线 + 五阶段

出师考核通过那天，老周没有给陈默发什么证书，只给他派了一个新活：把青禾外卖的订单模块按标准做法重写一遍，可独立运行、可部署、有测试。陈默起初觉得是杂活，写到第三天才发现，这个订单管理 API 几乎把他这一年踩过的坑全部串了一遍——金额校验、状态流转、库存扣减、操作日志。

改完最后一行代码，陈默把项目 README 推上去，附了一份 12 周学习计划给组里新来的实习生。老周看完，在结尾补了一段话："路线图只是地图，走不走得到，看你写不写代码。"

### 实战项目：订单管理 API

学完基础后，建议完成一个可运行的后端项目。

#### 功能列表

```text
用户注册与登录
商品查询
创建订单
订单详情
订单列表
取消订单
支付订单
库存扣减
操作日志
```

#### 数据表

```text
users
products
orders
order_items
payments
inventory
operation_logs
```

#### 核心状态

```java
public enum OrderStatus {
    CREATED,
    PAID,
    CANCELLED,
    COMPLETED
}
```

#### 订单实体

```java
public class Order {

    private final long id;
    private OrderStatus status;
    private long totalAmount;

    public Order(long id, long totalAmount) {
        if (totalAmount <= 0) {
            throw new IllegalArgumentException("订单金额必须大于 0");
        }

        this.id = id;
        this.totalAmount = totalAmount;
        this.status = OrderStatus.CREATED;
    }

    public void pay() {
        if (status != OrderStatus.CREATED) {
            throw new IllegalStateException("当前状态不能支付");
        }

        status = OrderStatus.PAID;
    }

    public void cancel() {
        if (status == OrderStatus.PAID) {
            throw new IllegalStateException("已支付订单不能直接取消");
        }

        if (status == OrderStatus.COMPLETED) {
            throw new IllegalStateException("已完成订单不能取消");
        }

        status = OrderStatus.CANCELLED;
    }

    public long getId() {
        return id;
    }

    public OrderStatus getStatus() {
        return status;
    }

    public long getTotalAmount() {
        return totalAmount;
    }
}
```

注意，业务规则被放进实体，而不是散落在 Controller 中。

#### 继续完善

完成基础功能后，可以逐步增加：

- 参数校验；
- 数据库事务；
- 幂等键；
- 乐观锁；
- Redis 缓存；
- 消息队列；
- 订单超时关闭；
- 接口鉴权；
- Docker 部署；
- Prometheus 指标；
- 分布式追踪；
- 压力测试；
- 故障演练。

这个项目足以串联大部分 Java 后端知识。

### 常见错误与改进方式

#### 错误一：只看视频，不写代码

改进：

- 每学一个概念，写一个最小示例；
- 每学一章，完成一个小练习；
- 每两周，完成一个可运行项目。

#### 错误二：只会使用框架

很多初学者会写：

```java
@Autowired
@Service
@RestController
```

却不知道：

- 对象如何创建；
- 依赖如何注入；
- 代理如何生成；
- 事务为什么可能失效；
- 注解如何被读取；
- Bean 生命周期如何管理。

改进方式是回到 Java 基础、反射、代理、类加载和设计模式。

#### 错误三：迷信源码

不是所有源码都值得一开始就读。

推荐顺序：

1. 先学会使用；
2. 理解核心概念；
3. 带着问题调试；
4. 再阅读关键路径源码。

#### 错误四：过早学习微服务

在没有掌握单体应用、数据库事务和接口设计之前，微服务只会把问题放大。

先把一个单体项目写清楚，再学习：

- 服务拆分；
- 分布式事务；
- 服务治理；
- 限流熔断；
- 链路追踪。

#### 错误五：忽视计算机基础

真正决定上限的知识包括：

- 数据结构与算法；
- 操作系统；
- 计算机网络；
- 数据库；
- 编译原理基础；
- 软件工程；
- 分布式系统。

框架会更新，但这些基础知识长期有效。

### Java 面试知识地图

#### 基础语法

- `==` 和 `equals`；
- `String` 为什么不可变；
- `final`、`finally`；
- 深拷贝与浅拷贝；
- 接口与抽象类；
- 重载与重写。

#### 集合

- ArrayList 扩容；
- HashMap 原理；
- ConcurrentHashMap；
- fail-fast；
- Comparable 与 Comparator。

#### 并发

- synchronized；
- volatile；
- CAS；
- AQS；
- 线程池；
- ThreadLocal；
- CompletableFuture；
- 虚拟线程；
- Java 内存模型。

#### JVM

- 类加载；
- 双亲委派；
- 堆与栈；
- 对象创建过程；
- GC 算法；
- G1、ZGC；
- 内存泄漏排查；
- CPU 飙高排查。

#### 数据库

- 索引；
- B+ 树；
- 事务隔离；
- MVCC；
- 锁；
- 慢查询；
- 分库分表。

#### Spring

- IOC；
- AOP；
- Bean 生命周期；
- 循环依赖；
- 事务传播；
- 事务失效；
- Spring MVC 流程；
- Spring Boot 自动配置。

#### 分布式系统

- 缓存一致性；
- 消息幂等；
- 分布式锁；
- 限流；
- 熔断；
- 一致性与可用性；
- 服务拆分；
- 分布式事务。

不要把面试题当成知识终点。最好的学习方式，是把每个问题映射到真实项目。

### 12 周学习路线

#### 第 1～2 周：语法基础

学习：

- 开发环境；
- 变量与数据类型；
- 运算符；
- 分支和循环；
- 数组；
- 方法；
- String。

练习：

- 猜数字；
- 学生成绩统计；
- 简单记账程序；
- 命令行通讯录。

#### 第 3～4 周：面向对象

学习：

- 类与对象；
- 构造方法；
- 封装；
- 继承；
- 多态；
- 接口；
- 枚举；
- `record`；
- 密封类。

练习：

- 图书管理系统；
- 银行账户系统；
- 简单购物车。

#### 第 5～6 周：核心类库

学习：

- 集合；
- 泛型；
- 异常；
- 日期时间；
- I/O；
- NIO；
- Lambda；
- Stream；
- Optional。

练习：

- 日志分析器；
- CSV 数据统计；
- 文件批量重命名工具。

#### 第 7～8 周：并发与 JVM

学习：

- Thread；
- 线程池；
- 锁；
- 原子类；
- CompletableFuture；
- 虚拟线程；
- Java 内存模型；
- JVM 内存；
- GC；
- JFR。

练习：

- 多线程下载器；
- 并发任务调度器；
- 简单压力测试工具。

#### 第 9～10 周：数据库与 Web

学习：

- SQL；
- JDBC；
- MySQL；
- Spring Boot；
- REST API；
- 参数校验；
- 全局异常处理；
- MyBatis 或 JPA；
- 事务。

练习：

- 用户系统；
- 博客 API；
- 商品管理系统。

#### 第 11～12 周：工程化项目

学习：

- Maven 或 Gradle；
- JUnit；
- Mock；
- Git；
- 日志；
- Docker；
- API 文档；
- 监控指标；
- 性能测试。

项目：

- 完整订单系统；
- 部署到服务器；
- 编写 README；
- 编写测试；
- 记录架构决策；
- 完成一次性能分析和优化。

### 从"会写 Java"到"精通 Java"

可以把 Java 能力分为五个阶段。

#### 第一阶段：能写

你可以：

- 写基础语法；
- 创建类和对象；
- 使用集合；
- 完成命令行程序。

#### 第二阶段：能做项目

你可以：

- 使用 Spring Boot；
- 连接数据库；
- 编写 REST API；
- 处理异常和事务；
- 使用构建工具。

#### 第三阶段：能解决问题

你可以：

- 定位线程阻塞；
- 分析慢 SQL；
- 排查内存泄漏；
- 设计缓存；
- 优化接口性能；
- 处理并发一致性。

#### 第四阶段：能设计系统

你可以：

- 划分模块边界；
- 设计稳定接口；
- 选择合适存储；
- 设计失败恢复机制；
- 权衡一致性、性能和复杂度。

#### 第五阶段：能建立方法论

真正的精通不是记住所有 API，而是面对陌生问题时能够：

1. 准确定义问题；
2. 建立可观测指标；
3. 找到关键约束；
4. 提出多个方案；
5. 比较成本与收益；
6. 通过实验验证；
7. 沉淀为团队规范。

### 给 Java 学习者的十条建议

1. 使用一个较新的 LTS 版本学习，不要从过时语法体系开始；
2. 每天写代码，而不是只收藏教程；
3. 学会阅读异常堆栈；
4. 熟练使用 IDE 调试器；
5. 把集合、并发和 JVM 当作核心内容；
6. 用项目串联知识，而不是孤立背诵；
7. 学好 SQL、网络和操作系统；
8. 性能优化前先测量；
9. 抽象要服务于变化，不要为了模式而模式；
10. 持续阅读高质量代码，并主动重构自己的旧项目。

### 结语

Java 的难点，从来不是语法多。

真正的难点在于：

- 如何建立清晰的对象模型；
- 如何在并发环境下保证正确性；
- 如何理解 JVM 的运行机制；
- 如何让代码便于测试和维护；
- 如何在复杂系统中控制失败与不确定性。

从入门到精通，不是一条"学完全部知识点"的路线，而是不断经历下面的循环：

```text
学习概念
  ↓
编写代码
  ↓
遇到问题
  ↓
调试与分析
  ↓
阅读源码和文档
  ↓
重新设计
```

当你能够独立完成项目、定位线上问题、解释技术取舍，并写出让团队成员容易理解和维护的代码时，你就已经不再只是"会写 Java"，而是在真正掌握 Java。

### 参考资料

- OpenJDK：JDK Project 与各版本发布说明
- Oracle：Java SE Support Roadmap
- Oracle Java Documentation：Java SE API、语言更新与迁移指南
- Java Language Specification
- Java Virtual Machine Specification

> 建议将官方文档作为长期参考资料。教程负责帮助你入门，规范与官方文档负责帮助你确认边界。
---

三个月后的又一个周五，晚市半价活动照常进行。订单量冲上了那次事故之夜的五倍，而这一次，监控曲线平稳得像一条直线：金额精确到分、库存分毫不差、GC 日志安静、告警群里一条消息也没有。

陈默把这段日子学到的东西总结成了一张清单，贴在工位上：

- 语法和集合是地基，并发和 JVM 是分水岭；
- 业务规则要放进对象里，而不是散落在 Controller 中；
- 引入任何中间件之前，先想清楚它在解决什么问题；
- 性能优化前先测量，排障先收集证据；
- 抽象要服务于变化，不要为了模式而模式；
- 代码是给人读的，测试是给未来写的。

当你不再把 Java 当成"一门要背的语法"，而是当成一套管理复杂度的工程体系时，才真正理解了这门语言为什么能走过三十年，依然是无数核心系统的底座。

> Java 的难点，从来不是语法多，而是你能否用它建立起清晰的对象模型，在并发环境下保证正确性，并让代码便于测试和维护。

青禾外卖的故事告一段落，但你的故事才刚刚开始。打开终端，敲下第一行 Java 代码吧。

---

## 官方延伸阅读

- dev.java 官方学习站：https://dev.java/
- OpenJDK：https://openjdk.org/
- Java SE 文档：https://docs.oracle.com/en/java/javase/25/
- Java Language Specification：https://docs.oracle.com/javase/specs/
- Java Virtual Machine Specification：https://docs.oracle.com/javase/specs/jvms/
- Spring Boot 官方文档：https://spring.io/projects/spring-boot
- JMH 微基准测试：https://github.com/openjdk/jmh
