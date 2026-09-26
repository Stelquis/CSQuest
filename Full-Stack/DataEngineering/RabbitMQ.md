# [RabbitMQ 在 Golang 中的使用：基本使用与进阶技巧](https://kbchulan.github.io/ClBlogs/blogs-main/mystore/05-rabbitmq.html)

> 这是一个关于"邮局"的故事——一个电商后台的小团队，和它从"接口里同步发短信把用户等急了"到"消息不丢、负载均衡、死信可查"的完整进化史。你会跟着小邮一起，把 RabbitMQ 的每个工作模式亲手跑一遍。读完之后你会发现：RabbitMQ 本质上只是一个队列，难的不是收发消息，而是让每一条消息都"死得明白、活得可靠"。

---

## 故事的起点：用户等不了那三秒钟

小邮所在团队维护一个电商后台。注册流程里有一段代码：写完数据库，接着同步发验证码短信、发欢迎邮件，最后才返回"注册成功"。

用户等不了那三秒钟。更糟的是，某天邮件服务挂了，整个注册接口跟着超时——**写数据库和发邮件这两件毫不相干的事，被一根调用链捆在了一起**。

技术负责人在白板上画了三个词：

- **解耦**：生产者和消费者不需要直接通信，而是通过中间件间接通信；
- **异步**：生产者发完消息立刻返回，不等待处理结果，并不关心消息何时被处理；
- **削峰填谷**：高峰期消息先存到队列，消费者按自己的速度处理。

而承载这三个词的工具，叫 RabbitMQ——一个 **消息中间件**，本质上就是内存或磁盘中的一个队列，只是为这个队列实现了发布订阅、路由、消息持久化等行为。

它整体走这样一条通信流程，先留个印象，后面逐站拆解：

```
┌──────────┐      ┌─────────────┐      ┌──────────┐      ┌──────────┐
│  生产者   │ ───> │   Exchange  │ ───> │  Queue   │ ───> │  消费者   │
└──────────┘      └─────────────┘      └──────────┘      └──────────┘
   发送消息            路由分发          存储消息          接收处理
```

小邮领到的任务：用 Go 把这套东西跑通，从 Hello World 一直跑到生产级实践。本故事就是他的完整路线图。

---

## 第一站：先把邮局开起来——安装与准备

