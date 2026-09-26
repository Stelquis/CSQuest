# 子模块从 CNB 同步到 GitHub 和 Gitee（通用指南）

本文档记录在 CNB（cnb.cool）托管的仓库中管理 git submodule，并将其同步推送到 GitHub / Gitee 的通用流程与注意事项。文中 `<子模块路径>`、`<远程仓库URL>`、`<用户名>`、`<邮箱>` 等均为占位符，使用时替换为实际值。

---

## 一、子模块 vs 普通目录

### 对比

| 维度 | 子模块（Submodule） | 普通目录 |
|------|:---:|:---:|
| 独立 Git 仓库 | ✅ 有 `.git` | ❌ 无 |
| 远程仓库 | ✅ 独立 remote | ❌ 无 |
| 父仓库跟踪方式 | 只记录 gitlink 指针（commit hash） | 直接跟踪所有文件 |
| 独立开发 | ✅ 可独立提交、推送 | ❌ 必须通过父仓库 |
| `.gitmodules` 注册 | ✅ 需要 | ❌ 不需要 |

### 判断一个目录是否为子模块

```bash
# 查看 .gitmodules 文件
cat .gitmodules

# 查看子模块状态
git submodule status

# 查看一个目录是否被父仓库直接跟踪（有 blob hash 就是直接跟踪）
git ls-tree HEAD -- <目录名>/
# 输出 mode 160000 表示子模块，其他表示普通文件
```

---

## 二、将普通目录转换为子模块

### 步骤

#### 1. 初始化子模块独立仓库

```bash
cd <子模块路径>
git init
git add -A
git commit -m "chore: initialize repository"
git branch -m master main
```

#### 2. 在 GitHub 上创建远程仓库

```bash
# 用 gh CLI 创建（需先登录）
gh repo create <仓库名> --public --remote origin --source=. --push
```

#### 3. 在父仓库中替换为子模块

```bash
# 从父仓库中移除直接跟踪的文件
git rm -r --cached <子模块路径>

# 临时移走目录（因为 submodule add 需要空目录）
mv <子模块路径> /tmp/备份

# 添加子模块
git submodule add <远程仓库URL> <子模块路径>

# 验证
git submodule status
```

#### 4. 更新 `.gitmodules`

`git submodule add` 会自动更新 `.gitmodules`，格式如下：

```ini
[submodule "<子模块路径>"]
    path = <子模块路径>
    url = <远程仓库URL>
```

---

## 三、同步作者 / 提交者信息

### 为什么需要设置？

GitHub 和 Gitee 的**贡献日历图**只认 Author 字段，且要求 Author 的邮箱与你 GitHub/Gitee 账号绑定的邮箱一致。

CNB 平台默认的 committer 是 `cnb <cnb@cnb.local>`，author 邮箱是 `@noreply.cnb.cool`，这些都不会被 GitHub/Gitee 识别。

### 修正本地 git config

```bash
cd <子模块路径>
git config user.name "<用户名>"
git config user.email "<邮箱>"
```

### 修正已有提交的 author 和 committer

```bash
# 修正最新提交的 author
git commit --amend --author="<用户名> <<邮箱>>" --no-edit

# author 和 committer 同时修改（需要环境变量覆盖）
GIT_COMMITTER_NAME="<用户名>" GIT_COMMITTER_EMAIL="<邮箱>" \
  git commit --amend --author="<用户名> <<邮箱>>" --no-edit
```

### 修正整个历史的 author（批量）

```bash
git filter-branch --msg-filter "grep -v '^Co-Authored-By:'" --force -- --all
```

> **注意**：`filter-branch` 会改写所有 commit hash，需要 force push，其他人需重新 clone。

---

## 四、同步脚本

### 脚本职责划分

| 脚本 | 同步对象 | 目标平台 |
|------|---------|---------|
| `sync-to-github.sh` | 父仓库 | GitHub |
| `sync-to-gitee.sh` | 父仓库 | Gitee |
| `sync-<子模块>-to-github.sh` | 各子模块 | GitHub |
| `sync-<子模块>-to-gitee.sh` | 各子模块 | Gitee |

### 脚本编写要点

所有同步脚本必须包含以下关键配置：

```bash
# 作者信息（用于 GitHub/Gitee 贡献图识别）
export GIT_AUTHOR_NAME="<用户名>"
export GIT_AUTHOR_EMAIL="<邮箱>"

# 提交者信息（也改为自己，不要留平台默认身份）
export GIT_COMMITTER_NAME="<用户名>"
export GIT_COMMITTER_EMAIL="<邮箱>"
```

