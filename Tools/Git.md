# $Git$

📋 速查表

```bash
# ===== 日常工作流 =====
git status                      # 查看状态
git add .                       # 暂存所有修改
git commit -m "描述"            # 提交
git push                        # 推送到远程

# ===== 查看信息 =====
git log --oneline               # 查看提交历史
git diff                        # 查看未暂存的修改
git diff --staged               # 查看已暂存的修改

# ===== 分支操作 =====
git branch                       # 查看分支
git checkout -b 新分支           # 创建并切换
git merge 分支名                 # 合并分支
git branch -d 分支名             # 删除分支

# ===== 撤销操作 =====
git checkout -- 文件名          # 撤销工作区修改
git reset HEAD 文件名           # 撤销暂存
git reset --hard commit_id      # 回退版本（危险！）

# =====================

# ===== 必做配置 =====
git config --global user.name "你的名字"
git config --global user.email "你的邮箱"

# ===== 换行符（根据系统选择）=====
# Windows:
git config --global core.autocrlf true
# Linux/Mac:
git config --global core.autocrlf input

# ===== 中文编码 =====
git config --global core.quotepath false

# ===== 查看所有配置 =====
git config --list
```

# ☀️ Git的安装

## Linux（基于Ubuntu24.04 LTS）

### 方式一：apt 包管理器安装（推荐新手）

```bash
# 安装 Git 核心命令
apt install git

# 可选：安装额外工具
apt install git-doc git-svn git-email gitk
```

| 包名 | 作用 |
|------|------|
| `git` | Git 核心命令（必装） |
| `git-doc` | 文档手册 |
| `git-svn` | 与 SVN 仓库交互 |
| `git-email` | 用邮件发送补丁 |
| `gitk` | 图形化历史查看工具 |

### 方式二：源码编译安装（适合需要最新版本）

```bash
# 1. 安装编译依赖
apt update
apt install build-essential libssl-dev libcurl4-openssl-dev libexpat1-dev gettext zlib1g-dev

# 2. 下载源码
wget https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.43.0.tar.gz

# 3. 解压并编译
tar -zxvf git-2.43.0.tar.gz
cd git-2.43.0
make prefix=/usr/local all
make prefix=/usr/local install
```

### 命令补齐配置

```bash
# 安装 bash-completion
apt install bash-completion

# 复制 Git 补齐脚本
cp contrib/completion/git-completion.bash /etc/bash_completion.d/

# 永久生效：添加到 ~/.bashrc
echo 'if [ -f /etc/bash_completion ]; then' >> ~/.bashrc
echo '    . /etc/bash_completion' >> ~/.bashrc
echo 'fi' >> ~/.bashrc
```

> 💡 按 `Tab` 键可自动补全命令，如 `git che<Tab>` → `git checkout`

### 验证安装

```bash
git --version
# 显示：git version 2.43.0
```

## Windows（基于Windows11）

### 方案一：Git 官方安装包（推荐）

**Step 1：下载安装**
- 访问 https://git-scm.com/download/win
- 下载 `Git-2.x.x-64-bit.exe` 安装包

**Step 2：选择组件**
| 组件 | 建议 |
|------|------|
| Git Bash Here | ✅ 勾选（右键菜单启动终端）|
| Git GUI Here | ✅ 可选 （图形化界面工具）|
| Git LFS | ❌ 取消勾选 |

**Step 3：配置 PATH**
- 推荐选择：`Use Git Bash only`
- 只在 Git Bash 中使用，不修改系统 PATH

**Step 4：验证安装**
- 右键任意文件夹 → "Git Bash Here"
- 运行 `git version` 验证

### 方案二：TortoiseGit（图形化工具）

适合喜欢图形界面操作的用户：
- 集成到 Windows 资源管理器
- 文件图标显示版本状态
- 右键菜单直接操作 Git 命令

**安装注意**：SSH 客户端选择 **TortoisePLink** 或 **OpenSSH**

