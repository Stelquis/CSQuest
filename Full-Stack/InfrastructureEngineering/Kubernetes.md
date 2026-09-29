# [Kubernetes从入门到精通：从第一个Pod到生产级集群](https://mp.weixin.qq.com/s/nIQL3nujUk40PxEQwYBqow)

> 这是一个关于"鹿鸣课堂"的故事——一个刚熬过第一次大促崩溃的三人小团队，和他们从"单机 Docker"走向"生产级 Kubernetes 集群"的完整旅程。你会跟着沈舟一起，把 Pod、Deployment、Service 这些名词一个个变成手里能跑的 YAML，再把它们变成一套稳稳当当的平台。读完之后你会发现：Kubernetes 的学习曲线确实陡，但核心思想并不复杂。

---

## 故事的起点：大促那晚，一台服务器撑不住所有梦想

"鹿鸣课堂"是一个三个人做的在线课程平台：一个 Node.js 写的 API，一个 MySQL 存课程和订单，一个 Redis 做缓存，外加一套用 Nginx 托着的静态页面。

大促之前，一切都在一台云服务器上跑得挺好。沈舟早半年就把整套服务用 Docker 容器化了——`docker run` 一条条敲上去，容器排成一列，井然有序。他当时挺得意：环境问题彻底解决了。

大促当晚，流量来了。先是 API 响应变慢，然后 Redis 内存告警，接着 MySQL 连接数打满。沈舟想扩容，可服务全在一台机器上，扩无可扩。他连夜买了台新服务器，手动装环境、拷镜像、改 Nginx 上游——凌晨四点，新机器终于接上一半流量。天亮时他瘫在椅子上，看着监控曲线里那两个割裂的实例，忽然想明白了一件事：

**Docker 解决的是"如何打包和运行一个容器"，但它不解决"如何在一组机器上长期、稳定、自动化地运行大量容器化应用"。**

一个人肉运维的容器集群，和大促的流量曲线一样，随时会崩。

沈舟把这一晚的问题列在白板上，密密麻麻：

- 一台服务器宕机，容器如何迁移？
- 一个实例扛不住流量，如何扩容到十个？
- 十个实例的 IP 地址不同，客户端连接谁？
- 发布新版本时，如何做到不中断服务？
- 容器重启后，数据如何保留？
- 开发、测试、生产环境如何使用不同配置？
- 某个实例看似在运行，但业务已经无法响应，如何自动摘除？
- 如何限制某个应用最多使用多少 CPU 和内存？
- 如何记录每次变更，并在失败时回滚？

团队里的架构师老赵看了白板，只说了一句："这些问题，业界已经抽象成一组标准化 API 了，那个东西叫 Kubernetes。它用控制器持续维护系统状态，你列的每一条，都有对应的答案。"

沈舟决定认真学一次 Kubernetes。但老赵提醒他：Kubernetes 不只是"启动容器的工具"，而是一套面向分布式系统的**声明式管理平台**。真正掌握它，不是记住多少条 kubectl 命令，而是理解：期望状态、控制循环、不可变基础设施、服务发现、故障自愈和自动化运维。

很多开发者第一次接触 Kubernetes，会被 Pod、Deployment、Service、Ingress、ConfigMap、Secret、PV、PVC、StatefulSet 这些概念淹没。但换个角度，Kubernetes 实际上始终在回答几个问题：

1. 应用应该运行几个实例？
2. 实例应该运行在哪些机器上？
3. 实例挂了之后谁来恢复？
4. 实例地址变化后，其他服务如何找到它？
5. 应用如何读取配置、密码和持久化数据？
6. 流量增加时，如何自动扩容？
7. 新版本发布失败时，如何快速回滚？
8. 多个团队共用集群时，如何隔离权限和资源？

截至 2026 年 7 月 22 日，Kubernetes 官方最新稳定补丁版为 v1.36.2。沈舟的学习笔记以 v1.36 系列文档为参考，但绝大多数核心概念同样适用于近几个版本。

这个故事，就是沈舟从第一个 Pod 到生产级集群走完的路线图。

---

## 第一站：先换一个脑子——声明式管理

沈舟以前做运维的思路是"命令式"：在服务器 A 上启动容器、在服务器 B 上再启动一个、删除旧容器、把新容器加入负载均衡。每一步都是一条指令，执行完就完了，没人保证结果一直成立。

Kubernetes 的思路是"声明式"：

```yaml
spec:
  replicas: 3
```

你只需要告诉 Kubernetes：**我希望这个应用始终有 3 个副本。**至于这 3 个副本运行在哪些节点、某个副本崩溃后如何补齐、节点宕机后如何重建，都由 Kubernetes 控制器完成。

### 期望状态与实际状态

老赵给沈舟画了 Kubernetes 最核心的循环：它不断比较——

- **期望状态**：3 个 Pod
- **实际状态**：2 个 Pod
- **差异**：少 1 个
- **动作**：创建 1 个新 Pod

这一过程称为**调谐（reconcile）**，背后依赖持续运行的控制循环。

### Kubernetes 对象

Kubernetes 使用对象描述系统状态，沈舟把常见对象抄在了笔记本上：

- **Pod**：运行容器的最小调度单元
- **Deployment**：管理无状态应用
- **StatefulSet**：管理有状态应用
- **DaemonSet**：让指定节点各运行一个副本
- **Job**：运行一次性任务
- **CronJob**：运行定时任务
- **Service**：为一组 Pod 提供稳定访问入口
- **ConfigMap**：保存非敏感配置
- **Secret**：保存敏感数据
- **PersistentVolumeClaim**：申请持久化存储
- **HorizontalPodAutoscaler**：根据指标自动扩缩容

### YAML 四大核心字段

绝大多数资源清单都包含四个核心字段：

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 3
```

它们分别表示：

| 字段 | 作用 |
| --- | --- |
| `apiVersion` | 使用哪个 API 版本 |
| `kind` | 创建哪种资源 |
| `metadata` | 名称、命名空间、标签和注解 |
| `spec` | 用户声明的期望状态 |

老赵教了沈舟一招查询一个资源支持哪些字段的方式，他称之为"学习 Kubernetes YAML 最实用的方式之一"：

```bash
kubectl explain deployment
kubectl explain deployment.spec
kubectl explain deployment.spec.template.spec.containers
```

---

## 第二站：拆开黑盒——集群架构

学声明式概念的同时，沈舟也在弄清楚另一件事：他敲下的每一条 kubectl 命令，到底是谁在干活。一个 Kubernetes 集群通常由两部分组成：

```
Kubernetes 集群
├── 控制平面 Control Plane
│   ├── kube-apiserver
│   ├── etcd
│   ├── kube-scheduler
│   ├── kube-controller-manager
│   └── cloud-controller-manager（云环境可选）
│
└── 工作节点 Worker Node
    ├── kubelet
    ├── 容器运行时
    ├── kube-proxy或其他数据面实现
    └── Pod
