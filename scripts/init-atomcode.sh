#!/usr/bin/env bash
# ===================================================================
# AtomCode AI 编程助手 一键初始化脚本（终端 TUI）
# ===================================================================
# 功能: 一键打通「安装 → 登录 → 启动」，自动检测（已装/已登录则跳过），最后启动终端 TUI
# 安装源: https://raw.atomgit.com/atomgit_atomcode/atomcode/raw/main/scripts/install.sh
# 用法:
#   bash scripts/init-atomcode.sh
# 升级: atomcode upgrade
# ===================================================================

set -e

INSTALL_URL="https://raw.atomgit.com/atomgit_atomcode/atomcode/raw/main/scripts/install.sh"

# -----------------------------------------------------------------------------
# 工具函数
# -----------------------------------------------------------------------------
info() { echo "    $*"; }
ok()   { echo "    ✅ $*"; }
fail() { echo "    ❌ $*" >&2; }

# 定位 atomcode（PATH + 常见路径），必要时将所在目录补入 PATH
ensure_in_path() {
    hash -r 2>/dev/null || true

    if command -v atomcode >/dev/null 2>&1; then
        return 0
    fi

    local candidate
    for candidate in \
        "$HOME/.local/bin/atomcode" \
        "$HOME/.atomcode/bin/atomcode" \
        "$HOME/bin/atomcode" \
        "/usr/local/bin/atomcode" \
        "/opt/atomcode/bin/atomcode"; do
        if [ -x "$candidate" ]; then
            case ":$PATH:" in
                *":$(dirname "$candidate"):"*) ;;              # 已在 PATH
                *) PATH="$(dirname "$candidate"):$PATH" ;;      # 补入 PATH
            esac
            export PATH
            info "已将 $(dirname "$candidate") 加入 PATH"
            return 0
        fi
    done

    return 1
}

# -----------------------------------------------------------------------------
# 第一步: 检测安装状态，未安装才执行安装
# -----------------------------------------------------------------------------
echo "=== AtomCode 安装与初始化（终端 TUI）==="

if ensure_in_path; then
    ok "已安装，跳过安装"
else
    echo "📦 未检测到 AtomCode，开始安装..."
    curl -fsSL "$INSTALL_URL" | sh
    ensure_in_path || { fail "安装完成但未找到 atomcode，请检查安装日志"; exit 1; }
    ok "安装完成"
fi

# -----------------------------------------------------------------------------
# 第二步: 登录检查（AtomGit OAuth）
# -----------------------------------------------------------------------------
if atomcode status 2>/dev/null | grep -qi "logged in"; then
    ok "已登录，跳过登录"
else
    echo "🔑 未登录，启动 OAuth 登录（按提示完成）..."
    atomcode login || { fail "登录未完成，稍后可手动执行: atomcode login"; }
fi

# -----------------------------------------------------------------------------
# 第三步: 启动 atomcode 终端交互会话
# -----------------------------------------------------------------------------
echo "🚀 启动 AtomCode..."
exec atomcode
