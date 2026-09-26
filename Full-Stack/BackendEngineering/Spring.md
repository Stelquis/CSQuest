# [Spring从入门到精通：从IoC容器到企业级工程实践](https://mp.weixin.qq.com/s/xd8WyB_BREkwdsZDzbWlSQ)

> 这是一个关于「擎舟科技」的故事——一支七人团队正在搭建名为「云单」的订单中台，和他们的技术负责人郑航一起，带着新人小柯从"会调注解"走到"能设计容器边界"的完整旅程。你会跟着小柯一起，把 IoC、Bean 生命周期、AOP、事务、MVC、自动配置一条条打通。读完之后你会发现：Spring 真正难的地方，不是记住多少个注解，而是理解——**对象由谁创建、依赖如何连接、功能怎样增强、请求如何流转、事务为何生效。**一旦把这五件事想清楚，Spring 庞大的知识体系就会从"注解迷宫"变成一套结构清晰的工程方法。

---

## 故事的起点：一次评审会上的灵魂三问

"擎舟科技"是一家做供应链 SaaS 的公司，刚拿到 B 轮融资，正在搭建面向所有客户的「云单」订单中台：上游对接十几种电商平台，下游连着仓库和结算系统。团队七个工程师，技术栈定的是 Java 17 + Spring Boot。

小柯入职第二周，提了他的第一个合并请求——一个订单查询接口，代码能跑，测试也过了。评审会上，技术负责人郑航只问了三个问题：

- "这个 `UserController` 是谁创建的？"
- "你在这个方法上加 `@Transactional`，事务是从哪里开始的，到哪里结束？"
- "如果明天要把数据库从 MySQL 换成别的实现，你的代码要改几行？"

小柯一个都答不上来。他注解背得很熟，`@Service`、`@Autowired`、`@Transactional` 用起来也不含糊，可这三个问题像三根针，一下戳破了"会调注解"的泡沫。

那天晚上，郑航在小柯的工位上留了一张便签：

> Spring 的核心从来不是注解，而是职责边界的重新划分。
> 把这三个问题想明白，你再往下学，每一步都踩在实地上。

小柯给自己定了个目标：**借「云单」项目的第一个迭代，把 Spring 从 IoC 容器到生产部署完整过一遍，下次评审会，主动把这三个问题讲清楚。**

这个故事，就是他从头到尾走完的路线图。

---

## 第一站：为什么订单中台离不开 Spring

在「云单」立项之前，公司里跑着一套祖传订单系统。没有框架的年代，一个业务类需要什么对象，通常就自己创建什么对象：

```java
public class OrderService {
    private final OrderRepository orderRepository =
            new JdbcOrderRepository();

    public void createOrder() {
        orderRepository.save();
    }
}
```

这套祖传代码看起来很简单，却隐藏着许多问题：

1. `OrderService`与`JdbcOrderRepository`紧密耦合；
2. 想改成内存实现、MyBatis实现或远程服务实现，需要修改业务代码；
3. 单元测试时很难替换依赖；
4. 数据源、事务、日志、权限、缓存等基础设施会不断侵入业务类；
5. 对象的创建顺序、初始化、销毁和作用域都需要开发者自己管理。

"重构这套系统的时候，"郑航在白板上写，"我们花了一个月，才把'new'出来的对象全部理清楚。Spring 的核心价值，就是把这些'通用但复杂'的工作从业务代码中抽离出去。"

它帮助应用解决三类问题：

- **对象管理问题**：谁创建对象、何时创建、如何销毁；
- **对象协作问题**：对象之间的依赖如何装配；
- **横切能力问题**：事务、日志、权限、缓存等功能如何统一织入。

因此，Spring并不是简单地"让Java代码少写几行"，而是在重新划分应用程序的职责边界。

## 第二站：Spring、Spring Framework与Spring Boot是什么关系

很多初学者会把Spring和Spring Boot混为一谈，「云单」团队的测试工程师一开始也以为"Spring Boot 就是 Spring 的新版本"。

更准确地说：

- **Spring Framework**是底层基础框架；
- **Spring Boot**是建立在Spring Framework之上的快速开发体系；
- **Spring生态**则包含Spring Security、Spring Data、Spring Cloud、Spring Batch等项目。

郑航把它们理解成一座城市：

```text
Spring Framework：道路、电网、供水等基础设施
Spring Boot：标准化住宅与快捷装修方案
Spring Security：安防系统
Spring Data：数据访问系统
Spring Cloud：分布式与微服务配套设施
Spring Batch：批处理工厂
```

Spring Framework的核心模块包括：

| 模块 | 主要职责 |
| --- | --- |
| Core Container | IoC、依赖注入、Bean管理 |
| AOP | 面向切面编程与代理 |
| Data Access | JDBC、事务、ORM集成 |
| Web MVC | Servlet栈Web应用 |
| WebFlux | 响应式Web应用 |
| Testing | 单元测试与集成测试支持 |

现代项目通常从Spring Boot开始，但要真正掌握Spring，仍然必须理解Spring Framework的底层原理。

> 本文示例采用Java 17+与现代Spring Boot项目结构。Spring Framework 6之后已迁移到`jakarta.*`命名空间，旧项目中常见的`javax.*`代码需要在升级时特别关注。

---

## 第三站：创建「云单」的第一个Spring项目

最方便的方式是使用Spring Initializr生成项目。

郑航给「云单」选的初始依赖：

- Spring Web
- Validation
- Spring Data JPA或MyBatis
- H2 Database或MySQL Driver
- Spring Boot Test
- Actuator

一个典型项目结构如下：

```text
spring-demo
├── pom.xml
└── src
    ├── main
    │   ├── java
    │   │   └── com.example.demo
    │   │       ├── DemoApplication.java
    │   │       ├── controller
    │   │       ├── service
    │   │       ├── repository
    │   │       ├── domain
    │   │       └── config
    │   └── resources
    │       ├── application.yml
    │       └── static
    └── test
```

启动类：

```java
package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }
}
```

`@SpringBootApplication`并不是一个神秘的"万能注解"，它主要组合了三个能力：

```java
@SpringBootConfiguration
@EnableAutoConfiguration
@ComponentScan
```

分别代表：

1. 当前类是配置类；
2. 启用自动配置；
3. 扫描当前包及其子包中的组件。

---

## 第四站：完成第一个REST接口

```java
package com.example.demo.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloController {

    @GetMapping("/hello")
    public String hello() {
        return "Hello Spring";
    }
}
```

启动项目后访问：

```text
GET http://localhost:8080/hello
```

返回：

```text
Hello Spring
```

小柯只写了一个普通Java类，却已经自动获得：

- HTTP服务器；
- 路由映射；
- 请求解析；
- Controller实例管理；
- JSON序列化基础设施；
- 异常处理链；
- 日志与配置体系。

这就是Spring Boot的便利。

但郑航的评审会三问之一，此刻出现了：

> `HelloController`到底是谁创建的？

答案是：**Spring容器。**

---

## 第五站：IoC到底是什么

IoC全称是Inversion of Control，即控制反转。

传统方式中，对象的控制权在业务代码手里：

```java
UserRepository repository = new JdbcUserRepository();
UserService service = new UserService(repository);
```

使用Spring后，对象由容器创建：

```java
@Service
public class UserService {

    private final UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }
}
```

业务类不再负责寻找和创建依赖，只需要声明：

> "我需要一个`UserRepository`。"

至于这个对象：

- 由哪个实现类提供；
- 什么时候创建；
- 是否是单例；
- 是否需要代理；
- 是否需要初始化；
- 最终注入到哪里；

都由Spring容器处理。

这就是控制反转。

---

## 第六站：DI与IoC有什么区别

DI是Dependency Injection，即依赖注入。

IoC是一种更广泛的设计思想，DI是Spring实现IoC的主要方式。

小柯的理解被郑航改成了这样一句话：

```text
IoC：对象控制权交给容器
DI：容器把对象需要的依赖注入进去
```