> 💡 **建议**：先装 Git 官方包，需要图形界面时再装 TortoiseGit

# ⚙️ Git的配置

## 通俗理解
Git 配置分三层，就像公司的规章制度：
- **系统配置**：公司全员都要遵守（所有用户）
- **用户配置**：你所在部门的规定（当前用户）
- **仓库配置**：你所在小组的特殊规定（当前项目）

**优先级**：仓库 > 用户 > 系统（越下层越优先）


## 👤 配置个人身份（必做！）

告诉 Git "我是谁"，每次提交代码都会带上你的名字和邮箱。

```bash
# 用户名和邮箱（二者通用）
git config --global user.name "Zhang San"
git config --global user.email "zhangsan123@huawei.com"
```

> ⚠️ **重要**：名字和邮箱一旦确定就不要改！用于责任追踪和贡献度统计。


## 🔄 文本换行符配置（Windows 和 Linux 差异点！）

| 系统 | 换行符 | 表示 |
|------|--------|------|
| Windows | CRLF | `\r\n` |
| Linux/Mac | LF | `\n` |

跨平台协作时容易出现奇怪的问题！

**Windows 用户（推荐）**：
```bash
git config --global core.autocrlf true
# 提交时自动把 CRLF 转为 LF，检出时转回 CRLF
```

**Linux/Mac 用户（推荐）**：
```bash
git config --global core.autocrlf input
# 提交时把 CRLF 转为 LF，检出时不转换
```

## 🅰️ 文本编码配置

确保中文正常显示，不乱码（二者通用）。

```bash
# 中文编码支持
git config --global gui.encoding utf-8
git config --global i18n.commitencoding utf-8
git config --global i18n.logoutputencoding utf-8

# 显示路径中的中文（避免中文路径显示为乱码）
git config --global core.quotepath false
```

## ☁️ 与服务器的认证配置

### 📊 两种协议对比

| 协议 | 特点 | 适用场景 |
|------|------|----------|
| HTTP/HTTPS | 需输入用户名密码 | 临时访问、简单场景 |
| SSH | 公钥认证，免密登录 | 日常开发（推荐）|

### HTTP/HTTPS 配置

```bash
# 记住密码（避免每次输入）
git config --global credential.helper store

# 忽略 HTTPS 证书验证（自签名证书时用）
git config http.sslverify false
```

### 🔑 SSH 认证配置（重点！）

**Step 1：生成密钥对**

```bash
# 命令在 Ubuntu 和 Windows 的 Git Bash 中通用
ssh-keygen -t rsa -C "zhangsan1123@163.com"
```
- 保存路径：直接回车（默认 `~/.ssh/id_rsa`）
- 密码：直接回车（免密登录）

**Step 2：查看公钥**

```bash
# Ubuntu 和 Windows (Git Bash)
cat ~/.ssh/id_rsa.pub
```

**Step 3：添加到代码平台**

| 平台 | 路径 |
|------|------|
| GitHub | Settings → SSH and GPG keys → New SSH key |
| GitLab | Profile Settings → SSH Keys → Add SSH key |
| Gitee | 设置 → SSH 公钥 → 添加公钥 |

复制 `id_rsa.pub` 内容，粘贴到平台的 Public Key 栏，保存即可。

**Step 4：验证连接**

```bash
# GitHub
ssh -T git@github.com

# GitLab
ssh -T git@gitlab.com
```

看到 `Hi xxx! You've successfully authenticated` 即成功！


# 📝 Git基本命令

## 🎯 核心概念：工作区、暂存区、版本库

