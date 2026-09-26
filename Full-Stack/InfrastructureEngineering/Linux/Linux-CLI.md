# [Linux 命令行从入门到精通：一篇文章掌握终端、Shell 与高效运维](https://mp.weixin.qq.com/s/odlsBmQNbev_QsIDdxwoDg)

> 这是一个关于"陆遥"的故事——一个在"雪松数据"从开发转岗运维的程序员。公司只有一台服务器，过去是开发随手维护，最近一个月挂了三次：磁盘满了没人发现、服务半夜悄悄退出、日志堆成山却不知道从哪查起。老板拍板：你来专职管它。你会跟着陆遥一起，从第一次面对那个黑色窗口的忐忑，走到能独立完成部署、排障、备份自动化的那一天。读完之后你会发现：命令行并不神秘，它只是用更直接、更高效的方式与计算机沟通。

---

## 故事的起点：凌晨两点，服务器又挂了

陆遥在"雪松数据"做了两年开发。公司的业务系统跑在一台 Ubuntu 服务器上，过去一直由开发们"顺手"维护。

那天凌晨两点，客服电话打爆：客户报表系统打不开了。陆遥被叫起来，登录服务器，眼前一片黑——不对，是一片白茫茫的报错。

磁盘满了。`df -h` 都不认识的他，折腾到天亮才在同事远程指导下清出空间。

这已经是这个月第三次事故。第一次是服务退出没人发现，第二次是日志把磁盘写满，第三次还是磁盘。

第二天，老板把陆遥叫到办公室："你转运维吧，专职管这台机器。"

陆遥苦笑："我连 `ls` 都只会用 `ls -l`……"

老板说："那就学。一个月后，我不希望再在凌晨接到你的电话。"

陆遥坐在服务器前，看着那个黑色窗口里闪烁的光标，深吸一口气，开始了他的 Linux 命令行之路。

这个故事，就是他从"看到终端就紧张"到"把重复工作写成脚本"的完整路线图。

---

## 第一站：Linux 命令行到底是什么？

陆遥的第一课，是搞清楚他面前这个黑色窗口的构成。

Linux 命令行通常由三部分组成：

- **终端 Terminal**：用于输入命令和显示结果的窗口；
- **Shell**：负责解释命令的程序；
- **命令或程序**：真正执行任务的工具。

常见 Shell 包括：`bash`、`zsh`、`fish`、`sh`。

查看当前使用的 Shell：

```bash
echo $SHELL
```

查看当前 Shell 进程：

```bash
echo $0
```

Linux 命令的一般格式是：

```
命令 [选项] [参数]
```

例如：

```bash
ls -lah /var/log
```

其中：

- `ls` 是命令；
- `-lah` 是选项；
- `/var/log` 是参数。

多个短选项通常可以合并：

```bash
ls -l -a -h
```

等价于：

```bash
ls -lah
```

---

## 第二站：第一次进入终端——先认识提示符

陆遥看到的提示符长这样：

```
user@server:~$
```

它通常表示：

- `user`：当前用户名；
- `server`：主机名；
- `~`：当前位于用户主目录；
- `$`：普通用户；
- `#`：超级用户 root。

查看当前用户：

```bash
whoami
```

查看主机名：

```bash
hostname
```

查看当前所在目录：

```bash
pwd
```

输出示例：

```
/home/user
```

这里的 `pwd` 是 `print working directory` 的缩写。

---

## 第三站：Linux 目录结构入门

Linux 使用一棵从 `/` 开始的目录树。

常见目录：

| 目录 | 用途 |
|------|------|
| `/` | 根目录，一切从这里开始 |
| `/home` | 普通用户主目录 |
| `/etc` | 系统配置文件 |
| `/var/log` | 日志文件 |
| `/usr` | 系统程序与库 |
| `/tmp` | 临时文件 |
| `/opt` | 第三方软件 |

Linux 中有两种路径：

### 1. 绝对路径

从根目录 `/` 开始：

```
/home/user/project
```

### 2. 相对路径

以当前目录为基准：

```
./project
../project
```

### 目录切换：cd

进入某个目录：

```bash
cd /var/log
```

返回主目录：

```bash
cd
```

或者：

```bash
cd ~
```

进入上一级目录：

```bash
cd ..
```

返回刚才所在的目录：

```bash
cd -
```

一个非常实用的技巧是使用 **Tab 自动补全**。输入 `cd /var/lo` 然后按下 `Tab`，Shell 会尝试自动补全为 `cd /var/log`。陆遥说："Tab 键是我在终端里按得最多的键。"

---

## 第四站：查看文件与目录——ls

最简单的查看方式：

```bash
ls
```

显示详细信息：

```bash
ls -l
```

显示隐藏文件：

```bash
ls -a
```

以更易读的单位显示文件大小：

