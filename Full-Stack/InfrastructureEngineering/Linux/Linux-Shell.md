# [Linux Shell编程从入门到精通：从命令行使用者到自动化高手](https://mp.weixin.qq.com/s/MuOLKLsVGFT7tdGgclBBaw)

> 这是一个关于"宋知远"的故事——一个在"拾贝科技"负责后端开发的程序员。团队只有五个人，没人专职运维，服务器上的事全靠一摞"临时凑合"的 Shell 脚本：备份脚本悄悄失败没人知道，清理脚本差点删错目录，一个带空格的文件名让批量任务全线崩溃。新来的 CTO 只留下一句话："这些脚本是资产还是炸弹，取决于你怎么写。"你会跟着宋知远一起，从把命令串起来的第一天，走到能写出带日志、带锁、带清理、带并发控制的生产级脚本的那一天。读完之后你会发现：Shell 的门槛很低，但从"能运行"到"可靠运行"，才是真正的进阶。

---

## 故事的起点：一份差点删掉整个网站的脚本

宋知远在"拾贝科技"写了三年后端。团队不大，服务器上的杂活——备份、清理、部署——全靠历任同事留下来的几份 Shell 脚本，谁也没认真看过。

直到那个周五的下午。

运营姑娘想清理服务器缓存，执行了团队里流传已久的一条命令：

```bash
rm -rf "$target_dir"/*
```

可脚本里的 `target_dir` 是空变量。Shell 把它展开成了空字符串，命令变成了删掉当前目录下的一切。磁盘警告响起来的时候，半个站点的静态资源已经没了。

那晚全组加班到凌晨三点，从备份里一点点恢复数据。CTO 第二天把宋知远叫过去："你平时最熟命令行，这些脚本以后归你。但有个条件——一个月内，把它们全部重写成**敢在生产环境跑**的脚本。不是'能运行'，是'可靠运行'。"

宋知远翻开那些脚本：没有判断、没有日志、没有错误处理，变量从不加引号。他忽然意识到，自己虽然每天都在敲命令，却从没真正写过"程序"——Shell 也可以是一门编程语言。

这个故事，就是他从"会敲命令"到"自动化高手"的完整路线图。

---

## 第一站：Shell 到底是什么

搞清楚自己每天在用的东西到底是什么，是宋知远的第一课。

Shell 位于用户和操作系统内核之间。当我们在终端输入：

```bash
ls -l /var/log
```

Shell 会完成以下工作：

1. 读取命令文本；
2. 分析命令、参数和重定向；
3. 查找 `ls` 程序；
4. 创建进程执行程序；
5. 将输出显示到终端。

可以把它理解为一条链路：

```
用户输入
   ↓
Shell 解析
   ↓
调用系统程序或内建命令
   ↓
操作系统执行
   ↓
返回结果
```

常见的 Shell 有这么几种：

| Shell | 特点 |
| ----- | ---- |
| sh | 传统 Unix Shell，强调可移植性 |
| bash | Linux 中最常见，功能丰富 |
| zsh | 交互体验强，插件生态丰富 |
| fish | 语法友好，自动补全优秀 |
| dash | 体积小、启动快，常用于系统脚本 |
| ksh | Korn Shell，兼顾脚本和交互能力 |

本文主要使用 Bash 语法。查看当前 Shell、Bash 版本和系统可用 Shell：

```bash
echo "$SHELL"
bash --version
cat /etc/shells
```

有两点需要注意：

- "当前登录 Shell"不一定等于"当前正在执行脚本的 Shell"；
- 脚本最终由谁解释，通常由第一行的 Shebang 决定。

---

## 第二站：第一个脚本——Shebang 不是装饰

那天下午，宋知远写的第一个"正式"脚本，和所有人的一样：

创建文件：

```bash
vim hello.sh
```

写入：

```bash
#!/usr/bin/env bash

echo "Hello, Shell!"
```

保存后添加执行权限：

```bash
chmod +x hello.sh
```

运行：

```bash
./hello.sh
```

输出：

```
Hello, Shell!
```

也可以显式调用 Bash：

```bash
bash hello.sh
```

### Shebang 的作用

第一行：

```bash
#!/usr/bin/env bash
```

称为 **Shebang**。它告诉系统：使用哪个解释器运行这个文件。

常见写法有两种：

```bash
#!/bin/bash
```

或者：

```bash
#!/usr/bin/env bash
```

两者区别：

- `#!/bin/bash`：直接指定固定路径；
- `#!/usr/bin/env bash`：从当前环境的 PATH 中寻找 Bash，通常更灵活。

如果脚本依赖 Bash 特性，应明确使用 Bash，**不要**写成：

```bash
#!/bin/sh
```

因为不同系统中的 `/bin/sh` 可能指向不同的 Shell——在很多现代发行版上它其实是 dash。

### 注释

单行注释以 `#` 开头：

```bash
# 这是一条注释
echo "Hello"
```

Shebang 虽然也以 `#` 开头，但它具有特殊意义。

---

## 第三站：退出状态——Shell 判断的基石

宋知远重读老脚本时发现，它们从不检查命令是否成功。而 Shell 编程的判断，本质上经常就是在判断这件事。

### 命令的基本结构

Shell 命令通常由三部分组成：

```
命令 选项 参数
```

例如：

```bash
cp -r source_dir target_dir
```

其中：

- `cp` 是命令；
- `-r` 是选项；
- `source_dir` 和 `target_dir` 是参数。

### 命令退出状态

每条命令执行后都会返回一个整数状态码：

- `0`：执行成功；
- 非 `0`：执行失败或出现特定状态。

查看上一条命令的退出状态：

```bash
echo "$?"
```

示例：

```bash
mkdir demo
echo "$?"
```

如果目录创建成功，通常输出 `0`。执行不存在的命令后再看 `$?`，会得到非零状态码。

所以，与其先执行命令再单独读 `$?`，不如直接把命令放进判断：

```bash
if mkdir demo_dir; then
    echo "目录创建成功"
else
    echo "目录创建失败"
fi
```

这比老脚本里"执行完就当成功"的写法，可靠得多。

---

## 第四站：变量——等号两边不能有空格

### 定义变量

```bash
name="Shell"
version="1.0"
```

**等号两边不能有空格。**

正确：

```bash
name="Linux"
```

错误：

```bash
name = "Linux"
```

后者会被 Shell 当成执行名为 `name` 的命令——这是新手最常踩的第一个坑。

### 使用变量

```bash
echo "$name"
echo "${name}"
```

推荐在多数情况下使用双引号。花括号适合明确变量边界：

```bash
file="report"
echo "${file}_2026.log"
```

如果写成：

```bash
echo "$file_2026.log"
```

Shell 会尝试读取变量 `file_2026`——一个不存在的变量。

### 单引号与双引号

单引号中的内容不会进行变量展开：

```bash
name="Shell"

echo '$name'
```

输出：

```
$name
```

双引号会展开变量：

```bash
echo "$name"
```

输出：

```
Shell
```

可以简单记忆：

- 单引号：原样输出；
- 双引号：允许变量和命令替换；
- 不加引号：可能发生单词分割和通配符展开，应谨慎使用。

### 只读变量与删除变量

```bash
readonly APP_NAME="backup"
```

之后不能重新赋值。也可以使用：

```bash
declare -r APP_NAME="backup"
```

删除变量：

```bash
unset name
```

### 环境变量

普通变量只在当前 Shell 中有效。使用 `export` 后，可以传递给子进程：

```bash
export APP_ENV="production"
```

或者：

```bash
APP_ENV="production"
export APP_ENV
```

临时为单条命令设置环境变量：

```bash
APP_ENV="test" ./start.sh
```

这种写法不会永久修改当前 Shell 的变量。

常见环境变量：

```bash
echo "$HOME"
echo "$USER"
echo "$PATH"
echo "$PWD"
echo "$OLDPWD"
echo "$SHELL"
echo "$LANG"
```

