# [Git 从入门到精通：一篇文章彻底搞懂版本控制](https://mp.weixin.qq.com/s/bj3WOSaIQy-nn5jFBlqkoA)

> 这是一个关于"拾光"的故事——一个由三个人维护的连载小说平台。新入职的小满第一天就发现，这个让上万读者追更的平台，版本管理还停留在"最终版"文件夹时代。你会跟着小满一起，从"我只会 `git add .`"走到真正理解分支、合并、回滚与协作。读完之后你会发现：Git 的命令确实不少，但它并不混乱——只要建立正确的心智模型，大多数操作都可以从几个核心概念自然推导出来。

---

## 故事的起点：入职第一天，版本失控

小满入职"拾光工作室"的第一天，就撞上了一出闹剧。

拾光是一个连载小说平台：作者在上面连载，读者追更打赏。平台不大，代码由两个人维护——师傅老周负责后端，同事阿澈负责前端。而小满，是刚毕业、第一次接触真实团队代码的新人。

上午十点，阿澈一声惨叫："谁把我的登录页改了？！"

小满凑过去一看，阿澈的电脑屏幕上，躺着这样一串文件夹：

```
shiguang/
shiguang-最终版/
shiguang-最终版2/
shiguang-真的最终版/
shiguang-真的最终版-修复版/
shiguang-真的最终版-修复版2-阿澈改/
```

老周尴尬地挠头："我刚才在服务器上改了两行配置……" 阿澈更崩溃："我昨天写了一天的新用户引导页，全没了。"

小满看着这场面，想起自己实习时的经历——那时候改代码全靠 Ctrl+Z，版本全靠"另存为"。他列了列大家遇到的问题：

- 改了半天代码，突然发现方向错了，却不知道怎么恢复；
- 一看到 `CONFLICT` 就紧张，生怕把同事的代码覆盖掉；
- 每天都在执行 `git add . && git commit && git push`，但说不清暂存区到底是什么；
- 分支越建越多，`merge`、`rebase`、`reset`、`revert` 傻傻分不清；
- 明明"删掉了"敏感文件，却发现它仍然藏在 Git 历史里。

这些问题指向同一个根源：**他们没有一套能记录每一次修改、并让多人安全协作的系统。**

而解决它的工具，叫 Git。

老周拍板："下周一上线前，我们必须把版本管理理顺。小满，你刚从学校出来，正好系统学一遍，回来教我们。"

小满深吸一口气："好，我学。从'最终版文件夹'到真正的版本控制，我陪大家走一遍。"

这个故事，就是他从头到尾走完的路线图。

---

## 第一站：先建立最重要的心智模型——代码在四个区域间流动

小满没有一上来就背命令。他先问了自己一个问题：**Git 到底在干什么？**

假设你正在写一个项目，每次完成重要修改，就复制一份文件夹——这就是那串"最终版"的来源。这种方式看似简单，却有三个致命问题：

1. 不知道每个版本具体改了什么；
2. 多人同时修改时很难合并；
3. 一旦误删或覆盖，恢复成本很高。

Git 本质上是一套**分布式版本控制系统**。它可以记录每次修改，让你随时查看历史、恢复版本、创建分支，并与团队成员协作。

"分布式"意味着：每个开发者本地都拥有一份相对完整的仓库历史。即使暂时没有网络，你仍然可以提交、创建分支、查看历史和回退版本。

> Git 不是简单的"文件备份工具"，而是一套管理项目演进过程的系统。

### 代码流动的四个区域

学习 Git，最关键的不是背命令，而是理解代码会在几个区域之间流动：

```
工作区  →  暂存区  →  本地仓库  →  远程仓库
          git add    git commit    git push
```

**工作区（Working Tree）**：你能直接看到和编辑的项目文件。例如，你修改了 `app.js`，但还没有执行任何 Git 命令，这个修改只存在于工作区。

**暂存区（Staging Area / Index）**：保存的是**你准备放进下一次提交的内容**。执行 `git add app.js` 并不是把代码上传到远程仓库，而是把 `app.js` 当前的修改加入暂存区。暂存区的价值在于：你可以从一堆修改中，只挑选一部分组成一次提交。

**本地仓库（Local Repository）**：执行 `git commit -m "feat: add login validation"`，Git 会把暂存区中的内容保存为一个新的提交，也就是一个可追踪、可恢复的历史节点。注意：`commit` 只发生在本地，并不会自动上传到 GitHub、GitLab 或 Gitee。

**远程仓库（Remote Repository）**：执行 `git push`，才会把本地提交同步到远程仓库。

小满把这四件事抄在了工位上：

```
保存文件 ≠ git add ≠ git commit ≠ git push
```

"只要记住这一点，很多 Git 问题都会瞬间清晰。"他说。

---

## 第二站：安装与初始化——把"我是谁"告诉 Git

心智模型有了，小满开始动手。工作室三台机器，配置各不相同：老周的 Ubuntu 服务器、阿澈的 Windows 笔记本，加上小满自己的 Mac。他把三种环境的安装方式都过了一遍。

### Linux 上的安装

最简单的方式是用 apt：

```bash
apt install git
```

可选安装一些辅助工具：

| 包名 | 作用 |
|------|------|
| `git` | Git 核心命令（必装） |
| `git-doc` | 文档手册 |
| `git-svn` | 与 SVN 仓库交互 |
| `git-email` | 用邮件发送补丁 |
| `gitk` | 图形化历史查看工具 |

如果追求最新版本，也可以从源码编译，但要先装好编译依赖：

