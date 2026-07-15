# ===================================================================
# GitHub 同步脚本
# ===================================================================
# 功能: 将 CNB main 分支内容同步到 GitHub
#
# 前置条件: GitHub CLI (gh) 已安装并登录
#   gh auth login
#
# 自动推断目标仓库: {当前登录用户}/{本地仓库名}
#   无需手动配置，fork 用户登录自己的 GitHub 账号即可自动同步到自己的仓库。
#
# 工作流程:
#   安装 gh CLI → 登录 → 推断仓库 → 配置 remote → 快照同步 → push → 切回 main
#
# 一键运行:
#   bash /workspace/scripts/sync-to-github.sh
#
# 覆盖目标仓库（可选）:
#   GITHUB_REPO="OtherUser/OtherRepo" bash /workspace/scripts/sync-to-github.sh
# ===================================================================

set -e

# -------------------------------------------------------------------
# 配置区
# -------------------------------------------------------------------

GITHUB_REMOTE="github"
SYNC_BRANCH="github-main"

# 同步提交作者信息（author 用 QQ 邮箱以记录 GitHub 贡献）
# 注意：committer 必须保持 CNB noreply 邮箱，否则 cnb-gpgsign 签名会 403
export GIT_AUTHOR_NAME="Stelquis"
export GIT_AUTHOR_EMAIL="3420761503@qq.com"

echo "=== 同步到 GitHub ==="

# -------------------------------------------------------------------
# 0. 检查并安装 GitHub CLI
# -------------------------------------------------------------------
if ! command -v gh &>/dev/null; then
    echo "🔧 未检测到 GitHub CLI，正在安装..."

    # 适配容器环境：优先用 curl（比 wget 更常见），没有 curl 才用 wget
    DOWNLOADER=""
    if command -v curl &>/dev/null; then
        DOWNLOADER="curl -fsSL -o"
    elif command -v wget &>/dev/null; then
        DOWNLOADER="wget -qO"
    else
        echo "❌ 未找到 curl 或 wget，请先安装其中之一: apt-get install -y curl"
        exit 1
    fi

    # 添加 GitHub CLI 官方 apt 源
    mkdir -p -m 755 /etc/apt/keyrings
    case "$DOWNLOADER" in
        curl*) $DOWNLOADER /etc/apt/keyrings/githubcli-archive-keyring.gpg \
            https://cli.github.com/packages/githubcli-archive-keyring.gpg ;;
        wget*) $DOWNLOADER- /etc/apt/keyrings/githubcli-archive-keyring.gpg \
            https://cli.github.com/packages/githubcli-archive-keyring.gpg ;;
    esac

    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
        | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

    apt-get update && apt-get install -y gh && rm -rf /var/lib/apt/lists/*

    # 装完了验证一下
    if ! command -v gh &>/dev/null; then
        echo "❌ gh CLI 安装失败，请手动安装后重试"
        exit 1
    fi
    echo "✅ gh CLI 安装完成（$(gh --version)）"
fi

# 检查是否已登录 GitHub，未登录则引导登录
echo "🔍 检查 GitHub 登录状态..."
if ! gh auth status &>/dev/null; then
    echo "🔐 未登录 GitHub，正在启动交互式登录..."
    echo "   请按提示选择: GitHub.com → HTTPS → Login with a web browser"
    gh auth login --hostname github.com --git-protocol https --web
    echo "✅ 登录成功"
fi
echo "✅ 已登录 GitHub: $(gh auth status 2>&1 | head -1)"

# -------------------------------------------------------------------
# 1. 推断目标 GitHub 仓库
# -------------------------------------------------------------------
# 如果环境变量 GITHUB_REPO 已设置则直接使用，否则自动推断：
#   {gh 当前登录用户}/{本地 git 仓库名}
if [ -z "${GITHUB_REPO:-}" ]; then
    GITHUB_USER=$(gh api user --jq '.login' 2>/dev/null)
    REPO_NAME=$(git remote get-url origin 2>/dev/null | sed 's|.*/||; s|\.git$||')
    GITHUB_REPO="${GITHUB_USER}/${REPO_NAME}"
fi
echo "📦 目标仓库: https://github.com/${GITHUB_REPO}"

