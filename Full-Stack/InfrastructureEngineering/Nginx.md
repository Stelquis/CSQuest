# [Nginx 相关配置与使用](https://kbchulan.github.io/ClBlogs/blogs-main/mystore/06-nginx.html)

> 这是一个关于"派对主持人"的故事——一个刚上线的个人项目，和它从"一台裸奔的服务器"到"能扛流量、能挡攻击、能看得见日志"的完整成长史。你会跟着小站一起，把 Nginx 的每一面都摸一遍。读完之后你会发现：Nginx 是现代网络服务器的瑞士军刀，而配置文件才是它的刀刃。

---

## 故事的起点：一台扛不住的小服务器

小站是个爱折腾的开发者，攒了一个个人项目：一个静态官网，加一个跑在 8080 端口上的 API 服务。

上线第一天，朋友们闻讯而来。几十个人同时打开页面，服务器就喘上了粗气——API 服务一个人又当爹又当妈：既要伺候 HTML、CSS、图片这些静态文件，又要处理业务请求，还要独自面对公网上的恶意扫描。

小站想起朋友的一句话：

**"当数百人同时敲你的门，你需要一个派对主持人。"**

在网站世界里，Nginx（发音为 "Engine-X"）就是那个主持人——不是普通的主持人，而是能轻松应对成千上万人的超级主持。它诞生于 2004 年，由伊戈尔·西索耶夫（Igor Sysoev）创建，目标简单却强大：超越当时的 Web 服务器，尤其是在处理大量同时连接时。

更妙的是，它不只会"迎宾"。Nginx 是网页服务器界的瑞士军刀，一人分饰四角：

- **Web 服务器**：处理来自浏览器的请求并提供网页，处理图片、视频、纯 HTML 等静态内容时速度飞快；
- **反向代理**：站在你的应用服务器前面，充当外部世界与服务器之间的守门人，决定哪个后端处理每个请求，同时隐藏真实服务器；
- **负载均衡器**：流量大时不让一台服务器独自硬扛，把请求分散到多台机器；
- **缓存系统**：把同一页面只生成一次，之后直接把副本快速递给后来的人。

凭这份灵活性、速度与效率，Netflix、Airbnb、Dropbox 这些大牌都是它的用户。

小站决定：把自己的小站交给这位主持人打理。这个故事，就是他从安装到调优的完整路线图。

---

## 第一站：请主持人上场——安装与第一个页面

小站的服务器是 Ubuntu，安装只需三步：

```bash
sudo apt update
sudo apt install nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

这样就能开启 Nginx 服务并设置为开机自启。其他 Linux 发行版基本只是换个包管理器，比如 Arch：

```bash
sudo pacman -S nginx
sudo systemctl start nginx
sudo systemctl enable nginx
```

如果在 Windows 上，官方更建议用 WSL 来跑；若坚持原生运行，则从 [官网](https://nginx.org/en/) 下载 ZIP、解压到目标目录，在该目录打开终端输入 `start nginx` 即可启动。

验证很简单——打开浏览器访问 `http://localhost`，看到欢迎页面就说明 Nginx 已成功运行。

### 让它端上自己的菜

Nginx 默认从 `/var/www/html` 目录提供文件。小站先做了一个自己的页面：

```bash
echo "<h1>Welcome to NGINX!</h1>" | sudo tee /var/www/html/index.html
```

然后编辑主配置文件 `/etc/nginx/nginx.conf`，写一个最简单的 server 块：

```nginx
server {
    listen 80;
    server_name localhost;

    location / {
        root /var/www/html;
        index index.html;
    }
}
```

- `listen` 和 `server_name`：监听端口与服务器名称；
- `location` 块：定义请求的处理方式——这里把根路径指向 `/var/www/html`，并使用该目录下的 `index.html` 作为默认页面。

保存后重启服务，刷新浏览器，就能看到自己的页面：

```bash
sudo systemctl restart nginx
```

### 排查问题的三板斧

如果中途卡壳，小站学会了三个排查动作：

- **检查防火墙**：确保 80（HTTP）和 443（HTTPS）端口开放可访问；
- **查看服务状态**：

```bash
sudo systemctl status nginx
```

- **追错误日志**：

```bash
sudo tail -f /var/log/nginx/error.log
```

日志文件里包含 Nginx 遇到问题的详细信息，是诊断的第一现场。

---

## 第二站：守门人上任——反向代理

主持人第一份正式工作：别让客人直接闯进厨房。

既然有反向代理，自然的就会有正向代理。小站倾向于从用户身份分析两者的区别，核心在客户端的主动性：

- **正向代理**：用户主动使用的代理服务器，用户通过它访问外部资源，隐藏自己的真实身份，比如翻墙软件；
- **反向代理**：服务器端使用的代理服务器，用户并不知道它的存在。用户请求先到达反向代理，再由它转发到真实服务器，隐藏的是真实服务器的身份。

