# [Netty从入门到精通：原理、核心组件、协议设计与生产实战](https://mp.weixin.qq.com/s/ecei443td-L_rd3WiB7s1w)

> 这是一个关于"鹊桥"的故事——栖云互娱游戏的长连接推送与对战接入网关，周末活动夜在线连接 50 万以上，推送延迟要求 P99 小于 100 毫秒。主角祁霖，24 岁，从 CRUD 后端转到长连接组，入职第一周就撞上旧版 Tomcat 加轮询方案在活动夜连接堆积雪崩的烂摊子。他的导师程焕之写了十年网络编程，同事白芷负责稳定性与监控，三个人正用 Netty 4.2 把鹊桥重写一遍。你会跟着祁霖，从写第一个 Echo 服务器开始，把事件驱动、线程模型、Pipeline、ByteBuf 内存管理和编解码设计一条条打通——直到他能独立负责鹊桥的编解码与内存管理。

---

## 写在前面：本文基于什么版本

截至 2026 年 7 月，Netty 官方文档将**4.2**标记为“Stable, Recommended”，同时继续维护 4.1 系列。本文示例以：

- JDK 17
- Maven
- Netty 4.2.16.Final

为基础。

如果你的项目仍在使用 Netty 4.1，大部分核心概念和示例仍然适用。不过，升级前应先阅读官方迁移指南，并在压测、兼容性测试和故障演练完成后再进入生产环境。

---

## 一、Netty到底是什么

周一早上九点，祁霖在"栖云互娱"长连接组的工位上坐下，面前的大屏幕被程焕之投了一张旧版鹊桥的架构图：Tomcat 集群、客户端每五秒轮询一次、Redis 存待推送消息。图的右下角用红笔写着一行字——"上周六活动夜，连接堆积，雪崩"。

"上周六晚上八点十七分，"程焕之把马克笔放下，"运营在游戏里挂了个限时活动，在线连接冲到 52 万。Tomcat 的工作线程全部堆在轮询请求上，队列越积越长，P99 推送延迟从 80 毫秒飙到 40 多秒，最后整个网关假死。白芷半夜把机器一台台摘下来才止血。"他看向祁霖，"这就是你来的原因。我们正在用 Netty 4.2 重写鹊桥，你从今天开始参与。"

祁霖 previous 做了两年 CRUD 后端，第一次接触 Netty，正是因为这样的场景——很多 Java 开发者第一次接触 Netty，往往是因为 Dubbo、gRPC、RocketMQ、Elasticsearch、游戏服务器、即时通信系统或者网关。真正学懂 Netty，不是记住几个类名，而是理解：**事件如何到达、线程如何调度、数据如何流过 Pipeline、内存由谁管理，以及协议边界如何定义。**程焕之在白板边上补了一句他的口头禅："连接是资源，不是免费午餐。"

Netty 是一个基于 Java 的异步、事件驱动网络应用框架，用来快速开发高性能、高可靠性的协议服务器和客户端。

它不是一个完整的业务服务器，也不是 Spring MVC 那样的 Web 开发框架。它更像一套经过工程化封装的网络编程基础设施，帮助我们处理：

- TCP、UDP、HTTP、WebSocket 等网络通信；
- 非阻塞 I/O 与多路复用；
- 连接建立、断开与异常；
- 数据缓冲区管理；
- 协议编解码；
- 粘包与拆包；
- 心跳检测与空闲连接；
- TLS 加密；
- 异步任务与事件传播；
- 高并发连接下的线程调度；
- Linux 原生传输能力。

一句话概括：

> ### JDK NIO 提供底层能力，Netty 提供可用于生产环境的网络编程模型。

### 1. 为什么不直接使用Socket或JDK NIO

直接使用`Socket`编写一个简单服务器并不难，但当需求逐渐复杂时，开发者需要自己解决：

1. 1. 一个连接一个线程带来的线程膨胀；
2. 2. Selector 注册、轮询和唤醒；
3. 3. 半包、粘包与协议边界；
4. 4. 缓冲区扩容、复用和释放；
5. 5. 连接状态与异常传播；
6. 6. 心跳、超时、重连；
7. 7. 写缓冲区积压和背压；
8. 8. TLS、HTTP、WebSocket 等协议细节；
9. 9. 跨平台传输实现；
10. 10. 性能调优与内存泄漏排查。

Netty 的价值不只是“封装 NIO”，而是提供了一套稳定、可扩展、可测试的网络应用架构。

### 2. 常见应用场景

Netty 特别适合：

- 即时通信与聊天室；
- 游戏服务器；
- 物联网设备接入；
- RPC 框架；
- API 网关与代理服务器；
- 消息中间件；
- 推送系统；
- 实时行情与交易通道；
- 自定义二进制协议；
- 大规模长连接服务。

如果只是普通的管理后台或 CRUD 系统，直接使用 Spring Boot 的 HTTP 技术栈通常更高效；如果需要掌控连接、协议、延迟和吞吐，Netty 才能体现真正价值。祁霖盯着那张红字架构图想：鹊桥需要掌控的，恰好全在后面这一栏。

---

## 二、从BIO到NIO：为什么需要事件驱动

周二下午，白芷把上周活动夜的监控时序图拉给祁霖看：八点十七分线程数从 400 一路爬到 8000，CPU 不高，内存却直线上升，"线程全阻塞在 read 上，一个都跑不动"。程焕之说："先想清楚这条消息在哪条线程上——旧架构里，每条连接都绑架了一条线程。"

### 1. BIO：一个连接一个线程

传统阻塞 I/O 模型中：

```
客户端连接1 ──> 线程1 ──> 阻塞读取客户端连接2 ──> 线程2 ──> 阻塞读取客户端连接3 ──> 线程3 ──> 阻塞读取
```
优点是代码直观，缺点是连接数上升后线程数量、上下文切换和内存消耗快速增长。

尤其在长连接系统中，大量连接大部分时间没有数据，却仍然占用线程资源。

### 2. NIO：一个线程管理多个连接

JDK NIO 使用非阻塞 Channel 和 Selector：

```
多个连接 ──> Selector ──> 少量线程处理就绪事件
```
线程不再一直等待某个连接，而是询问 Selector：

> 哪些连接已经准备好接受、读取或写入？

这就是 I/O 多路复用。

### 3. Reactor模型

Netty 的线程模型通常用 Reactor 模型解释。

#### 单Reactor单线程

一个线程同时负责：

- 接收连接；
- 读取数据；
- 解码；
- 业务处理；
- 写回结果。

适合演示，不适合复杂生产业务。

#### 单Reactor多线程

Reactor 线程负责 I/O，把耗时业务提交到业务线程池。

#### 主从Reactor多线程

生产环境最常见：

```
┌────────────────────┐客户端连接 ──> │ Boss EventLoopGroup│              │ 负责Accept          │              └─────────┬──────────┘                        │                        v              ┌─────────────────────┐              │Worker EventLoopGroup│              │负责Read/Write       │              └─────────┬───────────┘                        │                        v              ┌─────────────────────┐              │ ChannelPipeline     │              │ 编解码、鉴权、业务   │              └─────────────────────┘
```
Boss 通常只需要很少的线程；Worker 中的 EventLoop 会负责多个 Channel 的 I/O 事件。

---

## 三、Netty核心架构全景图

周三上午，程焕之把会议室白板擦干净，用十分钟画了一张 Netty 全景图，从 Bootstrap 一路画到 ByteBuf。祁霖数了数，七个名词，一根主线。"接下来两个月，你做的每件事都落在这条线上。"程焕之说，"先记住主线，细节后面补。"

学习 Netty 时，最容易被大量类名劝退。先记住下面这条主线：

```
Bootstrap    │    vEventLoopGroup    │    vChannel    │    vChannelPipeline    │    vChannelHandler    │    vByteBuf
```
### 1. Bootstrap与ServerBootstrap

`Bootstrap`用于启动客户端或无连接协议端点。

`ServerBootstrap`用于启动服务端。

它们负责装配：

- EventLoopGroup；
- Channel 类型；
- ChannelOption；
- ChannelInitializer；
- 本地或远程地址；
- 连接、绑定和启动过程。

可以把它们理解为 Netty 应用的“组装器”。

### 2. EventLoopGroup与EventLoop

`EventLoopGroup`是 EventLoop 的集合。

一个 EventLoop 通常：

- 绑定一个线程；
- 管理多个 Channel；
- 处理这些 Channel 的 I/O 事件；
- 执行提交到该 EventLoop 的普通任务；
- 执行定时任务。

一个 Channel 注册到某个 EventLoop 后，通常在生命周期内保持线程亲和性。也就是说，同一个 Channel 的事件通常由同一个 EventLoop 线程顺序处理。

这带来一个重要好处：

> 对单个连接的状态操作，很多时候不需要额外加锁。

但这并不意味着所有代码都天然线程安全。共享对象、跨 Channel 状态、业务线程池中的访问仍需正确处理并发。

### 3. Channel

Channel 是对网络连接或 I/O 端点的抽象。

常见实现包括：

- `NioServerSocketChannel`：NIO TCP 服务端监听 Channel；
- `NioSocketChannel`：NIO TCP 客户端或已建立连接；
- `NioDatagramChannel`：UDP；
- Epoll、KQueue、io_uring 等原生传输对应的 Channel。

Channel 提供：

- 当前连接状态；
- 本地与远程地址；
- Pipeline；
- EventLoop；
- 配置项；
- 异步写入和关闭能力。