常见注入方式有三种：

### 1. 构造器注入

```java
@Service
public class OrderService {

    private final OrderRepository orderRepository;

    public OrderService(OrderRepository orderRepository) {
        this.orderRepository = orderRepository;
    }
}
```

这是最推荐的方式。

优点：

- 依赖明确；
- 字段可以声明为`final`；
- 对象创建后即处于完整状态；
- 容易编写单元测试；
- 更容易发现循环依赖；
- 不依赖反射修改私有字段。

当类只有一个构造器时，一般不需要写`@Autowired`。「云单」团队的代码规范第一条就是：业务服务一律构造器注入。

### 2. Setter注入

```java
@Service
public class ReportService {

    private Exporter exporter;

    @Autowired
    public void setExporter(Exporter exporter) {
        this.exporter = exporter;
    }
}
```

适合可选依赖或需要重新配置的依赖，但一般业务服务中使用较少。

### 3. 字段注入

```java
@Service
public class PaymentService {

    @Autowired
    private PaymentGateway paymentGateway;
}
```

虽然写起来最短，但不推荐作为默认方式，因为：

- 依赖被隐藏；
- 不方便脱离Spring进行测试；
- 无法使用`final`；
- 可能让类在依赖未准备完整时被创建；
- 容易让一个类不知不觉拥有过多依赖。

评审会上小柯那个"字段能直接注入"的写法，就是在这一站被郑航打回去的。

---

## 第七站：Bean是什么

被Spring容器管理的对象称为Bean。

例如：

```java
@Component
public class IdGenerator {
}
```

`IdGenerator`是一个普通Java类。经过组件扫描后，Spring会为它创建对象，并将其注册到容器中。

可以把容器理解为一个高级对象工厂：

```text
Bean名称  ->  Bean定义  ->  Bean实例
```

容器内部并不只是保存对象，还会保存大量元数据，例如：

- Bean对应的类；
- Bean名称；
- 作用域；
- 是否延迟初始化；
- 初始化方法；
- 销毁方法；
- 构造参数；
- 属性依赖；
- 是否需要代理；
- 工厂方法。

这些元数据在Spring内部通常由`BeanDefinition`表示。

---

## 第八站：注册Bean的常见方式

### 1. 使用`@Component`

```java
@Component
public class SnowflakeIdGenerator {
}
```

### 2. 使用语义化注解

```java
@Service
public class UserService {
}

@Repository
public class UserRepository {
}

@Controller
public class PageController {
}

@RestController
public class UserController {
}
```

这些注解本质上都属于组件注解，但表达的语义不同：

| 注解 | 常见层次 |
| --- | --- |
| `@Component` | 通用组件 |
| `@Service` | 业务服务 |
| `@Repository` | 数据访问层 |
| `@Controller` | MVC控制器 |
| `@RestController` | REST控制器 |

`@Repository`还具有数据访问异常转换的语义。

### 3. 使用`@Bean`

当对象来自第三方类库，无法直接修改源码添加`@Component`时，可以在配置类中注册。「云单」需要把 clock 作为可替换组件，就是这么做的：

```java
@Configuration
public class AppConfig {

    @Bean
    public Clock clock() {
        return Clock.systemUTC();
    }
}
```

### 4. 使用`@Import`

```java
@Configuration
@Import({AppConfig.class, SecurityConfig.class})
public class RootConfig {
}
```

`@Import`适合模块化组合配置。

---

## 第九站：多个同类型Bean如何选择

「云单」上游平台众多，支付网关就有两个实现：

```java
public interface PaymentGateway {
    void pay();
}
```

```java
@Component
public class AlipayGateway implements PaymentGateway {
    @Override
    public void pay() {
        System.out.println("Alipay");
    }
}
```

```java
@Component
public class WechatPayGateway implements PaymentGateway {
    @Override
    public void pay() {
        System.out.println("Wechat Pay");
    }
}
```

此时直接注入：

```java
public PaymentService(PaymentGateway gateway) {
    this.gateway = gateway;
}
```

Spring无法确定选择哪个实现，启动直接报错。

解决方法一：使用`@Primary`

```java
@Primary
@Component
public class AlipayGateway implements PaymentGateway {
}
```

解决方法二：使用`@Qualifier`

```java
@Service
public class PaymentService {

    private final PaymentGateway gateway;

    public PaymentService(
            @Qualifier("wechatPayGateway") PaymentGateway gateway) {
        this.gateway = gateway;
    }
}
```

郑航给出的选择原则：

- 存在一个默认实现：用`@Primary`；
- 调用方必须明确选择：用`@Qualifier`；
- 需要全部实现：注入`List<PaymentGateway>`或`Map<String, PaymentGateway>`。

「云单」的路由层最终选了第三种：

```java
@Service
public class PaymentRouter {

    private final Map<String, PaymentGateway> gateways;

    public PaymentRouter(Map<String, PaymentGateway> gateways) {
        this.gateways = gateways;
    }
}
```

这种写法非常适合策略模式——新接一个支付渠道，只要加一个实现类，路由代码一行不改。

---

# 第二部分：Bean生命周期与容器原理

## 第十站：Bean生命周期概览

「云单」上线前的一次排障，让小柯第一次真正关注Bean的生命周期：某个客户端Bean的连接还没建立，就被别的组件拿去用了。郑航说，看懂这张图，这类问题就再也不神秘。

一个Bean从定义到可用，大致经历：

```text
读取配置
  ↓
注册BeanDefinition
  ↓
实例化Bean
  ↓
填充属性和依赖注入
  ↓
执行Aware回调
  ↓
BeanPostProcessor前置处理
  ↓
初始化
  ↓
BeanPostProcessor后置处理
  ↓
放入容器并提供使用
  ↓
容器关闭时执行销毁逻辑
```

其中最关键的扩展点是`BeanPostProcessor`。

许多Spring高级功能都依赖它完成，例如：

- `@Autowired`注入；
- `@PostConstruct`处理；
- AOP代理创建；
- 事务代理；
- 异步代理；
- 缓存代理。

换句话说，Spring并不是在每个注解出现时"硬编码处理"，而是通过可扩展的后处理器体系完成增强。

---

## 第十一站：初始化与销毁方法

```java
@Component
public class CacheClient {

    @PostConstruct
    public void init() {
        System.out.println("连接缓存");
    }

    @PreDestroy
    public void destroy() {
        System.out.println("释放连接");
    }
}
```

现代Spring使用的是：

```java
import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
```

也可以通过`@Bean`配置：

```java
@Bean(initMethod = "start", destroyMethod = "stop")
public Worker worker() {
    return new Worker();
}
```

郑航在评审时反复强调一条：不要在构造器里执行依赖外部系统的重操作。构造器更适合完成对象自身状态初始化；连接数据库、读取远程配置、启动线程等操作应谨慎放在初始化阶段。

---

## 第十二站：Bean作用域

Spring常见作用域：

| 作用域 | 含义 |
| --- | --- |
| singleton | 一个容器中一个实例，默认值 |
| prototype | 每次获取创建新实例 |
| request | 每个HTTP请求一个实例 |
| session | 每个HTTP会话一个实例 |
| application | 每个ServletContext一个实例 |
| websocket | 每个WebSocket会话一个实例 |

示例：

```java
@Component
@Scope("prototype")
public class TaskContext {
}
```

需要注意：

> Spring的`singleton`不是JVM全局单例，而是"每个Spring容器中每个Bean定义一个实例"。

---

## 第十三站：单例Bean一定线程安全吗

不一定。

压测「云单」的第一晚，小柯就踩过这个坑——接口统计数字在并发下对不上。

Spring默认创建单例Bean，但Spring不会自动保证你的业务状态线程安全。

危险写法：

```java
@Service
public class CounterService {

    private int count = 0;

    public int next() {
        return ++count;
    }
}
```

多个请求同时调用时会发生竞态条件。

更好的原则是：