```

### kube-apiserver

API Server 是整个集群的统一入口。kubectl、控制器、调度器以及各种扩展组件，几乎都通过 API Server 读写集群状态。例如：

```bash
kubectl get pods
```

本质上是向 API Server 发送查询请求。

### etcd

etcd 是分布式键值存储，保存 Kubernetes 集群的关键状态，比如 Deployment 定义、Pod 信息、Service 信息、Secret 和 ConfigMap、节点状态、RBAC 规则。

老赵在这条下面重重画了线：**生产环境必须重视 etcd 的备份、加密、权限和容灾。没有可靠的 etcd，就没有可靠的控制平面。**

### kube-scheduler

调度器负责为尚未分配节点的 Pod 选择合适节点。它会综合考虑：CPU 和内存是否充足、节点选择器、节点亲和性、Pod 亲和性与反亲和性、污点和容忍、拓扑分布约束、存储限制、优先级和抢占。

调度器只决定"放在哪里"，并不直接启动容器。

### kube-controller-manager

它运行多个控制器，例如 Deployment Controller、ReplicaSet Controller、Node Controller、Job Controller、EndpointSlice Controller。控制器持续观察实际状态，并推动系统接近期望状态——这正是第一站里"调谐"的执行者。

### kubelet 与容器运行时

kubelet 运行在每个工作节点上，负责确保分配给该节点的 Pod 正常运行。它会与 API Server 通信、调用容器运行时、挂载卷、执行健康检查、上报节点与 Pod 状态。

Kubernetes 通过 CRI 与容器运行时交互，常见实现包括 containerd 和 CRI-O。沈舟注意到一个细节：**Kubernetes 管理的是容器，但并不要求节点必须直接使用 Docker Engine 作为运行时。**

### 网络与 DNS 组件

一个可用集群通常还需要：CNI 网络插件、CoreDNS、Ingress Controller 或 Gateway API 实现、Metrics Server、CSI 存储驱动、日志和监控组件。这些组件共同补齐 Kubernetes 的网络、存储和可观测能力。

---

## 第三站：不买服务器也能练手——搭建本地学习环境

老赵说，学 Kubernetes 没有必要一开始就购买多台云服务器。常见本地方案：

| 工具 | 特点 | 适用场景 |
| --- | --- | --- |
| minikube | 上手简单，插件丰富 | 初学和单机实验 |
| kind | 使用容器创建节点，启动快 | CI、测试、多节点实验 |
| Docker Desktop Kubernetes | 图形化集成 | 已使用 Docker Desktop 的开发者 |
| k3d | 在容器中运行轻量级 k3s | 边缘和轻量实验 |

沈舟选择了 minikube。

### 安装 kubectl

macOS 使用 Homebrew：

```bash
brew install kubectl
kubectl version --client
```

Windows 可以使用 winget：

```bash
winget install -e --id Kubernetes.kubectl
kubectl version --client
```

Linux 可以使用发行版包管理器，也可以下载官方二进制文件。

### 启动 minikube

```bash
minikube start
```

查看集群状态：

```bash
minikube status
kubectl cluster-info
kubectl get nodes -o wide
```

输出中节点状态为 Ready，说明集群可以工作。

### 检查当前上下文

kubeconfig 用来保存集群、用户和上下文信息：

```bash
kubectl config current-context
kubectl config get-contexts
kubectl config view
```

切换上下文：

```bash
kubectl config use-context minikube
```

老赵特别叮嘱：在生产环境中执行命令前，**养成检查上下文的习惯，避免误操作其他集群**。这条后来救过沈舟不止一次。

---

## 第四站：先学会"看"——kubectl 必会命令

### 查看资源

```bash
kubectl get nodes
kubectl get pods
kubectl get pods -A
kubectl get deployments
kubectl get services
kubectl get all
```

显示更多信息：

```bash
kubectl get pods -o wide
kubectl get deployment web -o yaml
kubectl get pods --show-labels
```

持续观察变化：

```bash
kubectl get pods -w
```

### 查看详细状态

```bash
kubectl describe pod <pod-name>
kubectl describe deployment web
kubectl describe node <node-name>
```

describe 特别适合查看：调度失败原因、镜像拉取错误、探针失败、挂载失败、事件记录。

### 查看日志

```bash
kubectl logs <pod-name>
kubectl logs -f <pod-name>
kubectl logs <pod-name> -c <container-name>
kubectl logs <pod-name> --previous
```

`--previous` 可以查看容器上一次崩溃前的日志——排查 CrashLoopBackOff 时的利器。

### 进入容器与端口转发

```bash
kubectl exec -it <pod-name> -- sh
```

多容器 Pod：

```bash
kubectl exec -it <pod-name> -c <container-name> -- sh
```

端口转发：

```bash
kubectl port-forward service/web 8080:80
```

然后访问 `http://127.0.0.1:8080`。

### 创建与删除资源

```bash
kubectl apply -f app.yaml
kubectl delete -f app.yaml
```

推荐优先使用声明式的 apply，而不是长期依赖大量命令式操作——这是对第一站"声明式思想"的呼应。

### 按标签筛选与输出 JSONPath

```bash
kubectl get pods -l app=web
kubectl delete pods -l app=web
```

```bash
kubectl get pods \
  -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.status.phase}{"\n"}{end}'
```

熟练使用 JSONPath，可以显著提升批量排查效率。

---

## 第五站：给资源安个家——命名空间、标签与注解

### Namespace：逻辑隔离

创建命名空间：

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: demo
```

```bash
kubectl apply -f namespace.yaml
kubectl get pods -n demo
kubectl apply -f app.yaml -n demo
```

设置当前上下文的默认命名空间：

```bash
kubectl config set-context --current --namespace=demo
```

Namespace 适合用于：环境隔离（dev、test、prod）、团队隔离、项目隔离、配额和权限边界。

但沈舟在笔记里记下了一个容易忽视的点：**Namespace 不是完整的安全隔离**，需要配合 RBAC、ResourceQuota、LimitRange、NetworkPolicy 和 Pod Security。

### Label：资源选择

```yaml
metadata:
  labels:
    app: web
    environment: production
    version: v1
