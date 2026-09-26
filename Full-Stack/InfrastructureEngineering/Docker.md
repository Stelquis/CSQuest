# [Docker 从入门到精通：从第一个容器到生产级实践](https://mp.weixin.qq.com/s/W7sF-SLx_h5d0ATxYvyVfA)

> 这是一个关于"书友会"的故事——一个由两个人维护的读书社区，和它从"在我电脑上能跑"到"稳稳当当跑在生产环境"的完整旅程。你会跟着小林一起，亲手把一个个问题解决掉。读完之后你会发现：Docker 不难，难的是从没人和你讲清楚"为什么"。

---

## 故事的起点：周五晚上十点，一切崩塌

"书友会"是小林和搭档小周一起做的读书社区：用户可以注册、发书评、收藏书单，还有个简单的推荐系统。代码不算复杂，但五脏俱全——一个 Node.js 写的后端 API，一个 PostgreSQL 存用户和数据，一个 Redis 做缓存和推荐。

那天晚上，小林把代码推到服务器，准备部署上线。然后，噩梦开始了。

服务器先是报错，说找不到一个系统库。小林查了半天，发现是服务器上预装的 Node 版本太老，API 需要的语法根本不支持。他折腾着升级了 Node，又发现 PostgreSQL 版本对不上，数据文件格式不兼容。好不容易全都凑齐了，Redis 又起不来——端口被服务器上另一个项目占用了。

凌晨一点，小林盯着屏幕，忽然想明白了一件事：

**代码是可以复制粘贴的，但"环境"不行。**

小林的代码在本地跑得好好的，可"本地"是一个他花了两个月慢慢调出来的、充满巧合的环境：某个版本的依赖、某个路径下的配置、某次安装留下的系统库。这些东西没法打包，没法传递，换一台机器就全都对不上了。

这不止是小林一个人的困境。几乎所有开发者都遇到过：

- 程序在自己的电脑上运行正常，部署到服务器却报错；
- 新同事配置开发环境需要一两天；
- 测试环境与生产环境的依赖版本不同；
- 一台服务器上运行多个项目，端口和依赖互相冲突；
- 项目升级失败后，很难快速恢复到旧版本。

这些问题指向同一个根源：**应用运行所依赖的环境，无法被稳定、完整地复制。**

而解决它的工具，叫 Docker。

Docker 的思路特别朴素：把应用程序、运行时、系统依赖、配置方式全部打包成一个"标准化镜像"，然后把整个环境原样交付到任何一台机器上。

传统部署，是在服务器上"现场搭环境"；Docker 部署，是把已经准备好的环境整体端过去。

小林决定，从明天开始，认真学 Docker。他给自己定了个目标：把"书友会"完整地容器化，下次部署再也不要"现场搭环境"。

这个故事，就是他从头到尾走完的路线图。

---

## 第一站：先从 Redis 下手——认识镜像和容器

小林没有一上来就啃文档。他选了一个最实际的开刀对象：Redis。

为什么是 Redis？因为它最"无辜"——书友会的业务逻辑全在 API 里，Redis 只是个帮手。如果连把 Redis 用 Docker 跑起来都搞不定，那容器化就是个笑话。

他在本地装好 Docker（Windows 和 macOS 通常用 Docker Desktop，Linux 装 Docker Engine，Docker Desktop 一般自带 CLI、Engine 和 Compose），先确认一切就绪：

```bash
docker version
docker info
```

然后，他敲下了人生中第一条真正意义上的 Docker 命令：

```bash
docker run redis:7
```

屏幕上一行行日志滚出来，Redis 跑起来了。

就这么简单？小林有点不敢相信。没有去官网下载安装包，没有配置路径，没有处理依赖——一条命令，Redis 就活了。

这里就藏着 Docker 的第一个核心概念：

**镜像（Image）**。`redis:7` 就是一个镜像。镜像是一个只读模板，里面装好了运行 Redis 所需的一切：二进制程序、依赖库、配置文件、默认参数。它不是正在运行的程序，而是"安装包 + 环境快照"——一个随时可以拿来创建运行实例的模板。

**容器（Container）**。`docker run` 创建出来的那个正在运行的 Redis，就是容器。容器是镜像的运行实例——模具（镜像）是静止的，用模具做出来的成品（容器）才是真正在用的东西。

小林又敲了一遍：

```bash
docker run redis:7
docker run redis:7
```

两个 Redis 同时跑了起来，互不干扰。同一个镜像可以创建任意多个互相独立的容器，每个都有自己独立的进程、网络和可写层。

他还注意到，第一个命令执行时 Docker 先下载了镜像。这个下载来源，就是第三个概念：

**镜像仓库（Registry）**。Redis、Nginx、Node 这些官方镜像都放在 Docker Hub 上；除了公共仓库，还有 GitHub Container Registry、云厂商的镜像仓库、企业自建的私有 Registry。镜像的流转，全靠它们。

小林把三个概念串了起来：**镜像从仓库来，容器从镜像来。**

不过，Redis 跑起来归跑起来，他很快就发现了问题：第一条命令敲完后，终端就被占住了，Ctrl+C 一按，Redis 就停了。而且关掉终端，Redis 也跟着没了。

他查了查，改成这样：

```bash
docker run -d --name bookclub-redis redis:7
```

- `-d`：后台运行（detached），终端可以继续用；
- `--name bookclub-redis`：给容器起个名字，方便后面找它；
- `redis:7`：镜像名加标签。

跑起来之后，怎么确认它活着？小林学了一套"看"的命令：

```bash
docker ps            # 看正在运行的容器
docker ps -a         # 看所有容器，包括已经退出的
docker logs -f bookclub-redis   # 实时看 Redis 的日志
docker stats         # 看 CPU、内存占用
```

其中 `docker ps` 输出的那一列列信息，就是容器的"身份证"：ID、镜像、状态、端口、名字。

他试着停掉再启动：

```bash
docker stop bookclub-redis
docker start bookclub-redis
docker restart bookclub-redis
```

`stop` 是让运行中的容器停下来，`start` 是让停下来的再启动，`restart` 是先停再启。

他还发现容器里随时可以进去"串门"：

```bash
docker exec -it bookclub-redis sh
```

`-it` 是交互模式加终端，进去之后就能像在普通 Linux 机器上一样敲命令。很多精简镜像没有 `bash`，只有 `sh`，所以习惯上先用 `sh`。

到这里，小林已经会"养"一个容器了。但他心里还有个疑惑：**为什么我敲 `docker run redis:7`，它就知道要去下载？** 他翻了下文档，把 Docker 的分工理清楚了：