- Service尽量设计为无状态对象；
- 不要把请求级数据放进单例字段；
- 共享状态使用数据库、缓存或线程安全结构；
- 必要时使用原子类、锁或合适的作用域。

---

## 第十四站：循环依赖为什么危险

```java
@Service
public class AService {
    public AService(BService bService) {
    }
}
```

```java
@Service
public class BService {
    public BService(AService aService) {
    }
}
```

这形成了循环依赖。

构造器循环依赖通常无法完成创建，也是Spring在提醒你：

> 两个组件的职责可能没有正确拆分。

常见解决方案：

1. 提取第三个协调服务；
2. 使用事件机制解耦；
3. 重新划分业务边界；
4. 引入接口，降低直接依赖；
5. 极少数特殊场景使用`@Lazy`，但不应把它当作常规修复方案。

循环依赖通常是设计问题，而不是注解问题。郑航的原话是："容器帮你绕过去了，架构师还得把边界画回来。"

---

# 第三部分：配置管理

## 第十五站：使用`application.yml`

「云单」的支付超时配置，最初散落在各个类里，后来统一收敛到了配置文件：

```yaml
server:
  port: 8080

spring:
  application:
    name: order-service

app:
  payment:
    timeout: 3s
    retry-count: 3
```

可以使用`@Value`读取单个配置：

```java
@Component
public class PaymentClient {

    @Value("${app.payment.retry-count}")
    private int retryCount;
}
```

但当配置较多时，更推荐类型安全的`@ConfigurationProperties`。

```java
@ConfigurationProperties(prefix = "app.payment")
public record PaymentProperties(
        Duration timeout,
        int retryCount) {}
```

注册方式：

```java
@Configuration
@EnableConfigurationProperties(PaymentProperties.class)
public class PaymentConfig {
}
```

优点：

- 类型安全；
- 支持IDE提示；
- 易于校验；
- 配置层次清晰；
- 比大量`@Value`更容易维护。

---

## 第十六站：环境隔离与Profile

配置文件：

```text
application.yml
application-dev.yml
application-test.yml
application-prod.yml
```

激活环境：

```yaml
spring:
  profiles:
    active: dev
```

或通过命令行：

```bash
java -jar app.jar --spring.profiles.active=prod
```

也可以让Bean只在特定环境生效：

```java
@Configuration
@Profile("dev")
public class DevConfig {
}
```

「云单」曾经差点把一个测试密钥提交到Git仓库，从那以后团队立了规矩——生产环境不应把密码、密钥直接提交到Git仓库。更合适的方案包括：

- 环境变量；
- 容器Secret；
- 云密钥管理服务；
- Vault类产品；
- 外部化配置中心。

---

## 第十七站：条件化配置

```java
@Configuration
@ConditionalOnProperty(
        prefix = "feature",
        name = "sms",
        havingValue = "true")
public class SmsConfig {
}
```

条件化配置是Spring Boot自动配置的基础。

常见条件包括：

- 类路径中是否存在某个类；
- 容器中是否存在某个Bean；
- 配置项是否开启；
- 当前是否为Web应用；
- 当前运行环境是否匹配。

Spring Boot的"自动"并不等于猜测，它实际上是在执行一系列条件判断。

---

# 第四部分：AOP面向切面编程

## 第十八站：什么是横切关注点

「云单」的每个核心方法都曾长出过一样的代码：记日志、查权限、开事务、加缓存。郑航把这类东西叫横切关注点：

- 日志；
- 权限校验；
- 事务；
- 缓存；
- 性能统计；
- 重试；
- 幂等；
- 审计。

如果在每个业务方法中手写这些代码，业务逻辑会被大量基础设施代码包围。

AOP的目标是：

> 把横跨多个业务模块的通用逻辑提取成独立切面，再统一应用到目标方法。

---

## 第十九站：AOP核心术语

| 术语 | 含义 |
| --- | --- |
| Aspect（切面） | 横切逻辑的模块化封装 |
| Join Point（连接点） | 程序执行中可以插入切面的点 |
| Pointcut（切点） | 匹配连接点的表达式 |
| Advice（通知） | 切面在连接点上执行的动作 |
| Weaving（织入） | 把切面应用到目标对象的过程 |

在Spring AOP中，最常见的连接点是方法执行。

---

## 第二十站：编写一个日志切面

依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>
```

小柯给「云单」的服务层加的耗时切面：

```java
@Aspect
@Component
public class LogAspect {

    @Around("execution(* com.example.demo.service..*(..))")
    public Object log(ProceedingJoinPoint joinPoint) throws Throwable {
        long start = System.nanoTime();
        try {
            return joinPoint.proceed();
        } finally {
            long cost = System.nanoTime() - start;
            System.out.printf(
                    "%s cost %d ns%n",
                    joinPoint.getSignature(),
                    cost);
        }
    }
}
```

`@Around`通知可以在目标方法前后执行逻辑，并决定是否继续调用目标方法。

常见通知：

```java
@Before
@After
@AfterReturning
@AfterThrowing
@Around
```

---

## 第二十一站：Spring AOP为什么会失效

Spring AOP通常基于代理对象工作。

调用关系：

```text
调用方
  ↓
代理对象
  ↓
增强逻辑
  ↓
目标对象
```

一个非常典型的问题是同类内部调用：

```java
@Service
public class UserService {

    public void register() {
        sendMessage();
    }

    @Transactional
    public void sendMessage() {
        // ...
    }
}
```

`register()`中的`sendMessage()`是通过`this`直接调用的，没有经过代理对象，因此事务或其他AOP增强可能不会生效。

小柯在本地怎么都复现不出"事务没生效"，直到郑航让他画出了上面这张代理调用图。

常见解决方式：

1. 将方法拆到另一个Bean；
2. 重新设计业务边界；
3. 通过代理对象调用，但这通常会增加复杂性；
4. 特殊场景使用AspectJ织入，而不是Spring代理AOP。

最推荐的方式仍然是拆分职责。

---

## 第二十二站：JDK动态代理与CGLIB

Spring常见代理方式：

### JDK动态代理

基于接口创建代理。

```text
接口
├── 目标实现
└── 代理实现
```

### 类代理

通过生成目标类的子类完成代理，现代Spring通常使用CGLIB机制。

需要注意：

- `final`类不能被继承；
- `final`方法不能被覆盖；
- 私有方法通常不能作为代理增强入口；
- 自调用不会经过代理。

理解代理边界，是理解事务、缓存、异步和安全注解的关键。

---

# 第五部分：Spring事务

## 第二十三站：为什么需要事务

以「云单」的转账结算为例：

```text
账户A扣款
账户B加款
```

这两个操作必须作为一个整体：

- 全部成功；
- 或全部失败。

否则就会出现资金不一致——这是订单中台绝对不能出的事故。

Spring提供统一的事务抽象，让开发者可以用相似的编程方式管理不同的数据访问技术。

---

## 第二十四站：声明式事务

```java
@Service
public class TransferService {

    private final AccountRepository accountRepository;

    public TransferService(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }

    @Transactional
    public void transfer(
            long fromId,
            long toId,
            BigDecimal amount) {
        accountRepository.decrease(fromId, amount);
        accountRepository.increase(toId, amount);
    }
}
```

`@Transactional`背后通常也是AOP代理：

```text
进入代理
  ↓
开启事务
  ↓
调用业务方法
  ↓
