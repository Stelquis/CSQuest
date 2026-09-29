# ===================================================================
# CodeBuddy Code 环境初始化
# 安装: npm install -g @tencent-ai/codebuddy-code (需要 Node.js 18.20+)
# 首次使用: 终端输入 codebuddy，选择 "Log in via Chinese Site" 登录
# ===================================================================
# 用法:
#   bash scripts/init-codebuddy.sh   安装 + 交互是否取消 CNB 自动登录
# ===================================================================

set -euo pipefail

readonly PROFILE_FILE="/etc/profile"
readonly MIN_NODE_MAJOR=18
readonly MIN_NODE_MINOR=20
readonly CLI_PACKAGE="@tencent-ai/codebuddy-code"

# CNB 平台注入的认证相关环境变量
readonly -a INJECTED_ENV_VARS=(
    ACC_PRODUCT_CONFIG_V2
    CNB_TOKEN
    CNB_TOKEN_USER_NAME
)

# /etc/profile 注入行的注释表达式
readonly PROFILE_COMMENT_EXPR="s/^export ACC_PRODUCT_CONFIG_V2=/#export ACC_PRODUCT_CONFIG_V2=/;s/^export CNB_TOKEN=/#export CNB_TOKEN=/;s/^export CNB_TOKEN_USER_NAME=/#export CNB_TOKEN_USER_NAME=/;"

SKIP_CLEAN=0

print_usage() {
    cat <<'EOF'
用法:
    bash scripts/init-codebuddy.sh   安装 + 交互选择是否取消 CNB 自动登录 + 登录引导
EOF
}

# 注释 /etc/profile 中平台注入的自动登录行
clean_profile_inject() {
    if [[ ! -w $PROFILE_FILE ]]; then
        echo "    ⚠️  $PROFILE_FILE 不可写，请以 root 运行: sudo bash ${0##*/}" >&2
        return 0
    fi
    if ! grep -q '^export ACC_PRODUCT_CONFIG_V2=' "$PROFILE_FILE"; then
        return 0
    fi
    sed -i "$PROFILE_COMMENT_EXPR" "$PROFILE_FILE"
    echo "    ✓ 已注释 $PROFILE_FILE 注入行"
}

# 清除当前 shell 中平台注入的环境变量
clean_injected_env() {
    local var
    for var in "${INJECTED_ENV_VARS[@]}"; do
        unset "$var" 2>/dev/null || true
    done
}

# 清理 local_storage 中缓存的 CNB 认证配置
clean_cached_credentials() {
    local ls_dir="${HOME}/.codebuddy/local_storage"
    [[ -d $ls_dir ]] || return 0

    local file is_cnb
    for file in "${ls_dir}"/entry_*.info; do
        [[ -e $file ]] || continue
        # 缓存可能是 gzip+base64 压缩的，需解码后再匹配 CNB 关键字
        is_cnb="$(python3 -c '
import json, base64, gzip, sys
def looks_cnb(path):
    try:
        s = open(path, encoding="utf-8", errors="ignore").read().strip()
        try:
            d = json.loads(s)
            if isinstance(d, str):
                s = gzip.decompress(base64.b64decode(d)).decode("utf-8", errors="ignore")
        except Exception:
            pass
        return any(k in s for k in ("api.cnb.cool", "custom-token", "@cnb"))
    except Exception:
        return False
print("1" if looks_cnb(sys.argv[1]) else "0")
' "$file" 2>/dev/null || echo "0")"
        if [[ $is_cnb == 1 ]]; then
            rm -f "$file"
            echo "    ✓ 清除认证缓存: $(basename "$file")"
        fi
    done
}

cancel_cnb_inject() {
    clean_profile_inject
    clean_injected_env
    clean_cached_credentials
}

check_node() {
    if ! command -v node >/dev/null 2>&1; then
        echo "❌ 未检测到 Node.js，请安装 Node.js ${MIN_NODE_MAJOR}.${MIN_NODE_MINOR}+ (https://nodejs.org/)" >&2
        exit 1
    fi
    local version major minor
    version="$(node --version)"   # 形如 v18.20.1
    version="${version#v}"
    major="${version%%.*}"
    minor="${version#*.}"
    minor="${minor%%.*}"
    if (( major < MIN_NODE_MAJOR || (major == MIN_NODE_MAJOR && minor < MIN_NODE_MINOR) )); then
        echo "❌ Node.js 版本过低 (v${version})，需要 ${MIN_NODE_MAJOR}.${MIN_NODE_MINOR}+" >&2
        exit 1
    fi
}

install_cli() {
    npm install -g "$CLI_PACKAGE"
}

ask_clean_inject() {
    local answer
    printf "🧹 是否取消 CNB 平台注入的自动登录？[Y/n]: "
    read -r answer || true
    case "$(echo "$answer" | tr '[:upper:]' '[:lower:]')" in
        n|no) SKIP_CLEAN=1 ;;
        *)    cancel_cnb_inject ;;
    esac
}

launch_codebuddy() {
    if [[ $SKIP_CLEAN == 1 ]]; then
        echo "ℹ️  已跳过清理，将沿用 CNB 平台注入的自动登录"
    else
        echo "✅ CNB 自动登录已取消"
    fi
    if [[ -t 0 ]]; then
        codebuddy
    else
        echo "非交互终端，请手动执行: codebuddy"
    fi
}

main() {
    if [[ -n ${1:-} ]]; then
        echo "❌ 未知参数: $1" >&2
        print_usage
        exit 1
    fi
    check_node
    install_cli
    ask_clean_inject
    launch_codebuddy
}

main "$@"
