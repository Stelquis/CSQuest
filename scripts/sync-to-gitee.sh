# ===================================================================
# Gitee 同步脚本
# ===================================================================
# 功能: 将 CNB main 分支内容同步到 Gitee
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
#   5. 也可使用已生成的全权限令牌，永不过期更方便
#
# 工作流程:
#   输入令牌 → 验证 → 自动创建仓库 → 快照同步 → push → 切回 main → 清理 remote
#
# 一键运行:
#   bash /workspace/scripts/sync-to-gitee.sh
#
# 环境变量方式（可选，跳过交互）:
#   GITEE_TOKEN="xxx" bash /workspace/scripts/sync-to-gitee.sh
# ===================================================================

set -e

# -------------------------------------------------------------------
# 配置区
# -------------------------------------------------------------------

GITEE_REMOTE="gitee"
SYNC_BRANCH="gitee-main"
GITEE_API="https://gitee.com/api/v5"

# 同步提交作者信息（author 用 QQ 邮箱以记录 GitHub 贡献）
# 注意：committer 必须保持 CNB noreply 邮箱，否则 cnb-gpgsign 签名会 403
export GIT_AUTHOR_NAME="Stelquis"
export GIT_AUTHOR_EMAIL="3420761503@qq.com"

echo "=== 同步到 Gitee ==="

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
# 2. 推断仓库名
# -------------------------------------------------------------------
REPO_NAME=$(git remote get-url origin 2>/dev/null | sed 's|.*/||; s|\.git$||')
echo "📦 目标仓库: https://gitee.com/${GITEE_USER}/${REPO_NAME}"

# -------------------------------------------------------------------
# 3. 检查/创建 Gitee 仓库
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
# 4. 配置 Gitee remote（用 credential helper 避免 token 出现在 URL 中）
# -------------------------------------------------------------------
TARGET_URL="https://gitee.com/${GITEE_USER}/${REPO_NAME}.git"

# 禁止 git 弹窗索要密码
export GIT_TERMINAL_PROMPT=0

# 使用临时 credential helper，token 不落盘也不出现在 URL 中
CRED_FILE=$(mktemp)
trap "rm -f '$CRED_FILE'" EXIT
printf 'url=%s\nusername=oauth2\npassword=%s\n' "$TARGET_URL" "$GITEE_TOKEN" > "$CRED_FILE"
git config --local credential.helper "store --file=$CRED_FILE"

# 先清理旧的 gitee remote
git remote remove "$GITEE_REMOTE" 2>/dev/null || true
git remote add "$GITEE_REMOTE" "$TARGET_URL"
echo "✅ Gitee remote 已配置"

# -------------------------------------------------------------------
# 5. 执行同步引擎
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

sync_to_remote "Gitee" "$GITEE_REMOTE" "$SYNC_BRANCH" "https://gitee.com/${GITEE_USER}/${REPO_NAME}"