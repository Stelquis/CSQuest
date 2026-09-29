# [Python 网络编程从入门到精通：Socket、并发、异步与实战](https://mp.weixin.qq.com/s/daCiT0_gqiMKV4nfKlOyeQ)

> 这是一个关于"萤火矩阵"的故事——一个靠分布式爬虫吃饭的小团队，和它从"单线程脚本被一个超时卡死整晚"到"异步服务扛住上万连接"的完整旅程。你会跟着程野一起，把 Socket、字节流、消息边界、线程池、selectors 和 asyncio 一层层打通，最后亲手写出一个异步多人聊天室。读完之后你会发现：网络编程的核心其实很简单——让两个进程按照约定，在网络中可靠或高效地交换字节；难的是现实网络里的不确定性。

---

## 故事的起点：一个超时，卡死一整晚的爬虫

"萤火矩阵"是一个三人小团队，靠给客户做数据采集和分析过活。程野负责全部脚本开发——Python 写的，简单直接。

那晚跑一个紧急任务：采集两千个站点的数据。程野的脚本是单线程的，一个站点接着一个站点地抓。跑到第 37 个站点时，那个服务器没响应了——脚本就停在那里，`urlopen` 没设超时，一行代码把整个采集任务卡到天亮。客户早上要数据，早上看进度：37/2000。

程野盯着那行没有 `timeout` 参数的代码，忽然想明白了一件事：

**网络编程的核心，不是让程序在理想网络里跑通，而是让它在不理想的网络里活下来。**

他把那晚的教训写在白板上，密密麻麻：

- 数据可能被拆分；
- 连接可能突然中断；
- 对端可能很慢；
- 消息可能很大；
- 流量可能瞬间增加；
- 下游可能故障；
- 输入可能是恶意的。

很多人第一次接触网络编程，会觉得它充满了陌生名词：IP、端口、Socket、TCP、UDP、阻塞、非阻塞、粘包、并发、事件循环……但把这些概念串起来后，你会发现网络编程的核心其实很简单：

**让两个进程按照约定，在网络中可靠或高效地交换字节。**

其中有三个关键词：

1. **两个进程**：通常是客户端和服务端；
2. **交换字节**：网络传输的不是 Python 对象，而是字节；
3. **约定**：应用层协议决定了字节如何被理解和还原。

团队的老搭档给他划了一条学习路径：掌握 Python 基础语法之后，从阻塞 Socket 入门，是为了理解连接和字节流；学习消息协议，是为了可靠地表达业务；掌握并发和异步，是为了管理更多连接；补齐超时、背压、安全和可观测性，才是从"能运行"走向"可上线"。

建议环境：Python 3.10 及以上。

这个故事，就是程野从第一个回显服务走向"能上线"的网络工程师的路线图。

---

## 第一站：先建立网络编程的整体地图

### 1. 客户端与服务端

最常见的网络模型是客户端—服务端模型：

```
客户端  ──────请求──────>  服务端
客户端  <─────响应──────  服务端
```

例如：

- 浏览器是客户端，网站是服务端；
- 手机 App 是客户端，业务 API 是服务端；
- 数据库驱动是客户端，数据库进程是服务端。

服务端通常会：

1. 绑定一个 IP 地址和端口；
2. 等待客户端连接；
3. 接收数据；
4. 执行业务逻辑；
5. 返回结果；
6. 关闭连接或继续通信。

客户端通常会：

1. 知道服务端的地址；
2. 主动发起连接；
3. 发送请求；
4. 接收响应；
5. 关闭连接。

### 2. IP 地址与端口

可以把 IP 地址理解为"网络中的主机地址"，把端口理解为"主机内部某个程序的门牌号"。例如：

```
127.0.0.1:5000
```

其中：

- `127.0.0.1` 表示当前计算机，也叫回环地址；
- `5000` 表示某个进程监听的端口。

常见监听地址：

| 地址 | 含义 | 典型用途 |
| --- | --- | --- |
| `127.0.0.1` | 仅本机可访问 | 本地开发、内部组件 |
| `0.0.0.0` | 监听本机所有 IPv4 网卡 | 局域网或公网服务 |
| `::1` | IPv6 本机回环地址 | IPv6 本地开发 |
| `::` | 监听所有 IPv6 地址 | IPv6 服务 |

**`0.0.0.0` 是服务端的监听地址，不是客户端通常应该连接的目标地址。**客户端应连接服务器真实 IP、域名或 `127.0.0.1`。

### 3. TCP 与 UDP

Python 网络编程中最常用的两个传输层协议是 TCP 和 UDP：

| 对比项 | TCP | UDP |
| --- | --- | --- |
| 是否需要连接 | 是 | 否 |
| 可靠性 | 可靠、有序、重传 | 不保证到达、不保证顺序 |
| 数据形式 | 字节流 | 一个个数据报 |
| 开销 | 较高 | 较低 |
| 典型场景 | HTTP、数据库、文件传输、聊天 | 实时音视频、局域网发现、DNS、游戏状态同步 |

一个简单判断：

- 数据必须完整、有序到达，优先考虑 TCP；
- 更看重低延迟，可以容忍少量丢包，考虑 UDP。

### 4. Socket 是什么

Socket 可以理解为操作系统提供的"网络通信接口"。在 Python 中，socket 对象负责：

- 建立连接；
- 监听端口；
- 接收连接；
- 发送和接收数据；
- 设置超时与缓冲区；
- 关闭连接。

创建一个 IPv4 TCP Socket：

```python
import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
```

参数含义：

- `AF_INET`：使用 IPv4；
- `SOCK_STREAM`：使用面向字节流的 TCP。

创建一个 IPv4 UDP Socket：

```python
import socket

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
```

`SOCK_DGRAM` 表示数据报协议，也就是 UDP。

---

## 第二站：写出第一个 TCP 服务端

程野的第一课，是一个最小可运行的 TCP 回显服务：客户端发来什么，服务端就返回什么。

### 1. TCP 服务端

新建 `tcp_server.py`：