```
用户 → Docker CLI（你敲的命令）→ Docker API → Docker Daemon（真正干活的）
                                                    ├── 管理镜像
                                                    ├── 创建和运行容器
                                                    ├── 管理网络
                                                    └── 管理数据卷
                                                        ↓
                                                      镜像仓库
```

`docker` 命令只是"传话的"，真正干活的是后台的 Docker Daemon。你敲的每个命令，都通过标准接口交给 Daemon 执行——这也保证了无论在谁的机器上，行为都一致。

小林的 Redis 已经跑起来了。但他还不知道，一个更大的坑，正等着他。

---

## 第二站：Redis 的数据神秘消失了——持久化

书友会的推荐系统开始用 Redis 存一些中间结果。小林往里面写了几条数据，验证功能正常。

然后他干了一件"顺手"的事——把容器删了重来：

```bash
docker rm -f bookclub-redis
```

删除之后，他随手又跑了一个新 Redis：

```bash
docker run -d --name bookclub-redis redis:7
```

接着他傻眼了：之前写进去的数据，全没了。

小林的第一反应是"Redis 出 bug 了"。查了半天才明白，问题出在他自己身上：

**容器里面有一个"可写层"，但这一层跟容器的生命周期绑在一起。容器一删，这一层就跟着没了。**

Redis 把数据写在了容器的可写层里——容器是"一次性"的，数据却需要"永生"。

Docker 解决这个问题，靠的是三种持久化方式：

1. **Volume**：由 Docker 管理的数据卷，数据住在 Docker 专门开辟的存储区域里；
2. **Bind Mount**：直接把主机的某个目录挂进容器，主机和容器共享；
3. **tmpfs**：数据只存在内存里，容器一停就没，适合临时数据。

### 数据要住在外面：Volume

小林先学了最推荐的 Volume。先创建一个数据卷：

```bash
docker volume create bookclub-redis-data
```

查看有哪些数据卷：

```bash
docker volume ls
```

然后挂载着它启动 Redis：

```bash
docker run -d \
  --name bookclub-redis \
  -v bookclub-redis-data:/data \
  redis:7
```

`-v` 的格式是 `卷名:容器内路径`。Redis 把数据写到容器内的 `/data`，而 `/data` 实际指向的是外面的 `bookclub-redis-data` 卷。

小林做了个测试：写数据 → 删容器 → 再挂同一个卷启动。数据还在。

他还学到了一种更明确的写法 `--mount`，语义更清晰，推荐在正式项目里用：

```bash
docker run -d \
  --name bookclub-redis \
  --mount type=volume,src=bookclub-redis-data,dst=/data \
  redis:7
```

删除数据卷要小心：

```bash
docker volume rm bookclub-redis-data
docker volume prune   # 清理所有没被使用的卷
```

`prune` 会把没人用的卷全删了——执行前一定要确认数据确实不需要了，这命令没有后悔药。

### 开发时的另一个选择：Bind Mount

后来小林发现，开发阶段还有更爽的方式：直接把主机的目录挂进容器，改代码立刻生效，不用重新构建。

```bash
docker run -d \
  --name web \
  -p 8080:80 \
  -v "$PWD/html:/usr/share/nginx/html:ro" \
  nginx:alpine
```

- `$PWD/html`：主机上的目录；
- `/usr/share/nginx/html`：容器里对应的目录；
- `ro`：只读挂载，容器里改不了主机文件（安全）。

Bind Mount 适合：开发时挂源代码、挂配置文件、主机容器共享文件、想精确控制数据存储位置的场景。

### 到底怎么选？

小林给自己总结了一条决策铁律：

> 应用程序可以随时重新创建，业务数据必须独立于容器生命周期。

- 数据库、Redis、上传文件这类**数据** → Volume（Docker 管理，安全）；
- 开发调试、挂配置文件这类**需要跟主机实时交互**的 → Bind Mount；
- 临时缓存、会话这类**丢了也不心疼**的 → tmpfs。

把数据从容器里"搬"到卷里之后，小林长舒了一口气。但紧接着，他遇到了第二个怪问题。

---

## 第三站：容器明明在跑，浏览器却打不开——端口映射

书友会的 API 跑在容器里了，小林在浏览器输入 `http://localhost:8080`，转了半天圈，打不开。

他先去确认容器活着：

```bash
docker ps
```

容器确实在运行。那问题出在哪？

他排查了半天，终于明白了：**容器拥有独立的网络空间。容器内部监听 80 端口，不代表主机的 80 端口开放。**

打个比方：容器像是房间里的一台收音机，它在房间里放得再响，不把天线接到窗外，外面的人永远听不到。主机的端口就是那扇窗。

要让外面的人能访问到，必须做端口映射——把主机的某个端口，转发到容器的某个端口：

```bash
docker run -d \
  --name web \
  -p 8080:80 \
  nginx:alpine
```

`-p` 的格式是 `主机端口:容器端口`：访问主机的 8080，请求会被转发到容器的 80。

小林这才理解，为什么很多教程里容器明明在跑，访问却总是不通——**忘了 `-p`**。

他还学了几个变体：

只想让本机访问，不暴露给局域网或公网：

```bash
docker run -d \
  --name web \
  -p 127.0.0.1:8080:80 \
  nginx:alpine
```

懒得指定端口，让 Docker 随机分配一个主机端口：

```bash
docker run -d -P nginx
docker port <容器名>    # 查看随机分配的端口
```

他还搞清了一个特别容易混淆的点：**EXPOSE 和 -p 的区别**。

Dockerfile 里的 `EXPOSE 8080` 只是"声明"应用预期监听 8080，相当于写个说明文档，**不会真的开放端口**。真正建立主机端口映射的是 `-p 8080:8080`。

"声明"和"实打实"，完全是两回事。

---

## 第四站：容器之间怎么"打电话"？——网络与名字

端口通了，API 能访问了。但小林马上遇到了第三个问题：API 容器要连数据库，怎么连？

他一开始像写普通程序一样，在 API 里配了 `localhost:5432` 指向 PostgreSQL。结果连不上。

**因为容器里的 `localhost` 指向容器自己。** 每个容器都是独立的"房间"，房间里的 `localhost` 是房间自己，不是隔壁的数据库。

那么，容器之间到底怎么通信？

Docker 的网络驱动有几种：

- `bridge`：单机容器最常用的网络（默认）；
- `host`：容器共享主机网络，不隔离；
- `none`：关闭网络；
- `overlay`：跨多台主机的容器网络；
- `macvlan`：让容器像物理设备一样接入网络。

单机项目，绝大多数场景用 `bridge`。小林的做法是：创建一个自定义网络，把相关容器都拉进来：