```

Label 会被以下对象广泛使用：Service、Deployment、NetworkPolicy、调度策略、监控和成本统计。

好的标签体系应该**稳定、可预测、可查询**。

### Annotation：附加元数据

```yaml
metadata:
  annotations:
    owner: "platform-team"
    description: "public web service"
```

Annotation 不用于资源筛选，适合保存：负责人、构建信息、外部系统配置、证书与 Ingress 配置、变更说明。

---

## 第六站：从裸 Pod 到 Deployment——鹿鸣课堂的 API 上集群

### Pod 是什么？

Pod 是 Kubernetes 最小的可部署和调度单元。一个 Pod 可以包含一个或多个容器，这些容器共享：网络命名空间、Pod IP、端口空间、可挂载的数据卷、生命周期。

典型的多容器 Pod 模式包括：

- 主应用容器 + 日志代理
- 主应用容器 + Service Mesh Sidecar
- Init Container + 主应用容器

沈舟先创建了一个最朴素的 Pod：

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  containers:
    - name: nginx
      image: nginx:1.27-alpine
      ports:
        - containerPort: 80
```

```bash
kubectl apply -f pod.yaml
kubectl get pods
```

但是，生产环境通常不直接管理裸 Pod。原因是：

- Pod 被删除后不会自动重建
- 不方便滚动更新
- 不方便扩缩容
- 不方便版本回滚

### Deployment 管理无状态应用

沈舟把鹿鸣课堂的 API 服务改写成了 Deployment。Deployment 管理 ReplicaSet，ReplicaSet 再负责维护 Pod 数量：

```
Deployment
└── ReplicaSet
    ├── Pod
    ├── Pod
    └── Pod
```

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: demo
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  template:
    metadata:
      labels:
        app: web
        version: v1
    spec:
      containers:
        - name: web
          image: nginx:1.27-alpine
          ports:
            - name: http
              containerPort: 80
```

应用后查看：

```bash
kubectl apply -f deployment.yaml
kubectl get deployments -n demo
kubectl get replicasets -n demo
kubectl get pods -n demo -l app=web
```

### 扩缩容

```bash
kubectl scale deployment web \
  --replicas=5 \
  -n demo
```

```bash
kubectl get deployment web -n demo
```

### 滚动更新

修改镜像：

```bash
kubectl set image deployment/web \
  web=<你的镜像仓库>/web:v2 \
  -n demo
```

观察发布过程：

```bash
kubectl rollout status deployment/web -n demo
kubectl get pods -n demo -w
```

### 查看与回滚版本

```bash
kubectl rollout history deployment/web -n demo
kubectl rollout undo deployment/web -n demo
```

回滚到指定版本：

```bash
kubectl rollout undo deployment/web \
  --to-revision=2 \
  -n demo
```

沈舟在笔记本上写下：**生产发布的关键不是"能够更新"，而是更新过程不中断、新实例通过就绪检查后再接流量、发布失败可及时发现、可快速回滚、变更有记录。**

---

## 第七站：不同形状的应用，不同的管家——工作负载控制器怎么选

| 控制器 | 适用场景 |
| --- | --- |
| Deployment | Web、API、微服务等无状态应用 |
| StatefulSet | 数据库、消息队列、需要稳定身份的应用 |
| DaemonSet | 每个节点运行一个日志、监控或网络代理 |
| Job | 数据迁移、批处理、一次性任务 |
| CronJob | 定时备份、定时报表、周期清理 |

### StatefulSet

StatefulSet 适用于需要以下特性的应用：稳定的网络身份、稳定的存储、有序部署、有序扩缩容、有序滚动更新。Pod 名称通常具有稳定序号：

```
mysql-0
mysql-1
mysql-2
```

老赵提醒沈舟：**不要因为 StatefulSet 支持稳定身份，就认为任意数据库放进去后自动获得高可用。**数据库复制、选主、备份和一致性仍然需要应用自身或 Operator 负责。

### DaemonSet

DaemonSet 会在符合条件的节点上各运行一个 Pod。常见用途：日志采集代理、节点监控 Agent、网络插件、存储插件、安全检测 Agent。

### Job

```yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: data-migration
spec:
  backoffLimit: 3
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: migration
          image: busybox:1.36
          command: ["sh", "-c", "echo start; sleep 5; echo done"]
```

```bash
kubectl get jobs
kubectl logs job/data-migration
```

### CronJob

```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: report
spec:
  schedule: "0 2 * * *"
  concurrencyPolicy: Forbid
  successfulJobsHistoryLimit: 3
  failedJobsHistoryLimit: 3
  jobTemplate:
    spec:
      template:
        spec:
          restartPolicy: Never
          containers:
            - name: report
              image: busybox:1.36
              command: ["sh", "-c", "date; echo generate report"]
```

这里表示每天 02:00 执行一次。沈舟给鹿鸣课堂的数据库备份任务挑的就是它——生产环境还要注意时区、幂等性、超时和并发策略。

---

## 第八站：给善变的 Pod 一个稳定入口——Service

Pod 是短暂的。滚动更新、故障恢复和重新调度都会让 Pod IP 发生变化。因此，其他应用不应该把某个 Pod IP 写死。

Service 使用 Label Selector 选择一组 Pod，并提供稳定的虚拟 IP 和 DNS 名称：

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: demo
spec:
  selector:
    app: web
  ports:
    - name: http
      port: 80
      targetPort: http
  type: ClusterIP
```

```bash
kubectl apply -f service.yaml
kubectl get service -n demo
kubectl get endpointslices -n demo
```

集群内部可以通过 DNS 访问：

```
web.demo.svc.cluster.local
```

同一命名空间内通常可以直接使用 `web`。

### Service 常见类型

**ClusterIP**：默认类型，只能在集群内部访问。适合微服务内部调用、数据库和缓存内部访问、内部 API。

**NodePort**：在每个节点上开放一个端口。

```yaml
spec:
  type: NodePort
```

适合测试或特殊网络场景，不建议把大量生产服务直接暴露为 NodePort。

**LoadBalancer**：由云平台或负载均衡实现提供外部地址。

```yaml
spec:
  type: LoadBalancer
```

