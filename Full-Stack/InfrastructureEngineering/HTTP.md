# [HTTP 协议从入门到精通：从一次网页请求，到 HTTP/3 的完整知识体系](https://mp.weixin.qq.com/s/I4LnWoOq2n1GEmz_CghwtA)

> 这是一个关于"沈亦舟"的故事——一个刚入职"星帆科技"的后端工程师。入职第一周，他就撞上了一场诡异的线上故障：接口在同事的浏览器里返回旧数据，在他自己的电脑上却报跨域错误，用 `curl` 一测又一切正常。导师只留下一句话："这些现象背后是同一个东西——HTTP。把它学透，你就能看清整条请求链路。"你会跟着沈亦舟一起，从一次网页请求出发，把报文结构、方法语义、状态码、缓存、Cookie/Session/Token，再到 HTTP/2 与 HTTP/3 的演进一条条打通。读完之后你会发现：HTTP 不只是"会调接口"，而是一套用简洁规则支撑起整个 Web 的设计体系。

---

## 故事的起点：同一个接口，三个人看到三个结果

星帆科技是一家做在线协作文档的初创公司，后端是几个 Spring Boot 服务加一层 Nginx 网关。沈亦舟入职的第三天，就被拉进了一个奇怪的问题：

- 运营同事的浏览器里，文档列表永远比实际少一个新文档，强刷才出现；
- 前端同事本地联调时，控制台一片红色的 CORS 报错，接口"明明存在却调不通"；
- 而沈亦舟在自己的终端里敲 `curl`，返回的却是一份格式完全正常的 JSON。

三个人，三个结果，谁也说不清是谁的问题。排查了一整晚，最后发现真相藏在三个不同的角落：一个是 `Cache-Control` 配错导致的强缓存，一个是网关漏配了预检请求的响应头，还有一个是抓包时才发现的 307 重定向。

第二天复盘会上，导师在白板上画了一条从浏览器到数据库的链路，然后在最上层圈了一块：

> "DNS 负责找到服务器，TCP 或 QUIC 负责建立通信通道，TLS 负责保护数据，而真正定义'客户端要什么、服务器返回什么'的，是 HTTP。你们三个人看到三个结果，是因为你们各自只看到了这条链路的一小段。接下来一个月，你把 HTTP 从头到尾学一遍——用我们自己的系统当教材。"

沈亦舟给自己定了目标：**一个月，把 HTTP 从"会调接口"学到"能看清整条请求链路"。**

下面这个故事，就是他走完的路线图。

---

浏览器地址栏里输入一个网址，按下回车之后，究竟发生了什么？

DNS 负责找到服务器，TCP 或 QUIC 负责建立通信通道，TLS 负责保护数据，而真正定义“客户端要什么、服务器返回什么”的，正是 HTTP。

HTTP 几乎无处不在：浏览网页、调用 REST API、上传文件、播放视频、登录账号、扫码支付、使用小程序……背后都可能有 HTTP 的参与。

很多人会使用 `GET`、`POST`，也认识 `200`、`404`，但一遇到缓存失效、跨域、重复提交、连接阻塞、网关超时，就容易陷入“会用却说不清”的状态。

这篇文章将建立一套完整的 HTTP 知识体系：

- HTTP 到底是什么；

- 一次请求是怎样完成的；

- 请求报文和响应报文如何阅读；

- 方法、状态码、首部字段如何配合；

- Cookie、Session、Token 有什么区别；

- 浏览器缓存为什么既快又难调；

- HTTP/1.1、HTTP/2、HTTP/3 分别解决了什么问题；

- 如何设计规范、可靠、可调试的 HTTP API；

- 如何使用浏览器、`curl` 和抓包工具排查问题。
读完之后，你不仅能“调用 HTTP”，还能够真正理解它的设计思想。

## 一、HTTP 到底是什么
HTTP 的全称是 **Hypertext Transfer Protocol，超文本传输协议**。

可以把它拆成三个关键词：

### 1. 超文本
最早的 Web 页面主要由带有超链接的 HTML 文档组成，所以叫“超文本”。

今天 HTTP 传输的内容早已不限于 HTML，还包括：

- JSON；

- XML；

- 图片；

- 音频；

- 视频；

- 字体；

- 压缩包；

- 二进制文件；

- 流式数据。
因此，HTTP 更准确的理解是：**一种通用的应用层信息交换协议**。

### 2. 传输
HTTP 规定了客户端与服务器之间交换信息的方式，例如：

- 请求资源时应该发送什么；

- 服务器如何描述响应结果；

- 如何表达缓存、认证、压缩、范围请求；

- 如何处理重定向和错误。
HTTP 自己并不直接负责把一个个网络数据包送到对方。

在不同版本中，它依赖的底层传输方式有所不同：

| HTTP 版本 | 常见底层 |
| --- | --- |
| HTTP/1.0 | TCP |
| HTTP/1.1 | TCP |
| HTTP/2 | TCP，通常配合 TLS |
| HTTP/3 | QUIC，而 QUIC 运行在 UDP 之上 |

### 3. 协议
协议就是通信双方共同遵守的规则。

例如，客户端发送：

```
GET /articles/http HTTP/1.1
Host: example.com
Accept: text/html
```
服务器看到之后，就知道：

- 请求方法是 `GET`；

- 目标资源是 `/articles/http`；

- 访问的主机是 `example.com`；

- 客户端希望获得 HTML。
如果没有统一协议，客户端和服务器就无法正确理解彼此。

## 二、HTTP 在网络体系中的位置
我们可以把一次典型的 HTTPS 请求粗略拆成下面几层：

```
应用层：HTTP
安全层：TLS
传输层：TCP 或 QUIC
网络层：IP
链路层：以太网 / Wi-Fi / 蜂窝网络
```
以传统的 HTTPS over TCP 为例：

```
HTTP
↓
TLS
↓
TCP
↓
IP
↓
网卡与物理网络
```
HTTP 关心的是：

请求什么资源？以什么方式请求？返回什么状态？数据是什么类型？

TCP 关心的是：

如何可靠、有序地把字节送到对方？

TLS 关心的是：

如何加密通信、校验完整性，并验证服务器身份？

IP 关心的是：

数据包应该发往哪台主机？

理解这些边界非常重要。比如：

- `404 Not Found` 是 HTTP 层问题；

- TCP 连接超时是传输层问题；

- 证书过期是 TLS 问题；

- 域名无法解析通常是 DNS 问题。
它们都可能表现为“网页打不开”，但排查方向完全不同。

## 三、从输入网址到看到网页，发生了什么
假设在浏览器中访问：

```
https://www.example.com/articles/http?id=100
```
整个过程可以概括为以下步骤。

### 第一步：解析 URL
URL 可以拆成：

```
https://www.example.com:443/articles/http?id=100#chapter-1
│ │ │ │ │
协议 主机名 端口 路径和查询参数 片段
```
更完整地看：

| 部分 | 示例 | 含义 |
| --- | --- | --- |
| Scheme | https | 使用哪种协议方案 |
| Host | www.example.com | 目标主机 |
| Port | 443 | 目标端口，HTTPS 默认端口通常省略 |
| Path | /articles/http | 资源路径 |
| Query | id=100 | 查询参数 |
| Fragment | chapter-1 | 页面内部片段 |

需要注意：

`#chapter-1` 通常只在浏览器本地使用，不会作为 HTTP 请求目标发送给服务器。

### 第二步：DNS 解析
浏览器需要把域名：

```
www.example.com
```
解析成服务器可以路由的 IP 地址。

DNS 可能依次查找：

- 浏览器缓存；

- 操作系统缓存；

- 本地 DNS 解析器；

- 递归 DNS 服务器；

- 根域名服务器；

- 顶级域名服务器；

- 权威 DNS 服务器。

### 第三步：建立连接
如果使用 HTTP/1.1 或 HTTP/2，通常先建立 TCP 连接。

TCP 的经典三次握手是：

