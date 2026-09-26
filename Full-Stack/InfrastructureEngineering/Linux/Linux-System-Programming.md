# [Linux系统编程从入门到精通：从系统调用到高性能服务器](https://mp.weixin.qq.com/s/LO7pBXfyQrrxCEM6-OYAXA)

> 这是一个关于"纪云舒"的故事——一个在"极目科技"写了两三年业务代码的后端工程师。一次线上事故让她发现：自己会调框架、会写 SQL，却看不懂一个跑飞了的进程——文件句柄为什么泄漏、子进程为什么会变僵尸、日志为什么丢、`epoll` 到底强在哪。导师对她说："你一直在用别人造好的轮子，这次我们把它拆开看看。"你会跟着纪云舒一起，从第一个系统调用出发，把文件 I/O、进程、线程、信号、IPC、内存管理和 Socket 网络编程一条条打通，最后亲手写出一个简化版 Shell 和一个高性能并发服务器。读完之后你会发现：系统编程不是炫技，而是理解程序与操作系统之间每一字节的来龙去脉。

---

## 故事的起点：一个看不懂的僵尸进程

极目科技是一家做实时数据采集的公司，后端是一组常驻的采集守护进程。纪云舒入职的第三个月，接手了一个没人愿意碰的老模块——然后它出了事：

- 监控告警：采集服务进程数异常，`ps` 一看，几十个 `<defunct>` 的僵尸进程挂在进程表里；
- 日志文件隔几天就"不再更新"，但进程明明还活着；
- 半夜磁盘告警，`lsof` 一查，进程打开了上万个没关闭的文件描述符。

纪云舒盯着 `top` 和 `ps` 的输出，第一次意识到：她会用这些命令，却完全不明白它们背后发生了什么。僵尸是怎么产生的？文件描述符为什么会漏？父进程退出后子进程去了哪里？她一个都答不上来。

第二天，导师把她叫到白板前，画了一条从应用程序到内核的线：

> "框架和中间件把系统调用都包起来了，所以你平时感觉不到它们的存在。但出了这种问题，你得能穿透封装，直接跟操作系统对话。接下来两个月，你把 Linux 系统编程从头学一遍——就用你们这个采集服务当教材。"

纪云舒给自己定了目标：**两个月，从"会调 API"学到"能亲手写一个高性能采集服务"。**

下面这个故事，就是她走完的路线图。

---

很多开发者学习 Linux，往往从命令行开始：`ls`、`cd`、`grep`、`ps`、`top`、`chmod`……

这些命令当然重要，但它们只是 Linux 世界的入口。

真正理解 Linux，需要继续向下走一层：文件是如何读写的？进程是如何创建的？线程为什么会发生竞争？信号怎样打断程序？管道、共享内存和 Socket 又是如何工作的？

这些问题共同指向一个领域——**Linux 系统编程**。

系统编程并不等于编写操作系统内核。它通常是指：在用户态程序中，通过 Linux 提供的系统调用和底层接口，直接管理文件、进程、线程、内存、网络和设备。

如果说普通应用开发关注“业务逻辑”，那么系统编程关注的是：

- 程序如何与操作系统交互；

- 数据如何在内存、磁盘和网络之间流动；

- 多个进程和线程如何协同工作；

- 如何写出高性能、高可靠、可调试的底层程序。
本文将带你从基础概念出发，逐步建立一套完整的 Linux 系统编程知识体系。

## 一、什么是 Linux 系统编程
Linux 应用程序通常运行在**用户态**，操作系统内核运行在**内核态**。

用户程序不能直接操作磁盘、网卡、物理内存等硬件资源。当程序需要打开文件、创建进程、申请内存或发送网络数据时，必须向内核发出请求。

这个请求入口就是**系统调用**。

常见系统调用包括：

```
open()
read()
write()
close()
fork()
execve()
wait()
mmap()
socket()
connect()
accept()
```
从程序结构上看，大致可以理解为：

```
应用程序
↓
C 标准库 / glibc
↓
系统调用
↓
Linux 内核
↓
CPU、内存、磁盘、网卡等硬件
```
需要注意的是，C 标准库函数不一定等于系统调用。

例如：

```
printf("Hello\n");
```
`printf()` 是标准库函数，它通常会先把内容写入用户态缓冲区，之后再通过 `write()` 系统调用交给内核。

理解“库函数”和“系统调用”的区别，是学习 Linux 系统编程的第一步。

## 二、搭建系统编程开发环境
推荐使用 Linux 原生环境、虚拟机、云服务器或 WSL。

安装常用开发工具：

```
sudo apt update
sudo apt install build-essential gcc gdb make cmake \
strace ltrace valgrind manpages-dev
```
查看 GCC 版本：

```
gcc --version
```
创建第一个程序：

```
#include <stdio.h>

int main(void)
{
printf("Hello, Linux System Programming!\n");
return 0;
}
```
编译：

```
gcc hello.c -o hello
```
运行：

```
./hello
```
建议从一开始就打开编译警告：

```
gcc -Wall -Wextra -Werror -g hello.c -o hello
```
这些参数的含义：

- `-Wall`：开启常见警告；

- `-Wextra`：开启更多警告；

- `-Werror`：把警告当作错误；

- `-g`：生成调试信息，便于 GDB 调试。
系统编程越接近底层，越要重视编译器警告。很多崩溃、越界和未定义行为，都能在编译阶段提前发现。

## 三、理解系统调用、错误码与 errno
Linux 系统调用失败时，通常会返回 `-1`，并设置全局错误标志 `errno`。

例如打开文件：

```
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int main(void)
{
int fd = open("data.txt", O_RDONLY);

if (fd == -1) {
perror("open");
exit(EXIT_FAILURE);
}

close(fd);
return 0;
}
```
如果文件不存在，程序可能输出：

```
open: No such file or directory
```
常见错误处理方式有两种：