### 4. ChannelPipeline

每个 Channel 都有一个 Pipeline。

Pipeline 是一组按顺序组织的 Handler，用于处理入站事件和出站操作。

```
入站数据：Socket -> Handler A -> Handler B -> Handler C -> 业务出站数据：业务 -> Handler C -> Handler B -> Handler A -> Socket
```
典型 Pipeline：

```
IdleStateHandler     ↓LengthFieldBasedFrameDecoder     ↓MessageDecoder     ↓AuthenticationHandler     ↓BusinessHandler     ↓MessageEncoder
```
Pipeline 的本质是责任链模式与拦截器模式的组合。

### 5. ChannelHandler

Handler 是真正处理事件的组件。

常见类型：

- `ChannelInboundHandler`：处理连接、读取、异常等入站事件；
- `ChannelOutboundHandler`：处理写、刷新、连接、关闭等出站操作；
- `ChannelDuplexHandler`：同时处理入站和出站；
- `ByteToMessageDecoder`：字节到消息；
- `MessageToByteEncoder`：消息到字节；
- `SimpleChannelInboundHandler<T>`：按类型处理消息并自动释放引用计数对象。

### 6. ChannelHandlerContext

每个 Handler 在 Pipeline 中都有一个对应的`ChannelHandlerContext`。

它可以：

- 获取 Channel；
- 获取 Pipeline；
- 将事件传给下一个 Handler；
- 从当前位置发起写操作；
- 动态增删 Handler；
- 访问 Executor。

需要区分：

```
ctx.writeAndFlush(message);
```
从当前 Handler 所在位置向出站方向传播。

```
ctx.channel().writeAndFlush(message);
```
从整个 Pipeline 的尾部开始传播。

大多数业务代码使用哪一种都能工作，但在存在多个出站 Handler 时，传播起点会影响哪些 Handler 被执行。

### 7. ChannelFuture与Promise

Netty 的 I/O 操作几乎都是异步的。

例如：

```
ChannelFuture future = channel.writeAndFlush(message);
```
调用返回时，数据不一定已经写入操作系统，更不代表对端已经收到。

正确做法是添加监听器：

```
future.addListener(f -> {     if (f.isSuccess()) {         System.out.println("写入成功");     } else {         System.err.println("写入失败：" + f.cause());     }});
```
不要在 EventLoop 线程中随意调用`sync()`或`await()`等阻塞方法，否则可能造成死锁或阻塞整个连接组。

---

## 四、搭建第一个Netty项目

周三下午，程焕之给祁霖分了第一个任务：给新人培练环境搭一个独立的 Maven 项目，"先把地基打起来，别动鹊桥的代码。"祁霖在项目名上犹豫了一下，写下了`netty-learning`。JDK 17，Netty 4.2.16.Final——和鹊桥重写的版本保持一致，这样以后学到的东西可以直接迁移过去。

### 1. Maven配置

创建一个普通 Maven 项目，在`pom.xml`中加入：

```
<project xmlns="http://maven.apache.org/POM/4.0.0"          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"          xsi:schemaLocation="http://maven.apache.org/POM/4.0.0          https://maven.apache.org/xsd/maven-4.0.0.xsd">     <modelVersion>4.0.0</modelVersion>     <groupId>com.example</groupId>     <artifactId>netty-learning</artifactId>     <version>1.0.0</version>     <properties>         <maven.compiler.release>17</maven.compiler.release>         <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>         <netty.version>4.2.16.Final</netty.version>     </properties>     <dependencies>         <dependency>             <groupId>io.netty</groupId>             <artifactId>netty-all</artifactId>             <version>${netty.version}</version>         </dependency>         <dependency>             <groupId>org.junit.jupiter</groupId>             <artifactId>junit-jupiter</artifactId>             <version>5.13.4</version>             <scope>test</scope>         </dependency>     </dependencies>     <build>         <plugins>             <plugin>                 <groupId>org.apache.maven.plugins</groupId>                 <artifactId>maven-surefire-plugin</artifactId>                 <version>3.5.3</version>             </plugin>         </plugins>     </build></project>
```
生产项目通常会按需引入`netty-transport`、`netty-codec`、`netty-handler`等模块，以减少不必要依赖。学习阶段使用`netty-all`更直观。

### 2. 项目结构

```
src├── main│   └── java│       └── com.example.netty│           ├── EchoServer.java│           ├── EchoServerHandler.java│           ├── EchoClient.java│           └── EchoClientHandler.java└── test    └── java
```

---

## 五、实现第一个Echo服务器

周四，程焕之把 Echo 服务器作为新人练手题布置下来："别小看 Echo，它包含一个网关最核心的骨架：接收连接、读数据、写回去。鹊桥的接入层，剥掉业务之后就是一条更长的 Echo。"祁霖写完跑起来，看到控制台打出"Echo服务器已启动，端口：8080"，才算第一次亲手摸到 Netty。

### 1. 服务端启动类

```
package com.example.netty;import io.netty.bootstrap.ServerBootstrap;import io.netty.channel.Channel;import io.netty.channel.ChannelInitializer;import io.netty.channel.ChannelOption;import io.netty.channel.EventLoopGroup;import io.netty.channel.nio.NioEventLoopGroup;import io.netty.channel.socket.SocketChannel;import io.netty.channel.socket.nio.NioServerSocketChannel;import io.netty.handler.codec.LineBasedFrameDecoder;import io.netty.handler.codec.string.StringDecoder;import io.netty.handler.codec.string.StringEncoder;import io.netty.util.CharsetUtil;public final class EchoServer {     private final int port;      public EchoServer(int port) {         this.port = port;     }      public void start() throws InterruptedException {         EventLoopGroup bossGroup = new NioEventLoopGroup(1);         EventLoopGroup workerGroup = new NioEventLoopGroup();         try {             ServerBootstrap bootstrap = new ServerBootstrap();             bootstrap                 .group(bossGroup, workerGroup)                 .channel(NioServerSocketChannel.class)                 .option(ChannelOption.SO_BACKLOG, 1024)                 .childOption(ChannelOption.TCP_NODELAY, true)                 .childOption(ChannelOption.SO_KEEPALIVE, true)                 .childHandler(new ChannelInitializer<SocketChannel>() {                     @Override                     protected void initChannel(SocketChannel channel) {                         channel.pipeline()                             .addLast(new LineBasedFrameDecoder(8192))                             .addLast(new StringDecoder(CharsetUtil.UTF_8))                             .addLast(new StringEncoder(CharsetUtil.UTF_8))                             .addLast(new EchoServerHandler());                     }                 });             Channel serverChannel = bootstrap.bind(port).sync().channel();             System.out.println("Echo服务器已启动，端口：" + port);             serverChannel.closeFuture().sync();         } finally {             bossGroup.shutdownGracefully().sync();             workerGroup.shutdownGracefully().sync();         }     }      public static void main(String[] args) throws InterruptedException {         new EchoServer(8080).start();     }}
```
### 2. 服务端Handler

```
package com.example.netty;import io.netty.channel.ChannelHandlerContext;import io.netty.channel.SimpleChannelInboundHandler;public final class EchoServerHandler         extends SimpleChannelInboundHandler<String> {     @Override     public void channelActive(ChannelHandlerContext ctx) {         System.out.println("客户端已连接：" + ctx.channel().remoteAddress());     }      @Override     protected void channelRead0(             ChannelHandlerContext ctx,             String message) {         String text = message.trim();         System.out.println("收到客户端消息：" + text);         ctx.writeAndFlush(             "服务器已收到：" + text + System.lineSeparator()         );     }      @Override     public void channelInactive(ChannelHandlerContext ctx) {         System.out.println("客户端已断开：" + ctx.channel().remoteAddress());     }      @Override     public void exceptionCaught(             ChannelHandlerContext ctx,             Throwable cause) {         cause.printStackTrace();         ctx.close();     }}
```
### 3. 这段代码发生了什么

`bossGroup`负责接收新连接。

`workerGroup`负责已建立连接的读取和写入。

`ChannelInitializer`会为每一个新连接配置独立的 Pipeline。

`LineBasedFrameDecoder`按换行符切分消息，解决基于文本协议的粘包和拆包问题。

`StringDecoder`把`ByteBuf`转成字符串。

`StringEncoder`把字符串转成`ByteBuf`。

`EchoServerHandler`只关心业务消息，不再处理底层字节。

---

## 六、实现Netty客户端

服务端有了，总得有东西来连它。祁霖本来想用 telnet 凑合，白芷路过看了一眼："telnet 只能证明能连，证明不了能扛。写个客户端程序，以后改造成压测工具，接进我的监控里。"于是周五上午，Echo 客户端成了祁霖的下一个任务——它后面会长成鹊桥的连接压测工具。

### 1. 客户端启动类