RabbitMQ 在 Arch 的 pacman 中可以直接安装，其他系统可参考[官方文档](https://www.rabbitmq.com/docs/download)：

```bash
# 安装 RabbitMQ
sudo pacman -S rabbitmq

# 启动 RabbitMQ 服务
sudo systemctl start rabbitmq
sudo systemctl enable rabbitmq

# 启用管理界面插件，方便在浏览器可视化访问
sudo rabbitmq-plugins enable rabbitmq_management
```

此时就可以在浏览器访问 `http://127.0.0.1:15672` 进行管理了，默认账号密码均为 guest。

Go 这边初次使用需要拉取官方客户端包：

```bash
# 初始化
go mod init rabbitmq-demo

# 拉取依赖
go get github.com/rabbitmq/amqp091-go
```

---

## 第二站：第一封信——Hello World

任何一个技术点都跑不过的起步。先把完整的生产者代码放这里，注释里标了每个参数的含义——后面的所有模式说白了都是在这之上做一些简单的修改，因此此部分一定要牢记。

*01-hello-world/producer/producer.go*

```go
package main

import (
	"context"
	"log"
	"time"

	"github.com/rabbitmq/amqp091-go"
)

func main() {
	// 1. 连接到 RabbitMQ
	conn, err := amqp091.Dial("amqp://guest:guest@localhost:5672/")
	if err != nil {
		log.Fatalf("Cann't connect to RabbitMQ: %v", err)
	}
	defer conn.Close()

	// 2. 创建一个通道
	ch, err := conn.Channel()
	if err != nil {
		log.Fatalf("Cann't open a channel: %v", err)
	}
	defer ch.Close()

	// 3. 声明队列
	q, err := ch.QueueDeclare(
		"hello", // 队列名称
		false,   // durable: 队列持久化
		         //   - true: 队列元信息写入磁盘，RabbitMQ重启后队列仍存在
		         //   - false: 队列仅存在于内存，重启后丢失
		         //   - 注意：只是队列定义持久化，消息是否持久化需单独设置
		false,   // autoDelete: 自动删除
		         //   - true: 最后一个消费者断开后自动删除队列，注意这个必须是有消费者连接过才会删除的
		         //   - false: 队列会一直保留，即使没有消费者
		false,   // exclusive: 独占队列
		         //   - true: 只允许当前连接访问，连接断开自动删除
		         //   - false: 允许多个连接访问
		false,   // noWait: 是否等待服务器响应
		         //   - true: 不等待RabbitMQ确认，异步，快速但不保证成功
		         //   - false: 等待RabbitMQ确认队列创建成功，同步可靠，建议使用
		nil,     // arguments: 额外参数
		         //   - x-message-ttl: 队列中消息的过期时间（毫秒）
		         //   - x-max-length: 队列最大消息数量
		         //   - x-dead-letter-exchange: 死信交换机
		         //   - 暂时先保持 nil
	)
	if err != nil {
		log.Fatalf("Cann't declare a queue: %v", err)
	}

	// 4. 准备要发布的消息
	body := "Hello RabbitMQ"
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	// 5. 发布消息到队列
	err = ch.PublishWithContext(
		ctx,
		"",     // exchange: 交换机名称
		        //   - 空字符串"": 使用默认交换机（direct类型），直接路由到队列
		        //   - 指定名称: 使用自定义交换机（fanout/direct/topic等）
		q.Name, // routingKey: 路由键
		        //   - 使用默认交换机时: routingKey就是队列名称
		        //   - 使用fanout交换机时: routingKey会被忽略，建议写 ""
		        //   - 使用direct交换机时: 必须匹配绑定时的key
		        //   - 使用topic交换机时: 支持通配符匹配（*和#）
		false,  // mandatory: 消息路由失败时的处理
		        //   - true: 消息无法路由到队列时，通过 NotifyReturn 返回给生产者
		        //   - false: 消息无法路由时直接丢弃，一般情况下用这个
		        //   - 重要消息建议设为true并监听NotifyReturn
		false,  // immediate: 是否要求立即投递
		        //   - true: 队列没有消费者时退回消息
		        //   - false: 正常投递，必须用这个
		amqp091.Publishing{
			ContentType: "text/plain",
			Body:        []byte(body),
		},
	)
	if err != nil {
		log.Fatalf("Cann't publish a message: %v", err)
	}
	log.Printf(" [x] Sent %s", body)
}
```

对于生产者来说，先声明一个队列，随后调用连接的管道把消息发布到指定的队列中，随后就跟它没有任何关系了。

注意：`PublishWithContext` 的 `immediate` 参数必须设置为 false，RabbitMQ 3.0+ 以上的版本如果设置为 true 会直接报错，也就是没有消费者会强制丢弃此消息。

消费者从对应队列中取出数据：

*01-hello-world/consumer/consumer.go*

```go
package main

import (
	"log"

	"github.com/rabbitmq/amqp091-go"
)

func main() {
	// 1. 连接到 RabbitMQ
	conn, err := amqp091.Dial("amqp://guest:guest@localhost:5672/")
	if err != nil {
		log.Fatalf("Cann't connect to RabbitMQ: %v", err)
	}
	defer conn.Close()

	// 2. 创建一个通道
	ch, err := conn.Channel()
	if err != nil {
		log.Fatalf("Cann't open a channel: %v", err)
	}
	defer ch.Close()

	// 3. 声明队列，队列名要和生产者保持一致，具体含义见生产者注释
	q, err := ch.QueueDeclare("hello", false, false, false, false, nil)
	if err != nil {
		log.Fatalf("Cann't declare a queue: %v", err)
	}

	// 4. 接收消息
	msgs, err := ch.Consume(
		q.Name, // 队列名称
		"",     // consumer: 消费者标签
		        //   - 给这个消费者起的唯一标识符，类似昵称那种
		        //   - 可用于取消订阅（ch.Cancel(tag)）或监控
		        //   - 99%的情况填空字符串""，让RabbitMQ自动生成
		true,   // autoAck: 自动确认机制
		        //   - true: 消息一发送到消费者就删除，快速但不安全
		        //   - false: 需要消费者手动确认后才删除，比较可靠
		        //   - 关键业务建议用false，防止消费者崩溃时消息丢失
		false,  // exclusive: 队列独占模式
		        //   - true: 只允许当前连接的这个消费者访问队列，连接断开队列自动删除
		        //   - false: 允许多个消费者同时消费，更为常用
		false,  // noLocal: 是否接收本连接发布的消息，RabbitMQ不支持此参数，必须为false
		false,  // noWait: 是否等待服务器响应
		        //   - true: 不等待RabbitMQ确认，立即返回，异步，快速但不保证成功
		        //   - false: 等待RabbitMQ确认消费者注册成功，同步，可靠，用这个
		nil,    // args: 额外参数
		        //   - x-priority: 设置消费者优先级
		        //   - 暂时先保持 nil
	)
	if err != nil {
		log.Fatalf("Cann't register a consumer: %v", err)
	}

	// 5. 处理消息
	forever := make(chan struct{})
	go func() {
		for d := range msgs {
			log.Printf("[x] Received a message: %s", d.Body)
		}
	}()

	log.Printf(" [*] Waiting for messages. To exit press CTRL+C")
	<-forever
}
```

整体流程很清晰：生产者和消费者都需要先与 RabbitMQ 建立连接，随后通过管道进行通信，两者通信的中间件就是队列。不管哪一方都应该先声明队列——**声明是幂等的**，两边声明同一个队列即可。

核心函数的参数大多有多种选择，对应不同的特性，暂时只需理解当前例子中设置这个值的含义即可。

补充一个：发布消息时有个 `mandatory` 参数，设置为 true 会把路由失败的消息回送给生产者，可以这样处理回送的消息：

```go
returns := ch.NotifyReturn(make(chan amqp091.Return))
go func() {
    for ret := range returns {
        log.Printf("消息被退回: %s, 原因: %s", ret.Body, ret.ReplyText)
    }
}()
```

跑起来看效果——先注册消费者，再启动生产者：

```
> go run 01-hello-world/consumer/consumer.go
2025/11/05 19:05:07  [*] Waiting for messages. To exit press CTRL+C
2025/11/05 19:05:14 [x] Received a message: Hello RabbitMQ

> go run 01-hello-world/producer/producer.go
2025/11/05 19:05:14  [x] Sent Hello RabbitMQ
```

消费者终端立刻打印了这句话。有了这个基础，剩下的就简单很多了。

---

## 第三站：雇几个快递员——Work Queues 与轮询分发

一个队列可以被多个消费者同时订阅，多个消费者并行处理同一个队列中的消息——那一定需要一种手段来维持消息的分发规则。默认情况下，RabbitMQ 采用 **Round-Robin（轮询）** 分发策略：

- 严格按照消费者注册的顺序，依次分配消息；
- 消息是**提前分配**的，不考虑消费者的实际处理速度。

举个例子：消费者 A、B 先后注册，生产者发送 10 条消息，RabbitMQ 立即分配——A 得到消息 1、3、5、7、9，B 得到消息 2、4、6、8、10。

小邮模拟了一下耗时任务（消息里的每个 `.` 表示睡眠一秒），核心代码：

*02-work-queues/producer/producer.go*

```go
func main() {
	... 建立连接和 channel ...

	q, err := ch.QueueDeclare("task_queue", false, true, false, false, nil)
	if err != nil {
		log.Fatalf("Cann't declare a queue: %v", err)
	}

	// 准备消息内容，此处从命令行参数中获取
	body := bodyFrom(os.Args)
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	err = ch.PublishWithContext(ctx, "", q.Name, false, false, amqp.Publishing{
		ContentType: "text/plain",
		Body:        []byte(body),
	})
	if err != nil {
		log.Fatalf("Cann't publish a message: %v", err)
	}
	log.Printf(" [x] Sent %s", body)
}
```

*02-work-queues/consumer/consumer.go*

```go
func main() {
	... 建立连接和 channel ...

	q, err := ch.QueueDeclare("task_queue", false, true, false, false, nil)
	if err != nil {
		log.Fatalf("Cann't declare a queue: %v", err)
	}

	msgs, err := ch.Consume(q.Name, "", true, false, false, false, nil)
	if err != nil {
		log.Fatalf("Cann't register a consumer: %v", err)
	}

	log.Printf(" [*] 等待任务中。按 CTRL+C 退出")

	for d := range msgs {
		log.Printf(" [x] 收到 %s", d.Body)

		dotCount := bytes.Count(d.Body, []byte("."))
		t := time.Duration(dotCount)
		time.Sleep(t * time.Second)

		log.Printf("Task complete")
	}
}
```

先启动两个消费者，再用生产者快速发送多个消息：

```
# 终端1：启动消费者A
2025/11/05 19:34:16  [x] 收到 Task 1
2025/11/05 19:34:16 Task complete
2025/11/05 19:34:16  [x] 收到 Task 3.....
2025/11/05 19:34:21 Task complete
2025/11/05 19:34:21  [x] 收到 Task 5.....
2025/11/05 19:34:26 Task complete

# 终端2：启动消费者B
2025/11/05 19:34:16  [x] 收到 Task 2.
2025/11/05 19:34:17 Task complete
2025/11/05 19:34:17  [x] 收到 Task 4.
2025/11/05 19:34:18 Task complete
2025/11/05 19:34:18  [x] 收到 Task 6.
2025/11/05 19:34:19 Task complete
```

任务被均匀分给了两个消费者，轮询思想得到体现。但也暴露出一个严重问题：**消费者 B 三秒就干完了活，消费者 A 要十秒——即使 B 空闲了，Task 5 也不会转移给 B**，这就是消息的 **负载不均**。这里埋个伏笔，第五站解决它。

---

## 第四站：广播与叫号——Exchange 的三种模式

假设这么一个场景：一条日志消息需要被多个系统同时接收处理——写文件、发邮件、记录数据库。

按照原来的方式，生产者需要知道所有队列的名称，且要为每个队列调用一次 Publish，新增消费者还得修改生产者代码——显然无法接受。

于是引入 **Exchange（交换机）**。它有多种类型（fanout、direct、topic、headers），从最简单的开始。

### Fanout：发布订阅 / 广播

**架构对比**：

```
Work Queues 模式：
生产者 → 队列 → 消费者

发布订阅模式：
                      ┌→ 队列1 → 消费者1
生产者 → [Exchange]  ──┼→ 队列2 → 消费者2
                      └→ 队列3 → 消费者3
```

*03-publish-subscribe/publisher/publisher.go*

```go
func main() {
	... 建立连接和 channel ...

	// 声明一个 fanout 类型的 exchange
	err = ch.ExchangeDeclare(
		"logs",   // name: Exchange 名称
		"fanout", // type: Exchange 类型
		          //   - fanout: 广播模式，忽略 routing key，复制消息到所有绑定的队列
		          //   - direct: 精确匹配，routing key 必须完全相等
		          //   - topic: 模式匹配，支持通配符 * 和 #
		false,    // durable: Exchange 持久化
		          //   - true: Exchange 定义写入磁盘，RabbitMQ 重启后仍存在
		          //   - false: 仅存在于内存，重启后丢失
		true,     // autoDelete: 自动删除
		          //   - true: 最后一个绑定的队列解绑后，自动删除 Exchange，同样是必须有绑定过才会触发
		          //   - false: Exchange 一直保留
		false,    // internal: 是否为内部使用
		          //   - true: 只能被其他 Exchange 使用，客户端无法直接发布消息
		          //   - false: 客户端可以直接发布消息到 Exchange 上
		false,    // noWait: 是否等待服务器响应
		nil,      // arguments: 额外参数
		          //   - alternate-exchange: 备用 Exchange，消息无法路由时转发到这里
		          //   - 一般保持 nil
	)
	if err != nil {
		log.Fatalf("无法声明 exchange: %v", err)
	}

	// 准备消息
	body := bodyFrom(os.Args)
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// 发布消息到 exchange
	err = ch.PublishWithContext(ctx, "logs", "", false, false, amqp.Publishing{
		ContentType: "text/plain",
		Body:        []byte(body),
	})
	if err != nil {
		log.Fatalf("发布消息失败: %v", err)
	}

	log.Printf(" [x] 发送日志: %s", body)
}
```

*03-publish-subscribe/subscribe/subscriber.go*

```go
func main() {
	// 3. 声明 exchange，与生产者保持一致
	err = ch.ExchangeDeclare("logs", "fanout", false, true, false, false, nil)
	if err != nil {
		log.Fatalf("无法声明 exchange: %v", err)
	}

	// 4. 声明一个临时队列，需要设置为独占队列
	q, err := ch.QueueDeclare("", false, true, true, false, nil)
	if err != nil {
		log.Fatalf("无法声明队列: %v", err)
	}

	// 5. 将队列绑定到 exchange
	err = ch.QueueBind(
		q.Name, // queue: 要绑定的队列名称
		"",     // key: Binding Key
		        //   - fanout 类型的 Exchange 会忽略此参数，可以填空字符串
		        //   - direct 类型必须指定，用于精确匹配
		        //   - topic 类型必须指定，支持通配符 * 和 #
		"logs", // exchange: 要绑定到哪个 Exchange
		false,  // noWait: 是否等待服务器响应
		nil,    // arguments: 额外参数
	)
	if err != nil {
		log.Fatalf("无法绑定队列: %v", err)
	}

	// 6. 消费消息
	msgs, err := ch.Consume(q.Name, "", true, false, false, false, nil)
	if err != nil {
		log.Fatalf("无法注册消费者: %v", err)
	}

	log.Printf(" [*] 等待日志消息。按 CTRL+C 退出")
	log.Printf(" [*] 队列名称: %s", q.Name)

	// 7. 处理消息
	for d := range msgs {
		log.Printf(" [x] 收到日志: %s", d.Body)
	}
}
```

流程变了：生产者不再面对队列，而是把消息投递到 Exchange；消费者自己声明一个**临时队列**（RabbitMQ 自动生成随机名称、连接断开自动删除）绑定上去。生产者一投递，Exchange 就按规则转发——fanout 的规则就是**无差别转发给所有订阅队列**，类似广播。

测试结果：两个消费者都收到了同一条消息。总结一下：

- **生产者**：只需要知道 Exchange 名称，发送消息到 Exchange；
- **消费者**：声明临时队列 → 绑定到 Exchange → 消费消息；
- **Exchange**：负责消息复制和分发，生产者和消费者完全解耦。

### Direct：精确路由

direct 模式的本质是多出一个路由键——Exchange 在分发时只会把消息分发给**路由键完全匹配**的队列。代码区分不大：

*04-routing/emit_log_direct/main.go*

```go
func main() {
	// 3. 声明一个 direct 类型的 exchange
	err = ch.ExchangeDeclare("logs_direct", "direct", false, true, false, false, nil)
	if err != nil {
		log.Fatalf("无法声明 exchange: %v", err)
	}

	// 4. 从命令行获取日志级别和消息
	// 用法: go run main.go error "数据库连接失败"
	severity := severityFrom(os.Args)
	body := bodyFrom(os.Args)

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// 5. 发布消息
	err = ch.PublishWithContext(ctx, "logs_direct", severity, false, false, amqp.Publishing{
		ContentType: "text/plain",
		Body:        []byte(body),
	})
	if err != nil {
		log.Fatalf("发布消息失败: %v", err)
	}

	log.Printf(" [x] 发送 [%s] 日志: %s", severity, body)
}
```

消费者按需订阅级别：

*04-routing/receive_logs_direct/main.go*

```go
func main() {
	// 3. 声明 exchange，与发布者保持一致
	err = ch.ExchangeDeclare("logs_direct", "direct", false, true, false, false, nil)
	if err != nil {
		log.Fatalf("无法声明 exchange: %v", err)
	}

	// 4. 声明临时队列
	q, err := ch.QueueDeclare("", false, true, true, false, nil)
	if err != nil {
		log.Fatalf("无法声明队列: %v", err)
	}

	// 5. 从命令行获取要订阅的日志级别
	// 用法: go run main.go error warning
	if len(os.Args) < 2 {
		log.Printf("用法: %s [info] [warning] [error]", os.Args[0])
		os.Exit(0)
	}

	// 6. 为每个日志级别绑定队列
	for _, severity := range os.Args[1:] {
		log.Printf(" [*] 绑定队列到 routing key: %s", severity)
		err = ch.QueueBind(q.Name, severity, "logs_direct", false, nil)
		if err != nil {
			log.Fatalf("无法绑定队列: %v", err)
		}
	}

	// 7. 消费消息
	msgs, err := ch.Consume(q.Name, "", true, false, false, false, nil)
	if err != nil {
		log.Fatalf("无法注册消费者: %v", err)
	}

	// 8. 处理消息
	for d := range msgs {
		log.Printf(" [x] 收到 [%s] 日志: %s", d.RoutingKey, d.Body)
	}
}
```

与广播的区别就是 Exchange 多了一层过滤条件。测试效果：

```
# 终端1（订阅 warning 和 error）
2025/11/05 20:58:51  [x] 收到 [error] 日志: test1

# 终端2（订阅 info）
2025/11/05 20:58:45  [x] 收到 [info] 日志: test1
```

### Topic：通配符路由

路由模式的 routing key 必须和 binding key 一模一样才会分发。但很多时候我们想要"一类的消息"，比如接收 `app` 开头的所有消息——这就是 **通配符匹配**。规则非常简单：

- 必须是用 `.` 分隔的单词，如 `device.bedroom.room`；
- `*` 匹配**一个**单词，如 `device.*` 表示首个单词为 device，第二个单词为任意；
- `#` 匹配**多个**单词，如 `device.#` 表示首个单词为 device，后面所有单词为任意。

很容易看出：如果不用通配符，**主题模式会退化为路由模式**。所以代码改变很小，只需修改声明 Exchange 的类型：

```go
// 只需要修改声明 Exchange 的类型即可
err = ch.ExchangeDeclare("logs_topic", "topic", false, true, false, false, nil)
```

消费者部分不做任何修改，只改动处理命令行参数的逻辑。测试：

```
# 终端1（订阅 kern.*）
2025/11/05 21:14:00  [x] 收到 [kern.world]: Hello World!

# 终端2（订阅 #.error）
2025/11/05 21:13:42  [x] 收到 [s.error]: Hello World!
```

至此基础消息模型看完了。接下来是一些高级特性，尽可能只展示与先前不同的地方，保持最大限度的增量学习。

---

## 第五站：签收制度——消息确认（Ack）

把目光放到 消息队列 → 消费者 这一步。发送的过程本质上是 TCP 连接，**如果发送的过程失败或者消费者崩溃，这条消息是不是就彻底丢了**？

先了解 RabbitMQ 中消息的三种状态：

| 状态 | 含义 | 管理界面表现 |
| ---- | ---- | ---- |
| Ready | 消息在队列中等待被消费，尚未分配给任何消费者 | 显示为 "Ready" |
| Unacked | 已发送给消费者，但消费者还没有确认；消息已离开队列，还在 RabbitMQ 的内存中 | 显示为 "Unacked" |
| Acked | 消费者调用了确认方法，消息从内存中彻底删除 | 不再显示 |

回看前面 `Consume` 的 `autoAck` 设为 true 的含义就很清楚了：**消息发送给消费者后立刻标记为 Acked**，不管有没有被正常消费。这种行为在订单一类的场景下完全无法接受——我们需要 **消息确认机制**。

生产者基本没变化，关键是消费者：把 `autoAck` 设为 false，处理完消息后手动确认：

*06-message-ack/consumer/consumer.go*

```go
func main() {
	q, err := ch.QueueDeclare("task_queue_ack", false, true, false, false, nil)
	if err != nil {
		log.Fatalf("Cann't declare a queue: %v", err)
	}

	// autoAck 设置为 false
	msgs, err := ch.Consume(q.Name, "", false, false, false, false, nil)
	if err != nil {
		log.Fatalf("Cann't register a consumer: %v", err)
	}

	for d := range msgs {
		log.Printf("Received a message: %s", d.Body)

		dotCount := bytes.Count(d.Body, []byte("."))
		t := time.Duration(dotCount)
		time.Sleep(t * time.Second)

		log.Printf(" [✓] 任务完成")

		// 手动确认消息
		// false 表示只确认当前消息
		// true 表示确认当前及之前所有未确认的消息
		d.Ack(false)
	}
}
```

测试：启动两个消费者，发一条耗时 5 秒的消息，处理中途立刻 Ctrl+C 干掉它——你会发现原本没分配到这条消息的另一个消费者拿到了它并处理了。消息没丢。

确认的方式有三种：

```go
d.Ack(false) // multiple: 传入 false 表示只确认当前消息，传入 true 表示确认当前及之前所有未确认的消息(指的是 unacked 这个表)

d.Nack(
	false, // multiple: false 只拒绝当前，true 拒绝当前及之前所有
	true,  // requeue: true 重新入队，false 丢弃
)

d.Reject(true) // requeue: true=重新入队, false=丢弃
```

两个值得注意的点：

- Ack 操作的本质就是为消息增加一个标记，RabbitMQ 只会移除被标记的消息；
- **只有消费者崩溃，消息才会重新变成 Ready 状态**，其余情况想让它重新入队需要手动 Nack/Reject。

---

## 第六站：誊写备份——持久化

前面所有操作都是基于内存的队列和交换机。RabbitMQ 本质是一个内存中的队列进程，一旦进程崩溃或重启，操作系统会回收内存资源——先前设置的队列和未消费的消息就全没了。如果有还没落盘的充值日志，后果相当严重。因此持久化机制必须引入。

一共有三个实体需要考虑：交换机、消息队列、消息。使用上只需修改几个参数：

- **消息队列、交换机**：声明时把 `durable` 设置为 true；
- **消息**：发布时设置 `DeliveryMode: amqp091.Persistent`。

*07-duration/producer/producer.go*

```go
func main() {
	// 持久化声明为 true
	q, err := ch.QueueDeclare("task_queue_durable", true, false, false, false, nil)
	if err != nil {
		log.Fatalf("Cann't declare a queue: %v", err)
	}

	body := bodyFrom(os.Args)
	ctx, cancel := context.WithTimeout(context.Background(), time.Second*5)
	defer cancel()

	err = ch.PublishWithContext(ctx, "", q.Name, false, false, amqp091.Publishing{
		DeliveryMode: amqp091.Persistent, // 声明为持久化
		ContentType:  "text/plain",
		Body:         []byte(body),
	})
	if err != nil {
		log.Fatalf("Cann't publish a message: %v", err)
	}
	log.Printf(" [x] Sent %s", body)
}
```

消费者不需要修改，声明队列时同样把 `durable` 设为 true 即可。测试：先生产两条消息，在控制面板看到两条 Ready，然后 `sudo systemctl restart rabbitmq`——重启后消息依旧存在，可以被正常消费。

### 持久化的原理

持久化涉及三个层面，相互独立但需要配合使用：

- **队列持久化**（durable: true）：队列的**元数据**（名称、配置参数等）写入 RabbitMQ 的元数据存储（默认在 `/var/lib/rabbitmq/mnesia` 目录下的 Mnesia 数据库）。重启后恢复队列结构，但队列中的消息需要单独持久化；
- **消息持久化**（DeliveryMode: Persistent）：消息体写入磁盘上的消息存储文件。RabbitMQ 使用**写入缓冲区**机制——消息先写入内存缓冲区，定期批量刷盘，因此极端情况下可能丢失少量消息；
- **交换机持久化**（durable: true）：与队列持久化类似。

整体流程：

```
生产者发送消息
    ↓
RabbitMQ 接收消息
    ↓
写入内存缓冲区 ← (此时返回确认给生产者)
    ↓
定期批量刷盘 ← (异步写入磁盘)
    ↓
持久化完成
```

显而易见的代价：

- 吞吐量一定会下降，因为多了磁盘 I/O 操作；
- 极端情况下会丢消息——默认每 25ms 或 4096 条消息才写入一次，这就是个窗口，窗口期间崩溃，窗口内的数据就会丢失。

是否选择持久化，需要在**性能和可靠性之间权衡**，根据业务来选择。

---

## 第七站：能者多劳——Qos 公平分发

还记得第三站埋的伏笔吗？默认轮询按注册顺序依次分发，不管消费者忙不忙。我们更期待的是：**RabbitMQ 优先把消息分发给空闲的消费者**。

只需多设置一个参数：

```go
ch.Qos(
    1,     // prefetchCount: 每次只预取1条消息
    0,     // prefetchSize: 0 表示不限制大小
    false, // global: false 只应用于当前 channel
)
```

Qos 的含义是：消费者最多可以占有多少个未 ack 的消息。比如这里设置最多预取 1 个未 ack 数据，RabbitMQ 就会给每个消费者分配一个 Ready 消息、消费完再给下一个，而不会按顺序轮询硬塞——公平分发就实现了。

*08-prefetch/consumer/consumer.go*

```go
func main() {
	q, err := ch.QueueDeclare("task_queue_fair", false, true, false, false, nil)
	if err != nil {
		log.Fatalf("Cann't declare a queue: %v", err)
	}

	// 设置 Qos
	err = ch.Qos(
		1,     // prefetchCount: 每次只预取1条消息
		0,     // prefetchSize: 0 表示不限制大小
		false, // global: false 表示只应用于当前 channel
	)
	if err != nil {
		log.Fatalf("Cann't set Qos: %v", err)
	}

	// 注意，此时必须为手动 ack
	msgs, err := ch.Consume(q.Name, "", false, false, false, false, nil)
	if err != nil {
		log.Fatalf("Cann't register a consumer: %v", err)
	}

	log.Printf(" [*] 等待任务(Qos=1, 公平分发)。按 CTRL+C 退出")

	for d := range msgs {
		log.Printf(" [x] 收到: %s", d.Body)

		// 模拟耗时任务
		dotCount := bytes.Count(d.Body, []byte("."))
		time.Sleep(time.Duration(dotCount) * time.Second)

		log.Printf(" [✓] 完成")
		d.Ack(false)
	}
}
```

测试结果不再是消费者 1 被硬派 1、3、5，而是按消费情况具体分配了。

注意代码注释里那句话：**采用 Qos 的情况下必须手动 Ack**。想象一下如果自动 Ack——消息一发出去立刻确认，RabbitMQ 认为你已经空闲，马上再发下一条，又退回轮询分发了。

一个小建议：任务耗时差距较大时 `prefetchCount` 设为 1 最公平；任务耗时接近时建议设为 10~50。

顺带一提：用 RabbitMQ 实现 RPC 纯属"闲的"——性能等各方面都被 gRPC 爆了，有兴趣可以看原文附的 [RPC 例子](https://github.com/KBchulan/ClBlogs-Src/tree/main/blogs-main/mystore/04-rabbitmq/09-rpc/server/server.go)。

---

## 第八站：过期与善后——TTL 与死信队列

### TTL：消息的保质期

和 Redis 里一样是老熟人。一条消息发到队列里一直没人消费，就会一直占着内存。RabbitMQ 允许设置消息的 TTL（单位为**毫秒**），到期自动删除。

设置包含两种情况：

**队列 TTL**——通过声明参数设置：

```go
args := amqp.Table{
	"x-expires":     int32(30000), // 队列30秒不用就删除
	"x-message-ttl": int32(10000), // 队列中消息10秒过期
}
ch.QueueDeclare("queue_ttl", false, false, false, false, args)
```

注意：对队列消息的 TTL 行为是超时后被 RabbitMQ 保护不消费，**并不是立即删除**，而是由 RabbitMQ 主动扫描删除，看上去就像立即删除了一样。

**消息 TTL**——发布时单独设置：

```go
ch.PublishWithContext(ctx, "", q.Name, false, false,
	amqp.Publishing{
		Expiration: "5000", // 5秒过期（字符串）
		Body:       []byte("message"),
	},
)
```

消息级 TTL 有个坑：空闲时间到达后只是**标记为不可用**，要等消费到队头时发现不可用才立即删除——存在**队头阻塞**问题。

### 死信队列：给消息一个善后的地方

死信是无法被正常消费的消息，会被发送到特殊的死信交换机（DLX）进行处理。死信的来源主要有三个：

- 消息被拒绝（reject/nack）且不重新入队；
- 消息过期（TTL 到期）；
- 队列达到最大长度：

```go
args := amqp091.Table{
    "x-max-length": 10,  // 队列最多10条消息
}
// 第11条消息进来 → 最老的消息被挤出 → 变成死信
```

传统模式下这三种情况消息会被直接丢弃；配置了死信参数（DLX）后，消息会投递到死信交换机并分发到死信队列，可以起消费者专门消费——死信一般带有死信原因等信息，可以落盘日志并排查。

看一个超时导致死信的例子：

*11-dlx/producer/producer.go*

```go
func main() {
	// 3. 声明死信交换机
	err = ch.ExchangeDeclare("dlx_exchange", "direct", false, true, false, false, nil)
	if err != nil {
		log.Fatalf("无法声明死信交换机: %v", err)
	}

	// 4. 声明死信队列
	dlq, err := ch.QueueDeclare("dead_letter_queue", false, true, false, false, nil)
	if err != nil {
		log.Fatalf("无法声明死信队列: %v", err)
	}

	// 5. 绑定死信队列到死信交换机
	err = ch.QueueBind(dlq.Name, "dead", "dlx_exchange", false, nil)
	if err != nil {
		log.Fatalf("无法绑定死信队列: %v", err)
	}

	// 6. 声明业务队列（配置 DLX）
	args := amqp.Table{
		"x-message-ttl":             int32(10000),   // 10秒过期
		"x-dead-letter-exchange":    "dlx_exchange", // 死信交换机
		"x-dead-letter-routing-key": "dead",         // 死信路由键
	}

	q, err := ch.QueueDeclare("business_queue", false, true, false, false, args)
	if err != nil {
		log.Fatalf("无法声明业务队列: %v", err)
	}

	body := bodyFrom(os.Args)
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	// 8. 发布消息到业务队列
	err = ch.PublishWithContext(ctx, "", q.Name, false, false, amqp.Publishing{
		ContentType: "text/plain",
		Body:        []byte(body),
	})
	if err != nil {
		log.Fatalf("发布失败: %v", err)
	}

	log.Printf(" [x] 发送消息(10秒后过期 → 死信队列): %s", body)
}
```

起一个消费者消费死信队列（把基础消费模板的 Consume 队列名称改为 `dead_letter_queue` 即可），测试：

```
2025/11/06 18:27:10 死信消息: task1
2025/11/06 18:27:10 原因: [map[exchange: queue:business_queue reason:expired routing-keys:[business_queue] ...]]
```

过期消息被正确投递进入死信队列，`reason:expired` 写得明明白白——消息死了，但死得明白。

---

## 第九站：开一家不打烊的邮局——连接管理

到此为止的所有示例代码都有一个共同的问题：**没有处理网络异常和连接断开**。RabbitMQ 重启了咋整？网络波动导致 TCP 连接中断咋办？

我们期望的是：**全局公用一个连接，同时为每个业务创建通道进行处理**。

原因有二：

- 连接可能因意外中断，需要一个能**自动重连**的连接；
- 多个管道之间**并非并发安全**，出于异步的考虑，应该为每个业务创建独立的管道。

下面是一个带自动重连功能的 RabbitMQ 客户端实现：

*12-connection-management/rabbitmq_client.go*

```go
package connection_management

import (
	"log"
	"sync"
	"time"

	amqp "github.com/rabbitmq/amqp091-go"
)

// RabbitMQClient 是一个带自动重连的 RabbitMQ 客户端
type RabbitMQClient struct {
	url             string           // RabbitMQ 连接地址
	conn            *amqp.Connection // 连接对象
	channel         *amqp.Channel    // 通道对象
	isConnected     bool             // 连接状态
	mu              sync.RWMutex     // 读写锁，保护连接和通道
	notifyClose     chan *amqp.Error // 监听连接关闭事件
	notifyChanClose chan *amqp.Error // 监听通道关闭事件
	done            chan bool        // 关闭信号
}

// NewRabbitMQClient 创建一个新的 RabbitMQ 客户端
func NewRabbitMQClient(url string) *RabbitMQClient {
	client := &RabbitMQClient{
		url:  url,
		done: make(chan bool),
	}

	go client.handleReconnect()

	return client
}

// handleReconnect 处理连接和自动重连
func (c *RabbitMQClient) handleReconnect() {
	for {
		c.isConnected = false
		log.Println("Connecting to RabbitMQ")

		// 尝试建立连接
		if err := c.connect(); err != nil {
			log.Printf("Connect to RabbitMQ failed: %v, Wait 5 seconds to retry", err)

			select {
			case <-c.done:
				return
			case <-time.After(5 * time.Second):
			}
			continue
		}

		c.isConnected = true
		log.Println("RabbitMQ connecte successfully")

		// 等待连接或通道关闭事件
		select {
		case <-c.done:
			return
		case err := <-c.notifyClose:
			log.Printf("Connect to RabbitMQ closed: %v", err)
		case err := <-c.notifyChanClose:
			log.Printf("Channel to RabbitMQ closed: %v", err)
		}
	}
}

// connect 建立连接和通道
func (c *RabbitMQClient) connect() error {
	// 1. 建立连接
	conn, err := amqp.Dial(c.url)
	if err != nil {
		return err
	}

	// 2. 创建通道
	ch, err := conn.Channel()
	if err != nil {
		conn.Close()
		return err
	}

	// 3. 加锁更新连接和通道
	c.mu.Lock()
	c.conn = conn
	c.channel = ch
	c.mu.Unlock()

	// 4. 监听连接关闭事件
	c.notifyClose = make(chan *amqp.Error)
	c.conn.NotifyClose(c.notifyClose)

	// 5. 监听通道关闭事件
	c.notifyChanClose = make(chan *amqp.Error)
	c.channel.NotifyClose(c.notifyChanClose)

	return nil
}

// GetChannel 获取通道
func (c *RabbitMQClient) GetChannel() (*amqp.Channel, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()

	if !c.isConnected {
		return nil, amqp.ErrClosed
	}

	return c.channel, nil
}

// NewChannel 创建一个新的独立通道
func (c *RabbitMQClient) NewChannel() (*amqp.Channel, error) {
	c.mu.RLock()
	defer c.mu.RUnlock()

	if !c.isConnected || c.conn == nil {
		return nil, amqp.ErrClosed
	}

	return c.conn.Channel()
}

// IsConnected 检查连接状态
func (c *RabbitMQClient) IsConnected() bool {
	c.mu.RLock()
	defer c.mu.RUnlock()
	return c.isConnected
}

// Close 关闭客户端
func (c *RabbitMQClient) Close() error {
	// 1. 发送关闭信号，停止重连循环
	close(c.done)

	// 2. 加锁关闭通道和连接
	c.mu.Lock()
	defer c.mu.Unlock()

	if c.channel != nil {
		c.channel.Close()
	}

	if c.conn != nil {
		return c.conn.Close()
	}

	c.isConnected = false
	log.Println("RabbitMQ has been closed")
	return nil
}
```

设计非常直白：后台 goroutine 负责连接 + 重连循环，失败 5 秒后重试；连接建立后监听关闭事件，一断开就重新进入循环；对外用读写锁保护状态，提供获取共享通道和新建独立通道两个入口。

原文留了一个思考题：**如何确保关闭时能消费完剩余的消息呢？**——值得动手试试。

本节完整代码见[仓库示例](https://github.com/KBchulan/ClBlogs-Src/tree/main/blogs-main/mystore/05-rabbitmq)。

---

## 结语：可靠的消息，从来不是白来的

故事讲完了。

小邮把注册接口里那三秒钟拆掉了：数据库写完立刻返回，短信和邮件变成两条消息飞进队列；消费短信的服务崩溃了，消息自动转给另一个消费者；重启过一次 RabbitMQ，队列和消息原地复活；某条消息格式坏了被 Nack，最后安安静静躺在死信队列里等着排查。

回头看这一路，每个特性都在回答同一个问题——"这条消息会不会丢、会不会卡、会不会白给"：

- 自动确认省心但危险，关键业务必须手动 Ack；
- 持久化用吞吐量换可靠性，要不要开看业务；
- 轮询简单但会忙闲不均，Qos + 手动 Ack 才是公平分发；
- TTL 让过期消息有退出机制，死信队列让"死亡"可以被解释；
- 一个连接多个通道，断了自动重连，才算生产级。

> RabbitMQ 本质上只是一个队列，真正的功课是围绕这个队列的可靠性设计——确认、持久化、分发、过期与善后，缺一环，消息就可能悄悄消失。

邮局的故事告一段落。下一个注册接口里同步发邮件的，会不会还是你？

---

## 参考资料

- 原文：KBchulan 的博客《05 RabbitMQ》：https://kbchulan.github.io/ClBlogs/blogs-main/mystore/05-rabbitmq.html
- RabbitMQ 官方文档：https://www.rabbitmq.com/docs
- RabbitMQ 下载与安装：https://www.rabbitmq.com/docs/download
- amqp091-go 客户端：https://github.com/rabbitmq/amqp091-go
- RabbitMQ Tutorials（官方教程，本文模式的英文原型）：https://www.rabbitmq.com/tutorials
- 本节示例代码：https://github.com/KBchulan/ClBlogs-Src/tree/main/blogs-main/mystore/05-rabbitmq

> 📌 版本提示：本文基于 RabbitMQ 3.x 与 amqp091-go 客户端整理，`immediate` 参数在 RabbitMQ 3.0+ 已不支持 true 值，个别参数行为以官方文档为准。