# -------------------------------------------------------------------
# 2. 初始化 GitHub remote，配置 gh 为 git 凭证助手
# -------------------------------------------------------------------
# 禁止 git 弹窗索要密码（防止 hang），失败即报错
export GIT_TERMINAL_PROMPT=0

# 确保 git 使用 gh CLI 的登录凭证
gh auth setup-git -h github.com

TARGET_URL="https://github.com/${GITHUB_REPO}.git"

# 设置或校验 GitHub remote
if CURRENT_URL=$(git remote get-url "$GITHUB_REMOTE" 2>/dev/null); then
    if [ "$CURRENT_URL" != "$TARGET_URL" ]; then
        echo "🔧 GitHub remote URL 不匹配，更新为: $TARGET_URL"
        git remote set-url "$GITHUB_REMOTE" "$TARGET_URL"
    fi

    # 无论 remote 是否匹配，都用 gh repo view 确认远程仓库真实存在
    # 防止用户手动删除了 GitHub 仓库但本地 remote 残留
    if ! gh repo view "$GITHUB_REPO" &>/dev/null; then
        echo "🔧 GitHub 仓库不存在（可能已被手动删除），重新创建..."
        gh repo create "$GITHUB_REPO" --public --source=. --remote="$GITHUB_REMOTE" --push-unsafe
        echo "✅ GitHub 仓库已重新创建"
    else
        echo "✅ GitHub remote 已存在且远程仓库有效"
    fi
else
    echo "🔧 配置 GitHub remote..."

    # 确保 GitHub 仓库存在（不存在则创建，公开仓库）
    gh repo view "$GITHUB_REPO" &>/dev/null || \
        gh repo create "$GITHUB_REPO" --public --source=. --remote="$GITHUB_REMOTE"

    # 如果 remote 仍不存在，手动添加
    if ! git remote get-url "$GITHUB_REMOTE" &>/dev/null; then
        git remote add "$GITHUB_REMOTE" "$TARGET_URL"
    fi

    echo "✅ GitHub remote 已配置"
fi

# -------------------------------------------------------------------
# 3. 执行同步引擎
# -------------------------------------------------------------------
# 参数: $1=显示名称, $2=remote名, $3=同步分支名, $4=目标仓库URL
sync_to_remote() {
    local DISPLAY_NAME="$1" REMOTE="$2" SYNC_BRANCH="$3" REPO_URL="$4"

    local REMOTE_HEAD
    REMOTE_HEAD=$(git ls-remote "$REMOTE" HEAD 2>/dev/null | awk '{print $1}')

    git branch -D "$SYNC_BRANCH" 2>/dev/null || true

    if [ -n "$REMOTE_HEAD" ]; then
        echo "🔧 ${DISPLAY_NAME} 已有历史，拉取元数据..."
        git fetch --depth=1 --filter=blob:none "$REMOTE" main

        local CNB_TREE REMOTE_TREE
        CNB_TREE=$(git rev-parse main^{tree})
        REMOTE_TREE=$(git rev-parse "${REMOTE}/main^{tree}")
        if [ "$CNB_TREE" = "$REMOTE_TREE" ]; then
            echo "⏭️  没有新变更（树 hash 一致），跳过推送"
            exit 0
        fi

        git checkout -b "$SYNC_BRANCH" main
        git reset --soft "${REMOTE}/main"
        git -c commit.gpgsign=false commit -m "$(date '+%Y-%m-%d %H:%M')"
    else
        echo "🔧 ${DISPLAY_NAME} 为空仓库，创建孤儿分支全量提交..."
        git checkout --orphan "$SYNC_BRANCH"
        git rm -rf --quiet . 2>/dev/null || true
        git -c commit.gpgsign=false commit --allow-empty -m "root"
        git checkout main -- .
        git add -A
        git -c commit.gpgsign=false commit -m "$(date '+%Y-%m-%d %H:%M')"
    fi

    echo "📤 推送到 ${DISPLAY_NAME}..."
    git push "$REMOTE" "${SYNC_BRANCH}:main"
    git checkout main

    echo ""
    echo "✅ 同步完成！"
    echo "   origin (cnb.cool): 不受影响"
    echo "   ${DISPLAY_NAME}: ${REPO_URL}"
}

sync_to_remote "GitHub" "$GITHUB_REMOTE" "$SYNC_BRANCH" "https://github.com/${GITHUB_REPO}"