```
package com.example.netty;import io.netty.bootstrap.Bootstrap;import io.netty.channel.Channel;import io.netty.channel.ChannelInitializer;import io.netty.channel.ChannelOption;import io.netty.channel.EventLoopGroup;import io.netty.channel.nio.NioEventLoopGroup;import io.netty.channel.socket.SocketChannel;import io.netty.channel.socket.nio.NioSocketChannel;import io.netty.handler.codec.LineBasedFrameDecoder;import io.netty.handler.codec.string.StringDecoder;import io.netty.handler.codec.string.StringEncoder;import io.netty.util.CharsetUtil;public final class EchoClient {     private final String host;     private final int port;      public EchoClient(String host, int port) {         this.host = host;         this.port = port;     }      public void start() throws InterruptedException {         EventLoopGroup group = new NioEventLoopGroup();         try {             Bootstrap bootstrap = new Bootstrap();             bootstrap                 .group(group)                 .channel(NioSocketChannel.class)                 .option(ChannelOption.CONNECT_TIMEOUT_MILLIS, 5000)                 .option(ChannelOption.TCP_NODELAY, true)                 .handler(new ChannelInitializer<SocketChannel>() {                     @Override                     protected void initChannel(SocketChannel channel) {                         channel.pipeline()                             .addLast(new LineBasedFrameDecoder(8192))                             .addLast(new StringDecoder(CharsetUtil.UTF_8))                             .addLast(new StringEncoder(CharsetUtil.UTF_8))                             .addLast(new EchoClientHandler());                     }                 });             Channel channel = bootstrap.connect(host, port).sync().channel();             channel.writeAndFlush(                 "你好，Netty！" + System.lineSeparator()             );             channel.closeFuture().sync();         } finally {             group.shutdownGracefully().sync();         }     }      public static void main(String[] args) throws InterruptedException {         new EchoClient("127.0.0.1", 8080).start();     }}
```
### 2. 客户端Handler

```
package com.example.netty;import io.netty.channel.ChannelHandlerContext;import io.netty.channel.SimpleChannelInboundHandler;public final class EchoClientHandler         extends SimpleChannelInboundHandler<String> {     @Override     protected void channelRead0(             ChannelHandlerContext ctx,             String message) {         System.out.println("服务器响应：" + message.trim());         ctx.close();     }      @Override     public void exceptionCaught(             ChannelHandlerContext ctx,             Throwable cause) {         cause.printStackTrace();         ctx.close();     }}
```
先启动服务端，再启动客户端，即可看到一次完整通信。

---

## 七、入站事件与出站事件

周五下午，祁霖给 Echo 服务器加了个日志 Handler，想记录每条消息的进出，结果日志顺序全乱了：明明写在 Pipeline 最后的 Handler，打印却出现在解码之前；有时一条消息只打了一次，有时连不上。他调了两个小时没头绪，去找程焕之。程焕之在白板上画了两个方向相反的箭头："先想清楚这条消息在哪条线程上，再想清楚事件往哪个方向流。你不区分入站和出站，Pipeline 当然不按你想的走。"

### 1. 常见入站事件

入站事件通常包括：

- Channel 注册；
- Channel 激活；
- 读取到数据；
- 读取完成；
- Channel 失活；
- 用户自定义事件；
- 异常事件。

常用方法：

```
channelRegistered(...)channelActive(...)channelRead(...)channelReadComplete(...)channelInactive(...)userEventTriggered(...)exceptionCaught(...)
```
### 2. 常见出站操作

出站操作包括：

- bind；
- connect；
- disconnect；
- close；
- read；
- write；
- flush。

### 3. Pipeline传播方向

假设 Pipeline 为：

```
A -> B -> C -> D
```
入站事件从头向尾：

```
A -> B -> C -> D
```
出站事件从尾向头：

```
D -> C -> B -> A
```
当 Handler 不处理某个事件时，应继续传播。

入站传播：

```
ctx.fireChannelRead(msg);
```
出站传播：

```
ctx.write(msg, promise);
```
忘记传播，会导致后续 Handler 永远收不到事件。

---

## 八、ByteBuf：Netty性能的核心之一

第二周周二凌晨一点半，鹊桥预发环境告警：堆内存正常，堆外直接内存却在一个小时内从 2GB 涨到 14GB，机器眼看要被 OOM killer 杀掉。白芷把祁霖叫起来，两人对着`-Dio.netty.leakDetection.level=advanced`吐出的泄漏报告翻了四十分钟，最后定位到一条推送路径：业务线程池异步持有了一个 ByteBuf，异常分支提前 return，没有 release。祁霖后背发凉——这就是程焕之说的"连接是资源，不是免费午餐"，内存也一样。第二天早上，程焕之把 ByteBuf 的整个生命周期给他从头讲了一遍。

JDK NIO 使用`ByteBuffer`，Netty 提供`ByteBuf`。

### 1. ByteBuf的优势

`ByteBuf`具有：

- 独立的 readerIndex 与 writerIndex；
- 动态扩容；
- 池化分配；
- 堆内存与直接内存；
- 零拷贝相关能力；
- 引用计数；
- 丰富的读写方法；
- 组合缓冲区。

### 2. 读写索引

```
0                readerIndex          writerIndex       capacity| 已丢弃区域 | 可读区域 | 可写区域 |
```
常用方法：

```
buf.readableBytes();buf.writableBytes();buf.readerIndex();buf.writerIndex();buf.isReadable();buf.clear();buf.markReaderIndex();buf.resetReaderIndex();
```
### 3. 基本读写

```
ByteBuf buf = ctx.alloc().buffer();buf.writeInt(100);buf.writeLong(200L);buf.writeBytes("Netty".getBytes(CharsetUtil.UTF_8));int number = buf.readInt();long value = buf.readLong();byte[] bytes = new byte[buf.readableBytes()];buf.readBytes(bytes);
```
不要默认使用：

```
buf.array();
```
因为直接内存 ByteBuf 不一定有可访问的 Java 数组。更通用的方式是按`readableBytes()`复制，或者直接使用 Netty 提供的编解码 API。

### 4. 堆内存与直接内存

堆内存：

- 由 JVM 堆管理；
- 普通 Java 访问方便；
- 进行 Socket I/O 时可能需要额外复制。

直接内存：

- 位于堆外；
- 更适合底层 I/O；
- 分配和释放成本较高；
- 配合池化后性能更好。

Netty 通常优先使用池化分配器，并根据场景使用直接缓冲区。

### 5. 引用计数

在 Netty 4.x 中，部分对象通过引用计数管理生命周期，`ByteBuf`是最典型的对象。

```
int count = buf.refCnt();buf.retain();buf.release();
```
当引用计数降为 0，底层内存会被释放或归还对象池。

核心原则：

> 最后使用对象的一方负责释放。

### 6. SimpleChannelInboundHandler为什么方便

`SimpleChannelInboundHandler<T>`会在`channelRead0`返回后自动释放匹配的引用计数消息。

因此下面的代码一般不需要手动`release()`：

```
@Overrideprotected void channelRead0(         ChannelHandlerContext ctx,         ByteBuf msg) {     System.out.println(msg.readableBytes());}
```
如果消息要交给异步线程继续使用，必须明确转移生命周期：

```
ByteBuf retained = msg.retainedDuplicate();businessExecutor.execute(() -> {     try {         process(retained);     } finally {         retained.release();     }});
```
### 7. ChannelInboundHandlerAdapter中的释放

如果使用`ChannelInboundHandlerAdapter`并消费消息：

```
@Overridepublic void channelRead(         ChannelHandlerContext ctx,         Object msg) {     try {         // 使用msg     } finally {         ReferenceCountUtil.release(msg);     }}
```
如果把原消息继续传递给下一个 Handler：

```
ctx.fireChannelRead(msg);
```
通常不要在当前 Handler 立即释放，因为所有权已经交给后续处理者。

### 8. 内存泄漏检测

开发和测试环境可设置：

```
-Dio.netty.leakDetection.level=advanced
```
常见级别：

- `disabled`
- `simple`
- `advanced`
- `paranoid`

`paranoid`开销很大，适合短时间定位问题，不适合默认用于高负载生产环境。

---

## 九、编解码器：把字节变成业务消息

OOM 事故复盘会上，白芷提出新的要求：推送 JSON 帧的编解码必须规范化——长度头、帧边界、编码器解码器一一对应，不许再散落在各个 Handler 里手写解析。程焕之把这个任务正式交给了祁霖："从这周起，鹊桥的编解码由你负责。Netty 的解码器体系就是为这件事准备的，学明白它，你的第一块独立领地就有了。"

网络上传输的最终都是字节。业务代码希望处理的是对象，因此需要：

```
ByteBuf <-> 协议消息对象
```
### 1. ByteToMessageDecoder

用于把字节流解码为消息：

```
public final class IntegerDecoder         extends ByteToMessageDecoder {     @Override     protected void decode(             ChannelHandlerContext ctx,             ByteBuf in,             List<Object> out) {         if (in.readableBytes() < Integer.BYTES) {             return;         }         out.add(in.readInt());     }}
```
当数据不足时直接返回，Netty 会保留未消费数据，并在后续数据到达时再次调用。

### 2. MessageToByteEncoder

用于把对象编码为字节：

```
public final class IntegerEncoder         extends MessageToByteEncoder<Integer> {     @Override     protected void encode(             ChannelHandlerContext ctx,             Integer message,             ByteBuf out) {         out.writeInt(message);     }}
```
### 3. MessageToMessageDecoder

用于消息到消息的转换，例如：

- `FullHttpRequest`转业务请求；
- JSON 字符串转 Java 对象；
- 协议对象转领域对象。

### 4. CombinedChannelDuplexHandler

当解码器和编码器属于同一协议时，可组合成一个双向 Codec，便于装配和复用。

---



第二周的第一个工作日，"鹊桥"网关出事了。

