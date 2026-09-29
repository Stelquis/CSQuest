# [WebSocket 从入门到精通：从协议原理到高并发实时通信实战](https://mp.weixin.qq.com/s/CdcRTTsp4SC7JTGZ4ezvLg)

> 这是一个关于"脉冲直播"的故事——一个靠弹幕和实时互动活着的直播小站，和它从"每三秒问一次服务器"到"百万连接实时推送"的完整旅程。你会跟着林一帆一起，把 WebSocket 从一行 `new WebSocket()` 一直拆到帧结构和集群架构，亲手处理断线、重连、认证和慢客户端。读完之后你会发现：建立一条连接从来不难，难的是连接建立之后的工程问题。

---

## 故事的起点：被轮询拖垮的弹幕

"脉冲直播"是一个三个人做的直播小站：主播开播推流，观众发弹幕、点爱心、抽抽奖。林一帆负责全部后端，技术栈是 Node.js 加一层 Nginx。

第一版弹幕系统，他用了最省事的方案——前端每 3 秒请求一次 `/api/messages`：

```javascript
setInterval(async () => {
  const response = await fetch("/api/messages");
  const messages = await response.json();
  console.log(messages);
}, 3000);
```

日常几十个观众时，一切正常。直到某个周五晚上，一个游戏主播来试播，在线人数冲到了几千——弹幕越来越"卡"，每条消息平均要等三四秒才出现在别人屏幕上；服务器 CPU 却始终居高不下。林一帆盯了一晚监控，算了一笔账：3000 个客户端每 3 秒拉一次，就算一条弹幕都没有，服务器每秒也要白处理 1000 次请求，每次都带着一整套 HTTP 头。

凌晨两点，他在白板上写下了自己的困境：

- 聊天消息如何实时到达？
- 礼物特效如何立即触发？
- 在线人数如何实时刷新？
- 服务器能不能主动告诉客户端"有新消息了"？

如果仍然只使用普通 HTTP，客户端就不得不频繁询问服务器："有新消息吗？"——这就是轮询。

第二天复盘，前端同事阿蕾提了一句："浏览器和服务器之间，其实可以建一条长期保持、全双工、低开销的通信通道，那个东西叫 WebSocket。"

林一帆决定把 WebSocket 从头到尾学一遍。他给自己划了三个层次：**会用 API，理解协议，掌握工程化。**因为老听众都劝他：真正困难的从来不是"建立一条连接"，而是连接建立之后的一切——网络随时会断，消息可能重复，客户端在弱网里挣扎，服务器要滚动升级，单机内存装不下跨节点的路由。

这个故事，就是他从第一行 `new WebSocket()` 走到生产级实时通信系统的路线图。

---

## 第一站：轮询的尽头——为什么需要 WebSocket

### HTTP 的基本通信模式

HTTP 的典型工作方式如下：

1. 客户端发起请求。
2. 服务器处理请求。
3. 服务器返回响应。
4. 一次通信完成。

例如：

```http
GET /api/messages HTTP/1.1
Host: example.com
```

服务器返回：

```http
HTTP/1.1 200 OK
Content-Type: application/json

[
  {"id": 1, "content": "你好"}
]
```

HTTP 本质上由客户端驱动。服务器通常不能在没有请求的情况下，直接向浏览器发送一条新的业务消息。

### 短轮询

最简单的实时更新方案，是客户端每隔几秒发送一次请求。林一帆的弹幕系统就是它。

它的优点是实现简单，兼容性好；缺点也非常明显：

- 大量请求没有新数据，浪费带宽和服务器资源。
- 实时性取决于轮询间隔。
- 间隔太短，服务器压力大。
- 间隔太长，用户感受到明显延迟。
- 每次请求都带有 HTTP 头，通信开销较大。

假设 10 万个客户端每 3 秒请求一次，即使没有任何新消息，服务器每秒也要处理约 3.3 万次请求。

### 长轮询

长轮询的思路是：客户端发送请求后，服务器先不立即返回，而是等待有新数据时再响应。

```
客户端发起请求
    ↓
服务器等待消息
    ↓
有新消息后返回
    ↓
客户端收到响应
    ↓
客户端立即再次发起请求
```

长轮询比短轮询节省了许多无效请求，但它仍然存在问题：

- 每次收到消息后，都要重新建立下一次请求。
- 服务器需要长期挂起大量 HTTP 请求。
- 请求和响应头仍然存在。
- 双向高频通信时效率不高。

### Server-Sent Events

Server-Sent Events，简称 SSE，是一种服务器向浏览器单向推送文本数据的技术。

```javascript
const source = new EventSource("/events");
source.onmessage = event => {
  console.log(event.data);
};
```

SSE 的优点包括：

- 浏览器原生支持。
- 自动重连。
- 基于普通 HTTP。
- 非常适合服务器单向推送。
- 文本流处理简单。

但 SSE 是单向通信：服务器可以持续向客户端发送数据，而客户端仍需通过普通 HTTP 向服务器提交数据。

因此：

- 新闻推送、日志流、AI 文本流：SSE 很合适。
- 聊天、游戏、协同编辑、实时控制：WebSocket 通常更合适。

### WebSocket 的核心价值

WebSocket 建立连接后，客户端和服务器都可以随时主动发送数据：

```
客户端  ⇄  服务器
```

它具有以下特点：

- 全双工通信。
- 长连接。
- 低延迟。
- 协议头开销小。
- 支持文本和二进制数据。
- 适合高频消息交换。
- 服务器可以主动推送。

---

## 第二站：认识这个协议——什么是 WebSocket

WebSocket 是一种建立在 TCP 之上的应用层通信协议。它最初通过 HTTP 请求完成协议升级，随后通信进入 WebSocket 模式。

普通未加密连接使用：

```
ws://example.com/socket
```

加密连接使用：

```
wss://example.com/socket
```

其中：

- `ws` 类似于 `http`
- `wss` 类似于 `https`
- `wss` 使用 TLS 加密

在生产环境中，应优先使用 `wss://`。

### WebSocket 与 TCP 的关系

WebSocket 并不是对 TCP 的替代，而是在 TCP 之上定义了消息帧格式、连接握手、关闭机制等规则：

```
应用数据
   ↓
WebSocket 帧
   ↓
TCP
   ↓
IP
```

TCP 提供可靠、有序的字节流传输；WebSocket 在此基础上提供"消息"概念。

---

## 第三站：一次升级引发的握手——连接建立过程

WebSocket 不是一开始就直接使用自定义二进制协议，而是先发送一次 HTTP Upgrade 请求。

### 客户端握手请求

浏览器可能发送如下请求：

```http
GET /chat HTTP/1.1
Host: example.com
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ==
Sec-WebSocket-Version: 13
Origin: https://example.com
```

关键请求头说明：

| 请求头 | 作用 |
| --- | --- |
| `Upgrade: websocket` | 表示希望升级为 WebSocket |
| `Connection: Upgrade` | 表示当前连接需要升级 |
| `Sec-WebSocket-Key` | 客户端生成的随机值 |
| `Sec-WebSocket-Version` | WebSocket 协议版本 |
| `Origin` | 请求来源，可用于安全校验 |

### 服务端握手响应

服务器接受升级后，返回：

```http
HTTP/1.1 101 Switching Protocols
Upgrade: websocket
Connection: Upgrade
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
```

状态码 `101 Switching Protocols` 表示协议切换成功。

### Sec-WebSocket-Accept 如何生成

服务端会将客户端发送的 `Sec-WebSocket-Key` 与固定 GUID 拼接：

```
258EAFA5-E914-47DA-95CA-C5AB0DC85B11
```

然后执行：

1. 字符串拼接。
2. SHA-1 哈希。
3. Base64 编码。

伪代码如下：

```
accept = Base64(
  SHA1(
    Sec-WebSocket-Key
    + "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
  )
)
```

林一帆特意在这里标注了一句：这个过程主要用于确认服务端理解 WebSocket 协议，**而不是身份认证，也不是数据加密**。

### 握手完成后的变化

握手前：

```
HTTP 请求 → HTTP 响应
```

握手后：

```
WebSocket 帧 ⇄ WebSocket 帧
```