```
perror("open");
```
或者：

```
#include <errno.h>
#include <string.h>

fprintf(stderr, "open failed: %s\n", strerror(errno));
```
常见错误码包括：

| 错误码 | 含义 |
| --- | --- |
| ENOENT | 文件或目录不存在 |
| EACCES | 权限不足 |
| EBADF | 文件描述符无效 |
| EINTR | 系统调用被信号中断 |
| EAGAIN | 资源暂时不可用 |
| ENOMEM | 内存不足 |
| EPIPE | 管道读取端已关闭 |

底层程序不能只写“正常路径”，还要认真设计失败路径。

成熟的系统程序至少需要考虑：

- 1. 系统调用失败怎么办；

- 2. 资源是否正确释放；

- 3. 调用是否可能被信号中断；

- 4. 是否可能发生短读或短写；

- 5. 多线程下错误处理是否安全。

## 四、文件描述符：Linux I/O 的核心抽象
Linux 中有一句经典的话：

一切皆文件。

普通文件、终端、管道、Socket、设备，都可以通过类似的接口进行读写。

程序打开一个对象后，内核会返回一个非负整数，这个整数称为**文件描述符**，英文为 File Descriptor，简称 FD。

每个进程启动时通常已经打开三个文件描述符：

| 文件描述符 | 名称 | 默认对象 |
| --- | --- | --- |
| 0 | 标准输入 stdin | 键盘 |
| 1 | 标准输出 stdout | 终端 |
| 2 | 标准错误 stderr | 终端 |

因此：

```
write(1, "Hello\n", 6);
```
表示直接向标准输出写入数据。

### 1. open、read、write、close
一个最基础的文件复制程序：

```
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define BUFFER_SIZE 4096

int main(int argc, char *argv[])

{

if (argc != 3) {

fprintf(stderr, "Usage: %s <src> <dst>\n", argv[0]);

return EXIT_FAILURE;

}

int src_fd = open(argv[1], O_RDONLY);

if (src_fd == -1) {

perror("open source");

return EXIT_FAILURE;

}

int dst_fd = open(

argv[2],

O_WRONLY | O_CREAT | O_TRUNC,

0644

);

if (dst_fd == -1) {

perror("open destination");

close(src_fd);

return EXIT_FAILURE;

}

char buffer[BUFFER_SIZE];

for (;;) {

ssize_t nread = read(src_fd, buffer, sizeof(buffer));

if (nread == 0) {

break;

}

if (nread == -1) {

if (errno == EINTR) {

continue;

}

perror("read");

close(src_fd);

close(dst_fd);

return EXIT_FAILURE;

}

ssize_t offset = 0;

while (offset < nread) {

ssize_t nwritten = write(

dst_fd,

buffer + offset,

(size_t)(nread - offset)

);

if (nwritten == -1) {

if (errno == EINTR) {

continue;

}

perror("write");

close(src_fd);

close(dst_fd);

return EXIT_FAILURE;

}

offset += nwritten;

}

}

close(src_fd);

close(dst_fd);

return EXIT_SUCCESS;

}
```
这个例子包含系统编程中几个非常重要的细节：

- `read()` 不保证一次读满缓冲区；

- `write()` 不保证一次写完全部数据；

- 系统调用可能因为信号返回 `EINTR`；

- 打开的文件描述符必须关闭；

- 失败路径也要释放已经获得的资源。

### 2. 文件打开标志
`open()` 常见标志包括：

| 标志 | 说明 |
| --- | --- |
| O_RDONLY | 只读 |
| O_WRONLY | 只写 |
| O_RDWR | 读写 |
| O_CREAT | 文件不存在时创建 |
| O_TRUNC | 清空原文件 |
| O_APPEND | 追加写入 |
| O_NONBLOCK | 非阻塞模式 |
| O_CLOEXEC | 执行新程序时自动关闭 |

创建文件时还需要指定权限：

```
open("log.txt", O_WRONLY | O_CREAT, 0644);
```
`0644` 表示：

```
文件所有者：读、写

同组用户：读

其他用户：读
```
实际权限还会受到 `umask` 的影响。

## 五、文件偏移、随机访问与元数据

### 1. lseek
`lseek()` 可以修改文件偏移量，实现随机读写。

```
off_t pos = lseek(fd, 0, SEEK_END);
```
常见位置参数：

- `SEEK_SET`：相对文件开头；

- `SEEK_CUR`：相对当前位置；

- `SEEK_END`：相对文件末尾。
获取文件大小：

```
off_t size = lseek(fd, 0, SEEK_END);
```
但要注意，管道和 Socket 不支持 `lseek()`。

### 2. stat
`stat()` 用于获取文件元数据：

```
#include <sys/stat.h>

struct stat st;

if (stat("data.txt", &st) == -1) {

perror("stat");

}
```
`struct stat` 中常见字段：

```
st.st_size; // 文件大小

st.st_mode; // 文件类型和权限

st.st_uid; // 所有者用户 ID

st.st_gid; // 所属组 ID

st.st_mtime; // 最后修改时间
```
判断文件类型：

```
if (S_ISREG(st.st_mode)) {

printf("regular file\n");

}

if (S_ISDIR(st.st_mode)) {

printf("directory\n");

}
```

### 3. 目录操作
遍历目录通常使用：

```
opendir()

readdir()

closedir()
```
示例：

```
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>

int main(void)

{

DIR *dir = opendir(".");

if (dir == NULL) {

perror("opendir");

return EXIT_FAILURE;

}

struct dirent *entry;

while ((entry = readdir(dir)) != NULL) {

printf("%s\n", entry->d_name);

}

closedir(dir);

return EXIT_SUCCESS;

}
```
基于这些接口，可以实现简化版 `ls`、目录扫描器、文件索引器和备份工具。

## 六、标准 I/O 与系统 I/O 的区别
C 标准库提供：