其中 `PATH` 决定 Shell 在哪些目录中查找可执行命令。查看格式化后的 PATH：

```bash
printf '%s\n' "$PATH" | tr ':' '\n'
```

---

## 第五站：命令替换与算术运算

### 命令替换

将命令输出赋给变量：

```bash
current_date=$(date '+%Y-%m-%d')
echo "$current_date"
```

旧式写法是反引号：

```bash
current_date=`date '+%Y-%m-%d'`
```

推荐使用 `$(command)`，因为它更清晰，也更容易嵌套：

```bash
files=$(find "$(pwd)" -type f | wc -l)
```

### 整数运算

Shell 中常用双括号进行整数运算：

```bash
a=10
b=3

sum=$((a + b))
difference=$((a - b))
product=$((a * b))
quotient=$((a / b))
remainder=$((a % b))

echo "$sum"
echo "$remainder"
```

自增：

```bash
count=0
((count++))
```

或者：

```bash
((count += 1))
```

注意：Shell 原生算术主要处理整数。需要浮点运算时，可使用 `awk` 或 `bc`：

```bash
awk 'BEGIN { printf "%.2f\n", 10 / 3 }'
```

---

## 第六站：位置参数——让脚本接收输入

脚本要变成工具，第一步就是能接收用户传入的参数。

创建 `args.sh`：

```bash
#!/usr/bin/env bash

echo "脚本名称：$0"
echo "第一个参数：$1"
echo "第二个参数：$2"
echo "参数个数：$#"
echo "全部参数：$*"
echo "全部参数：$@"
```

运行：

```bash
bash args.sh hello world
```

常见特殊变量：

| 变量 | 含义 |
| ---- | ---- |
| `$0` | 脚本名称 |
| `$1` | 第一个参数 |
| `$2` | 第二个参数 |
| `$#` | 参数数量 |
| `$@` | 所有参数，每个参数保持独立 |
| `$*` | 所有参数，倾向于合并为一个整体 |
| `$?` | 上一条命令的退出状态 |
| `$$` | 当前 Shell 的进程 ID |
| `$!` | 最近一个后台进程的进程 ID |

### `"$@"` 与 `"$*"` 的区别

假设调用：

```bash
bash test.sh "hello world" linux
```

在双引号中，`"$@"` 表示两个参数：`hello world` 和 `linux`；而 `"$*"` 更像一个合并后的字符串：`hello world linux`。

遍历参数时，通常应该使用：

```bash
for arg in "$@"; do
    echo "$arg"
done
```

这是 Shell 编程中非常重要的习惯。

### shift

`shift` 可以将位置参数向左移动：

```bash
#!/usr/bin/env bash

while (($# > 0)); do
    echo "当前参数：$1"
    shift
done
```

每执行一次 `shift`：

- 原来的 `$2` 变成 `$1`；
- 原来的 `$3` 变成 `$2`；
- `$#` 减少 1。

---

## 第七站：读取用户输入

使用 `read` 读取输入：

```bash
read -r name
echo "你好，$name"
```

带提示文字：

```bash
read -r -p "请输入用户名：" username
echo "用户名：$username"
```

读取密码：

```bash
read -r -s -p "请输入密码：" password
echo
```

常用选项：

| 选项 | 作用 |
| ---- | ---- |
| `-r` | 不把反斜杠当转义符，通常建议使用 |
| `-p` | 显示提示文字 |
| `-s` | 静默输入 |
| `-t` | 设置超时时间 |
| `-n` | 限制读取字符数 |
| `-a` | 读取到数组 |

读取多个变量：

```bash
read -r first_name last_name
```

读取一行到数组：

```bash
read -r -a words
printf '%s\n' "${words[@]}"
```

---

## 第八站：条件判断——`[[ ]]` 优于 `[ ]`

### if 语句

基本结构：

```bash
if condition; then
    command
fi
```

带 `else`：

```bash
if condition; then
    command1
else
    command2
fi
```

多分支：

```bash
if condition1; then
    command1
elif condition2; then
    command2
else
    command3
fi
```

示例：

```bash
age=20

if ((age >= 18)); then
    echo "成年人"
else
    echo "未成年人"
fi
```

### test、`[` 与 `[[`

传统写法：

```bash
if test -f "$file"; then
    echo "普通文件"
fi
```

常见写法：

```bash
if [ -f "$file" ]; then
    echo "普通文件"
fi
```

Bash 推荐写法：

```bash
if [[ -f $file ]]; then
    echo "普通文件"
fi
```

注意：`[ -f "$file" ]` 中的 `[` 实际上是一个命令，因此左右必须保留空格。

错误：

```bash
[-f "$file"]
```

正确：

```bash
[ -f "$file" ]
```

在 Bash 脚本中，`[[ ... ]]` 通常更安全、更强大：

- 减少意外的单词分割；
- 支持模式匹配；
- 支持正则表达式；
- 逻辑表达式可读性更好。

### 字符串判断

```bash
name="Shell"

if [[ -z $name ]]; then
    echo "字符串为空"
fi

if [[ -n $name ]]; then
    echo "字符串非空"
fi

if [[ $name == "Shell" ]]; then
    echo "相等"
fi

if [[ $name != "Bash" ]]; then
    echo "不相等"
fi
```

常用字符串判断：

| 表达式 | 含义 |
| ------ | ---- |
| `-z STRING` | 字符串长度为 0 |
| `-n STRING` | 字符串长度不为 0 |
| `A == B` | 字符串相等 |
| `A != B` | 字符串不相等 |
| `A < B` | 字典序小于 |
| `A > B` | 字典序大于 |

### 数字判断

使用传统测试表达式：

```bash
if [ "$a" -gt "$b" ]; then
    echo "a 大于 b"
fi
```

常用操作符：

| 操作符 | 含义 |
| ------ | ---- |
| `-eq` | 等于 |
| `-ne` | 不等于 |
| `-gt` | 大于 |
| `-ge` | 大于等于 |
| `-lt` | 小于 |
| `-le` | 小于等于 |

在 Bash 中，更推荐算术上下文：

```bash
if ((a > b)); then
    echo "a 大于 b"
fi
```

### 文件判断

```bash
file="/etc/passwd"

if [[ -e $file ]]; then
    echo "路径存在"
fi
```

常用文件测试：

| 表达式 | 含义 |
| ------ | ---- |
| `-e FILE` | 路径存在 |
| `-f FILE` | 普通文件 |
| `-d FILE` | 目录 |
| `-L FILE` | 符号链接 |
| `-r FILE` | 可读 |
| `-w FILE` | 可写 |
| `-x FILE` | 可执行 |
| `-s FILE` | 文件非空 |
| `FILE1 -nt FILE2` | FILE1 比 FILE2 新 |
| `FILE1 -ot FILE2` | FILE1 比 FILE2 旧 |

### 逻辑运算

```bash
if [[ $age -ge 18 && $age -le 60 ]]; then
    echo "年龄在 18 到 60 之间"
fi
```

或者：

```bash
if [[ $role == "admin" || $role == "root" ]]; then
    echo "拥有管理员权限"
fi
```

取反：

```bash
if [[ ! -f $file ]]; then
    echo "文件不存在"
fi
```

### 模式匹配

```bash
filename="report.log"

if [[ $filename == *.log ]]; then
    echo "这是日志文件"
fi
```

这里右侧的 `*.log` 不应加引号，否则模式匹配可能变成普通字符串比较。

### 正则表达式

```bash
email="user@example.com"

if [[ $email =~ ^[[:alnum:]._%+-]+@[[:alnum:].-]+\.[[:alpha:]]+$ ]]; then
    echo "邮箱格式基本正确"
else
    echo "邮箱格式不正确"
fi
```

正则表达式适合基本格式检查，但不要把简单正则当成完整业务验证。

---

## 第九站：case 多分支——固定模式下的清晰选择

当分支基于固定模式时，`case` 比大量 `if` 更清晰。