同一个 TCP 连接继续使用，但不再按普通 HTTP 请求和响应格式通信。

### 连接建立时序

```
客户端                      服务端
  ├─── HTTP Upgrade 请求 ───→│
  │←── 101 Switching Protocols┤
  ├─── WebSocket 数据帧 ────→│
  │←─── WebSocket 数据帧 ─────┤
  │←─── Ping ────────────────│
  ├─── Pong ────────────────→│
  │←─── Close ───────────────│
  ├─── Close ───────────────→│
```

---

## 第四站：拆开消息的封装——数据帧原理

WebSocket 传输的数据被组织为一个个帧。一个简化的帧结构如下：

```
+--------+--------+------------------+------------------+
| FIN    | Opcode | Payload Length   | Payload Data     |
+--------+--------+------------------+------------------+
```

实际帧头还包括 RSV、MASK、扩展长度、掩码密钥等字段。

### FIN

FIN 用于表示当前帧是否是一个消息的最后一帧：

- FIN = 1：消息已经结束。
- FIN = 0：后面还有分片。

大消息可以拆成多个帧传输。

### Opcode

Opcode 表示帧类型：

| Opcode | 含义 |
| --- | --- |
| 0x0 | 延续帧 |
| 0x1 | 文本帧 |
| 0x2 | 二进制帧 |
| 0x8 | 关闭帧 |
| 0x9 | Ping 帧 |
| 0xA | Pong 帧 |

### Payload Length

负载长度决定数据部分的大小。较短消息只需要很小的帧头——与每次都携带大量 HTTP 头相比，WebSocket 在高频小消息场景中更节省带宽。这正是弹幕这种场景的刚需。

### MASK

浏览器发送给服务器的数据帧必须进行掩码处理；服务器发送给客户端的数据通常不需要掩码。

**掩码不是加密**，它只是协议层面的数据变换，不能提供保密性。真正的数据安全依赖 TLS，也就是 `wss://`。

### 文本帧和二进制帧

文本消息通常采用 UTF-8：

```javascript
socket.send(JSON.stringify({
  type: "chat",
  content: "你好"
}));
```

二进制消息可以发送：图片数据、音频片段、视频片段、Protobuf、MessagePack、自定义二进制协议。

浏览器端可指定二进制接收类型：

```javascript
socket.binaryType = "arraybuffer";
```

或者：

```javascript
socket.binaryType = "blob";
```

---

## 第五站：前端的第一课——浏览器 WebSocket API

### 创建连接

```javascript
const socket = new WebSocket("wss://example.com/ws");
```

创建对象后，浏览器会自动开始连接。

### 监听连接成功

```javascript
socket.addEventListener("open", () => {
  console.log("WebSocket 已连接");
});
```

### 发送消息

```javascript
socket.send("Hello WebSocket");
```

发送 JSON：

```javascript
socket.send(JSON.stringify({
  type: "message",
  roomId: "room-001",
  content: "大家好"
}));
```

### 接收消息

```javascript
socket.addEventListener("message", event => {
  console.log("收到消息：", event.data);
});
```

解析 JSON：

```javascript
socket.addEventListener("message", event => {
  try {
    const message = JSON.parse(event.data);
    switch (message.type) {
      case "message":
        console.log("聊天消息：", message.data);
        break;
      case "online_count":
        console.log("在线人数：", message.data);
        break;
      default:
        console.warn("未知消息类型：", message.type);
    }
  } catch (error) {
    console.error("消息格式错误：", error);
  }
});
```

### 监听错误

```javascript
socket.addEventListener("error", event => {
  console.error("WebSocket 发生错误：", event);
});
```

浏览器为了安全，通常不会提供非常详细的底层网络错误信息。

### 监听连接关闭

```javascript
socket.addEventListener("close", event => {
  console.log("连接已关闭");
  console.log("关闭码：", event.code);
  console.log("原因：", event.reason);
  console.log("是否正常关闭：", event.wasClean);
});
```

### 主动关闭连接

```javascript
socket.close(1000, "页面退出");
```

其中：

- `1000` 表示正常关闭。
- 第二个参数是关闭原因。

### readyState

WebSocket 有四种状态：

| 值 | 常量 | 含义 |
| --- | --- | --- |
| 0 | CONNECTING | 正在连接 |
| 1 | OPEN | 已连接 |
| 2 | CLOSING | 正在关闭 |
| 3 | CLOSED | 已关闭 |

发送消息前应检查：

```javascript
if (socket.readyState === WebSocket.OPEN) {
  socket.send("hello");
}
```

### bufferedAmount

`bufferedAmount` 表示已经调用 `send()`、但尚未真正发送到网络的数据量：

```javascript
if (socket.bufferedAmount < 1024 * 1024) {
  socket.send(data);
} else {
  console.warn("发送缓冲区积压过多");
}
```

在高频发送、弱网或大文件传输场景中，必须关注背压问题——这一点在后面第十九站还会回来。

---

## 第六站：封装一个可复用的客户端——真实项目的第一步

真实项目中，通常不会在页面里零散地调用 WebSocket API，而是封装成一个可复用客户端。林一帆给脉冲直播写了一个带心跳、指数退避重连和事件分发的 `WebSocketClient`：

```javascript
class WebSocketClient {
  constructor(url, options = {}) {
    this.url = url;
    this.protocols = options.protocols;
    this.heartbeatInterval = options.heartbeatInterval ?? 15000;
    this.reconnectBaseDelay = options.reconnectBaseDelay ?? 1000;
    this.reconnectMaxDelay = options.reconnectMaxDelay ?? 30000;
    this.maxReconnectAttempts = options.maxReconnectAttempts ?? Infinity;
    this.socket = null;
    this.reconnectAttempts = 0;
    this.reconnectTimer = null;
    this.heartbeatTimer = null;
    this.manuallyClosed = false;
    this.listeners = new Map();
  }

  connect() {
    if (
      this.socket &&
      (this.socket.readyState === WebSocket.OPEN ||
       this.socket.readyState === WebSocket.CONNECTING)
    ) {
      return;
    }
    this.manuallyClosed = false;
    this.emit("status", "connecting");

    this.socket = this.protocols
      ? new WebSocket(this.url, this.protocols)
      : new WebSocket(this.url);

    this.socket.addEventListener("open", () => {
      this.reconnectAttempts = 0;
      this.emit("status", "connected");
      this.emit("open");
      this.startHeartbeat();
    });

    this.socket.addEventListener("message", event => {
      this.handleMessage(event.data);
    });

    this.socket.addEventListener("error", error => {
      this.emit("error", error);
    });

    this.socket.addEventListener("close", event => {
      this.stopHeartbeat();
      this.emit("status", "disconnected");
      this.emit("close", event);
      if (!this.manuallyClosed) {
        this.scheduleReconnect();
      }
    });
  }

  handleMessage(rawData) {
    try {
      const message = JSON.parse(rawData);
      if (message.type === "pong") {
        this.emit("pong", message);
        return;
      }
      this.emit("message", message);
      this.emit(message.type, message.data, message);
    } catch {
      this.emit("message", rawData);
    }
  }

  send(type, data, requestId = crypto.randomUUID()) {
    if (!this.socket || this.socket.readyState !== WebSocket.OPEN) {
      throw new Error("WebSocket 尚未连接");
    }
    const message = {
      type,
      requestId,
      timestamp: Date.now(),
      data
    };
    this.socket.send(JSON.stringify(message));
    return requestId;
  }

  startHeartbeat() {
    this.stopHeartbeat();
    this.heartbeatTimer = setInterval(() => {
      if (this.socket?.readyState === WebSocket.OPEN) {
        this.socket.send(JSON.stringify({
          type: "ping",
          timestamp: Date.now()
        }));
      }
    }, this.heartbeatInterval);
  }

  stopHeartbeat() {
    if (this.heartbeatTimer) {
      clearInterval(this.heartbeatTimer);
      this.heartbeatTimer = null;
    }
  }

  scheduleReconnect() {
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      this.emit("reconnect_failed");
      return;
    }
    const exponentialDelay =
      this.reconnectBaseDelay * 2 ** this.reconnectAttempts;
    const delay = Math.min(
      exponentialDelay,
      this.reconnectMaxDelay
    );
    const jitter = Math.random() * 500;
    this.reconnectAttempts += 1;
    this.reconnectTimer = setTimeout(() => {
      this.connect();
    }, delay + jitter);
    this.emit("reconnecting", {
      attempt: this.reconnectAttempts,
      delay: delay + jitter
    });
  }

  close(code = 1000, reason = "主动关闭") {
    this.manuallyClosed = true;
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }
    this.stopHeartbeat();
    if (this.socket) {
      this.socket.close(code, reason);
    }
  }

  on(event, listener) {
    if (!this.listeners.has(event)) {
      this.listeners.set(event, new Set());
    }
    this.listeners.get(event).add(listener);
    return () => {
      this.listeners.get(event)?.delete(listener);
    };
  }

  emit(event, ...args) {
    this.listeners.get(event)?.forEach(listener => {
      listener(...args);
    });
  }
}
```