提交或回滚
```

---

## 第二十五站：事务传播行为

传播行为决定：

> 一个带事务的方法调用另一个带事务的方法时，应该如何处理事务边界。

常用类型：

| 传播行为 | 含义 |
| --- | --- |
| REQUIRED | 有事务就加入，没有就新建（默认） |
| REQUIRES_NEW | 总是新建事务，挂起当前事务 |
| NESTED | 在当前事务内创建保存点 |
| SUPPORTS | 有事务就加入，没有就非事务执行 |
| NOT_SUPPORTED | 非事务执行，存在事务则挂起 |
| MANDATORY | 必须存在事务，否则抛异常 |
| NEVER | 必须没有事务，否则抛异常 |

大多数业务使用默认的`REQUIRED`即可。

`REQUIRES_NEW`适合需要独立提交的场景，但必须谨慎使用，因为它会创建新的事务边界，也可能增加连接占用。

---

## 第二十六站：事务隔离级别

隔离级别用于控制并发事务之间的可见性。

| 隔离级别 | 含义 |
| --- | --- |
| DEFAULT | 使用数据库默认隔离级别 |
| READ_UNCOMMITTED | 可以读到未提交数据 |
| READ_COMMITTED | 只能读到已提交数据 |
| REPEATABLE_READ | 同一事务内多次读取结果一致 |
| SERIALIZABLE | 完全串行化，最强隔离 |

事务隔离并不是越高越好。

隔离越强，通常意味着：

- 锁竞争更明显；
- 并发度降低；
- 延迟增大；
- 死锁风险可能变化。

应根据业务一致性需求和数据库机制选择。

---

## 第二十七站：事务回滚规则

默认情况下，Spring通常对运行时异常和Error触发回滚。

```java
@Transactional(rollbackFor = Exception.class)
public void importData() throws Exception {}
```

不要为了"确保回滚"而在所有地方机械地写`rollbackFor = Exception.class`。更重要的是建立明确的异常体系：

```text
BusinessException：业务可预期异常
SystemException：系统异常
ExternalServiceException：外部依赖异常
```

还要警惕吞异常：

```java
@Transactional
public void execute() {
    try {
        repository.save();
    } catch (Exception e) {
        log.error("失败", e);
    }
}
```

异常被捕获后没有继续抛出，事务拦截器会认为方法正常结束，从而可能提交事务。

---

## 第二十八站：事务常见失效场景

小柯把这一站整理成了「云单」团队的排查清单：

1. 方法不是通过代理对象调用；
2. 同类内部自调用；
3. 方法不可被代理；
4. 异常被吞掉；
5. 回滚异常类型与规则不匹配；
6. 使用了错误的事务管理器；
7. 数据库引擎本身不支持事务；
8. 异步线程脱离原事务；
9. 方法实际上没有执行数据库写操作；
10. 事务边界设置在错误的层次。

事务通常应放在Service层，因为Service层最接近一个完整业务用例。

---

# 第六部分：Spring MVC

## 第二十九站：一次HTTP请求是如何处理的

Spring MVC的核心入口是`DispatcherServlet`。

请求流程可以简化为：

```text
客户端请求
  ↓
DispatcherServlet
  ↓
HandlerMapping寻找Controller方法
  ↓
HandlerAdapter调用方法
  ↓
参数解析与数据绑定
  ↓
执行Controller
  ↓
返回对象或视图
  ↓
HttpMessageConverter序列化
  ↓
写入HTTP响应
```

这套流程背后对应大量可扩展组件：

- HandlerMapping；
- HandlerAdapter；
- ArgumentResolver；
- ReturnValueHandler；
- HttpMessageConverter；
- Validator；
- ExceptionResolver；
- Interceptor。

理解这些扩展点之后，许多"Spring MVC魔法"都会变得可解释。

---

## 第三十站：编写规范的Controller

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserApplicationService userService;

    public UserController(UserApplicationService userService) {
        this.userService = userService;
    }

    @PostMapping
    public UserResponse create(
            @Valid @RequestBody CreateUserRequest request) {
        return userService.create(request);
    }

    @GetMapping("/{id}")
    public UserResponse findById(@PathVariable long id) {
        return userService.findById(id);
    }
}
```

Controller应该负责：

- 接收HTTP请求；
- 参数校验；
- 调用应用服务；
- 返回HTTP响应。

Controller不应该承担：

- 大量业务规则；
- 复杂事务；
- 数据库拼接；
- 第三方接口细节；
- 领域对象的全部转换逻辑。

保持Controller薄，可以让Web协议与业务逻辑解耦。

---

## 第三十一站：常用参数绑定注解

```java
@GetMapping("/search")
public List<UserResponse> search(
        @RequestParam String keyword,
        @RequestParam(defaultValue = "0") int page) {
    // ...
}
```

```java
@GetMapping("/{id}")
public UserResponse find(@PathVariable long id) {
    // ...
}
```

```java
@PostMapping
public UserResponse create(
        @RequestBody CreateUserRequest request) {
    // ...
}
```

```java
@GetMapping("/header")
public String header(
        @RequestHeader("X-Request-Id") String requestId) {
    return requestId;
}
```

---

## 第三十二站：参数校验

请求对象：

```java
public record CreateUserRequest(
        @NotBlank(message = "用户名不能为空")
        @Size(max = 50, message = "用户名不能超过50个字符")
        String username,

        @NotBlank(message = "邮箱不能为空")
        @Email(message = "邮箱格式错误")
        String email) {}
```

Controller：

```java
@PostMapping
public UserResponse create(
        @Valid @RequestBody CreateUserRequest request) {
    return userService.create(request);
}
```

校验并不等于全部业务规则。

例如：

- 字符串不能为空：输入校验；
- 邮箱是否已经注册：业务规则；
- 当前用户是否允许创建管理员账号：权限与业务规则。

不要把所有业务判断都塞进Bean Validation注解。

---

## 第三十三站：统一异常处理

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(UserNotFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ErrorResponse handleUserNotFound(
            UserNotFoundException ex) {
        return new ErrorResponse(
                "USER_NOT_FOUND",
                ex.getMessage());
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    public ErrorResponse handleValidation(
            MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult()
                .getFieldErrors()
                .stream()
                .findFirst()
                .map(DefaultMessageSourceResolvable::getDefaultMessage)
                .orElse("参数错误");
        return new ErrorResponse(
                "VALIDATION_ERROR",
                message);
    }
}
```

统一错误结构：

```java
public record ErrorResponse(
        String code,
        String message) {}
```

生产项目还可以增加：

- 时间戳；
- 请求路径；
- traceId；
- 字段错误列表；
- 可重试标记；
- 文档链接。

不要直接把堆栈、SQL、服务器路径或内部类名返回给客户端。

---

## 第三十四站：拦截器与过滤器

### Filter

Servlet规范的一部分，位置更靠近容器入口。

适合：

- 请求编码；
- CORS基础处理；
- 请求包装；
- 链路ID；
- 通用安全过滤。

### HandlerInterceptor

Spring MVC机制，能够感知Controller映射信息。

适合：

- 接口级审计；
- 基于Handler的权限判断；
- 请求耗时统计；
- Controller调用前后处理。

简化流程：

```text
HTTP请求
  ↓
Filter
  ↓
DispatcherServlet
  ↓
Interceptor
  ↓
Controller
```

---

# 第七部分：数据访问

## 第三十五站：不要在Controller直接操作数据库

不推荐：

```java
@RestController
public class UserController {

    private final UserRepository repository;

    @PostMapping("/users")
    public void create(@RequestBody User user) {
        repository.save(user);
    }
}
```

这会导致：

- HTTP层与持久化层直接耦合；
- 事务边界不清晰；
- 业务规则分散；
- 难以复用；
- 测试困难。

更合理的调用关系：

```text
Controller
  ↓
Application Service
  ↓
Domain / Repository
  ↓
Database
```

---

## 第三十六站：JdbcTemplate的价值

传统JDBC需要处理：

- 获取连接；
- 创建Statement；
- 参数绑定；
- 遍历ResultSet；
- 异常转换；
- 资源关闭。

Spring JDBC通过模板方法减少样板代码：

```java
@Repository
public class JdbcUserRepository {

    private final JdbcTemplate jdbcTemplate;

    public JdbcUserRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    public Optional<User> findById(long id) {
        List<User> users = jdbcTemplate.query(
                """
                select id, username, email
                from users
                where id = ?
                """,
                (rs, rowNum) -> new User(
                        rs.getLong("id"),
                        rs.getString("username"),
                        rs.getString("email")),
                id);
        return users.stream().findFirst();
    }
}
```

Spring的模板类体现了一个重要设计思想：

> 框架控制固定流程，开发者提供变化部分。

---

## 第三十七站：Spring Data JPA

实体：

```java
@Entity
@Table(name = "users")
public class UserEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String username;
    private String email;

    protected UserEntity() {
    }

    // getter、业务方法等
}
```

Repository：

```java
public interface UserRepository
        extends JpaRepository<UserEntity, Long> {

    Optional<UserEntity> findByEmail(String email);
}
```

Spring Data根据接口和方法命名生成实现，大幅减少简单CRUD代码。

但要避免误区：

- JPA不是"不用懂SQL"；
- `save()`不是性能万能解；
- 懒加载可能导致N+1；
- 实体关系过度建模会放大复杂性；
- 大批量写入需要专门优化；
- 复杂查询仍需理解执行计划和索引。

框架可以隐藏样板代码，但不能替代数据库知识——这是郑航在「云单」性能复盘会上说过最多的一句话。

---

# 第八部分：Spring Boot自动配置

## 第三十八站：Spring Boot到底自动了什么

加入Web Starter后，Spring Boot会根据：

- 类路径中的依赖；
- 当前配置；
- 已存在的Bean；
- 应用类型；
- 条件注解；

决定是否注册：

- Web服务器；
- `DispatcherServlet`；
- JSON转换器；
- MVC配置；
- 异常处理基础设施；
- 静态资源处理器。

自动配置的基本逻辑是：

```text
如果存在某个类
并且用户没有自己定义对应Bean
并且某个配置条件满足
那么注册默认Bean
```

因此，Spring Boot遵循"约定优于配置"，但仍然允许用户覆盖默认行为。

---

## 第三十九站：Starter是什么

Starter是一组经过协调的依赖集合。

例如：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

它会引入构建Web应用所需的一组常用组件。

Starter主要解决：

- 依赖选择；
- 版本协调；
- 常见组合；
- 降低配置成本。

Starter本身不等于自动配置，但两者通常配合工作。

---

## 第四十站：编写自己的自动配置

「云单」要对接公司自研的短信平台，郑航让小柯把它封装成内部Starter——这一站是小柯第一次写出"框架级"的代码。

属性：

```java
@ConfigurationProperties(prefix = "sms")
public record SmsProperties(
        String endpoint,
        String apiKey) {}