```bash
ls -lh
```

按修改时间排序：

```bash
ls -lt
```

按文件大小排序：

```bash
ls -lS
```

递归显示子目录：

```bash
ls -R
```

最常用组合之一：

```bash
ls -lah
```

示例输出：

```
drwxr-xr-x  5 user user 4.0K Jul 23 10:00 .
-rw-r--r--  1 user user 1.2K Jul 23 09:50 README.md
```

第一列包含文件类型和权限：

```
-rw-r--r--
```

第一个字符表示类型：

- `-`：普通文件；
- `d`：目录；
- `l`：符号链接；
- `c`：字符设备；
- `b`：块设备。

---

## 第五站：创建文件和目录

### 创建空文件

```bash
touch hello.txt
```

`touch` 如果文件不存在，会创建空文件；如果文件存在，则更新其时间戳。

一次创建多个文件：

```bash
touch a.txt b.txt c.txt
```

### 创建目录

```bash
mkdir project
```

递归创建多层目录：

```bash
mkdir -p project/src/components
```

### 同时创建多个目录

```bash
mkdir docs scripts tests
```

### 创建带日期的目录

```bash
mkdir "backup-$(date +%F)"
```

可能生成：

```
backup-2026-07-23
```

陆遥第一次看到这个命令时愣了一下，然后意识到：这就是"把重复工作交给 Shell"的雏形。

---

## 第六站：复制、移动、重命名和删除

### 复制文件：cp

```bash
cp source.txt target.txt
```

复制到目录：

```bash
cp source.txt /tmp/
```

递归复制目录：

```bash
cp -r project project-backup
```

保留权限、时间戳和符号链接：

```bash
cp -a project project-backup
```

交互式确认覆盖：

```bash
cp -i source.txt target.txt
```

### 移动和重命名：mv

```bash
mv report.txt /tmp/
mv old.txt new.txt
mv project /opt/
```

### 删除文件：rm

```bash
rm file.txt
rm -r directory
rm -f file.txt
rm -rf directory
```

陆遥在这节课上记住了运维的第一条血泪教训：

> `rm -rf` 不会把文件放进回收站。执行前必须确认路径，尤其不要随意以 root 身份运行。

更安全的写法：

```bash
rm -ri directory
```

删除空目录：

```bash
rmdir empty-directory
```

---

## 第七站：查看文件内容

### cat：一次性输出整个文件

```bash
cat file.txt
```

显示行号：

```bash
cat -n file.txt
```

合并多个文件：

```bash
cat part1.txt part2.txt > all.txt
```

`cat` 适合查看较短文件，不适合直接打开超大日志。

### less：分页查看大文件

```bash
less /var/log/syslog
```

常用操作：`/keyword` 搜索、`n` 下一个结果、`q` 退出、`Ctrl+C` 退出实时跟踪模式。

实时查看不断增长的日志：

```bash
less +F app.log
```

### head：查看文件开头

```bash
head file.txt          # 默认前 10 行
head -n 20 file.txt
```

### tail：查看文件结尾

```bash
tail file.txt
tail -n 100 file.txt
```

实时跟踪日志：

```bash
tail -f app.log
tail -f app.log error.log
```

陆遥说："排查线上问题，`tail -f` 是我用得最多的命令——没有之一。"

---

## 第八站：重定向——让输出流向文件

命令行中最重要的思想之一，是把命令的输出重新定向。

### 覆盖写入

```bash
echo "Hello Linux" > hello.txt
```

如果文件已经存在，原内容会被覆盖。

### 追加写入

```bash
echo "New Line" >> hello.txt
```

### 标准输出与标准错误

Linux 中常见文件描述符：

- `0`：标准输入 stdin；
- `1`：标准输出 stdout；
- `2`：标准错误 stderr。

将标准错误写入文件：

```bash
command 2> error.log
```

将标准输出和标准错误分别保存：

```bash
command > output.log 2> error.log
```

将两者合并：

```bash
command > all.log 2>&1
```

在 Bash 中也可以写成：

```bash
command &> all.log
```

丢弃输出：

```bash
command > /dev/null 2>&1
```

---

## 第九站：管道——把多个命令连接起来

管道符 `|` 会把前一个命令的输出，交给后一个命令作为输入。

例如：

```bash
cat access.log | grep "404"
```

更简洁地写：

```bash
grep "404" access.log
```

统计包含 `404` 的行数：

```bash
grep "404" access.log | wc -l
```

查找占用内存最多的进程：

```bash
ps aux | sort -k4 -nr | head
```

查找当前目录下最大的 10 个文件：

```bash
find . -type f -printf '%s %p\n' | sort -nr | head -n 10
```

管道体现了 Unix 的核心哲学：

> 每个工具只做好一件事，再通过组合完成复杂任务。