使用方式：

```javascript
const client = new WebSocketClient(
  "wss://example.com/ws?token=temporary-token"
);

client.on("status", status => {
  console.log("连接状态：", status);
});

client.on("chat_message", data => {
  console.log("收到聊天消息：", data);
});

client.on("error", error => {
  console.error(error);
});

client.connect();

document.querySelector("#send").addEventListener("click", () => {
  client.send("send_message", {
    roomId: "room-001",
    content: "你好，WebSocket"
  });
});
```

---

## 第七站：服务端登场——用 Node.js 搭建 WebSocket 服务

Node.js 生态中常用的 WebSocket 库是 `ws`。

### 安装依赖

```bash
npm init -y
npm install ws
```

### 创建基础服务器

```javascript
import { WebSocketServer } from "ws";

const wss = new WebSocketServer({
  port: 8080
});

wss.on("connection", socket => {
  console.log("客户端已连接");

  socket.on("message", rawData => {
    const text = rawData.toString();
    console.log("收到：", text);
    socket.send(JSON.stringify({
      type: "echo",
      data: text
    }));
  });

  socket.on("close", () => {
    console.log("客户端已断开");
  });

  socket.on("error", error => {
    console.error("连接错误：", error);
  });
});

console.log("WebSocket 服务运行在 ws://localhost:8080");
```

### 广播消息

```javascript
import { WebSocket, WebSocketServer } from "ws";

const wss = new WebSocketServer({
  port: 8080
});

function broadcast(message) {
  const payload = JSON.stringify(message);
  for (const client of wss.clients) {
    if (client.readyState === WebSocket.OPEN) {
      client.send(payload);
    }
  }
}

wss.on("connection", socket => {
  socket.on("message", rawData => {
    const message = JSON.parse(rawData.toString());
    broadcast({
      type: "chat_message",
      data: {
        content: message.data.content,
        timestamp: Date.now()
      }
    });
  });
});
```

### 房间机制

聊天系统通常不是向所有连接广播，而是按房间发送。林一帆给脉冲直播的每个直播间建了一个"房间"：

```javascript
import { WebSocketServer } from "ws";

const wss = new WebSocketServer({
  port: 8080
});

const rooms = new Map();

function joinRoom(roomId, socket) {
  if (!rooms.has(roomId)) {
    rooms.set(roomId, new Set());
  }
  rooms.get(roomId).add(socket);
  socket.roomIds ??= new Set();
  socket.roomIds.add(roomId);
}

function leaveRoom(roomId, socket) {
  const room = rooms.get(roomId);
  if (!room) {
    return;
  }
  room.delete(socket);
  if (room.size === 0) {
    rooms.delete(roomId);
  }
  socket.roomIds?.delete(roomId);
}

function sendToRoom(roomId, message, excludeSocket = null) {
  const room = rooms.get(roomId);
  if (!room) {
    return;
  }
  const payload = JSON.stringify(message);
  for (const client of room) {
    if (client !== excludeSocket && client.readyState === client.OPEN) {
      client.send(payload);
    }
  }
}

wss.on("connection", socket => {
  socket.on("message", rawData => {
    let message;
    try {
      message = JSON.parse(rawData.toString());
    } catch {
      socket.send(JSON.stringify({
        type: "error",
        error: {
          code: "INVALID_JSON",
          message: "消息必须是合法 JSON"
        }
      }));
      return;
    }
    switch (message.type) {
      case "join_room":
        joinRoom(message.data.roomId, socket);
        break;
      case "leave_room":
        leaveRoom(message.data.roomId, socket);
        break;
      case "send_message":
        sendToRoom(message.data.roomId, {
          type: "chat_message",
          data: {
            roomId: message.data.roomId,
            content: message.data.content,
            timestamp: Date.now()
          }
        });
        break;
      default:
        socket.send(JSON.stringify({
          type: "error",
          error: {
            code: "UNKNOWN_MESSAGE_TYPE",
            message: "未知消息类型"
          }
        }));
    }
  });

  socket.on("close", () => {
    for (const roomId of socket.roomIds ?? []) {
      leaveRoom(roomId, socket);
    }
  });
});
```

---

## 第八站：给消息定规矩——消息协议设计

WebSocket 只负责传输消息，不会替你定义业务语义。一个成熟系统通常需要自定义应用层消息格式。

推荐使用统一结构：

```json
{
  "type": "send_message",
  "requestId": "6bf6e743-25c0-4cc7-a9fa-5e881d73428d",
  "timestamp": 1784690000000,
  "data": {
    "roomId": "room-001",
    "content": "你好"
  }
}
```

服务端响应：

```json
{
  "type": "message_ack",
  "requestId": "6bf6e743-25c0-4cc7-a9fa-5e881d73428d",
  "timestamp": 1784690000123,
  "data": {
    "messageId": "msg-10001",
    "status": "accepted"
  }
}
```

错误响应：

```json
{
  "type": "error",
  "requestId": "6bf6e743-25c0-4cc7-a9fa-5e881d73428d",
  "timestamp": 1784690000125,
  "error": {
    "code": "PERMISSION_DENIED",
    "message": "你没有进入该房间的权限"
  }
}
```

推荐字段：

| 字段 | 说明 |
| --- | --- |
| `type` | 消息类型 |
| `requestId` | 请求唯一标识，用于关联响应 |
| `timestamp` | 客户端或服务端时间戳 |
| `data` | 业务数据 |
| `error` | 错误对象 |
| `version` | 协议版本 |
| `sequence` | 消息序列号 |

### 为什么需要 requestId

客户端可能同时发送多个请求，例如：发送消息、加入房间、拉取在线成员、更新输入状态。通过 `requestId`，客户端可以知道某个响应对应哪一次请求。

### 为什么需要协议版本

随着业务演进，消息结构可能发生变化：

```json
{
  "version": 2,
  "type": "send_message",
  "data": {}
}
```

服务端可以根据版本兼容旧客户端，避免升级时所有用户同时失效。

---

## 第九站：连接还在吗——心跳机制

WebSocket 的 `open` 状态并不意味着连接永远有效。以下情况都可能导致"假连接"：

- 用户突然断网。
- Wi-Fi 切换到蜂窝网络。
- 路由器重启。
- NAT 映射失效。
- 移动系统冻结后台应用。
- 代理服务器清理空闲连接。
- 服务端进程异常退出。
- TCP 连接半开。

因此，生产系统必须设计心跳。

### 协议级 Ping/Pong

WebSocket 协议定义了 Ping 和 Pong 控制帧。服务端可定期发送 Ping，客户端自动或主动返回 Pong。

Node.js ws 示例：

```javascript
import { WebSocketServer } from "ws";

const wss = new WebSocketServer({
  port: 8080
});

function markAlive() {
  this.isAlive = true;
}

wss.on("connection", socket => {
  socket.isAlive = true;
  socket.on("pong", markAlive);
});

const interval = setInterval(() => {
  for (const socket of wss.clients) {
    if (socket.isAlive === false) {
      socket.terminate();
      continue;
    }
    socket.isAlive = false;
    socket.ping();
  }
}, 30000);

wss.on("close", () => {
  clearInterval(interval);
});
```

### 应用层心跳

浏览器 JavaScript API 不能直接发送协议级 Ping 控制帧，因此常见做法是发送业务消息。