周一晚上八点，压测环境里五万条模拟连接跑得正欢，白芷忽然在群里 @ 了祁霖："推送对不上账了。客户端 A 订阅的是对战 room-1024 的战况，收到的却是 room-2048 的结算消息；还有一批客户端收到的 JSON 少了半截，反序列化直接抛异常。"祁霖把自己写的 JSON 编解码器翻来覆去看了三遍，编码和解码逻辑都是对称的，单测也是绿的。他把日志拉出来对比，发现服务端确实发出了完整的消息，客户端收到的却是两条消息黏在一起、或者一条消息被拦腰截断。

第二天一早，程焕之听完描述，在白板上写了四个字：TCP 粘包。"你前两周规范了事件顺序、ByteBuf 释放和 JSON 编解码，但漏了最基础的一课——TCP 是字节流，不是消息流。它只保证字节按序到达，从不保证你写一次、对面就收到一次。"他敲了敲白板，"先想清楚这条消息在哪条线程上是一回事，先想清楚这条消息在网络上是几段字节，是另一回事。"

## 十、TCP粘包与拆包

### 1. 为什么会粘包

TCP 是字节流协议，不保留应用层消息边界。

发送端执行：

```
发送A发送B
```
接收端可能得到：

```
A + B
```
这叫粘包。

也可能得到：

```
A的一部分A剩余部分 + B的一部分B剩余部分
```
这叫拆包或半包。

这不是 TCP 的错误，而是应用层必须自己定义消息边界。

### 2. 常见解决方案

#### 固定长度

每条消息固定 128 字节：

```
pipeline.addLast(new FixedLengthFrameDecoder(128));
```
#### 分隔符

消息以换行或特殊字符结尾：

```
pipeline.addLast(new LineBasedFrameDecoder(8192));
```
或：

```
ByteBuf delimiter =     Unpooled.copiedBuffer("$_".getBytes(StandardCharsets.UTF_8));pipeline.addLast(    new DelimiterBasedFrameDecoder(8192, delimiter));
```
#### 长度字段

协议头中包含消息体长度，这是最常见、最灵活的方案：

```
魔数 | 版本 | 类型 | 请求ID | 消息体长度 | 消息体
```
Netty 提供`LengthFieldBasedFrameDecoder`，可以处理绝大多数带长度字段的协议。

### 3. LengthFieldBasedFrameDecoder参数

构造参数中最容易混淆的是：

```
new LengthFieldBasedFrameDecoder(    maxFrameLength,    lengthFieldOffset,    lengthFieldLength,    lengthAdjustment,    initialBytesToStrip);
```
假设协议：

```
+--------+----------+----------------+| length | command  | body           || 4字节   | 2字节     | N字节          |+--------+----------+----------------+
```
其中`length`表示 body 长度，则：

```
new LengthFieldBasedFrameDecoder(    1024 * 1024,    0,    4,    2,    0);
```
为什么`lengthAdjustment`是 2？

因为长度字段只记录 body，不包含后面的 2 字节 command，但完整帧中 command 位于长度字段与 body 之间。

实际项目中一定要先画出协议字节布局，再计算偏移量。

---

粘包问题查清之后，程焕之把祁霖叫到白板前："推送通道用 JSON 还能凑合，但对战指令不行。对战指令一局能到每秒几十条，帧头那点开销和 JSON 的解析耗时会直接吃掉你 P99 < 100ms 的预算。这周你给对战指令设计一个二进制协议。"

祁霖先画了字节布局图，又把魔数、版本、类型一个个排上去。画到"消息体长度"那一格时，他忽然明白了上一章那个 `lengthAdjustment = 2` 到底在调什么——不是死记的参数，是字节布局的算术。程焕之看了一眼他的草图，只提了一个要求："解码器必须防住非法魔数和超长 body，鹊桥迟早要面对公网上的乱流。"

## 十一、设计一个自定义二进制协议

### 1. 协议结构

设计如下：

```
+----------+---------+------+-----------+------------+----------+| magic    | version | type | requestId | bodyLength | body     || 4字节     | 1字节    | 1字节 | 8字节      | 4字节       | N字节     |+----------+---------+------+-----------+------------+----------+
```
字段说明：

- magic：识别是否为本协议；
- version：协议版本；
- type：消息类型；
- requestId：请求与响应关联；
- bodyLength：消息体长度；
- body：实际负载。

### 2. 消息对象

```
package com.example.netty.protocol;public record ProtocolMessage(        byte version,        byte type,        long requestId,        byte[] body) {}
```
### 3. 编码器

```
package com.example.netty.protocol;import io.netty.buffer.ByteBuf;import io.netty.channel.ChannelHandlerContext;import io.netty.handler.codec.MessageToByteEncoder;public final class ProtocolMessageEncoder        extends MessageToByteEncoder<ProtocolMessage> {    public static final int MAGIC = 0x4E455454;    @Override    protected void encode(            ChannelHandlerContext ctx,            ProtocolMessage message,            ByteBuf out) {        byte[] body =            message.body() == null ? new byte[0] : message.body();        out.writeInt(MAGIC);        out.writeByte(message.version());        out.writeByte(message.type());        out.writeLong(message.requestId());        out.writeInt(body.length);        out.writeBytes(body);    }}
```
### 4. 解码器

```
package com.example.netty.protocol;import io.netty.buffer.ByteBuf;import io.netty.channel.ChannelHandlerContext;import io.netty.handler.codec.ByteToMessageDecoder;import io.netty.handler.codec.CorruptedFrameException;import io.netty.handler.codec.TooLongFrameException;import java.util.List;public final class ProtocolMessageDecoder        extends ByteToMessageDecoder {    private static final int HEADER_LENGTH = 18;    private static final int MAX_BODY_LENGTH = 1024 * 1024;    @Override    protected void decode(            ChannelHandlerContext ctx,            ByteBuf in,            List<Object> out) {        if (in.readableBytes() < HEADER_LENGTH) {            return;        }        in.markReaderIndex();        int magic = in.readInt();        if (magic != ProtocolMessageEncoder.MAGIC) {            throw new CorruptedFrameException(                "非法魔数：0x" + Integer.toHexString(magic)            );        }        byte version = in.readByte();        byte type = in.readByte();        long requestId = in.readLong();        int bodyLength = in.readInt();        if (bodyLength < 0 || bodyLength > MAX_BODY_LENGTH) {            throw new TooLongFrameException(                "非法消息体长度：" + bodyLength            );        }        if (in.readableBytes() < bodyLength) {            in.resetReaderIndex();            return;        }        byte[] body = new byte[bodyLength];        in.readBytes(body);        out.add(new ProtocolMessage(            version,            type,            requestId,            body        ));    }}
```
### 5. Pipeline配置

```
pipeline.addLast(new ProtocolMessageDecoder());pipeline.addLast(new ProtocolMessageEncoder());pipeline.addLast(new ProtocolBusinessHandler());
```
### 6. 协议设计建议

一个可用于生产的协议还应考虑：

- 校验和或摘要；
- 压缩标志；
- 序列化方式；
- 请求类型和响应类型；
- 错误码；
- 时间戳；
- 扩展字段；
- 协议版本协商；
- 最大消息限制；
- 防重放机制；
- 鉴权信息；
- 分片与合并策略。

不要把 Java 原生序列化直接暴露到不可信网络中。跨语言系统可根据需求选择 Protobuf、FlatBuffers、JSON、MessagePack、CBOR 等方案。

---

周三凌晨两点，值班群炸了。白芷发了一条告警截图："鹊桥网关文件描述符耗尽，accept 新连接全部失败，持续 11 分钟。"祁霖被电话叫醒，远程登上机器，`lsof` 一拉，几十万个 ESTABLISHED 连接里，一大半是几个小时前活动结束后的僵尸连接——客户端进程早没了，路由器上的 NAT 映射也失效了，但服务端这边既收不到 FIN，也收不到任何数据，连接就那么"活着"。

复盘会上，程焕之在白板上写下"连接是资源，不是免费午餐"。"五万僵尸连接挂在上面，每一条都占着 fd、占着内存、占着 EventLoop 的注册表。客户端不会主动告诉你它死了，你得自己去问——这就是心跳和空闲检测。"

## 十二、心跳与空闲连接检测

长连接系统必须处理：

- 客户端断电；
- 网络切换；
- NAT 映射失效；
- 防火墙清理空闲连接；
- 应用假死；
- 半开连接。

### 1. IdleStateHandler

```
pipeline.addLast(    new IdleStateHandler(        60,        30,        0,        TimeUnit.SECONDS    ));
```
表示：

- 60 秒没有读事件，触发读空闲；
- 30 秒没有写事件，触发写空闲；
- 不检测读写同时空闲。

### 2. 心跳Handler

```
public final class HeartbeatHandler        extends ChannelDuplexHandler {    @Override    public void userEventTriggered(            ChannelHandlerContext ctx,            Object event) throws Exception {        if (event instanceof IdleStateEvent idleEvent) {            switch (idleEvent.state()) {                case READER_IDLE -> {                    System.out.println("读空闲，关闭连接");                    ctx.close();                }                case WRITER_IDLE -> {                    ProtocolMessage heartbeat =                         new ProtocolMessage(                            (byte) 1,                            (byte) 0x01,                            0L,                            new byte[0]                        );                    ctx.writeAndFlush(heartbeat);                }                case ALL_IDLE -> {                    // 根据协议决定处理策略                }            }            return;        }        super.userEventTriggered(ctx, event);    }}
```
### 3. 心跳设计原则