```bash
docker network create bookclub-net
```

然后让数据库和 API 都挂到这个网络上：

```bash
docker run -d \
  --name bookclub-db \
  --network bookclub-net \
  -e POSTGRES_PASSWORD=change-me \
  postgres:17-alpine

docker run -d \
  --name bookclub-api \
  --network bookclub-net \
  -e DATABASE_HOST=bookclub-db \
  my-api:1.0.0
```

关键在这里：**同一个自定义网络里，容器之间可以直接用容器名通信**。API 里配置 `DATABASE_HOST=bookclub-db`，就能连上数据库——用的是名字，不是 IP。

为什么不用 IP？因为容器被删除重建后，IP 会变。用名字，Docker 内置的 DNS 会自动解析到最新的地址。用 IP，一重建就断。

排障的时候，有几条命令很管用：

```bash
docker inspect bookclub-api              # 看容器连了哪些网络
docker network inspect bookclub-net      # 看网络里有谁
docker run --rm -it --network bookclub-net nicolaka/netshoot   # 网络调试工具箱
```

`netshoot` 这个镜像里预装了 `curl`、`dig`、`nslookup`、`ping`、`tcpdump` 等全套网络工具，容器之间连不通的时候，进这个"工具箱"里查，效率极高。

到这里，Redis 活了，数据不丢了，端口通了，容器之间也能说话了。小林的"书友会"基础环境已经成型。但下一个问题更硬核：**他自己的 Node.js 应用，怎么才能变成一个镜像？**

---

## 第五站：把书友会装进镜像——Dockerfile 的完整旅程

Redis、PostgreSQL、Nginx 都有现成的官方镜像，拿来就能用。但书友会自己的 API 是全世界独一无二的代码，没有任何现成镜像。小林必须学会**把自己的应用做成镜像**。

做镜像的说明书，叫 **Dockerfile**。

小林给 API 写的第一版 Dockerfile 长这样：

```dockerfile
FROM node:22-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --omit=dev
COPY . .
ENV NODE_ENV=production
EXPOSE 3000
CMD ["node", "server.js"]
```

然后构建：

```bash
docker build -t bookclub-api:1.0.0 .
```

跑起来：

```bash
docker run --rm -p 3000:3000 bookclub-api:1.0.0
```

成了。他的 API 第一次以"镜像"的形式运行起来。但小林不想只是"照着写"，他花了一个下午，把每一行指令都搞明白了。

### FROM：出身决定一切

```dockerfile
FROM node:22-alpine
```

每个 Dockerfile 的第一行，决定这个镜像"出生在什么家庭"。这里用的是 Node.js 22 的 Alpine 精简版——带好了 Node 运行环境。

### WORKDIR：在哪个目录干活

```dockerfile
WORKDIR /app
```

之后所有指令都在 `/app` 目录下执行。比反复写 `RUN cd /app && ...` 清晰得多。

### COPY：把文件搬进镜像

```dockerfile
COPY package*.json ./
```

把项目里的 `package.json` 和 `package-lock.json` 复制进镜像。小林注意到这里有个讲究：**先复制依赖清单，再复制代码**——这个顺序后面会带来巨大的收益。

### RUN：构建时执行命令

```dockerfile
RUN npm ci --omit=dev
```

`RUN` 是在**构建阶段**执行的命令，用来装依赖、编译代码。`npm ci` 会按照锁定文件精确安装依赖，`--omit=dev` 跳过开发依赖，只装生产需要的。

### ENV：运行时环境变量

```dockerfile
ENV NODE_ENV=production
```

设置容器运行时的环境变量。注意和 `ARG` 的区别：`ARG` 是**构建时**的参数，`ENV` 是**运行时**的配置。

### EXPOSE：声明端口

```dockerfile
EXPOSE 3000
```

告诉 Docker"这个应用预期监听 3000 端口"。注意，它只是声明，不是开放——前面讲过，真正的端口映射要靠 `-p`。

### CMD：容器启动时跑什么

```dockerfile
CMD ["node", "server.js"]
```

容器启动时执行的默认命令。这里用了 JSON 数组形式，而不是 `CMD node server.js` 这种 shell 形式——这个细节后面还会提到。

### 把基础镜像换成自己想要的

小林发现，`FROM` 前面还可以用 `ARG` 定义基础镜像的版本，方便统一管理：

```dockerfile
ARG NODE_VERSION=22
FROM node:${NODE_VERSION}-alpine
```

构建时用 `--build-arg` 覆盖：

```bash
docker build --build-arg NODE_VERSION=20 -t bookclub-api:1.0.0 .
```

### COPY 还是 ADD？

小林在网上看到有人用 `ADD`，有人用 `COPY`，纠结了一下。结论是：**优先用 `COPY`**。`ADD` 多出来的能力（自动解压本地压缩包、从 URL 拉文件）在日常构建里几乎用不上，反而容易带来意想不到的行为。`COPY` 简单、直白、可预期。

### 一个 Dockerfile 只能有一个"默认启动"

小林问：如果 Dockerfile 里写了多个 `CMD` 会怎样？答案是：**只会保留最后一个**。`CMD` 是"默认命令"，一个镜像只能有一个默认启动方式。

### ENTRYPOINT 和 CMD：一个定死，一个可换

书友会的 API 后来加了一个功能：镜像里要内置一个命令行工具，方便运维查看缓存状态。小林遇到了 `ENTRYPOINT`。

可以这样理解两者的分工：

- `ENTRYPOINT`：容器**固定执行什么程序**，定死了；
- `CMD`：**默认参数**，可以被 `docker run` 后面的参数覆盖。

举个例子，一个"官方 curl 镜像"可以这么定义：

```dockerfile
ENTRYPOINT ["curl"]
CMD ["https://example.com"]
```

```bash
docker run my-curl
# 等价于 curl https://example.com

docker run my-curl https://www.docker.com
# 等价于 curl https://www.docker.com —— 参数被替换了
```

### USER：别用 root 跑生产

镜像里的进程默认是 root 用户。但生产环境用 root 跑应用，一旦被攻击，攻击者就拿到了最高权限。小林在 Dockerfile 里创建了一个普通用户：

```dockerfile
RUN addgroup -S app && adduser -S app -G app
USER app
```

### HEALTHCHECK：让容器自己报平安

为了让编排系统知道容器是否健康，小林给 API 加了健康检查：

```dockerfile
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD wget -qO- http://127.0.0.1:3000/health || exit 1
```

每 30 秒检查一次 `/health` 接口，3 次失败就标记为不健康。

到这里，小林的 Dockerfile 已经相当完整了。但他很快发现一个新问题：**每次改一行代码，构建都要重装一遍依赖，慢得离谱。**