客户端：

```json
{
  "type": "ping",
  "timestamp": 1784690000000
}
```

服务端：

```json
{
  "type": "pong",
  "timestamp": 1784690000001
}
```

### 心跳间隔如何设置

心跳过于频繁会增加流量和服务器负载；过于稀疏则无法快速发现断线。常见范围：

- 即时聊天：15～30 秒。
- 在线游戏：5～15 秒。
- 普通通知：30～60 秒。
- 大量物联网设备：根据网络和功耗调整。

设计时还应考虑反向代理和负载均衡器的空闲超时时间。

---

## 第十站：断开是常态——断线重连的正确做法

网络断开并不罕见。移动端切换网络、电脑休眠、代理重启，都可能造成连接中断。

### 不要固定间隔疯狂重连

下面的代码并不理想：

```javascript
socket.onclose = () => {
  setTimeout(connect, 1000);
};
```

如果服务器宕机，数十万客户端会每秒同时重连一次，形成**重连风暴**。

### 指数退避

更合理的方式是指数退避：

```
第 1 次：1 秒
第 2 次：2 秒
第 3 次：4 秒
第 4 次：8 秒
第 5 次：16 秒
上限：30 秒
```

加入随机抖动：

```javascript
function getReconnectDelay(attempt) {
  const base = 1000;
  const max = 30000;
  const exponential = Math.min(base * 2 ** attempt, max);
  const jitter = Math.random() * 500;
  return exponential + jitter;
}
```

随机抖动可以避免大量客户端在完全相同的时间重连。

### 重连后恢复状态

重新建立连接并不等于业务状态已经恢复。客户端往往还需要：

1. 重新认证。
2. 重新加入房间。
3. 恢复订阅。
4. 上报最后收到的消息序列号。
5. 拉取断线期间遗漏的数据。

例如：

```json
{
  "type": "resume",
  "data": {
    "sessionId": "session-001",
    "lastSequence": 10240,
    "subscriptions": [
      "room:100",
      "stock:AAPL"
    ]
  }
}
```

### 消息补偿

假设客户端最后收到的序列号是 10240，重连后服务端可以补发：

```
10241
10242
10243
...
```

但这要求服务端保存一定时间窗口内的消息，或从消息数据库中重新查询。

---

## 第十一站：谁在敲连接的门——认证与授权

WebSocket 建立后会保持很长时间，因此认证设计非常重要。

### 浏览器限制

浏览器原生 WebSocket 构造函数不能像 `fetch` 那样自由添加任意请求头。不能直接这样写：

```javascript
new WebSocket(url, {
  headers: {
    Authorization: "Bearer token"
  }
});
```

浏览器端常见认证方式包括：Cookie、URL 查询参数、子协议、连接成功后的第一条认证消息、先通过 HTTP 获取一次性票据。

### Cookie 认证

当 WebSocket 地址与网站属于同一站点时，浏览器可能自动携带 Cookie。

优点：

- 与现有会话系统结合方便。
- 浏览器自动管理。

注意事项：

- 必须防范跨站 WebSocket 劫持。
- 需要校验 Origin。
- Cookie 应设置 HttpOnly、Secure、合理的 SameSite。
- 不能只因为存在 Cookie 就默认请求可信。

### 查询参数携带 Token

```javascript
const token = "temporary-token";
const socket = new WebSocket(
  `wss://example.com/ws?token=${encodeURIComponent(token)}`
);
```

这种方式简单，但存在风险：

- URL 可能出现在日志中。
- 代理、监控系统可能记录查询参数。
- 浏览器历史或错误报告可能泄露信息。

因此，应使用短期、一次性、权限受限的临时票据，而不是长期访问令牌。

### 连接后发送认证消息

```javascript
const socket = new WebSocket("wss://example.com/ws");
socket.addEventListener("open", () => {
  socket.send(JSON.stringify({
    type: "authenticate",
    data: {
      token: "access-token"
    }
  }));
});
```

服务端在认证成功前，不应允许执行其他业务操作。

### 一次性 WebSocket Ticket

更安全的流程是：

1. 客户端通过 HTTPS 请求一次性票据。
2. 服务端生成短期票据。
3. 客户端使用票据建立 WebSocket。
4. WebSocket 服务验证后立即使票据失效。

```
客户端              WebSocket 服务            认证服务
  ├── HTTPS 请求 WebSocket Ticket ────────→│
  │←──────────── 返回短期一次性 Ticket ─────┤
  ├── 使用 Ticket 建立 WebSocket ──→│
  │                                 ├── 校验 Ticket ──→│
  │←──────── 校验成功并作废，连接成功 ─┤←────────────────┤
```

### 认证不等于授权

认证解决"你是谁"，授权解决"你能做什么"。即使用户已经登录，服务端仍要检查：

- 是否有权加入某个房间。
- 是否有权订阅某只股票。
- 是否有权操作某个设备。
- 是否可以向某个用户发消息。
- 是否可以执行管理员命令。

**永远不要相信客户端传来的 userId。**错误做法：

```json
{
  "type": "send_message",
  "data": {
    "userId": "admin",
    "content": "系统通知"
  }
}
```

正确做法是从服务端认证上下文读取用户身份：

```javascript
const userId = socket.auth.userId;
```

---

## 第十二站：长连接的攻防——WebSocket 安全问题

### 1. 使用 WSS

生产环境应使用：

```
wss://example.com/ws
```

而不是：

```
ws://example.com/ws
```

`wss` 可以防止中间人窃听和篡改通信内容。

### 2. 校验 Origin

浏览器在握手时通常发送 Origin。服务端应建立允许列表：

```javascript
const allowedOrigins = new Set([
  "https://www.example.com",
  "https://admin.example.com"
]);

wss.on("connection", (socket, request) => {
  const origin = request.headers.origin;
  if (!allowedOrigins.has(origin)) {
    socket.close(1008, "Origin 不被允许");
    return;
  }
});
```

不要把 Origin 校验当作唯一认证方式，但它是重要的防护层。

### 3. 限制消息大小

攻击者可能发送超大消息耗尽内存：

```javascript
const wss = new WebSocketServer({
  port: 8080,
  maxPayload: 1024 * 1024
});
```

这里将单条消息限制为 1 MB。

### 4. 限制消息频率

需要按连接、用户、IP 或业务类型限流。伪代码：

```javascript
if (!rateLimiter.allow(userId)) {
  socket.close(1008, "请求过于频繁");
  return;
}
```

可以使用：固定窗口、滑动窗口、令牌桶、漏桶。

### 5. 校验消息结构

不要直接相信客户端 JSON：

```javascript
function validateSendMessage(data) {
  return (
    typeof data === "object" &&
    typeof data.roomId === "string" &&
    data.roomId.length <= 64 &&
    typeof data.content === "string" &&
    data.content.length > 0 &&
    data.content.length <= 2000
  );
}
```

大型项目可使用 JSON Schema、Zod、Joi、Ajv 等工具。

### 6. 防止资源泄漏

连接关闭后，应清理：

- 房间成员关系
- 用户在线状态
- 定时器
- 订阅
- 未完成请求
- 文件句柄
- 内存缓存

否则，运行时间越长，内存占用越高。

### 7. 避免敏感信息进入日志

不要记录：完整访问令牌、Cookie、身份证号、银行卡号、私密聊天原文、密码、一次性认证票据。日志中应进行脱敏。

---

## 第十三站：好好说再见——关闭码与连接生命周期

WebSocket 使用关闭帧结束连接。常见关闭码：

| 关闭码 | 含义 |
| --- | --- |
| 1000 | 正常关闭 |
| 1001 | 端点离开，例如服务器关闭或页面离开 |
| 1002 | 协议错误 |
| 1003 | 不支持的数据类型 |
| 1008 | 违反策略 |
| 1009 | 消息过大 |
| 1011 | 服务端内部错误 |
| 1012 | 服务重启 |
| 1013 | 服务暂时过载 |

### 正常关闭流程

理想情况下：

1. 一端发送 Close 帧。
2. 另一端回复 Close 帧。
3. TCP 连接关闭。

如果检测到死连接，可以直接强制终止。Node.js ws 中：

```javascript
socket.close(1000, "正常关闭");
```

强制终止：

```javascript
socket.terminate();
```

`close()` 会尽量完成关闭握手，`terminate()` 则立即断开。

---

## 第十四站：过代理这道关——反向代理与 Nginx 配置

生产环境中，WebSocket 服务通常位于 Nginx、网关或负载均衡器之后。Nginx 需要正确转发 Upgrade 头：

```nginx
map $http_upgrade $connection_upgrade {
    default upgrade;
    ''      close;
}