- 心跳包尽量小；
- 心跳间隔不要过短；
- 服务端可只检测读空闲；
- 客户端可在写空闲时发送 Ping；
- 连续多次超时再断开，可降低网络抖动误判；
- 心跳应走完整协议编解码链；
- 不要只依赖 TCP Keepalive；
- 断开后要清理会话、定时任务和业务状态。

---

心跳方案上线后的那个周五，祁霖坐地铁回家，顺手用手机连着压测环境跑客户端。地铁钻进隧道，网络断了十几秒；出了站又恢复。他盯着客户端日志：断线后客户端没有重连，界面一直转圈；后来他改了一版"立即无限重连"，结果演练时压测环境重启，五万个客户端以毫秒级间隔疯狂重试，把正在恢复的服务端摁在地上摩擦——重连风暴比断线本身更致命。

周末他把客户端的 `ReconnectManager` 重写了一遍，加上指数退避，又找白芷要了一份地铁断网时段的抓包做回归。周一程焕之看到代码，点了点头："断线不可怕，可怕的是恢复的方式放大了故障。"

## 十三、断线重连与指数退避

客户端重连不能写成无限快速循环，否则服务端故障时会形成重连风暴。

推荐指数退避：

```
第1次：1秒第2次：2秒第3次：4秒第4次：8秒……最大：30秒
```
示例思路：

```
public final class ReconnectManager {    private final Bootstrap bootstrap;    private final int maxDelaySeconds;    private int attempts;    public ReconnectManager(            Bootstrap bootstrap,            int maxDelaySeconds) {        this.bootstrap = bootstrap;        this.maxDelaySeconds = maxDelaySeconds;    }    public void connect(String host, int port) {        bootstrap.connect(host, port).addListener(future -> {            if (future.isSuccess()) {                attempts = 0;                System.out.println("连接成功");                return;            }            int delay = Math.min(                1 << Math.min(attempts, 5),                maxDelaySeconds            );            attempts++;            bootstrap.config()                .group()                .next()                .schedule(                    () -> connect(host, port),                    delay,                    TimeUnit.SECONDS                );        });    }}
```
生产环境还应加入：

- 随机抖动 jitter；
- 最大重试次数或熔断；
- 服务发现；
- 连接状态机；
- 鉴权恢复；
- 未完成请求的失败处理；
- 重连后订阅与会话恢复。

---

第二次事故来得毫无预兆。周四下午三点，白芷的监控面板上，推送延迟 P99 从 40ms 一路爬到 9 秒，全服推送几乎停摆。祁霖顺着慢请求日志查下去，发现是一个新同事在推送 Handler 里加了一段"权限校验"——`channelRead0` 里同步查了一次 Redis，再同步查了一次 MySQL。单次查询也就几十毫秒，可一个 EventLoop 上挂着几千条连接，这一查，同一条线程上所有连接的读写全部排队。

程焕之看了一眼火焰图，指向那根孤零零竖起的长条："先想清楚这条消息在哪条线程上。你查库的时候，这条线程不是你的，是几千条连接共用的。"祁霖把查询挪进业务线程池，P99 十分钟内回到 40ms。他把这次事故的火焰图打印出来，贴在了工位隔板上。

## 十四、不要阻塞EventLoop

这是 Netty 最重要的工程原则之一。

### 1. 错误示例

```
@Overrideprotected void channelRead0(        ChannelHandlerContext ctx,        Request request) throws Exception {    Thread.sleep(5000);    Response response = database.query(request);    ctx.writeAndFlush(response);}
```
同一个 EventLoop 可能管理大量 Channel。一个 Handler 阻塞 5 秒，这个 EventLoop 上的其他连接也会延迟。

常见阻塞源：

- 数据库调用；
- 同步 HTTP 请求；
- 文件 I/O；
- 大量计算；
- `Thread.sleep()`；
- 等待锁；
- 调用`Future.get()`；
- 阻塞队列；
- 第三方同步 SDK。

### 2. 使用业务线程池

```
EventExecutorGroup businessGroup =     new DefaultEventExecutorGroup(16);pipeline.addLast(    businessGroup,    "businessHandler",    new BusinessHandler());
```
这样`BusinessHandler`会在业务线程池执行。

注意：

- 业务线程池应全局复用；
- 不要为每个连接创建线程池；
- 线程数量需要根据阻塞比例、CPU、外部依赖容量和压测结果确定；
- 切换线程有成本，不要把所有轻量操作都提交出去；
- 业务完成后写回 Channel 是线程安全的，Netty 会调度到对应 EventLoop。

### 3. CPU密集任务

CPU 密集型任务不应直接占用 EventLoop。

可使用独立固定线程池，并根据 CPU 核数和任务特征配置并发度。对于超长计算，还应考虑拆分任务、限流、超时和取消。

---

阻塞事故刚过去两天，祁霖又栽在一个更隐蔽的坑上。他写了一个 `MetricsHandler` 统计全服消息量，为了省内存，用了单例加 `@Sharable`，加入所有连接的 Pipeline。压测时白芷发现：QPS 明明是每秒 8 万，计数器每秒只涨 1 万多，而且每次对不上数的幅度还不一样。

祁霖盯着那段 `count++` 看了半天，忽然反应过来：几十条 EventLoop 线程并发执行 `count++`，丢更新丢得无声无息。更糟的是他把"每个连接的已读帧数"也塞进了这个共享 Handler 的字段里，单连接统计和全局统计搅成一团。程焕之看完只说了一句："共享的前提是线程安全，线程安全的前提是你想清楚状态属于谁。"

## 十五、线程安全与@Sharable

### 1. Handler是否可以复用

默认情况下，一个 Handler 实例不应随意加入多个 Pipeline。

如果 Handler 完全无状态，或者内部状态线程安全，可标注：

```
@ChannelHandler.Sharablepublic final class MetricsHandler        extends ChannelInboundHandlerAdapter {}
```
然后复用同一个实例。

### 2. 常见错误

下面的 Handler 不应直接共享：

```
public final class CounterHandler        extends ChannelInboundHandlerAdapter {    private int count;    @Override    public void channelRead(            ChannelHandlerContext ctx,            Object msg) {        count++;        ctx.fireChannelRead(msg);    }}
```
多个 Channel 并发访问`count`会产生数据竞争，而且这个 count 到底表示单连接还是全局也不明确。

单连接状态可存放在：

- Handler 实例中，但每个 Channel 创建一个实例；
- Channel Attribute；
- 独立会话对象。

### 3. Channel Attribute

```
public static final AttributeKey<String> USER_ID =     AttributeKey.valueOf("userId");ctx.channel().attr(USER_ID).set("user-1001");String userId = ctx.channel().attr(USER_ID).get();
```
适合存放与连接绑定的轻量状态。复杂会话仍建议建立明确的 Session 对象与生命周期管理。

---

周五晚上的一次演练，把"鹊桥"推向了另一种故障形态。白芷故意把下游会话存储的响应时间从 5ms 拧到 2 秒，模拟存储故障。五分钟后，网关堆内存曲线陡直上冲，老年代一路涨满，Full GC 接连不断。祁霖用堆转储一看：几十万个 `ChannelOutboundBuffer` 里堆满了没发出去的推送消息——下游慢，消息发不出去，上游还在拼命写，写缓冲区变成了无底洞。

"连接是资源，不是免费午餐，"程焕之说，"内存也是。客户端收不动，你就别往里灌。Netty 给你留了水位线，去把它用起来。"

## 十六、背压与写缓冲区

当生产消息的速度大于网络发送速度时，未发送数据会在写缓冲区堆积，最终可能导致内存暴涨。

### 1. 判断Channel是否可写

```
if (ctx.channel().isWritable()) {     ctx.writeAndFlush(message);} else {    // 暂停生产、丢弃低优先级消息或进入有界队列}
```
### 2. 监听可写状态变化

```
@Overridepublic void channelWritabilityChanged(        ChannelHandlerContext ctx) throws Exception {    if (ctx.channel().isWritable()) {        resumeProducing();    } else {        pauseProducing();    }    ctx.fireChannelWritabilityChanged();}
```
### 3. 配置高低水位

```
bootstrap.childOption(    ChannelOption.WRITE_BUFFER_WATER_MARK,    new WriteBufferWaterMark(        32 * 1024,        64 * 1024    ));
```
当待写字节超过高水位，Channel 变为不可写；下降到低水位后恢复可写。

### 4. 背压策略

可选择：

- 暂停从上游读取；
- 限制消息生产速度；
- 有界队列；
- 丢弃低优先级消息；
- 合并多个小消息；
- 降级为摘要数据；
- 断开长期慢消费者；
- 为不同用户设置配额。

绝对不要用无限队列掩盖慢消费者问题。

---

背压做完之后，祁霖信心满满地跑了一轮全链路推送压测，结果报告里出现了一条诡异的数据：网关统计发出 120 万条消息，客户端只收到 117 万条，中间"消失"了 3 万条。没有异常、没有断连、没有丢包计数，消息凭空蒸发。

他排查了一下午，最后把嫌疑锁定在一处"优化"上：为了省系统调用，他把某段推送从 `writeAndFlush` 改成了只 `write`，指望后面统一刷。可那条路径上后续的 flush 条件不满足，消息就静静躺在出站缓冲区里，直到连接关闭也没发出去。程焕之听完他的排查过程，只补了一句："write 是入队，flush 才是发车。车厢里坐着人不等于车开了。"

## 十七、write与flush的区别