```
客户端 -- SYN --> 服务器
客户端 <-- SYN + ACK -- 服务器
客户端 -- ACK --> 服务器
```
如果使用 HTTPS，还需要完成 TLS 握手，以协商密钥并验证证书。

如果使用 HTTP/3，底层是 QUIC。QUIC 把传输能力和 TLS 1.3 安全机制紧密结合，可以减少连接建立过程中的额外往返。

### 第四步：发送 HTTP 请求
浏览器发送请求行、请求头和可选的请求体。

例如：

```
GET /articles/http?id=100 HTTP/1.1
Host: www.example.com
User-Agent: Mozilla/5.0
Accept: text/html
Accept-Encoding: gzip, br
Cookie: session_id=abc123
```

### 第五步：服务器处理请求
请求可能依次经过：

```
浏览器
↓
CDN
↓
负载均衡器
↓
反向代理
↓
网关
↓
应用服务器
↓
缓存 / 数据库 / 其他服务
```
现代网站往往不是浏览器直接连接一台应用服务器，而是由多层基础设施共同完成请求。

### 第六步：服务器返回响应
例如：

```
HTTP/1.1 200 OK
Content-Type: text/html; charset=utf-8
Content-Encoding: br
Cache-Control: max-age=600
Content-Length: 12580

<!doctype html>
<html>
...
</html>
```

### 第七步：浏览器解析和渲染
浏览器解析 HTML 后，还可能继续请求：

- CSS；

- JavaScript；

- 图片；

- 字体；

- 视频；

- API 数据。
因此，一个网页的加载通常不是一次 HTTP 请求，而是几十次甚至数百次请求的组合。

## 四、HTTP 的核心模型：请求与响应
HTTP 最重要的交互模型是：

```
客户端发送请求 → 服务器返回响应
```
客户端不一定是浏览器，也可能是：

- 手机 App；

- 小程序；

- 命令行工具；

- 后端服务；

- IoT 设备；

- 爬虫；

- API 测试工具。
服务器也不一定是最终业务系统，可能是：

- CDN；

- 代理服务器；

- API 网关；

- 缓存节点；

- 反向代理；

- 微服务。

### HTTP 是无状态协议
“无状态”表示：

每一次请求原则上都应当携带服务器处理它所需的信息，协议本身不会自动记住上一次请求的业务状态。

例如，服务器不会仅凭“这是同一台电脑发来的第二个请求”，就天然知道用户已经登录。

为了维持登录状态，应用通常需要借助：

- Cookie；

- Session；

- Token；

- 数据库或分布式缓存。
无状态并不等于“不能保存状态”，而是说：

状态管理不是 HTTP 协议自动完成的，需要应用层显式设计。

## 五、HTTP/1.1 报文结构
HTTP/1.1 使用可读的文本形式表达报文，特别适合学习协议结构。

### 1. 请求报文
一个请求通常由四部分组成：

```
请求行
请求头
空行
请求体（可选）
```
示例：

```
POST /api/users HTTP/1.1
Host: api.example.com
Content-Type: application/json
Content-Length: 38
Authorization: Bearer eyJhbGciOi...

{"name":"Alice","age":20}
```

#### 请求行

```
POST /api/users HTTP/1.1
```
包含：

- 请求方法：`POST`；

- 请求目标：`/api/users`；

- HTTP 版本：`HTTP/1.1`。

#### 请求头
请求头用于描述请求的附加信息：

```
Content-Type: application/json
Authorization: Bearer ...
Accept: application/json
```

#### 空行
请求头结束之后必须有一个空行，用于分隔首部和消息体。

#### 请求体
并非所有请求都有请求体。

常见于：

- `POST`；

- `PUT`；

- `PATCH`。
请求体可以是：

- JSON；

- 表单；

- XML；

- 文件；

- 二进制数据。

### 2. 响应报文
响应通常由四部分组成：

```
状态行
响应头
空行
响应体（可选）
```
示例：

```
HTTP/1.1 201 Created
Content-Type: application/json
Location: /api/users/1001
Content-Length: 39

{"id":1001,"name":"Alice","age":20}
```

#### 状态行

```
HTTP/1.1 201 Created
```
包含：

- HTTP 版本；

- 状态码；

- 原因短语。

#### 响应头
描述返回内容和处理规则，例如：

```
Content-Type: application/json
Cache-Control: no-store
Set-Cookie: session_id=abc123; HttpOnly; Secure
```

#### 响应体
响应体是真正的资源内容，可能是：

- HTML 页面；

- JSON 数据；

- 图片；

- 文件；

- 错误信息。
有些响应没有消息体，例如：

- `204 No Content`；

- 对 `HEAD` 请求的响应；

- 某些重定向或条件请求响应。

## 六、HTTP 方法：不只是 GET 和 POST
HTTP 方法表达客户端希望对目标资源执行的操作。

### 1. GET：获取资源

```
GET /api/users/1001 HTTP/1.1
Host: api.example.com
```
典型用途：

- 获取网页；

- 查询数据；

- 下载资源。
按照语义，`GET` 应当用于读取，不应产生用户可感知的业务副作用。

不推荐这样设计：

```
GET /api/deleteUser?id=1001
```
因为浏览器预加载、搜索引擎抓取、代理重试等行为，都可能意外触发删除。

### 2. POST：提交数据或触发处理

```
POST /api/orders HTTP/1.1
Content-Type: application/json

{"productId":88,"quantity":2}
```
典型用途：

- 创建订单；

- 提交表单；

- 上传数据；

- 触发一项业务操作。

### 3. PUT：整体创建或替换资源

```
PUT /api/users/1001 HTTP/1.1
Content-Type: application/json

{"name":"Alice","age":21}
```
通常表示：

用请求中的完整表示，创建或整体替换指定资源。

### 4. PATCH：部分修改资源

```
PATCH /api/users/1001 HTTP/1.1
Content-Type: application/json

{"age":21}
```
通常表示只修改部分字段。

### 5. DELETE：删除资源

```
DELETE /api/users/1001 HTTP/1.1
```

### 6. HEAD：只获取响应头
`HEAD` 与 `GET` 语义相近，但服务器不返回响应体。

常见用途：

- 检查资源是否存在；

- 获取文件大小；

- 获取缓存信息；

- 检查最后修改时间。

### 7. OPTIONS：查询通信选项
浏览器的 CORS 预检请求经常使用 `OPTIONS`：

```
OPTIONS /api/users HTTP/1.1
Origin: https://www.example.com
Access-Control-Request-Method: POST
```

### 8. CONNECT：建立隧道
常用于通过 HTTP 代理建立 TCP 隧道，例如 HTTPS 代理。

### 9. TRACE：诊断请求链路
用于回显请求，现实部署中常因安全原因被禁用。

## 七、安全方法、幂等方法与可缓存性
这是 HTTP 中最容易混淆的三个概念。

### 1. 安全性
“安全方法”不是指加密安全，而是指：

按照定义，该方法主要用于读取，不应请求服务器改变资源状态。

常见安全方法：

- `GET`；

- `HEAD`；

- `OPTIONS`；

- `TRACE`。
服务器记录访问日志、统计浏览量，并不一定破坏安全方法语义，因为这些属于附带行为，而不是客户端请求的主要目的。

### 2. 幂等性
幂等表示：

同一个请求执行一次或多次，对服务器产生的预期效果应当相同。

常见幂等方法：

- `GET`；

- `HEAD`；

- `PUT`；

- `DELETE`；

- `OPTIONS`；

- `TRACE`。
通常非幂等：

- `POST`；

- `PATCH` 是否幂等取决于具体语义和实现。
例如：

```
PUT /api/users/1001
{"name":"Alice"}
```
重复执行，最终资源仍是同一个结果。

而：

```
POST /api/orders
{"productId":88}
```
重复执行可能创建多个订单。

### 3. 可缓存性
是否能够缓存，不仅取决于方法，还取决于：

- 状态码；

- 响应头；
-认证信息；

- 缓存实现；

- 具体协议规则。
`GET` 和 `HEAD` 最常被缓存。某些 `POST` 响应在满足明确条件时也可能缓存，但实际系统中并不常见。