server {
    listen 443 ssl;
    server_name example.com;

    location /ws/ {
        proxy_pass http://websocket_backend;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection $connection_upgrade;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 60s;
        proxy_send_timeout 60s;
    }
}
```

### 常见配置错误

**错误一：未使用 HTTP/1.1**

```nginx
proxy_http_version 1.1;
```

缺少它可能导致协议升级失败。

**错误二：未转发 Upgrade 头**

```nginx
proxy_set_header Upgrade $http_upgrade;
proxy_set_header Connection $connection_upgrade;
```

**错误三：空闲超时过短**

如果代理 60 秒无数据就关闭连接，而心跳间隔是 120 秒，连接会频繁断开。因此，必须协调：

```
心跳间隔 < 代理空闲超时
```

---

## 第十五站：一台机器装不下所有连接——单机为什么无法无限扩展

单机 WebSocket 服务通常把连接对象保存在内存中：

```javascript
const users = new Map();
users.set(userId, socket);
```

当系统只有一个实例时，这种方式很简单。但当服务扩展为多个实例：

```
客户端 A → 实例 1
客户端 B → 实例 2
客户端 C → 实例 3
```

此时实例 1 无法直接访问实例 2 内存中的连接对象。

### 典型问题

用户 A 连接实例 1，用户 B 连接实例 2。A 给 B 发消息时：

1. 实例 1 收到消息。
2. 实例 1 查询自己的内存。
3. 找不到 B 的连接。
4. 消息无法直接发送。

因此，需要跨节点消息分发机制。

---

## 第十六站：让消息跨过节点——WebSocket 集群架构

典型集群架构如下：

```
              ┌──────────────┐
客户端 ────────→│  负载均衡器   │
              └──────┬───────┘
                     │
        ┌────────────┼────────────┐
        ↓            ↓            ↓
  WebSocket 1   WebSocket 2   WebSocket 3
        │            │            │
        └────────────┼────────────┘
                     ↓
             Redis / 消息队列
```

### Redis Pub/Sub

每个 WebSocket 实例订阅频道：

```
user:1001
room:2001
broadcast
```

当实例 1 需要向实例 2 上的用户发送消息时，可以发布到 Redis。

发布：

```javascript
await redis.publish(
  "user:1001",
  JSON.stringify({
    type: "notification",
    data: {
      content: "你有一条新消息"
    }
  })
);
```

订阅：

```javascript
await subscriber.subscribe("user:1001", message => {
  const socket = localUsers.get("1001");
  if (socket?.readyState === socket.OPEN) {
    socket.send(message);
  }
});
```

Redis Pub/Sub 简单、延迟低，但消息不会持久化。订阅者离线时，消息可能丢失。

### Redis Streams

如果业务要求消息可追溯、消费确认、离线恢复、重放，可以考虑 Redis Streams。

### Kafka

Kafka 更适合：高吞吐事件流、消息持久化、多消费组、大规模数据管道、业务事件解耦。但 Kafka 并不直接管理 WebSocket 连接，WebSocket 网关仍需将 Kafka 消息路由到本机连接。

### 粘性会话

负载均衡器可以使用粘性会话，让同一用户尽量连接到同一实例。但粘性会话不能解决所有问题：

- 实例故障后仍会重连到其他节点。
- 用户可能同时使用多个设备。
- 跨用户消息仍然需要节点间通信。
- 部署扩缩容会改变连接分布。

因此，粘性会话只是优化手段，不应成为唯一依赖。

### 连接注册中心

大型系统可以维护 `userId → serverId → connectionId` 的映射，例如：

```json
{
  "userId": "1001",
  "serverId": "ws-node-03",
  "connectionIds": [
    "conn-a",
    "conn-b"
  ]
}
```

这样，消息路由服务可以知道某个用户连接在哪个节点。

---

## 第十七站："在线"不是布尔值——在线状态设计

"在线"并不是一个简单的布尔值。用户可能：

- 同时打开多个浏览器标签页。
- 同时登录手机和电脑。
- 网络断开但服务端尚未发现。
- 页面在后台被冻结。
- 连接存在但用户长期无操作。

因此，更合理的数据结构是：

```
userId
  ├── device-1
  │     ├── connection-a
  │     └── connection-b
  └── device-2
        └── connection-c
```

### 在线状态的常见定义

- 只要存在一个有效连接，即在线。
- 最近 30 秒收到心跳，即在线。
- 最近 5 分钟有用户操作，即活跃。
- 连接已建立但无操作，即空闲。

可以分别提供：

```json
{
  "connectionStatus": "online",
  "activityStatus": "idle",
  "lastActiveAt": 1784690000000
}
```

### 避免频繁写数据库

如果每次心跳都更新数据库，连接数大时会产生巨量写操作。更常见的方式：

- 在线状态放 Redis。
- 心跳只刷新 TTL。
- 离线后异步更新数据库。
- 批量处理最后活跃时间。

---

## 第十八站：send 成功≠消息可靠——可靠消息设计

TCP 可以保证字节流可靠到达对端操作系统，但这并不等于业务消息已经成功处理。例如：

1. 客户端调用 `send()`。
2. 数据进入本地缓冲区。
3. 服务器收到消息。
4. 服务器尚未写入数据库。
5. 服务器进程崩溃。

此时客户端可能以为消息已发送，但服务端并未真正保存。

### 应用层 ACK

客户端发送：

```json
{
  "type": "send_message",
  "requestId": "req-001",
  "data": {
    "clientMessageId": "client-msg-001",
    "content": "你好"
  }
}
```

服务端处理成功后返回：

```json
{
  "type": "message_ack",
  "requestId": "req-001",
  "data": {
    "clientMessageId": "client-msg-001",
    "serverMessageId": "server-msg-9001",
    "status": "stored"
  }
}
```

客户端只有收到 ACK 后，才把消息状态从"发送中"改为"已发送"。

### 超时重试

```javascript
function sendWithAck(client, type, data, timeout = 5000) {
  return new Promise((resolve, reject) => {
    const requestId = crypto.randomUUID();
    const timer = setTimeout(() => {
      unsubscribe();
      reject(new Error("请求超时"));
    }, timeout);
    const unsubscribe = client.on("message_ack", message => {
      if (message.requestId !== requestId) {
        return;
      }
      clearTimeout(timer);
      unsubscribe();
      resolve(message.data);
    });
    client.send(type, data, requestId);
  });
}
```

### 幂等性

如果客户端没有收到 ACK，可能会重试。但第一次请求也许已经成功，只是 ACK 丢失。此时服务端可能重复保存消息。

因此，应使用客户端消息 ID 实现幂等：

```
clientMessageId = client-msg-001
```

服务端对该 ID 建立唯一约束。重复请求到达时，返回之前的处理结果，而不是再次执行。

### 消息顺序

WebSocket 在单条 TCP 连接内按发送顺序交付数据，但业务层仍可能出现乱序：

- 多节点并行处理。
- 消息进入多个队列分区。
- 重试导致旧消息晚到。
- 断线重连后补发。
- 客户端并发更新界面。

可以使用：sequence、业务版本号、逻辑时钟、服务端时间戳、每个会话独立序列。

示例：

```json
{
  "type": "chat_message",
  "sequence": 1042,
  "data": {}
}
```

---

## 第十九站：快客户端把慢客户端拖下水——背压与流量控制

WebSocket 连接速度并不总是一样。如果服务端产生消息的速度高于客户端接收速度，数据会不断积压。

### 服务端背压

Node.js ws 中可以检查：

```javascript
if (socket.bufferedAmount > 1024 * 1024) {
  console.warn("客户端过慢，缓冲区超过 1 MB");
}
```

处理策略包括：

- 丢弃非关键旧消息。
- 合并多条状态更新。
- 降低发送频率。
- 暂停上游数据。
- 断开长期慢客户端。
- 只保留最新快照。

### 不同业务的处理方式

**聊天消息**：不能轻易丢弃，应持久化并允许补拉。

**实时坐标**：旧坐标通常没有价值，只需保留最新状态。客户端过慢时，可以直接发送最新的那个位置。

**监控指标**：可以降低采样率或聚合：

```
每秒 100 条 → 每秒 1 条平均值
```

### 客户端发送背压

浏览器端：

```javascript
function safeSend(socket, data) {
  const maxBufferedAmount = 512 * 1024;
  if (socket.bufferedAmount > maxBufferedAmount) {
    throw new Error("发送队列拥堵");
  }
  socket.send(data);
}
```

---

## 第二十站：消息用什么格式——JSON、MessagePack 与 Protobuf

### JSON

优点：

- 易读。
- 易调试。
- 浏览器原生支持。
- 开发效率高。

缺点：

- 字段名重复，占用空间。
- 数值和二进制表达效率较低。
- 解析成本可能较高。

适合大多数中小型系统。

### MessagePack

MessagePack 是一种紧凑的二进制序列化格式。

优点：

- 比 JSON 更紧凑。
- 支持二进制。
- 解析效率较好。

缺点：

- 抓包后不易直接阅读。
- 前后端需要统一库。

### Protobuf

Protobuf 通过 `.proto` 文件定义消息：

```protobuf
syntax = "proto3";