陆遥第一次看到 `ps aux | sort -k4 -nr | head` 时感叹："这不就是把一个个小积木拼成流水线吗？"

---

## 第十站：搜索文件——find

按名称查找：

```bash
find /home/user -name "config.json"
```

忽略大小写：

```bash
find . -iname "*.jpg"
```

查找所有普通文件：

```bash
find . -type f
```

查找所有目录：

```bash
find . -type d
```

查找最近 7 天修改的文件：

```bash
find . -type f -mtime -7
```

查找大于 100 MB 的文件：

```bash
find / -type f -size +100M 2>/dev/null
```

查找并删除 `.tmp` 文件：

```bash
find . -type f -name "*.tmp" -delete
```

查找后执行命令：

```bash
find . -type f -name "*.log" -exec gzip {} \;
```

使用空字符分隔，安全处理带空格的文件名：

```bash
find . -type f -print0 | xargs -0 ls -lh
```

---

## 第十一站：搜索文本——grep

在文件中搜索：

```bash
grep "error" app.log
```

忽略大小写：

```bash
grep -i "error" app.log
```

显示行号：

```bash
grep -n "error" app.log
```

递归搜索目录：

```bash
grep -R "TODO" .
```

只显示匹配的文件名：

```bash
grep -Rl "password" /etc
```

反向匹配：

```bash
grep -v "DEBUG" app.log
```

使用扩展正则表达式：

```bash
grep -E "error|warning|fatal" app.log
```

显示匹配前后各 3 行：

```bash
grep -C 3 "Exception" app.log
```

只显示匹配次数：

```bash
grep -c "404" access.log
```

匹配完整单词：

```bash
grep -w "root" /etc/passwd
```

---

## 第十二站：统计与排序——wc、sort、uniq

统计行数：

```bash
wc -l file.txt
```

统计单词数：

```bash
wc -w file.txt
```

排序：

```bash
sort names.txt
```

数字排序：

```bash
sort -n numbers.txt
```

倒序：

```bash
sort -r names.txt
```

按第二列数字排序：

```bash
sort -k2 -n data.txt
```

去除相邻重复行：

```bash
uniq file.txt
```

统计重复次数：

```bash
sort file.txt | uniq -c
```

按出现次数倒序：

```bash
sort file.txt | uniq -c | sort -nr
```

统计日志中访问最多的 IP——陆遥第一次写出这条"三连管道"时激动了半天：

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head
```

---

## 第十三站：文本切割与替换——cut、tr、sed、awk

### cut：按列提取

提取 `/etc/passwd` 的用户名：

```bash
cut -d: -f1 /etc/passwd
```

其中：`-d:` 指定分隔符为冒号，`-f1` 取第 1 列。

提取第 1、3、7 列：

```bash
cut -d: -f1,3,7 /etc/passwd
```

### tr：字符转换

转为大写：

```bash
echo "linux" | tr 'a-z' 'A-Z'
```

删除数字：

```bash
echo "abc123" | tr -d '0-9'
```

把连续空格压缩为一个：

```bash
tr -s ' ' < file.txt
```

### sed：流式文本编辑

把每行中的 `foo` 替换为 `bar`：

```bash
sed 's/foo/bar/g' file.txt
```

直接修改文件：

```bash
sed -i 's/foo/bar/g' file.txt
```

macOS 的 BSD sed 通常需要：

```bash
sed -i '' 's/foo/bar/g' file.txt
```

删除空行：

```bash
sed '/^$/d' file.txt
```

显示第 10 到 20 行：

```bash
sed -n '10,20p' file.txt
```

删除以 `#` 开头的注释：

```bash
sed '/^#/d' config.ini
```

同时删除注释和空行：

```bash
sed '/^#/d;/^$/d' config.ini
```

### awk：按字段处理结构化文本

打印第一列：

```bash
awk '{print $1}' file.txt
```

指定冒号为分隔符：

```bash
awk -F: '{print $1, $7}' /etc/passwd
```

筛选第三列大于 1000 的记录：

```bash
awk -F: '$3 > 1000 {print $1, $3}' /etc/passwd
```

统计第二列总和：

```bash
awk '{sum += $2} END {print sum}' data.txt
```

计算平均值：

```bash
awk '{sum += $2; count++} END {print sum/count}' data.txt
```

给输出添加标题：

```bash
awk 'BEGIN {print "NAME SCORE"} {print $1, $2}' data.txt
```

---

## 第十四站：通配符与引号

Shell 会在命令执行前展开通配符。

### 常见通配符

```bash
ls *.txt
```

```bash
rm image?.png
```

```bash
touch file{1,2,3}.txt
```

展开结果：

```
file1.txt file2.txt file3.txt
```

创建多个年份目录：

```bash
mkdir -p backup/{2024,2025,2026}/{01..12}
```