```bash
apt update
apt install build-essential libssl-dev libcurl4-openssl-dev libexpat1-dev gettext zlib1g-dev

wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.43.0.tar.gz
tar -zxvf git-2.43.0.tar.gz
cd git-2.43.0
make prefix=/usr/local all
make prefix=/usr/local install
```

小满还顺手配了命令补齐——以后敲 `git che<Tab>` 就能自动补全成 `git checkout`：

```bash
apt install bash-completion
cp contrib/completion/git-completion.bash /etc/bash_completion.d/
```

### Windows 与 Mac 上的安装

阿澈这边更简单：去 https://git-scm.com/download/win 下载官方安装包，安装时记得勾选 **Git Bash Here**（右键菜单启动终端）；PATH 配置推荐选 **Use Git Bash only**，只在 Git Bash 里用，不污染系统 PATH。如果喜欢图形界面，可以再装一个 TortoiseGit，集成到资源管理器里，文件图标直接显示版本状态。小满的 Mac 则直接 `brew install git` 搞定。

装完后验证：

```bash
git --version
```

### 必做配置：告诉 Git"我是谁"

Git 配置分三层，就像公司的规章制度：

- **系统配置（system）**：公司全员都要遵守（所有用户）；
- **用户配置（global）**：你所在部门的规定（当前用户）；
- **仓库配置（local）**：你所在小组的特殊规定（当前项目）。

优先级：**仓库 > 用户 > 系统**（越下层越优先）。仓库级配置会覆盖全局配置——比如在拾光项目里用工作室邮箱：

```bash
git config --global user.name "Your Name"
git config --global user.email "you@example.com"

# 在某个仓库里覆盖
git config user.email "name@company.com"
```

老周特别叮嘱："名字和邮箱一旦确定就不要改——它用于责任追踪和贡献度统计。"他还建议把默认主分支设置为 `main`：

```bash
git config --global init.defaultBranch main
```

查看当前配置：

```bash
git config --list
git config --list --show-origin   # 看配置来自哪个文件
```

### 两个跨平台的坑：换行符与中文

**换行符**：Windows 用 CRLF（`\r\n`），Linux/Mac 用 LF（`\n`）。跨平台协作时，这会引起大量"看似没改却显示全变了"的假 diff。

```bash
# Windows 用户
git config --global core.autocrlf true   # 提交时 CRLF→LF，检出时 LF→CRLF

# Linux/Mac 用户
git config --global core.autocrlf input  # 提交时 CRLF→LF，检出时不转换
```

**中文显示**：确保中文路径和提交信息不乱码：

```bash
git config --global gui.encoding utf-8
git config --global i18n.commitencoding utf-8
git config --global i18n.logoutputencoding utf-8
git config --global core.quotepath false  # 显示路径中的中文
```

### 与代码平台的认证：SSH 免密登录

阿澈每天 push 都要输密码，烦死了。小满教他配 SSH 免密：

```bash
# Step 1：生成密钥对（各系统通用）
ssh-keygen -t rsa -C "you@example.com"
# 保存路径直接回车（默认 ~/.ssh/id_rsa），密码直接回车（免密登录）

# Step 2：查看公钥
cat ~/.ssh/id_rsa.pub
```

把公钥内容粘贴到代码平台的 SSH Keys 设置里：

| 平台 | 路径 |
|------|------|
| GitHub | Settings → SSH and GPG keys → New SSH key |
| GitLab | Profile Settings → SSH Keys → Add SSH key |
| Gitee | 设置 → SSH 公钥 → 添加公钥 |

验证连接：

```bash
ssh -T git@github.com
# 看到 "Hi xxx! You've successfully authenticated" 即成功
```

至此，工具装好了，身份也确认了。小满准备把"拾光"变成第一个 Git 仓库。

---

## 第三站：创建第一个仓库——完整跑通"暂存→提交"链路

小满新建了一个目录，把拾光的代码放进去，然后初始化仓库：

```bash
mkdir git-demo
cd git-demo
git init
```

执行后，目录里多了一个隐藏的 `.git` 文件夹——**这里保存了提交对象、分支引用、配置和日志等核心数据**，整个 Git 仓库的"灵魂"都在里面。

他创建了一个 README，然后开始走那条最基础的链路：

```bash
echo "# Git Demo" > README.md

git status          # 查看状态：README.md 是未跟踪文件
git add README.md   # 加入暂存区
git commit -m "docs: add project README"   # 创建第一次提交
```

看历史：

```bash
git log                          # 完整历史
git log --oneline                # 一行一条，简洁
git log --oneline --graph --decorate --all   # 图形化，适合观察分支结构
```

到这里，小满已经完成了最基础的一条链路：

```
创建文件 → 加入暂存区 → 创建提交
```

他感慨："其实 Git 的日常操作，90% 都在重复这条链路。难点不在于命令，而在于搞清楚**每一步到底改变了什么**。"

---

## 第四站：每天都会用到的核心命令

### 1. 查看当前状态：`git status`

小满说，这是排查 Git 问题时**最值得先执行的命令**。它会告诉你：

- 当前位于哪个分支；
- 哪些文件被修改；
- 哪些文件已暂存；
- 哪些文件尚未被跟踪；
- 当前分支是否领先或落后于远程分支。

```bash
git status
git status -s    # 简化输出，只看文件状态
```

输出里的符号含义：