```
ctx.write(message);
```
把消息放入出站缓冲，但不一定立即触发底层发送。

```
ctx.flush();
```
尝试把之前写入的数据向底层刷新。

```
ctx.writeAndFlush(message);
```
写入并刷新。

高频发送场景中，每条消息都`writeAndFlush()`可能增加系统调用与小包数量。可以批量：

```
for (Message message : messages) {     ctx.write(message);}ctx.flush();
```
但批量大小和延迟需要权衡，不能为了吞吐无限延后 flush。

---

三周攻坚接近尾声，观战功能的接入方式提上了日程。移动端 H5 观战页和第三方主播工具都希望走 WebSocket，而不是鹊桥自定义的二进制协议。祁霖一开始想把 WebSocket 消息在 Handler 里"翻译"成内部协议，绕了一圈发现握手、升级、帧类型这些细节比想象中多。程焕之给他划了重点："握手是一次性的 HTTP，握手之后就是长连接。Pipeline 的前半段是 HTTP，后半段是你熟悉的那个世界——但鉴权和帧大小限制必须在握手阶段就卡住。"

## 十八、WebSocket服务器实战

WebSocket 先通过 HTTP 完成握手，然后升级为长连接双向通信。

### 1. Pipeline配置

```
pipeline    .addLast(new HttpServerCodec())    .addLast(new HttpObjectAggregator(64 * 1024))    .addLast(new WebSocketServerCompressionHandler())    .addLast(        new WebSocketServerProtocolHandler(            "/ws",            null,            true        )    )    .addLast(new TextWebSocketFrameHandler());
```
### 2. 文本消息Handler

```
public final class TextWebSocketFrameHandler        extends SimpleChannelInboundHandler<TextWebSocketFrame> {    @Override    protected void channelRead0(            ChannelHandlerContext ctx,            TextWebSocketFrame frame) {        String text = frame.text();        ctx.writeAndFlush(            new TextWebSocketFrame(                "服务器收到：" + text            )        );    }}
```
### 3. 生产环境注意事项

- 限制 HTTP 聚合大小；
- 限制 WebSocket 帧大小；
- 做 Origin 校验；
- 握手阶段完成鉴权；
- 管理 Ping/Pong；
- 防止慢消费者；
- 限制单连接消息频率；
- 定义断线重连与消息补偿；
- 不要把敏感 Token 长期暴露在 URL；
- 使用 WSS；
- 处理代理层空闲超时。

---

观战频道接进来之后，安全评审跟着到了。白芷拿抓包工具在办公网里截了一条对战指令，明文的战况数据看得安全同学直皱眉。对外接入必须上 TLS，这项任务又落到了祁霖头上。他先用自签名证书把链路跑通，再找运维申请了正式证书，最后被程焕之一句话点醒："TLS Handler 放在 Pipeline 的哪个位置，决定了你加密的是字节流还是已解码的消息。想不清楚就去看握手之后数据流经的第一个 Handler 是谁。"

## 十九、为Netty启用TLS

### 1. 服务端SSL Context

本地开发可使用自签名证书：

```
SelfSignedCertificate certificate =     new SelfSignedCertificate();SslContext sslContext =     SslContextBuilder        .forServer(            certificate.certificate(),            certificate.privateKey()        )        .build();
```
在 Pipeline 最前面加入：

```
pipeline.addFirst(    "ssl",    sslContext.newHandler(channel.alloc()));
```
### 2. 生产证书

生产环境应加载可信 CA 签发的证书和私钥：

```
SslContext sslContext =     SslContextBuilder        .forServer(certChainFile, privateKeyFile)        .protocols("TLSv1.3", "TLSv1.2")        .build();
```
### 3. 客户端验证

客户端必须正确验证服务端证书和主机名。不要把“不验证证书”的 TrustManager 用到生产环境。

### 4. TLS注意事项

- TLS Handler 必须位于协议编解码器之前；
- 对握手设置超时；
- 监控握手失败率；
- 禁用过时协议和弱密码套件；
- 证书更新需要演练；
- 双向 TLS 要管理客户端证书；
- HTTP/2 场景还涉及 ALPN；
- 高并发握手会消耗 CPU，需要容量规划。

---

三周攻坚的最后一天，程焕之在周会上抛出最后一个问题："鹊桥现在跑的是 JDK NIO，谁去看看换成 Epoll 原生传输，压测数字能好看多少？"祁霖领了任务，换了依赖、改了一行 `NioEventLoopGroup` 为 `EpollEventLoopGroup`，在压测环境跑了一轮，P99 从 68ms 降到 52ms。他兴冲冲地贴出结果，程焕之却泼了半盆冷水："52 和 68 的差距里，有多少是 Epoll 的功劳，有多少是那天机房负载刚好低？先想清楚数字是哪来的。"

于是祁霖老老实实做了三轮交叉压测，固定变量、保留 NIO 回退方案，最后把结论连同数据一起写进了文档。

## 二十、原生传输：Epoll、KQueue与io_uring

Netty 除了跨平台 NIO，还提供平台相关传输。

### 1. Epoll

适用于 Linux，能够使用 Linux epoll 相关能力。

### 2. KQueue

适用于 macOS、FreeBSD 等 BSD 系统。

### 3. io_uring

适用于支持 io_uring 的 Linux 环境，提供更现代的异步 I/O 接口。具体支持情况应以当前 Netty 版本和运行环境为准。

### 4. 是否一定比NIO快

不一定。

真实性能取决于：

- 消息大小；
- 连接数；
- 读写比例；
- 系统调用；
- 内存分配；
- TLS；
- 业务耗时；
- 操作系统和内核；
- JVM；
- 网卡与网络；
- 参数配置。

正确做法是：

1. 1. 先用 NIO 建立可靠基线；
2. 2. 在目标生产环境压测；
3. 3. 再决定是否采用原生传输；
4. 4. 保留回退方案；
5. 5. 监控原生库加载失败。

---

## 二十一、使用EmbeddedChannel测试Handler

鹊桥的自定义协议解码器稳定跑了一个多月，这天祁霖要给协议加一个可选的压缩标志位。改动本身只有十几行，他改完本机跑了一下，看起来没问题，正准备提测，程焕之走了过来。

"改编码器之前先问你一句：这个改动怎么证明它不破坏现有协议？"程焕之看着他，"上线之后客户端解析失败，那可是 50 万条连接同时受影响。网络代码更应该做单元测试，但很多人不知道怎么测——总不能为了跑个测试真的去监听端口吧？"

"其实不用。"程焕之在白板上写下 `EmbeddedChannel` 这个名字，"Netty 提供了 EmbeddedChannel，可以在不启动真实端口、不依赖真实 I/O 的情况下测试整条 Pipeline。你把事件写进去，把结果读出来，编码解码都能验证。"

网络代码也应该做单元测试。`EmbeddedChannel`可以在不启动真实端口的情况下测试 Pipeline。

### 1. 测试编码器

```
import io.netty.buffer.ByteBuf;import io.netty.channel.embedded.EmbeddedChannel;import org.junit.jupiter.api.Test;import static org.junit.jupiter.api.Assertions.assertEquals;import static org.junit.jupiter.api.Assertions.assertTrue;class ProtocolMessageEncoderTest {    @Test    void shouldEncodeMessage() {        EmbeddedChannel channel =            new EmbeddedChannel(                new ProtocolMessageEncoder()            );        ProtocolMessage message =            new ProtocolMessage(                (byte) 1,                (byte) 2,                1001L,                new byte[]{10, 20, 30}            );        assertTrue(channel.writeOutbound(message));        ByteBuf buf = channel.readOutbound();        try {            assertEquals(                ProtocolMessageEncoder.MAGIC,                buf.readInt()            );            assertEquals(1, buf.readByte());            assertEquals(2, buf.readByte());            assertEquals(1001L, buf.readLong());            assertEquals(3, buf.readInt());            assertEquals(10, buf.readByte());            assertEquals(20, buf.readByte());            assertEquals(30, buf.readByte());        } finally {            buf.release();            channel.finishAndReleaseAll();        }    }}
```
### 2. 测试半包

祁霖照着写完编码器测试，正得意，程焕之又补了一句："编码器只是入门。真正容易出事的是解码器——你前面被粘包拆包折腾了那么久，测试也得覆盖那些场景。往 EmbeddedChannel 里分几次写入不完整的字节，看它是不是忍住不解码。"

于是祁霖把当初踩过的每一个坑，都变成了一条测试用例。

解码器测试必须覆盖：

- 完整包；
- 只到达部分头部；
- 头部完整、消息体不完整；
- 两个包粘在一起；
- 非法魔数；
- 负数长度；
- 超大消息；
- 空消息体；
- 多次连续解码。

这是协议代码最重要的一组测试。

写完这组测试，祁霖回头看了一眼：当初那些让他排查到半夜的"玄学问题"，现在都变成了一分钟能跑完的断言。他忽然理解了程焕之常说的那句话——先想清楚这条消息在哪条线程上，再想清楚它长什么样。

---

## 二十二、性能优化的正确顺序

大促前的压测周到了。运营定下周六晚上有全场限时活动，预计在线连接冲上 50 万，推送延迟要求 P99 < 100ms。白芷把压测环境搭了起来，祁霖看着压测报告里 P99 一百三十多毫秒的数字，第一反应是："把 worker 线程数从 16 调到 32 试试？"

程焕之正好路过，把他的手从键盘上按住了。