```python
import socket

HOST = "127.0.0.1"
PORT = 5000
BUFFER_SIZE = 4096


def main() -> None:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
        # 允许服务重启后较快重新绑定同一端口
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind((HOST, PORT))
        server.listen()
        print(f"服务端已启动：{HOST}:{PORT}")

        conn, address = server.accept()
        with conn:
            print(f"客户端已连接：{address}")
            while True:
                data = conn.recv(BUFFER_SIZE)
                if not data:
                    print("客户端已断开")
                    break
                print(f"收到原始字节：{data!r}")
                conn.sendall(data)


if __name__ == "__main__":
    main()
```

运行：

```bash
python tcp_server.py
```

### 2. TCP 客户端

新建 `tcp_client.py`：

```python
import socket

HOST = "127.0.0.1"
PORT = 5000


def main() -> None:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as client:
        client.connect((HOST, PORT))
        message = "你好，Python 网络编程！"
        client.sendall(message.encode("utf-8"))
        response = client.recv(4096)
        print("服务端返回：", response.decode("utf-8"))


if __name__ == "__main__":
    main()
```

另开一个终端运行：

```bash
python tcp_client.py
```

### 3. 服务端代码到底做了什么

服务端的核心调用顺序是：

```
socket() → bind() → listen() → accept() → recv()/send() → close()
```

逐个解释：

- `socket()`：创建网络套接字；
- `bind()`：绑定监听地址和端口；
- `listen()`：进入监听状态；
- `accept()`：等待并接收客户端连接；
- `recv()`：读取数据；
- `sendall()`：发送完整数据；
- `close()`：释放连接和系统资源。

客户端的核心调用顺序是：

```
socket() → connect() → send()/recv() → close()
```

### 4. 为什么推荐 with socket.socket(...)

Socket 是操作系统资源。使用上下文管理器后，即使代码抛出异常，Socket 也会被自动关闭：

```python
with socket.socket(...) as sock:
    ...
```

它比手动调用 `sock.close()` 更不容易遗漏。

### 5. send() 和 sendall() 有什么区别

`send()` 返回本次实际写入的字节数，可能小于你传入的数据长度：

```python
sent = sock.send(data)
```

`sendall()` 会持续发送，直到全部数据写入系统缓冲区，或者发生异常：

```python
sock.sendall(data)
```

对大多数业务代码来说，优先使用 `sendall()`。

---

## 第三站：网络传输的本质——你发送的是字节

Socket 不认识字符串、字典、列表和对象，只认识字节。

### 1. 字符串与字节互转

```python
text = "你好"
data = text.encode("utf-8")
print(data)
print(data.decode("utf-8"))
```

通信双方必须约定相同编码。现代应用通常使用 UTF-8。

### 2. 结构化数据使用 JSON

```python
import json

payload = {
    "action": "login",
    "username": "alice",
    "remember": True,
}
data = json.dumps(payload, ensure_ascii=False).encode("utf-8")
restored = json.loads(data.decode("utf-8"))
print(restored)
```

JSON 的优点是跨语言、可读、易调试。缺点是体积和解析开销高于某些二进制协议。

### 3. 不要直接反序列化不可信的 pickle

pickle 可以保存 Python 对象，但反序列化恶意数据可能执行任意代码。因此：

**不要对来自网络、用户上传或其他不可信来源的数据直接调用 `pickle.loads()`。**

跨进程协议优先考虑 JSON、MessagePack、Protocol Buffers 等明确格式。

---

## 第四站：最容易踩的坑——TCP 没有"消息边界"

初学者常有一个错误直觉：

> 客户端 send 一次，服务端就能 recv 一次完整收到。

这并不成立。TCP 是字节流。假设客户端连续发送两条消息：

```
Hello
World
```

服务端可能收到：

```
HelloWorld
```

也可能分三次收到：

```
Hel
loWorld
```

原因是 TCP 只保证字节可靠、有序到达，不保留应用层消息边界。

这类现象通常被概括为"粘包"和"拆包"，但本质不是 TCP 出错，而是应用层没有定义消息协议。

### 常见的消息分帧方案

1. 固定长度：每条消息固定为 N 字节；
2. 分隔符：每条消息以 `\n` 等特殊字符结束；
3. 长度前缀：先发送消息长度，再发送消息正文；
4. 连接关闭：读到 EOF 代表消息结束，适合一次性传输。

实际项目中，长度前缀和分隔符最常见。

---

## 第五站：实现可靠的长度前缀协议

萤火矩阵后来规定每条消息格式如下：

```
4 字节消息长度 + 消息正文
```

其中 4 字节使用网络字节序的无符号整数。

### 1. 通用协议函数

新建 `protocol.py`：

```python
import socket
import struct

HEADER_SIZE = 4
MAX_MESSAGE_SIZE = 10 * 1024 * 1024  # 10 MB


def recv_exact(sock: socket.socket, size: int) -> bytes:
    """恰好读取 size 个字节；连接提前关闭时抛出异常。"""
    chunks: list[bytes] = []
    remaining = size
    while remaining > 0:
        chunk = sock.recv(remaining)
        if not chunk:
            raise ConnectionError("连接在数据接收完成前关闭")
        chunks.append(chunk)
        remaining -= len(chunk)
    return b"".join(chunks)


def send_message(sock: socket.socket, payload: bytes) -> None:
    """发送一条带 4 字节长度前缀的消息。"""
    if len(payload) > MAX_MESSAGE_SIZE:
        raise ValueError("消息过大")
    header = struct.pack("!I", len(payload))
    sock.sendall(header + payload)


def recv_message(sock: socket.socket) -> bytes:
    """接收一条带 4 字节长度前缀的消息。"""
    header = recv_exact(sock, HEADER_SIZE)
    (message_size,) = struct.unpack("!I", header)
    if message_size > MAX_MESSAGE_SIZE:
        raise ValueError(f"消息长度非法：{message_size}")
    return recv_exact(sock, message_size)
```

### 2. 为什么使用 !I

`struct.pack("!I", value)` 中：

- `!` 表示网络字节序，也就是大端序；
- `I` 表示 4 字节无符号整数。

网络协议应明确字节序，避免不同平台解释不一致。

### 3. 带协议的服务端

新建 `framed_server.py`：