```bash
read -r -p "请输入操作 start|stop|restart：" action

case "$action" in
    start)
        echo "启动服务"
        ;;
    stop)
        echo "停止服务"
        ;;
    restart)
        echo "重启服务"
        ;;
    *)
        echo "未知操作"
        exit 1
        ;;
esac
```

支持多个模式：

```bash
case "$answer" in
    y|Y|yes|YES)
        echo "用户确认"
        ;;
    n|N|no|NO)
        echo "用户取消"
        ;;
    *)
        echo "无效输入"
        ;;
esac
```

判断文件扩展名：

```bash
case "$file" in
    *.jpg|*.png|*.gif)
        echo "图片文件"
        ;;
    *.mp4|*.mov)
        echo "视频文件"
        ;;
    *.txt|*.md)
        echo "文本文件"
        ;;
    *)
        echo "其他文件"
        ;;
esac
```

---

## 第十站：循环结构

### for 循环

遍历固定列表：

```bash
for language in Bash Python Go Rust; do
    echo "$language"
done
```

遍历参数：

```bash
for arg in "$@"; do
    echo "$arg"
done
```

C 风格循环：

```bash
for ((i = 1; i <= 5; i++)); do
    echo "$i"
done
```

遍历数组：

```bash
servers=("web01" "web02" "db01")

for server in "${servers[@]}"; do
    echo "$server"
done
```

### 遍历文件

简单写法：

```bash
for file in ./*.log; do
    [[ -e $file ]] || continue
    echo "$file"
done
```

为什么需要 `[[ -e $file ]] || continue`？因为当目录中没有匹配文件时，某些情况下通配符可能保持为字面量 `./*.log`。

处理复杂文件名时，**不要**使用：

```bash
for file in $(find . -type f); do
    ...
done
```

这种写法会在空格、换行等字符处拆分文件名。更可靠的方式：

```bash
while IFS= read -r -d '' file; do
    printf '处理：%s\n' "$file"
done < <(find . -type f -print0)
```

### while 循环

```bash
count=1

while ((count <= 5)); do
    echo "$count"
    ((count++))
done
```

读取文件：

```bash
while IFS= read -r line; do
    echo "读取：$line"
done < input.txt
```

这里：

- `IFS=` 防止删除行首和行尾空白；
- `-r` 防止反斜杠转义；
- `< input.txt` 将文件内容作为循环输入。

为了处理最后一行没有换行符的文件，可以写成：

```bash
while IFS= read -r line || [[ -n $line ]]; do
    echo "$line"
done < input.txt
```

### until 循环

`until` 会在条件为假时持续执行：

```bash
count=1

until ((count > 5)); do
    echo "$count"
    ((count++))
done
```

它相当于：

```bash
while ((count <= 5)); do
    ...
done
```

### break 与 continue

`break` 结束循环：

```bash
for ((i = 1; i <= 100; i++)); do
    if ((i == 10)); then
        break
    fi
    echo "$i"
done
```

`continue` 跳过当前轮次：

```bash
for ((i = 1; i <= 10; i++)); do
    if ((i % 2 == 0)); then
        continue
    fi
    echo "$i"
done
```

---

## 第十一站：字符串处理

Shell 可以完成大量轻量字符串处理。

### 获取字符串长度

```bash
text="hello shell"
echo "${#text}"
```

### 截取字符串

```bash
text="abcdef"

echo "${text:0:3}"
echo "${text:2}"
```

输出：

```
abc
cdef
```

### 删除前缀和后缀

```bash
path="/var/log/nginx/access.log"
```

删除最短前缀：

```bash
echo "${path#*/}"
```

删除最长前缀：

```bash
echo "${path##*/}"
```

输出文件名：`access.log`。

删除最短后缀：

```bash
echo "${path%.*}"
```

删除最长后缀：

```bash
echo "${path%%/*}"
```

实际工作中常见写法：

```bash
filename="${path##*/}"
extension="${filename##*.}"
basename="${filename%.*}"
```

### 字符串替换

```bash
text="hello shell shell"

echo "${text/shell/bash}"
echo "${text//shell/bash}"
```

第一个只替换一次，第二个替换全部。

### 大小写转换

```bash
name="Shell Programming"

echo "${name,,}"
echo "${name^^}"
```

这是 Bash 扩展语法，不属于所有 `sh` 实现。

### 默认值与参数展开

变量未定义或为空时使用默认值：

```bash
echo "${name:-Guest}"
```

未定义时赋默认值：

```bash
name="${name:=Guest}"
```

变量未定义时输出错误：

```bash
config_file="${CONFIG_FILE:?CONFIG_FILE 未设置}"
```

变量已定义时使用替代值：

```bash
echo "${name:+变量已设置}"
```

这些参数展开语法非常适合配置脚本。

---

## 第十二站：数组

### 索引数组

定义：

```bash
languages=("Bash" "Python" "Go" "Rust")
```

访问元素：

```bash
echo "${languages[0]}"
echo "${languages[2]}"
```

访问全部元素：

```bash
printf '%s\n' "${languages[@]}"
```

获取数组长度：

```bash
echo "${#languages[@]}"
```

获取所有索引：

```bash
printf '%s\n' "${!languages[@]}"
```

追加元素：

```bash
languages+=("Java")
```

修改元素：

```bash
languages[1]="Python3"
```

删除元素：

```bash
unset 'languages[2]'
```

遍历：

```bash
for language in "${languages[@]}"; do
    echo "$language"
done
```

带索引遍历：

```bash
for index in "${!languages[@]}"; do
    printf '%s => %s\n' "$index" "${languages[$index]}"
done
```

### 关联数组

关联数组类似其他语言中的字典或哈希表。

```bash
declare -A user

user[name]="Alice"
user[role]="admin"
user[city]="Hangzhou"

echo "${user[name]}"
```

遍历：

```bash
for key in "${!user[@]}"; do
    printf '%s=%s\n' "$key" "${user[$key]}"
done
```

关联数组是 Bash 特性。若要追求严格 POSIX 兼容，不应使用。

---

## 第十三站：函数——从命令堆积到结构化程序

函数让脚本从"命令堆积"变成结构化程序。宋知远重写老脚本，就是从这里开始的。

### 定义函数

```bash
greet() {
    echo "Hello, Shell!"
}
```

调用：

```bash
greet
```

另一种写法：

```bash
function greet {
    echo "Hello"
}
```

推荐第一种，更简洁，也更接近 POSIX 风格。

### 函数参数

```bash
greet() {
    local name="$1"
    echo "你好，$name"
}

greet "Alice"
```

函数内部也可以使用 `$1`、`$2`、`$#`、`"$@"`、`"$*"`。

### 局部变量

```bash
calculate_sum() {
    local a="$1"
    local b="$2"
    local result=$((a + b))

    echo "$result"
}
```

`local` 可以避免函数变量污染全局作用域。

### 函数返回值

Shell 函数的 `return` 返回的是状态码，范围通常是 0 到 255：

```bash
is_even() {
    local number="$1"

    if ((number % 2 == 0)); then
        return 0
    else
        return 1
    fi
}
```

使用：

```bash
if is_even 10; then
    echo "偶数"
else
    echo "奇数"
fi
```

如果要返回字符串或较大的数值，通常通过标准输出：

```bash
get_sum() {
    local a="$1"
    local b="$2"
    echo $((a + b))
}

result=$(get_sum 10 20)
echo "$result"
```

注意：函数中用于"返回结果"的标准输出，应避免混入调试日志。可以把日志输出到标准错误：

```bash
echo "正在计算..." >&2
```

### 函数库

创建 `lib.sh`：

```bash
log_info() {
    printf '[INFO] %s\n' "$*"
}

log_error() {
    printf '[ERROR] %s\n' "$*" >&2
}
```

在主脚本中加载：

```bash
source ./lib.sh
```

或者：

```bash
. ./lib.sh
```

然后调用：

```bash
log_info "程序启动"
```