"先别动手。"他说，"性能调优最忌讳的就是拍脑袋改参数。你连瓶颈在哪都不知道，调线程数跟掷骰子没区别。先测量，再动手——没有数据的优化，都是在给系统埋雷。"

他让祁霖先把目标和压测环境讲清楚，然后一样一样过：目标是什么？压测环境像不像生产？阻塞和泄漏排除了没有？都确认了，才轮到调参数。

性能调优不应从“调线程数”开始。

推荐顺序：

### 第一步：定义目标

明确：

- 并发连接数；
- 每秒消息数；
- 平均消息大小；
- P50、P95、P99 延迟；
- CPU 与内存上限；
- 可接受丢包率；
- 连接建立速率；
- TLS 比例；
- 业务处理耗时。

### 第二步：建立可复现压测

压测环境应尽量接近生产：

- 相同 JDK；
- 相同内核；
- 相同容器限制；
- 相同网卡；
- 相同 TLS；
- 相同消息分布；
- 相同连接生命周期。

### 第三步：先找阻塞和泄漏

重点排查：

- EventLoop 阻塞；
- ByteBuf 泄漏；
- 无限队列；
- 慢消费者；
- 频繁创建线程；
- 频繁分配大对象；
- 小包过多；
- 日志过量；
- 锁竞争；
- GC 停顿；
- 外部依赖超时。

### 第四步：再调参数

常见参数：

```
.option(ChannelOption.SO_BACKLOG, 1024).childOption(ChannelOption.TCP_NODELAY, true).childOption(ChannelOption.SO_KEEPALIVE, true).childOption(ChannelOption.ALLOCATOR, PooledByteBufAllocator.DEFAULT).childOption(    ChannelOption.WRITE_BUFFER_WATER_MARK,    new WriteBufferWaterMark(32 * 1024, 64 * 1024))
```
参数没有万能值，必须通过目标负载压测。

### 第五步：优化协议与业务

照着顺序走完，祁霖发现真正的瓶颈不在 Netty 参数上，而是推送业务里有一处对同一个大对象做了三次序列化。砍掉重复序列化之后，P99 直接掉进了 100ms 以内。程焕之在评审会上总结："参数调优是最后一公里，不是第一步。"

通常最有效的优化是：

- 减少无用字段；
- 合并小消息；
- 避免重复序列化；
- 减少内存复制；
- 缓存不变结果；
- 限制大消息；
- 批量处理；
- 减少同步等待；
- 降低日志量；
- 优化数据库和下游调用。

---

## 二十三、可观测性与故障排查

压测过了，白芷却提了个新要求："压测只能证明我们测过的场景没问题。上了生产，出了问题你得能在五分钟内告诉我瓶颈在哪——这靠的是监控，不是运气。"

她给鹊桥拉起了一整套可观测性体系：连接指标、流量指标、延迟指标、资源指标，全部接进大盘，再配上分级告警。祁霖一开始嫌她指标定得太细，直到那次深夜告警。

那是个周三凌晨一点，值班群弹出告警：单节点 P99 推送延迟冲到 400ms。祁霖被电话叫醒，打开大盘，先看连接指标——连接数平稳，排除新连接冲击；再看流量指标——入站消息数正常，但出站字节数翻了三倍；顺着查下去，是上游一个业务方发了大量重复推送，把写缓冲区打了满。白芷十分钟内在群里给出定位，加上临时限流，十几分钟恢复。事后复盘会上，祁霖感慨："要是没有这些指标，今晚就是抓瞎到天亮。"

生产 Netty 服务至少应监控：

### 1. 连接指标

- 当前连接数；
- 新建连接速率；
- 断开连接速率；
- 连接失败率；
- TLS 握手成功率；
- 各断开原因；
- 空闲连接数；
- 每个节点连接分布。

### 2. 流量指标

- 入站字节数；
- 出站字节数；
- 入站消息数；
- 出站消息数；
- 消息大小分布；
- 丢弃消息数；
- 协议错误数；
- 解码失败数。

### 3. 延迟指标

- 消息处理延迟；
- 排队时间；
- EventLoop 任务延迟；
- 外部依赖延迟；
- 写完成延迟；
- 心跳往返时间。

### 4. 资源指标

- CPU；
- 堆内存；
- 直接内存；
- GC；
- 线程数；
- 文件描述符；
- 写缓冲区积压；
- 业务线程池队列；
- 容器限额；
- 网络重传。

### 5. 日志原则

复盘会后，白芷顺手把日志规范也定了下来。她说指标回答"哪里不对"，日志回答"具体是哪条消息、哪个连接出了问题"——但没有日志规范，日志再多也救不了人。

日志中应包含：

- Channel ID；
- 远端地址；
- 用户或设备标识；
- requestId；
- 消息类型；
- 错误码；
- 关键耗时；
- 断开原因。

但不要在高频链路中打印完整消息体，也不要记录密码、Token、身份证号等敏感信息。

---

## 二十四、优雅关闭

事故发生在一次例行发版。运维按旧流程直接重启了容器，JVM 一秒内被杀掉，鹊桥 A 集群的十万个在线连接瞬间断开。更糟的是客户端的自动重连逻辑没有退避，几十万条重连请求在三十秒内砸向存活节点，重连风暴把整条接入链路拖得摇摇欲坠，不少用户看到"对战连接失败"的红条。

第二天复盘会上，白芷把断连曲线投在屏幕上：一个干净的悬崖，然后是锯齿一样的重连洪峰。"这不是运维的问题，"她说，"是我们根本没有实现优雅关闭，服务被杀的时候只能裸死。"

程焕之点头："记住，连接是资源，不是免费午餐。你关闭服务的方式，决定了客户端要付出多大的代价重建这些资源。进程退出之前，必须把在途的消息送完、把下线消息通知出去、把资源一层层还回去。"

直接结束 JVM 可能导致：

- 正在处理的消息中断；
- 待写数据丢失；
- 连接异常断开；
- 线程池未释放；
- 注册中心状态未清理。

推荐顺序：

1. 1. 停止接收新连接；
2. 2. 通知客户端服务即将下线；
3. 3. 停止接收新业务请求；
4. 4. 等待在途请求完成；
5. 5. 关闭子 Channel；
6. 6. 关闭 Server Channel；
7. 7. 关闭业务线程池；
8. 8.`shutdownGracefully()`关闭 EventLoopGroup；
9. 9. 设置最大等待时间，避免无限卡住。

简单示例：

```
Runtime.getRuntime().addShutdownHook(    new Thread(() -> {        try {            serverChannel.close().sync();            workerGroup.shutdownGracefully().sync();            bossGroup.shutdownGracefully().sync();        } catch (InterruptedException e) {            Thread.currentThread().interrupt();        }    }));
```
真实系统还要与 Kubernetes`preStop`、健康检查、负载均衡摘流和终止宽限期配合。

祁霖照着这套顺序改造了鹊桥的下线流程，并与 K8s 的 preStop 钩子和负载均衡摘流串了起来。下一次发版，断连曲线变成了一条平缓下坡，客户端在收到下线通知后有条不紊地重连到了其他节点。那条锯齿状的洪峰曲线，被白芷贴在了团队文化墙上，标题是："连接是资源，不是免费午餐。"

---

## 二十五、常见错误清单

优雅关闭落地之后，程焕之给组里立了个新规矩：每次 code review，必须对照一份清单过一遍。清单的来历很朴素——是他对鹊桥前几个月所有线上问题、code review 里拦下来的问题、还有他自己十年里见过的坑，做的一次总账。

"新人犯的错，几乎都逃不出这十五条，"他把清单贴到团队 wiki 首页，"review 的时候别凭感觉，就一条条对着看。在 EventLoop 里阻塞了吗？ByteBuf 谁释放？队列有没有界？Future 结果看了没有？"

清单还真的立竿见影。第二周白芷提交一个推送补丁，祁霖照着清单一看，发现她在 EventLoop 回调里调了下游接口的同步方法——一条就够把整个节点的推送延迟拖垮。白芷改成投递到业务线程池，顺手在评论里写："清单第 1 条，感谢。"

### 1. 在EventLoop中执行阻塞操作

后果：同 EventLoop 上多个连接一起卡顿。

### 2. 忘记释放ByteBuf

后果：直接内存持续增长，最终 OOM。

### 3. 重复释放

后果：`IllegalReferenceCountException`。

### 4. 把有状态Handler标成@Sharable

后果：数据竞争和连接状态串扰。

### 5. 每个连接创建线程池

后果：线程爆炸和资源泄漏。

### 6. 不处理粘包拆包

后果：消息内容随机错位，压力越大越明显。

### 7. 不限制消息大小

后果：攻击者或异常客户端可发送超大包耗尽内存。

### 8. 无限重连

后果：服务故障时形成重连风暴。

### 9. 无限业务队列

后果：流量高峰时内存爆炸，延迟不断累积。

### 10. 忽略ChannelFuture结果

后果：写入失败、连接失败和绑定失败无法被发现。

### 11. 在EventLoop线程里调用sync

后果：阻塞甚至死锁。

### 12. 将TCP Keepalive等同于业务心跳

后果：无法及时发现应用层假死或协议状态异常。

### 13. 过度使用writeAndFlush

后果：小包与系统调用增多，吞吐下降。

### 14. 生产环境关闭证书验证

后果：失去 TLS 身份验证能力，可能遭受中间人攻击。

### 15. 只看平均延迟