适合云环境中的四层负载均衡。

**ExternalName**：通过 DNS CNAME 指向集群外部名称，不创建普通代理数据面。

---

## 第九站：让流量按域名进来——Ingress 与 Gateway API

Service 主要解决四层访问。如果需要根据域名或路径转发 HTTP/HTTPS 流量，可以使用 Ingress 或 Gateway API。

### Ingress 不是控制器

沈舟差点在这里栽跟头：**创建 Ingress 资源并不代表流量一定能够进入集群**，集群中还必须安装 Ingress Controller。常见实现包括 ingress-nginx、Traefik、HAProxy Ingress、云厂商 Ingress Controller。

minikube 可启用 ingress 插件：

```bash
minikube addons enable ingress
```

Ingress 示例：

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: web
  namespace: demo
spec:
  ingressClassName: nginx
  rules:
    - host: web.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: web
                port:
                  number: 80
```

### Gateway API

Gateway API 提供比传统 Ingress 更丰富、更清晰的模型，例如：GatewayClass、Gateway、HTTPRoute、GRPCRoute、TCPRoute、ReferenceGrant。

在新平台建设中，可以评估 Gateway API；在已有集群中，则需要结合现有控制器支持情况决定。

---

## 第十站：配置与镜像分离——ConfigMap 与 Secret

老赵定过一条规矩：**镜像应该尽可能保持环境无关**。不要为开发、测试和生产分别构建不同镜像，更好的做法是——同一个镜像 + 不同配置。

### ConfigMap 保存非敏感配置

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-config
  namespace: demo
data:
  APP_ENV: "production"
  index.html: |
    <!doctype html>
    <html lang="zh-CN">
    <head>
      <meta charset="UTF-8">
      <title>Kubernetes Demo</title>
    </head>
    <body>
      <h1>Hello Kubernetes</h1>
      <p>配置来自 ConfigMap。</p>
    </body>
    </html>
```

ConfigMap 可以通过以下方式提供给容器：环境变量、命令行参数、挂载为文件、应用直接调用 Kubernetes API。

注意：ConfigMap 适合非敏感数据，**并不提供保密能力**。

### Secret 保存敏感数据

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: web-secret
  namespace: demo
  type: Opaque
stringData:
  APP_TOKEN: "change-me-in-production"
```

在 Pod 中引用：

```yaml
env:
  - name: APP_TOKEN
    valueFrom:
      secretKeyRef:
        name: web-secret
        key: APP_TOKEN
```

沈舟在这一节记下的注意事项最多：

- Base64 编码不是加密
- 限制谁可以读取 Secret
- 启用静态数据加密
- 避免把 Secret 提交到 Git
- 尽量使用短期凭据
- 结合外部密钥管理系统
- 记录和审计 Secret 访问

---

## 第十一站：把学到的全串起来——一个可运行的完整示例

沈舟把 Namespace、ConfigMap、Secret、Deployment 和 Service 放到一个文件里，作为鹿鸣课堂的第一个完整部署清单。保存为 `k8s-demo.yaml`：

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: demo
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: web-config
  namespace: demo
data:
  APP_ENV: "production"
  index.html: |
    <!doctype html>
    <html lang="zh-CN">
    <head>
      <meta charset="UTF-8">
      <title>Kubernetes Demo</title>
    </head>
    <body>
      <h1>Hello Kubernetes</h1>
      <p>Deployment、Service 和 ConfigMap 已经正常工作。</p>
    </body>
    </html>
---
apiVersion: v1
kind: Secret
metadata:
  name: web-secret
  namespace: demo
  type: Opaque
stringData:
  APP_TOKEN: "change-me-in-production"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
  namespace: demo
  labels:
    app: web
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  template:
    metadata:
      labels:
        app: web
        version: v1
    spec:
      terminationGracePeriodSeconds: 30
      containers:
        - name: web
          image: nginx:1.27-alpine
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
          env:
            - name: APP_ENV
              valueFrom:
                configMapKeyRef:
                  name: web-config
                  key: APP_ENV
            - name: APP_TOKEN
              valueFrom:
                secretKeyRef:
                  name: web-secret
                  key: APP_TOKEN
          resources:
            requests:
              cpu: 50m
              memory: 64Mi
            limits:
              cpu: 200m
              memory: 128Mi
          readinessProbe:
            httpGet:
              path: /
              port: http
            initialDelaySeconds: 2
            periodSeconds: 5
            timeoutSeconds: 2
            failureThreshold: 3
          livenessProbe:
            httpGet:
              path: /
              port: http
            initialDelaySeconds: 10
            periodSeconds: 10
            timeoutSeconds: 2
            failureThreshold: 3
          volumeMounts:
            - name: html
              mountPath: /usr/share/nginx/html/index.html
              subPath: index.html
              readOnly: true
      volumes:
        - name: html
          configMap:
            name: web-config
---
apiVersion: v1
kind: Service
metadata:
  name: web
  namespace: demo
spec:
  selector:
    app: web
  ports:
    - name: http
      port: 80
      targetPort: http
  type: ClusterIP
```

部署：

```bash
kubectl apply -f k8s-demo.yaml
```

检查：

```bash
kubectl get all -n demo
kubectl get configmap,secret -n demo
kubectl describe deployment web -n demo
```

访问：

```bash
kubectl port-forward service/web 8080:80 -n demo
```

浏览器打开 `http://127.0.0.1:8080`。

清理：

```bash
kubectl delete namespace demo
```

**删除 Namespace 会级联删除其中的大多数资源，因此在生产环境执行前必须确认上下文和命名空间**——第三站里"检查上下文"的习惯，在这里显出了价值。

---

## 第十二站：容器活着≠应用健康——三类健康探针

容器进程正在运行，不代表应用真的健康。Kubernetes 提供三类探针。

### Liveness Probe（存活探针）

判断容器是否仍然存活。连续失败后，kubelet 会重启容器。适合发现：死锁、进程卡死、内部状态不可恢复。

不要把外部数据库偶发不可用直接作为存活失败条件，否则可能引发大量无意义重启。

### Readiness Probe（就绪探针）

判断 Pod 是否可以接收流量。失败时，Pod 通常不会被作为 Service 的可用后端，但容器不会因此自动重启。适合判断：应用是否完成初始化、依赖是否达到可服务状态、是否正在优雅下线、是否应该临时停止接流量。

### Startup Probe（启动探针）