```
fopen()

fread()

fwrite()

fclose()

fprintf()

fgets()
```
Linux 系统调用提供：

```
open()

read()

write()

close()
```
二者最大的区别之一是：**标准 I/O 通常带有用户态缓冲区**。

标准 I/O 的优势：

- 使用方便；

- 适合文本处理；

- 减少系统调用次数；

- 跨平台性更好。
系统 I/O 的优势：

- 控制更直接；

- 可操作 Socket、管道和设备；

- 适合非阻塞 I/O；

- 更方便与 `select`、`poll`、`epoll` 配合。
混用两套接口时要非常谨慎。

例如同时对一个文件描述符使用 `read()` 和 `fread()`，可能因为缓冲区状态不同而得到意外结果。

## 七、进程：Linux 程序运行的基本单位
进程可以理解为“正在运行的程序实例”。

一个进程通常拥有：

- 独立虚拟地址空间；

- 代码段、数据段、堆和栈；

- 文件描述符表；

- 进程 ID；

- 用户和权限信息；

- 信号处理状态；

- 调度信息。
获取当前进程 ID：

```
#include <stdio.h>
#include <unistd.h>

int main(void)

{

printf("PID: %d\n", getpid());

printf("PPID: %d\n", getppid());

return 0;

}
```

### 1. fork：创建子进程

```
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

int main(void)

{

pid_t pid = fork();

if (pid == -1) {

perror("fork");

return EXIT_FAILURE;

}

if (pid == 0) {

printf("child: pid=%d\n", getpid());

} else {

printf("parent: child pid=%d\n", pid);

}

return EXIT_SUCCESS;

}
```
`fork()` 调用一次，却会返回两次：

- 在父进程中返回子进程 PID；

- 在子进程中返回 `0`；

- 失败时返回 `-1`。
`fork()` 之后，父子进程拥有逻辑上独立的地址空间。

现代 Linux 一般使用**写时复制**机制。刚创建时，父子进程可以共享相同物理页；只有某一方修改内存时，内核才复制对应页面。

### 2. exec：加载新程序
`fork()` 创建子进程后，常常配合 `exec` 系列函数运行另一个程序。

```
execlp("ls", "ls", "-l", NULL);
```
如果 `exec` 成功，当前进程原来的代码、数据、堆和栈都会被新程序替换。

成功的 `exec` 不会返回。

### 3. wait：回收子进程
父进程需要通过 `wait()` 或 `waitpid()` 获取子进程退出状态。

```
#include <sys/wait.h>

int status;

pid_t child = waitpid(pid, &status, 0);

if (child == -1) {

perror("waitpid");

}
```
判断退出方式：

```
if (WIFEXITED(status)) {

printf("exit code: %d\n", WEXITSTATUS(status));

}

if (WIFSIGNALED(status)) {

printf("signal: %d\n", WTERMSIG(status));

}
```
如果父进程不回收已经退出的子进程，就会产生**僵尸进程**。

如果父进程先退出，子进程会成为**孤儿进程**，之后由系统中的其他进程接管。

## 八、实现一个简化版 Shell
Shell 的核心逻辑并不神秘：

- 1. 读取用户输入；

- 2. 解析命令和参数；

- 3. 调用 `fork()`；

- 4. 子进程调用 `exec()`；

- 5. 父进程调用 `waitpid()`。
简化示例：

```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

#define MAX_LINE 1024
#define MAX_ARGS 64

int main(void)

{

char line[MAX_LINE];

while (1) {

printf("mini-shell$ ");

fflush(stdout);

if (fgets(line, sizeof(line), stdin) == NULL) {

break;

}

line[strcspn(line, "\n")] = '\0';

if (strcmp(line, "exit") == 0) {

break;

}

char *args[MAX_ARGS];

size_t count = 0;

char *token = strtok(line, " ");

while (token != NULL && count < MAX_ARGS - 1) {

args[count++] = token;

token = strtok(NULL, " ");

}

args[count] = NULL;

if (count == 0) {

continue;

}

pid_t pid = fork();

if (pid == -1) {

perror("fork");

continue;

}

if (pid == 0) {

execvp(args[0], args);

perror("execvp");

_exit(127);

}

int status;

if (waitpid(pid, &status, 0) == -1) {

perror("waitpid");

}

}

return EXIT_SUCCESS;

}
```
这个 Shell 还不支持：

- 引号解析；

- 环境变量；

- 管道；

- 输入输出重定向；

- 后台任务；

- 作业控制；

- 通配符。
但它已经完整展示了 Shell 最核心的运行模型。

## 九、进程间通信：让独立进程协同工作
不同进程拥有独立地址空间，因此不能像函数调用一样直接访问彼此变量。

Linux 提供了多种进程间通信机制，简称 IPC。

常见方式包括：

- 管道；

- FIFO；

- 消息队列；

- 共享内存；

- 信号量；

- Unix Domain Socket；

- TCP/UDP Socket。

### 1. 匿名管道
创建管道：

```
int pipefd[2];

if (pipe(pipefd) == -1) {

perror("pipe");

}
```
其中：

```
pipefd[0]：读端

pipefd[1]：写端
```
父子进程通信示例：

```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

int main(void)

{

int pipefd[2];

if (pipe(pipefd) == -1) {

perror("pipe");

return EXIT_FAILURE;

}

pid_t pid = fork();

if (pid == -1) {

perror("fork");

return EXIT_FAILURE;

}

if (pid == 0) {

close(pipefd[1]);

char buffer[128];

ssize_t n = read(pipefd[0], buffer, sizeof(buffer) - 1);

if (n > 0) {

buffer[n] = '\0';

printf("child received: %s\n", buffer);

}

close(pipefd[0]);

_exit(0);

}

close(pipefd[0]);

const char *message = "hello from parent";

write(pipefd[1], message, strlen(message));

close(pipefd[1]);

waitpid(pid, NULL, 0);

return EXIT_SUCCESS;

}
```
管道是单向字节流。