```python
import json
import socket

from protocol import recv_message, send_message

HOST = "127.0.0.1"
PORT = 5001


def main() -> None:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind((HOST, PORT))
        server.listen()
        print(f"服务端已启动：{HOST}:{PORT}")

        conn, address = server.accept()
        with conn:
            print(f"客户端已连接：{address}")
            conn.settimeout(30)
            while True:
                try:
                    raw = recv_message(conn)
                except ConnectionError:
                    print("客户端已断开")
                    break
                except socket.timeout:
                    print("连接读取超时")
                    break

                request = json.loads(raw.decode("utf-8"))
                response = {
                    "ok": True,
                    "received": request,
                }
                payload = json.dumps(
                    response,
                    ensure_ascii=False,
                ).encode("utf-8")
                send_message(conn, payload)


if __name__ == "__main__":
    main()
```

### 4. 带协议的客户端

新建 `framed_client.py`：

```python
import json
import socket

from protocol import recv_message, send_message

HOST = "127.0.0.1"
PORT = 5001


def main() -> None:
    request = {
        "action": "echo",
        "message": "这是一条完整消息",
    }
    with socket.create_connection((HOST, PORT), timeout=5) as client:
        payload = json.dumps(
            request,
            ensure_ascii=False,
        ).encode("utf-8")
        send_message(client, payload)
        response = json.loads(recv_message(client).decode("utf-8"))
        print(response)


if __name__ == "__main__":
    main()
```

到这里已经具备一个应用层协议的基本形态：

- 明确消息边界；
- 明确字符编码；
- 明确序列化格式；
- 限制最大消息长度；
- 设置连接超时；
- 对断线进行处理。

---

## 第六站：TCP 连接的生命周期与半关闭

### 1. recv() 返回空字节意味着什么

```python
data = sock.recv(4096)
if not data:
    print("对端已关闭发送方向")
```

`b""` 不是"暂时没有数据"，而是对端已经正常关闭了发送方向，或者连接已走到 EOF。

### 2. shutdown() 与 close()

`close()` 释放 Socket；`shutdown()` 可以关闭连接的某个方向：

```python
import socket

sock.shutdown(socket.SHUT_WR)  # 不再发送，但仍可以接收
```

常见模式：客户端发送完请求后调用 `SHUT_WR`，告诉服务端"请求正文结束"，然后继续读取响应。

### 3. 必须设置超时

没有超时的阻塞调用可能永久等待——那晚卡死程野整个采集任务的，正是它：

```python
sock.settimeout(10)
```

之后 `connect()`、`recv()`、`send()` 等操作超过时限会抛出 `socket.timeout`。也可以创建连接时直接指定：

```python
import socket

with socket.create_connection(
    ("127.0.0.1", 5000),
    timeout=5,
) as sock:
    ...
```

生产环境通常要分别考虑：

- 连接超时；
- 读取超时；
- 写入超时；
- 整个请求的总超时；
- 空闲连接超时。

---

## 第七站：UDP 编程——无连接的数据报通信

UDP 不需要先建立连接，每次发送都是一份独立数据报。

### 1. UDP 服务端

新建 `udp_server.py`：

```python
import socket

HOST = "127.0.0.1"
PORT = 5002
BUFFER_SIZE = 65535


def main() -> None:
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as server:
        server.bind((HOST, PORT))
        print(f"UDP 服务端已启动：{HOST}:{PORT}")
        while True:
            data, address = server.recvfrom(BUFFER_SIZE)
            print(f"收到来自 {address} 的数据：{data!r}")
            server.sendto(b"ACK: " + data, address)


if __name__ == "__main__":
    main()
```

### 2. UDP 客户端

新建 `udp_client.py`：

```python
import socket

SERVER_ADDRESS = ("127.0.0.1", 5002)


def main() -> None:
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as client:
        client.settimeout(3)
        client.sendto("你好，UDP".encode("utf-8"), SERVER_ADDRESS)
        data, address = client.recvfrom(65535)
        print(f"收到 {address} 的回复：{data.decode('utf-8')}")


if __name__ == "__main__":
    main()
```

### 3. UDP 的重要特点

UDP 保留消息边界：一次 `sendto()` 对应一个数据报，接收端通过一次 `recvfrom()` 读取一个数据报。

但要注意：

- 数据报可能丢失；
- 数据报可能重复；
- 数据报可能乱序；
- 数据报过大时可能发生 IP 分片，丢失风险上升；
- `recvfrom()` 的缓冲区太小时，超出部分可能被截断。

如果业务需要可靠性，你需要在应用层补充：消息编号、ACK 确认、超时重传、去重、顺序重排、拥塞控制。

做到这一步时，也要重新评估：是不是直接使用 TCP 或成熟协议更合适。

---

## 第八站：为什么单线程服务端只能服务一个客户端

前面的 TCP 服务端在执行：

```python
conn, address = server.accept()
```

之后就进入该连接的 `recv()` 循环。只要这个客户端不退出，服务端就不会再次调用 `accept()`，其他客户端只能等待。

解决并发连接主要有三条路线：

1. 每个连接一个线程或进程；
2. 非阻塞 Socket + I/O 多路复用；
3. asyncio 异步 I/O。

程野接下来把三条路各走了一遍。

---

## 第九站：多线程 TCP 服务端

对于连接数不高、业务主要等待网络或数据库的场景，多线程简单直观。

### 1. 使用线程池处理连接

新建 `threaded_server.py`：

```python
import socket
from concurrent.futures import ThreadPoolExecutor

HOST = "127.0.0.1"
PORT = 5003
MAX_WORKERS = 20


def handle_client(conn: socket.socket, address: tuple[str, int]) -> None:
    print(f"客户端连接：{address}")
    with conn:
        conn.settimeout(60)
        while True:
            try:
                data = conn.recv(4096)
            except socket.timeout:
                print(f"客户端超时：{address}")
                return
            except ConnectionError as exc:
                print(f"连接异常 {address}：{exc}")
                return
            if not data:
                print(f"客户端断开：{address}")
                return
            conn.sendall(b"echo: " + data)


def main() -> None:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind((HOST, PORT))
        server.listen(128)
        print(f"多线程服务端已启动：{HOST}:{PORT}")
        with ThreadPoolExecutor(max_workers=MAX_WORKERS) as pool:
            while True:
                conn, address = server.accept()
                pool.submit(handle_client, conn, address)


if __name__ == "__main__":
    main()
```

### 2. 线程池比无限创建线程更稳妥

下面这种写法虽然简单，但连接一多就可能创建大量线程：