判断慢启动应用是否完成启动。在启动探针成功之前，存活和就绪探针不会按正常方式接管检查流程，可避免慢启动应用被过早重启。

示例：

```yaml
startupProbe:
  httpGet:
    path: /health/startup
    port: 8080
  periodSeconds: 5
  failureThreshold: 30

readinessProbe:
  httpGet:
    path: /health/ready
    port: 8080
  periodSeconds: 5

livenessProbe:
  httpGet:
    path: /health/live
    port: 8080
  periodSeconds: 10
```

沈舟总结，好的健康接口应该：响应快速、不执行高开销逻辑、区分存活和就绪、避免不必要的级联依赖、能反映应用真实服务能力。

---

## 第十三站：给每个应用报个数——资源请求、限制与 QoS

Kubernetes 调度器需要知道应用需要多少资源：

```yaml
resources:
  requests:
    cpu: 200m
    memory: 256Mi
  limits:
    cpu: "1"
    memory: 512Mi
```

### requests

requests 是调度和资源保障的重要依据。`cpu: 200m` 表示 0.2 个 CPU 核心，`memory: 256Mi` 表示 256 MiB 内存。

### limits

limits 表示容器可使用资源的上限。常见现象：CPU 超过限制时通常会被节流；内存超过限制时可能触发 OOMKilled。

### QoS 等级

根据 requests 和 limits 设置情况，Pod 会被划分为：

- Guaranteed
- Burstable
- BestEffort

节点资源紧张时，QoS 会影响驱逐顺序。

### 四个常见错误

沈舟把它们贴在了工位上：

1. **完全不设置 requests**：调度器无法准确判断节点容量，集群容易过度承诺。
2. **limits 设置过低**：应用频繁被节流或 OOMKilled。
3. **所有应用统一填写相同数值**：不同服务的负载模型不同，应基于监控和压测设置。
4. **只看平均值**：还要考虑峰值、启动过程、批处理任务、缓存增长和垃圾回收。

---

## 第十四站：把 Pod 放到该放的地方——调度进阶

### nodeSelector

将 Pod 调度到带有指定标签的节点。先给节点加标签：

```bash
kubectl label node <node-name> disk=ssd
```

Pod 中声明：

```yaml
nodeSelector:
  disk: ssd
```

### Node Affinity

比 nodeSelector 更灵活，可以表达：必须满足、尽量满足、多个条件组合。

### Pod Anti-Affinity

让同一应用的多个副本尽量不要落在同一节点，降低单节点故障影响：

```yaml
affinity:
  podAntiAffinity:
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        podAffinityTerm:
          labelSelector:
            matchLabels:
              app: web
          topologyKey: kubernetes.io/hostname
```

### Topology Spread Constraints

控制 Pod 在节点、可用区等拓扑域之间均匀分布：

```yaml
topologySpreadConstraints:
  - maxSkew: 1
    topologyKey: topology.kubernetes.io/zone
    whenUnsatisfiable: DoNotSchedule
    labelSelector:
      matchLabels:
        app: web
```

### Taint 与 Toleration

Taint 用于排斥 Pod，Toleration 表示 Pod 可以容忍某种污点。常见用途：GPU 节点、专用数据库节点、系统组件节点、特殊硬件节点。

需要记住：**Toleration 只表示"允许调度"，并不保证"一定调度到该节点"**。通常还要配合节点亲和性。

---

## 第十五站：让数据活过 Pod 的生命周期——Volume、PV、PVC 与 StorageClass

容器文件系统通常是临时的。当 Pod 被重建后，写入容器可写层的数据可能丢失。持久化数据需要使用 Volume。

### Volume

Volume 挂载到 Pod 中，可以被一个或多个容器使用。常见类型：emptyDir、ConfigMap、Secret、Projected Volume、CSI Volume、PersistentVolumeClaim。

emptyDir 生命周期与 Pod 一致，适合：临时缓存、同一 Pod 中容器间共享文件、中间计算结果。它不适合需要跨 Pod 重建保留的数据。

### PersistentVolume

PersistentVolume，简称 PV，是集群中的存储资源。它可能来自：云硬盘、NFS、SAN、Ceph、本地磁盘、其他 CSI 存储系统。

### PersistentVolumeClaim

PersistentVolumeClaim，简称 PVC，是用户对存储的申请：

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-data
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
```

Pod 使用 PVC：

```yaml
volumes:
  - name: data
    persistentVolumeClaim:
      claimName: app-data
```

挂载：

```yaml
volumeMounts:
  - name: data
    mountPath: /data
```

### StorageClass

StorageClass 描述存储类别和动态供应方式。用户创建 PVC 后，存储系统可以自动创建匹配的 PV。

要重点理解三个角色：

- **StorageClass**：描述如何提供存储
- **PVC**：应用申请存储
- **PV**：实际提供给应用的存储资源

### 回收策略

常见回收策略：

- **Delete**：PVC 释放后删除后端存储
- **Retain**：保留后端存储，等待人工处理

生产数据库、审计数据和重要文件，应根据恢复要求谨慎设置。

---

## 第十六站：弹性不是改个数字——自动扩缩容

Kubernetes 的弹性不只是"把副本数从 2 改为 10"。完整弹性通常包含三个层次：

- **HPA**：调整 Pod 数量
- **VPA**：调整 Pod 的资源请求
- **Node Autoscaling**：调整节点数量

### HPA

Horizontal Pod Autoscaler 根据指标调整工作负载副本数。前提通常包括：应用设置了合理的资源 requests、集群安装资源指标组件、指标能够被 Autoscaler 获取。

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web
  namespace: demo
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: web
  minReplicas: 2
  maxReplicas: 10
  behavior:
    scaleDown:
      stabilizationWindowSeconds: 300
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 60
```

```bash
kubectl get hpa -n demo
kubectl describe hpa web -n demo
```

### 不要只使用 CPU 指标

不同应用的真实瓶颈可能是：请求速率、响应延迟、消息队列长度、活跃连接数、任务积压数量、GPU 利用率、业务订单量。成熟系统会根据业务指标设计扩缩容策略。

### 扩容也有延迟

扩容链路可能包括：

```
指标采集 → HPA计算 → 创建Pod → 调度 → 拉取镜像 → 应用启动 → Readiness通过 → 开始接流量
```

因此，不能把 HPA 当作瞬间完成的保险机制。应配合容量预留、预热、副本下限、快速启动和合理的稳定窗口。