---

## 第六站：为什么构建这么慢？——镜像分层与缓存

小林第一次构建 API 镜像用了三分钟，他忍了。可后来他每改一行代码就要重建一次，每次都三分钟，他崩溃了。

他研究了一下 Docker 的构建机制，发现秘密藏在**镜像分层**里。

一个镜像不是一块铁板，而是由很多**只读层**叠起来的。Dockerfile 里的很多指令，每一条都会生成一层。

拿最常见的构建流程举例：

```dockerfile
COPY package.json ./
RUN npm install
COPY . .
```

构建时，Docker 会一层一层地检查：**如果某一层没变，就直接复用之前的构建结果（缓存），不再重新执行。**

小林之前把 Dockerfile 写成了这样：

```dockerfile
COPY . .
RUN npm install
```

**先复制全部代码，再装依赖**——只要任意一个源文件变了，`COPY . .` 这一层就变了，紧接着的 `npm install` 层也跟着失效，于是每次都重新装一遍依赖。这就是慢的根源。

改成**先复制依赖清单，装好依赖，再复制代码**：

```dockerfile
COPY package*.json ./
RUN npm ci
COPY . .
```

效果立竿见影：代码随便改，依赖层都命中缓存，只有最后 `COPY . .` 那层重建。构建时间从三分钟降到十几秒。

### 缓存优化的原则

小林把经验总结成几条：

1. 把**不常变化**的步骤放在前面；
2. 把**经常变化**的代码放在后面；
3. 先复制依赖清单，再安装依赖；
4. 用 `.dockerignore` 缩小构建上下文；
5. 别在镜像层里留下缓存和临时文件；
6. 不要为了减少层数而牺牲可读性，但强相关的操作可以合并。

### .dockerignore：给构建"瘦身"

小林的第二个优化是 `.dockerignore`——它告诉 Docker："构建时别把这些东西打包进来"：

```
.git
.gitignore
node_modules
npm-debug.log
.env
coverage
dist
Dockerfile*
compose*.yaml
README.md
```

好处很明显：`node_modules` 这种动辄几百 MB 的目录不再被发到构建器，构建更快；本地依赖、Git 历史、`.env` 这些敏感文件不会溜进镜像；缓存也不会被无关文件反复击穿。

### 基础镜像的取舍

小林发现基础镜像也大有学问，各有取舍：

- **完整发行版镜像**：兼容性最好，但体积大；
- **`slim` 版**：体积和兼容性的平衡点；
- **`alpine` 版**：体积极小，但用的是 musl libc，个别依赖可能编译不过；
- **Distroless**：只保留运行必需，几乎不能进容器调试；
- **`scratch`**：空镜像，适合 Go 这种静态编译的单文件程序。

他得到的教训是：**别只看体积**。省 100MB，结果装个依赖装不上，或者在线上没法排查问题，得不偿失。

---

## 第七站：镜像太胖了——多阶段构建

书友会的 API 越做越大，小林发现镜像体积也很感人：几百 MB。

原因很简单：镜像里带着完整的 Node.js 工具链、npm 缓存、甚至源代码。但这些**运行时根本不需要**。

多阶段构建就是专门治这个的：**一个 Dockerfile 里分两个阶段——一个阶段负责"造"，另一个阶段只留"成品"。**

以前端为例（书友会的前端是静态页面）：

```dockerfile
# 第一阶段：构建静态文件
FROM node:22-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . .
RUN npm run build

# 第二阶段：只留运行需要的
FROM nginx:1.27-alpine
COPY --from=builder /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

第一阶段用 Node.js 把代码编译成静态文件；第二阶段只拿编译产物，交给 Nginx 托管。**最终镜像里没有 Node.js、没有 npm、没有源代码**——体积直接缩到十分之一。

多阶段构建的好处：

- 镜像更小；
- 攻击面更小（少了很多用不上的工具）；
- 构建环境和运行环境彻底分离；
- Dockerfile 更好维护；
- 源代码不会泄露进生产镜像。

书友会后端是 Node 的，前端这套多阶段构建帮他省了 300MB。

他还看到一个 Go 项目的多阶段构建示例，更夸张——最终镜像只有几 MB：

```dockerfile
FROM golang:1.24-alpine AS builder
WORKDIR /src
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 go build -o /out/app ./cmd/server

FROM alpine:3.21
RUN addgroup -S app && adduser -S app -G app
USER app
COPY --from=builder /out/app /app
EXPOSE 8080
ENTRYPOINT ["/app"]
```

### 生产级镜像的几条铁律

小林把这些零散的经验，沉淀成了他构建生产镜像的"检查清单"：

1. **固定明确版本**，不要 `FROM node:latest`。`latest` 今天一个样明天一个样，生产要的是确定性。要求高的场景还可以用镜像摘要锁死：`FROM node:22.14-alpine@sha256:<digest>`——但注意锁死了就不会自动收到安全更新，需要定期手动更新。
2. **非 root 用户跑进程**，配合 `COPY --chown=app:app` 保证目录权限正确。
3. **只复制必要文件**，别 `COPY . /` 一把梭。
4. **正确对待 PID 1 和信号**：容器主进程通常是 PID 1，应用要正确处理 `SIGTERM` 才能优雅退出。用 JSON 数组形式 `CMD ["node", "server.js"]` 比 shell 形式 `CMD node server.js` 好——信号能直达主进程，不会被 shell 吃掉。
5. **日志写到 stdout/stderr**，别写进容器里的文件。这样 `docker logs` 和日志采集系统才能统一收。
6. **一个容器一个主要职责**：Web 一个、数据库一个、Redis 一个、代理一个，别把定时任务和日志代理全塞进一个容器。

---

## 第八站：三个服务怎么一起管？——Compose 登场

到这一步，书友会已经有了三个容器：API、PostgreSQL、Redis。每次启动，小林都要敲三条 `docker run`，还要记得给它们建同一个网络、按顺序启动、配好环境变量。

他很快意识到，这不可持续。手动 `docker run` 越多，越容易出错——漏一个参数，服务就悄悄坏掉。

Docker Compose 就是来解决这个问题的：**用一个 YAML 文件，描述整个项目所有服务、网络、存储和依赖关系**，然后一个命令全部拉起。

注意现在的命令格式是：

```bash
docker compose
```

不是旧版的：

```bash
docker-compose
```

### compose.yaml：整个项目的蓝图

小林的书友会项目，用一个 `compose.yaml` 就描述清楚了：

```yaml
services:
  api:
    build:
      context: .
      dockerfile: Dockerfile
    image: bookclub-api:1.0.0
    ports:
      - "8080:8080"
    environment:
      APP_ENV: production
      DATABASE_URL: postgres://app:${POSTGRES_PASSWORD}@db:5432/app
      REDIS_URL: redis://redis:6379/0
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    restart: unless-stopped
    networks:
      - backend

  db:
    image: postgres:17-alpine
    environment:
      POSTGRES_DB: app
      POSTGRES_USER: app
      POSTGRES_PASSWORD: ${POSTGRES_PASSWORD}
    volumes:
      - postgres-data:/var/lib/postgresql/data
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U app -d app"]
      interval: 10s
      timeout: 5s
      retries: 5
    restart: unless-stopped
    networks:
      - backend

  redis:
    image: redis:7-alpine
    command: ["redis-server", "--appendonly", "yes"]
    volumes:
      - redis-data:/data
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 10s
      timeout: 3s
      retries: 5
    restart: unless-stopped
    networks:
      - backend