### 单引号和双引号

单引号不会展开变量：

```bash
echo '$HOME'
```

输出：

```
$HOME
```

双引号会展开变量：

```bash
echo "$HOME"
```

输出可能是：

```
/home/user
```

变量包含空格时，通常应该加双引号：

```bash
rm "$filename"
```

---

## 第十五站：变量与环境变量

定义变量：

```bash
name="Linux"
```

读取变量：

```bash
echo "$name"
```

注意：等号两边不能有空格。

错误写法：

```bash
name = "Linux"
```

查看所有环境变量：

```bash
env
```

查看 PATH：

```bash
echo "$PATH"
```

临时设置环境变量：

```bash
export APP_ENV=production
```

永久配置通常写入：

```
~/.bashrc
~/.bash_profile
~/.zshrc
```

修改后重新加载：

```bash
source ~/.bashrc
```

或者：

```bash
source ~/.zshrc
```

### 命令替换与算术运算

把命令输出保存到变量：

```bash
today=$(date +%F)
```

创建带时间戳的备份——陆遥后来写备份脚本的起点：

```bash
cp config.yml "config.yml.$(date +%Y%m%d%H%M%S).bak"
```

整数运算：

```bash
result=$((10 + 20))
echo "$result"
```

自增：

```bash
count=1
count=$((count + 1))
```

更简洁地写：

```bash
((count++))
```

---

## 第十六站：权限系统——r、w、x

使用 `ls -l` 查看权限：

```bash
ls -l script.sh
```

可能显示：

```
-rwxr-xr--
```

从左到右分为：文件类型、所有者权限、所属组权限、其他用户权限。

三种权限：`r`（读）、`w`（写）、`x`（执行）。

### chmod：修改权限

给所有者增加执行权限：

```bash
chmod u+x script.sh
```

移除其他用户写权限：

```bash
chmod o-w file.txt
```

给用户和组增加读写权限：

```bash
chmod ug+rw file.txt
```

数字方式：

```bash
chmod 755 script.sh
```

`755` 表示：

- 所有者：`7 = 4 + 2 + 1 = rwx`
- 所属组：`5 = 4 + 1 = r-x`
- 其他用户：`5 = 4 + 1 = r-x`

### chown：修改所有者

```bash
sudo chown user file.txt
sudo chown user:group file.txt
sudo chown -R user:group project
```

### chgrp：修改所属组

```bash
sudo chgrp developers project
```

---

## 第十七站：sudo 与 root

以管理员权限执行命令：

```bash
sudo command
```

例如安装软件：

```bash
sudo apt install nginx
```

切换到 root Shell：

```bash
sudo -i
```

退出：

```bash
exit
```

查看自己可以执行哪些 sudo 命令：

```bash
sudo -l
```

陆遥把老板的话记在了工位上：

> 不要长期使用 root 账户进行日常操作。管理员权限越高，误操作造成的破坏越大。

---

## 第十八站：用户和用户组管理

查看当前用户身份和组：

```bash
id
```

查看当前登录用户：

```bash
who
```

创建用户：

```bash
sudo useradd -m alice
```

在 Debian、Ubuntu 中也常用：

```bash
sudo adduser alice
```

设置密码：

```bash
sudo passwd alice
```

创建用户组：

```bash
sudo groupadd developers
```

把用户加入组：

```bash
sudo usermod -aG developers alice
```

查看用户所属组：

```bash
groups alice
```

删除用户：

```bash
sudo userdel alice
sudo userdel -r alice   # 同时删除主目录
```

---

## 第十九站：进程管理

### ps：查看进程

```bash
ps
ps aux
```

查找 Nginx 进程：

```bash
ps aux | grep nginx
```

更推荐：

```bash
pgrep -a nginx
```

查看进程树：

```bash
ps -ef --forest
```

或者：

```bash
pstree
```

### top 与 htop

实时查看系统进程：

```bash
top
```

常用按键：`q` 退出、`k` 结束进程、`M` 按内存排序、`P` 按 CPU 排序。

`htop` 是交互体验更好的工具：

```bash
htop
```

如果未安装：

```bash
sudo apt install htop
```

### kill：结束进程

先查找进程号：

```bash
pgrep -a nginx
```

发送默认的 `SIGTERM`：

```bash
kill 1234
```

强制结束：

```bash
kill -9 1234
```

按进程名结束：

```bash
pkill nginx
```

更温和地重新加载配置：

```bash
kill -HUP 1234
```

常见信号：`SIGTERM`（15，温和终止）、`SIGKILL`（9，强制）、`SIGHUP`（1，重载配置）。

> 优先使用 `SIGTERM`，只有进程无法正常结束时才使用 `SIGKILL`。

---

## 第二十站：前台、后台与任务控制

后台运行：

```bash
sleep 300 &
```