```

客户端：

```java
public class SmsClient {

    private final String endpoint;
    private final String apiKey;

    public SmsClient(String endpoint, String apiKey) {
        this.endpoint = endpoint;
        this.apiKey = apiKey;
    }
}
```

自动配置：

```java
@AutoConfiguration
@EnableConfigurationProperties(SmsProperties.class)
@ConditionalOnClass(SmsClient.class)
@ConditionalOnMissingBean(SmsClient.class)
public class SmsAutoConfiguration {

    @Bean
    public SmsClient smsClient(SmsProperties properties) {
        return new SmsClient(
                properties.endpoint(),
                properties.apiKey());
    }
}
```

这里最关键的是：

```java
@ConditionalOnMissingBean
```

它表示：只有用户没有自己提供`SmsClient`时，才注册默认实现。

这体现了优秀框架的原则：

> 提供方便的默认值，同时保留明确的覆盖能力。

---

# 第九部分：测试

## 第四十一站：测试金字塔

一个健康的Spring项目通常包含：

```text
少量端到端测试
  ↑
适量集成测试
  ↑
大量单元测试
```

不要把所有测试都写成`@SpringBootTest`。

完整启动Spring容器会：

- 增加执行时间；
- 增加测试耦合；
- 隐藏对象设计问题；
- 让失败原因更难定位。

---

## 第四十二站：纯单元测试

```java
class UserServiceTest {

    @Test
    void shouldCreateUser() {
        UserRepository repository =
                mock(UserRepository.class);

        UserService service =
                new UserService(repository);

        service.create("alice@example.com");

        verify(repository)
                .save(any(User.class));
    }
}
```

纯单元测试不需要启动Spring。

只要使用构造器注入，业务类通常可以像普通Java对象一样测试——这也是「云单」坚持构造器注入的原因之一。

---

## 第四十三站：Controller切片测试

```java
@WebMvcTest(UserController.class)
class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private UserApplicationService userService;

    @Test
    void shouldReturnUser() throws Exception {
        when(userService.findById(1L))
                .thenReturn(new UserResponse(
                        1L,
                        "Alice",
                        "alice@example.com"));

        mockMvc.perform(get("/api/users/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.username")
                        .value("Alice"));
    }
}
```

`@WebMvcTest`主要加载MVC相关组件，适合验证：

- 路由；
- 参数绑定；
- 校验；
- JSON序列化；
- 异常处理；
- HTTP状态码。

---

## 第四十四站：数据层测试

```java
@DataJpaTest
class UserRepositoryTest {

    @Autowired
    private UserRepository userRepository;

    @Test
    void shouldFindByEmail() {
        // 准备测试数据
        // 执行查询
        // 验证结果
    }
}
```

真实项目中可以结合Testcontainers启动真实数据库容器，避免H2与生产数据库行为差异。「云单」的CI流水线就是这么做的。

---

## 第四十五站：完整集成测试

```java
@SpringBootTest(
        webEnvironment =
                SpringBootTest.WebEnvironment.RANDOM_PORT)
class UserApiIntegrationTest {

    @Autowired
    private TestRestTemplate restTemplate;

    @Test
    void shouldCreateUser() {
        // 从HTTP入口验证完整链路
    }
}
```

完整集成测试适合验证：

- 自动配置；
- 数据库；
- 事务；
- 序列化；
- Bean装配；
- 安全配置；
- 外部接口适配器；
- 应用启动行为。

---

# 第十部分：工程化能力

## 第四十六站：分层架构怎么设计

常见分层：

```text
Controller
Application Service
Domain Service / Domain Model
Repository
Infrastructure
```

也可以使用更轻量的三层结构：

```text
Controller
Service
Repository
```

关键不在于层数，而在于职责边界。

### Controller层

负责协议适配：

- HTTP请求；
- 参数解析；
- 响应格式；
- 状态码。

### Service层

负责编排业务用例：

- 事务边界；
- 业务流程；
- 调用多个领域能力；
- 调用Repository和外部服务。

### Repository层

负责持久化抽象：

- 保存；
- 查询；
- 删除；
- 数据映射。

### Infrastructure层

负责技术实现：

- 数据库；
- 消息队列；
- 文件系统；
- 第三方API；
- 缓存。

---

## 第四十七站：DTO、实体和领域对象不要混用

一个数据库实体直接贯穿所有层，会导致：

- HTTP字段与数据库字段耦合；
- 敏感字段可能泄漏；
- API升级困难；
- 懒加载对象被意外序列化；
- 业务规则无处安放。

更合理的对象类型：

```text
Request DTO：接收请求
Response DTO：返回响应
Entity：映射数据库
Domain Object：表达业务
Command / Query：表达应用用例
```

小项目可以适当简化，但应知道自己省略了哪些边界。

---

## 第四十八站：领域事件解耦

发布事件：

```java
public record UserRegisteredEvent(
        long userId,
        String email) {}
```

```java
@Service
public class UserService {

    private final ApplicationEventPublisher publisher;

    public UserService(ApplicationEventPublisher publisher) {
        this.publisher = publisher;
    }

    public void register() {
        // 保存用户
        publisher.publishEvent(
                new UserRegisteredEvent(
                        1L,
                        "alice@example.com"));
    }
}
```

监听事件：

```java
@Component
public class WelcomeEmailListener {

    @EventListener
    public void handle(UserRegisteredEvent event) {
        // 发送欢迎邮件
    }
}
```

如果事件逻辑必须在事务提交后执行，可以考虑：

```java
@TransactionalEventListener(
        phase = TransactionPhase.AFTER_COMMIT)