程序应及时关闭不用的读端和写端，否则接收方可能永远等不到 EOF。

### 2. 共享内存
共享内存允许多个进程映射同一块物理内存，是非常高效的 IPC 方式。

但共享内存只解决“数据共享”，不自动解决“并发同步”。

通常需要搭配：

- 信号量；

- 互斥锁；

- 原子变量；

- 条件变量。

### 3. Unix Domain Socket
Unix Domain Socket 适合同一台主机上的进程通信。

与 TCP Socket 相比，它不经过完整网络协议栈，通常开销更低，并且可以传递文件描述符。

很多系统组件和容器工具都会使用它。

## 十、信号：异步事件通知机制
信号是一种软件中断。

常见信号：

| 信号 | 含义 |
| --- | --- |
| SIGINT | 终端按下 Ctrl+C |
| SIGTERM | 请求程序正常终止 |
| SIGKILL | 强制终止，不可捕获 |
| SIGCHLD | 子进程状态发生变化 |
| SIGPIPE | 向已关闭的管道写数据 |
| SIGALRM | 定时器到期 |
| SIGHUP | 终端断开或请求重载配置 |

推荐使用 `sigaction()` 注册信号处理函数：

```
#include <signal.h>
#include <stdio.h>
#include <unistd.h>

static volatile sig_atomic_t stop = 0;

static void handle_signal(int signo)

{

(void)signo;

stop = 1;

}

int main(void)

{

struct sigaction sa = {0};

sa.sa_handler = handle_signal;

sigemptyset(&sa.sa_mask);

sa.sa_flags = 0;

sigaction(SIGINT, &sa, NULL);

sigaction(SIGTERM, &sa, NULL);

while (!stop) {

pause();

}

write(STDOUT_FILENO, "exiting...\n", 11);

return 0;

}
```
信号处理函数中不能随意调用普通函数。

很多标准库函数都不是**异步信号安全**的，例如：

```
printf()

malloc()

free()

pthread_mutex_lock()
```
安全的常见做法是：

- 只修改 `sig_atomic_t` 类型标志；

- 或向管道写入一个字节；

- 在主循环中执行真正清理工作。

## 十一、线程：共享地址空间的并发执行单元
进程之间地址空间隔离，线程则共享同一进程中的大部分资源。

线程通常共享：

- 全局变量；

- 堆内存；

- 文件描述符；

- 当前工作目录；

- 信号处理设置。
每个线程独立拥有：

- 栈；

- 寄存器；

- 线程 ID；

- 调度状态；

- 线程局部存储。
使用 POSIX 线程时，需要链接 `pthread`：

```
gcc thread_demo.c -pthread -o thread_demo
```

### 1. 创建线程

```
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

static void *worker(void *arg)

{

const char *name = arg;

printf("worker: %s\n", name);

return NULL;

}

int main(void)

{

pthread_t thread;

int ret = pthread_create(&thread, NULL, worker, "task-1");

if (ret != 0) {

fprintf(stderr, "pthread_create failed: %d\n", ret);

return EXIT_FAILURE;

}

pthread_join(thread, NULL);

return EXIT_SUCCESS;

}
```
注意：`pthread` 系列函数通常直接返回错误码，而不是通过 `errno` 报错。

### 2. 数据竞争
下面的程序存在数据竞争：

```
counter++;
```
这行代码看起来只有一步，但底层可能包含：

- 1. 从内存读取；

- 2. 加一；

- 3. 写回内存。
多个线程同时执行时，更新可能丢失。

### 3. 互斥锁

```
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

pthread_mutex_lock(&mutex);

counter++;

pthread_mutex_unlock(&mutex);
```
互斥锁保证同一时刻只有一个线程进入临界区。

但要警惕死锁。

例如：

```
线程 A：先锁 mutex1，再锁 mutex2

线程 B：先锁 mutex2，再锁 mutex1
```
如果两个线程各自拿到一把锁，就可能永远等待。

避免死锁的常见方法：

- 统一加锁顺序；

- 缩小临界区；

- 避免持锁执行阻塞操作；

- 使用 `pthread_mutex_trylock()`；

- 对锁层级进行明确设计。

### 4. 条件变量
条件变量用于等待某个条件成立。

典型模型是生产者—消费者队列：

```
pthread_mutex_lock(&mutex);

while (queue_is_empty()) {

pthread_cond_wait(&cond, &mutex);

}

item = queue_pop();

pthread_mutex_unlock(&mutex);
```
必须使用 `while`，而不是 `if`。

因为线程被唤醒后，条件不一定仍然成立，也可能发生伪唤醒。

## 十二、内存管理：堆、栈与虚拟内存
Linux 进程通常拥有独立的虚拟地址空间。

一个典型进程的地址空间可以简化为：

```
高地址

┌──────────────┐

│ 栈 │

│ ↓ │

├──────────────┤

│ 内存映射区 │

├──────────────┤

│ ↑ │

│ 堆 │

├──────────────┤

│ BSS / 数据段 │

├──────────────┤

│ 代码段 │

└──────────────┘

低地址
```

### 1. malloc 与 free

```
int *array = malloc(100 * sizeof(*array));

if (array == NULL) {

perror("malloc");

exit(EXIT_FAILURE);

}

free(array);

array = NULL;
```
常见内存错误：

- 内存泄漏；

- 重复释放；

- 越界访问；

- 使用已释放内存；

- 返回局部变量地址；

- 未初始化内存；

- 错误计算分配大小。

### 2. mmap
`mmap()` 可以把文件或匿名内存映射到进程地址空间。

```
void *addr = mmap(

NULL,

length,

PROT_READ | PROT_WRITE,

MAP_PRIVATE,

fd,

0

);
```
常见用途：

- 映射大文件；

- 共享内存；

- 动态链接器；

- 高性能文件访问；