### GitHub 同步脚本核心流程

```bash
cd <子模块路径>
git add -A
git commit -m "提交信息"
git push origin main
```

### Gitee 同步脚本核心流程

Gitee 使用私人令牌（Personal Access Token）进行身份验证，不能直接使用用户名密码。

```bash
# 1. 获取令牌（交互输入或环境变量）
# 2. 验证令牌（调用 Gitee API）
# 3. 创建/检查仓库
# 4. 配置临时 credential helper（避免 token 出现在 URL 中）
# 5. git push 到 Gitee
```

**使用方式：**

```bash
# 交互方式（输入 token）
bash sync-<子模块>-to-gitee.sh

# 环境变量方式（跳过交互）
GITEE_TOKEN="<token>" bash sync-<子模块>-to-gitee.sh
```

---

## 五、Gitee 私人令牌配置

### 获取令牌

1. 登录 Gitee → 右上角头像 → **设置**
2. 左侧菜单 → **私人令牌**
3. 点击"生成新令牌"，勾选以下权限：
   - `projects`（仓库相关操作）
   - `user`（获取用户信息）
4. 生成后复制令牌（**仅显示一次**，请妥善保存）

### 令牌安全

- 令牌保存在环境变量中，不要写入代码
- 脚本中使用临时 credential helper，token 不落盘
- 用完即清理

```bash
# 临时 credential helper 配置
CRED_FILE=$(mktemp)
trap "rm -f '$CRED_FILE'" EXIT
printf 'url=%s\nusername=oauth2\npassword=%s\n' "$TARGET_URL" "$GITEE_TOKEN" > "$CRED_FILE"
git config --local credential.helper "store --file=$CRED_FILE"
```

---

## 六、常见问题

### 6.1 提交信息中不要有 Co-Authored-By

AI 编码助手可能会自动在提交信息末尾添加 `Co-Authored-By: ...` 行。如果不需要协作者，务必移除。

**检查方法：**

```bash
git log --all --oneline --grep="Co-Authored-By"
```

**批量移除：**

```bash
git filter-branch --msg-filter "grep -v '^Co-Authored-By:'" --force -- --all
```

### 6.2 GitHub 贡献图不显示提交

原因：Author 邮箱与 GitHub 账号绑定的邮箱不匹配。

**检查方法：**

```bash
git log -1 --format="Author: %an <%ae>%nCommitter: %cn <%ce>"
```

**修复：** 确保 Author 邮箱与 GitHub 设置中的邮箱一致（Settings → Emails）。

### 6.3 force push 后其他人拉取失败

`filter-branch` 或 `--amend` 会改变 commit hash，force push 后其他人需要：

```bash
git fetch --all
git reset --hard origin/main
```

### 6.4 子模块指针未更新

父仓库跟踪子模块的方式是记录一个 commit hash（gitlink）。如果子模块有新的提交，父仓库的指针不会自动更新，需要手动：

```bash
git add <子模块路径>
git commit -m "chore: update submodule pointer"
```

### 6.5 删除 filter-branch 备份

`git filter-branch` 会在 `refs/original/` 下创建备份，需要清理：

```bash
git for-each-ref --format='%(refname)' refs/original/ | while read ref; do git update-ref -d "$ref"; done
```

### 6.6 编译产物不入库

子模块如果包含需要编译的项目（Rust/Node/Python 等），构建产物（`target/`、`node_modules/`、`dist/` 等）**绝不能提交进仓库**：

- 确认子模块自己的 `.gitignore` 覆盖了构建目录（如 `target/`）
- 若 `.gitignore` 缺失，在**子模块仓库内**添加并提交（`.gitignore` 跟随子模块自身，而非父仓库）
- 新环境克隆子模块后，按项目说明重新构建（如 `cargo build --release`）

---

## 七、完整工作流程示例

### 日常开发流程

```bash
# 1. 在子模块中开发
cd <子模块路径>
# ... 修改代码 ...

# 2. 提交到子模块
git add -A
git commit -m "feat: 新功能"
git push origin main

# 3. 回到父仓库，更新子模块指针
git add <子模块路径>
git commit -m "chore: update submodule"
git push origin main

# 4. 同步到 Gitee
GITEE_TOKEN="<token>" bash sync-<子模块>-to-gitee.sh
```