为了避免相对路径受当前工作目录影响，可以获取脚本所在目录：

```bash
SCRIPT_DIR=$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1
    pwd
)

source "$SCRIPT_DIR/lib.sh"
```

---

## 第十四站：输入输出与重定向

Shell 最强大的能力之一，就是把程序的输入输出连接起来。

### 三个标准流

每个进程通常有三个标准流：

| 编号 | 名称 | 说明 |
| ---- | ---- | ---- |
| 0 | 标准输入 stdin | 默认来自键盘 |
| 1 | 标准输出 stdout | 默认显示在终端 |
| 2 | 标准错误 stderr | 默认显示在终端 |

### 输出重定向

覆盖写入：

```bash
echo "hello" > output.txt
```

追加写入：

```bash
echo "world" >> output.txt
```

错误输出重定向：

```bash
command 2> error.log
```

标准输出和错误分别保存：

```bash
command > output.log 2> error.log
```

标准输出和错误写入同一文件：

```bash
command > all.log 2>&1
```

Bash 中也可写：

```bash
command &> all.log
```

忽略输出：

```bash
command >/dev/null 2>&1
```

### 输入重定向

```bash
wc -l < input.txt
```

### Here Document

```bash
cat <<EOF
第一行
第二行
变量：$HOME
EOF
```

若不希望变量展开：

```bash
cat <<'EOF'
变量不会展开：$HOME
命令不会执行：$(date)
EOF
```

### Here String

```bash
grep "shell" <<< "hello shell"
```

### 管道

```bash
cat access.log | grep "404" | wc -l
```

更简洁：

```bash
grep "404" access.log | wc -l
```

管道把前一个命令的标准输出，连接到后一个命令的标准输入。需要注意：管道默认通常只传递标准输出，不传递标准错误。

---

## 第十五站：文件描述符进阶

Shell 可以自行创建文件描述符。

打开文件用于写入：

```bash
exec 3> app.log
```

向文件描述符 3 写入：

```bash
echo "程序启动" >&3
echo "任务完成" >&3
```

关闭：

```bash
exec 3>&-
```

读写文件：

```bash
exec 3<> data.txt
```

文件描述符适合：

- 同时写多个日志文件；
- 保存和恢复标准输出；
- 读取多个输入源；
- 实现锁和进程通信。

保存标准输出的经典用法：

```bash
exec 3>&1
exec 1> output.log
echo "这行进入日志"
exec 1>&3
exec 3>&-
```

---

## 第十六站：文本处理三剑客——grep、sed、awk

Shell 脚本往往不是依靠复杂算法，而是组合各种文本工具。

### grep：搜索文本

查找包含关键字的行：

```bash
grep "ERROR" app.log
```

忽略大小写：

```bash
grep -i "error" app.log
```

显示行号：

```bash
grep -n "ERROR" app.log
```

反向匹配：

```bash
grep -v "DEBUG" app.log
```

递归搜索：

```bash
grep -R "TODO" .
```

只统计数量：

```bash
grep -c "ERROR" app.log
```

扩展正则：

```bash
grep -E 'ERROR|WARN' app.log
```

### sed：流式编辑

替换文本：

```bash
sed 's/http/https/' config.txt
```

全局替换：

```bash
sed 's/http/https/g' config.txt
```

删除空行：

```bash
sed '/^[[:space:]]*$/d' file.txt
```

打印指定行：

```bash
sed -n '10,20p' file.txt
```

直接修改文件前应谨慎测试，并注意不同系统中 `sed -i` 的细节可能不同。更稳妥的工程习惯：

1. 先输出到终端验证；
2. 再写入临时文件；
3. 检查成功后替换原文件；
4. 必要时保留备份。

### awk：按列处理

假设文件 `scores.txt`：

```
Alice 90
Bob 75
Carol 88
```

打印第一列：

```bash
awk '{print $1}' scores.txt
```

打印分数大于 80 的记录：

```bash
awk '$2 > 80 {print $1, $2}' scores.txt
```

求和：

```bash
awk '{sum += $2} END {print sum}' scores.txt
```

指定分隔符：

```bash
awk -F: '{print $1}' /etc/passwd
```

传入 Shell 变量：

```bash
limit=80
awk -v limit="$limit" '$2 > limit {print $0}' scores.txt
```

### 组合使用

统计日志中不同状态码出现次数：

```bash
awk '{print $9}' access.log |
    sort |
    uniq -c |
    sort -nr
```

统计最常访问的 URL：

```bash
awk '{print $7}' access.log |
    sort |
    uniq -c |
    sort -nr |
    head
```

Shell 的核心思想不是"所有事情都自己实现"，而是让小工具各司其职，再通过管道组合。

---

## 第十七站：进程与作业控制

### 前台与后台

前台运行：

```bash
sleep 10
```

后台运行：

```bash
sleep 10 &
```

获取最近后台进程 PID：

```bash
pid=$!
echo "$pid"
```

等待后台进程：

```bash
wait "$pid"
```

获取其退出状态：

```bash
if wait "$pid"; then
    echo "后台任务成功"
else
    echo "后台任务失败"
fi
```

### 并发执行

```bash
task_a &
pid_a=$!

task_b &
pid_b=$!

wait "$pid_a"
status_a=$?

wait "$pid_b"
status_b=$?
```

简单并发可以提高批处理效率，但要注意：

- CPU 和内存占用；
- 磁盘与网络压力；
- 多进程同时写同一个文件；
- 错误收集；
- 并发数量限制。

### 查看进程

```bash
ps aux
```

查找进程：

```bash
pgrep -af nginx
```

查看进程树：

```bash
pstree
```

结束进程：

```bash
kill "$pid"
```

强制结束：

```bash
kill -9 "$pid"
```

`kill -9` 不应作为默认手段。优先发送普通终止信号，让程序有机会清理资源。

---

## 第十八站：信号与 trap——优雅地善后

脚本可能因为用户按下 Ctrl+C、系统发送终止信号或命令失败而中断。此时需要清理临时文件、释放锁、停止子进程。宋知远清理脚本的事故，根子就在这里。

### 捕获退出信号

```bash
cleanup() {
    echo "正在清理..."
    rm -f /tmp/my_script.tmp
}

trap cleanup EXIT
```

无论脚本正常结束还是发生大多数错误，`EXIT` 陷阱都会执行。

捕获中断信号：

```bash
trap 'echo "收到中断信号"; exit 130' INT
```

捕获终止信号：

```bash
trap 'echo "收到终止信号"; exit 143' TERM
```

### 临时目录安全用法

```bash
tmp_dir=$(mktemp -d)

cleanup() {
    rm -rf -- "$tmp_dir"
}

trap cleanup EXIT
```

不要手写可预测的临时文件名：

```
/tmp/app.tmp
```

因为它可能：

- 与其他进程冲突；
- 被恶意创建为符号链接；
- 被并发脚本覆盖。

使用 `mktemp` 更安全。

---

## 第十九站：错误处理与严格模式

很多 Shell 脚本最危险的问题不是"语法错误"，而是命令失败后脚本仍然继续执行。

### set -e

```bash
set -e
```

当某些命令失败时退出脚本。但 `set -e` 并不是简单的"任何错误都退出"，它在条件判断、管道、逻辑运算等上下文中存在例外，因此不能只依赖它解决所有错误处理问题。

### set -u

```bash
set -u
```

使用未定义变量时退出。例如：

```bash
echo "$UNDEFINED_VAR"
```

这能发现变量名拼写错误。

### set -o pipefail

默认情况下，管道的退出状态通常由最后一个命令决定：

```bash
false | true
echo "$?"
```

可能得到 `0`。开启：

```bash
set -o pipefail
```

管道中任意命令失败，都可能使整个管道失败。

### 常用严格模式

```bash
set -Eeuo pipefail
```

含义：