message ChatMessage {
  string room_id = 1;
  string user_id = 2;
  string content = 3;
  int64 timestamp = 4;
}
```

优点：

- 体积小。
- 序列化速度快。
- 类型明确。
- 适合多语言系统。

缺点：

- 协议管理更复杂。
- 调试不如 JSON 直观。
- 字段演进需要遵循兼容规则。

### 如何选择

- 普通 Web 应用：JSON。
- 高频实时数据：MessagePack。
- 大规模多语言系统：Protobuf。
- 极致性能场景：定制二进制协议，但维护成本更高。

---

## 第二十一站：别把两者混为一谈——WebSocket 与 Socket.IO 的区别

许多初学者会把 WebSocket 和 Socket.IO 当作同一个东西。它们并不相同。

### WebSocket

WebSocket 是标准协议。浏览器原生支持：

```javascript
new WebSocket("wss://example.com/ws");
```

### Socket.IO

Socket.IO 是一个实时通信框架，提供了更高层功能：

- 自动重连。
- 心跳。
- 房间。
- 命名空间。
- ACK。
- 广播。
- 降级传输。
- 连接状态恢复。

Socket.IO 可能使用 WebSocket 作为底层传输，但其消息协议不是原生 WebSocket 协议。

因此：

- 原生 WebSocket 客户端不能直接连接 Socket.IO 服务端。
- Socket.IO 客户端也不能直接连接普通 WebSocket 服务端。

### 如何选择

选择原生 WebSocket：

- 希望遵循标准协议。
- 客户端类型很多。
- 需要精确控制协议。
- 追求较低开销。
- 团队愿意自行实现重连、房间、ACK 等能力。

选择 Socket.IO：

- 希望快速开发实时应用。
- 主要使用 JavaScript/TypeScript 技术栈。
- 需要现成的房间、重连和 ACK。
- 更关注开发效率。

---

## 第二十二站：单向还是双向——WebSocket 与 SSE 如何选择

| 对比项 | WebSocket | SSE |
| --- | --- | --- |
| 通信方向 | 双向 | 服务端到客户端单向 |
| 数据类型 | 文本、二进制 | 主要是文本 |
| 自动重连 | 需要自行实现 | 浏览器内置 |
| 基于协议 | WebSocket | HTTP |
| 代理兼容性 | 需要正确升级配置 | 通常更简单 |
| 典型场景 | 聊天、游戏、协同编辑 | 通知、日志、AI 文本流 |
| 客户端上行 | 原连接发送 | 另用 HTTP |

判断方法很简单：

- 只需要服务器持续推送：优先考虑 SSE。
- 客户端与服务器都要高频交互：优先考虑 WebSocket。
- 只是偶尔更新：普通 HTTP 可能已经足够。

**不要为了"技术看起来高级"而滥用 WebSocket。**

---

## 第二十三站：框架里的长连接——React 中使用 WebSocket

下面是一个简化的 React Hook：

```javascript
import { useCallback, useEffect, useRef, useState } from "react";

export function useWebSocket(url) {
  const socketRef = useRef(null);
  const reconnectTimerRef = useRef(null);
  const reconnectAttemptRef = useRef(0);
  const [status, setStatus] = useState("disconnected");
  const [lastMessage, setLastMessage] = useState(null);

  useEffect(() => {
    let manuallyClosed = false;

    function connect() {
      setStatus("connecting");
      const socket = new WebSocket(url);
      socketRef.current = socket;

      socket.onopen = () => {
        reconnectAttemptRef.current = 0;
        setStatus("connected");
      };

      socket.onmessage = event => {
        try {
          setLastMessage(JSON.parse(event.data));
        } catch {
          setLastMessage(event.data);
        }
      };

      socket.onerror = () => {
        setStatus("error");
      };

      socket.onclose = () => {
        setStatus("disconnected");
        if (manuallyClosed) {
          return;
        }
        const attempt = reconnectAttemptRef.current++;
        const delay = Math.min(1000 * 2 ** attempt, 30000);
        const jitter = Math.random() * 500;
        reconnectTimerRef.current = setTimeout(
          connect,
          delay + jitter
        );
      };
    }

    connect();

    return () => {
      manuallyClosed = true;
      if (reconnectTimerRef.current) {
        clearTimeout(reconnectTimerRef.current);
      }
      socketRef.current?.close(1000, "组件卸载");
    };
  }, [url]);

  const send = useCallback(message => {
    const socket = socketRef.current;
    if (!socket || socket.readyState !== WebSocket.OPEN) {
      return false;
    }
    socket.send(
      typeof message === "string"
        ? message
        : JSON.stringify(message)
    );
    return true;
  }, []);

  return {
    status,
    lastMessage,
    send
  };
}
```

组件中使用：

```jsx
function ChatRoom() {
  const { status, lastMessage, send } =
    useWebSocket("wss://example.com/ws");

  return (
    <div>
      <p>连接状态：{status}</p>
      <button
        onClick={() =>
          send({
            type: "send_message",
            data: {
              roomId: "room-001",
              content: "你好"
            }
          })
        }
      >
        发送消息
      </button>
      <pre>
        {JSON.stringify(lastMessage, null, 2)}
      </pre>
    </div>
  );
}
```

在 React 开发模式下，要注意组件可能重复挂载与卸载，连接管理应放在稳定的 Provider 或专门的连接层中。

---

## 第二十四站：另一种栈——Python WebSocket 服务示例

使用 websockets 库：

```bash
pip install websockets
```

服务端：

```python
import asyncio
import json
import websockets
from websockets.server import ServerConnection

clients: set[ServerConnection] = set()

async def broadcast(message: dict) -> None:
    if not clients:
        return
    payload = json.dumps(message, ensure_ascii=False)
    await asyncio.gather(
        *(client.send(payload) for client in clients),
        return_exceptions=True,
    )

async def handler(websocket: ServerConnection) -> None:
    clients.add(websocket)
    print("客户端连接，当前数量：", len(clients))
    try:
        async for raw_message in websocket:
            try:
                message = json.loads(raw_message)
            except json.JSONDecodeError:
                await websocket.send(json.dumps({
                    "type": "error",
                    "error": {
                        "code": "INVALID_JSON",
                        "message": "消息不是合法 JSON",
                    },
                }, ensure_ascii=False))
                continue

            if message.get("type") == "ping":
                await websocket.send(json.dumps({
                    "type": "pong",
                    "timestamp": message.get("timestamp"),
                }))
                continue

            await broadcast({
                "type": "broadcast",
                "data": message.get("data"),
            })
    finally:
        clients.discard(websocket)
        print("客户端断开，当前数量：", len(clients))

