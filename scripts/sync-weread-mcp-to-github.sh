# ===================================================================
# WeRead-MCP GitHub 同步脚本
# ===================================================================
# 功能: 将 WeRead-MCP 子模块内容同步到 GitHub
#
# 前置条件: GitHub CLI (gh) 已安装并登录
#   gh auth login
#
# 工作流程:
#   进入子模块 → 检查变更 → 提交 → 推送到 GitHub
#
# 一键运行:
#   bash /workspace/scripts/sync-weread-mcp-to-github.sh
# ===================================================================

set -e

SUBMODULE_PATH="Repo/WeRead-MCP"
GITHUB_REMOTE="origin"

# 同步提交作者/提交者信息（用 QQ 邮箱以记录 GitHub 贡献）
export GIT_AUTHOR_NAME="Stelquis"
export GIT_AUTHOR_EMAIL="3420761503@qq.com"
export GIT_COMMITTER_NAME="Stelquis"
export GIT_COMMITTER_EMAIL="3420761503@qq.com"

echo "=== 同步 WeRead-MCP 到 GitHub ==="

# -------------------------------------------------------------------
# 0. 检查并安装 GitHub CLI
# -------------------------------------------------------------------
if ! command -v gh &>/dev/null; then
    echo "🔧 未检测到 GitHub CLI，正在安装..."

    DOWNLOADER=""
    if command -v curl &>/dev/null; then
        DOWNLOADER="curl -fsSL -o"
    elif command -v wget &>/dev/null; then
        DOWNLOADER="wget -qO"
    else
        echo "❌ 未找到 curl 或 wget，请先安装其中之一: apt-get install -y curl"
        exit 1
    fi

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

    if ! command -v gh &>/dev/null; then
        echo "❌ gh CLI 安装失败，请手动安装后重试"
        exit 1
    fi
    echo "✅ gh CLI 安装完成（$(gh --version)）"
fi

# 检查是否已登录 GitHub
echo "🔍 检查 GitHub 登录状态..."
if ! gh auth status &>/dev/null; then
    echo "🔐 未登录 GitHub，正在启动交互式登录..."
    echo "   请按提示选择: GitHub.com → HTTPS → Login with a web browser"
    gh auth login --hostname github.com --git-protocol https --web
    echo "✅ 登录成功"
fi
echo "✅ 已登录 GitHub: $(gh auth status 2>&1 | head -1)"

# -------------------------------------------------------------------
# 1. 进入子模块目录
# -------------------------------------------------------------------
cd "$(dirname "$0")/../${SUBMODULE_PATH}"

echo "📂 进入子模块: $(pwd)"

# 确保 git 使用 gh CLI 的登录凭证
gh auth setup-git -h github.com
export GIT_TERMINAL_PROMPT=0

# -------------------------------------------------------------------
# 2. 检查是否有变更需要提交
# -------------------------------------------------------------------
if [ -z "$(git status --porcelain)" ]; then
    echo "⏭️  没有未提交的变更"
else
    echo "📝 检测到变更，提交中..."
    git add -A
    git -c commit.gpgsign=false commit -m "chore: sync update $(date '+%Y-%m-%d %H:%M')"
    echo "✅ 已提交"
fi

# -------------------------------------------------------------------
# 3. 推送到 GitHub
# -------------------------------------------------------------------
echo "📤 推送到 GitHub..."
git push "$GITHUB_REMOTE" main

echo ""
echo "✅ 同步完成！"
echo "   GitHub: https://github.com/Stelquis/WeRead-MCP"