- 自定义内存分配器。
使用完毕后：

```
munmap(addr, length);
```
`mmap()` 并不意味着整个文件立刻加载到物理内存。页面通常在首次访问时按需载入。

## 十三、阻塞、非阻塞与 I/O 多路复用

### 1. 阻塞 I/O
默认情况下，很多 I/O 操作是阻塞的。

例如 Socket 没有数据时：

```
read(fd, buffer, size);
```
线程会暂停，直到：

- 有数据到达；

- 对端关闭连接；

- 信号中断；

- 发生错误。

### 2. 非阻塞 I/O
可以通过 `fcntl()` 设置非阻塞：

```
int flags = fcntl(fd, F_GETFL, 0);

fcntl(fd, F_SETFL, flags | O_NONBLOCK);
```
非阻塞模式下，如果暂时没有数据，`read()`会返回 `-1`，并设置：

```
errno == EAGAIN
```
或：

```
errno == EWOULDBLOCK
```
非阻塞不等于高性能。

如果程序不断循环调用 `read()` 检查数据，会造成忙等和 CPU 浪费。

因此，非阻塞 I/O 通常需要配合 I/O 多路复用。

### 3. select
`select()` 可以同时监控多个文件描述符，但存在明显限制：

- 文件描述符数量受 `FD_SETSIZE` 限制；

- 每次调用都需要复制集合；

- 每次返回后需要线性扫描；

- 大量连接时效率较低。

### 4. poll
`poll()` 使用数组保存文件描述符，突破了 `select()` 固定集合大小的限制。

但它仍需要线性扫描全部 FD。

### 5. epoll
`epoll` 是 Linux 高性能网络程序中常见的 I/O 多路复用机制。

基本流程：

```
int epfd = epoll_create1(EPOLL_CLOEXEC);
```
注册文件描述符：

```
struct epoll_event ev = {0};

ev.events = EPOLLIN;

ev.data.fd = fd;

epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &ev);
```
等待事件：

```
int n = epoll_wait(epfd, events, MAX_EVENTS, -1);
```
`epoll` 支持两种常见触发模式：

- LT：水平触发；

- ET：边缘触发。
水平触发下，只要缓冲区中还有数据，事件就会继续被报告。

边缘触发下，状态变化时才通知。程序通常需要使用非阻塞 FD，并循环读取，直到返回 `EAGAIN`。

## 十四、Socket 网络编程
Socket 是 Linux 网络编程的核心接口。

TCP 服务器通常经历以下步骤：

```
socket

↓

bind

↓

listen

↓

accept

↓

read / write

↓

close
```
TCP 客户端通常是：

```
socket

↓

connect

↓

read / write

↓

close
```

### 1. 一个最小 TCP 服务器

```
#include <arpa/inet.h>
#include <netinet/in.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <unistd.h>

#define PORT 8080

int main(void)

{

int server_fd = socket(AF_INET, SOCK_STREAM, 0);

if (server_fd == -1) {

perror("socket");

return EXIT_FAILURE;

}

int reuse = 1;

setsockopt(

server_fd,

SOL_SOCKET,

SO_REUSEADDR,

&reuse,

sizeof(reuse)

);

struct sockaddr_in address = {0};

address.sin_family = AF_INET;

address.sin_addr.s_addr = htonl(INADDR_ANY);

address.sin_port = htons(PORT);

if (bind(

server_fd,

(struct sockaddr *)&address,

sizeof(address)

) == -1) {

perror("bind");

close(server_fd);

return EXIT_FAILURE;

}

if (listen(server_fd, 128) == -1) {

perror("listen");

close(server_fd);

return EXIT_FAILURE;

}

printf("server listening on port %d\n", PORT);

int client_fd = accept(server_fd, NULL, NULL);

if (client_fd == -1) {

perror("accept");

close(server_fd);

return EXIT_FAILURE;

}

const char response[] =

"HTTP/1.1 200 OK\r\n"

"Content-Type: text/plain\r\n"

"Content-Length: 12\r\n"

"Connection: close\r\n"

"\r\n"

"Hello Linux!";

write(client_fd, response, sizeof(response) - 1);

close(client_fd);

close(server_fd);

return EXIT_SUCCESS;

}
```
运行：

```
gcc server.c -Wall -Wextra -o server

./server
```
在另一个终端测试：

```
curl http://127.0.0.1:8080
```
这个服务器一次只能处理一个连接。

要支持大量客户端，可以采用：

- 每连接一个进程；

- 每连接一个线程；

- 线程池；

- 非阻塞 I/O 加 `epoll`；

- 多 Reactor；

- 协程运行时。

### 2. TCP 是字节流
TCP 不保留消息边界。

发送两次：

```
send(fd, "abc", 3, 0);

send(fd, "def", 3, 0);
```
接收方可能一次收到：

```
abcdef
```
也可能分成多次收到。

因此，应用层必须自己设计协议，例如：

- 固定长度；

- 分隔符；

- 长度字段加消息体；

- TLV；

- Protobuf；

- HTTP。

## 十五、文件描述符复制与重定向
Shell 中的重定向：

```
command > output.txt
```
底层通常通过 `dup2()` 实现。

例如，把标准输出重定向到文件：

```
int fd = open(

"output.txt",

O_WRONLY | O_CREAT | O_TRUNC,

0644

);

if (fd == -1) {

perror("open");

exit(EXIT_FAILURE);

}

if (dup2(fd, STDOUT_FILENO) == -1) {

perror("dup2");

exit(EXIT_FAILURE);

}

close(fd);

printf("this line goes to output.txt\n");
```
管道命令：

```
ls -l | grep ".c"
```
大致实现方式是：

- 1. 创建管道；

- 2. 创建两个子进程；

- 3. 第一个子进程把标准输出连接到管道写端；

- 4. 第二个子进程把标准输入连接到管道读端；