```python
import threading

threading.Thread(
    target=handle_client,
    args=(conn, address),
).start()
```

线程池可以限制并发数量，避免资源失控。

### 3. 多线程的适用场景

适合：

- 连接数从几十到几百；
- 每个连接逻辑清晰；
- 业务主要是 I/O 等待；
- 团队更重视可读性和开发速度。

需要注意：

- 共享变量要加锁或使用线程安全结构；
- 一个线程阻塞不会阻塞其他线程，但会占用线程资源；
- CPU 密集型工作不会因为多线程而线性提速；
- 一定要限制线程数、连接数和消息大小。

---

## 第十站：非阻塞 Socket 与 I/O 多路复用

阻塞 Socket 的行为是：没有数据时，`recv()` 就一直等待。

非阻塞 Socket 的行为是：没有数据时，立即抛出 `BlockingIOError`：

```python
sock.setblocking(False)
```

但我们不应该反复循环调用 `recv()` 碰运气，因为这会产生忙轮询并浪费 CPU。

正确做法是让操作系统通知我们：哪些 Socket 已经可读或可写。这就是 **I/O 多路复用**。Python 的 `selectors` 模块会根据平台选择合适的底层机制。

### 一个基于 selectors 的回显服务端

```python
import selectors
import socket

HOST = "127.0.0.1"
PORT = 5004

selector = selectors.DefaultSelector()


def accept_connection(server: socket.socket) -> None:
    conn, address = server.accept()
    print(f"客户端连接：{address}")
    conn.setblocking(False)
    selector.register(conn, selectors.EVENT_READ, read_from_client)


def read_from_client(conn: socket.socket) -> None:
    try:
        data = conn.recv(4096)
    except ConnectionError:
        data = b""
    if data:
        # 为了突出事件循环原理，这里只演示小数据回显。
        # 生产代码还需要处理非阻塞写入未完成的情况。
        try:
            conn.sendall(b"echo: " + data)
        except (BlockingIOError, ConnectionError):
            close_connection(conn)
    else:
        close_connection(conn)


def close_connection(conn: socket.socket) -> None:
    try:
        selector.unregister(conn)
    except Exception:
        pass
    conn.close()


def main() -> None:
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as server:
        server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        server.bind((HOST, PORT))
        server.listen()
        server.setblocking(False)
        selector.register(server, selectors.EVENT_READ, accept_connection)
        print(f"selectors 服务端已启动：{HOST}:{PORT}")
        try:
            while True:
                events = selector.select(timeout=1)
                for key, _mask in events:
                    callback = key.data
                    callback(key.fileobj)
        finally:
            selector.close()


if __name__ == "__main__":
    main()
```

这段代码展示了事件驱动的基本思想：

1. 把监听 Socket 和客户端 Socket 注册到选择器；
2. 调用 `selector.select()` 等待事件；
3. 某个 Socket 可读时，执行对应回调；
4. 一个线程即可管理多个连接。

不过，真正完善的非阻塞服务还要处理：每个连接独立的接收缓冲区、发送缓冲区，消息拆分与拼接，部分写入，可读/可写事件动态切换，超时和连接状态机。

这也是为什么现代 Python 项目通常更愿意使用 asyncio：它把这些底层细节封装成了更清晰的协程模型。

---

## 第十一站：使用 asyncio 编写高并发服务

asyncio 的核心是：

- 单线程事件循环；
- 协程；
- 遇到 I/O 等待时主动让出执行权；
- I/O 就绪后继续运行。

### 1. 异步 TCP 服务端

新建 `async_server.py`：

```python
import asyncio
import json

HOST = "127.0.0.1"
PORT = 5005
MAX_LINE_SIZE = 64 * 1024


async def handle_client(
    reader: asyncio.StreamReader,
    writer: asyncio.StreamWriter,
) -> None:
    peer = writer.get_extra_info("peername")
    print(f"客户端连接：{peer}")
    try:
        while True:
            # 使用换行符作为消息边界
            raw = await asyncio.wait_for(
                reader.readline(),
                timeout=60,
            )
            if not raw:
                break
            if len(raw) > MAX_LINE_SIZE:
                raise ValueError("消息过大")

            request = json.loads(raw.decode("utf-8"))
            response = {
                "ok": True,
                "echo": request,
            }
            writer.write(
                json.dumps(
                    response,
                    ensure_ascii=False,
                ).encode("utf-8") + b"\n"
            )
            # 等待发送缓冲区下降，形成背压
            await writer.drain()
    except asyncio.TimeoutError:
        print(f"客户端读取超时：{peer}")
    except (ConnectionError, json.JSONDecodeError, ValueError) as exc:
        print(f"客户端异常 {peer}：{exc}")
    finally:
        writer.close()
        await writer.wait_closed()
        print(f"客户端断开：{peer}")


async def main() -> None:
    server = await asyncio.start_server(
        handle_client,
        HOST,
        PORT,
        limit=MAX_LINE_SIZE,
    )
    addresses = ", ".join(str(sock.getsockname()) for sock in server.sockets or [])
    print(f"异步服务端已启动：{addresses}")
    async with server:
        await server.serve_forever()


if __name__ == "__main__":
    asyncio.run(main())
```

### 2. 异步 TCP 客户端

新建 `async_client.py`：

```python
import asyncio
import json

HOST = "127.0.0.1"
PORT = 5005


async def main() -> None:
    reader, writer = await asyncio.open_connection(HOST, PORT)
    try:
        for index in range(3):
            request = {
                "id": index,
                "message": f"第 {index + 1} 条消息",
            }
            writer.write(
                json.dumps(
                    request,
                    ensure_ascii=False,
                ).encode("utf-8") + b"\n"
            )
            await writer.drain()
            response = await asyncio.wait_for(
                reader.readline(),
                timeout=5,
            )
            print(json.loads(response.decode("utf-8")))
    finally:
        writer.close()
        await writer.wait_closed()


if __name__ == "__main__":
    asyncio.run(main())
```

### 3. await writer.drain() 为什么重要

`writer.write()` 只是把数据放进发送缓冲区。如果对端读取很慢，而程序持续写入，内存可能不断增长。

`await writer.drain()` 会在缓冲区压力过大时暂停当前协程，等待数据继续发送，这叫**背压**。