- `-E`：错误陷阱可在函数和子 Shell 等场景中继承；
- `-e`：遇到未处理失败时退出；
- `-u`：未定义变量视为错误；
- `pipefail`：管道中任意命令失败都能影响结果。

再配合：

```bash
IFS=$'\n\t'
```

可以减少默认空格分割带来的意外。

不过需要理解：

- 严格模式不是万能模板；
- 某些脚本需要对可接受失败显式处理；
- 第三方命令的非零状态有时不代表真正错误；
- 生产脚本应针对关键步骤写明确的错误信息。

### 显式错误处理

```bash
if ! cp "$source" "$target"; then
    echo "复制失败：$source -> $target" >&2
    exit 1
fi
```

或者：

```bash
cp "$source" "$target" || {
    echo "复制失败" >&2
    exit 1
}
```

封装失败函数：

```bash
die() {
    printf '错误：%s\n' "$*" >&2
    exit 1
}
```

使用：

```bash
[[ -f $config ]] || die "配置文件不存在：$config"
```

---

## 第二十站：日志系统

不要让生产脚本只输出零散的 `echo`。可以定义统一日志函数：

```bash
log() {
    local level="$1"
    shift

    printf '%s [%s] %s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$level" \
        "$*"
}

log_info() {
    log "INFO" "$@"
}

log_warn() {
    log "WARN" "$@" >&2
}

log_error() {
    log "ERROR" "$@" >&2
}
```

使用：

```bash
log_info "任务开始"
log_warn "磁盘空间不足"
log_error "数据库连接失败"
```

更完善的日志系统可以支持：

- 日志级别；
- 输出到文件；
- 彩色终端；
- JSON 格式；
- 脚本名称和行号；
- 日志滚动；
- 调试开关。

避免把敏感信息写入日志，例如：

- 密码；
- Token；
- 私钥；
- 完整身份证件信息；
- 数据库连接密钥。

---

## 第二十一站：命令行选项解析

简单参数可以手动处理：

```bash
while (($# > 0)); do
    case "$1" in
        -f|--file)
            file="$2"
            shift 2
            ;;
        -v|--verbose)
            verbose=true
            shift
            ;;
        -h|--help)
            echo "用法：$0 [选项]"
            exit 0
            ;;
        *)
            echo "未知参数：$1" >&2
            exit 1
            ;;
    esac
done
```

需要注意缺失参数：

```bash
-f)
    (($# >= 2)) || {
        echo "-f 需要一个文件参数" >&2
        exit 1
    }
    file="$2"
    shift 2
    ;;
```

### 使用 getopts

```bash
#!/usr/bin/env bash

verbose=false
output=""

while getopts ":vo:h" option; do
    case "$option" in
        v)
            verbose=true
            ;;
        o)
            output="$OPTARG"
            ;;
        h)
            echo "用法：$0 [-v] [-o output]"
            exit 0
            ;;
        :)
            echo "选项 -$OPTARG 缺少参数" >&2
            exit 1
            ;;
        \?)
            echo "未知选项：-$OPTARG" >&2
            exit 1
            ;;
    esac
done

shift $((OPTIND - 1))
```

`getopts` 适合短选项。复杂长选项通常通过 `case` + `shift` 处理，或使用外部参数解析工具。

---

## 第二十二站：子 Shell、命令分组与作用域

### 子 Shell

圆括号中的命令在子 Shell 中执行：

```bash
(
    cd /tmp
    echo "当前目录：$PWD"
)

echo "外部目录：$PWD"
```

子 Shell 中对目录和变量的修改，不会影响父 Shell。

### 当前 Shell 命令组

花括号中的命令在当前 Shell 中执行：

```bash
{
    echo "第一行"
    echo "第二行"
} > output.txt
```

花括号后面通常需要空格，最后一条命令后要有分号或换行。

### 管道与变量作用域

下面的写法可能得不到预期结果：

```bash
count=0

printf '%s\n' a b c |
while IFS= read -r line; do
    ((count++))
done

echo "$count"
```

在一些环境中，`while` 可能运行在子 Shell 中，因此循环后的 `count` 仍为 0。

可改为进程替换：

```bash
count=0

while IFS= read -r line; do
    ((count++))
done < <(printf '%s\n' a b c)

echo "$count"
```

---

## 第二十三站：进程替换

进程替换语法：

```
<(command)
```

它把命令输出表现为一个类似文件的路径。

比较两个命令输出：

```bash
diff <(sort file1.txt) <(sort file2.txt)
```

读取命令输出：

```bash
while IFS= read -r line; do
    echo "$line"
done < <(find . -type f)
```

输出进程替换：

```
>(command)
```

例如同时写入文件并过滤输出：

```bash
exec > >(tee -a app.log) 2>&1
```

之后脚本输出既显示在终端，也追加到日志文件。

进程替换是 Bash 等 Shell 的扩展功能，不属于严格 POSIX sh。

---

## 第二十四站：调试 Shell 脚本

### 语法检查

```bash
bash -n script.sh
```

它只检查语法，不真正执行命令。

### 跟踪执行

```bash
bash -x script.sh
```

也可以在脚本中开启：

```bash
set -x
```

关闭：

```bash
set +x
```

局部调试：

```bash
set -x
important_command
set +x
```

注意：`set -x` 可能打印敏感变量。

### 自定义调试输出

```bash
DEBUG=${DEBUG:-false}

debug() {
    if [[ $DEBUG == true ]]; then
        printf '[DEBUG] %s\n' "$*" >&2
    fi
}
```

运行：

```bash
DEBUG=true ./script.sh
```

### 显示行号和函数名

```bash
PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]}: '
set -x
```

调试输出会包含：

- 脚本文件；
- 行号；
- 函数名。

### 使用 ShellCheck

ShellCheck 是常用的 Shell 静态分析工具，可以发现：

- 未加引号的变量；
- 无效条件判断；
- 数组展开错误；
- 不安全的 read；
- 管道与子 Shell 问题；
- 可疑的重定向；
- 兼容性问题。

使用：

```bash
shellcheck script.sh
```

静态检查不能替代测试，但能提前发现大量常见错误。

---

## 第二十五站：最重要的引号规则

很多 Shell Bug 都来自变量没有加双引号。

假设：

```bash
file="my report.txt"
```

错误：

```bash
rm $file
```

Shell 可能把它拆成两个参数：`my` 和 `report.txt`。

正确：

```bash
rm -- "$file"
```

推荐习惯：

```bash
cp -- "$source" "$target"
mv -- "$old_name" "$new_name"
rm -- "$file"
printf '%s\n' "$value"
```

其中 `--` 表示后续内容不再解析为选项。例如文件名是 `-rf`，如果执行：

```bash
rm "$file"
```

命令可能把它理解成选项。使用 `rm -- "$file"` 更安全。

### 什么时候不加引号

某些特定语境不需要或不能加引号，例如：

```bash
[[ $file == *.log ]]
```

右侧模式不加引号。算术上下文：

```bash
((count += 1))
```

数组索引等也有自己的规则。

原则不是"所有内容都机械加引号"，而是：

> 默认给变量展开加双引号，只有明确需要分割、通配或模式匹配时才例外。

---

## 第二十六站：安全编程——避免危险脚本

宋知远清理脚本的事故，就是这一站的真实注脚。

### 永远谨慎对待 rm -rf

危险写法：

```bash
rm -rf "$target_dir"/*
```

如果 `target_dir` 为空或设置错误，后果可能非常严重。

更安全：

```bash
[[ -n ${target_dir:-} ]] || die "target_dir 为空"
[[ $target_dir == /srv/app/cache ]] || die "拒绝删除非预期目录"

rm -rf -- "$target_dir"/*
```

对于删除操作，应检查：

- 变量是否为空；
- 路径是否为预期目录；
- 是否为根目录；
- 是否包含未展开变量；
- 是否会跨文件系统；
- 是否需要交互确认或备份。

### 防止命令注入

危险：

```bash
eval "$user_input"
```