---

## 第十七站：不是所有 Pod 都该互相认识——网络策略与零信任思路

默认情况下，很多 Kubernetes 网络环境允许 Pod 之间互相通信。NetworkPolicy 用于控制三层和四层流量，但前提是所使用的网络插件支持策略执行。

一个默认拒绝入站流量的策略：

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: demo
spec:
  podSelector: {}
  policyTypes:
    - Ingress
```

允许同一命名空间内访问 Web Pod：

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-web-from-same-namespace
  namespace: demo
spec:
  podSelector:
    matchLabels:
      app: web
  policyTypes:
    - Ingress
  ingress:
    - from:
        - podSelector: {}
      ports:
        - protocol: TCP
          port: 80
```

生产策略应围绕"最小通信权限"设计：

- 哪些前端可以访问哪些后端
- 哪些服务可以访问数据库
- 哪些工作负载可以访问公网
- DNS 是否放行
- 监控和日志组件是否放行
- Ingress Controller 是否能够访问目标 Service

**执行默认拒绝策略前，必须先梳理依赖关系，否则很容易造成业务中断。**

---

## 第十八站：从能运行到可信运行——安全

### RBAC 最小权限

RBAC 的核心资源：Role、ClusterRole、RoleBinding、ClusterRoleBinding。

只允许读取 demo 命名空间中的 Pod：

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: demo
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: demo
subjects:
  - kind: ServiceAccount
    name: app-reader
    namespace: demo
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pod-reader
```

验证权限：

```bash
kubectl auth can-i list pods \
  --as=system:serviceaccount:demo:app-reader \
  -n demo
```

避免轻易授予：cluster-admin、`*` 资源、`*` 动作、读取所有 Secret、创建任意 Pod、创建或绑定高权限角色。

### ServiceAccount

ServiceAccount 为非人类工作负载提供集群身份。不要让所有应用都使用默认 ServiceAccount。应用不需要访问 Kubernetes API 时，可以关闭自动挂载：

```yaml
automountServiceAccountToken: false
```

### SecurityContext

推荐方向：

```yaml
securityContext:
  runAsNonRoot: true
  allowPrivilegeEscalation: false
  readOnlyRootFilesystem: true
  capabilities:
    drop:
      - ALL
```

但必须确保镜像本身支持非 root 和只读根文件系统，否则应用会启动失败。

### Pod Security Standards

常见安全级别：Privileged、Baseline、Restricted。平台团队可通过内置准入机制在 Namespace 层面逐步实施。

### 镜像安全

生产镜像建议：

- 使用可信基础镜像
- 固定版本，重要场景固定 digest
- 删除编译工具和无关依赖
- 扫描漏洞
- 生成软件物料清单
- 对镜像进行签名与验证
- 避免使用 latest
- 使用私有镜像仓库和访问控制

### 集群安全清单

- 控制 Kubernetes API 的网络访问
- 使用强认证机制
- 定期轮换证书和凭据
- 启用审计日志
- 限制特权容器
- 限制 hostPath、hostNetwork 和 hostPID
- 使用 NetworkPolicy
- 保护 etcd
- 对 Secret 静态加密
- 及时升级仍在支持周期内的版本
- 定期执行恢复演练

---

## 第十九站："Running"不代表正常——可观测性

成熟的可观测体系通常包含四块拼图：

- **Metrics**：发生了多少、快不快、资源是否充足
- **Logs**：具体发生了什么
- **Traces**：一次请求经过了哪些服务
- **Events**：Kubernetes 控制面做了什么

### Metrics

关键指标包括：节点 CPU、内存、磁盘和网络；Pod CPU、内存、重启次数；API Server 延迟和错误率；etcd 延迟、容量和选主状态；调度失败数量；Deployment 可用副本数；HPA 当前值和目标值；应用 QPS、错误率和 P95/P99 延迟。

查看基础资源指标：

```bash
kubectl top nodes
kubectl top pods -A
```

如果命令不可用，通常需要检查 Metrics Server。

### Logs

容器应尽量把日志写到标准输出和标准错误：

```bash
kubectl logs -f deployment/web -n demo
```

生产环境需要集中式日志系统，因为 Pod 被删除后，本地日志不一定保留。日志至少应包含：时间、级别、服务名、环境、请求 ID、Trace ID、错误码、关键上下文。

**不要在日志中输出密码、Token 和完整敏感数据。**

### Traces

分布式追踪适合回答：请求慢在哪个服务？哪个依赖产生大量重试？延迟来自应用、数据库还是外部 API？一次请求跨越了哪些 Pod？

### Events

排查 Kubernetes 问题时，Events 极其重要：

```bash
kubectl get events -n demo \
  --sort-by=.metadata.creationTimestamp
```

Events 可能显示：FailedScheduling、FailedMount、BackOff、Unhealthy、Pulling、Pulled、Killing。

---

## 第二十站：从手敲 YAML 到平台——Helm、Kustomize 与 GitOps

当系统只有一个 YAML 文件时，直接 `kubectl apply` 足够。随着资源数量增加，会出现：多环境差异、YAML 重复、版本管理困难、发布过程不可审计、人工操作容易出错。

### Kustomize

Kustomize 通过 Base 和 Overlay 管理环境差异：

```
deploy/
├── base/
│   ├── deployment.yaml
│   ├── service.yaml
│   └── kustomization.yaml
└── overlays/
    ├── dev/
    ├── test/
    └── prod/
```

```bash
kubectl apply -k deploy/overlays/prod
```

适合：原生 YAML、环境覆盖、少量变体、不希望引入模板语言。

### Helm

Helm 使用 Chart 打包 Kubernetes 应用。典型结构：

```
mychart/
├── Chart.yaml
├── values.yaml
└── templates/
```

常用命令：

```bash
helm install web ./mychart
helm upgrade web ./mychart
helm rollback web 1
helm list
```

适合：可复用应用包、参数化部署、第三方组件安装、复杂应用版本管理。

### GitOps

GitOps 的核心思想：

```
Git中的声明 = 期望状态
集群中的资源 = 实际状态
控制器持续同步两者
```

优势：变更可审计、可代码评审、易于回滚、减少人工进入集群操作、支持多集群持续交付。

但沈舟记下了老赵的补充：GitOps 并不意味着可以忽略 Secret 管理、发布验证、数据库迁移、回滚兼容性、权限边界、灾难恢复。

---

## 第二十一站：故障总会来，重要的是顺序——建立固定的排查路径

Kubernetes 问题看起来复杂，通常可以按固定顺序排查。

### 第一步：确认集群和上下文

```bash
kubectl config current-context
kubectl cluster-info
kubectl get nodes
```

### 第二步：查看工作负载状态

```bash
kubectl get deployment,statefulset,daemonset -A
kubectl get pods -A -o wide
```

### 第三步：Describe 与 Events

```bash
kubectl describe pod <pod-name> -n <namespace>
kubectl get events -n <namespace> \
  --sort-by=.metadata.creationTimestamp