async def main() -> None:
    async with websockets.serve(
        handler,
        "0.0.0.0",
        8765,
        max_size=1024 * 1024,
        ping_interval=20,
        ping_timeout=20,
    ):
        print("WebSocket 服务运行在 ws://localhost:8765")
        await asyncio.Future()

if __name__ == "__main__":
    asyncio.run(main())
```

---

## 第二十五站：上线之前先练手——测试 WebSocket

### 浏览器控制台

```javascript
const ws = new WebSocket("ws://localhost:8080");
ws.onopen = () => {
  console.log("connected");
  ws.send(JSON.stringify({
    type: "ping"
  }));
};
ws.onmessage = event => {
  console.log(event.data);
};
```

### 使用 wscat

安装：

```bash
npm install -g wscat
```

连接：

```bash
wscat -c ws://localhost:8080
```

连接成功后可直接输入消息。

### 使用 websocat

```bash
websocat ws://localhost:8080
```

它适合命令行测试、管道处理和自动化脚本。

### 自动化测试

测试内容应包括：

- 正常连接。
- 认证失败。
- 非法 Origin。
- 无效 JSON。
- 超大消息。
- 高频消息。
- 心跳超时。
- 服务重启。
- 断线重连。
- 重连后恢复订阅。
- 重复消息幂等。
- 慢客户端。
- 集群跨节点发送。

### 压力测试

压力测试不能只统计"建立了多少连接"，还应观察：

- 每秒新建连接数。
- 当前连接总数。
- 每秒消息数。
- 单条消息大小。
- P50、P95、P99 延迟。
- CPU 使用率。
- 内存占用。
- 事件循环延迟。
- 发送缓冲区长度。
- 重连成功率。
- 消息丢失率。
- 错误码分布。

---

## 第二十六站：长连接更难排查——可观测性设计

WebSocket 是长连接，排查问题比普通 HTTP 更困难。一个成熟系统至少需要以下指标。

### 1. 连接指标

```
websocket_connections_active
websocket_connections_opened_total
websocket_connections_closed_total
websocket_connection_duration_seconds
websocket_auth_failed_total
```

### 2. 消息指标

```
websocket_messages_received_total
websocket_messages_sent_total
websocket_message_bytes_received_total
websocket_message_bytes_sent_total
websocket_message_processing_duration_seconds
```

### 3. 错误指标

```
websocket_invalid_message_total
websocket_rate_limited_total
websocket_send_failed_total
websocket_heartbeat_timeout_total
websocket_reconnect_total
```

### 4. 业务指标

聊天系统还应监控：消息发送成功率、ACK 延迟、在线人数、房间数量、离线消息补发量、重复消息数量。

### 5. 日志字段

建议每条连接日志包含：

```json
{
  "connectionId": "conn-001",
  "userId": "user-1001",
  "serverId": "ws-node-03",
  "remoteIp": "203.0.113.10",
  "connectedAt": "2026-07-22T10:00:00Z",
  "closeCode": 1000,
  "durationMs": 184000
}
```

不要在每次心跳时打印一条普通日志，否则高并发下日志量会非常大。

---

## 第二十七站：省下每一字节——性能优化

### 1. 减少不必要的广播

错误做法：

```
一条消息 → 遍历全部 100 万连接
```

应按用户、房间、主题建立索引：

```
roomId → connections
userId → connections
topic  → connections
```

### 2. 合并消息

短时间内大量小消息可以合并：

```json
{
  "type": "batch",
  "data": [
    {"type": "price", "symbol": "A", "value": 10},
    {"type": "price", "symbol": "B", "value": 20},
    {"type": "price", "symbol": "C", "value": 30}
  ]
}
```

但合并会增加延迟，应根据业务权衡。

### 3. 选择合适的压缩策略

WebSocket 支持扩展，例如 permessage-deflate。

压缩适合：大量重复文本、大 JSON、带宽成本高。

压缩不一定适合：极小消息、CPU 紧张、数据本身已压缩、极低延迟场景。

压缩会增加 CPU 和内存消耗，必须通过压测决定。

### 4. 控制每条连接的内存

一条连接可能占用：Socket 对象、接收缓冲区、发送缓冲区、用户上下文、房间集合、心跳状态、未完成请求、日志上下文。

假设平均每条连接占用 50 KB，10 万连接就可能占用约 5 GB 内存。因此，连接上下文应尽量精简。

### 5. 避免每连接一个重量级定时器

10 万连接创建 10 万个 `setInterval`，管理成本较高。更好的做法是使用统一扫描器：

```javascript
setInterval(() => {
  for (const socket of connections) {
    checkHeartbeat(socket);
  }
}, 30000);
```

大型系统还可以使用时间轮等结构。

### 6. 分离连接层与业务层

WebSocket 网关负责：建立连接、认证、心跳、限流、协议解析、消息路由。

业务服务负责：聊天业务、订单处理、游戏逻辑、数据持久化、权限规则。

这样可以让连接层保持轻量，业务服务独立扩容。

---

## 第二十八站：不停机地换轮子——部署与优雅停机

WebSocket 是长连接。部署新版本时，不能简单地直接杀死进程。

### 1. 优雅停机流程

1. 实例从负载均衡器摘除。
2. 停止接受新连接。
3. 通知现有客户端服务即将重启。
4. 等待连接主动迁移或关闭。
5. 超时后关闭剩余连接。
6. 进程退出。

服务端发送：

```json
{
  "type": "server_shutdown",
  "data": {
    "retryAfterMs": 3000
  }
}
```

客户端收到后：

```javascript
client.on("server_shutdown", data => {
  client.close(1012, "服务重启");
  setTimeout(() => {
    client.connect();
  }, data.retryAfterMs);
});
```

### 2. Kubernetes 环境

在 Kubernetes 中应关注：

- terminationGracePeriodSeconds
- preStop Hook
- Readiness Probe
- Pod 从 Service Endpoint 移除的时机
- 负载均衡器连接排空
- 客户端重连抖动

### 3. 避免同时重启所有节点

滚动发布时分批重启，否则所有连接会同时断开并触发重连风暴。

---

## 第二十九站：问题来了怎么办——常见错误与排查方法

### 1. 浏览器提示连接失败

检查：

- 地址是否正确。
- 页面是 HTTPS 时，是否错误地使用了 `ws://`。
- 证书是否有效。
- 服务端是否监听对应端口。
- 防火墙是否放行。
- Nginx 是否转发 Upgrade。
- Origin 是否被拒绝。
- Token 是否过期。

### 2. 连接约一分钟自动断开

通常与代理空闲超时有关。解决：

- 缩短心跳间隔。
- 调大代理读超时。
- 检查云负载均衡器的空闲连接设置。

### 3. 浏览器显示 400 或 404

可能原因：

- 请求路径错误。
- 请求被普通 HTTP 路由处理。
- 服务端没有执行协议升级。
- 代理转发到了错误端口。
- Host 或路径重写错误。

### 4. 连接成功但收不到消息

检查：

- 消息是否发到了正确房间。
- 用户与连接映射是否存在。
- 连接是否在本机节点。
- Redis 订阅是否正常。
- `readyState` 是否为 OPEN。
- 发送缓冲区是否积压。
- 客户端消息解析是否报错。
- 协议版本是否一致。

### 5. 内存持续上涨

重点检查：

- 断开连接是否从集合中移除。
- 房间为空后是否删除。
- 定时器是否清理。
- 事件监听器是否重复注册。
- 未完成 Promise 是否积压。
- 发送缓冲区是否不断变大。
- 大消息是否被长期引用。

### 6. 重连后收到重复消息

可能原因：

- 客户端重复订阅。
- 旧连接尚未完全关闭。
- 服务端重复消费队列。
- ACK 超时导致重试。
- 没有使用幂等 ID。
- 补发区间边界计算错误。

---

## 第三十站：把一切拼起来——一个生产级聊天系统架构

下面给出一个较完整的架构思路：