| 符号 | 含义 | 说明 |
|------|------|------|
| `A`（绿） | 新增 | 新文件，已添加到暂存区 |
| `M`（绿） | 修改 | 文件已修改并暂存 |
| `M`（红） | 修改 | 文件已修改但未暂存 |
| `D` | 删除 | 文件已删除 |
| `??` | 未跟踪 | 新文件，Git 还没管理 |

### 2. 查看差异：`git diff`

小满最爱的排查三连：

```bash
git diff                      # 工作区 vs 暂存区（未暂存的修改）
git diff --staged             # 暂存区 vs 最近一次提交（已暂存的修改）
git diff <commit-a> <commit-b>  # 两个提交之间的差异
git diff --name-status        # 只看文件名和变更状态
```

### 3. 精确暂存：`git add`

```bash
git add src/app.js    # 暂存单个文件
git add .             # 暂存当前目录所有变化（含删除）
git add *.py          # 暂存所有 .py 文件
git add -p            # 交互式选择部分修改
```

小满特别强调 `git add -p`："这是从'会用 Git'走向'用好 Git'的关键命令。它允许你逐块选择修改，避免把调试代码、格式化变更和业务逻辑混在同一个提交里。"

> ⚠️ 注意：`git add .` 会暂存**所有**变更，包括删除的文件。

### 4. 创建提交：`git commit`

```bash
git commit -m "fix: handle empty username"
git commit                # 打开编辑器写更完整的提交说明
git commit -am "快速提交"  # 已跟踪文件的修改直接提交（跳过 git add）
git commit --amend        # 修改最后一次提交
```

一个好的提交应该满足两个标准：

- **只做一件相对完整的事情**；
- **提交信息能说明"为什么改"**，而不只是"改了什么"。

```bash
不推荐：update code
不推荐：fix bug
推荐：fix: prevent duplicate order submission
推荐：feat: support passwordless login
推荐：refactor: extract payment validation service
```

小满说："把'新增功能、格式化全项目、升级依赖、修复无关 Bug'塞进同一次提交，是新手最常见的坏习惯。提交越纯粹，将来 `git log` 查历史、`git bisect` 找 Bug 就越轻松。"

### 5. 删除与移动文件

```bash
git rm 文件名.py          # 从暂存区和工作区同时删除
git rm --cached 文件名.py  # 只从暂存区删除（保留工作区文件）
git rm -r 目录名/          # 删除目录
git mv 旧名.py 新名.py     # 重命名（等价于 mv + git rm + git add）
```

---

## 第五站：`.gitignore`——让 Git 忽略不该提交的文件

拾光项目里有些内容**不应该**进入仓库：

- 依赖目录（`node_modules`）；
- 编译产物（`dist/`、`build/`）；
- 日志文件（`*.log`）；
- 编辑器配置（`.vscode/`、`.idea/`）；
- 本地环境变量（`.env`）；
- 密钥和凭证。

在项目根目录创建 `.gitignore`：

```gitignore
# Dependencies
node_modules/

# Build output
dist/
build/

# Logs
*.log

# Environment variables
.env
.env.*

# IDE
.vscode/
.idea/

# OS
.DS_Store
Thumbs.db
```

但小满踩过一个坑，必须讲清楚：**`.gitignore` 只对"尚未被 Git 跟踪的文件"生效。**

如果 `.env` 已经提交过，仅仅把它写进 `.gitignore` 并不能停止跟踪。你需要：

```bash
git rm --cached .env
git commit -m "chore: stop tracking local environment file"
```

他还在工位上贴了一条红线：

> 如果文件中包含已经泄露的密钥，**必须立即轮换密钥**。删除最新版本中的文件，并不等于它从 Git 历史中消失——一旦提交过，历史里就永远留着它。

---

## 第六站：分支——Git 最强大的能力之一

拾光的功能越加越多，三个人开始分工：老周优化追更接口，阿澈重构阅读页，小满做作者后台。如果都在 `main` 上改，又会互相踩脚——阿澈的登录页事故就是前车之鉴。

分支就是来解决这个问题的。**分支可以理解为一条独立的开发路线**：你可以在 `main` 保持稳定代码，同时创建新分支开发功能：

```
main:        A---B---C
                   \
feature:           D---E
```

小满说："把分支想象成从主干上长出来的树枝——树枝上可以随便折腾，折腾好了再接回主干，折腾坏了直接剪掉，主干毫发无损。"

### 查看分支

```bash
git branch        # 查看本地分支
git branch -a     # 查看本地和远程分支
```

### 创建并切换分支

推荐使用现代命令：

```bash
git switch -c feature/login
```

它等价于旧写法：

```bash
git checkout -b feature/login
```

### 切换分支

```bash
git switch main
```

### 合并分支

功能开发完成后，切回主分支，把功能合并进来：

```bash
git switch main
git merge feature/login
```

### 删除分支

```bash
git branch -d feature/login     # 删除已合并的分支（安全删除）
git branch -D feature/login     # 强制删除未合并分支
```

> 使用 `-D` 前一定要确认分支内容不再需要。小满补了一句："**分支非常轻量**，为每个功能、修复或实验创建独立分支，通常比直接在主分支修改更安全——别把分支当宝贝舍不得建，也别把 `-D` 当日常操作。"

---

## 第七站：`merge` 与 `rebase`——最容易混淆的一组概念

这是 Git 学习中最容易混淆、也最值得理解的一组概念。小满花了一个下午把它们彻底搞懂。

假设当前历史如下：

```
C---D  feature
     /
A---B---E---F  main
```

### `merge`：保留真实的分叉历史

在 `feature` 分支执行 `git merge main`，或者切到 `main` 后合并 `feature`，Git 可能创建一个新的合并提交：