### 4. 不要在事件循环中执行阻塞代码

下面的代码会阻塞整个事件循环：

```python
import time


async def bad() -> None:
    time.sleep(5)
```

应改为：

```python
import asyncio


async def good() -> None:
    await asyncio.sleep(5)
```

如果必须调用阻塞函数，可以把它放到线程中：

```python
import asyncio


def blocking_io() -> str:
    return "result"


async def main() -> None:
    result = await asyncio.to_thread(blocking_io)
    print(result)
```

CPU 密集型任务则更适合进程池、任务队列或独立计算服务。

### 5. asyncio 适合什么场景

适合：

- 数千甚至更多长连接；
- 大量时间消耗在网络等待；
- WebSocket、消息推送、网关、爬虫、代理；
- 需要细粒度超时、取消和并发控制。

不适合盲目使用的场景：

- 业务非常简单、连接数很少；
- 依赖库大多是同步阻塞接口；
- 团队对异步调试和协程生命周期不熟悉；
- 主要瓶颈是 CPU，而不是 I/O。

---

## 第十二站：并发不等于无限并行——必须做流量控制

假设异步客户端需要同时请求 1 万个地址，直接创建 1 万个任务可能压垮本机、目标服务或网络。

可以使用信号量限制并发：

```python
import asyncio

semaphore = asyncio.Semaphore(100)


async def limited_request(host: str, port: int) -> bytes:
    async with semaphore:
        reader, writer = await asyncio.open_connection(host, port)
        try:
            writer.write(b"ping\n")
            await writer.drain()
            return await asyncio.wait_for(reader.readline(), timeout=3)
        finally:
            writer.close()
            await writer.wait_closed()
```

一个稳定系统通常要同时限制：

- 最大连接数；
- 单客户端连接数；
- 并发任务数；
- 每秒请求数；
- 单条消息大小；
- 接收和发送缓冲区；
- 队列长度；
- 请求执行时间。

---

## 第十三站：HTTP 网络编程

HTTP 本质上也是应用层协议。多数情况下，我们不需要手写 TCP 报文，而应使用成熟 HTTP 客户端或 Web 框架。

### 1. 使用标准库发送 HTTP GET 请求

```python
import json
from urllib.request import Request, urlopen

request = Request(
    "https://httpbin.org/get",
    headers={"User-Agent": "Python-Network-Demo/1.0"},
)
with urlopen(request, timeout=5) as response:
    body = response.read()
    data = json.loads(body.decode("utf-8"))
print(data)
```

需要注意：

- 一定设置超时——程野那晚的教训；
- 检查状态码；
- 限制响应体大小；
- 对重试设置次数和退避；
- 不要对所有错误无脑重试；
- 复用连接可以明显减少延迟。

### 2. 用标准库启动一个简单 HTTP 服务

```python
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer

HOST = "127.0.0.1"
PORT = 8000


class Handler(BaseHTTPRequestHandler):
    def do_GET(self) -> None:
        body = "Hello from Python HTTP Server!".encode("utf-8")
        self.send_response(200)
        self.send_header("Content-Type", "text/plain; charset=utf-8")
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)


if __name__ == "__main__":
    server = ThreadingHTTPServer((HOST, PORT), Handler)
    print(f"HTTP 服务已启动：http://{HOST}:{PORT}")
    server.serve_forever()
```

`http.server` 很适合学习、临时文件服务和本地调试，但不应直接作为高负载生产 Web 服务。生产项目通常使用成熟框架和服务器，例如同步 WSGI 或异步 ASGI 技术栈。

---

## 第十四站：TLS——给 TCP 通信加密

明文 TCP 中，链路上的观察者可能读取或篡改数据。TLS 可以提供：

- 传输加密；
- 数据完整性校验；
- 服务端身份验证；
- 可选的客户端证书验证。

### 1. TLS 客户端示例

下面直接使用标准库建立 TLS 连接，并发送一个最小 HTTP 请求：

```python
import socket
import ssl

hostname = "example.com"

context = ssl.create_default_context()
with socket.create_connection((hostname, 443), timeout=5) as raw_sock:
    with context.wrap_socket(
        raw_sock,
        server_hostname=hostname,
    ) as tls_sock:
        request = (
            "GET / HTTP/1.1\r\n"
            f"Host: {hostname}\r\n"
            "Connection: close\r\n"
            "\r\n"
        ).encode("ascii")
        tls_sock.sendall(request)

        chunks: list[bytes] = []
        while True:
            chunk = tls_sock.recv(4096)
            if not chunk:
                break
            chunks.append(chunk)

response = b"".join(chunks)
print(response.decode("utf-8", errors="replace"))
```

关键点：

- 使用 `ssl.create_default_context()`；
- 传入 `server_hostname`，用于证书主机名校验和 SNI；
- **不要为了"解决证书报错"而关闭证书验证**；
- 生产环境应正确管理证书、私钥和续期。

### 2. TLS 不是业务安全的全部

即使使用 TLS，也仍然需要：身份认证、权限控制、防重放设计、请求签名或 Token、速率限制、审计日志、敏感数据脱敏。

---

## 第十五站：实战项目——异步多人聊天室

学了这么多，程野决定用一个可运行的聊天室把知识串起来：多个客户端同时连接；用户进入时广播通知；用户发送消息时广播给其他人；用户离开时自动清理连接；使用换行符划分消息边界；对用户名和消息长度做限制。

### 1. 聊天室服务端

新建 `chat_server.py`：