```
┌─────────────────────────────────────────────────────────────┐
│                        工作区 (Working Directory)            │
│              你正在编辑文件的目录 / 看得见摸得着               │
│                                                             │
│   文件1.py   文件2.txt   图片.png                            │
│       ↓  git add                                            │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              暂存区 (Staging Area / Index)           │   │
│  │             准备提交的文件快照                        │   │
│  │                                                     |    │
│  │   文件1.py   文件2.txt                               │    │
│  │       ↓  git commit                                 │    │
│  └─────────────────────────────────────────────────────┘    │
│       ↓                                                     │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              版本库 (Repository)                     │    │
│  │             正式记录的历史版本                        │    │
│  │                                                     |    │
│  │   commit_1 ← 最新版本                                │    │
│  │   commit_2                                          │    │
│  │   commit_3                                          │    │
│  └─────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────┘
```

**通俗理解** 🌟：
- **工作区**：你的办公桌，放着正在用的文件
- **暂存区**：准备提交的文件清单（类似快递的打包区）
- **版本库**：正式存档的版本记录（类似档案室）

## 🚀 1. 创建仓库

```bash
# 在当前目录初始化一个新的 Git 仓库
git init

# 示例输出
Initialized empty Git repository in /home/user/project/.git/
```

> 💡 执行后会在当前目录生成 `.git` 隐藏文件夹，这就是版本库。

## 🔍 2. 查看状态

```bash
# 查看工作区文件状态（最常用的命令！）
git status

# 简化输出（只看文件名）
git status -s
```

**输出解读**：

| 符号 | 含义 | 说明 |
|------|------|------|
| `A` (Green) | 新增 | 新文件，已添加到暂存区 |
| `M` (Green) | 修改 | 文件已修改并暂存 |
| `M` (Red) | 修改 | 文件已修改但未暂存 |
| `D` | 删除 | 文件已删除 |
| `??` | 未跟踪 | 新文件，Git 还没管理 |

**示例输出**：
```
On branch master                               # 当前在 master 分支
Untracked files:                              # 未跟踪的文件
  (use "git add <file>..." to include in what will be committed)
        new_feature.py                         # 红色 = 新文件，未 add
        README.md                              # 红色 = 未 add

Changes to be committed:                       # 暂存区（准备提交）
  (use "git reset HEAD <file>..." to unstage)
        modified:   config.py                  # 绿色 = 已 add
```

## 📦 3. 暂存文件

```bash
# 暂存指定文件
git add 文件名.py

# 暂存多个文件
git add 文件1.py 文件2.txt

# 暂存当前目录所有变化（新增、修改、删除）
git add .

# 暂存所有 .py 文件
git add *.py

# 交互式暂存（选择性添加文件的部分修改）
git add -p
```

> ⚠️ **注意**：`git add .` 会暂存**所有**变更，包括删除的文件。

## 💾 4. 提交到版本库

```bash
# 提交暂存区的文件（-m 后面是提交信息）
git commit -m "提交描述"

# 示例
git commit -m "修复登录页面样式问题"

# 把已追踪文件的修改直接提交（跳过 git add）
git commit -am "快速提交"

# 修改最后一次提交（追加忘记的文件/修改提交信息）
git commit --amend
```

**输出示例**：
```
[master 3d5a7b2] 修复登录页面样式问题
 1 file changed, 5 insertions(+), 2 deletions(-)
```

| 输出项 | 含义 |
|--------|------|
| `3d5a7b2` | 提交的 hash ID（版本号） |
| `1 file changed` | 修改了 1 个文件 |
| `5 insertions(+)` | 新增 5 行 |
| `2 deletions(-)` | 删除 2 行 |

## 📜 5. 查看历史记录

```bash
# 查看完整提交历史
git log

# 简洁模式（每行一个提交）
git log --oneline

# 显示最近 5 次提交
git log -5

# 图形化显示分支
git log --graph --oneline --all

# 查看某个文件的历史
git log 文件名.py
```

**输出示例**：
```
commit 3d5a7b2c8a1e4f6d9b2c3e5f7a8b1c2d3e4f5a6
Author: Zhang San <zhangsan@email.com>
Date:   Mon Apr 6 10:30:00 2026

    修复登录页面样式问题
```

## 🔀 6. 查看差异