```
C---D
     \     \
A---B---E---F---M
```

**优点**：不改写已有提交、历史真实、对共享分支更安全。
**缺点**：分支多时，提交图可能变得复杂。

小满看了下输出，学会了读合并结果：

```
$ git merge bugfix_branch_1

Updating 47cb197..03d0419
Fast-forward                          # 快进合并（没有冲突，直接移动指针）
 app/static/dist/css/main.min.css |   2 +-
 app/static/dist/js/highcharts.js  | 40 +++++
 ...
 18 files changed, 1000 insertions(+), 512 deletions(-)
```

| 输出项 | 含义 |
|--------|------|
| `Fast-forward` | 快进合并，直接移动指针，无额外合并提交 |
| `files changed` | 改了多少文件 |
| `insertions(+)` | 新增的行数 |
| `deletions(-)` | 删除的行数 |

### `rebase`：把提交"搬到"新基线

在 `feature` 分支执行 `git rebase main`，历史会变成：

```
A---B---E---F---C'---D'
```

原来的 `C`、`D` 被重新创建为 `C'`、`D'`，因此**提交哈希会改变**。

**优点**：历史更线性、代码审查更清晰、减少无意义的合并提交。
**风险**：会改写提交历史，不适合随意改写多人共同使用的公共分支。

### 一条实用原则

> 可以整理自己的本地分支，但不要轻易改写已经推送、且被多人基于其开发的公共历史。

常见个人分支同步方式：

```bash
git switch feature/login
git fetch origin
git rebase origin/main
```

如果发生冲突，解决后执行：

```bash
git add <resolved-file>
git rebase --continue
```

取消本次变基：

```bash
git rebase --abort
```

小满把两者的取舍做成了一张表贴在工位上：

| 特性 | `git merge` | `git rebase` |
|------|-------------|--------------|
| 历史记录 | 有分叉，保留真实历史 | 线性，历史整洁 |
| 额外提交 | 生成合并提交（Merge commit） | 无额外提交 |
| 安全性 | 更安全，不易出问题 | 较危险，改写了历史 |
| 适用场景 | 公共分支、团队协作 | 个人本地分支整理 |
| 冲突处理 | 一次性解决 | 可能逐个提交解决 |

> 💡 **经验法则**：公共分支用 **merge**，本地个人分支整理用 **rebase**。

---

## 第八站：远程仓库与团队协作

分支解决了"三个人怎么在本地并行开发"，接下来是"三个人怎么把代码合到一起"——远程仓库登场。

老周把代码托管到了 Gitee 私有仓库，作为大家的"公共存档点"。

### 克隆项目

```bash
git clone <repository-url>
```

克隆完成后，Git 通常会自动创建名为 `origin` 的远程地址。查看远程仓库：

```bash
git remote -v
```

### 给本地仓库添加远程地址

```bash
git remote add origin <repository-url>
```

第一次推送主分支：

```bash
git push -u origin main
```

`-u` 会建立本地分支与远程分支的**跟踪关系**。之后可以直接执行 `git push` / `git pull`，不用再带参数。

### `fetch` 与 `pull` 的区别

小满反复跟阿澈强调这两个命令的区别：

```bash
git fetch origin    # 获取远程最新信息，但不自动修改当前分支
git pull            # 拉取并整合远程变化
```

可以把 `git pull` 粗略理解为 `git fetch + git merge`；在启用 rebase 的情况下，也可能是 `git fetch + git rebase`。

更稳妥的做法是**先获取、再查看、最后决定如何整合**：

```bash
git fetch origin
git log --oneline --graph --decorate --all
git merge origin/main
```

个人功能分支常用：

```bash
git pull --rebase
```

### 推送分支并发起审查

```bash
git push -u origin feature/login
```

随后在代码托管平台（GitHub / GitLab / Gitee）发起 Pull Request 或 Merge Request，由团队进行代码审查。

---

## 第九站：标准团队协作流程——一套低风险的日常循环

三人磨合了一个月后，沉淀出一套清晰、低风险的日常流程。小满说："这套流程的核心是：**让 `main` 永远干净，让冲突尽早暴露，让审查成为习惯。**"

### 第一步：同步主分支

```bash
git switch main
git pull --ff-only
```

`--ff-only` 表示只允许快进更新，避免在本地主分支意外产生合并提交。

### 第二步：创建功能分支

```bash
git switch -c feature/order-export
```

### 第三步：开发并提交

```bash
git add -p
git commit -m "feat: add CSV order export"
```

一个较大的功能可以拆成多个逻辑清晰的提交。

### 第四步：同步最新主分支

```bash
git fetch origin
git rebase origin/main
```

### 第五步：推送远程

```bash
git push -u origin feature/order-export
```

如果你已经推送过该个人分支，且 rebase 改写了历史，可能需要：

```bash
git push --force-with-lease
```

小满特别强调：**不要优先使用裸 `--force`**。`--force-with-lease` 会在远程分支出现你未获取的新提交时拒绝覆盖，相对更安全。

### 第六步：发起代码审查

在 Pull Request 或 Merge Request 中说明：

- 为什么要做；
- 主要改动是什么；
- 如何验证；
- 是否存在兼容性、数据库或部署风险。

### 第七步：合并并清理分支

```bash
git switch main
git pull --ff-only
git branch -d feature/order-export

git push origin --delete feature/order-export   # 删除远程分支
```

---

## 第十站：冲突并不可怕——一步步解决