volumes:
  postgres-data:
  redis-data:

networks:
  backend:
    driver: bridge
```

这个文件把之前手动敲的所有 `docker run` 参数都"翻译"成了声明式配置：

- `api` 用本地 Dockerfile 构建，映射 8080 端口，通过 `${POSTGRES_PASSWORD}` 引用外部环境变量；
- `db` 和 `redis` 挂载数据卷、配了健康检查；
- 三个服务都挂在同一个 `backend` 网络下，`api` 里直接用服务名 `db`、`redis` 连接——还记得吗？**用名字，不用 IP**；
- `restart: unless-stopped` 保证意外挂掉后自动拉起。

启动整个项目：

```bash
docker compose up -d
```

一条命令，三个服务，全部就位。

### .env：敏感配置放这里

`${POSTGRES_PASSWORD}` 从哪来？从项目根目录的 `.env` 文件：

```
POSTGRES_PASSWORD=please-change-this-password
```

**不要**把真实密码提交到 Git 仓库。可以提交一个占位模板 `.env.example`：

```
POSTGRES_PASSWORD=replace-me
```

### 常用的 Compose 命令

小林把日常命令背了下来：

```bash
docker compose up -d            # 后台启动
docker compose up -d --build    # 重新构建并启动
docker compose ps               # 查看服务状态
docker compose logs -f          # 实时看所有服务日志
docker compose logs -f api      # 只看 API 的日志
docker compose exec api sh      # 进入 api 容器
docker compose run --rm api npm test   # 跑一次性命令
docker compose down             # 停止并删除容器和默认网络
docker compose down -v          # 连数据卷一起删（高危！数据会没）
docker compose config           # 查看最终生效的配置
```

`docker compose config` 特别有用：环境变量有没有正确替换、多个文件合并后是什么样、YAML 有没有写错，它一眼就能看出来。

### depends_on 的坑：启动了 ≠ 能服务了

小林一开始写的是：

```yaml
depends_on:
  - db
```

后来发现，API 还是会时不时连不上数据库。原因在于：`depends_on` 只保证**启动顺序**，不保证数据库已经能接受连接。容器"启动了"和"准备好服务了"是两回事。

稳妥的写法是配合健康检查：

```yaml
depends_on:
  db:
    condition: service_healthy
```

先让数据库通过 `healthcheck` 自检（`pg_isready`），API 才启动。同时，应用自身也要做连接重试——因为运行过程中数据库随时可能短暂断线，不能把希望全押在启动顺序上。

---

## 第九站：开发和生产的"两副面孔"——配置覆盖

书友会要上线了。小林发现一个麻烦：**开发环境和生产环境的诉求完全相反**。

开发时：要挂载源代码，改一行立刻生效；要用开发模式跑，方便调试。
生产时：要跑不可变的、测试过的、版本明确的镜像，绝不挂载源码。

一份 `compose.yaml` 怎么同时满足？

答案是：**用多个 Compose 文件覆盖配置**。

- `compose.yaml`：通用配置，所有人共用；
- `compose.override.yaml`：开发环境专属覆盖（Docker Compose 会自动读取它）；
- `compose.prod.yaml`：生产环境专属覆盖，用 `-f` 显式指定。

开发环境的覆盖文件长这样：

```yaml
services:
  api:
    build:
      target: development
    environment:
      APP_ENV: development
    volumes:
      - ./src:/app/src
    command: ["npm", "run", "dev"]
```

挂载了源码，改代码即时生效；用 `npm run dev` 跑开发模式。

生产部署时，显式指定生产文件：

```bash
docker compose \
  -f compose.yaml \
  -f compose.prod.yaml \
  up -d
```

生产环境跑的是版本明确的不可变镜像，不挂载任何源码。

### Compose Watch：开发时的"自动刷新"

在支持的 Compose 版本里，还有一个提升开发体验的功能：

```bash
docker compose up --watch
```

它会监视文件变化，自动同步文件、重建镜像或重启服务——改完代码，刷新浏览器就能看到效果，体验接近"热更新"。

---

## 第十站：上线前的安全加固——容器不是绝对沙箱

书友会要正式上线了。上线前，小林请一位做安全的同事帮忙过了遍配置。同事看完，给了他一份"安全清单"，还特别叮嘱了一句：

> 容器提供隔离，但它共享宿主机内核。错误配置，照样能把整台机器搭进去。

### 第一刀：别碰 --privileged

```bash
# 高风险，不要随意使用
docker run --privileged ...
```

`--privileged` 会把容器的权限放大到接近宿主机的程度——很多隔离保护直接失效。不到万不得已，别用。

### 第二刀：别挂载 Docker Socket

```bash
-v /var/run/docker.sock:/var/run/docker.sock
```

拿到 Docker Socket 的容器，就等于拿到了控制宿主机上所有容器的能力，风险接近拿到主机 root。这是很多"容器逃逸"事故的入口，能不用就不用。

### 第三刀：默认非 root

在 Dockerfile 里创建普通用户，进程用它跑：

```dockerfile
RUN addgroup -S app && adduser -S app -G app
USER app
```

### 第四刀：删掉用不上的 Capabilities

Linux 的 Capabilities 把 root 的权限拆成了很多小块，可以按需发放。遵循最小权限原则：

```bash
docker run \
  --cap-drop=ALL \
  --cap-add=NET_BIND_SERVICE \
  my-web:1.0.0
```

先把所有能力丢掉，再只加应用真正需要的。

### 第五刀：只读文件系统

```bash
docker run \
  --read-only \
  --tmpfs /tmp \
  my-app:1.0.0