### 三者对照

| 方法 | 安全 | 幂等 | 常见用途 |
| --- | --- | --- | --- |
| GET | 是 | 是 | 查询资源 |
| HEAD | 是 | 是 | 只取响应头 |
| POST | 否 | 否 | 创建或执行操作 |
| PUT | 否 | 是 | 整体替换 |
| PATCH | 否 | 不一定 | 部分更新 |
| DELETE | 否 | 是 | 删除资源 |
| OPTIONS | 是 | 是 | 查询能力 |
| CONNECT | 否 | 否 | 建立隧道 |

注意：

“DELETE 是幂等的”不等于每次响应必须一样。

第一次删除可能返回 `204`，第二次删除可能返回 `404`，但服务器资源最终都处于“已不存在”的状态，因此仍可符合幂等语义。

## 八、状态码：服务器对请求结果的标准表达
HTTP 状态码由三位数字组成，分为五大类。

### 1xx：信息性响应
表示请求已收到，仍需继续处理。

常见状态码：

- `100 Continue`：客户端可以继续发送请求体；

- `101 Switching Protocols`：切换协议；

- `103 Early Hints`：提前提示客户端加载相关资源。

### 2xx：请求成功

#### 200 OK
请求成功，最常见。

#### 201 Created
资源创建成功，常用于 `POST` 或 `PUT`。

通常可以配合：

```
Location: /api/users/1001
```
告诉客户端新资源的位置。

#### 202 Accepted
请求已经被接受，但尚未处理完成。

适用于：

- 异步任务；

- 消息队列；

- 视频转码；

- 大批量数据处理。

#### 204 No Content
请求成功，但没有响应体。

常用于：

- 删除成功；

- 更新成功但无需返回内容。

#### 206 Partial Content
服务器返回资源的一部分，常见于：

- 断点续传；

- 视频拖动；

- 大文件分块下载。

### 3xx：重定向与缓存验证

#### 301 Moved Permanently
资源永久迁移。

浏览器和搜索引擎可能长期记住这个跳转。

#### 302 Found
临时重定向。历史兼容行为可能导致某些客户端把原请求改成 `GET`。

#### 303 See Other
告诉客户端使用 `GET` 请求另一个地址，常用于提交表单后的跳转。

#### 304 Not Modified
资源未修改，客户端可以继续使用缓存。

它不是“请求失败”，而是缓存验证成功。

#### 307 Temporary Redirect
临时重定向，并要求保留原方法和请求体。

#### 308 Permanent Redirect
永久重定向，并要求保留原方法和请求体。

### 4xx：客户端侧问题

#### 400 Bad Request
请求格式错误或参数不合法。

#### 401 Unauthorized
更准确地说是“未通过身份认证”。

服务器通常会配合 `WWW-Authenticate` 指示认证方案。

#### 403 Forbidden
服务器理解请求，也可能知道用户是谁，但拒绝授权访问。

可以这样区分：

```
401：你是谁？请先认证。
403：我知道你是谁，但你没有权限。
```

#### 404 Not Found
未找到目标资源。

有些系统也会为了隐藏资源存在性，对无权限用户返回 `404`。

#### 405 Method Not Allowed
资源存在，但不支持当前方法。

通常应返回：

```
Allow: GET, HEAD
```

#### 409 Conflict
请求与资源当前状态冲突。

例如：

- 用户名已存在；

- 版本冲突；

- 重复创建；

- 状态机不允许当前操作。

#### 410 Gone
资源曾经存在，但已永久删除。

#### 412 Precondition Failed
请求中的前置条件失败，常用于条件更新和并发控制。

#### 413 Content Too Large
请求体过大。

#### 415 Unsupported Media Type
服务器不支持请求体的媒体类型。

例如接口只接受 JSON，却发送了 XML。

#### 422 Unprocessable Content
请求格式可以理解，但语义校验失败。

例如：

```
{
"email": "not-an-email"
}
```

#### 429 Too Many Requests
请求过于频繁，触发限流。

服务器可返回：

```
Retry-After: 60
```

### 5xx：服务器侧问题

#### 500 Internal Server Error
服务器内部发生未处理错误。

#### 501 Not Implemented
服务器不支持完成请求所需的功能。

#### 502 Bad Gateway
网关或代理从上游服务器收到了无效响应。

常见场景：

```
浏览器 → Nginx → 应用服务
↑
上游异常或断开
```

#### 503 Service Unavailable
服务暂时不可用，可能因为：

- 过载；

- 维护；

- 依赖故障；

- 熔断；

- 服务未就绪。

#### 504 Gateway Timeout
网关等待上游服务器响应超时。

### 状态码设计原则
不要所有结果都返回：

```
HTTP/1.1 200 OK
```
然后在 JSON 中写：

```
{
"code": 500,
"message": "服务器错误"
}
```
业务码可以存在，但不应完全取代 HTTP 状态码。合理使用状态码，可以让：

- 浏览器；

- 代理；

- 网关；

- 监控系统；

- SDK；

- 调试工具
更准确地理解结果。

## 九、最常用的 HTTP 首部字段
HTTP 首部字段本质上是元数据。

### 1. Host

```
Host: www.example.com
```
同一个 IP 地址上可以部署多个网站，服务器需要根据 `Host` 判断客户端访问的是哪一个站点。

在 HTTP/1.1 中，`Host` 对普通请求非常重要。

在 HTTP/2 和 HTTP/3 中，请求目标信息以伪首部形式表达，例如：

```
:method
:scheme
:authority
:path
```

### 2. Content-Type
描述消息体的媒体类型：

```
Content-Type: application/json
```
常见值：

```
text/html; charset=utf-8
application/json
application/xml
application/pdf
image/png
multipart/form-data
application/x-www-form-urlencoded
```

### 3. Accept
客户端告诉服务器自己希望接收什么类型：

```
Accept: application/json
```

### 4. Content-Length
表示消息体长度，单位是字节：

```
Content-Length: 1024
```
不要把字符数直接当成字节数。UTF-8 中文字符通常占多个字节。

### 5. Content-Encoding
描述消息体使用的内容编码：

```
Content-Encoding: gzip
```
常见压缩方式：

- `gzip`；

- `br`；

- `zstd`，是否可用取决于客户端和服务器支持。

### 6. Accept-Encoding
客户端声明支持的内容编码：

```
Accept-Encoding: gzip, br
```

### 7. Authorization
携带认证信息：

```
Authorization: Bearer <token>
```
也可能使用其他认证方案。

### 8. User-Agent
描述客户端信息：

```
User-Agent: Mozilla/5.0 ...
```
它可以用于兼容性分析和日志统计，但不应被视为可靠身份凭据，因为客户端可以伪造。

### 9. Referer
表示当前请求大致从哪个页面发起。

历史拼写是 `Referer`，而不是正确英文拼写 `Referrer`。

### 10. Origin
表示请求来源的协议、主机和端口：

```
Origin: https://www.example.com
```
它在 CORS 和安全校验中非常重要。

### 11. Location
常用于重定向或指出新资源位置：

```
Location: /login
```

### 12. Retry-After
提示客户端何时重试：

```
Retry-After: 120
```
也可以使用 HTTP 日期。

### 13. Vary
告诉缓存：

这个响应会根据哪些请求头产生不同版本。

例如：

```
Vary: Accept-Encoding
```
表示 gzip 版本和未压缩版本不能混为同一个缓存条目。

## 十、请求体的常见格式

### 1. JSON

```
Content-Type: application/json
```

```
{
"name": "Alice",
"age": 20
}
```
适合 API 数据交换。

### 2. URL 编码表单

```
Content-Type: application/x-www-form-urlencoded
```

```
name=Alice&age=20
```
传统 HTML 表单中很常见。

### 3. multipart/form-data
常用于上传文件：

```
Content-Type: multipart/form-data; boundary=----WebKitFormBoundary...
```
消息体中可以同时包含：

- 普通文本字段；

- 一个或多个文件；