查看当前 Shell 的后台任务：

```bash
jobs
```

把任务切回前台：

```bash
fg %1
```

让暂停的任务在后台继续：

```bash
bg %1
```

暂停前台任务：`Ctrl+Z`；结束前台任务：`Ctrl+C`。

让命令在退出终端后继续运行：

```bash
nohup python app.py > app.log 2>&1 &
```

查看后台进程：

```bash
ps aux | grep app.py
```

> 对于长期服务，更推荐使用 `systemd`、Supervisor、Docker 或其他进程管理工具。

---

## 第二十一站：systemd 服务管理

现代 Linux 发行版通常使用 `systemd` 管理服务。

查看服务状态：

```bash
systemctl status nginx
```

启动服务：

```bash
sudo systemctl start nginx
```

停止服务：

```bash
sudo systemctl stop nginx
```

重启服务：

```bash
sudo systemctl restart nginx
```

重新加载配置：

```bash
sudo systemctl reload nginx
```

设置开机启动：

```bash
sudo systemctl enable nginx
```

立即启动并设置开机启动：

```bash
sudo systemctl enable --now nginx
```

取消开机启动：

```bash
sudo systemctl disable nginx
```

查看失败的服务：

```bash
systemctl --failed
```

查看服务日志：

```bash
journalctl -u nginx
```

实时查看：

```bash
journalctl -u nginx -f
```

查看最近 100 行：

```bash
journalctl -u nginx -n 100
```

查看本次启动日志：

```bash
journalctl -b
```

查看上一次启动日志：

```bash
journalctl -b -1
```

陆遥说："systemd 是我从'会重启'到'会管理服务'的分水岭——`enable`、`reload`、`journalctl` 这三个命令，让凌晨的电话少了一半。"

---

## 第二十二站：磁盘与文件系统

查看磁盘使用情况：

```bash
df -h
```

查看 inode：

```bash
df -i
```

查看目录大小：

```bash
du -sh project
```

查看当前目录下每个子目录大小：

```bash
du -h --max-depth=1
```

按大小排序：

```bash
du -h --max-depth=1 | sort -h
```

查看块设备：

```bash
lsblk
```

查看分区：

```bash
sudo fdisk -l
```

查看文件系统类型：

```bash
df -Th
```

挂载设备：

```bash
sudo mount /dev/sdb1 /mnt/data
```

卸载：

```bash
sudo umount /mnt/data
```

查找占用空间最大的目录：

```bash
sudo du -xhd1 / | sort -h
```

查找大文件：

```bash
sudo find / -xdev -type f -size +1G -print 2>/dev/null
```

陆遥在"磁盘满"事故后养成的第一个习惯：每周看一眼 `df -h` 和 `df -i`。

---

## 第二十三站：压缩与归档

### tar：归档多个文件

创建 tar 包：

```bash
tar -cf archive.tar project/
```

查看内容：

```bash
tar -tf archive.tar
```

解包：

```bash
tar -xf archive.tar
```

创建 gzip 压缩包：

```bash
tar -czf project.tar.gz project/
```

解压：

```bash
tar -xzf project.tar.gz
```

创建 xz 压缩包：

```bash
tar -cJf project.tar.xz project/
```

解压到指定目录：

```bash
tar -xzf project.tar.gz -C /opt/project
```

### zip 与 unzip

```bash
zip -r project.zip project/
unzip project.zip
unzip -l project.zip
```

---

## 第二十四站：软件包管理

不同 Linux 发行版使用不同的软件包管理器。

### Debian、Ubuntu：apt

```bash
sudo apt update              # 更新软件索引
sudo apt upgrade             # 升级软件
sudo apt install curl        # 安装软件
sudo apt remove curl         # 卸载软件
sudo apt purge curl          # 同时删除配置
apt search nginx             # 搜索软件
apt show nginx               # 查看软件信息
sudo apt autoremove          # 清理无用依赖
```

### RHEL、Rocky Linux、AlmaLinux、Fedora：dnf

```bash
sudo dnf install nginx
sudo dnf remove nginx
sudo dnf update
dnf search nginx
```

### Arch Linux：pacman

```bash
sudo pacman -Syu
sudo pacman -S nginx
sudo pacman -R nginx
```

---

## 第二十五站：网络基础命令

查看 IP 地址：

```bash
ip addr
```

简写：

```bash
ip a
```

查看路由：

```bash
ip route
```

测试网络连通性：

```bash
ping -c 4 8.8.8.8
```

测试域名解析：

```bash
ping -c 4 example.com
```

查看 DNS 解析：

```bash
dig example.com
dig +short example.com
nslookup example.com
```

查看监听端口：

```bash
ss -tuln
```

查看监听端口和进程：

```bash
sudo ss -tulnp
```

查看 TCP 连接：