如果用户输入 `echo hello; rm -rf ...`，可能执行任意命令。尽量避免 `eval`。

不要把外部输入直接拼成命令字符串：

```bash
command="grep $keyword $file"
$command
```

更安全：

```bash
grep -- "$keyword" "$file"
```

使用数组保存命令和参数：

```bash
cmd=(grep -n -- "$keyword" "$file")
"${cmd[@]}"
```

### 不要信任文件名

文件名可能包含：

- 空格；
- 换行；
- 通配符；
- 以 `-` 开头；
- 控制字符。

处理文件时应使用：

- 双引号；
- `--`；
- `find -print0`；
- `read -d ''`；
- 数组。

### 检查外部命令

```bash
require_command() {
    command -v "$1" >/dev/null 2>&1 || {
        echo "缺少依赖命令：$1" >&2
        exit 1
    }
}

require_command curl
require_command tar
```

### 不要在命令行暴露密钥

例如：

```bash
curl -H "Authorization: Bearer $TOKEN" ...
```

虽然有时难以完全避免，但要注意：

- 命令历史；
- 调试输出；
- 进程列表；
- CI 日志；
- 错误日志。

优先使用安全的凭据文件、标准输入、密钥管理系统或受保护环境变量。

### 设置安全权限

创建敏感文件前：

```bash
umask 077
```

这样新文件默认只允许当前用户访问。

---

## 第二十七站：可移植性——Bash 还是 POSIX sh

如果脚本只运行在已知的 Bash 环境中，可以使用：

- `[[ ... ]]`；
- 数组；
- 关联数组；
- `mapfile`；
- 进程替换；
- `BASH_SOURCE`；
- `=~` 正则匹配；
- `set -o pipefail`。

如果脚本需要运行在各种 Unix 环境中，应考虑 POSIX sh，避免 Bash 专属语法。例如 Bash 数组：

```bash
items=("a" "b" "c")
```

在 POSIX sh 中不可用。

工程上不必盲目追求可移植性。应先明确部署环境：

- 只在公司 Linux 服务器上运行：可以统一 Bash；
- 需要运行在精简系统或多种 Unix 上：优先 POSIX sh；
- 复杂逻辑不断增长：考虑改用 Python、Go 等语言。

---

## 第二十八站：什么时候不应该继续使用 Shell

Shell 非常适合：

- 调用和组合系统命令；
- 文件批处理；
- 部署与初始化；
- 日志过滤；
- CI/CD 步骤；
- 简单监控；
- 轻量自动化。

Shell 不太适合：

- 复杂数据结构；
- 大型业务逻辑；
- 高精度数学运算；
- 复杂网络服务；
- 长期维护的大型应用；
- 需要完善单元测试和类型系统的项目；
- 对跨平台一致性要求很高的程序。

一个实用判断：

> 如果脚本主要是在"编排命令"，Shell 很合适；如果脚本主要是在"实现算法和业务规则"，应考虑其他语言。

---

## 第二十九站：性能优化原则

Shell 的性能瓶颈常来自大量外部进程。

低效：

```bash
while IFS= read -r line; do
    echo "$line" | grep "ERROR" >/dev/null
    if [[ $? -eq 0 ]]; then
        echo "$line"
    fi
done < app.log
```

每一行都启动多个外部进程。更高效：

```bash
grep "ERROR" app.log
```

优化原则：

1. 能用一次 awk 完成，就不要循环启动几千次命令；
2. 减少无意义的 cat；
3. 避免在循环中频繁调用 date、grep、sed；
4. 大数据处理优先考虑 awk、专用工具或其他语言；
5. 并发不等于越多越快；
6. 先测量，再优化。

简单计时：

```bash
time ./script.sh
```

记录纳秒或毫秒级时间时，要注意不同系统的 date 实现可能不同。跨平台脚本应选择兼容方式或使用专门的计时工具。

---

## 第三十站：编写可维护脚本的工程规范

### 推荐脚本结构

```bash
#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly SCRIPT_DIR=$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1
    pwd
)

log() {
    printf '%s [%s] %s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$1" \
        "$2"
}

die() {
    log "ERROR" "$*" >&2
    exit 1
}

usage() {
    cat <<EOF
用法：
  $SCRIPT_NAME [选项]

选项：
  -h, --help    显示帮助
EOF
}

parse_args() {
    while (($# > 0)); do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;
            *)
                die "未知参数：$1"
                ;;
        esac
    done
}

main() {
    parse_args "$@"
    log "INFO" "程序开始"
}

main "$@"
```

### 关键原则

- 在顶部明确解释器；
- 根据需要启用严格模式；
- 常量使用 readonly；
- 函数变量使用 local；
- 业务入口统一放在 main；
- 错误写入标准错误；
- 成功和失败返回明确状态码；
- 参数必须验证；
- 删除和覆盖操作必须做保护；
- 依赖命令要检查；
- 不在函数中滥用全局变量；
- 复杂逻辑拆分为多个函数；
- 避免超过几十行的巨大函数；
- 使用静态检查和自动化测试。

---

## 第三十一站：实战一——批量重命名文件

一个月后，宋知远交出的第一份"敢在生产跑"的脚本：将目录中的 `.JPG` 文件改为小写扩展名 `.jpg`。

```bash
#!/usr/bin/env bash

set -Eeuo pipefail

for file in ./*.JPG; do
    [[ -e $file ]] || continue

    new_name="${file%.JPG}.jpg"

    if [[ -e $new_name ]]; then
        printf '跳过，目标已存在：%s\n' "$new_name" >&2
        continue
    fi

    mv -- "$file" "$new_name"
    printf '重命名：%s -> %s\n' "$file" "$new_name"
done
```

改进点：

- 使用双引号处理空格；
- 使用 `--` 防止文件名被当成选项；
- 检查目标是否已存在；
- 不覆盖已有文件；
- 输出清晰操作记录。

加入"预览模式"：

```bash
dry_run=false

if [[ ${1:-} == "--dry-run" ]]; then
    dry_run=true
fi

for file in ./*.JPG; do
    [[ -e $file ]] || continue

    new_name="${file%.JPG}.jpg"

    if [[ $dry_run == true ]]; then
        printf '[预览] %s -> %s\n' "$file" "$new_name"
    else
        mv -- "$file" "$new_name"
    fi
done
```

对批量修改类脚本，`--dry-run` 非常重要。

---

## 第三十二站：实战二——日志分析脚本

目标：

- 统计总请求数；
- 统计 4xx 和 5xx；
- 输出访问量最高的前 10 个路径。

```bash
#!/usr/bin/env bash

set -Eeuo pipefail

log_file="${1:-}"

if [[ -z $log_file ]]; then
    echo "用法：$0 access.log" >&2
    exit 1
fi

if [[ ! -f $log_file ]]; then
    echo "日志文件不存在：$log_file" >&2
    exit 1
fi

total_requests=$(wc -l < "$log_file")

client_errors=$(
    awk '$9 >= 400 && $9 < 500 {count++} END {print count + 0}' "$log_file"
)

server_errors=$(
    awk '$9 >= 500 && $9 < 600 {count++} END {print count + 0}' "$log_file"
)

printf '总请求数：%s\n' "$total_requests"
printf '4xx 数量：%s\n' "$client_errors"
printf '5xx 数量：%s\n' "$server_errors"

echo
echo "访问量最高的路径："

awk '{print $7}' "$log_file" |
    sort |
    uniq -c |
    sort -nr |
    head -n 10
```

进一步可以增加：

- 状态码分布；
- IP 排名；
- User-Agent 分析；
- 每小时请求量；
- 慢请求统计；
- 输出 CSV 或 HTML 报告。

---

## 第三十三站：实战三——服务健康检查

目标：检查一个 HTTP 地址是否可访问，失败时重试。