- 每个部分自己的首部。

### 4. 纯文本或二进制

```
Content-Type: text/plain
```
或者：

```
Content-Type: application/octet-stream
```

## 十一、Cookie、Session 与 Token
HTTP 本身无状态，但登录系统需要识别连续请求属于哪个用户。

### 1. Cookie
服务器可以在响应中写入 Cookie：

```
Set-Cookie: session_id=abc123; Path=/; HttpOnly; Secure; SameSite=Lax
```
浏览器之后访问符合条件的地址时，会自动携带：

```
Cookie: session_id=abc123
```

### 常见 Cookie 属性

#### Expires 和 Max-Age
控制 Cookie 的有效期。

#### Domain
控制 Cookie 可以发送到哪些域名。

#### Path
控制 Cookie 在哪些路径下发送。

#### Secure
仅通过安全连接发送。

#### HttpOnly
禁止 JavaScript 通过 `document.cookie` 读取，可以降低某些 XSS 攻击窃取 Cookie 的风险。

#### SameSite
控制跨站请求是否携带 Cookie。

常见取值：

- `Strict`；

- `Lax`；

- `None`。
使用 `SameSite=None` 时，现代浏览器通常要求同时设置 `Secure`。

### 2. Session
Session 通常表示服务器端保存的会话数据。

典型流程：

```
用户登录
↓
服务器创建 Session
↓
服务器生成 session_id
↓
session_id 写入 Cookie
↓
浏览器后续自动携带 Cookie
↓
服务器根据 session_id 查找会话
```
Session 数据可以存储在：

- 服务器内存；

- Redis；

- 数据库；

- 分布式缓存。

### 3. Token
Token 是客户端持有并主动携带的凭据，常见形式：

```
Authorization: Bearer <token>
```
Token 可以是：

- 随机字符串；

- JWT；

- OAuth 访问令牌；

- 其他自定义凭据。

### 4. 三者不是同一层概念
经常有人把 Cookie、Session、Token 当作互斥方案，其实不完全正确。

- Cookie 是浏览器保存和发送数据的一种机制；

- Session 是服务器端会话状态的一种管理方式；

- Token 是表示认证或授权信息的一种凭据。
例如：

- Session ID 可以放在 Cookie 中；

- Token 也可以放在 Cookie 中；

- Token 也可以放在 `Authorization` 请求头中。

### 5. JWT 并不自动更安全
JWT 的优点可能包括：

- 自包含；

- 便于跨服务验证；

- 减少中心化会话查询。
但它也带来问题：

- 已签发 Token 不易立即失效；

- 载荷默认只是编码，不是加密；

- Token 过大会增加每次请求开销；

- 密钥轮换和权限撤销更复杂；

- 错误地把敏感信息放入载荷会造成泄露。
选择 Session 还是 Token，应根据架构需求，而不是追逐概念。

## 十二、HTTPS：HTTP 为什么需要 TLS
HTTP 明文传输时，中间节点可能看到或篡改数据。

HTTPS 可以理解为：

```
HTTP over TLS
```
TLS 主要提供三类能力：

### 1. 机密性
通信内容被加密，中间人难以直接读取。

### 2. 完整性
可以检测数据是否被篡改。

### 3. 身份认证
客户端通过数字证书验证连接的服务器是否是目标站点。

### TLS 握手大致做什么
TLS 握手会完成：

- 协商协议版本；

- 协商密码套件；

- 获取服务器证书；

- 验证证书链和域名；

- 建立会话密钥；

- 开始加密通信。

### HTTPS 不代表网站业务绝对安全
HTTPS 能保护传输过程，但不能自动解决：

- SQL 注入；

- 越权访问；

- 弱密码；

- 业务逻辑漏洞；

- XSS；

- CSRF；

- 服务端数据泄露；

- 恶意网站本身的问题。
它是必要基础，但不是全部安全体系。

## 十三、缓存：HTTP 性能优化的核心机制
缓存的价值是：

- 减少网络传输；

- 降低服务器压力；

- 缩短页面加载时间；

- 提高弱网体验；

- 降低带宽成本。
HTTP 缓存常分为两类：

- 1. **新鲜度缓存**：缓存仍然新鲜，直接使用；

- 2. **验证缓存**：缓存可能过期，向服务器确认是否还能使用。
很多前端资料把它们称为“强缓存”和“协商缓存”。

## 十四、Cache-Control 详解

### 1. max-age

```
Cache-Control: max-age=600
```
表示响应生成之后，在 600 秒内可被视为新鲜。

### 2. no-cache

```
Cache-Control: no-cache
```
它不是“不缓存”，而是：

可以存储，但再次使用前通常必须向服务器验证。

这是最常被误解的指令之一。

### 3. no-store

```
Cache-Control: no-store
```
表示不应存储该响应。

适合：

- 敏感数据；

- 一次性数据；

- 不希望落入缓存的响应。

### 4. public

```
Cache-Control: public, max-age=3600
```
表示共享缓存也可以存储。

### 5. private

```
Cache-Control: private, max-age=300
```
表示响应面向单个用户，通常不应被共享缓存存储。

浏览器私有缓存仍可使用。

### 6. s-maxage

```
Cache-Control: s-maxage=3600, max-age=60
```
用于共享缓存，例如 CDN，优先于共享缓存中的 `max-age`。

### 7. must-revalidate

```
Cache-Control: max-age=60, must-revalidate
```
过期后必须成功验证，不能随意继续使用陈旧响应。

### 8. immutable

```
Cache-Control: public, max-age=31536000, immutable
```
表示资源在新鲜期内不会改变。

特别适合带内容哈希的静态资源：

```
app.8f3a2c1.js
style.4d91b7.css
```

## 十五、ETag 与 Last-Modified
当缓存过期时，客户端可以发起条件请求。

### 1. ETag
服务器第一次响应：

```
HTTP/1.1 200 OK
ETag: "v18-a8c923"
Cache-Control: no-cache
```
客户端再次请求：

```
GET /app.js HTTP/1.1
If-None-Match: "v18-a8c923"
```
如果资源未变化，服务器返回：

```
HTTP/1.1 304 Not Modified
```
不需要再次发送完整响应体。

### 2. Last-Modified
服务器响应：

```
Last-Modified: Sun, 19 Jul 2026 08:00:00 GMT
```
客户端再次请求：

```
If-Modified-Since: Sun, 19 Jul 2026 08:00:00 GMT
```
未修改时也可以返回 `304`。

### 3. ETag 与 Last-Modified 的差别
`Last-Modified` 依赖修改时间，精度和语义可能受文件系统或生成方式影响。

`ETag` 可以由服务器根据：

- 内容哈希；

- 版本号；

- 文件元数据；

- 数据库版本
生成，通常更灵活。

### 4. 推荐的静态资源策略
对于内容哈希命名的资源：

```
Cache-Control: public, max-age=31536000, immutable
```
对于 HTML 入口文件：

```
Cache-Control: no-cache
```
这样既可以让带哈希资源长期缓存，又能让 HTML 每次验证，从而及时获得新的资源文件名。

## 十六、缓存链路与 Vary
一次请求可能经过多级缓存：

```
浏览器缓存
↓
系统代理缓存
↓
公司网关
↓
CDN 边缘节点
↓
反向代理缓存
↓
源站
```
如果响应内容会根据请求头变化，必须合理设置 `Vary`。

例如：

```
Vary: Accept-Encoding
```
否则，缓存可能把 gzip 响应错误地返回给不支持 gzip 的客户端。

再如：

```
Vary: Accept-Language
```
表示不同语言版本应分别缓存。

但 `Vary` 取值越多，缓存键越分散，命中率通常越低，因此要谨慎使用。

## 十七、内容协商
同一个资源可以有不同表示形式。

客户端通过请求头表达偏好：

```
Accept: application/json
Accept-Language: zh-CN
Accept-Encoding: br, gzip
```
服务器根据这些信息选择表示，并通过响应头说明结果：