```

根文件系统只读，容器里改不了任何东西，只能往 `/tmp` 写。攻击者想落盘都没地方。

### 第六刀：秘密永远不进镜像

小林的同事特别强调了这条：**镜像层是历史档案，删不掉。** 就算 Dockerfile 里写了 `RUN rm secret.txt`，秘密也还留在之前的镜像层里，随时能被翻出来。

正确做法是从一开始就不把秘密复制进普通镜像层——运行时注入，或者用 Secret 管理。

### 第七刀：及时更新基础镜像

固定版本 ≠ 永不更新。要建立周期性的更新流程：

1. 检查基础镜像更新；
2. 重建镜像；
3. 跑自动化测试；
4. 扫描已知漏洞；
5. 灰度发布；
6. 保留可回滚版本。

### 第八刀：别把数据库暴露到公网

小林原来的 `compose.yaml` 里写了：

```yaml
ports:
  - "5432:5432"
```

同事让他删掉。数据库只给同一个 Compose 网络里的 API 访问，**完全不需要对外暴露端口**——服务之间走内部网络就够了。暴露得越少，攻击面越小。

### 第九刀：只用可信镜像

拉第三方镜像之前，检查：

- 发布者身份；
- Dockerfile 或源码；
- 最近更新时间；
- 漏洞情况；
- 有没有不必要服务；
- 有没有要危险权限。

安全清单过完，小林又想起资源的事——书友会跑在一台小服务器上，他可不想让 Redis 把内存吃光，把整台机器拖垮。

---

## 第十一站：给容器"分蛋糕"——资源限制与重启策略

小服务器上同时跑着 API、数据库、Redis，还有一个留给将来的 Nginx。小林学会了给每个容器"分蛋糕"——限制它能吃多少资源。

限制内存：

```bash
docker run -d \
  --name api \
  --memory=512m \
  my-api:1.0.0
```

限制 CPU：

```bash
docker run -d \
  --name api \
  --cpus=1.5 \
  my-api:1.0.0
```

限制进程数（防止容器内部 fork 炸弹）：

```bash
docker run -d \
  --name api \
  --pids-limit=200 \
  my-api:1.0.0
```

只读根文件系统（配合 tmpfs 给临时文件一个去处）：

```bash
docker run -d \
  --read-only \
  --tmpfs /tmp \
  my-api:1.0.0
```

还有一个他一开始忽略的：**重启策略**。默认情况下容器崩了就崩了，不会自己爬起来。

```bash
docker run -d \
  --restart=unless-stopped \
  my-api:1.0.0
```

常见策略：

- `no`：不自动重启；
- `on-failure`：异常退出时重启；
- `always`：始终尝试重启；
- `unless-stopped`：除非被主动停止，否则自动重启。

小林在 Compose 里早就配了 `restart: unless-stopped`，现在明白了它的意义。

他提醒自己：**资源限制不是性能优化，是安全护栏**——它不让你跑得更快，但能保证一个失控的容器不会吃掉整台机器。

---

## 第十二站：同事的 Mac 跑不了我的镜像——多架构

书友会加了个新功能，负责前端的小周在自己的 MacBook（Apple Silicon，ARM 架构）上构建镜像，推到仓库后，小林在 x86_64 的服务器上一拉——**跑不起来**。

架构不同，二进制不通用。CPU 架构差异，是容器化团队协作里躲不开的坎。

解决办法是 **Buildx 多平台构建**：一次构建，同时产出 AMD64 和 ARM64 的镜像。

查看当前构建器：

```bash
docker buildx ls
```

创建并使用新的构建器：

```bash
docker buildx create --name multiarch --use
docker buildx inspect --bootstrap
```

同时构建两个架构并推送：

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t username/bookclub-api:1.0.0 \
  --push \
  .
```

原理是：仓库里存的其实是一个"镜像清单"（manifest list），里面列着各架构对应的镜像。用户拉同一个标签，仓库按运行平台的架构自动分发对应的那一份——**一个标签，各取所需**。

如果只想在本地加载单个架构（比如调试）：

```bash
docker buildx build \
  --platform linux/arm64 \
  -t bookclub-api:dev \
  --load \
  .
```

紧急情况也可以在 x86 机器上直接模拟运行 ARM 镜像：

```bash
docker run --platform linux/amd64 <镜像>
```

但模拟有性能损失，正规做法还是发布原生多平台镜像。

---

## 第十三站：半夜的告警——容器为什么会自己退出？

上线后的第三周，凌晨两点，小林被告警吵醒：书友会的 API 挂了。

他打开服务器，先看发生了什么：

```bash
docker ps -a
```

API 容器静静地躺在列表里，状态是 Exited。小林的第一反应是"服务器中病毒了"。查了半天才发现，真相朴素得有点丢人——

**容器的生命周期，和它的主进程绑在一起。主进程一结束，容器就退出。**

打个比方：容器像是"主进程住的房子"。房客（主进程）走了，房子自然就空了、关门了。

他之前跑过这样一个例子，一下就理解了：

```bash
docker run ubuntu echo hello
```

`echo hello` 执行完，主进程结束，容器立刻退出。所以容器"活着"的唯一条件是：**主进程还在跑**。

那他的 API 为什么退出？常见原因就那么几类：

- 主程序执行结束（比如把服务写成了"跑完就退"的脚本）；
- 配置错误，启动即失败；
- 端口冲突；
- 依赖（数据库/Redis）连接失败；
- 文件权限错误；
- 内存不足，被系统 OOM Kill；
- 程序崩溃；
- ENTRYPOINT 或 CMD 写错。

排查的顺序，小林总结成了三步：

```bash
docker ps -a              # 1. 确认容器状态
docker logs <容器名>       # 2. 看日志，找报错
docker inspect <容器名>    # 3. 看细节，查配置
```

看退出码也有个快捷方式：

```bash
docker inspect -f '{{.State.ExitCode}}' <容器名>
```

常见退出码要结合日志判断：比如 `137` 通常意味着进程被 `SIGKILL`，常见于内存不足被 OOM 干掉，或者被强制停止。但**退出码是线索，不是答案**——最终还是要看日志。

那天晚上小林发现，他的 API 是因为内存超限被 OOM 杀掉的——他给容器设了 512m 内存，但应用实际峰值超过了。调大内存，加个重启策略，搞定。

---

## 第十四站：踩坑实录——七个高频故障的排查清单

那之后，小林把自己和同事踩过的坑整理成了一份"排障清单"。遇到问题按图索骥，效率高了很多。

### 端口已被占用

报错通常长这样：

```
bind: address already in use
```

解决思路：

- 检查主机端口是否被占用；
- 换一个主机端口；
- 停掉冲突的服务。

```bash
docker run -p 8081:80 nginx
```