```python
import asyncio

HOST = "127.0.0.1"
PORT = 6000
MAX_NAME_LENGTH = 30
MAX_MESSAGE_LENGTH = 2000

# 在单线程事件循环中维护，避免了普通线程之间的数据竞争。
clients: dict[asyncio.StreamWriter, str] = {}


async def send_line(
    writer: asyncio.StreamWriter,
    message: str,
) -> None:
    writer.write(message.encode("utf-8") + b"\n")
    await writer.drain()


async def broadcast(
    message: str,
    exclude: asyncio.StreamWriter | None = None,
) -> None:
    dead_clients: list[asyncio.StreamWriter] = []
    for writer in list(clients):
        if writer is exclude:
            continue
        try:
            await send_line(writer, message)
        except ConnectionError:
            dead_clients.append(writer)
    for writer in dead_clients:
        clients.pop(writer, None)
        writer.close()


async def handle_client(
    reader: asyncio.StreamReader,
    writer: asyncio.StreamWriter,
) -> None:
    peer = writer.get_extra_info("peername")
    username = "匿名用户"
    try:
        await send_line(writer, "请输入用户名：")
        raw_name = await asyncio.wait_for(reader.readline(), timeout=30)
        if not raw_name:
            return
        username = raw_name.decode("utf-8").strip()
        if not username or len(username) > MAX_NAME_LENGTH:
            await send_line(writer, "用户名无效，连接关闭。")
            return

        clients[writer] = username
        await send_line(writer, f"欢迎你，{username}！输入 /quit 退出。")
        await broadcast(f"[系统] {username} 进入了聊天室。", exclude=writer)

        while True:
            raw = await reader.readline()
            if not raw:
                break
            message = raw.decode("utf-8").rstrip("\r\n")
            if message == "/quit":
                break
            if not message:
                continue
            if len(message) > MAX_MESSAGE_LENGTH:
                await send_line(writer, "消息过长，已拒绝发送。")
                continue
            await broadcast(f"[{username}] {message}", exclude=writer)

    except asyncio.TimeoutError:
        print(f"客户端登录超时：{peer}")
    except (UnicodeDecodeError, ConnectionError) as exc:
        print(f"客户端异常 {peer}：{exc}")
    finally:
        was_logged_in = writer in clients
        clients.pop(writer, None)
        writer.close()
        try:
            await writer.wait_closed()
        except ConnectionError:
            pass
        if was_logged_in:
            await broadcast(f"[系统] {username} 离开了聊天室。")
        print(f"连接关闭：{peer}")


async def main() -> None:
    server = await asyncio.start_server(
        handle_client,
        HOST,
        PORT,
        limit=MAX_MESSAGE_LENGTH * 4,
    )
    print(f"聊天室服务端已启动：{HOST}:{PORT}")
    async with server:
        await server.serve_forever()


if __name__ == "__main__":
    asyncio.run(main())
```

### 2. 聊天室客户端

新建 `chat_client.py`：

```python
import asyncio

HOST = "127.0.0.1"
PORT = 6000


async def receive_messages(reader: asyncio.StreamReader) -> None:
    while True:
        data = await reader.readline()
        if not data:
            print("与服务端的连接已关闭。")
            return
        print(data.decode("utf-8").rstrip())


async def send_messages(writer: asyncio.StreamWriter) -> None:
    while True:
        # input() 是阻塞函数，放到线程中执行，避免阻塞事件循环。
        message = await asyncio.to_thread(input)
        writer.write(message.encode("utf-8") + b"\n")
        await writer.drain()
        if message == "/quit":
            return


async def main() -> None:
    reader, writer = await asyncio.open_connection(HOST, PORT)
    receiver = asyncio.create_task(receive_messages(reader))
    sender = asyncio.create_task(send_messages(writer))

    done, pending = await asyncio.wait(
        {receiver, sender},
        return_when=asyncio.FIRST_COMPLETED,
    )
    for task in pending:
        task.cancel()
    await asyncio.gather(*pending, return_exceptions=True)

    for task in done:
        exception = task.exception()
        if exception:
            print(f"任务异常：{exception}")

    writer.close()
    await writer.wait_closed()


if __name__ == "__main__":
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        pass
```

### 3. 运行方式

先启动服务端：

```bash
python chat_server.py
```

再打开多个终端，分别启动客户端：

```bash
python chat_client.py
```

### 4. 这个项目还可以怎样升级

可以继续增加：房间和频道、私聊、登录认证、消息持久化、离线消息、心跳与空闲连接清理、JSON 消息协议、WebSocket 网关、敏感词过滤、限流与封禁、多实例部署和消息中间件。

一个"玩具聊天室"升级为"生产消息系统"的过程，本质上就是不断补齐协议、状态、安全、可靠性和可观测性。

为了保持示例清晰，聊天室的广播逻辑按客户端依次发送。生产环境应为每个连接设置独立发送队列和写入超时，并及时断开持续阻塞的慢客户端，避免一个连接拖慢所有广播。

---

## 第十六站：心跳、重连与连接保活

长连接系统常见三个问题：

1. 对端程序已经崩溃，但本端暂时不知道；
2. NAT、代理或防火墙清理空闲连接；
3. 网络短暂中断后需要自动恢复。

### 1. 应用层心跳

可以约定：

```
客户端每 30 秒发送 PING
服务端回复 PONG
连续多次未收到响应则断开
```

心跳消息同样应该走正式的消息协议，而不是随意插入字节流。

### 2. TCP Keepalive

操作系统也提供 TCP Keepalive，但默认探测周期可能较长，而且不同平台配置方式不同。它适合发现"连接已经失效"，但不能完全替代业务层心跳。

### 3. 指数退避重连

断线后不要立即无限快速重连。可以采用指数退避：

```python
import asyncio
import random


async def reconnect_forever() -> None:
    delay = 1.0
    while True:
        try:
            reader, writer = await asyncio.open_connection(
                "127.0.0.1",
                6000,
            )
            print("连接成功")
            delay = 1.0
            # 在此进入正常通信逻辑
            writer.close()
            await writer.wait_closed()
        except OSError as exc:
            jitter = random.uniform(0, delay * 0.2)
            print(f"连接失败：{exc}，稍后重试")
            await asyncio.sleep(delay + jitter)
            delay = min(delay * 2, 30.0)
```

加入随机抖动可以减少大量客户端同时重连造成的"惊群"。

---

## 第十七站：域名解析与 IPv6

### 1. 不要假设一个域名只有一个 IP

域名可能解析到多个 IPv4 或 IPv6 地址。可以使用 `getaddrinfo()` 获取候选地址：

```python
import socket

results = socket.getaddrinfo(
    "example.com",
    443,
    type=socket.SOCK_STREAM,
)
for family, socktype, proto, canonname, sockaddr in results:
    print(family, socktype, proto, canonname, sockaddr)
```

`socket.create_connection()` 会帮助你尝试可用地址，因此通常比手动创建并连接 Socket 更方便。

### 2. IPv6 Socket