```

### 第四步：查看日志

```bash
kubectl logs <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace> --previous
```

### 第五步：验证 Service 链路

```bash
kubectl get service,endpointslices -n <namespace>
kubectl describe service <service-name> -n <namespace>
```

检查：Service selector 是否匹配 Pod label、targetPort 是否正确、Pod 是否 Ready、EndpointSlice 是否有地址、NetworkPolicy 是否阻断、Ingress 或 Gateway 路由是否正确。

### 第六步：进入调试容器或临时 Pod

```bash
kubectl run net-debug \
  --rm -it \
  --restart=Never \
  --image=busybox:1.36 \
  -- sh
```

在临时 Pod 内测试：

```bash
nslookup web.demo.svc.cluster.local
wget -qO- http://web.demo.svc.cluster.local
```

### 第七步：检查节点

```bash
kubectl describe node <node-name>
kubectl get pods -A \
  --field-selector spec.nodeName=<node-name>
```

重点关注：MemoryPressure、DiskPressure、PIDPressure、节点是否 NotReady、kubelet 是否正常、磁盘是否耗尽。

---

## 第二十二站：常见故障速查——沈舟踩过的坑

### Pending

可能原因：CPU 或内存不足、PVC 无法绑定、节点选择条件不满足、Taint 未被容忍、拓扑约束无法满足、集群没有可调度节点。

```bash
kubectl describe pod <pod-name>
```

重点查看 Events 中的 FailedScheduling。

### ImagePullBackOff

可能原因：镜像名称错误、Tag 不存在、私有仓库认证失败、节点无法访问仓库、拉取频率受限。

```bash
kubectl describe pod <pod-name>
```

检查 imagePullSecrets 和镜像地址。

### CrashLoopBackOff

可能原因：应用启动即退出、配置错误、依赖不可用、探针配置错误、权限不足、OOMKilled。

```bash
kubectl logs <pod-name>
kubectl logs <pod-name> --previous
kubectl describe pod <pod-name>
```

### OOMKilled

可能原因：内存 limit 太低、内存泄漏、缓存无限增长、启动瞬时内存过高。

```bash
kubectl describe pod <pod-name>
kubectl top pod <pod-name>
```

### Service 无法访问

检查链路：

```
客户端 → DNS → Service → EndpointSlice → Pod IP → 容器端口
```

常见错误：Service selector 写错、Pod label 不匹配、port 与 targetPort 混淆、Pod 未 Ready、应用只监听 127.0.0.1、NetworkPolicy 拦截、容器端口与应用真实端口不一致。

### 发布卡住

```bash
kubectl rollout status deployment/web
kubectl describe deployment web
kubectl get pods
```

可能原因：新镜像无法启动、Readiness 一直失败、资源不足、maxUnavailable 和 maxSurge 不合理、新版本与旧配置不兼容。

---

## 第二十三站：把大促那晚的教训写进规范——生产环境最佳实践

### 1. 每个工作负载设置资源请求

没有 requests，调度器无法做可靠决策。

### 2. 为关键服务设置多个副本

单副本应用无法抵抗节点故障，也无法实现真正的滚动更新。

### 3. 使用 Readiness Probe 控制流量

只有真正可服务的 Pod 才应接收请求。

### 4. 使用 PodDisruptionBudget

PDB 可以在自愿中断场景中限制同时不可用的副本数量：

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: web
  namespace: demo
spec:
  minAvailable: 1
  selector:
    matchLabels:
      app: web
```

需要注意：PDB 不能阻止所有类型的故障，也不能替代多副本和跨节点部署。

### 5. 跨节点和可用区分布

结合 Pod Anti-Affinity、Topology Spread Constraints、多可用区节点池，避免副本集中到同一故障域。

### 6. 使用优雅终止

应用收到终止信号后应该：停止接收新请求 → 完成正在处理的请求 → 刷新缓冲区 → 关闭连接 → 在宽限期内退出。

可结合 Readiness、preStop、terminationGracePeriodSeconds。

### 7. 镜像版本不可漂移

不要依赖：

```yaml
image: myapp:latest
```

使用明确版本或 digest：

```yaml
image: registry.example.com/myapp:1.8.3
```

### 8. 配置与代码分离

非敏感配置放 ConfigMap；敏感配置放 Secret 或外部密钥系统；不把环境差异写死在镜像中。

### 9. 建立备份与恢复演练

备份不等于可靠恢复。必须定期验证：etcd 能否恢复、数据卷快照是否可用、数据库备份是否一致、新集群能否重建、GitOps 仓库能否恢复期望状态、密钥和证书是否完整。

### 10. 保持版本在支持周期内

Kubernetes 小版本有明确维护周期。升级时要检查：API 弃用、CNI/CSI/Ingress Controller 兼容性、kubectl 与服务端版本差距、Webhook 和 CRD 兼容性、节点操作系统与内核、容器运行时版本、备份与回滚方案。

---

## 第二十四站：什么时候，不该用它

沈舟学到最后，老赵却先泼了盆冷水：Kubernetes 很强，但不是所有项目都需要。以下情况可以先不使用：

- 只有一个很小的服务
- 流量稳定且单机足够
- 团队没有容器和 Linux 运维经验
- 不需要自动扩缩容和高可用
- 简单 PaaS 已经能够满足需求
- 引入 Kubernetes 的运维成本高于收益

因为 Kubernetes 会带来新的复杂度：集群生命周期、网络和存储插件、证书、权限、监控、日志、版本升级、成本控制、故障定位。

**技术选型的目标不是"使用最流行的工具"，而是用合适的复杂度解决真实问题。**

---

## 终点站：从入门到精通的学习路线

沈舟把整个学习过程整理成了五个阶段。

### 阶段一：容器基础

学习内容：Linux 进程、网络、文件系统；Namespace 与 cgroup；Dockerfile；镜像分层；容器网络；数据卷；镜像仓库。