### 容器能启动，但浏览器访问不到

按顺序检查：

1. 应用是否监听 `0.0.0.0`，而不是只监听 `127.0.0.1`；
2. 是否正确配置了 `-p` 端口映射；
3. 容器内程序是否真的监听目标端口；
4. 主机防火墙和云安全组是否放行；
5. 应用是否启动失败（看日志）；
6. 反向代理是否配置正确。

### 容器之间无法通信

检查网络：

```bash
docker network ls
docker network inspect <网络名>
docker inspect <容器名>
```

重点确认：

- 两个容器是否在同一个网络；
- 是否用服务名/容器名连接（而不是 IP）；
- 目标服务是否监听容器网络接口；
- 用的是容器端口，不是主机映射端口。

比如 API 连数据库，应该写：

```
db:5432
```

而不是：

```
localhost:5432
```

**每个容器都有自己独立的 localhost**——`localhost` 指容器自己，不是隔壁的数据库。

### 改了代码，镜像却没变化

可能的原因：

- 构建缓存被复用（最常见）；
- 文件被 `.dockerignore` 忽略；
- 构建上下文选错；
- 还在跑旧容器；
- 镜像标签指向旧版本。

应急手段：

```bash
docker build --no-cache -t my-app:dev .
docker compose up -d --build --force-recreate
```

但 `--no-cache` 不是日常选项，最好先想清楚缓存为什么没失效。

### 磁盘空间越来越少

```bash
docker system df        # 先看谁占了空间
docker system prune     # 清理未使用对象
docker system prune -a  # 连非悬空镜像一起清
docker system prune -a --volumes   # 高危！数据卷也清
```

最后一条命令风险极高，执行前必须确认没有重要数据。

### 文件权限异常

Bind Mount 会把主机的文件权限带进容器，Linux 上常见 UID/GID 对不上的问题。

解决思路：

- 让容器用户 UID/GID 与主机用户匹配；
- 构建阶段就用 `COPY --chown` 设好所有权；
- 避免粗暴 `chmod 777`；
- 明确哪些目录需要写权限。

### Apple Silicon 上跑 x86 镜像

```bash
docker run --platform linux/amd64 <镜像>
```

能跑，但模拟有性能损失。更好的办法是发布原生 ARM64 或多平台镜像（第十二站讲过）。

---

## 第十五站：从开发到生产——一条可重复的交付流水线

排障能力有了，小林开始琢磨一个更根本的问题：**怎么保证每次发布都又快又稳？**

他意识到，Docker 的真正价值不在单点命令，而在**把整个交付过程变成一条可重复的流水线**：

```
编写代码
   ↓
编写 Dockerfile
   ↓
本地构建镜像
   ↓
运行单元测试和集成测试
   ↓
扫描依赖与镜像漏洞
   ↓
推送到镜像仓库
   ↓
部署指定版本镜像
   ↓
健康检查与监控
   ↓
失败时回滚到旧版本
```

### CI 里怎么构建和推送

书友会的 CI 流水线里，核心就是两条命令：

```bash
docker build \
  --tag registry.example.com/team/bookclub-api:${GIT_SHA} \
  .
docker push registry.example.com/team/bookclub-api:${GIT_SHA}
```

注意 tag 用的是 `${GIT_SHA}`——**每个提交都构建出唯一对应的镜像**，可追踪、可回滚。

### 部署时用不可变版本

部署配置里引用的是那个唯一的版本号：

```yaml
services:
  api:
    image: registry.example.com/team/bookclub-api:a8c9f21
```

### 最重要的一条原则：别手工改生产容器

小林把这句话贴在了工位上：

> 不要在生产部署时临时进入服务器修改容器文件。

手工改容器 = 制造一个不可复现的环境，容器一重建，改的东西全丢，别人也不知道改了什么。正确姿势永远是：

1. 修改代码或配置；
2. 提交版本控制；
3. 重新构建镜像；
4. 通过流水线部署；
5. 保留回滚能力。

---

## 第十六站：Compose 能扛住生产吗？——单机到集群的分水岭

书友会用户涨起来了。有人问小林：Compose 直接跑生产，行不行？

小林研究了一圈，答案是：**可以，但要看规模和需求。**

Compose 非常适合：

- 单机部署；
- 中小型内部系统；
- 开发和测试环境；
- 个人项目；
- 边缘设备；
- 对自动扩缩容要求不高的服务。

但当系统开始需要这些能力时，就要考虑 Kubernetes、Docker Swarm、Nomad 或云厂商容器平台了：

- 多主机调度；
- 自动扩缩容；
- 服务自愈；
- 滚动更新；
- 集群级服务发现；
- 复杂流量治理；
- 多租户资源管理；
- 更完整的 Secret、Policy 和可观测性体系。

一句话：**单机用 Compose，集群用 K8s。**

而且小林发现，学过 Docker 之后再看 Kubernetes，那些概念特别眼熟——Pod、Image、Volume、Network、Deployment，全都是 Docker 概念的延伸。**Docker 就是 K8s 最好的"前导课"。**

---

## 第十七站：小林的血泪清单——十个最常见的坑

书友会稳定运行了三个月。回头复盘，小林把踩过的坑、同事踩过的坑、网上看来的坑，整理成了十份"血泪教训"。每一条背后，都是一个真实的故障现场。

### 坑 1：把容器当虚拟机用

容器要围绕应用进程设计，别往里塞 systemd、SSH 和一整套传统服务器管理工具。容器不是"小虚拟机"，装得越多，越难维护、越不安全。

### 坑 2：用 latest 部署生产

`latest` 今天一个样，明天又一个样，版本不可追踪、难以复现和回滚。生产环境要的是**确定的版本**。

### 坑 3：把数据库数据放在容器可写层

容器一删，数据就没了。数据必须住在 Volume 或外部存储里——第二站就吃过这个亏。

### 坑 4：在镜像里写密码

就算后面 `RUN rm` 删掉，秘密也留在镜像层的历史里。镜像层是"历史档案"，写了就删不干净。

### 坑 5：所有容器都用 root 跑

应用一旦有漏洞，攻击者直接拿到最高权限。非 root 是底线。

### 坑 6：数据库端口暴露到公网

只给内部服务访问的数据库，就不该有 `ports`。暴露越少，攻击面越小。

### 坑 7：用容器 IP 连服务

容器重建 IP 就变。用服务名、容器名、内部 DNS——用名字，不用 IP。

### 坑 8：不限制日志大小

不配日志轮转，日志文件能撑爆磁盘。`max-size` 和 `max-file` 早点配上。

### 坑 9：进容器手工改生产文件