### 从零开始新子模块

```bash
# 1. 创建目录并初始化为独立仓库
mkdir -p <子模块路径>
cd <子模块路径>
git init
git add -A
git commit -m "chore: initialize"
git branch -m main

# 2. 创建 GitHub 远程
gh repo create <仓库名> --public --remote origin --source=. --push

# 3. 父仓库中转为子模块
git rm -r --cached <子模块路径>
mv <子模块路径> /tmp/backup
git submodule add <远程仓库URL> <子模块路径>
git add .gitmodules <子模块路径>
git commit -m "refactor: convert <子模块名> to submodule"
git push origin main

# 4. 按需编写 Gitee 同步脚本（参照第八节模板）
```

---

## 八、脚本模板

### 子模块 GitHub 同步脚本模板

```bash
#!/bin/bash
set -e

SUBMODULE_PATH="<子模块路径>"
GITHUB_REMOTE="origin"

export GIT_AUTHOR_NAME="<用户名>"
export GIT_AUTHOR_EMAIL="<邮箱>"
export GIT_COMMITTER_NAME="<用户名>"
export GIT_COMMITTER_EMAIL="<邮箱>"

cd "$(dirname "$0")/../${SUBMODULE_PATH}"

if [ -z "$(git status --porcelain)" ]; then
    echo "⏭️ 没有变更"
    exit 0
fi

git add -A
git -c commit.gpgsign=false commit -m "chore: sync update $(date '+%Y-%m-%d %H:%M')"
git push "$GITHUB_REMOTE" main
echo "✅ 同步完成"
```

### 子模块 Gitee 同步脚本模板

```bash
#!/bin/bash
set -e

SUBMODULE_PATH="<子模块路径>"
GITEE_REMOTE="gitee"
GITEE_API="https://gitee.com/api/v5"

export GIT_AUTHOR_NAME="<用户名>"
export GIT_AUTHOR_EMAIL="<邮箱>"
export GIT_COMMITTER_NAME="<用户名>"
export GIT_COMMITTER_EMAIL="<邮箱>"

# 获取令牌
if [ -z "${GITEE_TOKEN:-}" ]; then
    printf "🔐 请输入 Gitee 私人令牌: "
    read -r GITEE_TOKEN
fi

# 验证令牌
GITEE_USER=$(curl -s -H "Authorization: token $GITEE_TOKEN" "${GITEE_API}/user" | python3 -c "import sys,json; print(json.load(sys.stdin).get('login',''))")

cd "$(dirname "$0")/../${SUBMODULE_PATH}"

# 创建或更新仓库（按需实现）
# ...

git push "$GITEE_REMOTE" main
echo "✅ 同步完成"
```

---

## 九、关键命令速查

```bash
# 子模块操作
git submodule status                          # 查看子模块状态
git submodule add <url> <path>                # 添加子模块
git submodule update --init                   # 初始化/更新子模块
git submodule update --remote                 # 更新子模块到最新

# 提交信息
git log --format="Author: %an <%ae>%nCommitter: %cn <%ce>"  # 查看作者/提交者
git commit --amend --author="name <email>" -m "msg"         # 修正作者
git filter-branch --msg-filter "grep -v '^Co-Authored-By:'" # 批量移除协作者

# 远程
git remote -v                                 # 查看远程
git remote add <name> <url>                   # 添加远程
git push origin main --force                  # 强制推送（慎用）

# 工具
gh auth status                                # 检查 GitHub 登录
gh repo create <name> --public --remote origin # 创建 GitHub 仓库
```

---

## 十、注意事项

1. **不要自动推送** — 提交前先在子模块内运行构建/测试验证（如 `cargo check`、`npm test`），确认无误再推送
2. **Author 邮箱必须匹配** — GitHub/Gitee 贡献图只认 Author 邮箱，必须与平台绑定邮箱一致
3. **Committer 也要改** — 不要留平台默认身份，全部改为用户身份
4. **不要有 Co-Authored-By** — 除非用户明确要求，否则提交信息中不要有协作者标记
5. **force push 要谨慎** — 改写历史后需要 force push，会影响其他人
6. **Gitee token 不落盘** — 使用临时 credential helper，用完即清理
7. **子模块指针手动更新** — 父仓库不会自动跟踪子模块的新提交，需要手动 `git add` 更新
8. **编译产物不入库** — 构建产物由子模块自身的 `.gitignore` 排除，新环境克隆后重新构建