目标：能独立容器化一个 Web 应用；能分析容器启动失败；能优化镜像大小和构建速度。

### 阶段二：Kubernetes 基础对象

学习内容：Pod、Deployment、Service、Namespace、Label、ConfigMap、Secret、kubectl、健康探针。

目标：能部署一个多副本无状态应用；能完成更新、扩容和回滚；能从集群内部和外部访问应用。

### 阶段三：网络、存储与调度

学习内容：ClusterIP、NodePort、LoadBalancer；Ingress 与 Gateway API；DNS；NetworkPolicy；PV、PVC、StorageClass；Affinity；Taint 与 Toleration；Topology Spread。

目标：能解释一次请求如何到达 Pod；能为有状态应用申请持久化存储；能控制 Pod 的调度位置和故障域分布。

### 阶段四：安全与可观测性

学习内容：RBAC、ServiceAccount、Pod Security、SecurityContext、镜像安全、Metrics/Logs/Traces、审计、告警。

目标：能设计最小权限；能建立监控和日志体系；能在故障时快速定位问题。

### 阶段五：交付与平台工程

学习内容：Helm、Kustomize、GitOps、CRD、Operator、Admission Policy、多集群管理、成本治理、SLO 与容量规划。

目标：能把 Kubernetes 从"部署工具"升级为稳定的应用平台；能为开发团队提供标准化、自助式交付能力。

### 真正"精通 Kubernetes"的标志

精通并不是记住所有 API 字段，而是能够回答下面的问题：

**架构层面**

- 为什么 Kubernetes 采用声明式 API？
- 控制器如何通过调谐维持状态？
- API Server、etcd、scheduler 和 kubelet 如何协作？
- 控制平面出现故障时会发生什么？

**应用层面**

- 为什么不应该直接使用裸 Pod？
- Deployment 和 StatefulSet 的本质区别是什么？
- Readiness、Liveness 和 Startup Probe 应如何设计？
- 如何做到无损发布和快速回滚？

**网络层面**

- Service 如何找到 Pod？
- ClusterIP 是如何实现的？
- DNS、EndpointSlice、Ingress 和 Gateway 如何配合？
- NetworkPolicy 为什么有时创建后不生效？

**存储层面**

- PV、PVC 和 StorageClass 分别解决什么问题？
- 数据卷的访问模式和回收策略有什么影响？
- 如何设计数据库备份与恢复？

**安全层面**

- 为什么能创建 Pod 的权限可能非常敏感？
- 如何限制工作负载访问 Kubernetes API？
- 如何实施最小权限和网络隔离？
- Secret 为什么不能只依赖 Base64？

**运维层面**

- Pod Pending、CrashLoopBackOff、OOMKilled 如何排查？
- 如何确定问题在应用、Service、网络还是节点？
- 如何设计 SLO、告警、容量和灾难恢复？
- 如何安全升级集群和核心插件？

当你能从系统原理出发解决这些问题，而不是只会复制 YAML，才算真正跨过了 Kubernetes 的门槛。

### 常用命令备忘录

```bash
# 集群
kubectl cluster-info
kubectl get nodes -o wide
kubectl config current-context
kubectl config get-contexts

# 资源
kubectl get pods -A
kubectl get all -n demo
kubectl get pods -o wide
kubectl get pods --show-labels

# 详情与事件
kubectl describe pod <pod-name> -n demo
kubectl get events -n demo --sort-by=.metadata.creationTimestamp

# 日志
kubectl logs <pod-name> -n demo
kubectl logs -f <pod-name> -n demo
kubectl logs <pod-name> --previous -n demo

# 容器交互
kubectl exec -it <pod-name> -n demo -- sh
kubectl port-forward service/web 8080:80 -n demo

# 声明式管理
kubectl apply -f app.yaml
kubectl diff -f app.yaml
kubectl delete -f app.yaml

# Deployment
kubectl scale deployment web --replicas=5 -n demo
kubectl rollout status deployment/web -n demo
kubectl rollout history deployment/web -n demo
kubectl rollout undo deployment/web -n demo

# 权限
kubectl auth can-i list pods -n demo
kubectl auth can-i --list -n demo

# 资源指标
kubectl top nodes
kubectl top pods -A

# API字段说明
kubectl explain deployment
kubectl explain deployment.spec.template.spec.containers
```

---

那天晚上，沈舟又看了一遍大促当晚写下的白板。宕机迁移、自动扩容、服务发现、零中断发布、配置管理——当初那九个问题，如今每一个都有了对应的对象和机制：Deployment 与控制循环负责补齐副本，Service 与 DNS 稳住善变的 Pod IP，探针摘除不健康的实例，requests 和 limits 管住资源，HPA 应对流量洪峰，rollout undo 兜底每一次发布。

集群还是会在深夜出问题，但沈舟不再慌了——因为他知道，无论问题藏在哪一层，都有一套固定的顺序可以把它找出来。Kubernetes 的学习曲线确实陡峭，因为它不是一个孤立工具，而是容器、Linux、网络、存储、分布式系统、安全和自动化运维的交汇点。但它的核心思想并不复杂：

**用声明描述期望状态，用控制器持续修正实际状态，用标准化对象管理应用生命周期，用自动化机制应对变化与故障。**

正如那句流传在社区里的话：

> "Kubernetes 不是让你更少地理解分布式系统，而是把你必须理解的那些东西，变成了一套可以练的功课。"

## 参考资料 / 官方延伸阅读

- [Kubernetes Overview](https://kubernetes.io/docs/concepts/overview/)
- [Kubernetes Components](https://kubernetes.io/docs/concepts/overview/components/)
- [Objects in Kubernetes](https://kubernetes.io/docs/concepts/overview/working-with-objects/)
- [Deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [ConfigMaps and Secrets](https://kubernetes.io/docs/concepts/configuration/configmap/)
- [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/)
- [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/)
- [Liveness, Readiness and Startup Probes](https://kubernetes.io/docs/tasks/configure-pod-container/configure-liveness-readiness-startup-probes/)
- [RBAC Authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
- [Kubernetes Release Information](https://kubernetes.io/releases/)

> 版本提示：Kubernetes 迭代较快，本文以 v1.36 系列文档（2026 年 7 月）为参考基准。实际部署前，请根据目标集群版本检查 API、功能状态、组件兼容性和弃用信息。