```bash
# 查看工作区 vs 暂存区（未暂存的修改）
git diff

# 查看暂存区 vs 最新提交（已暂存的修改）
git diff --staged

# 查看两个提交之间的差异
git diff commit_id1 commit_id2

# 查看某个文件的修改
git diff 文件名.py
```

**输出示例**：
```
diff --git a/app.py b/app.py
--- a/app.py                              # - 表示旧版本
+++ b/app.py                              # + 表示新版本
@@ -1,3 +1,4 @@                          # 变更位置
 # 原有代码
+这是新增的一行                           # 绿色 = 新增
-这是要删除的一行                          # 红色 = 删除
```

## 🗑️ 7. 删除文件

```bash
# 从 Git 暂存区和工作区同时删除
git rm 文件名.py

# 只从暂存区删除（保留工作区文件）
git rm --cached 文件名.py

# 强制删除已修改的文件
git rm -f 文件名.py

# 删除目录
git rm -r 目录名/
```

## 📁 8. 重命名/移动文件

```bash
# 重命名文件
git mv 旧文件名.py 新文件名.py

# 移动文件
git mv 文件.py 目录名/

# 等价于手动操作：
mv old.py new.py
git rm old.py
git add new.py
```

## ⏪ 9. 撤销操作

### 🧹 9.1 撤销工作区修改（未 add）

```bash
# 丢弃单个文件的修改（不可恢复！）
git checkout -- 文件名.py

# 新版 Git 推荐写法
git restore 文件名.py
```

**示例**：
```
$ git status
    modified:   README.md      # 红色 = 未暂存的修改

$ git checkout -- README.md   # 丢弃修改

$ git status
nothing to commit, working directory clean   # 干净了！
```

> ⚠️ **警告**：此操作不可恢复！请确认后再执行。⛔

### 🔙 9.2 撤销暂存区（已 add 但未 commit）

```bash
# 把文件从暂存区移回工作区
git reset HEAD 文件名.py

# 新版 Git 推荐写法
git restore --staged 文件名.py
```

### ⏰ 9.3 回退版本

### 📊 三种模式对比（重点理解）🌟

| 模式 | 工作区 | 暂存区 | 版本库 | 安全程度 |
|------|--------|--------|--------|----------|
| `--soft` | ✅ 保留修改 | ✅ 保留暂存 | 回退 | ⭐ 最安全 |
| `--mixed` (默认) | ✅ 保留修改 | ❌ 清空暂存 | 回退 | ⭐⭐ 中等 |
| `--hard` | ❌ **丢弃修改** | ❌ 清空暂存 | 回退 | ⚠️ **最危险** |

```bash
# 查看 git log 获取 commit ID
git log --oneline

# 回退到指定版本（mixed模式，默认）
git reset commit_id

# 强制回退（hard模式，丢失所有未提交修改！慎用！）
git reset --hard commit_id

# 软回退（soft模式，修改保留在暂存区）
git reset --soft commit_id

# 回退到上一个版本
git reset --hard HEAD~1
```

**输出示例**：
```
$ git reset c495a77
Unstaged changes after reset:
M       README.md          # M 表示修改被保留在工作区
```

> ⚠️ **警告**：`git reset --hard` 会永久丢失未提交的修改，使用前务必确认！🎯

### 🗺️ 9.4 撤销操作决策树

```
我想要撤销...
│
├─ 只撤销某个文件的修改？
│   └── git checkout -- 文件名  或  git restore 文件名
│
├─ 撤销 git add（不想提交了）？
│   └── git reset HEAD 文件名  或  git restore --staged 文件名
│
├─ 撤销最近的 commit（想重写提交信息）？
│   └── git commit --amend
│
├─ 回退到很久以前的版本？
│   ├── 保留修改 → git reset commit_id
│   └── 丢弃修改 → git reset --hard commit_id（危险！）
│
└─ 看看历史版本的代码？
    └── git checkout commit_id（分离头指针，只读查看）
```

## 🎒 10. 暂存工作（临时保存）