```
┌─────────────────┐
│  Web / App 客户端 │
└───────┬─────────┘
        │ WSS
        ↓
┌──────────────────┐
│ 负载均衡 / API 网关 │
└────────┬─────────┘
         ↓
┌──────────────────┐
│ WebSocket Gateway │
│ 认证、心跳、限流、路由 │
└────┬────────┬────┘
     │        │
     ├────────→ Redis
     │         在线状态、路由、Pub/Sub
     ├─────────→ 消息队列
     │            Kafka / Redis Streams
     ↓
┌──────────────────┐
│  Chat Service    │
│ 会话、权限、消息逻辑 │
└────────┬─────────┘
         ↓
┌──────────────────┐
│  Database        │
│ 消息、会话、成员关系 │
└──────────────────┘
```

### 发送消息流程

1. 客户端通过 WebSocket 发送消息。
2. 网关完成身份认证和限流。
3. 网关调用聊天服务。
4. 聊天服务校验房间权限。
5. 消息写入数据库。
6. 消息进入队列。
7. WebSocket 节点消费消息。
8. 按用户或房间推送。
9. 服务端返回 ACK。
10. 客户端更新消息状态。

### 离线消息流程

1. 服务端发现接收方没有在线连接。
2. 消息保存在数据库。
3. 可选：发送系统推送通知。
4. 用户重新上线后拉取未读消息。
5. WebSocket 负责后续实时消息。

**WebSocket 并不意味着所有数据都必须只通过 WebSocket 获取。**成熟系统通常将 HTTP 和 WebSocket 结合使用：

- HTTP：登录、历史消息、文件上传、分页查询。
- WebSocket：实时消息、状态变化、在线通知。

---

## 第三十一站：贴在墙上的清单——最佳实践

### 连接层

- 生产环境使用 WSS。
- 校验 Origin。
- 设置连接超时。
- 设计心跳和断线检测。
- 使用指数退避和随机抖动重连。
- 服务端支持优雅停机。
- 限制单 IP 和单用户连接数。

### 消息层

- 定义统一消息格式。
- 使用消息类型和协议版本。
- 使用 requestId 关联请求与响应。
- 对关键操作设计 ACK。
- 使用幂等 ID 防止重复执行。
- 对消息长度和结构严格校验。
- 明确消息顺序规则。

### 安全层

- 不信任客户端身份字段。
- 每次敏感操作都做授权。
- Token 使用短期有效期。
- 避免令牌进入日志。
- 限制消息频率。
- 限制最大消息大小。
- 对异常连接及时关闭。

### 扩展层

- 不依赖单机内存完成跨节点路由。
- 使用 Redis、Kafka 等进行节点间分发。
- 在线状态使用 TTL。
- 设计断线补偿。
- 区分可丢弃状态消息与不可丢失业务消息。
- 对慢客户端实施背压策略。

### 运维层

- 监控在线连接数。
- 监控消息延迟和错误率。
- 监控发送缓冲区。
- 压测连接建立和消息吞吐。
- 演练节点故障和网络抖动。
- 发布时进行连接排空。

---

## 第三十二站：面试官最爱问的——常见面试题

### 1. WebSocket 和 HTTP 有什么关系

WebSocket 建立连接时使用 HTTP Upgrade 完成握手。握手成功后，连接继续复用底层 TCP，但后续数据不再使用普通 HTTP 请求和响应格式，而是使用 WebSocket 帧。

### 2. WebSocket 为什么比轮询高效

因为连接长期保持，服务器可以主动推送数据，不需要客户端不断发送无效请求；同时 WebSocket 数据帧头通常比完整 HTTP 头更小。

### 3. WebSocket 是否一定不会丢消息

不是。WebSocket 基于 TCP，能提供可靠、有序的传输，但业务处理仍可能失败。若要保证业务可靠性，需要 ACK、持久化、重试、幂等、序列号和断线补偿。

### 4. 如何判断 WebSocket 断开

可通过：Close 事件、协议级 Ping/Pong、应用层心跳、心跳超时、读写失败、服务端定期扫描。

### 5. 浏览器如何在 WebSocket 握手时携带 Token

常见方式：Cookie、查询参数中的短期票据、子协议、连接建立后的认证消息、先通过 HTTPS 获取一次性 Ticket。

### 6. WebSocket 集群如何发送消息

每个节点只持有本机连接。跨节点消息可通过 Redis Pub/Sub、Redis Streams、Kafka 等分发，再由目标节点把消息发送给本机连接。

### 7. 如何防止重连风暴

使用指数退避、随机抖动、最大重试间隔、服务端 Retry-After 提示、分批发布和连接排空。

### 8. 为什么要设计应用层 ACK

`send()` 成功只代表数据进入发送流程，不代表业务已经完成。ACK 可以确认服务端是否已经校验、保存或执行成功。

---

## 终点站：学习路线——从入门到精通

### 第一阶段：掌握基础 API

学习内容：浏览器 WebSocket API；open、message、error、close；文本和 JSON 消息；Node.js 或 Python 搭建服务器。

练习项目：回声服务器；简单聊天室；在线人数统计。

### 第二阶段：理解协议原理

学习内容：HTTP Upgrade；握手请求头；帧结构；Opcode；Ping/Pong；Close 帧；文本与二进制；分片与掩码。

练习：使用浏览器开发者工具观察握手；使用抓包工具分析帧；手动计算 Sec-WebSocket-Accept。

### 第三阶段：掌握工程能力

学习内容：心跳；自动重连；指数退避；消息协议；ACK；幂等；背压；认证和授权；限流和消息校验。

练习项目：支持断线恢复的聊天室；带消息状态的即时通信系统；实时日志监控面板。

### 第四阶段：掌握分布式架构

学习内容：多节点连接路由；Redis Pub/Sub；Redis Streams；Kafka；在线状态；消息补偿；连接注册中心；灰度发布和优雅停机。

练习项目：多实例聊天室；百万连接架构设计；实时通知中心；协同编辑系统。

### 第五阶段：深入性能与稳定性

学习内容：内存模型；事件循环；压缩；二进制协议；背压；慢客户端；延迟分析；故障演练；可观测性；容量规划。

最终目标不是"会调用 `new WebSocket()`"，而是能够设计一个在真实网络环境下仍然可靠、可扩展、可运维的实时通信系统。

---

半年后的又一个周五晚上，还是那个游戏主播的直播间，在线人数冲到了上万。弹幕一秒几十条地滚动，爱心特效成片地飘过屏幕，服务器 CPU 的曲线却平得像一条直线。林一帆看着监控大屏，想起了那个被轮询拖垮的夜晚。

他已经不再是那个每 3 秒问一次"有新消息吗"的人了。从他手里跑出去的，是一条条穿过握手、帧、心跳、重连、认证、限流和集群分发的长连接——连接的另一端，是上万个正在实时互动的用户。

WebSocket 的基础 API 并不复杂：

```javascript
const socket = new WebSocket("wss://example.com/ws");

socket.onopen = () => {
  socket.send("hello");
};

socket.onmessage = event => {
  console.log(event.data);
};
```

真正困难的部分，从来不是"建立一条连接"，而是连接建立之后的工程问题：网络随时可能中断，消息可能重复处理，客户端可能长期处于弱网，服务器可能滚动升级，单机内存无法支撑跨节点路由。

正如那句总结：

> "实时通信的功夫，全在连接建立之后。"

## 参考资料 / 官方延伸阅读

- [The WebSocket Protocol (RFC 6455)](https://datatracker.ietf.org/doc/html/rfc6455)
- [MDN — WebSocket API](https://developer.mozilla.org/zh-CN/docs/Web/API/WebSocket)
- [MDN — HTTP 请求升级机制](https://developer.mozilla.org/zh-CN/docs/Web/HTTP/Protocol_upgrade_mechanism)
- [ws — Node.js WebSocket 库](https://github.com/websockets/ws)
- [websockets — Python 库文档](https://websockets.readthedocs.io/)
- [Socket.IO 官方文档](https://socket.io/docs/v4/)
- [MDN — Server-Sent Events](https://developer.mozilla.org/zh-CN/docs/Web/API/Server-sent_events)
- [Nginx — WebSocket proxying](https://nginx.org/en/docs/http/websocket.html)

> 版本提示：WebSocket 协议（RFC 6455）长期稳定，但各运行时与库的 API 细节持续演进。实际开发前，请根据所使用的语言、框架和库版本核对参数与行为。