```bash
ss -tan
```

查看某个端口：

```bash
sudo ss -ltnp | grep ':80'
```

查看访问路径：

```bash
traceroute example.com
```

部分系统使用：

```bash
tracepath example.com
```

---

## 第二十六站：curl 与 wget

### curl：发送 HTTP 请求

获取网页：

```bash
curl https://example.com
```

显示响应头：

```bash
curl -I https://example.com
```

跟随重定向：

```bash
curl -L https://example.com
```

保存到文件：

```bash
curl -o page.html https://example.com
```

使用服务器文件名：

```bash
curl -O https://example.com/file.zip
```

发送 POST JSON：

```bash
curl -X POST https://api.example.com/users \
  -H "Content-Type: application/json" \
  -d '{"name":"Alice"}'
```

带认证头：

```bash
curl https://api.example.com/me \
  -H "Authorization: Bearer TOKEN"
```

查看详细连接过程：

```bash
curl -v https://example.com
```

只输出状态码：

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://example.com
```

### wget：下载文件

```bash
wget https://example.com/file.zip
wget -c https://example.com/file.zip   # 断点续传
wget -O package.zip https://example.com/download
```

---

## 第二十七站：SSH 远程连接

连接远程服务器：

```bash
ssh user@server.example.com
```

指定端口：

```bash
ssh -p 2222 user@server.example.com
```

执行远程命令：

```bash
ssh user@server 'uptime'
```

生成 SSH 密钥：

```bash
ssh-keygen -t ed25519
```

把公钥复制到服务器：

```bash
ssh-copy-id user@server
```

之后通常可以免密码登录：

```bash
ssh user@server
```

SSH 配置文件 `~/.ssh/config`：

```
Host myserver
    HostName 203.0.113.10
    User ubuntu
    Port 22
    IdentityFile ~/.ssh/id_ed25519
```

之后可直接连接：

```bash
ssh myserver
```

私钥权限必须足够严格：

```bash
chmod 600 ~/.ssh/id_ed25519
```

---

## 第二十八站：远程复制——scp 与 rsync

### scp

上传文件：

```bash
scp file.txt user@server:/tmp/
```

下载文件：

```bash
scp user@server:/var/log/app.log .
```

递归复制目录：

```bash
scp -r project user@server:/opt/
```

指定 SSH 端口：

```bash
scp -P 2222 file.txt user@server:/tmp/
```

注意：`scp` 指定端口使用大写 `-P`。

### rsync

同步目录：

```bash
rsync -av project/ backup/
```

同步到远程服务器：

```bash
rsync -avz project/ user@server:/opt/project/
```

显示进度：

```bash
rsync -avz --progress project/ user@server:/opt/project/
```

删除目标端多余文件，使两端完全一致：

```bash
rsync -av --delete source/ target/
```

排除文件：

```bash
rsync -av --exclude='.git' --exclude='node_modules' project/ backup/
```

注意目录后面的 `/`：

```bash
rsync -av source/ target/    # 同步 source 目录中的内容
rsync -av source target/     # 把整个 source 目录复制到 target 中
```

陆遥说："`rsync -avz --delete` 是我部署代码的标配——先 `--dry-run` 预演一遍，确认无误再真跑。"

---

## 第二十九站：Shell 脚本入门——把重复工作写成脚本

命令学得越多，陆遥越觉得"手敲"不够用。他开始学 Shell 脚本。

创建脚本：

```bash
vim hello.sh
```

内容：

```bash
#!/usr/bin/env bash
echo "Hello, Linux!"
```

增加执行权限：

```bash
chmod +x hello.sh
```

运行：

```bash
./hello.sh
```

也可以：

```bash
bash hello.sh
```

第一行称为 Shebang：

```bash
#!/usr/bin/env bash
```

它告诉系统使用 Bash 解释该脚本。

### 条件判断

基本结构：

```bash
if 条件; then
    命令
fi
```

示例：

```bash
#!/usr/bin/env bash
if [[ -f "/etc/passwd" ]]; then
    echo "文件存在"
else
    echo "文件不存在"
fi
```

字符串判断：

```bash
if [[ "$name" == "Linux" ]]; then
    echo "matched"
fi
```

数字比较：

```bash
if (( count > 10 )); then
    echo "count is greater than 10"
fi
```

### 循环

for 循环：

```bash
for file in *.log; do
    echo "$file"
done
```

数字循环：

```bash
for i in {1..5}; do
    echo "$i"
done
```

while 循环：

```bash
count=1
while (( count <= 5 )); do
    echo "$count"
    ((count++))
done
```

逐行读取文件：

```bash
while IFS= read -r line; do
    echo "$line"
done < file.txt
```

### 函数与参数

```bash
greet() {
    echo "Hello, $1"
}