反向代理就像服务器的守门人，带来三个直接好处：

- **安全性**：后端服务器藏在 Nginx 之后，只有 Nginx 对公众开放，攻击面变小，基础设施更易管理；
- **负载均衡**：请求被分散到多个服务器，没有单一服务器会被压垮；
- **缓存**：Nginx 可以缓存后端响应，直接提供给客户端，减轻负载、加快响应。

### 把 8080 藏到身后

小站的 API 还在 8080 端口裸奔。他编辑 `/etc/nginx/sites-available/default`，替换服务器块：

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Nginx 在 80 端口监听 `example.com` 的请求，并转发到 `http://127.0.0.1:8080` 上的应用服务器。改完配置后是固定的三连：

```bash
sudo nginx -t              # 测试配置语法
sudo systemctl reload nginx
```

之后访问 `http://example.com`，看到的就是应用服务器在 8080 端口提供的内容——而后端的存在，外界一无所知。

### 进阶玩法

反向代理还有不少高级选项：

**负载均衡**——把请求分散到多个后端：

```nginx
upstream backend {
    server backend1.example.com;
    server backend2.example.com;
}

server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://backend;
    }
}
```

**SSL 终止**——在 Nginx 处卸载 SSL，后端可以纯 HTTP 通信：

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}
```

**缓存**——缓存后端响应以提升性能：

```nginx
location / {
    proxy_pass http://127.0.0.1:8080;
    proxy_cache my_cache;
    proxy_cache_valid 200 1h;
    proxy_cache_use_stale error timeout invalid_header updating;
}
```

---

## 第三站：分流的艺术——负载均衡

API 用户多了，一台机器撑不住。小站加了一台后端，让 Nginx 把流量摊开。

负载均衡对高流量应用至关重要，把请求均匀分布到多台服务器后：

- **防止服务器过载**：没有单一服务器承受全部流量，降低停机风险；
- **提升响应时间**：多台服务器同时处理请求，减少等待；
- **提高容错能力**：一台宕机，流量自动重定向到剩余服务器。

Nginx 支持多种负载均衡方法：

| 方法 | 规则 | 适用场景 |
| ---- | ---- | ---- |
| 轮询（Round Robin） | 默认方法，请求依次传给下一台服务器 | 通用场景 |
| 最少连接（Least Connections） | 请求发给当前活动连接数最少的服务器 | 各请求耗时不均 |
| IP 哈希 | 来自特定客户端的请求总是发到同一服务器 | 需要会话持久性 |

### 用轮询搭起来

先定义 upstream 区块中的后端服务器：

```nginx
upstream myapp {
    server backend1.example.com;
    server backend2.example.com;
}
```

再让服务器块使用上游组：

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_pass http://myapp;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

老规矩测试并重载：

```bash
sudo nginx -t
sudo systemctl reload nginx
```

验证方式很朴素：多发几个请求（curl 或浏览器），观察它们在两台后端之间的分布。

### 进阶配置

**最少连接**：

```nginx
upstream myapp {
    least_conn;
    server backend1.example.com;
    server backend2.example.com;
}
```

**IP 哈希的会话持久性**：

```nginx
upstream myapp {
    ip_hash;
    server backend1.example.com;
    server backend2.example.com;
}
```

**健康检查**——确保流量只发给健康的服务器：

```nginx
upstream myapp {
    server backend1.example.com;
    server backend2.example.com;
    server backend3.example.com backup;

    # Health check
    server backend1.example.com max_fails=3 fail_timeout=30s;
}
```

---

## 第四站：上锁与限流——安全加固

守门人还得会安保。

### SSL/TLS 加密

最重要的安全措施是加密客户端与服务器之间的通信，让数据无法被轻易拦截。证书可以从 [Let's Encrypt](https://letsencrypt.org/) 免费获得，或从可信 CA 购买。

```nginx
server {
    listen 443 ssl;
    server_name example.com;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers 'ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384';
    ssl_prefer_server_ciphers on;

    location / {
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

为了确保所有流量都加密，把 HTTP 重定向到 HTTPS：

```nginx
server {
    listen 80;
    server_name example.com;
    return 301 https://$host$request_uri;
}
```

### 速率限制

速率限制可以保护应用免受暴力破解、DoS 攻击等滥用——限制客户端在指定时间内的请求次数，恶意用户就淹不了服务器。两个关键参数：

- **Burst**：突发参数，允许客户端超过速率限制一定数量而不被延迟或拒绝；
- **Nodelay**：禁用延迟机制，一旦超过突发限制，额外请求立即被拒绝。

在 `http` 区块定义限流区域：

```nginx
http {
    limit_req_zone $binary_remote_addr zone=mylimit:10m rate=10r/s;
}
```

这创建了一个名为 `mylimit` 的区域：每个客户端 IP 每秒允许 10 次请求，区域最多存储 10MB 数据——足以追踪约 160,000 个 IP 地址。

再对登录页应用限流：

```nginx
server {
    location /login {
        limit_req zone=mylimit burst=20 nodelay;
        proxy_pass http://127.0.0.1:8080;
    }
}
```

允许无延迟地突发 20 个请求，超过后其余请求将被拒绝。还可以自定义超限时的响应：

```nginx
error_page 503 @limit;

location @limit {
    return 429 "Too Many Requests";
}
```

限流不是一劳永逸的，要持续观察调整：

- **监控被限的请求**：`grep "429" /var/log/nginx/access.log`，看有多少请求被阻断；
- **按需调整**：合法用户频繁被限就提高速率或突发大小；放得太松就收紧；
- **分位置独立限流**：登录页可以比通用 API 端点更严格。

同时别忘了限流只是工具箱之一，配合使用效果更好：

- **IP 白名单/黑名单**：允许或屏蔽特定 IP；
- **验证码**：在登录、注册等敏感操作中加验证码挑战；
- **WAF（网络应用防火墙）**：检测并阻断恶意流量。

### 安全头

点击劫持是一种恶意技术——攻击者诱使用户点击与感知不同的内容。设置 `X-Frame-Options` 头部可以缓解：

```nginx
server {
    add_header X-Frame-Options "SAMEORIGIN" always;

    location / {
        proxy_pass http://127.0.0.1:8080;
    }
}
```

该头部确保内容不会被嵌入其他网站的 iframe，降低点击劫持风险。一次配齐一套安全头：

```nginx
server {
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Content-Security-Policy "default-src 'self'; script-src 'self'; object-src 'none'; frame-ancestors 'none'; base-uri 'self';" always;
    add_header Referrer-Policy "no-referrer-when-downgrade" always;
}
```

每个头的分工：

| 安全头 | 作用 |
| ---- | ---- |
| Strict-Transport-Security (HSTS) | 强制对服务器进行 HTTPS 安全连接 |
| X-Frame-Options | 控制浏览器是否允许在帧内渲染页面，防点击劫持 |
| X-Content-Type-Options | 阻止浏览器通过 MIME 嗅探响应 |
| Content-Security-Policy (CSP) | 指定允许加载的内容来源，帮助防 XSS |
| Referrer-Policy | 控制请求中包含的引荐信息量 |

---

## 第五站：把常用的记住——缓存

Nginx 最强大的能力之一就是缓存：存储频繁请求内容的副本，直接从缓存提供请求，减轻后端负载、加快响应。

缓存的价值很直接：

- **降低服务器负载**：后端无需处理重复请求，能做更多独特的任务；
- **提升响应时间**：缓存内容更快被提供；
- **节省带宽**：服务器和客户端之间传输的数据变少。

### 基础缓存

**定义缓存区**——在 `http` 区块里声明它：

```nginx
http {
    proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m max_size=1g inactive=60m use_temp_path=off;
}
```

这创建名为 `my_cache` 的缓存区：最大容量 1 GB，存储路径 `/var/cache/nginx`。

**在服务器块中启用**：

```nginx
server {
    listen 80;
    server_name example.com;

    location / {
        proxy_cache my_cache;
        proxy_cache_valid 200 302 10m;
        proxy_cache_valid 404 1m;
        proxy_pass http://127.0.0.1:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

成功响应（200 和 302）缓存 10 分钟，404 缓存 1 分钟。

**绕过或刷新缓存**——允许客户端带特定头绕过缓存：

```nginx
server {
    location / {
        proxy_cache_bypass $http_cache_control;
        proxy_no_cache $http_cache_control;
    }
}
```

### 持续维护

缓存是动态过程，需要随时间监控调整：

- **清除缓存内容**：可借助第三方模块 `ngx_cache_purge`，或手动从缓存目录移除文件（效率较低）；
- **监控缓存性能**：定期看日志或状态模块，关注缓存命中率（hit/miss ratio）；
- **调整缓存设置**：根据监控情况调整大小、有效期或缓存对象，目标是平衡缓存效率与内容新鲜度。

---

## 第六站：看得见，才管得住——日志与监控

了解服务器上发生了什么，是维护应用健康的前提。

### 访问日志与错误日志

Nginx 会记录它处理的每一个请求和发生的任何错误。

**自定义访问日志格式**：

```nginx
http {
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log /var/log/nginx/access.log main;

    # Other settings...
}
```

**错误日志**——记录连接失败、指令配置错误等问题：

```nginx
error_log /var/log/nginx/error.log warn;
```

严重程度为警告或更高。改完重启生效：

```bash
sudo systemctl restart nginx
```

### 监控与告警

**ngxtop 实时监控**——命令行工具，解析访问日志并实时给出性能指标：

```bash
# 使用 pip 安装 ngxtop
pip install ngxtop

# 运行 ngxtop 监控 NGINX 访问日志
ngxtop
```

会实时显示请求计数、响应时间和状态码等统计数据。

**接入监控服务**：更全面的做法是把 Nginx 与 Prometheus、Grafana 或 Datadog 集成——收集指标、仪表盘可视化、问题告警一条龙。

**快速日志分析**：

```bash
tail -f /var/log/nginx/access.log
grep "404" /var/log/nginx/error.log
```

**配置告警**：可以用 `logwatch` 每天发送 Nginx 日志摘要邮件（`sudo apt install logwatch` 后配置监控 nginx 日志）；使用 Datadog 等服务的话，可以基于响应时间、错误率或流量设置自定义警报，通过邮件、短信或 Slack 提醒。

---

## 第七站：高峰期前的大扫除——性能优化

流量上来之前，小站决定把 Nginx 再拧紧一圈。

### 工作进程与连接数

Nginx 用工作进程处理请求，进程和连接的数量直接影响性能：

```nginx
worker_processes auto;
```

根据可用 CPU 核心数自动设置工作进程数量。再调每个进程能处理的连接数：

```nginx
events {
    worker_connections 1024;
}
```

高流量下可以根据服务器容量进一步增大。

### 静态内容与压缩

**静态内容缓存**——图片、CSS、JS 缓存 30 天，减少向后端反复取用：

```nginx
location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
    expires 30d;
    add_header Cache-Control "public, no-transform";
}
```

**gzip 压缩**——发送前压缩响应，显著降低带宽、改善加载时间：

```nginx
http {
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
    gzip_min_length 1000;
}
```

### 缓冲区与超时

缓冲区和超时在高负载下起关键作用：

```nginx
http {
    client_body_buffer_size 16K;
    client_max_body_size 10M;
    client_header_buffer_size 1k;
    large_client_header_buffers 4 16k;
}
```

更大的缓冲区帮助 Nginx 高效处理较大的请求和响应。

```nginx
http {
    client_body_timeout 12s;
    client_header_timeout 12s;
    keepalive_timeout 15s;
    send_timeout 10s;
}
```

超时控制 Nginx 等待客户端或后端收发数据的时间，防止挂断的连接白白消耗资源。

### 高流量下的负载均衡

选择合适的算法，例如 `least_conn` 把流量发给连接最少的服务器：

```nginx
upstream backend {
    least_conn;
    server backend1.example.com;
    server backend2.example.com;
}
```

并启用健康检查，只把流量发给能处理的服务器：

```nginx
upstream backend {
    server backend1.example.com;
    server backend2.example.com;
    server backend3.example.com backup;
}
```

---

## 结语：主持人就位

故事讲完了。

小站的小站，从一台裸奔的服务器，长成了这样一副模样：

- 静态文件由 Nginx 直出，API 藏在反向代理身后；
- 两台后端在 upstream 里轮班，坏一台流量自动让路；
- 全站 HTTPS，HTTP 一律 301 过去；
- 登录接口挂着限流，响应头里站着一排安全卫士；
- 热点内容躺在缓存里，命中率高得让后端清闲；
- 访问日志和错误日志各就各位，ngxtop 实时盯着。

他记住了一件事：Nginx 成功的关键不仅在于初始设置，更在于持续监控、优化和适应不断变化的需求。

> 无论你管理的是单台服务器还是复杂的网络基础设施，Nginx 只要配置得当，都能显著提升网络应用的性能、安全性和可扩展性。

小站的故事告一段落，你的服务器还在裸奔吗？打开终端，敲下 `sudo apt install nginx` 吧。

---

## 参考资料

- 原文：KBchulan 的博客《06 Nginx》：https://kbchulan.github.io/ClBlogs/blogs-main/mystore/06-nginx.html
- Nginx 官方文档：https://nginx.org/en/docs/
- Nginx 入门指南（ beginner's guide）：https://nginx.org/en/docs/beginners_guide.html
- ngx_http_proxy_module（反向代理与缓存）：https://nginx.org/en/docs/http/ngx_http_proxy_module.html
- ngx_http_limit_req_module（速率限制）：https://nginx.org/en/docs/http/ngx_http_limit_req_module.html
- ngx_http_upstream_module（负载均衡）：https://nginx.org/en/docs/http/ngx_http_upstream_module.html
- Let's Encrypt 免费证书：https://letsencrypt.org/

> 📌 版本提示：本文基于 Nginx 主线版本的常用配置整理，个别指令（如缓存路径、TLS 配置）随版本演进可能有差异，以官方文档为准。