```
Content-Type: application/json
Content-Language: zh-CN
Content-Encoding: br
Vary: Accept, Accept-Language, Accept-Encoding
```
常见协商维度包括：

- 媒体类型；

- 语言；

- 压缩方式；

- 字符编码。
现代 API 中，媒体类型协商最常见。

## 十八、连接管理：短连接、长连接与流水线

### 1. HTTP/1.0 的典型短连接
早期 HTTP 常常每请求一个资源就建立一次 TCP 连接：

```
建立连接 → 请求 HTML → 关闭连接
建立连接 → 请求 CSS → 关闭连接
建立连接 → 请求图片 → 关闭连接
```
连接建立成本较高。

### 2. HTTP/1.1 的持久连接
HTTP/1.1 默认支持持久连接，可以在一个 TCP 连接上连续发送多个请求。

```
建立一次连接
├─ 请求 HTML
├─ 请求 CSS
├─ 请求 JS
└─ 请求图片
```
旧式关闭方式：

```
Connection: close
```

### 3. HTTP/1.1 流水线
理论上，客户端可以不等待前一个响应就连续发送多个请求。

但响应必须按请求顺序返回，容易遇到队头阻塞，而且代理兼容性复杂，所以浏览器长期并未广泛依赖 HTTP/1.1 流水线。

### 4. 浏览器为什么曾经建立多条 TCP 连接
为了并行请求资源，浏览器往往会对同一个站点建立多条连接，以绕开单连接串行限制。

这改善了速度，也带来了：

- 更多握手；

- 更多拥塞控制状态；

- 更高服务器资源消耗；

- 更复杂的连接管理。
HTTP/2 的多路复用正是为解决这些问题而来。

## 十九、HTTP/1.1：成熟但存在结构性限制
HTTP/1.1 的重要改进包括：

- 默认持久连接；

- `Host` 首部；

- 分块传输；

- 更完善的缓存；

- 范围请求；

- 更丰富的内容协商；

- 更明确的方法和状态码体系。

### 分块传输
当服务器无法提前知道响应体长度时，可以使用分块传输编码：

```
Transfer-Encoding: chunked
```
消息体由多个块组成，每个块前面带有块长度。

需要注意：

HTTP/2 和 HTTP/3 使用帧和流来组织数据，不使用 HTTP/1.1 的 `chunked` 传输编码。

### HTTP/1.1 的主要瓶颈

- 首部是文本格式，重复内容较多；

- 单连接上的请求响应处理受顺序影响；

- 为并发而创建多连接会增加成本；

- TCP 层丢包可能阻塞后续字节交付。

## 二十、HTTP/2：二进制分帧与多路复用
HTTP/2 没有改变 HTTP 的核心语义。

你仍然使用：

- `GET`、`POST`；

- 状态码；

- 请求头和响应头；

- URL；

- 缓存；

- Cookie。
它主要改变的是：

HTTP 消息如何在连接上传输。

### 1. 二进制分帧
HTTP/2 把通信拆成二进制帧，例如：

- HEADERS 帧；

- DATA 帧；

- SETTINGS 帧；

- WINDOW_UPDATE 帧；

- RST_STREAM 帧。
二进制分帧比文本拼接更适合高效解析和多路复用。

### 2. 流
每次请求与响应运行在一个逻辑流中，每个流有独立编号。

```
一个 TCP 连接
├─ Stream 1：HTML
├─ Stream 3：CSS
├─ Stream 5：JavaScript
└─ Stream 7：图片
```

### 3. 多路复用
多个流的帧可以交错发送：

```
HTML 数据帧
CSS 数据帧
图片数据帧
HTML 数据帧
JS 数据帧
```
不必等一个完整响应结束，才能开始下一个响应。

### 4. 首部压缩
HTTP/2 使用 HPACK 压缩首部。

因为连续请求中经常重复出现：

```
User-Agent
Cookie
Accept
Host / :authority
```
首部压缩能够减少重复传输。

### 5. 流量控制
HTTP/2 可以分别控制：

- 整个连接的数据窗口；

- 每一个流的数据窗口。
这样可以防止发送方无限制地压垮接收方。

### 6. 优先级
HTTP/2 定义了流优先级机制，但实际部署和浏览器策略经历过复杂演进。应用开发中不应把性能完全寄托在理想化的优先级行为上。

### 7. Server Push
HTTP/2 曾提供服务器推送机制，让服务器主动发送客户端可能需要的资源。

但在实际应用中，它可能造成：

- 推送了客户端已有缓存的资源；

- 带宽竞争；

- 缓存交互复杂；

- 收益不稳定。
因此现代浏览器和服务端实践通常更倾向于使用：

- `preload`；

- `preconnect`；

- `Early Hints`；

- 合理缓存；

- CDN。

### 8. HTTP/2 仍然存在 TCP 队头阻塞
HTTP/2 消除了 HTTP 层单请求排队，但所有流仍共享一条 TCP 连接。

TCP 必须按顺序向上层交付字节。一旦某个 TCP 数据包丢失，即使其他流的数据已经到达，也可能暂时无法交付。

这就是 HTTP/3 重点解决的问题之一。

## 二十一、HTTP/3：运行在 QUIC 之上的 HTTP
HTTP/3 使用 QUIC 作为底层传输。

QUIC 的核心特征包括：

- 基于 UDP 承载；

- 内置加密握手；

- 原生多路复用；

- 独立的流；

- 低延迟连接建立；

- 更灵活的丢包恢复；

- 支持连接迁移。

### 1. 为什么使用 UDP
并不是因为 UDP 自己更可靠。

恰恰相反，UDP 只提供简单的数据报传输。

QUIC 在用户空间重新实现了很多能力：

- 可靠传输；

- 拥塞控制；

- 流量控制；

- 丢包检测；

- 重传；

- 多路复用；

- 安全握手。
使用 UDP 让 QUIC 可以比修改操作系统内核中的 TCP 更快演进和部署。

### 2. 避免跨流的传输层队头阻塞
在 QUIC 中，不同流拥有相对独立的数据交付。

某个流的数据包丢失，不必像单一 TCP 字节流那样阻塞其他无关流的已到达数据。

注意：

同一个 QUIC 流内部仍然可能因为数据缺失而等待；消除的是不同流之间的传输层队头阻塞。

### 3. 更快的连接建立
QUIC 将传输握手和 TLS 1.3 安全机制紧密结合，可以减少建立安全连接所需的往返。

对于曾经连接过的服务器，还可能使用 0-RTT 提前数据。

但 0-RTT 数据可能遭受重放风险，因此只适合谨慎使用在可安全重放的操作上，不能简单用于所有请求。

### 4. 连接迁移
TCP 连接通常由源 IP、源端口、目标 IP、目标端口等信息标识。

移动设备从 Wi-Fi 切换到蜂窝网络时，地址可能变化，TCP 连接往往需要重建。

QUIC 使用连接标识符，可以支持网络路径变化时维持逻辑连接。

### 5. QPACK
HTTP/3 使用 QPACK 压缩首部。

它与 HTTP/2 的 HPACK 设计目标相似，但需要适应 QUIC 多流并行和独立交付的特点。

## 二十二、HTTP/1.1、HTTP/2、HTTP/3 对比

| 维度 | HTTP/1.1 | HTTP/2 | HTTP/3 |
| --- | --- | --- | --- |
| 报文传输形式 | 文本报文 | 二进制帧 | QUIC 流上的二进制帧 |
| 常见底层 | TCP | TCP | QUIC/UDP |
| 多路复用 | 能力有限 | 支持 | 支持 |
| 首部压缩 | 无专用机制 | HPACK | QPACK |
| 跨流传输层队头阻塞 | 明显 | 仍存在 | 大幅缓解 |
| 安全 | 可明文或 TLS | Web 中通常使用 TLS | QUIC 内建 TLS 1.3 机制 |
| 连接迁移 | 不擅长 | 不擅长 | 支持 |
| 主要价值 | 成熟、简单、兼容广 | 提高单连接并发效率 | 改善弱网、丢包和移动网络体验 |