🎯 当你需要切换分支，但当前修改还没完成时：

```bash
# 暂存当前所有修改
git stash

# 暂存时添加描述
git stash save "未完成的新功能"

# 查看暂存列表
git stash list

# 恢复最近的暂存（并删除暂存记录）
git stash pop

# 恢复指定的暂存（保留暂存记录）
git stash apply stash@{0}

# 删除暂存
git stash drop stash@{0}
```

## 🌿 11. 分支操作

### 🌱 11.1 创建和切换分支

```bash
# 查看所有分支（* 表示当前分支）
git branch

# 创建新分支
git branch 分支名

# 切换到指定分支
git checkout 分支名

# 新版 Git 推荐：切换分支
git switch 分支名

# 创建并切换到新分支（一行搞定）
git checkout -b 新分支名

# 新版 Git 推荐
git switch -c 新分支名
```

### ❌ 11.2 删除分支

```bash
# 删除已合并的分支（安全删除）
git branch -d 分支名

# 强制删除分支（不管是否合并）
git branch -D 分支名
```

## 🔀 12. 分支合并

### 🤝 12.1 git merge - 三路合并（最常用）

🎯 找到两个分支的**最近共同祖先**，将指定分支在 base 之后的所有变更一次性合到当前分支。

```
       A --- B --- C (master)
              \
               D --- E (feature)
                      ↑
        merge 后：把 D、E 的变更合到 master 上

结果：
       A --- B --- C --- F (master, 合并提交F)
                    \
                     D --- E (feature)
```

```bash
# 将 bugfix_branch_1 合并到当前分支
git merge bugfix_branch_1
```

**输出解读**：

```
$ git merge bugfix_branch_1

Updating 47cb197..03d0419
Fast-forward                          # 快进合并（没有冲突）
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

### ⚡ 12.2 冲突处理

当两个分支修改了同一个文件的同一行时，会产生**冲突**：

```
<<<<<<< HEAD
当前分支的内容
=======
要合并分支的内容
>>>>>>> bugfix_branch_1
```

**解决步骤**：
```bash
# 1. 手动编辑冲突文件，选择保留的内容
vim 冲突文件.py

# 2. 标记为已解决
git add 冲突文件.py

# 3. 完成合并
git commit -m "解决冲突，合并bugfix"
```

### 📐 12.3 git rebase - 变基合并

🎯 把当前分支的提交**重新"嫁接"**到目标分支的最新位置上，让历史变成一条直线。

```
# merge 结果（有分叉）
       A --- B --- C --- M (master)     ← M 是合并提交
                \         /
                 D --- E (feature)

# rebase 结果（线性）
       A --- B --- C --- D' --- E' (feature)  ← D', E' 是重新应用的提交
```

```bash
# 将当前分支变基到 master 上
git rebase master

# 示例输出
$ git rebase master
First, rewinding head to replay your work on top of that...
Applying: Update README.md
Applying: nginx config edit
```

### ⚖️ 12.4 merge vs rebase 对比

| 特性 | `git merge` | `git rebase` |
|------|-------------|--------------|
| 历史记录 | 有分叉，保留真实历史 | 线性，历史整洁 |
| 额外提交 | 生成合并提交（Merge commit） | 无额外提交 |
| 安全性 | 更安全，不易出问题 | 较危险，改写了历史 |
| 适用场景 | 公共分支、团队协作 | 个人本地分支整理 |
| 冲突处理 | 一次性解决 | 可能逐个提交解决 |

> 💡 **经验法则**：公共分支用 **merge**，本地个人分支整理用 **rebase** ✨

## ☁️ 13. 远程仓库操作

```bash
# 查看远程仓库
git remote -v

# 添加远程仓库
git remote add origin https://github.com/user/repo.git

# 推送到远程
git push origin master

# 推送所有分支
git push -u origin --all

# 从远程拉取
git pull origin master

# 克隆远程仓库
git clone https://github.com/user/repo.git
```

---