greet Linux
```

常见脚本参数：`$0` 脚本名、`$#` 参数数量、`$@` 所有参数。

```bash
#!/usr/bin/env bash
echo "脚本名：$0"
echo "参数数量：$#"
for arg in "$@"; do
    echo "参数：$arg"
done
```

### 退出状态与命令组合

Linux 命令执行后会返回退出状态：`0` 成功，非 `0` 失败。

查看上一条命令状态：

```bash
echo $?
```

只有前一个命令成功，才执行后一个：

```bash
mkdir backup && cp file.txt backup/
```

只有前一个命令失败，才执行后一个：

```bash
ping -c 1 server || echo "服务器不可达"
```

无论成功失败都继续：

```bash
command1 ; command2
```

脚本中建议启用更严格的错误处理：

```bash
set -Eeuo pipefail
```

含义：

- `-e`：命令失败时退出；
- `-u`：使用未定义变量时报错；
- `-o pipefail`：管道中任一命令失败，整体视为失败；
- `-E`：让错误陷阱在函数中继续生效。

---

## 第三十站：一个实用备份脚本

学了脚本之后，陆遥做的第一件事，就是把"凌晨磁盘满"的噩梦写成一个脚本。

```bash
#!/usr/bin/env bash
set -Eeuo pipefail

SOURCE_DIR="${1:-/etc}"
BACKUP_DIR="${2:-$HOME/backups}"
TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
ARCHIVE_NAME="backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"

if [[ ! -d "$SOURCE_DIR" ]]; then
    echo "错误：源目录不存在：$SOURCE_DIR" >&2
    exit 1
fi

mkdir -p "$BACKUP_DIR"
echo "正在备份：$SOURCE_DIR"
tar -czf "$ARCHIVE_PATH" "$SOURCE_DIR"
echo "备份完成：$ARCHIVE_PATH"
```

运行：

```bash
chmod +x backup.sh
./backup.sh /var/www "$HOME/backups"
```

这个脚本涉及：参数默认值、变量引用、目录判断、错误输出、自动创建目录、时间戳、tar 压缩、严格错误处理。

陆遥看着它跑完，第一次觉得"运维"这两个字有了实感：**不是会敲命令，而是把会敲的命令变成可靠的系统。**

---

## 第三十一站：计划任务——cron

备份脚本写好了，但总不能每天手动跑。cron 登场。

编辑当前用户的定时任务：

```bash
crontab -e
```

查看：

```bash
crontab -l
```

Cron 格式：

```
分 时 日 月 星期 命令
```

示例：每天凌晨 2 点执行备份：

```
0 2 * * * /home/user/backup.sh >> /home/user/backup.log 2>&1
```

每 5 分钟执行：

```
*/5 * * * * /home/user/check.sh
```

每周一上午 9 点：

```
0 9 * * 1 /home/user/report.sh
```

Cron 环境通常比交互式 Shell 更简单，因此脚本中最好：

- 使用绝对路径；
- 显式设置 PATH；
- 把输出写入日志；
- 测试脚本是否有执行权限。

示例：

```
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
0 2 * * * /home/user/backup.sh >> /home/user/backup.log 2>&1
```

---

## 第三十二站：日志排查实战

学会这些工具之后，陆遥终于有能力面对真正的生产事故。假设一个 Web 服务出现大量 500 错误——这是陆遥第一次独立排查的完整流程。

### 第一步：确认服务是否运行

```bash
systemctl status nginx
systemctl status myapp
```

### 第二步：查看服务日志

```bash
journalctl -u myapp -n 200
```

实时观察：

```bash
journalctl -u myapp -f
```

### 第三步：查看端口

```bash
sudo ss -ltnp
sudo ss -ltnp | grep ':8000'
```

### 第四步：本机请求测试

```bash
curl -v http://127.0.0.1:8000/health
```

### 第五步：统计错误日志

```bash
grep " 500 " access.log | wc -l
```

查看最近的错误：

```bash
grep "ERROR" app.log | tail -n 50
```

按错误类型统计：

```bash
grep "ERROR" app.log \
  | sed -E 's/.*ERROR[ :]//' \
  | sort \
  | uniq -c \
  | sort -nr \
  | head
```

### 第六步：查看系统资源

```bash
top
free -h
df -h
df -i
uptime
```

很多"应用故障"，最终可能只是：

- 磁盘满了；
- inode 用完了；
- 内存不足；
- 端口被占用；
- 权限错误；
- DNS 失败；
- 配置文件写错；
- 上游服务不可达。

陆遥说："排查的第一步永远是看现象、看日志、看资源——而不是凭感觉改配置。"

---

## 第三十三站：资源与端口排查

### CPU、内存和系统负载

查看运行时间和负载：

```bash
uptime
```

查看内存：

```bash
free -h
```

持续刷新：