协议版本升级并不意味着业务代码需要完全重写。

HTTP 方法、状态码、缓存和资源语义仍然延续。很多升级可以由：

- 浏览器；

- CDN；

- 负载均衡；

- 反向代理；

- Web 服务器
在基础设施层完成。

## 二十三、跨域与 CORS
浏览器有同源策略。

通常，协议、主机、端口三者都相同，才被视为同源。

例如：

```
https://www.example.com:443
```
下面这些都可能与它不同源：

```
http://www.example.com
https://api.example.com
https://www.example.com:8443
```

### CORS 是浏览器安全机制
CORS 全称是跨源资源共享。

服务器通过响应头告诉浏览器，哪些来源可以读取响应。

例如：

```
Access-Control-Allow-Origin: https://www.example.com
```

### 简单请求
满足特定条件的跨源请求可以直接发送，服务器在响应中返回 CORS 头。

### 预检请求
对于某些方法、首部或媒体类型，浏览器会先发送 `OPTIONS`：

```
OPTIONS /api/orders HTTP/1.1
Origin: https://www.example.com
Access-Control-Request-Method: POST
Access-Control-Request-Headers: Authorization, Content-Type
```
服务器响应：

```
HTTP/1.1 204 No Content
Access-Control-Allow-Origin: https://www.example.com
Access-Control-Allow-Methods: POST, OPTIONS
Access-Control-Allow-Headers: Authorization, Content-Type
Access-Control-Max-Age: 600
```
预检通过后，浏览器才发送实际请求。

### CORS 不等于服务器访问控制
非浏览器客户端一般不受浏览器同源策略约束。

因此，不能把 CORS 当作真正的身份认证或权限控制。服务器仍然必须进行：

- 登录校验；

- Token 校验；

- 权限校验；

- 参数校验。

## 二十四、CSRF 与 XSS：和 HTTP 有什么关系

### 1. CSRF
CSRF 利用浏览器在某些请求中自动携带 Cookie 的特性，诱导已登录用户向目标站点发起非预期操作。

防护方式包括：

- CSRF Token；

- `SameSite` Cookie；

- 校验 `Origin` 或 `Referer`；

- 重要操作二次确认；

- 避免使用 `GET` 执行状态修改。

### 2. XSS
XSS 是把恶意脚本注入页面并在用户浏览器中执行。

防护包括：

- 输出编码；

- 输入处理；

- Content Security Policy；

- 避免危险的 DOM API；

- Cookie 设置 `HttpOnly`；

- 使用可信模板和框架机制。
XSS 可能绕过很多前端安全假设，因此不能只依赖“Token 不放 Cookie”之类的单点策略。

## 二十五、范围请求与断点续传
客户端可以请求资源的一部分：

```
Range: bytes=1000-1999
```
服务器支持时返回：

```
HTTP/1.1 206 Partial Content
Content-Range: bytes 1000-1999/10000
Content-Length: 1000
```
常见用途：

- 视频拖动；

- 音频播放；

- 大文件下载；

- 断点续传；

- 分块读取。
服务器可通过：

```
Accept-Ranges: bytes
```
声明支持字节范围请求。

如果条件不满足，可能返回：

```
416 Range Not Satisfiable
```

## 二十六、并发更新与条件请求
HTTP 条件请求不仅用于缓存，也可用于防止并发覆盖。

假设客户端读取到：

```
ETag: "version-18"
```
更新时发送：

```
PUT /api/articles/100 HTTP/1.1
If-Match: "version-18"
Content-Type: application/json

{"title":"新的标题"}
```
如果资源仍然是版本 18，更新成功。

如果其他用户已经把资源更新成版本 19，服务器可以返回：

```
HTTP/1.1 412 Precondition Failed
```
这是一种乐观并发控制。

它可以避免：

```
用户 A 读取旧版本
用户 B 修改并保存
用户 A 再保存，覆盖了用户 B 的修改
```

## 二十七、代理、网关与 CDN
HTTP 的强大之处之一，是支持大量中间节点。

### 1. 正向代理
代表客户端访问外部服务器。

```
客户端 → 正向代理 → 互联网
```
常见用途：

- 企业网络出口；

- 内容过滤；

- 隐私保护；

- 访问控制。

### 2. 反向代理
代表服务器接收客户端请求。

```
客户端 → 反向代理 → 后端服务
```
常见用途：

- TLS 终止；

- 负载均衡；

- 压缩；

- 缓存；

- 限流；

- 路由；

- 静态文件服务。

### 3. API 网关
在微服务架构中统一处理：

- 认证；

- 鉴权；

- 限流；

- 路由；

- 协议转换；

- 日志；

- 监控；

- 熔断。

### 4. CDN
CDN 把资源缓存到离用户更近的边缘节点。

```
用户 → 就近 CDN 节点 → 必要时回源
```
CDN 特别适合：

- 图片；

- 视频；

- JavaScript；

- CSS；

- 下载文件；

- 可缓存 API 响应。

## 二十八、HTTP API 设计的实用原则

### 1. URL 表达资源，方法表达动作
推荐：

```
GET /users/1001
POST /users
PUT /users/1001
PATCH /users/1001
DELETE /users/1001
```
不够理想：

```
POST /getUser
POST /createUser
POST /updateUser
POST /deleteUser
```
并不是任何带动作的 URL 都错误，但应尽量发挥 HTTP 本身的语义能力。

### 2. 正确使用状态码
例如：

- 创建成功：`201`；

- 异步受理：`202`；

- 无内容成功：`204`；

- 参数错误：`400`；

- 未认证：`401`；

- 无权限：`403`；

- 资源不存在：`404`；

- 冲突：`409`；

- 限流：`429`；

- 服务不可用：`503`。

### 3. 错误响应保持一致
例如：

```
{
"error": {
"code": "USER_EMAIL_INVALID",
"message": "邮箱格式不正确",
"requestId": "req_01J..."
}
}
```
建议包含：

- 稳定的机器可读错误码；

- 面向调用方的描述；

- 请求追踪 ID；

- 必要的字段级错误信息。
不要把堆栈、数据库语句、密钥等内部信息暴露给客户端。

### 4. 分页
常见方式：

```
GET /articles?page=2&pageSize=20
```
对于数据频繁变化的大型列表，可以考虑游标分页：

```
GET /articles?cursor=eyJpZCI6MTAwMH0&limit=20
```

### 5. 过滤与排序

```
GET /articles?status=published&sort=-createdAt
```

### 6. 版本管理
常见方式：

```
/api/v1/users
```
或通过媒体类型、请求头协商。

不要为了每次小改动都创建新版本。版本升级应聚焦不兼容变化。

### 7. 幂等键
对于支付、下单等不能重复执行的操作，可以使用幂等键：

```
POST /payments HTTP/1.1
Idempotency-Key: 4f01d4a8-...
```
服务器记录该键与结果。客户端超时重试时，如果键相同，服务器返回第一次处理结果，而不是重复扣款。

### 8. 请求追踪
客户端或网关可携带追踪标识：

```
Traceparent: 00-...
```
或者系统内部约定的请求 ID。

日志中串联：

```
CDN → 网关 → 服务 A → 服务 B → 数据库
```
才能快速定位分布式系统中的问题。

## 二十九、重试不是简单地“失败就再来一次”
重试可以提升可靠性，也可能制造事故。

### 适合重试的情况

- 临时网络错误；

- 连接重置；

- `502`；

- `503`；

- `504`；

- 某些 `429`；

- 明确可幂等的操作。

### 不应盲目重试的情况

- 参数错误；

- 权限错误；

- 不可重放的请求；

- 已经在服务器成功执行但客户端没收到响应的非幂等操作。

### 指数退避
不要固定每 10 毫秒重试一次。

更合理的方式：

```
第 1 次：等待约 1 秒
第 2 次：等待约 2 秒
第 3 次：等待约 4 秒
第 4 次：等待约 8 秒
```
并加入随机抖动，避免大量客户端同时重试形成“惊群”。