上线前的某天，阿澈和小满改了同一个阅读页的配置文件。合并时，屏幕上出现了那个让所有新手心跳加速的词：`CONFLICT`。

小满说："冲突的本质是：**Git 无法自动判断两份修改应该如何组合，需要人来决定。**它不可怕，只是需要你亲自做一次'裁决'。"

例如，文件中出现：

```
<<<<<<< HEAD
const timeout = 3000;
=======
const timeout = 5000;
>>>>>>> feature/performance
```

含义是：

- `<<<<<<< HEAD` 到 `=======`：当前一侧的内容；
- `=======` 到 `>>>>>>>`：另一侧的内容。

处理步骤：

### 1. 查看冲突文件

```bash
git status
```

### 2. 打开文件，决定最终内容

例如保留 `const timeout = 5000;`，并删除冲突标记。

### 3. 标记冲突已解决

```bash
git add src/config.js
```

### 4. 继续当前操作

```bash
git commit              # 如果是 merge
git rebase --continue   # 如果是 rebase
git cherry-pick --continue  # 如果是 cherry-pick
```

### 5. 放弃当前操作

```bash
git merge --abort       # 放弃 merge
git rebase --abort      # 放弃 rebase
git cherry-pick --abort # 放弃 cherry-pick
```

> 解决冲突的关键不是"选左边还是右边"，而是**理解双方修改的业务意图，写出正确的最终结果**。

小满还总结了一句让团队受用很久的话："冲突是 Git 在保护你们——它宁可停下来问人，也不愿悄悄覆盖掉任何一方的成果。"

---

## 第十一站：撤销修改——先判断内容在哪个区域

Git 的撤销操作看起来很多，小满说其实只需要先问一个问题：

> 我想撤销的内容，现在位于**工作区、暂存区、本地提交，还是远程共享历史**？

不同位置，用的命令完全不同。

### 场景 1：丢弃工作区修改

```bash
git restore app.js    # 恢复单个文件
git restore .         # 恢复所有已跟踪文件
```

> ⚠️ 这会丢失未提交修改，执行前请确认。这个操作不可恢复！经典旧写法是 `git checkout -- 文件名`，新版 Git 推荐 `git restore`。

### 场景 2：取消暂存，但保留文件修改

```bash
git restore --staged app.js
```

文件会从暂存区回到工作区。（旧写法：`git reset HEAD 文件名`）

### 场景 3：修改最近一次提交

```bash
git add forgotten-file.js
git commit --amend --no-edit    # 补充遗漏文件，不修改提交信息

git commit --amend              # 修改最近一次提交信息
```

> 如果该提交已经被他人拉取，不建议随意 amend 后强制推送。

### 场景 4：撤销已经共享的提交

```bash
git revert <commit>
```

`revert` 不会删除旧提交，而是创建一个新的"反向提交"，因此**适合公共分支**。

撤销一次合并提交时，通常需要指定主线父提交：

```bash
git revert -m 1 <merge-commit>
```

这类操作影响较大，执行前应先确认合并结构和回滚目标。

### 场景 5：重置本地提交

```bash
git reset --soft HEAD~1    # 保留修改并回退提交（修改留在暂存区）
git reset HEAD~1           # 保留工作区修改，但取消提交和暂存
git reset --hard HEAD~1    # 彻底丢弃提交及文件修改（最危险）
```

三种模式对比（重点理解）：

| 模式 | 工作区 | 暂存区 | 版本库 | 安全程度 |
|------|--------|--------|--------|----------|
| `--soft` | ✅ 保留修改 | ✅ 保留暂存 | 回退 | ⭐ 最安全 |
| `--mixed`（默认） | ✅ 保留修改 | ❌ 清空暂存 | 回退 | ⭐⭐ 中等 |
| `--hard` | ❌ **丢弃修改** | ❌ 清空暂存 | 回退 | ⚠️ **最危险** |

小满把撤销的决策树画在了笔记里：

```
我想要撤销...
│
├─ 只撤销某个文件的修改？
│   └── git restore 文件名
│
├─ 撤销 git add（不想提交了）？
│   └── git restore --staged 文件名
│
├─ 撤销最近的 commit（想重写提交信息）？
│   └── git commit --amend
│
├─ 回退到很久以前的版本？
│   ├── 保留修改 → git reset commit_id
│   └── 丢弃修改 → git reset --hard commit_id（危险！）
│
└─ 撤销已经推送的提交？
    └── git revert commit_id（生成反向提交，最安全）
```

---

## 第十二站：误删提交怎么办？——认识 `reflog`

上线前夜，小满手一抖，执行了 `git reset --hard HEAD~3`，把包含三天工作量的提交全"删"了。

"完了。"他心想。

但老周（已经比他淡定得多）告诉他："**别慌，Git 有后悔药。**很多人以为 `reset --hard` 之后就彻底没救了。实际上，只要 Git 尚未清理相关对象，通常还能通过 `reflog` 找回。"

查看 HEAD 的移动记录：

```bash
git reflog
```

你可能看到：

```
a1b2c3d HEAD@{0}: reset: moving to HEAD~1
9f8e7d6 HEAD@{1}: commit: feat: complete payment flow
```

恢复到误操作前：

```bash
git reset --hard 9f8e7d6
```

更稳妥的方式是先创建一个救援分支，再检查内容：

```bash
git branch rescue/payment 9f8e7d6
```

> `git log` 展示**可达的**提交历史，`git reflog` 记录**本地引用曾经指向过哪里**。后者是 Git 的"后悔药"，但它不是永久备份——它也会过期清理。

---

## 第十三站：临时切换任务——`git stash`