```bash
watch -n 1 free -h
```

查看 CPU 信息：

```bash
lscpu
```

查看内核信息：

```bash
uname -a
```

查看发行版：

```bash
cat /etc/os-release
```

查看内核日志末尾：

```bash
dmesg | tail
```

按内存占用排序：

```bash
ps aux --sort=-%mem | head
```

按 CPU 占用排序：

```bash
ps aux --sort=-%cpu | head
```

Linux Load Average 常显示三个数字：

```
0.32 0.45 0.50
```

分别代表过去 1 分钟、5 分钟、15 分钟的平均负载。负载是否过高，需要结合 CPU 核心数判断。

### 端口占用排查

```bash
sudo ss -ltnp | grep ':8080'
sudo lsof -i :8080
lsof -p 1234            # 查看某进程打开的文件
kill 1234
sudo fuser -k 8080/tcp  # 结束占用端口的进程
sudo lsof -i            # 查看所有网络连接
```

### 文件被谁占用

当删除日志后磁盘空间没有释放，可能是进程仍持有已删除文件：

```bash
sudo lsof +L1
sudo lsof +D /var/log
sudo fuser -vm /mnt/data
```

如果无法卸载磁盘，提示 busy 时，可以先检查：

```bash
sudo lsof /mnt/data
sudo fuser -vm /mnt/data
```

---

## 第三十四站：软链接、硬链接与 inode

### 软链接

创建软链接：

```bash
ln -s /opt/app/current app
```

查看链接目标：

```bash
readlink app
readlink -f app
```

### 硬链接

创建硬链接：

```bash
ln source.txt hardlink.txt
```

软链接特点：可以跨文件系统、可以链接目录、原文件删除后链接失效。

硬链接特点：与原文件共享 inode、通常不能跨文件系统、通常不能链接目录、删除原文件后内容仍可通过硬链接访问。

### 理解 inode

Linux 文件名并不是文件本身，而是目录项到 inode 的映射。

查看 inode：

```bash
ls -li file.txt
```

查看文件详细信息：

```bash
stat file.txt
```

如果磁盘明明还有空间，却提示 `No space left on device`，可能是 **inode 用完了**：

```bash
df -i
```

大量小文件会快速消耗 inode。查找小文件密集目录：

```bash
for dir in /*; do
    printf "%8s %s\n" "$(find "$dir" -xdev 2>/dev/null | wc -l)" "$dir"
done | sort -nr | head
```

---

## 第三十五站：安全使用命令行的 10 条原则

陆遥把三个月踩过的坑，沉淀成了一份"保命清单"：

1. 执行删除命令前先用 `ls` 或 `find` 验证目标。
2. 使用变量表示路径时尽量加双引号。
3. 不熟悉的命令先看 `--help` 或 `man`。
4. 脚本中启用 `set -Eeuo pipefail`。
5. 不要复制来源不明的 `curl ... | bash` 命令。
6. 不要长期以 root 身份工作。
7. 修改配置文件前先备份。
8. 批量操作前先用 `echo` 模拟。
9. 对重要目录使用 `rsync --dry-run` 预演。
10. 日志和错误输出不要直接丢弃，至少在排查阶段保留。

例如，在真正删除前先预览：

```bash
find . -type f -name "*.tmp" -print
```

确认无误后再执行：

```bash
find . -type f -name "*.tmp" -delete
```

使用 rsync 预演：

```bash
rsync -av --delete --dry-run source/ target/
```

---

## 结语：真正的精通来自组合，而不是背诵

故事讲完了。

一个月后，陆遥没有再在凌晨接到老板的电话。他给服务器配好了磁盘监控、写好了自动备份脚本、用 systemd 管理了所有服务、把部署流程固化成了 rsync 命令——他甚至给团队写了第一份排障手册。

学习 Linux 命令行，不必一次背下几百条命令。更有效的方法是：

1. 先掌握最常用的 20 条命令；
2. 理解路径、权限、进程和数据流；
3. 学会使用管道组合工具；
4. 遇到问题主动查看帮助；
5. 把重复操作写成脚本；
6. 在真实项目中持续使用。

初学者看到的是一个个孤立的命令：

```
grep sort uniq head
```

熟练者看到的是一条完整的数据处理流水线：

```
awk '{print $1}' access.log \
  | sort \
  | uniq -c \
  | sort -nr \
  | head
```

这就是 Linux 命令行真正强大的地方。

它不是要求你记住所有答案，而是给你一套可以不断组合、不断扩展的问题解决工具。

当你开始习惯用命令行查日志、找文件、管理服务、连接服务器和编写自动化脚本时，你会发现：那块曾经令人紧张的黑色窗口，已经变成了最直接、最高效的工作台。

> 命令行能力没有捷径，最好的学习方式就是：边用、边查、边组合。