### 尊重 Retry-After
当服务器返回：

```
Retry-After: 60
```
客户端应尽量遵守。

## 三十、超时应该分层设计
“请求超时”并不是一个单一概念。

常见超时包括：

- DNS 超时；

- 连接超时；

- TLS 握手超时；

- 请求写入超时；

- 等待响应头超时；

- 响应体读取超时；

- 整体调用截止时间。
如果只设置一个很大的总超时，系统可能长期卡在某个阶段。

在微服务中，还要保证超时预算逐层递减：

```
用户请求总预算：3 秒
↓
网关调用服务 A：2.5 秒
↓
服务 A 调用服务 B：1.5 秒
↓
服务 B 查询数据库：800 毫秒
```
否则上游已经超时断开，下游仍在继续消耗资源。

## 三十一、HTTP 性能优化的正确方向

### 1. 先减少不必要的请求

- 删除无用资源；

- 合并可合并的数据接口；

- 避免重复请求；

- 使用本地缓存；

- 按需加载。
HTTP/2 并不意味着“请求数量完全不重要”。

### 2. 减少传输体积

- 文本使用 gzip、Brotli 等压缩；

- 图片使用合适格式和尺寸；

- 精简 JSON；

- 避免返回无用字段；

- 大数据分页；

- 静态资源压缩和 Tree Shaking。
不要对已经高度压缩的格式反复压缩，例如某些图片、视频和压缩包，收益可能很低。

### 3. 合理使用缓存

- 带哈希静态资源长期缓存；

- HTML 入口及时验证；

- API 根据业务设置私有缓存或共享缓存；

- 设置正确的 `Vary`；

- 避免对用户私有数据误用公共缓存。

### 4. 使用 CDN
静态资源和可缓存内容尽可能靠近用户。

### 5. 复用连接
避免频繁建立连接。服务端调用应使用连接池。

### 6. 支持 HTTP/2 或 HTTP/3
尤其对：

- 高延迟网络；

- 移动网络；

- 多资源页面；

- 全球访问；

- 丢包环境
可能带来明显改善。

### 7. 优化服务器首字节时间
如果 TTFB 很高，问题可能在：

- 后端计算；

- 数据库；

- 缓存未命中；

- 服务依赖；

- 冷启动；

- 网关排队；

- 跨区域访问。
升级协议不能替代后端性能优化。

## 三十二、用 curl 学习 HTTP
`curl` 是最实用的 HTTP 调试工具之一。

### 1. 发送 GET 请求

```
curl https://example.com
```

### 2. 查看响应头

```
curl -I https://example.com
```

### 3. 查看完整通信信息

```
curl -v https://example.com
```
可以观察：

- DNS 解析；

- 连接建立；

- TLS；

- 请求头；

- 响应头；

- 协议版本。

### 4. 发送 JSON

```
curl -X POST 'https://api.example.com/users' \
-H 'Content-Type: application/json' \
-d '{"name":"Alice","age":20}'
```

### 5. 添加认证头

```
curl 'https://api.example.com/profile' \
-H 'Authorization: Bearer YOUR_TOKEN'
```

### 6. 跟随重定向

```
curl -L https://example.com/old
```

### 7. 保存 Cookie

```
curl -c cookies.txt https://example.com/login
```

### 8. 携带 Cookie

```
curl -b cookies.txt https://example.com/profile
```

### 9. 测量请求耗时

```
curl -o /dev/null -s \
-w 'DNS: %{time_namelookup}\nConnect: %{time_connect}\nTLS: %{time_appconnect}\nTTFB: %{time_starttransfer}\nTotal: %{time_total}\n' \
https://example.com
```
这些指标可以帮助判断慢在：

- DNS；

- TCP；

- TLS；

- 服务器处理；

- 内容下载。

## 三十三、浏览器开发者工具怎么看
打开浏览器开发者工具的 Network 面板，可以重点观察：

### General

- Request URL；

- Request Method；

- Status Code；

- Remote Address；

- Referrer Policy。

### Request Headers
检查：

- `Authorization` 是否发送；

- Cookie 是否发送；

- `Origin` 是否正确；

- `Content-Type` 是否匹配；

- 是否出现缓存条件头。

### Response Headers
检查：

- `Cache-Control`；

- `ETag`；

- `Content-Type`；

- `Content-Encoding`；

- CORS 响应头；

- `Set-Cookie`；

- 代理和 CDN 信息。

### Timing
常见阶段：

- Queueing；

- DNS Lookup；

- Initial Connection；

- SSL；

- Request Sent；

- Waiting for Server Response；

- Content Download。

### Size
注意区分：

- 资源原始大小；

- 网络传输大小；

- 是否来自内存缓存；

- 是否来自磁盘缓存；

- 是否返回 `304`。

## 三十四、抓包时为什么有时看不到 HTTP 内容
如果是明文 HTTP，抓包工具通常能直接看到报文。

如果是 HTTPS，抓到的主要是加密后的 TLS 或 QUIC 数据，无法直接读取 HTTP 内容。

可行的调试方式包括：

- 浏览器开发者工具；

- 应用日志；

- 本地调试代理并安装受信任证书；

- 在受控环境中导出 TLS 会话密钥；

- 服务端链路追踪。
必须注意隐私和合规，不应在未经授权的设备或网络上拦截通信。

## 三十五、常见故障如何定位

### 1. 404
检查：

- URL 路径；

- 路由配置；

- 是否访问了错误域名；

- 反向代理是否改写路径；

- 资源是否真的存在。

### 2. 401
检查：

- 是否携带凭据；

- Token 是否过期；

- Token 格式是否正确；

- Cookie 是否因为 Domain、Path、SameSite 或 Secure 未发送；

- 客户端和服务器时间是否严重偏差。

### 3. 403
检查：

- 用户是否有权限；

- IP 白名单；

- WAF 规则；

- CSRF 校验；

- 资源是否仅允许特定角色；

- CORS 问题是否被误认为 403。

### 4. 413
检查：

- Nginx 或网关请求体大小限制；

- 应用服务器上传限制；

- CDN 限制；

- 是否应使用分片或直传对象存储。

### 5. 415
检查 `Content-Type` 与请求体是否一致。

发送 JSON 时不要忘记：

```
Content-Type: application/json
```

### 6. 429
检查：

- 客户端重试过于激进；

- 限流维度是 IP、用户、Token 还是接口；

- 是否遵守 `Retry-After`；

- 是否存在请求风暴。

### 7. 502
通常检查网关到上游：

- 上游进程是否运行；

- 地址和端口是否正确；

- 协议是否匹配；

- 上游是否提前关闭连接；

- DNS 是否解析错误；

- TLS 是否握手失败。

### 8. 504
通常检查：

- 上游是否处理太慢；

- 数据库是否慢查询；

- 依赖服务是否超时；

- 网关超时是否小于后端实际耗时；

- 是否存在线程池、连接池耗尽。

### 9. 浏览器报跨域，但 curl 正常
这是典型情况。

`curl` 不执行浏览器同源策略，浏览器会检查 CORS 响应头。

因此：

curl 成功，只能说明服务器可访问，不代表浏览器跨域访问一定被允许。

### 10. 明明修改了文件，浏览器还是旧内容
检查：

- 浏览器内存缓存；

- 磁盘缓存；

- Service Worker；

- CDN 缓存；

- 反向代理缓存；

- `Cache-Control`；

- `ETag`；

- HTML 是否引用了旧资源文件名。

## 三十六、常见误区

### 误区一：HTTP 是不可靠的
HTTP 本身定义应用语义。HTTP/1.1 和 HTTP/2 通常依赖 TCP 获得可靠字节传输；HTTP/3 依赖 QUIC 提供可靠流。

不能简单说“HTTP 不可靠”。

### 误区二：POST 比 GET 更安全
方法名称不会自动提供安全性。

如果使用明文 HTTP，GET 和 POST 都可能被中间人读取。

真正的传输保护依赖 HTTPS。

此外，GET 参数通常出现在 URL 中，更容易进入：