不可追踪、不可复制，容器一重建全丢。一切变更走代码、走流水线。

### 坑 10：一慌就 system prune -a --volumes

这命令连数据卷一起删。先 `docker system df` 看清楚，再决定清什么——**先看再删**。

---

## 第十八站：把常用命令贴在工位上——速查表

小林把最常用的命令整理成了速查表。建议你也存一份，用多了自然就记住了。

### 镜像

```bash
docker pull nginx:alpine
docker image ls
docker image inspect nginx:alpine
docker history nginx:alpine
docker image rm nginx:alpine
docker tag my-app:1.0 registry/my-app:1.0
docker push registry/my-app:1.0
```

### 容器

```bash
docker run -d --name web -p 8080:80 nginx
docker ps
docker ps -a
docker stop web
docker start web
docker restart web
docker rm -f web
docker logs -f web
docker exec -it web sh
docker inspect web
docker stats
docker cp ./index.html web:/usr/share/nginx/html/index.html
```

### 构建

```bash
docker build -t my-app:1.0.0 .
docker build --no-cache -t my-app:dev .
docker buildx ls
docker buildx build --platform linux/amd64,linux/arm64 --push .
```

### 数据卷

```bash
docker volume create app-data
docker volume ls
docker volume inspect app-data
docker volume rm app-data
docker volume prune
```

### 网络

```bash
docker network create app-net
docker network ls
docker network inspect app-net
docker network connect app-net web
docker network disconnect app-net web
docker network rm app-net
```

### Compose

```bash
docker compose up -d
docker compose up -d --build
docker compose ps
docker compose logs -f
docker compose exec api sh
docker compose run --rm api npm test
docker compose config
docker compose down
docker compose down -v
```

### 清理

```bash
docker system df
docker container prune
docker image prune
docker network prune
docker volume prune
docker system prune
docker builder prune
```

---

## 第十九站：从入门到精通——六个阶段的路线图

小林给后来者画了一张六阶段的路线图。每个阶段有明确的目标和练习，照着走不会迷路。

### 第一阶段：理解基本概念

目标：能解释镜像、容器、仓库、端口和数据卷。

练习：运行 Nginx、映射端口、看日志、进容器、删除并重建容器。

### 第二阶段：掌握 Dockerfile

目标：能把自己的应用做成镜像。

练习：给 Node.js、Python、Java 或 Go 项目写 Dockerfile；配 `.dockerignore`；理解构建上下文；优化缓存顺序；用非 root 用户。

### 第三阶段：掌握存储和网络

目标：能正确处理状态与服务通信。

练习：用 Volume 存数据库数据；用 Bind Mount 挂开发代码；建自定义网络；用服务名连数据库。

### 第四阶段：掌握 Docker Compose

目标：能一个命令拉起完整的多容器应用。

练习：Web + 数据库、Web + Redis；配环境变量；加健康检查；区分开发和生产配置。

### 第五阶段：掌握构建优化

目标：构建更快、更小、更安全。

练习：多阶段构建；BuildKit 缓存；多平台构建；镜像版本管理；自动化漏洞扫描。

### 第六阶段：掌握生产实践

目标：形成可部署、可监控、可回滚的交付流程。

练习：CI/CD 构建镜像；私有镜像仓库；日志轮转；资源限制；健康检查；滚动升级与回滚；Secret 管理；主机和容器安全加固。

---

## 第二十站：几个常被问到的关键问题

小林把新同事问得最多的问题汇总了一下，答案都很朴素。

### 镜像和容器是什么关系？

镜像是只读模板，容器是镜像的运行实例。一个是图纸，一个是按图纸盖好的房子。

### 删除容器会删除镜像吗？

不会。容器和镜像是两个不同的对象。

### 删除容器会删除 Volume 吗？

通常不会，除非显式删数据卷，或执行了带卷清理的命令（比如 `docker compose down -v`）。

### EXPOSE 会自动开放端口吗？

不会。它只是声明容器预期使用的端口，真正开放要靠 `-p` 或 Compose 的 `ports`。

### 为什么容器里不能用 localhost 连另一个容器？

因为容器里的 `localhost` 指向容器自己。要连别的容器，用对方的服务名或容器名。

### Dockerfile 每一行都会产生镜像层吗？

不是所有指令都以完全相同的方式产生文件系统层，但把它理解为"构建指令形成可缓存的构建步骤"，更有助于优化 Dockerfile。

### Docker 适合保存数据库吗？

可以，但数据必须放在可靠的持久化存储里，做好备份、恢复、监控和升级计划。**容器管运行，存储管数据，各司其职。**

### Docker 能替代 Kubernetes 吗？

不能简单说替代。Docker 解决镜像构建和容器运行，Kubernetes 解决大规模容器编排和集群管理。它们是上下游，不是对手。

---

## 结语：真正的精通，是建立可重复的交付体系

故事讲完了。

小林从周五晚上那个崩溃的部署开始，一路走到书友会稳稳当当跑在生产环境。他学会了敲：

```bash
docker run
docker build
docker exec
docker compose up
```

但他很清楚，这些命令只是表象。真正让他脱胎换骨的，是一整套工程思维：

- 环境应该可以通过代码描述；
- 镜像应该可以重复构建；
- 容器应该可以随时销毁和重建；
- 数据应该独立于容器生命周期；
- 配置和秘密应该在运行时安全注入；
- 服务应该通过稳定名称通信；
- 日志应该可以统一收集；
- 发布应该有明确版本；
- 失败应该可以快速回滚；
- 权限应该遵循最小化原则。

当你不再把服务器当成需要人工维护的"宠物"，而是把应用、配置和基础设施都变成可复制、可测试、可替换的交付单元时，才真正理解了 Docker 的价值。

> Docker 的核心不是"把程序装进容器"，而是让软件交付从经验操作变成标准化、自动化和可重复的工程流程。

书友会的故事告一段落，但你的故事才刚刚开始。打开终端，敲下第一条命令吧。

---

## 官方延伸阅读

- Docker 概览：https://docs.docker.com/get-started/docker-overview/
- Docker 入门：https://docs.docker.com/get-started/
- Dockerfile 最佳实践：https://docs.docker.com/build/building/best-practices/
- 多阶段构建：https://docs.docker.com/build/building/multi-stage/
- Docker Compose：https://docs.docker.com/compose/
- Compose 文件参考：https://docs.docker.com/reference/compose-file/
- Docker 网络：https://docs.docker.com/engine/network/
- Docker Volume：https://docs.docker.com/engine/storage/volumes/
- Docker Engine 安全：https://docs.docker.com/engine/security/
- 多平台构建：https://docs.docker.com/build/building/multi-platform/