```

但要注意：应用内事件不自动等于可靠消息。跨服务可靠投递通常需要消息队列、Outbox等机制。

---

## 第四十九站：缓存

```java
@Cacheable(cacheNames = "users", key = "#id")
public UserResponse findById(long id) {
    return loadFromDatabase(id);
}
```

```java
@CacheEvict(cacheNames = "users", key = "#id")
public void update(long id, UpdateUserCommand command) {}
```

```java
@CachePut(cacheNames = "users", key = "#result.id")
public UserResponse save(CreateUserCommand command) {}
```

缓存最难的不是加注解，而是回答：

- 缓存什么；
- 缓存多久；
- 如何失效；
- 如何防止脏数据；
- 如何应对穿透、击穿和雪崩；
- 是否允许短暂不一致；
- 多实例如何同步失效；
- Key如何设计。

缓存是数据一致性设计，不只是性能开关。

---

## 第五十站：异步执行

```java
@EnableAsync
@Configuration
public class AsyncConfig {}
```

```java
@Async
public CompletableFuture<Void> sendEmail() {
    return CompletableFuture.completedFuture(null);
}
```

使用异步时必须关注：

- 线程池大小；
- 队列容量；
- 拒绝策略；
- 上下文传播；
- 异常处理；
- 优雅停机；
- 事务边界；
- 任务幂等；
- 是否需要可靠消息。

`@Async`适合进程内异步任务，但不适合承担所有可靠任务需求。

---

## 第五十一站：定时任务

```java
@EnableScheduling
@Configuration
public class SchedulingConfig {}
```

```java
@Scheduled(cron = "0 0 2 * * *")
public void cleanup() {}
```

单实例项目中很简单，但部署为多个实例后，每台机器可能都会执行同一任务。

「云单」的对账任务就曾在预发环境双实例下跑重过一次，之后团队补上了分布式锁。

常见解决方案：

- 分布式锁；
- 调度平台；
- 数据库任务抢占；
- 消息队列；
- Kubernetes CronJob；
- 专门的批处理系统。

---

# 第十一部分：可观测性与生产部署

## 第五十二站：日志

推荐结构化日志包含：

- 时间；
- 日志级别；
- 服务名；
- traceId；
- spanId；
- 请求ID；
- 用户或租户标识；
- 关键业务字段；
- 异常堆栈。

不要记录：

- 密码；
- 访问令牌；
- 私钥；
- 完整银行卡号；
- 未脱敏身份证号；
- 敏感请求体。

日志是生产系统的重要接口，而不是随手输出字符串。

---

## 第五十三站：Actuator

加入依赖：

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

常见端点：

```text
/actuator/health
/actuator/info
/actuator/metrics
/actuator/prometheus
```

配置暴露端点：

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
```

生产环境必须保护管理端点，不能无条件暴露全部信息。

---

## 第五十四站：健康检查不是"进程活着"

常见检查维度：

### Liveness

应用进程是否还能继续运行。

### Readiness

应用是否准备好接收流量。

一个数据库暂时不可用时：

- 是否应该重启应用；
- 还是暂时从流量中摘除；

需要根据系统设计区分。

错误地把所有外部依赖都放进存活检查，可能造成大规模反复重启。

---

## 第五十五站：优雅停机

应用关闭时需要：

- 停止接收新请求；
- 等待正在处理的请求；
- 停止拉取新消息；
- 完成或中断后台任务；
- 提交必要状态；
- 关闭线程池；
- 释放连接和文件句柄。

在容器化环境中，还要协调：

- Kubernetes终止信号；
- readiness状态；
- 终止宽限期；
- 负载均衡摘流；
- 消费者再平衡。

---

# 第十二部分：性能调优

## 第五十六站：先测量，再优化

Spring应用慢，不代表一定是Spring慢。

常见瓶颈：

- 慢SQL；
- 缺少索引；
- N+1查询；
- 连接池耗尽；
- 外部接口延迟；
- 线程池配置不合理；
- 频繁Full GC；
- 对象序列化过重；
- 日志量过大；
- 锁竞争；
- 缓存失效；
- 网络抖动。

优化顺序：

```text
建立指标
  ↓
定位慢点
  ↓
构造可复现测试
  ↓
只改一个变量
  ↓
对比优化前后
  ↓
验证副作用
```

---

## 第五十七站：启动速度优化

可能的优化方向：

- 减少不必要的Starter；
- 缩小组件扫描范围；
- 避免启动时执行重型任务；
- 减少大量反射和动态扫描；
- 优化数据库迁移脚本；
- 延迟非核心客户端初始化；
- 使用AOT处理；
- 在适合的场景评估GraalVM Native Image。

但不要为了少几百毫秒启动时间，破坏代码可维护性。

---

## 第五十八站：请求性能优化

重点观察：

- P50、P95、P99延迟；
- 请求吞吐量；
- 错误率；
- 活跃线程；
- 队列长度；
- 数据库连接池；
- 外部调用耗时；
- GC暂停；
- CPU与内存；
- 缓存命中率。

平均值可能掩盖尾延迟问题，因此高分位延迟往往更重要。

---

## 第五十九站：线程池配置

线程池不是越大越好。

过大的线程池可能导致：

- 上下文切换增加；
- 内存占用增加；
- 下游服务被压垮；
- 延迟抖动；
- 请求大量堆积。

配置时应考虑：

```text
任务类型：CPU密集还是I/O密集
到达速率
平均处理时间
允许排队时间
下游容量
机器CPU数量
内存限制
拒绝策略
```

要为不同任务建立隔离线程池，避免邮件发送、报表导出等任务拖垮核心请求。

---

# 第十三部分：源码原理

## 第六十站：ApplicationContext启动的大致流程

Spring容器启动时，核心工作可以概括为：

1. 创建或准备BeanFactory；
2. 读取配置并注册BeanDefinition；
3. 执行BeanFactoryPostProcessor；
4. 注册BeanPostProcessor；
5. 初始化消息、事件等基础设施；
6. 创建非延迟单例Bean；
7. 完成容器刷新；
8. 发布容器已启动事件。

经典入口之一是`AbstractApplicationContext#refresh()`。

学习源码时，不要一开始逐行追踪所有分支，而应先抓住模板方法骨架。

---

## 第六十一站：BeanFactory与ApplicationContext

### BeanFactory

最基础的IoC容器接口，提供：

- 获取Bean；
- 判断Bean是否存在；
- 查询类型；
- 获取作用域等。

### ApplicationContext

在BeanFactory之上增加：

- 国际化；
- 事件发布；
- 资源加载；
- 环境与Profile；
- 自动注册后处理器；
- 企业应用常用能力。

日常Spring应用几乎总是使用`ApplicationContext`。

---

## 第六十二站：BeanFactoryPostProcessor

它操作的是Bean定义，而不是普通Bean实例。

可以在Bean实例化之前：

- 修改BeanDefinition；
- 注册额外定义；
- 调整属性；
- 处理配置元数据。

`ConfigurationClassPostProcessor`就是非常重要的实现之一，它负责处理：

- `@Configuration`；
- `@Bean`；
- `@Import`；
- `@ComponentScan`等。

---

## 第六十三站：BeanPostProcessor

它操作的是Bean实例。

核心方法：

```java
Object postProcessBeforeInitialization(
        Object bean,
        String beanName);

Object postProcessAfterInitialization(
        Object bean,
        String beanName);
```

AOP自动代理创建器会判断Bean是否需要增强，并可能在后置处理阶段返回代理对象。

这解释了一个关键现象：

> 从容器中获取到的对象，不一定是原始对象，也可能是代理对象。

---

## 第六十四站：三级缓存与循环依赖

在传统单例Bean创建机制中，Spring内部会区分：

- 已完成初始化的单例；
- 提前暴露的单例；
- 单例工厂。