- 历史记录；

- 日志；
-监控；

- Referer。
但 POST 请求体也不是天然加密的。

### 误区三：GET 不能有请求体
协议语法并不总是简单等同于“绝对禁止”，但 GET 请求内容没有通用、可靠的语义，很多客户端、服务器、代理和缓存不会正确支持。

工程实践中不应依赖 GET 请求体。

### 误区四：no-cache 就是不缓存
`no-cache` 通常表示可以存储，但使用前要验证。

真正强调不存储的是：

```
Cache-Control: no-store
```

### 误区五：304 是服务端错误
`304 Not Modified` 是缓存验证成功。

客户端应继续使用本地缓存的响应体。

### 误区六：HTTP/2 一定比 HTTP/1.1 快
多数场景可能更高效，但性能取决于：

- 页面结构；

- 网络质量；

- 服务器实现；

- TLS；

- 缓存；

- CDN；

- 资源优先级；

- 后端响应时间。
协议不是唯一变量。

### 误区七：用了 HTTPS 就不需要其他安全措施
HTTPS 只保护传输，不替代认证、授权、输入校验和安全编码。

### 误区八：JWT 比 Session 高级
两者适用于不同架构，没有绝对高低。

### 误区九：状态码只给人看
状态码会影响：

- 浏览器行为；

- 代理缓存；

- 重试策略；

- 监控告警；

- SDK 逻辑；

- 搜索引擎；

- CDN。
它是机器可理解的协议语义。

## 三十七、从入门到精通的学习路线

### 第一阶段：会读报文
掌握：

- URL；

- 请求行；

- 状态行；

- 请求头；

- 响应头；

- 请求体；

- 响应体。
练习：

```
curl -v https://example.com
```

### 第二阶段：掌握核心语义
重点学习：

- 方法；

- 状态码；

- 安全性；

- 幂等性；

- 内容类型；

- 重定向；
-认证。

### 第三阶段：掌握浏览器相关机制
重点学习：

- Cookie；

- Session；

- CORS；

- SameSite；

- CSRF；

- 缓存；

- DevTools。

### 第四阶段：掌握现代协议
理解：

- HTTP/1.1 持久连接；

- HTTP/2 二进制分帧；

- 多路复用；

- HPACK；

- QUIC；

- HTTP/3；

- QPACK；

- 连接迁移。

### 第五阶段：掌握工程设计
重点学习：

- API 设计；

- 错误模型；

- 超时；

- 重试；

- 幂等键；

- 并发控制；

- CDN；

- 网关；

- 链路追踪；

- 性能测量。

### 第六阶段：阅读规范
不要一开始就逐字硬啃所有 RFC。

可以按问题阅读：

- 方法语义不清楚时，查 HTTP Semantics；

- 缓存行为不清楚时，查 HTTP Caching；

- HTTP/1.1 报文边界不清楚时，查 HTTP/1.1；

- HTTP/2 帧和流不清楚时，查 HTTP/2；

- QUIC 和 HTTP/3 不清楚时，查 QUIC 与 HTTP/3。

## 三十八、面试常见问题速答

### 1. HTTP 和 HTTPS 的区别是什么
HTTPS 是 HTTP 通过 TLS 进行安全通信，提供加密、完整性校验和服务器身份认证。

### 2. GET 和 POST 的区别是什么
核心区别是语义：

- GET 用于获取资源，安全且幂等；

- POST 用于提交数据或触发处理，通常不安全且不幂等。
URL、缓存、浏览器行为和请求体支持上的差异，是语义和实现共同形成的结果。

### 3. 401 和 403 的区别是什么

- 401：尚未通过身份认证；

- 403：服务器拒绝授权访问。

### 4. 301、302、307、308 有什么区别

- 301：永久重定向；

- 302：临时重定向；

- 307：临时重定向并保留方法和请求体；

- 308：永久重定向并保留方法和请求体。

### 5. 强缓存和协商缓存是什么

- 新鲜度缓存：资源仍新鲜，直接使用；

- 验证缓存：向服务器发送条件请求，未修改则返回 304。

### 6. HTTP/2 为什么更快
主要因为：

- 二进制分帧；

- 多路复用；

- 首部压缩；

- 更高效的连接使用；

- 流量控制。

### 7. HTTP/3 为什么使用 QUIC
QUIC 提供安全的多路复用传输，减少连接建立延迟，缓解不同流之间的传输层队头阻塞，并支持连接迁移。

### 8. 什么是幂等
相同请求执行一次或多次，对服务器产生的预期最终效果一致。

### 9. Cookie 和 Session 的区别是什么
Cookie 是客户端存储和自动发送数据的机制；Session 通常是服务器保存会话状态的机制，Session ID 经常通过 Cookie 传递。

### 10. 为什么会出现 502 和 504

- 502：网关收到上游无效响应；

- 504：网关等待上游响应超时。

## 三十九、一张图建立完整认知

```
用户输入 URL
↓
解析 Scheme / Host / Port / Path / Query
↓
DNS 获取 IP
↓
建立 TCP + TLS，或建立 QUIC
↓
发送 HTTP 请求
├─ Method
├─ Target
├─ Headers
└─ Body
↓
CDN / 代理 / 网关 / 应用处理
↓
返回 HTTP 响应
├─ Status
├─ Headers
└─ Body
↓
浏览器执行
├─ 缓存
├─ Cookie
├─ CORS
├─ 解压
├─ 解析
└─ 渲染
```
再把协议演进串起来：

```
HTTP/1.0
└─ 简单请求响应，连接复用能力有限

HTTP/1.1
├─ 持久连接
├─ Host
├─ 更完善的缓存
└─ 分块传输

HTTP/2
├─ 二进制分帧
├─ 多路复用
├─ HPACK
└─ 仍运行在 TCP 上

HTTP/3
├─ 基于 QUIC
├─ 独立流
├─ QPACK
├─ 更快连接建立
└─ 支持连接迁移
```

## 四十、总结
学习 HTTP，不能只背方法和状态码。

真正的理解，应当建立在以下几个层次上：

### 第一层：知道它是什么
HTTP 是应用层协议，定义客户端和服务器交换资源表示的语义。

### 第二层：看懂一次请求
能够读懂：

- URL；

- 方法；

- 状态码；

- 首部；

- 消息体。

### 第三层：理解浏览器机制
掌握：

- Cookie；

- Session；

- 缓存；

- CORS；

- HTTPS；

- 安全边界。

### 第四层：理解协议演进
知道 HTTP/2 和 HTTP/3 并没有推翻 HTTP 语义，而是在传输表达和连接效率上持续改进。

### 第五层：解决工程问题
能够设计：

- 正确的 API；

- 合理的缓存；

- 安全的认证；

- 可控的重试；

- 清晰的错误响应；

- 可追踪的请求链路；

- 稳定的超时体系。
HTTP 看似简单：

```
请求 → 响应
```
但它背后连接了浏览器、网络、服务器、代理、缓存、安全与分布式系统。

当你真正读懂一个 HTTP 报文，也就拥有了一把理解整个 Web 世界的钥匙。

## 参考资料

- [1. RFC 9110：HTTP Semantics](https://www.rfc-editor.org/rfc/rfc9110.html)

- [2. RFC 9111：HTTP Caching](https://www.rfc-editor.org/rfc/rfc9111.html)

- [3. RFC 9112：HTTP/1.1](https://www.rfc-editor.org/rfc/rfc9112.html)

- [4. RFC 9113：HTTP/2](https://www.rfc-editor.org/rfc/rfc9113.html)

- [5. RFC 9114：HTTP/3](https://www.rfc-editor.org/rfc/rfc9114.html)

- [6. RFC 9000：QUIC Transport](https://www.rfc-editor.org/rfc/rfc9000.html)

- [7. RFC 9001：Using TLS to Secure QUIC](https://www.rfc-editor.org/rfc/rfc9001.html)

- [8. RFC 9205：Building Protocols with HTTP](https://www.rfc-editor.org/rfc/rfc9205.html)