某天下午，小满正在开发作者后台的新功能，代码写到一半还不能提交。突然读者群炸了：线上评论功能挂了，他必须马上切分支修复。

"改到一半的代码怎么办？"他问。

答案是 `git stash`——把当前的工作现场"存起来"：

```bash
git stash push -m "wip: order form validation"
```

查看 stash 列表：

```bash
git stash list
```

修完线上问题，切回来恢复：

```bash
git stash apply          # 恢复并保留 stash
git stash pop            # 恢复后删除 stash
git stash apply stash@{1}  # 恢复指定项
git stash branch rescue/order-form stash@{0}  # 把某个 stash 直接恢复到新分支
```

默认情况下，未跟踪文件可能不会被保存。需要同时保存未跟踪文件时：

```bash
git stash push -u -m "wip: include untracked files"
```

> 小满提醒：**不要把 stash 当成长期仓库。**重要工作更适合创建临时分支并提交——stash 栈堆太多，自己都会忘记里面存的是什么。

---

## 第十四站：从其他分支拿一个提交——`cherry-pick`

拾光有一个维护分支 `release`，线上出了个紧急 Bug，修复提交打在 `main` 上。小满不想把整个 `main` 合进 `release`（那会把没上线的新功能也带过去），只想取那一个修复提交：

```bash
git switch release
git cherry-pick a1b2c3d
```

Git 会把该提交的改动应用到当前分支，并生成一个新的提交。

发生冲突后：

```bash
git add <resolved-files>
git cherry-pick --continue
```

放弃操作：

```bash
git cherry-pick --abort
```

> `cherry-pick` 很适合把某个紧急修复同步到多个维护分支，但如果频繁使用，也可能造成重复提交和历史关系混乱。小满的原则：**偶尔救火用 cherry-pick，长期同步靠 merge 或 rebase。**

---

## 第十五站：整理提交历史——交互式 `rebase`

小满有个坏习惯：写代码时提交得又碎又乱。开发"支付表单"功能时，他的历史长这样：

```
feat: add payment form
fix typo
try again
fix test
really fix test
```

阿澈看了一眼："这种历史推到仓库里，review 的人会崩溃的。"

整理方法：交互式 rebase，把最近 5 个提交合并整理：

```bash
git rebase -i HEAD~5
```

编辑器中会出现：

```
pick a111111 feat: add payment form
pick b222222 fix typo
pick c333333 try again
pick d444444 fix test
pick e555555 really fix test
```

常见操作：

- `pick`：保留提交；
- `reword`：保留内容，修改提交信息；
- `edit`：停下来修改提交；
- `squash`：合并到前一个提交，并编辑信息；
- `fixup`：合并到前一个提交，丢弃当前信息；
- `drop`：删除提交。

整理后，可以把历史变成一行干净利落的提交：

```
feat: add payment form with validation and tests
```

> 再次提醒：交互式 rebase 会改写提交历史，**更适合整理尚未共享的个人分支**。已经推送到公共分支的历史，不要轻易改写。

---

## 第十六站：给版本打标签——`git tag`

拾光要发 v1.0.0 了。老周想给这个"历史时刻"做个标记，方便以后随时找回——出了问题也好回滚到发布版本。

发布版本时，可以给某个提交创建标签：

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
```

查看标签：

```bash
git tag            # 列出所有标签
git show v1.0.0    # 查看标签详情
```

推送标签：

```bash
git push origin v1.0.0      # 推送单个标签
git push origin --tags      # 推送所有本地标签
```

删除标签：

```bash
git tag -d v1.0.0               # 删除本地标签
git push origin --delete v1.0.0 # 删除远程标签
```

> 标签通常用于版本发布，不建议把可变的开发状态当成固定版本标签反复覆盖。小满说："标签就是发布清单上的版本号——每次发版打一个，出问题就知道该回滚到哪。"

---

## 第十七站：定位"哪个提交引入了 Bug"——`git bisect`

上线三周后，读者反馈拾光的搜索功能时好时坏。Bug 存在于当前版本，但一周前的版本是好的——到底是哪个提交引入的？

小满不想一个个提交翻。他用了 `git bisect`——**二分查找**：

```bash
git bisect start          # 开始
git bisect bad            # 标记当前版本有问题
git bisect good <good-commit>   # 标记某个旧版本正常
```

Git 会自动切换到中间提交。测试后继续标记：

```bash
git bisect good    # 这个版本正常
git bisect bad     # 这个版本有问题
```

重复几次后，Git 会定位第一个问题提交。

结束并回到原分支：

```bash
git bisect reset
```

如果项目有可自动判断成功或失败的测试脚本，还可以全自动：

```bash
git bisect run <test-command>
```

> 这能把"几百次提交中找 Bug"的问题，变成少量自动测试。小满感慨："一次 Bug 排查从半天缩短到十分钟，`bisect` 是我最感谢的 Git 命令之一。"

---

## 第十八站：同时维护多个分支——`git worktree`

拾光的功能分支越来越多，小满遇到了一个尴尬：Git 仓库**一个目录一次只能检出一个分支**。他想在当前目录继续开发作者后台，同时又想在另一个目录里修线上 Hotfix——来回 `stash`、`switch` 太折腾了。

`git worktree` 可以让同一个仓库同时拥有多个工作目录：

```bash
git worktree add ../project-hotfix hotfix/login
```

此时你可以：

- 在当前目录继续开发功能；
- 在 `../project-hotfix` 修复线上问题；
- 两边共享同一个仓库对象数据库。

查看工作区：

```bash
git worktree list
```

移除工作区：

```bash
git worktree remove ../project-hotfix
```

> 对于需要频繁在多个分支间切换的人，`worktree` 往往比反复 stash 更高效。小满说："它像是给 Git 开了多个'窗口'，每个窗口一个分支，互不干扰。"

---

## 第十九站：Git 的底层原理——它保存的不是"差异列表"

小满一直好奇一个问题：Git 到底是怎么存历史的？难道是把每个版本的完整文件都复制一遍？

他翻了很多资料后恍然大悟：**从使用层面看，Git 像是在记录每次修改；从底层看，Git 更接近一个基于内容寻址的对象数据库。**

核心对象主要有四类：

### 1. Blob

保存文件内容，不关心文件名。

### 2. Tree

保存目录结构，记录文件名、权限以及对应的 blob 或子 tree。

### 3. Commit

保存：

- 顶层 tree；
- 父提交；
- 作者和提交者；
- 时间；
- 提交信息。

### 4. Tag

通常用于给某个对象，尤其是提交，创建一个有名称的版本标记。

一次提交可以粗略理解为：

```
commit
  ├─ 指向一个项目快照 tree
  ├─ 指向一个或多个父 commit
  └─ 保存作者、时间和说明