这些结构能够处理部分Setter或字段注入形成的循环依赖，并为代理对象提前暴露提供机会。

但要强调：

- 构造器循环依赖通常无法解决；
- 原型Bean循环依赖不属于常规解决范围；
- 能被容器"处理"不等于设计合理；
- 新项目应优先消除循环依赖。

学习三级缓存的目的，不是鼓励写循环依赖，而是理解Bean创建和代理暴露过程。

---

## 第六十五站：Spring MVC源码入口

建议按以下顺序阅读：

1. `DispatcherServlet#doDispatch`
2. `HandlerMapping`
3. `HandlerAdapter`
4. `RequestMappingHandlerMapping`
5. `RequestMappingHandlerAdapter`
6. 参数解析器
7. 返回值处理器
8. `HttpMessageConverter`
9. 异常解析器

阅读时画出主流程：

```text
找到Handler
  ↓
执行拦截器preHandle
  ↓
调用Controller方法
  ↓
处理返回值
  ↓
异常解析
  ↓
执行拦截器afterCompletion
```

---

# 第十四部分：常见误区

## 第六十六站：把Spring等同于注解集合

错误学习方式：

```text
背@Component
背@Autowired
背@Transactional
背@RestController
```

正确学习方式：

```text
注解由谁扫描
元数据存在哪里
何时注册BeanDefinition
何时创建对象
谁执行注入
何时创建代理
调用是否经过代理
```

注解只是入口，容器与扩展机制才是本质。

---

## 第六十七站：所有类都注册成Bean

不是每个对象都需要交给Spring。

适合注册为Bean的通常是：

- 服务；
- 仓储；
- 控制器；
- 配置；
- 基础设施客户端；
- 无状态策略；
- 生命周期需要管理的组件。

不一定要注册的对象：

- DTO；
- 普通值对象；
- 短生命周期领域对象；
- 方法内部临时对象；
- 纯数据结构。

容器不是全局对象垃圾桶。

---

## 第六十八站：过度使用AOP

AOP适合稳定、统一的横切逻辑。

不适合：

- 隐藏复杂业务流程；
- 让方法产生难以发现的副作用；
- 用切面代替清晰的领域模型；
- 通过复杂切点表达核心业务规则。

当调试者无法从代码表面判断方法会做什么时，AOP可能已经使用过度。

---

## 第六十九站：Service层只有转发代码

例如：

```java
public User findById(long id) {
    return repository.findById(id);
}
```

如果系统很简单，这并非一定错误。但随着业务增长，Service层应承载：

- 用例编排；
- 事务边界；
- 权限与业务校验；
- 领域对象协作；
- 外部依赖协调；
- 事件发布。

不要为了"分层"制造无意义层次，也不要让Controller承担全部业务。

---

## 第七十站：异常全部捕获成`Exception`

不推荐：

```java
try {
    // ...
} catch (Exception e) {
    return "系统异常";
}
```

这会：

- 丢失异常语义；
- 影响事务回滚；
- 隐藏编程错误；
- 降低可观测性；
- 让调用方无法判断是否重试。

异常处理要分层：

```text
底层：保留原因并转换技术异常
业务层：表达业务失败
接口层：转换为稳定的错误响应
日志层：记录足够上下文
```

---

# 第十五部分：一个完整的小项目

「云单」第一个迭代的收尾任务：用户注册模块。麻雀虽小，五脏俱全——评审会上郑航的三个问题，答案全部藏在这条链路里。

## 第七十一站：需求

实现用户注册接口：

1. 接收用户名和邮箱；
2. 校验参数；
3. 检查邮箱是否重复；
4. 保存用户；
5. 发布注册事件；
6. 事务提交后发送欢迎消息；
7. 返回用户信息。

---

## 第七十二站：请求与响应对象

```java
public record RegisterUserRequest(
        @NotBlank
        @Size(max = 50)
        String username,

        @NotBlank
        @Email
        String email) {}
```

```java
public record UserResponse(
        Long id,
        String username,
        String email) {}
```

---

## 第七十三站：实体

```java
@Entity
@Table(
        name = "users",
        uniqueConstraints = {
                @UniqueConstraint(
                        name = "uk_users_email",
                        columnNames = "email")
        })
public class UserEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, length = 50)
    private String username;

    @Column(nullable = false, length = 200)
    private String email;

    protected UserEntity() {
    }

    public UserEntity(String username, String email) {
        this.username = username;
        this.email = email;
    }

    public Long getId() {
        return id;
    }

    public String getUsername() {
        return username;
    }

    public String getEmail() {
        return email;
    }
}
```

---

## 第七十四站：Repository

```java
public interface UserRepository
        extends JpaRepository<UserEntity, Long> {

    boolean existsByEmail(String email);
}
```

---

## 第七十五站：业务异常

```java
public class EmailAlreadyExistsException
        extends RuntimeException {

    public EmailAlreadyExistsException(String email) {
        super("邮箱已注册：" + email);
    }
}
```

---

## 第七十六站：应用服务

```java
@Service
public class UserApplicationService {

    private final UserRepository userRepository;
    private final ApplicationEventPublisher publisher;

    public UserApplicationService(
            UserRepository userRepository,
            ApplicationEventPublisher publisher) {
        this.userRepository = userRepository;
        this.publisher = publisher;
    }

    @Transactional
    public UserResponse register(
            RegisterUserRequest request) {
        if (userRepository.existsByEmail(request.email())) {
            throw new EmailAlreadyExistsException(
                    request.email());
        }

        UserEntity user = new UserEntity(
                request.username(),
                request.email());

        UserEntity saved = userRepository.save(user);

        publisher.publishEvent(
                new UserRegisteredEvent(
                        saved.getId(),
                        saved.getEmail()));

        return new UserResponse(
                saved.getId(),
                saved.getUsername(),
                saved.getEmail());
    }
}
```

即使代码中已经检查邮箱是否存在，数据库仍然应该建立唯一约束。

原因是并发请求可能同时通过应用层检查，只有数据库约束才能提供最终防线。

---

## 第七十七站：事务后事件监听

```java
@Component
public class WelcomeMessageListener {

    private final MessageSender messageSender;

    public WelcomeMessageListener(
            MessageSender messageSender) {
        this.messageSender = messageSender;
    }

    @TransactionalEventListener(
            phase = TransactionPhase.AFTER_COMMIT)
    public void handle(UserRegisteredEvent event) {
        messageSender.sendWelcome(event.email());
    }
}
```

在高可靠场景中，不应只依赖进程内事件发送关键消息。

更稳妥的设计是：

```text
业务事务中写入用户
业务事务中写入Outbox事件
  ↓
独立发布器读取Outbox
  ↓
发送到消息队列
  ↓
消费者幂等处理
```

---

## 第七十八站：Controller

```java
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserApplicationService userService;

    public UserController(
            UserApplicationService userService) {
        this.userService = userService;
    }

    @PostMapping
    @ResponseStatus(HttpStatus.CREATED)
    public UserResponse register(
            @Valid @RequestBody RegisterUserRequest request) {
        return userService.register(request);
    }
}
```

---

## 第七十九站：异常处理

```java
@RestControllerAdvice
public class ApiExceptionHandler {

    @ExceptionHandler(EmailAlreadyExistsException.class)
    @ResponseStatus(HttpStatus.CONFLICT)
    public ErrorResponse handleEmailExists(
            EmailAlreadyExistsException ex) {
        return new ErrorResponse(
                "EMAIL_ALREADY_EXISTS",
                ex.getMessage());
    }
}
```

到这里，一个小型但结构完整的Spring业务链路就建立起来了。

---

# 第十六部分：学习路线

## 第八十站：入门阶段

目标：能写出规范的CRUD应用。

学习内容：

1. Spring Boot项目结构；
2. Controller、Service、Repository分层；
3. IoC与依赖注入；
4. `@Component`、`@Service`、`@Bean`；
5. 配置文件；
6. Spring MVC；
7. 参数校验；
8. 统一异常处理；
9. 数据库访问；
10. 基本测试。