```python
import socket

with socket.socket(socket.AF_INET6, socket.SOCK_STREAM) as server:
    server.bind(("::1", 7000))
    server.listen()
```

生产服务是否同时支持 IPv4 和 IPv6，需要结合操作系统、容器网络、云平台和负载均衡配置验证，不能只看本地代码。

---

## 第十八站：常见异常与排查思路

### 1. ConnectionRefusedError

含义：目标地址可达，但端口没有服务监听，或连接被明确拒绝。

检查：

- 服务端是否启动；
- IP 和端口是否正确；
- 服务端是否只监听 127.0.0.1；
- 容器端口是否映射；
- 防火墙和安全组是否放行。

### 2. socket.timeout 或 TimeoutError

含义：连接、读取或写入超过设定时限。

检查：

- 目标服务是否响应缓慢；
- 超时是否过短；
- 是否发生网络丢包；
- 服务端线程池、连接池或队列是否耗尽；
- 是否在等待一条永远不会结束的消息。

### 3. ConnectionResetError

含义：连接被对端或中间设备异常重置。

常见原因：

- 对端进程崩溃；
- 对端强制关闭；
- 协议错误；
- 代理或负载均衡器清理连接；
- 向已失效连接继续写入。

### 4. BrokenPipeError

通常表示你正在向已经被对端关闭的连接发送数据。

处理原则：记录必要上下文、清理资源，不要把它当成可以无条件重试的错误。

### 5. OSError: Address already in use

端口已被占用，或者旧连接仍处于相关状态。可以：

- 查找占用端口的进程；
- 换一个端口；
- 服务端启用 SO_REUSEADDR；
- 确认是否启动了多个实例。

### 6. 中文乱码或 UnicodeDecodeError

检查：

- 双方是否统一使用 UTF-8；
- 是否把不完整的一段字节提前解码；
- 是否把二进制数据误当文本；
- 消息边界是否正确。

对流式数据，先按协议拼出完整消息，再进行解码和 JSON 解析。

---

## 第十九站：网络调试工具箱

网络问题不应只靠 `print()`。

### 1. 查看监听端口

Linux/macOS 常用：

```bash
lsof -i :5000
```

或：

```bash
ss -lntp
```

Windows 可使用：

```bash
netstat -ano | findstr :5000
```

### 2. 测试 TCP 端口

```bash
nc -vz 127.0.0.1 5000
```

也可以直接用 nc 连接文本协议：

```bash
nc 127.0.0.1 5000
```

### 3. 调试 HTTP

```bash
curl -v http://127.0.0.1:8000/
```

`-v` 可以显示请求头、响应头和连接过程。

### 4. 查看域名解析

```bash
nslookup example.com
```

或：

```bash
dig example.com
```

### 5. 抓包

Linux/macOS 可以使用 tcpdump：

```bash
sudo tcpdump -i any port 5000
```

图形化分析可以使用 Wireshark。

抓包时重点关注：

- TCP 三次握手是否成功；
- 谁先发送 FIN 或 RST；
- 是否发生重传；
- 应用层数据是否符合协议；
- TLS 握手在哪一步失败。

---

## 第二十站：如何测试网络代码

网络代码也必须可测试。

### 1. 使用 socket.socketpair() 做本地协议测试

`socketpair()` 可以创建一对互相连接的 Socket，不需要真实监听端口：

```python
import socket

from protocol import recv_message, send_message


def test_message_round_trip() -> None:
    left, right = socket.socketpair()
    try:
        payload = "测试消息".encode("utf-8")
        send_message(left, payload)
        assert recv_message(right) == payload
    finally:
        left.close()
        right.close()
```

### 2. 应该重点测试什么

至少覆盖：

- 空消息；
- 最大合法消息；
- 超过上限的消息；
- 头部被拆成多次到达；
- 正文被拆成多次到达；
- 多条消息连续到达；
- 非法编码；
- 对端提前断开；
- 读写超时；
- 并发连接；
- 慢客户端；
- 服务端关闭时的资源清理。

### 3. 不要只测"理想网络"

真实网络会出现：延迟、抖动、丢包、乱序、带宽限制、短暂断网、DNS 故障、中间代理超时。

在测试环境中模拟这些情况，往往比继续阅读更多 API 文档更能提升网络编程能力。

---

## 第二十一站：性能优化——先测量，再优化

网络程序的瓶颈可能在完全不同的位置：DNS 解析、TCP/TLS 建连、网络往返延迟、序列化与反序列化、数据库、锁竞争、日志写入、CPU 计算、内存复制、下游服务。

### 1. 常见优化方向

**复用连接**：频繁建立 TCP 和 TLS 连接成本较高。HTTP 连接池、数据库连接池和长连接都能减少建连开销。

**批量传输**：大量小消息会增加系统调用和协议开销。可在可接受延迟内适当批量发送。

**设置背压**：下游变慢时，上游不能无限写入内存队列。

**避免无界队列**：无界队列通常只是把"服务变慢"推迟成"进程内存耗尽"。

**减少重复编码**：同一份广播内容可以只编码一次，再发送给多个客户端。

**隔离 CPU 密集任务**：压缩、加密、图片处理、大模型推理等任务不应长期占用事件循环。

**合理使用超时和熔断**：故障下游如果长期占用连接和任务，会形成级联故障。

### 2. 建议关注的指标

- 当前连接数；
- 新建连接速率；
- 请求吞吐量；
- P50、P95、P99 延迟；
- 超时率和错误率；
- 入站/出站字节数；
- 事件循环延迟；
- 线程池或连接池使用率；
- 队列长度；
- 内存和 CPU；
- 重连、重试和拒绝数量。

平均延迟看起来正常，不代表用户体验正常。高分位延迟往往更能暴露排队、抖动和下游故障。

---

## 第二十二站：网络编程安全清单

网络服务天然面对不可信输入。至少做到以下几点：

### 1. 限制输入

- 限制单条消息长度；
- 限制请求头和正文大小；
- 限制嵌套深度和字段数量；
- 限制上传文件大小；
- 对枚举值、数字范围和字符串格式做验证。

### 2. 设置超时

防止客户端建立连接后长期不发送完整数据，也就是慢速连接攻击。

### 3. 认证与授权分开

- 认证回答"你是谁"；
- 授权回答"你能做什么"。