- 5. 分别执行 `ls` 和 `grep`；

- 6. 父进程关闭管道并等待子进程。
掌握 `pipe()`、`dup2()`、`fork()`、`exec()`和 `waitpid()` 后，就能逐步实现更完整的 Shell。

## 十六、守护进程与长期运行服务
守护进程是在后台长期运行的服务进程。

传统守护进程通常会执行：

- 1. `fork()`；

- 2. 父进程退出；

- 3. 子进程调用 `setsid()` 创建新会话；

- 4. 修改工作目录；

- 5. 设置 `umask`；

- 6. 关闭或重定向标准输入输出；

- 7. 写入 PID 文件；

- 8. 进入服务主循环。
不过在现代 Linux 上，很多服务由 `systemd`管理。

程序不一定需要自行双重 `fork`，而可以保持前台运行，把以下能力交给 `systemd`：

- 自动启动；

- 崩溃重启；

- 日志收集；

- 权限隔离；

- 资源限制；

- 服务依赖；

- Socket 激活。
一个简单服务单元：

```
[Unit]

Description=Example Service

After=network.target

[Service]

ExecStart=/usr/local/bin/example-server

Restart=on-failure

User=nobody

[Install]

WantedBy=multi-user.target
```
系统编程不仅是写代码，也包括让程序在真实系统中可靠运行。

## 十七、时间、定时器与事件循环
常用时间接口包括：

```
time()

clock_gettime()

nanosleep()

timerfd_create()
```
测量性能时，不建议直接使用墙上时间。

推荐单调时钟：

```
struct timespec ts;

clock_gettime(CLOCK_MONOTONIC, &ts);
```
`CLOCK_MONOTONIC` 不受系统时间调整影响，更适合：

- 统计耗时；

- 实现超时；

- 调度周期任务。
Linux 的 `timerfd` 可以把定时器抽象为文件描述符，方便放入 `epoll` 事件循环。

类似的还有：

- `eventfd`：线程或进程间事件通知；

- `signalfd`：把信号转换为可读事件；

- `inotify`：监控文件系统变化。
这些接口可以让网络、定时器、信号和内部事件统一进入同一个事件循环。

## 十八、调试系统程序的常用工具

### 1. GDB
编译时加入：

```
gcc -g -O0 app.c -o app
```
启动：

```
gdb ./app
```
常用命令：

```
break main

run

next

step

continue

print variable

backtrace

info threads

thread 2

quit
```
分析崩溃时，`backtrace` 非常重要。

### 2. strace
`strace` 用于跟踪系统调用：

```
strace ./app
```
跟踪某个进程：

```
strace -p PID
```
只关注文件相关调用：

```
strace -e trace=openat,read,write,close ./app
```
统计系统调用：

```
strace -c ./app
```
当程序出现以下问题时，`strace` 特别有用：

- 文件找不到；

- 权限不足；

- 程序卡住；

- 网络连接失败；

- 子进程启动失败；

- 动态库加载异常。

### 3. ltrace
`ltrace` 跟踪动态库函数调用：

```
ltrace ./app
```

### 4. Valgrind
检查内存泄漏：

```
valgrind --leak-check=full ./app
```

### 5. Sanitizer
现代 C/C++ 项目非常推荐使用 Sanitizer。

地址检查：

```
gcc -fsanitize=address -g app.c -o app
```
未定义行为检查：

```
gcc -fsanitize=undefined -g app.c -o app
```
线程竞争检查：

```
gcc -fsanitize=thread -g app.c -pthread -o app
```

### 6. perf
性能分析：

```
perf stat ./app
```
采样：

```
perf record ./app

perf report
```
可以用于发现：

- CPU 热点；

- 缓存未命中；

- 上下文切换过多；

- 分支预测失败；

- 锁竞争。

## 十九、理解程序的编译、链接与加载
一个 C 程序从源代码到运行，通常经历：

```
预处理

↓

编译

↓

汇编

↓

链接

↓

加载执行
```
查看预处理结果：

```
gcc -E app.c -o app.i
```
生成汇编：

```
gcc -S app.c -o app.s
```
只编译不链接：

```
gcc -c app.c -o app.o
```
链接：

```
gcc app.o -o app
```
查看目标文件：

```
readelf -h app

readelf -S app

readelf -s app
```
查看依赖的动态库：

```
ldd ./app
```
查看符号：

```
nm ./app
```
反汇编：

```
objdump -d ./app
```
系统编程者需要逐步理解：

- ELF 文件格式；

- 静态链接和动态链接；

- 符号解析；

- 位置无关代码；

- 动态加载器；

- 共享库；

- 重定位；

- 程序启动过程。

## 二十、并发模型的选择
构建服务器时，没有一种并发模型适合所有场景。

### 1. 多进程
优点：

- 隔离性好；

- 单个进程崩溃不一定影响其他进程；

- 容易利用多核。
缺点：

- 创建和切换开销较大；

- 进程间共享数据复杂；

- IPC 成本较高。

### 2. 多线程
优点：

- 共享内存方便；

- 线程切换通常比进程轻；

- 适合阻塞型任务。
缺点：

- 需要同步；

- 容易发生死锁和数据竞争；

- 单个错误可能破坏整个进程。

### 3. 事件驱动
优点：

- 适合大量长连接；

- 线程数量较少；

- 内存占用较低。
缺点：

- 状态管理复杂；

- 一次阻塞可能卡住整个事件循环；

- 错误处理和回调链较难维护。

### 4. 线程池加事件循环
很多高性能程序会采用混合模型：

- I/O 线程负责网络事件；

- 工作线程池处理 CPU 密集型任务；

- 无锁队列或任务队列负责调度；

- 定时器处理超时和重试。
选择模型时，需要考虑：

- 连接数量；

- 请求耗时；

- 是否存在阻塞操作；

- CPU 密集还是 I/O 密集；

- 故障隔离要求；