```

Git 对对象内容计算哈希，并通过哈希标识对象。**内容发生变化，哈希也会变化。**

这解释了几个现象：

- 修改一次提交信息，提交哈希会变；
- rebase 后提交哈希会变；
- 两个内容完全相同的文件对象可以复用；
- 分支本质上只是一个指向提交的可移动引用。

---

## 第二十站：HEAD、分支和"游离状态"

理解了对象模型，小满发现 HEAD 和分支的概念一下子清晰了。

### 分支是什么？

分支不是一份完整代码副本，而是一个**指向某次提交的轻量引用**：

```
main → C3
```

当你在 `main` 上创建新提交 `C4`，分支指针向前移动：

```
main → C4
```

### HEAD 是什么？

HEAD 表示你**当前检出的位置**。通常它指向某个分支：

```
HEAD → main → C4
```

### 什么是 Detached HEAD（游离状态）？

如果直接检出某个提交：

```bash
git switch --detach <commit>
```

HEAD 会直接指向提交，而不是分支：

```
HEAD → C2
```

此时可以查看、测试和临时修改，但**新提交不会自动属于某个已有分支**。

如果你在游离状态下做了重要提交，及时创建分支"收留"它：

```bash
git switch -c rescue/experiment
```

小满说："理解了 HEAD 是'我现在站在哪'，Detached HEAD 就是'我站在一个没有路标的路口'——能看能逛，但新走的脚印不会记在主干道上，要自己立个路标（分支）。"

---

## 第二十一站：提交信息如何写得更专业

拾光发版时，老周需要根据提交历史生成发布说明。看着一堆 `update`、`fix bug`，他头都大了。从那以后，他强制团队使用 Conventional Commits 规范。

一种常见格式是：

```
<type>(<scope>): <subject>
```

例如：

```
feat(auth): support passkey login
fix(order): prevent duplicate payment
docs(api): add pagination examples
refactor(user): extract profile service
test(cart): cover coupon edge cases
chore(deps): update build tooling
```

提交正文可以解释：

```
为什么需要这个修改？采用了什么方案？有哪些副作用或兼容性影响？
```

> 高质量提交历史不仅方便查问题，也能提升代码审查、发布说明和团队交接效率。小满说："写提交信息不是写给 Git 看的，是写给三个月后的自己和同事看的。"

---

## 第二十二站：几个常见误区——别再踩了

小满把团队踩过的坑汇总成"误区清单"，新人入职必读：

### 误区 1：`git add .` 就是上传代码

不是。它只是把修改加入暂存区。

### 误区 2：`git commit` 后同事就能看到

不是。提交仍然在你的本地仓库，通常还需要 `git push`。

### 误区 3：分支很"重"，不要随便建

Git 分支非常轻量。为每个功能、修复或实验创建独立分支，通常比直接在主分支修改更安全。

### 误区 4：删掉分支，提交就永久消失

不一定。只要提交仍被其他分支、标签或 reflog 引用，就仍然可能找回。

### 误区 5：`git pull` 永远安全

`pull` 会自动整合远程修改，可能生成你不期望的合并提交，或触发冲突。重要操作前先 `fetch` 并查看历史更稳妥。

### 误区 6：强制推送只是"覆盖一下"

强制推送可能删除远程分支上的他人提交。个人分支确需强推时，优先使用：

```bash
git push --force-with-lease
```

### 误区 7：把密码删掉就安全了

只要密码曾经提交，它就可能仍存在于历史中。应立即轮换凭证，并按团队流程清理历史。

小满说："这七个误区有个共同点——**都是对'Git 到底改了什么'缺乏感知**。看清状态再动手，一半的坑都能躲开。"

---

## 第二十三站：推荐的 Git 最佳实践

拾光稳定运行了半年，小满把团队沉淀下来的实践整理成了"最佳实践清单"：

### 1. 主分支始终保持可构建、可测试

不要把未完成代码直接堆在 `main`。`main` 是所有人的共同地基，地基塌了，大家都完蛋。

### 2. 一个分支解决一个主题

```bash
feature/user-search
fix/payment-timeout
refactor/order-service
```

### 3. 一次提交只做一件事

不要把"新增功能、格式化全项目、升级依赖、修复无关 Bug"放在同一次提交里。

### 4. 提交前先检查差异

```bash
git status
git diff
git diff --staged
```

### 5. 不提交密钥、大文件和本地配置

对大文件和二进制资产，评估是否需要 Git LFS 或专门的制品存储。

### 6. 对主分支启用保护规则

团队项目中通常应要求：

- 通过 Pull Request 合并；
- 至少一人审查；
- CI 检查通过；
- 禁止直接强推；
- 必要时要求分支保持最新。

### 7. 合并前整理个人分支

可以通过 rebase、fixup 和交互式 rebase，让提交历史清晰可读。

### 8. 不要害怕提交

本地小步提交比长期不提交更安全。提交太碎可以在分享前整理。

---

## 第二十四站：一个完整实战——从零开发到合并

理论都讲完了，小满带阿澈完整走了一遍"给拾光新增作者搜索功能"的全流程。

### 1. 获取项目

```bash
git clone <repository-url>
cd project
```

### 2. 同步主分支

```bash
git switch main
git pull --ff-only
```

### 3. 创建功能分支

```bash
git switch -c feature/user-search
```

### 4. 开发并查看修改

```bash
git status
git diff
```

### 5. 分批暂存

```bash
git add -p
```

### 6. 创建提交

```bash
git commit -m "feat(search): add user keyword query"
```

继续补充测试：

```bash
git add tests/
git commit -m "test(search): cover empty and fuzzy queries"
```

### 7. 同步团队最新代码

```bash
git fetch origin
git rebase origin/main
```

若发生冲突：

```bash
git status
# 手动解决冲突
git add <resolved-files>
git rebase --continue
```

### 8. 推送分支

```bash
git push -u origin feature/user-search
```

如果此前已推送，且 rebase 改写了个人分支：

```bash
git push --force-with-lease
```

### 9. 发起代码审查

说明功能目标、测试方法、影响范围和风险。

### 10. 合并后清理

```bash
git switch main
git pull --ff-only
git branch -d feature/user-search
```

至此，一次完整、规范的 Git 协作流程结束。小满说："你看，整个流程里没有一个'高级命令'——把基础命令用对顺序，就是专业。"

---

## 第二十五站：高频命令速查表——贴在工位上

小满把最常用的命令整理成了速查表。建议你也存一份，用多了自然就记住了。

### 仓库与配置

```bash
git init
git clone <url>
git config --global user.name "Name"
git config --global user.email "email@example.com"
```

### 状态与差异

```bash
git status
git diff
git diff --staged
git log --oneline --graph --decorate --all
git show <commit>
```

### 暂存与提交

```bash
git add <file>
git add -p
git restore --staged <file>
git commit -m "message"
git commit --amend
```

### 分支

```bash
git branch
git switch <branch>
git switch -c <new-branch>
git merge <branch>
git rebase <branch>
git branch -d <branch>
```

### 远程协作

```bash
git remote -v
git fetch origin
git pull --ff-only
git pull --rebase
git push
git push -u origin <branch>
git push --force-with-lease
```

### 撤销与恢复

```bash
git restore <file>
git revert <commit>
git reset --soft HEAD~1
git reset --hard <commit>
git reflog
```

### 临时保存与挑选提交

```bash
git stash push -m "message"
git stash list
git stash pop
git cherry-pick <commit>
```

### 标签与排错

```bash
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
git bisect start
git blame <file>
```

---

## 结语：真正"精通 Git"意味着什么？

故事讲完了。

小满从入职第一天那串"最终版"文件夹开始，一路走到拾光三人团队协作、稳定迭代。他学会了敲：

```bash
git add
git commit
git push
git switch
```

但他很清楚，这些命令只是表象。真正让他脱胎换骨的，是一整套心智模型：

- 清楚修改位于工作区、暂存区还是提交历史；
- 能根据场景选择 merge、rebase、revert 或 reset；
- 面对冲突时，能理解并正确整合双方意图；
- 发生误操作后，知道用 reflog、临时分支等方式恢复；
- 能设计清晰、安全、可审查的团队协作流程；
- 理解分支、HEAD、提交和对象之间的关系；
- 知道哪些历史可以改写，哪些历史必须谨慎保护。

你会发现，Git 的核心始终围绕三件事：

```
保存状态、移动引用、同步历史
```

当这套模型真正建立起来，命令就不再是零散口诀，而会变成自然的操作选择。

> Git 最让人焦虑的地方，往往不是命令多，而是不知道命令执行后究竟改变了什么。

所以，下一次准备执行危险操作时，不妨先停一下，依次确认：

```bash
git status
git diff
git log --oneline --graph --decorate --all
```

看清当前状态，再决定下一步。

从今天开始，不要只把 Git 当成"上传代码的工具"。把它当成你的开发时间机器、协作协议和项目历史数据库。

当你不再害怕分支、不再恐惧冲突，并且知道误操作后如何恢复时，你就已经跨过了 Git 从入门到精通最重要的那道门槛。

> 建议在实际项目中逐条实践。Git 不是看会的，而是用会的。

---

## 官方延伸阅读

- Git 官方文档：https://git-scm.com/doc
- Pro Git 中文版（免费在线书）：https://git-scm.com/book/zh/v2
- Git 参考手册：https://git-scm.com/docs
- Conventional Commits 规范：https://www.conventionalcommits.org/zh-hans/
- GitHub 入门指南：https://docs.github.com/zh/get-started
- GitLab 文档：https://docs.gitlab.com/
- 阮一峰 Git 教程：https://www.ruanyifeng.com/blog/2015/12/git-cheat-sheet.html