登录成功不代表可以访问所有资源。

### 4. 使用 TLS

不要在明文连接中传输密码、Token、Cookie、个人信息和业务机密。

### 5. 做好限流

可以按以下维度限流：IP、用户、API Key、设备、路由、全局服务容量。

### 6. 谨慎记录日志

不要把密码、完整 Token、私钥、银行卡号、身份证号等敏感数据写入日志。

### 7. 不信任反序列化数据

- 不对不可信数据使用 `pickle.loads()`；
- JSON 解析后仍然要做 Schema 校验；
- 不把网络输入直接拼接到 Shell、SQL 或文件路径中。

### 8. 优雅关闭

服务停止时应：

1. 停止接收新连接；
2. 给正在处理的请求一定完成机会；
3. 关闭空闲连接；
4. 取消超时任务；
5. 刷新必要日志和指标；
6. 最终释放 Socket。

---

## 第二十三站：多线程、selectors 和 asyncio 怎么选

| 方案 | 优点 | 缺点 | 适用场景 |
| --- | --- | --- | --- |
| 单线程阻塞 | 最简单、易理解 | 一次只能处理少量连接 | 教学、一次性脚本 |
| 多线程/线程池 | 编码直观、兼容同步库 | 线程有资源成本，共享状态复杂 | 中等并发、I/O 型业务 |
| 多进程 | 可利用多核、故障隔离较好 | 进程间通信和资源成本更高 | CPU 型任务、多个工作进程 |
| selectors | 高性能、接近底层 | 状态机和缓冲区管理复杂 | 框架、基础设施、学习底层原理 |
| asyncio | 高并发、超时取消清晰 | 不能阻塞事件循环，异步生态有学习成本 | 长连接、网关、爬虫、实时服务 |

选择时不要只看"能支持多少连接"，还要考虑：

- 团队经验；
- 依赖库是否异步；
- 业务是 I/O 密集还是 CPU 密集；
- 是否需要长连接；
- 运维和调试能力；
- 复杂度是否值得。

---

## 第二十四站：从入门到精通的学习路线

### 第一阶段：掌握基础

完成以下目标：

- 理解 IP、端口、TCP、UDP；
- 会写阻塞式 TCP/UDP 客户端和服务端；
- 理解字符串与字节；
- 会设置超时并处理断线；
- 能使用 curl、nc、lsof 等工具。

### 第二阶段：掌握协议设计

重点学习：消息边界；长度前缀；JSON 和二进制协议；请求 ID；状态码；心跳；幂等性；重试与去重。

### 第三阶段：掌握并发

分别实现：线程池服务端；selectors 服务端；asyncio 服务端；并发压测客户端。

通过对比理解三种模型，而不是只记 API。

### 第四阶段：掌握工程化

补齐：日志；配置；指标；链路追踪；限流；熔断；优雅关闭；单元测试与集成测试；容器化与部署。

### 第五阶段：深入协议与系统

进一步学习：

- HTTP/1.1、HTTP/2、HTTP/3；
- TLS 握手和证书体系；
- WebSocket；
- DNS；
- 代理和负载均衡；
- NAT 与防火墙；
- TCP 拥塞控制；
- 分布式系统中的超时、重试、幂等和一致性。

---

## 第二十五站：一份可直接使用的代码审查清单

提交网络代码前，逐项检查：

- 是否明确使用 TCP 还是 UDP；
- 是否定义了消息边界；
- 是否统一字符编码；
- 是否限制消息大小；
- 是否设置连接和读取超时；
- 是否正确处理 `recv()` 返回 `b""`；
- 是否处理部分读取和部分写入；
- 是否避免在事件循环中执行阻塞操作；
- 是否限制线程数、连接数和并发数；
- 是否实现背压；
- 是否正确清理 Socket、任务和线程；
- 是否避免反序列化不可信 pickle；
- 是否使用 TLS 保护敏感数据；
- 是否避免日志泄露敏感信息；
- 是否测试断线、超时、慢客户端和大消息；
- 是否具备必要的指标和错误日志；
- 重试是否有上限、退避和随机抖动；
- 服务是否支持优雅关闭。

---

一个月后，又是那个采集任务。这一次，两千个站点在异步服务里并发跑着，每个请求带着超时和退避重试，进度条稳定地向前爬。凌晨三点，某个站点又没响应了——但这一次，脚本只是记下一条错误日志，把连接让给了下一个站点，然后在一小时后自动重试成功。

早上八点，客户看到的进度是：2000/2000。

程野想起一个月前那个被卡死在 37/2000 的夜晚。变的不是网络，还是那张网络——变的是他终于学会了和网络的不确定性打交道：每一次 `recv()` 在等什么、每一条消息如何结束、连接为什么会断、系统如何避免被慢客户端拖垮。

Python 网络编程真正的分水岭，不是会不会调用 `socket.connect()`，而是能否处理现实网络中的不确定性。从阻塞 Socket 入门，是为了理解连接和字节流；学习消息协议，是为了可靠地表达业务；掌握并发和异步，是为了管理更多连接；补齐超时、背压、安全和可观测性，才是从"能运行"走向"可上线"。

正如那句写在萤火矩阵工位上的话：

> "网络编程的功夫，一半在收发字节，一半在等待与超时之间。"

## 参考资料 / 官方延伸阅读

- [socket — Python 官方文档](https://docs.python.org/zh-cn/3/library/socket.html)
- [asyncio — Python 官方文档](https://docs.python.org/zh-cn/3/library/asyncio.html)
- [selectors — Python 官方文档](https://docs.python.org/zh-cn/3/library/selectors.html)
- [ssl — Python 官方文档](https://docs.python.org/zh-cn/3/library/ssl.html)
- [struct — Python 官方文档](https://docs.python.org/zh-cn/3/library/struct.html)
- [urllib.request — Python 官方文档](https://docs.python.org/zh-cn/3/library/urllib.request.html)
- [http.server — Python 官方文档](https://docs.python.org/zh-cn/3/library/http.server.html)
- [Beej's Guide to Network Programming](https://beej.us/guide/bgnet/)

> 版本提示：本文示例基于 Python 3.10+（使用了 `asyncio.to_thread`、内建泛型标注等特性）。旧版本运行时可能需要调整类型标注和部分 API 用法。