- 开发和维护成本。

## 二十一、系统编程中的常见陷阱

### 1. 忽略短读和短写
错误：

```
write(fd, buffer, length);
```
就默认全部写完。

正确做法是循环写入，直到完成或发生不可恢复错误。

### 2. 文件描述符泄漏
忘记 `close()` 会导致进程耗尽 FD。

检查当前进程打开的文件：

```
ls -l /proc/PID/fd
```

### 3. fork 后缓冲区重复刷新
如果 `fork()` 前标准 I/O 缓冲区中还有数据，父子进程都可能刷新同一份缓冲区。

必要时在 `fork()` 前调用：

```
fflush(NULL);
```

### 4. 子进程中错误使用 exit
`fork()` 后，子进程执行失败时通常更适合使用：

```
_exit(127);
```
而不是 `exit()`，以避免重复刷新继承的标准 I/O 缓冲区。

### 5. 忽略 SIGPIPE
向已关闭连接写数据可能触发 `SIGPIPE`，默认行为是终止进程。

网络程序通常需要忽略它：

```
signal(SIGPIPE, SIG_IGN);
```
或使用支持禁用该信号的发送方式。

### 6. 非阻塞模式下没有处理 EAGAIN
`EAGAIN` 通常不是致命错误，只表示“现在暂时无法完成”。

### 7. 多线程中错误使用全局变量
全局变量共享，必须明确其并发访问规则。

### 8. 持锁执行阻塞 I/O
持有互斥锁时执行磁盘或网络阻塞操作，可能导致其他线程长时间等待。

### 9. 不检查返回值
系统编程中，几乎每个重要调用都可能失败。

不检查返回值，相当于主动放弃程序可靠性。

## 二十二、如何写出可靠的系统程序

### 1. 统一错误处理
可以封装常见检查：

```
static void die(const char *message)

{

perror(message);

exit(EXIT_FAILURE);

}
```
但在大型程序中，还需要区分：

- 可恢复错误；

- 临时错误；

- 配置错误；

- 资源不足；

- 协议错误；

- 程序内部错误。

### 2. 明确资源所有权
每个资源都应该有清晰的所有者：

- 谁负责关闭文件描述符；

- 谁负责释放内存；

- 谁负责销毁锁；

- 谁负责回收子进程；

- 谁负责终止线程。

### 3. 使用清理路径
C 程序中可以使用统一清理标签：

```
int fd1 = -1;

int fd2 = -1;

char *buffer = NULL;

int result = -1;

/* 获取资源 */

result = 0;

cleanup:

free(buffer);

if (fd2 != -1) {

close(fd2);

}

if (fd1 != -1) {

close(fd1);

}

return result;
```
这种写法虽然朴素，却能有效减少复杂失败路径中的资源泄漏。

### 4. 设计可观测性
长期运行服务应具备：

- 结构化日志；

- 错误码；

- 指标统计；

- 健康检查；

- 请求 ID；

- 超时信息；

- 配置输出；

- 调试模式。
一个程序不仅要“能运行”，还要在发生问题时“能解释自己为什么出错”。

## 二十三、从入门到精通的学习路线

### 第一阶段：C 语言与 Linux 基础
需要掌握：

- 指针、数组、结构体；

- 动态内存；

- 函数指针；

- 位运算；

- 预处理器；

- Makefile；

- Linux 命令行；

- 权限和目录结构。
练习项目：

- 文本统计工具；

- 简化版 `cat`；

- 简化版 `cp`；

- 十六进制查看器；

- 目录遍历工具。

### 第二阶段：文件、进程与信号
需要掌握：

- 文件描述符；

- 文件状态；

- `fork`；

- `exec`；

- `waitpid`；

- 信号；

- 管道；

- 重定向。
练习项目：

- 简化版 Shell；

- 管道命令执行器；

- 多进程文件搜索器；

- 后台任务管理器；

- 日志轮转工具。

### 第三阶段：线程与同步
需要掌握：

- POSIX 线程；

- 互斥锁；

- 读写锁；

- 条件变量；

- 信号量；

- 原子操作；

- 线程池；

- 生产者—消费者模型。
练习项目：

- 线程池；

- 并行文件校验器；

- 多线程下载器；

- 并发任务队列；

- 简化版内存缓存。

### 第四阶段：网络编程
需要掌握：

- TCP/IP 基础；

- Socket；

- 字节序；

- 地址解析；

- 阻塞和非阻塞；

- `select`、`poll`、`epoll`；

- 超时和重连；

- 应用层协议设计。
练习项目：

- Echo 服务器；

- 聊天室；

- HTTP 静态文件服务器；

- 反向代理；

- 多客户端消息广播；

- 简化版 Redis 服务。

### 第五阶段：性能与工程化
需要掌握：

- `mmap`；

- 零拷贝；

- `sendfile`；

- `splice`；

- Reactor；

- 线程模型；

- 内存池；

- 对象池；

- 性能分析；

- 锁竞争；

- Cache 友好设计；

- 系统资源限制。
练习项目：

- epoll 高并发服务器；

- 日志采集代理；

- 文件同步服务；

- 轻量级消息队列；

- 高性能键值存储；

- 多线程网络框架。

## 二十四、推荐实战项目：从简单到复杂

### 项目一：文件复制工具
目标：

- 支持大文件；

- 正确处理短读短写；

- 保留权限和时间；

- 显示复制进度；

- 支持覆盖确认。
核心知识：

```
open / read / write / close / stat
```

### 项目二：简化版 Shell
目标：

- 支持普通命令；

- 支持管道；

- 支持输入输出重定向；

- 支持后台运行；

- 支持环境变量。
核心知识：

```
fork / exec / waitpid / pipe / dup2 / signal
```

### 项目三：线程池
目标：

- 固定工作线程；

- 线程安全任务队列；

- 条件变量唤醒；

- 支持优雅关闭；