```bash
#!/usr/bin/env bash

set -Eeuo pipefail

url="${1:-https://example.com}"
max_attempts=3
timeout_seconds=5

check_url() {
    curl \
        --fail \
        --silent \
        --show-error \
        --location \
        --max-time "$timeout_seconds" \
        "$url" \
        >/dev/null
}

for ((attempt = 1; attempt <= max_attempts; attempt++)); do
    printf '第 %d 次检查：%s\n' "$attempt" "$url"

    if check_url; then
        echo "服务正常"
        exit 0
    fi

    if ((attempt < max_attempts)); then
        sleep 2
    fi
done

echo "服务检查失败：$url" >&2
exit 1
```

生产环境中还可以检查：

- HTTP 状态码；
- 响应时间；
- 返回内容是否包含关键字；
- TLS 证书是否即将过期；
- DNS 是否正常；
- TCP 端口是否可达；
- 失败时发送告警。

---

## 第三十四站：实战四——数据库备份脚本

下面用通用结构展示一个备份脚本。实际使用时，应根据数据库类型调整备份命令。

功能：

- 创建按日期命名的备份；
- 记录日志；
- 自动清理过期备份；
- 使用临时文件；
- 捕获异常；
- 防止并发执行。

```bash
#!/usr/bin/env bash

set -Eeuo pipefail

readonly SCRIPT_NAME="${0##*/}"
readonly BACKUP_DIR="${BACKUP_DIR:-/var/backups/myapp}"
readonly RETENTION_DAYS="${RETENTION_DAYS:-7}"
readonly TIMESTAMP="$(date '+%Y%m%d_%H%M%S')"
readonly FINAL_FILE="$BACKUP_DIR/database_$TIMESTAMP.sql.gz"

tmp_file=""
lock_dir="/tmp/${SCRIPT_NAME}.lock"

log() {
    local level="$1"
    shift

    printf '%s [%s] %s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$level" \
        "$*"
}

die() {
    log "ERROR" "$*" >&2
    exit 1
}

cleanup() {
    if [[ -n ${tmp_file:-} && -f $tmp_file ]]; then
        rm -f -- "$tmp_file"
    fi

    rmdir "$lock_dir" 2>/dev/null || true
}

trap cleanup EXIT
trap 'die "脚本被中断"' INT TERM

acquire_lock() {
    if ! mkdir "$lock_dir" 2>/dev/null; then
        die "已有备份任务正在运行"
    fi
}

check_requirements() {
    command -v gzip >/dev/null 2>&1 ||
        die "缺少 gzip"

    command -v find >/dev/null 2>&1 ||
        die "缺少 find"
}

create_backup() {
    mkdir -p -- "$BACKUP_DIR"

    tmp_file=$(mktemp "$BACKUP_DIR/.backup.XXXXXX")

    log "INFO" "开始创建备份"

    # 将下面的示例命令替换成真实数据库导出命令。
    # 例如：数据库导出命令 | gzip > "$tmp_file"
    printf '%s\n' \
        "-- 示例备份文件" \
        "-- 创建时间：$(date '+%Y-%m-%d %H:%M:%S')" |
        gzip > "$tmp_file"

    [[ -s $tmp_file ]] || die "备份文件为空"

    mv -- "$tmp_file" "$FINAL_FILE"
    tmp_file=""

    log "INFO" "备份完成：$FINAL_FILE"
}

remove_old_backups() {
    log "INFO" "清理 $RETENTION_DAYS 天前的备份"

    find "$BACKUP_DIR" \
        -type f \
        -name 'database_*.sql.gz' \
        -mtime "+$RETENTION_DAYS" \
        -print \
        -delete
}

main() {
    acquire_lock
    check_requirements
    create_backup
    remove_old_backups
    log "INFO" "全部任务完成"
}

main "$@"
```

这个脚本体现了生产脚本的重要思想：

- 配置可通过环境变量覆盖；
- 严格模式；
- 依赖检查；
- 临时文件；
- 原子式重命名；
- 锁机制；
- 信号清理；
- 日志；
- 备份有效性检查；
- 过期文件清理。

实际数据库凭据不要直接硬编码在脚本中。

---

## 第三十五站：实战五——并发批量检查服务器

假设有一个服务器列表 `servers.txt`：

```
server1.example.com
server2.example.com
server3.example.com
```

脚本：

```bash
#!/usr/bin/env bash

set -Eeuo pipefail

server_file="${1:-servers.txt}"
max_parallel="${MAX_PARALLEL:-5}"

[[ -f $server_file ]] || {
    echo "服务器列表不存在：$server_file" >&2
    exit 1
}

check_server() {
    local server="$1"

    if ping -c 1 -W 2 "$server" >/dev/null 2>&1; then
        printf '%-30s %s\n' "$server" "UP"
        return 0
    else
        printf '%-30s %s\n' "$server" "DOWN"
        return 1
    fi
}

running=0
failed=0

while IFS= read -r server || [[ -n $server ]]; do
    [[ -n $server ]] || continue
    [[ $server == \#* ]] && continue

    (
        check_server "$server"
    ) &

    ((running += 1))

    if ((running >= max_parallel)); then
        if ! wait -n; then
            ((failed += 1))
        fi
        ((running -= 1))
    fi
done < "$server_file"

while ((running > 0)); do
    if ! wait -n; then
        ((failed += 1))
    fi
    ((running -= 1))
done

printf '失败数量：%d\n' "$failed"

((failed == 0))
```

说明：

- `wait -n` 需要较新的 Bash；
- 如果目标环境 Bash 较旧，需要换用保存 PID 列表的兼容实现；
- 并发数量必须受控；
- 不同系统的 ping 参数可能不同。

---

## 第三十六站：脚本测试方法

Shell 脚本也需要测试。

### 测试正常输入

```bash
./script.sh valid_input
```

### 测试边界情况

- 空字符串；
- 不存在的文件；
- 空目录；
- 超长文件名；
- 带空格的文件名；
- 以 `-` 开头的文件名；
- 权限不足；
- 磁盘满；
- 网络超时；
- 外部命令不存在；
- 用户中断；
- 并发执行。

### 测试退出状态

```bash
./script.sh
status=$?

if ((status != 0)); then
    echo "脚本失败，状态码：$status"
fi
```

### 在临时目录中测试

```bash
test_dir=$(mktemp -d)
trap 'rm -rf -- "$test_dir"' EXIT

touch "$test_dir/file one.txt"
touch "$test_dir/-dangerous-name"
```

在隔离目录中测试破坏性操作，避免误伤真实文件。

### 自动化测试工具

Shell 项目可以使用专门的测试框架，也可以自行编写简单断言：

```bash
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-}"

    if [[ $expected != "$actual" ]]; then
        printf '断言失败：%s\n期望：%s\n实际：%s\n' \
            "$message" "$expected" "$actual" >&2
        return 1
    fi
}
```

测试函数：

```bash
add() {
    echo $(($1 + $2))
}

result=$(add 2 3)
assert_equals "5" "$result" "2 + 3 应等于 5"
```

---

## 第三十七站：常见错误与修复

### 错误一：变量赋值两边有空格

错误：

```bash
name = "Shell"
```

正确：

```bash
name="Shell"
```

### 错误二：变量未加引号

错误：

```bash
cp $source $target
```

正确：

```bash
cp -- "$source" "$target"
```

### 错误三：使用 for file in $(ls)

错误：

```bash
for file in $(ls); do
    echo "$file"
done
```

它无法正确处理空格和换行。更好：

```bash
for file in ./*; do
    [[ -e $file ]] || continue
    echo "$file"
done
```

### 错误四：错误使用 $?

不推荐：

```bash
command
echo "执行了一些其他操作"
if [[ $? -eq 0 ]]; then
    ...
fi
```

此时 `$?` 对应的是 echo，不是原命令。推荐：

```bash
if command; then
    ...
else
    ...
fi
```

### 错误五：把函数输出和日志混在一起

错误：

```bash
get_value() {
    echo "正在处理"
    echo "42"
}

value=$(get_value)
```

`value` 会同时包含日志和结果。修复：

