# ===================================================================
# WeRead-MCP Gitee 同步脚本
# ===================================================================
# 功能: 将 WeRead-MCP 子模块内容同步到 Gitee
#
# 前置条件: 有 Gitee 私人令牌（运行时会提示输入，不保存到文件）
#
# 如何获取私人令牌:
#   1. 登录 Gitee → 右上角头像 → 设置
#   2. 左侧菜单 → 私人令牌
#   3. 点击"生成新令牌"，勾选以下权限:
#      - projects（仓库相关操作）
#      - user（获取用户信息）
#   4. 生成后复制令牌（仅显示一次，请妥善保存）
#
# 工作流程:
#   进入子模块 → 输入令牌 → 验证 → 创建仓库 → 推送到 Gitee
#
# 一键运行:
#   bash /workspace/scripts/sync-weread-mcp-to-gitee.sh
#
# 环境变量方式（可选，跳过交互）:
#   GITEE_TOKEN="xxx" bash /workspace/scripts/sync-weread-mcp-to-gitee.sh
# ===================================================================

set -e

SUBMODULE_PATH="Repo/WeRead-MCP"
GITEE_REMOTE="gitee"
GITEE_API="https://gitee.com/api/v5"

# 同步提交作者/提交者信息（用 QQ 邮箱以记录 GitHub 贡献）
export GIT_AUTHOR_NAME="Stelquis"
export GIT_AUTHOR_EMAIL="3420761503@qq.com"
export GIT_COMMITTER_NAME="Stelquis"
export GIT_COMMITTER_EMAIL="3420761503@qq.com"

echo "=== 同步 WeRead-MCP 到 Gitee ==="

# -------------------------------------------------------------------
# 0. 获取 Gitee 私人令牌（交互输入，不回显）
# -------------------------------------------------------------------
if [ -z "${GITEE_TOKEN:-}" ]; then
    printf "🔐 请输入 Gitee 私人令牌: "
    read -r GITEE_TOKEN
fi

if [ -z "$GITEE_TOKEN" ]; then
    echo "❌ 令牌不能为空"
    exit 1
fi

# -------------------------------------------------------------------
# 1. 验证令牌，获取用户名
# -------------------------------------------------------------------
echo "🔍 验证 Gitee 令牌..."
GITEE_USER=$(curl -s -H "Authorization: token $GITEE_TOKEN" "${GITEE_API}/user" | python3 -c "import sys,json; print(json.load(sys.stdin).get('login',''))" 2>/dev/null)
if [ -z "$GITEE_USER" ]; then
    echo "❌ 令牌无效或网络错误"
    exit 1
fi
echo "✅ 已登录 Gitee: $GITEE_USER"

# -------------------------------------------------------------------
# 2. 进入子模块目录
# -------------------------------------------------------------------
cd "$(dirname "$0")/../${SUBMODULE_PATH}"

echo "📂 进入子模块: $(pwd)"

# -------------------------------------------------------------------
# 3. 推断仓库名（使用子模块目录名）
# -------------------------------------------------------------------
REPO_NAME="WeRead-MCP"
echo "📦 目标仓库: https://gitee.com/${GITEE_USER}/${REPO_NAME}"

# -------------------------------------------------------------------
# 4. 检查/创建 Gitee 仓库
# -------------------------------------------------------------------
echo "🔍 检查 Gitee 仓库是否存在..."
REPO_EXISTS=$(curl -s -o /dev/null -w "%{http_code}" -H "Authorization: token $GITEE_TOKEN" "${GITEE_API}/repos/${GITEE_USER}/${REPO_NAME}")
if [ "$REPO_EXISTS" = "200" ]; then
    echo "✅ 仓库已存在"
else
    echo "🔧 创建 Gitee 仓库..."
    CREATE_RESP=$(curl -s -X POST -H "Authorization: token $GITEE_TOKEN" -H "Content-Type: application/json" \
        -d "{\"name\":\"${REPO_NAME}\",\"private\":\"false\"}" \
        "${GITEE_API}/user/repos")
    echo "$CREATE_RESP" | python3 -c "import sys,json; d=json.load(sys.stdin); print('✅ 仓库已创建:', d.get('html_url','?'))" 2>/dev/null || echo "✅ 仓库已创建"
fi

# -------------------------------------------------------------------
# 5. 配置 Gitee remote（用 credential helper 避免 token 出现在 URL 中）
# -------------------------------------------------------------------
TARGET_URL="https://gitee.com/${GITEE_USER}/${REPO_NAME}.git"

# 禁止 git 弹窗索要密码
export GIT_TERMINAL_PROMPT=0

# 使用临时 credential helper，token 不落盘也不出现在 URL 中
CRED_FILE=$(mktemp)
trap "rm -f '$CRED_FILE'" EXIT
printf 'url=%s\nusername=oauth2\npassword=%s\n' "$TARGET_URL" "$GITEE_TOKEN" > "$CRED_FILE"
git config --local credential.helper "store --file=$CRED_FILE"

# 清理旧的 gitee remote
git remote remove "$GITEE_REMOTE" 2>/dev/null || true
git remote add "$GITEE_REMOTE" "$TARGET_URL"
echo "✅ Gitee remote 已配置"

# 确保 git 使用 credential helper
gh auth setup-git -h github.com 2>/dev/null || true

# -------------------------------------------------------------------
# 6. 推送到 Gitee
# -------------------------------------------------------------------
echo "📤 推送到 Gitee..."
git push "$GITEE_REMOTE" main

# 清理临时 credential helper
git config --local --unset credential.helper 2>/dev/null || true
rm -f "$CRED_FILE"

echo ""
echo "✅ 同步完成！"
echo "   GitHub: https://github.com/Stelquis/WeRead-MCP"
echo "   Gitee:  https://gitee.com/${GITEE_USER}/${REPO_NAME}"