# D2 速查（语法、主题与渲染）

D2 是声明式架构图语言：只描述"谁连谁"，布局引擎自动排版，无需坐标。适合架构大图、层级嵌套与节点较多的场景。

## 节点与连边

```d2
# 节点：id: 标签（id 用英文，标签可中文）
users: 用户
server: 服务器
db: 数据库 {shape: cylinder}

# 连边：-> 单向，<-> 双向
users -> server: HTTPS
server -> db: SQL
```

- id 定义后可复用，重复出现即引用同一节点；标签缺省时显示 id 本身
- 注释用 `#`

## 容器嵌套（核心优势）

缩进即层级，天然表达集群、租户与网络边界：

```d2
cloud: 云环境 {
  vpc: VPC 生产区 {
    lb: 负载均衡 {shape: queue}
    api: API 网关
  }
  rds: RDS {shape: cylinder}
}

# 嵌套内节点被外部引用时必须写全路径
users -> cloud.vpc.lb
cloud.vpc.lb -> cloud.vpc.api
cloud.vpc.api -> cloud.rds
```

## 常用形状

```d2
p: 用户     {shape: person}
q: 队列     {shape: queue}
d: 数据     {shape: cylinder}
dec: 判断   {shape: diamond}
cld: 云服务 {shape: cloud}
doc: 文档   {shape: document}
o: 手动操作 {shape: circle}
```

## 样式与强调

```d2
a -> b: 关键路径 {style.animated: true}                # 动画流动
b: 核心 {style.fill: honeydew}                        # 填充色
c: 待办 {style.stroke: red; style.stroke-width: 3}    # 描边
a -> b: 多级标签 {style.font-size: 24}                # 标签字号
```

常用柔和底色：`honeydew`、`mistyrose`、`lavender`、`lightgray`。

## 网格布局（同构节点阵列）

```d2
workers: Worker 池 {
  grid-rows: 2
  w1; w2; w3; w4
}
```

容器声明 `grid-rows` / `grid-columns` 后，子节点自动阵列排列，适合分片、副本、多实例场景。

## Markdown 卡片与图标

```d2
note: |md
  ## 说明
  支持 **Markdown** 语法
| {near: bottom-center}

db: PostgreSQL {
  icon: https://icons.terrastruct.com/essentials/005-postgres.svg
  shape: cylinder
}
```

远程图标需联网拉取；离线环境会因无法 bundle 远程图片而渲染失败，此时改用内置形状。

## 连线进阶

```d2
# 带编号的步骤连线
a -> b: ①
b -> c: ②
c -> a: 回流 {style.animated: true}

# 虚线（异步、可选路径）
a -> b: 异步事件 {style.stroke-dash: 4}

# 双向多段标签
x -> y: 请求
y -> x: 响应
```

## 主题与渲染

```bash
d2 file.d2 out.svg                   # 默认主题
d2 --theme 300 file.d2 out.svg       # 指定主题（300 系为现代配色）
d2 --sketch --theme 0 file.d2 x.svg  # 手绘/草稿风格
d2 --watch file.d2                   # 保存即重渲染
d2 --layout elk file.d2 out.svg      # 改用 elk 布局引擎（大图更快）
```

主题速记：`0` Neutral（常与 `--sketch` 搭配）、`200` Cool Aubergine、`300` Dark Mauve、`8` Earth Tones。

## 常见坑

| 坑                        | 规避                                        |
| ------------------------- | ------------------------------------------- |
| 嵌套子节点引用漏写全路径  | 写全路径 `cloud.vpc.api`，或提前定义为变量  |
| id 含特殊字符             | 用引号包裹 id：`"my-node": 标签`            |
| 标签以 `#` 开头被当作注释 | 标签加引号                                  |
| 中文标签过宽导致重叠      | 增大 `--pad`，或精简标签、细节移到注释      |
| 图渲染慢                  | 减少嵌套深度；大图改用 `--layout elk`       |

## 何时用 D2

工具选型见 `SKILL.md`《工具选型与产出纪律》。简单判断：节点超过 15 个、嵌套深、Mermaid 布局失控时改用 D2。