```bash
get_value() {
    echo "正在处理" >&2
    echo "42"
}
```

### 错误六：使用 eval

大多数 `eval` 都可以用数组、关联数组、函数或参数展开替代。

### 错误七：忽略退出状态

关键命令执行后必须确认是否成功，尤其是：

- 备份；
- 上传；
- 删除；
- 数据迁移；
- 服务重启；
- 配置替换。

### 错误八：假设所有系统命令参数相同

GNU/Linux、macOS、BSD 和精简环境中的命令参数可能有差异。脚本开发前应明确运行平台。

---

## 第三十八站：Shell 学习路线

### 第一阶段：命令行基础

掌握：

- 文件和目录操作；
- 权限；
- 管道；
- 重定向；
- grep、sed、awk；
- 进程；
- 环境变量。

### 第二阶段：脚本语法

掌握：

- 变量；
- 引号；
- 参数；
- 判断；
- 循环；
- 函数；
- 数组；
- 命令替换；
- 算术运算。

### 第三阶段：健壮性

掌握：

- 退出状态；
- 错误处理；
- trap；
- 临时文件；
- 文件锁；
- 参数解析；
- 日志；
- ShellCheck；
- 单元测试思路。

### 第四阶段：工程化

掌握：

- 模块化；
- 配置管理；
- 可移植性；
- 安全编程；
- 并发控制；
- 性能分析；
- CI/CD 集成；
- 部署和回滚。

### 第五阶段：形成工具思维

真正的 Shell 高手，不是记住最多命令的人，而是能够快速判断：

- 该用 Shell 内建语法还是外部命令；
- 该用管道还是循环；
- 该用 awk 还是换成 Python；
- 哪些参数需要验证；
- 哪些操作具有破坏性；
- 如何保证失败后可恢复；
- 如何让其他人看得懂并敢于维护。

---

## 第三十九站：Shell 编程速查表

### 变量

```bash
name="Shell"
echo "$name"
readonly name
unset name
```

### 命令替换

```bash
result=$(command)
```

### 算术

```bash
result=$((a + b))
((count++))
```

### 判断

```bash
[[ -f $file ]]
[[ -d $dir ]]
[[ -n $text ]]
[[ $a == "$b" ]]
((number > 10))
```

### if

```bash
if condition; then
    ...
elif condition; then
    ...
else
    ...
fi
```

### case

```bash
case "$value" in
    pattern)
        ...
        ;;
    *)
        ...
        ;;
esac
```

### 循环

```bash
for item in "${items[@]}"; do
    ...
done
while condition; do
    ...
done
```

### 函数

```bash
function_name() {
    local value="$1"
    ...
}
```

### 参数

```bash
$0
$1
$#
"$@"
$?
$$
$!
```

### 重定向

```bash
> file
>> file
2> error.log
> all.log 2>&1
< input.txt
```

### 严格模式

```bash
set -Eeuo pipefail
```

### 临时目录

```bash
tmp_dir=$(mktemp -d)
trap 'rm -rf -- "$tmp_dir"' EXIT
```

---

## 第四十站：一份可直接复用的生产脚本模板

```bash
#!/usr/bin/env bash

set -Eeuo pipefail
IFS=$'\n\t'

readonly SCRIPT_NAME="${0##*/}"
readonly SCRIPT_DIR=$(
    cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1
    pwd
)

DEBUG=${DEBUG:-false}
tmp_dir=""

log() {
    local level="$1"
    shift

    printf '%s [%s] [%s] %s\n' \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$SCRIPT_NAME" \
        "$level" \
        "$*"
}

debug() {
    if [[ $DEBUG == true ]]; then
        log "DEBUG" "$@" >&2
    fi
}

info() {
    log "INFO" "$@"
}

warn() {
    log "WARN" "$@" >&2
}

die() {
    log "ERROR" "$@" >&2
    exit 1
}

cleanup() {
    local status=$?

    if [[ -n ${tmp_dir:-} && -d $tmp_dir ]]; then
        rm -rf -- "$tmp_dir"
    fi

    if ((status == 0)); then
        debug "脚本正常退出"
    else
        warn "脚本异常退出，状态码：$status"
    fi

    exit "$status"
}

on_error() {
    local line="$1"
    local command="$2"
    local status="$3"

    log "ERROR" \
        "命令执行失败：line=$line status=$status command=$command" >&2
}

trap cleanup EXIT
trap 'on_error "$LINENO" "$BASH_COMMAND" "$?"' ERR
trap 'die "收到中断信号"' INT TERM

usage() {
    cat <<EOF
用法：
  $SCRIPT_NAME [选项]

选项：
  -h, --help       显示帮助
  -d, --debug      开启调试日志
EOF
}

require_command() {
    local command_name="$1"

    command -v "$command_name" >/dev/null 2>&1 ||
        die "缺少依赖命令：$command_name"
}

parse_args() {
    while (($# > 0)); do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;
            -d|--debug)
                DEBUG=true
                shift
                ;;
            *)
                die "未知参数：$1"
                ;;
        esac
    done
}

main() {
    parse_args "$@"

    require_command mktemp

    tmp_dir=$(mktemp -d)

    info "任务开始"
    debug "脚本目录：$SCRIPT_DIR"
    debug "临时目录：$tmp_dir"

    # 在这里编写业务逻辑。

    info "任务完成"
}

main "$@"
```

这份模板并非适用于所有脚本，但它提供了一个良好的起点：

- 严格模式；
- 日志函数；
- 调试开关；
- 参数解析；
- 依赖检查；
- 临时目录；
- 错误陷阱；
- 信号处理；
- 统一入口。

---

## 结语：从"能运行"到"可靠运行"

故事讲完了。

那个差点删掉整个网站的脚本，被宋知远重写成了带预览、带锁、带日志的新版本。CTO 在新脚本的评审意见里只写了一句话："这才是资产，不是炸弹。"

Shell 的门槛很低，但真正写好并不容易。

初学者看到的是：

```bash
echo "Hello"
```

熟练者看到的是：

- 输入是否可信；
- 文件名是否包含特殊字符；
- 命令失败后是否继续；
- 临时文件是否会被清理；
- 多进程是否会冲突；
- 日志是否足够定位问题；
- 脚本是否能重复执行；
- 操作是否可回滚；
- 密钥是否会泄露；
- 运行环境是否兼容。

从"能运行"到"可靠运行"，才是 Shell 编程真正的进阶。

学习 Shell 最有效的方法，不是一次背下所有语法，而是不断把重复工作脚本化：

- 每天执行一次的命令，写成脚本；
- 每周整理一次的文件，写成脚本；
- 每次部署都要重复的步骤，写成脚本；
- 每次排查都要组合的日志命令，写成脚本；
- 每次担心误操作的流程，加入检查、预览和日志。

当你能够把一串临时命令，逐步改造成一个安全、清晰、可测试、可复用的工具时，你就真正掌握了 Shell 编程。

真正的"精通"，不是复制模板，而是理解每一行为什么存在，并根据具体场景做出正确取舍。

> Shell 编程的核心不是记住多少命令，而是让每一次自动化都安全、清晰、可测试、可复用。

---

## 参考资料

- [1. GNU Bash 官方手册](https://www.gnu.org/software/bash/manual/)
- [2. Bash Reference Manual：Shell Parameters](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html)
- [3. Bash Reference Manual：Shell Builtin Commands](https://www.gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html)
- [4. POSIX Shell Command Language](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html)
- [5. ShellCheck — A shell script static analysis tool](https://www.shellcheck.net/)
- [6. ShellCheck 用户手册](https://github.com/koalaman/shellcheck/wiki)
- [7. Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [8. GNU Coreutils 官方手册](https://www.gnu.org/software/coreutils/manual/)
- [9. GNU awk 用户指南](https://www.gnu.org/software/gawk/manual/gawk.html)
- [10. GNU sed 官方手册](https://www.gnu.org/software/sed/manual/sed.html)