- 支持任务统计。
核心知识：

```
pthread / mutex / condition variable
```

### 项目四：epoll 聊天服务器
目标：

- 支持多客户端；

- 非阻塞 Socket；

- 连接管理；

- 消息广播；

- 心跳检测；

- 空闲连接超时。
核心知识：

```
socket / fcntl / epoll / timerfd
```

### 项目五：HTTP 服务器
目标：

- 解析请求行和请求头；

- 支持静态文件；

- 支持 Keep-Alive；

- 支持错误页面；

- 防止目录穿越；

- 使用线程池处理业务。
核心知识：

```
TCP / HTTP / epoll / thread pool / sendfile
```

### 项目六：简化版键值数据库
目标：

- 支持 SET、GET、DEL；

- 使用哈希表；

- 支持过期时间；

- 追加日志持久化；

- 崩溃恢复；

- 多客户端并发。
核心知识：

```
data structure / mmap / fsync / epoll / protocol
```

## 二十五、进一步理解 Linux 内核接口
达到进阶阶段后，可以继续深入：

### 1. `/proc` 文件系统
查看进程状态：

```
cat /proc/PID/status
```
查看内存映射：

```
cat /proc/PID/maps
```
查看打开的 FD：

```
ls -l /proc/PID/fd
```

### 2. `/sys` 文件系统
`sysfs` 用于展示设备、驱动和内核对象信息。

### 3. 资源限制
查看限制：

```
ulimit -a
```
程序中可以使用：

```
getrlimit()

setrlimit()
```
常见限制：

- 最大文件描述符数量；

- 最大进程数量；

- 栈大小；

- Core Dump 大小；

- 锁定内存大小。

### 4. Core Dump
允许生成 Core Dump：

```
ulimit -c unlimited
```
程序崩溃后分析：

```
gdb ./app core
```

### 5. Linux 特有高级接口
进阶学习内容包括：

- `epoll`；

- `inotify`；

- `signalfd`；

- `timerfd`；

- `eventfd`；

- `clone`；

- `futex`；

- `io_uring`；

- Namespace；

- cgroup；

- seccomp；

- eBPF。
这些接口广泛应用于容器、数据库、Web 服务器、消息系统和高性能运行时。

## 二十六、Linux 系统编程的核心思维
学完大量 API 后，更重要的是建立底层思维。

### 1. 所有资源都有生命周期
文件描述符、内存、线程、进程、锁和 Socket 都必须被正确创建、使用和释放。

### 2. 系统调用随时可能失败
不要把异常当作“不可能发生”。

磁盘会满，连接会断，信号会打断调用，权限会不足，进程会退出。

### 3. I/O 不保证一次完成
TCP 是字节流，`read()` 和 `write()` 都可能只完成部分工作。

### 4. 并发意味着不确定性
线程调度顺序不可预测。

不能依赖“通常先执行”或者“测试时没有出问题”。

### 5. 性能问题必须测量
不要凭感觉优化。

使用 `perf`、火焰图、系统指标和压测数据找出真正瓶颈。

### 6. 简单设计往往更可靠
底层代码本身已经复杂。

越是系统程序，越要保持接口清晰、资源归属明确、状态数量可控。

## 二十七、结语
Linux 系统编程是一条从应用层走向底层的道路。

开始时，你可能只是学习几个函数：

```
open()

read()

write()

fork()

socket()
```
但随着学习深入，你会逐渐理解：

- Shell 为什么能执行命令；

- Web 服务器为什么能同时处理大量连接；

- 数据库为什么需要 `mmap` 和 `fsync`；

- 容器如何隔离进程和资源；

- 线程为什么会竞争和死锁；

- 程序崩溃后应该如何定位；

- 高性能系统为什么关注上下文切换、缓存和零拷贝。
真正的“精通”，并不是记住所有系统调用，而是能够在面对一个系统问题时，知道应该选择什么机制、如何验证假设、怎样处理异常，以及如何让程序长期稳定运行。

建议你遵循这条实践路线：

```
文件 I/O

↓

进程与信号

↓

IPC

↓

线程与同步

↓

Socket 网络编程

↓

epoll 事件驱动

↓

调试与性能分析

↓

完整系统项目
```
每学一个模块，都写一个可以运行的项目。

不要只看 API 文档，也不要只背概念。

当你亲手实现过 Shell、线程池、HTTP 服务器和键值数据库后，你会发现：Linux 不再只是一个操作系统，而是一套清晰、强大且高度统一的编程模型。

## 附：常用系统编程头文件速查

```
#include <unistd.h> // read、write、close、fork、exec
#include <fcntl.h> // open、fcntl
#include <errno.h> // errno
#include <sys/stat.h> // stat、文件权限
#include <sys/types.h> // pid_t、off_t
#include <sys/wait.h> // wait、waitpid
#include <signal.h> // signal、sigaction
#include <pthread.h> // POSIX 线程
#include <sys/mman.h> // mmap、munmap
#include <sys/socket.h> // Socket
#include <netinet/in.h> // IPv4 地址结构
#include <arpa/inet.h> // inet_pton、inet_ntop
#include <netdb.h> // getaddrinfo
#include <sys/epoll.h> // epoll
#include <dirent.h> // 目录遍历
```

## 附：常用调试命令速查

```
# 查看系统调用
strace ./app

# 查看动态库调用
ltrace ./app

# GDB 调试
gdb ./app

# 查看动态库依赖
ldd ./app

# 查看 ELF 信息
readelf -a ./app

# 查看符号
nm ./app

# 反汇编
objdump -d ./app

# 内存检查
valgrind --leak-check=full ./app

# 性能统计
perf stat ./app

# 性能采样
perf record ./app

perf report

# 查看进程打开的文件
lsof -p PID

# 查看进程文件描述符
ls -l /proc/PID/fd

# 查看进程内存映射
cat /proc/PID/maps
```