后果：P99 长尾问题被隐藏。

---

## 二十六、一个生产级Netty服务应具备什么

周末活动夜顺利扛过了 50 万在线，公司决定给鹊桥立正式的 1.0 里程碑。上线评审会那天，会议室里坐着架构组、QA 和 SRE 的十几个人，白芷提前把评审表做成了检查单形式。

程焕之没有逐条念，而是把评审表投在屏幕上："这不是走过场。每一项，要么指着我们的代码说'在这里'，要么承认'我们还没有'。生产级的 Netty 服务，从来不是 Bootstrap 配置出来的，是这一整张清单撑起来的。"

评审从上午十点开到下午一点。有几项被当场标了黄：协议模糊测试还没系统化、故障演练只做过断连场景、容量规划还停留在表格推算。这三项被记入了 1.1 的必做项——1.0 评审最终通过，但所有人都清楚，这张清单以后每个季度都要重新过一遍。

至少包括：

- 清晰的协议文档；
- 长度字段与最大帧限制；
- 版本协商；
- 鉴权；
- 心跳；
- 空闲连接清理；
- 重连与退避；
- 请求超时；
- requestId；
- 限流；
- 背压；
- 慢消费者处理；
- 业务线程池隔离；
- TLS；
- 内存泄漏检测；
- 指标、日志和追踪；
- 单元测试与协议模糊测试；
- 压测；
- 优雅停机；
- 灰度发布；
- 容量规划；
- 故障演练；
- 依赖版本和安全更新策略。

---

## 二十七、Netty学习路线

评审会后没几天，组里来了一位从业务中台转过来的工程师小盛，第一个任务是给鹊桥加一种新的消息类型。他看了看 Pipeline 里十几层 Handler，有点发怵，私下问祁霖："这些我是不是得系统学一遍 Netty？从哪儿开始？"

祁霖想起自己半年前连 `ByteBuf.release()` 都写错的样子，把程焕之给他划过的学习路线整理成了一页文档，标题就叫"长连接方向 Netty 学习路线"，发给了小盛。

"别一上来就啃源码，"他在文档开头写，"先会写、再懂数据、再懂并发，然后做工程，最后才是读源码。程老师带我的顺序，就是这条。"

### 第一阶段：会写

掌握：

- ServerBootstrap；
- Bootstrap；
- EventLoopGroup；
- ChannelInitializer；
- ChannelPipeline；
- ChannelHandler；
- Echo 客户端和服务端。

### 第二阶段：懂数据

掌握：

- ByteBuf；
- 引用计数；
- 编码器与解码器；
- 粘包拆包；
- 自定义协议；
- EmbeddedChannel。

### 第三阶段：懂并发

掌握：

- Reactor 模型；
- EventLoop 线程亲和性；
- 阻塞任务隔离；
- Handler 线程安全；
- Future 与异步监听；
- 定时任务。

### 第四阶段：做工程

掌握：

- 心跳；
- 重连；
- TLS；
- WebSocket；
- 限流；
- 背压；
- 优雅关闭；
- 可观测性；
- 压测和性能分析。

### 第五阶段：读源码

推荐阅读顺序：

1. 1. Bootstrap 启动流程；
2. 2. Channel 注册流程；
3. 3. EventLoop 执行循环；
4. 4. Pipeline 事件传播；
5. 5. ByteBuf 分配与回收；
6. 6. 解码器累积缓冲区；
7. 7. 写队列与 flush；
8. 8. NIO 与原生传输实现。

读源码时不要试图一次读完整个项目，而要围绕一个问题追踪调用链。

例如：

> `writeAndFlush()`调用后，消息经过了哪些 Handler，何时进入写缓冲，何时真正交给操作系统？

---

## 二十八、面试高频问题

学习路线发出去的第二周，大学同学群里有人@祁霖：一个老同学下周要面后端岗位，简历上写着"熟悉 Netty"，临时抱佛脚来找他要复习提纲。

祁霖想起自己年初面试时被程焕之面过的那轮：没有背八股的余地，每个问题都能追到鹊桥的真实场景上。于是他把那些高频问题整理成了一份清单发给同学，还在每个问题后面加了一句自己的注解——"这个问题，鹊桥当年是怎么踩的"。

### 1. Netty为什么性能高

可以从这些角度回答：

- 非阻塞 I/O 与多路复用；
- Reactor 事件驱动模型；
- 少量线程管理大量连接；
- EventLoop 线程亲和性；
- 池化 ByteBuf；
- 直接内存；
- 减少内存复制；
- 高效 Pipeline；
- 批量写与异步 Future；
- 平台原生传输。

### 2. EventLoop能管理多个Channel吗

能。一个 EventLoop 通常绑定一个线程，并管理多个 Channel。一个 Channel 通常固定注册到一个 EventLoop。

### 3. 为什么不能阻塞EventLoop

因为 EventLoop 不只服务一个连接。阻塞会让同一个 EventLoop 上的其他 Channel 无法及时处理 I/O 和任务。

### 4. 粘包拆包怎么解决

由应用层协议定义边界，常见方案：

- 固定长度；
- 分隔符；
- 长度字段；
- 自描述协议。

### 5. ByteBuf为什么需要引用计数

为了更及时、可预测地回收或复用底层缓冲区，尤其是池化和直接内存。但它也要求开发者正确管理所有权。

### 6. ChannelPipeline是什么

它是由多个 ChannelHandler 构成的处理链，用于拦截和处理入站事件、出站操作。

### 7. SimpleChannelInboundHandler与ChannelInboundHandlerAdapter的区别

前者会对匹配类型的引用计数消息自动释放；后者通常需要开发者根据是否消费或转发消息自行管理生命周期。

### 8. writeAndFlush是不是同步发送

不是。它返回 ChannelFuture，表示异步操作结果。返回时数据不一定已经写入网络。

### 9. 如何处理慢客户端

监控`isWritable()`和`channelWritabilityChanged()`，配置写缓冲区水位，并采用暂停生产、有界队列、丢弃、降级或断开等策略。

### 10. Handler能否共享

只有无状态或内部状态线程安全的 Handler 才适合共享，并应标记`@Sharable`。

---

## 二十九、从“会用”到“精通”的关键认知

鹊桥 1.0 上线一个月后的项目复盘会，没有讲成绩。程焕之在白板上只写了两个词："会用"，"精通"，中间画了一条长箭头。

"这半年，你们的代码从能跑，变成了能扛 50 万连接。"他说，"但我想讲清楚的是，这条箭头跨过去的标志是什么。不是背下了多少 API，也不是调过多少参数——是四种意识长在了你脑子里。你写每一行网络代码的时候，会不自觉地追问四个问题。"

他一条条往下写：边界、所有权、线程、流量。写完他停了一下："每出一次事故，你们就会发现，根因都能落在这四条里的某一条上。"

学 Netty 最重要的不是背 API，而是建立四种意识。

### 1. 边界意识

TCP 没有消息边界，协议必须自己定义边界。

### 2. 所有权意识

ByteBuf 由谁创建、谁持有、谁转发、谁最终释放，必须明确。

### 3. 线程意识

当前代码运行在哪个线程？是否会阻塞？对象是否会跨线程？状态是否共享？

### 4. 流量意识

发送速度是否超过网络速度？下游是否变慢？队列是否有界？系统如何背压和降级？

只要这四个问题始终清楚，Netty 的大部分“玄学故障”都会变成可分析、可定位的工程问题。

---

## 三十、总结

复盘会的最后，程焕之没有再讲话，而是让每个人用一句话说说自己这半年最大的收获。轮到祁霖，他想了想，说的是程焕之的两句口头禅——先想清楚这条消息在哪条线程上；连接是资源，不是免费午餐。

"半年前我以为是两句老工程师的唠叨，"他说，"现在我知道，第一句说的是并发模型，第二句说的是资源与容量。Netty 的全部，差不多就在这两句里了。"

Netty 的学习可以浓缩成一条完整链路：

```
连接建立   ↓EventLoop接收事件   ↓ChannelPipeline传播   ↓ByteBuf承载数据   ↓Decoder解决边界并生成消息   ↓业务Handler处理   ↓Encoder生成字节   ↓写缓冲区与背压   ↓网络发送
```
入门阶段，先完成 Echo、粘包拆包和自定义协议。

进阶阶段，理解 Pipeline、EventLoop、ByteBuf 和异步 Future。

生产阶段，重点解决阻塞、内存、背压、心跳、重连、TLS、监控、限流和优雅关闭。

真正精通 Netty，不是能写出一个可以连接的服务器，而是能回答：

- 这条消息在哪个线程处理？
- 它的边界如何确定？
- ByteBuf 由谁释放？
- 下游变慢时会发生什么？
- 连接异常时状态如何恢复？
- 服务下线时如何不丢消息？
- 高峰流量下系统如何保护自己？

当这些问题都有明确答案，你就不只是“会用 Netty”，而是在设计一个可靠的高性能网络系统。

---

## 官方参考资料

- Netty 官网：https://netty.io/
- Netty 官方文档：https://netty.io/wiki/
- Netty 4.x 用户指南：https://netty.io/wiki/user-guide-for-4.x.html
- Netty 4.2 API：https://netty.io/4.2/api/
- Netty 4.2 迁移指南：https://netty.io/wiki/netty-4.2-migration-guide.html
- 引用计数对象说明：https://netty.io/wiki/reference-counted-objects.html
- Netty GitHub：https://github.com/netty/netty
