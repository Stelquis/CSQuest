# CNB 网址配置说明

## 概述

CNB（云原生构建）平台提供了**自动公网网址映射**能力。只需在项目中配置 Web 服务，CNB 会自动将容器内端口通过反向代理映射到一个**公网可访问的 URL**，无需手动配置域名或端口转发。

## 配置架构

CNB 的网址映射通过**两层配置文件**协同工作：

```
.cnb.yml          → 激活 Web 服务（告诉平台要暴露 Web）
.cnb/web.yml      → 定义端口和启动命令（告诉平台怎么启动）
CNB 平台层        → 自动反向代理（生成公网 URL）
```

## 第一步：激活 Web 服务（`.cnb.yml`）

在 `.cnb.yml` 的云原生开发环境配置中，需要在 `services` 列表中添加 `web`：

```yaml
# .cnb.yml
$:
  vscode:
    - name: 你的环境名称
      docker:
        image: 你的Docker镜像
      services:
        - vscode      # VS Code Web IDE
        - docker      # Docker 支持
        - web         # ★ 激活 Web 服务反向代理 ★
```

### `services` 字段说明

| 服务名 | 作用 |
|--------|------|
| `vscode` | 提供 VS Code Web IDE 在线编辑器 |
| `docker` | 允许在容器内使用 Docker |
| `web` | **激活 Web 服务，CNB 会自动读取 `.cnb/web.yml`** |

> **关键**：只有当 `services` 中包含 `web` 时，CNB 才会读取 `.cnb/web.yml` 并建立公网映射。

## 第二步：定义 Web 服务（`.cnb/web.yml`）

在项目根目录下创建 `.cnb/web.yml` 文件：

```yaml
# .cnb/web.yml
port: 8080
command: <你的 Web 服务启动命令>
```

### 配置项说明

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `port` | number | **是** | 容器内 Web 服务监听的端口号 |
| `command` | string | **是** | CNB 平台启动环境时执行的启动命令 |

### 常见启动命令示例

#### 静态网站（Python HTTP Server）

```yaml
port: 8080
command: cd /workspace/frontend && python3 -m http.server 8080 --bind 0.0.0.0
```

#### Node.js 应用

```yaml
port: 3000
command: cd /workspace && node server.js
```

#### React / Vue 开发服务器

```yaml
port: 5173
command: cd /workspace && npm run dev -- --host 0.0.0.0
```

#### Flask 应用

```yaml
port: 5000
command: cd /workspace && python3 app.py
```

#### Spring Boot 应用

```yaml
port: 8080
command: cd /workspace && java -jar app.jar
```

> **重要提示**：Web 服务必须绑定到 `0.0.0.0`（监听所有网络接口），而不能只绑定 `127.0.0.1`（localhost），否则 CNB 的反向代理无法访问。

## 第三步：CNB 平台自动映射

CNB 平台在检测到 `web` 服务后，会自动执行以下流程：

```
1. 执行 .cnb/web.yml 中定义的 command
2. 检测容器内指定端口是否就绪
3. 通过平台级反向代理（NGINX）建立公网映射
4. 在环境日志中输出公网访问 URL
```

### 公网 URL 格式

CNB 自动生成的 URL 格式为：

```
https://<项目名>.<命名空间>.cnb.cool
```

或者类似的 `*.cnb.cool` 子域名格式。

**特点：**
- 无需手动配置域名
- 无需配置 SSL 证书（自动 HTTPS）
- 全球任意浏览器均可访问
- URL 在环境启动后自动显示在日志中

## 当前项目配置

本项目（RWA 现实世界资产代币化系统）的 Web 服务配置：

### `.cnb.yml`（片段）

```yaml
$:
  vscode:
    - name: java-dev-env
      docker:
        image: docker.cnb.cool/orionseeker/csquest:latest
      services:
        - vscode
        - docker
        - web
```

### `.cnb/web.yml`（完整内容）

```yaml
port: 8080
command: cd /workspace/Blockchain/Project/frontend && python3 -m http.server 8080 --bind 0.0.0.0
```

### 映射关系

```
容器内部:   /workspace/Blockchain/Project/frontend/  (静态文件目录)
             ↓  (python3 -m http.server)
容器端口:   0.0.0.0:8080
             ↓  (CNB 平台反向代理)
公网 URL:   https://<项目名>.<命名空间>.cnb.cool → 任意浏览器可访问
```

## 访问流程

1. 在 CNB 平台启动云原生开发环境
2. CNB 自动执行 `command` 启动 Web 服务
3. CNB 自动建立反向代理映射
4. **在环境日志中找到公网 URL**（格式：`https://xxx.cnb.cool`）
5. 将该 URL 复制到**任意浏览器**中打开即可

## 常见问题

### Q: 为什么我访问 URL 显示 502？

A: 可能原因：
- Web 服务启动失败，检查 `.cnb/web.yml` 中的 `command` 是否正确
- 端口不匹配，检查 `port` 字段是否与实际监听端口一致
- 服务绑定在 `127.0.0.1` 而非 `0.0.0.0`

### Q: 可以不使用 8080 端口吗？

A: 可以。只需修改 `.cnb/web.yml` 中的 `port` 字段，并在 `command` 中指定相同端口即可。

### Q: 可以同时映射多个端口吗？

A: 目前 `.cnb/web.yml` 只支持单一端口映射。如需多个服务，可使用反向代理（如 Nginx）在容器内统一到一个端口。

### Q: URL 会变化吗？

A: 每次启动新的开发环境时，URL 可能不同。同一环境的 URL 在会话期间保持不变。

### Q: 是否需要配置防火墙或安全组？

A: 不需要。CNB 平台自动处理网络安全，URL 默认启用 HTTPS。

## 配置文件模板

可直接复制使用的空白模板：

**`.cnb.yml` Web 服务部分：**

```yaml
$:
  vscode:
    - name: my-web-app
      docker:
        image: <你的镜像>
      services:
        - vscode
        - docker
        - web
      stages:
        - name: workspace init
          script: |
            echo "环境就绪"
```

**`.cnb/web.yml`：**

```yaml
# CNB Web 服务配置
# 端口映射配置，用于外部访问

port: 8080
command: <替换为你的启动命令，注意绑定 0.0.0.0>
```