练习项目：

- 图书管理；
- 待办清单；
- 用户中心；
- 博客后台；
- 库存管理。

---

## 第八十一站：进阶阶段

目标：理解框架为何生效。

学习内容：

1. Bean生命周期；
2. Bean作用域；
3. AOP代理；
4. 声明式事务；
5. 事务传播；
6. MVC请求链路；
7. 自动配置；
8. 条件注解；
9. 缓存与异步；
10. 集成测试；
11. Actuator与指标。

练习项目：

- 订单系统；
- 支付回调系统；
- 优惠券系统；
- 消息通知中心；
- 文件处理平台。

---

## 第八十二站：高级阶段

目标：能够设计和治理生产系统。

学习内容：

1. Spring核心源码；
2. 自动配置源码；
3. Spring MVC源码；
4. 事务管理器；
5. Spring Security；
6. 高并发与线程模型；
7. 数据一致性；
8. 分布式事务取舍；
9. Outbox与可靠消息；
10. 可观测性；
11. 性能分析；
12. AOT与Native Image；
13. 模块化与架构边界。

练习项目：

- 多租户SaaS；
- 电商订单中心；
- 高并发秒杀系统；
- 事件驱动平台；
- 微服务治理平台。

---

# 第十七部分：面试高频问题

## 第八十三站：IoC与DI是什么关系

IoC是控制权反转的思想，DI是实现IoC的主要方式。对象不再主动创建依赖，而是由容器注入。

## 第八十四站：BeanFactory和ApplicationContext有什么区别

BeanFactory提供基础Bean管理；ApplicationContext在此基础上增加事件、国际化、资源加载、环境配置、后处理器自动注册等企业级能力。

## 第八十五站：为什么推荐构造器注入

依赖明确、支持`final`、便于测试、对象创建后状态完整，还能更早暴露循环依赖。

## 第八十六站：`@Transactional`为什么可能失效

常见原因是调用没有经过代理、自调用、异常被吞、方法不可代理、回滚规则不匹配或事务管理器配置错误。

## 第八十七站：Spring AOP使用什么代理

通常根据目标类型和配置使用JDK动态代理或类代理机制。代理只能拦截经过代理对象的方法调用。

## 第八十八站：Spring Bean默认是否线程安全

不是。默认单例只代表一个容器中通常只有一个实例，线程安全仍由代码设计保证。

## 第八十九站：Spring Boot自动配置原理是什么

自动配置类结合类路径、配置项、Bean存在情况和应用类型，通过条件注解决定是否注册默认Bean。

## 第九十站：`@Component`与`@Bean`如何选择

自己控制的应用类常用组件扫描；第三方对象、需要精细构造或模块化配置的对象常用`@Bean`。

## 第九十一站：Filter与Interceptor有什么区别

Filter属于Servlet层，位于Spring MVC入口之前；Interceptor属于Spring MVC，可以感知Handler和Controller调用。

## 第九十二站：Spring MVC的核心组件是什么

核心入口是`DispatcherServlet`，它协调HandlerMapping、HandlerAdapter、参数解析器、返回值处理器、消息转换器和异常解析器。

---

# 第十八部分：真正"精通"Spring的标准

精通Spring不是背出所有注解，也不是能够复制一套脚手架。

一个真正理解Spring的开发者，应该能够回答：

1. 这个Bean为什么会被注册？
2. 依赖为什么能被注入？
3. 当前拿到的是原始对象还是代理对象？
4. 这个调用是否经过代理？
5. 事务边界在哪里？
6. 异常为什么回滚或不回滚？
7. 一个HTTP请求经过哪些组件？
8. 自动配置为什么生效？
9. 为什么这个配置能覆盖默认值？
10. 应用启动慢在哪里？
11. 线上请求慢在哪里？
12. 这个组件是否线程安全？
13. 当前设计是否存在循环依赖？
14. 该使用同步调用、事件还是消息队列？
15. 测试需要启动多大的Spring上下文？

当你能从容器、代理、生命周期、请求链路、事务和工程边界的角度解释问题时，才算真正建立了Spring知识体系。

用户注册模块上线的那天，小柯在评审会上把当初那三个问题重新讲了一遍：Controller由容器创建、事务从代理进入Service方法时开启、换掉Repository只需替换一个Bean定义。郑航听完只说了一句："下个迭代，短信Starter的维护交给你了。"

Spring最重要的不是某个注解，而是一套长期有效的软件设计思想：

- 让对象专注于自己的职责；
- 让依赖关系清晰可替换；
- 让基础设施与业务逻辑分离；
- 让通用能力通过统一机制扩展；
- 让应用具备可测试、可配置、可观察和可演进的能力。

学习Spring时，可以始终抓住一条主线：

```text
Bean如何定义
  ↓ 容器如何创建
  ↓ 依赖如何注入
  ↓ 代理如何增强
  ↓ 请求如何流转
  ↓ 事务如何管理
  ↓ 系统如何测试与运行
```

沿着这条主线不断向下追问，你会发现，Spring并不神秘。

它只是把大型Java应用中重复出现的问题，整理成了一套成熟、统一、可扩展的解决方案。

---

# 附录：核心注解速查

## 容器与配置

| 注解 | 用途 |
| --- | --- |
| `@Component` / `@Service` / `@Repository` / `@Controller` | 组件扫描注册 |
| `@Bean` | 配置类中注册第三方对象 |
| `@Configuration` | 声明配置类 |
| `@Import` | 组合导入配置 |
| `@Autowired` / `@Qualifier` / `@Primary` | 依赖注入与选择 |
| `@Value` / `@ConfigurationProperties` | 配置读取 |
| `@Profile` / `@ConditionalOn*` | 条件化装配 |
| `@Scope` | Bean作用域 |

## Web

| 注解 | 用途 |
| --- | --- |
| `@RestController` / `@RequestMapping` | REST控制器与路由 |
| `@GetMapping` / `@PostMapping` 等 | 方法级路由 |
| `@RequestParam` / `@PathVariable` / `@RequestHeader` / `@RequestBody` | 参数绑定 |
| `@Valid` | 参数校验 |
| `@RestControllerAdvice` / `@ExceptionHandler` | 统一异常处理 |
| `@ResponseStatus` | 响应状态码 |

## 数据与事务

| 注解 | 用途 |
| --- | --- |
| `@Entity` / `@Id` / `@Table` / `@Column` | JPA实体映射 |
| `@Transactional` | 声明式事务 |
| `@Cacheable` / `@CacheEvict` / `@CachePut` | 缓存 |

## 工程能力

| 注解 | 用途 |
| --- | --- |
| `@PostConstruct` / `@PreDestroy` | 生命周期回调 |
| `@Async` / `@EnableAsync` | 异步执行 |
| `@Scheduled` / `@EnableScheduling` | 定时任务 |
| `@EventListener` / `@TransactionalEventListener` | 事件监听 |
| `@SpringBootApplication` | 启动类组合注解 |

---

## 参考资料

- [Spring Framework Reference Documentation](https://docs.spring.io/spring-framework/reference/)
- [Spring Framework Project](https://spring.io/projects/spring-framework)
- [Spring Boot Reference Documentation](https://docs.spring.io/spring-boot/)
- [Spring Boot Project](https://spring.io/projects/spring-boot)
- [Spring Guides](https://spring.io/guides)
- [Spring Initializr](https://start.spring.io/)

版本、依赖兼容范围会持续变化。正式升级前，应以对应版本的官方文档和发布说明为准。

> Spring 的难点，从来不是注解多，而是你能否讲清楚：对象由谁创建、依赖如何连接、功能怎样增强、请求如何流转、事务为何生效。

「云单」的故事才刚刚开始，小柯的 Spring 笔记也会随着每一次上线、每一次故障继续增补。而你的故事，从 `start.spring.io` 生成第一个项目开始。
