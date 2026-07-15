# ===================================================================
# JupyterLab 初始化脚本
# ===================================================================
# 功能: 一键安装并配置 JupyterLab (单用户 / 免密)
# 配置路径: /root/.jupyter/jupyter_lab_config.py
# 一键运行:
#   bash /workspace/scripts/init-jupyterlab.sh
# ===================================================================

set -e

# -----------------------------------------------------------------------------
# 用户配置区
# -----------------------------------------------------------------------------

# JupyterLab 监听端口（默认 8888，与 code-server 8080 不冲突）
MY_PORT="8888"

# 工作目录（默认 /workspace）
MY_ROOT_DIR="/workspace"

# -----------------------------------------------------------------------------
# 配置读取逻辑
# -----------------------------------------------------------------------------

JUPYTER_PORT="${JUPYTER_PORT:-$MY_PORT}"
JUPYTER_ROOT_DIR="${JUPYTER_ROOT_DIR:-$MY_ROOT_DIR}"
JUPYTER_CONFIG_DIR="/root/.jupyter"
JUPYTER_CONFIG_FILE="${JUPYTER_CONFIG_DIR}/jupyter_lab_config.py"
VENV_DIR="/opt/venv"

echo "==> JupyterLab 初始化"

# -----------------------------------------------------------------------------
# 1. 安装 JupyterLab
# -----------------------------------------------------------------------------

if command -v jupyter &>/dev/null && jupyter --version 2>&1 | grep -q "jupyterlab"; then
    echo "  ✅ JupyterLab $(jupyter --version 2>&1 | grep jupyterlab | awk '{print $3}') 已安装"
else
    echo "  📦 安装 JupyterLab ..."
    uv pip install --python "${VENV_DIR}/bin/python" --quiet jupyterlab
    echo "  ✅ 安装完成"
fi

# -----------------------------------------------------------------------------
# 2. 配置文件
# -----------------------------------------------------------------------------

mkdir -p "${JUPYTER_CONFIG_DIR}"
cat > "${JUPYTER_CONFIG_FILE}" << JUPYTERCONFIG
c = get_config()
c.ServerApp.ip = '*'
c.ServerApp.port = ${JUPYTER_PORT}
c.ServerApp.open_browser = False
c.ServerApp.root_dir = '${JUPYTER_ROOT_DIR}'
c.ServerApp.allow_origin = '*'
c.ServerApp.trust_xheaders = True
c.IdentityProvider.token = ''
c.PasswordIdentityProvider.password_required = False
JUPYTERCONFIG
echo "  ✅ 配置已写入 (端口 ${JUPYTER_PORT} · ${JUPYTER_ROOT_DIR})"

# -----------------------------------------------------------------------------
# 3. 扩展
# -----------------------------------------------------------------------------

PACKAGES=(
    "jupyterlab_code_formatter"
    "black"
    "isort"
    "jupyterlab-language-pack-zh-CN"
)

TO_INSTALL=()
for pkg in "${PACKAGES[@]}"; do
    pkg_norm="${pkg//_/-}"
    if ! uv pip list --python "${VENV_DIR}/bin/python" 2>/dev/null | grep -qi "^${pkg_norm}[[:space:]=]"; then
        TO_INSTALL+=("$pkg")
    fi
done

if [ ${#TO_INSTALL[@]} -gt 0 ]; then
    echo "  📦 安装扩展: ${TO_INSTALL[*]}"
    uv pip install --python "${VENV_DIR}/bin/python" --quiet "${TO_INSTALL[@]}"
    echo "  ✅ 扩展安装完成"
else
    echo "  ✅ 扩展已全部安装"
fi

# -----------------------------------------------------------------------------
# 4. 启动服务
# -----------------------------------------------------------------------------

echo "  🚀 启动 JupyterLab ..."
nohup jupyter lab --no-browser --allow-root --config="${JUPYTER_CONFIG_FILE}" > /tmp/jupyterlab.log 2>&1 &
sleep 6

if curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:${JUPYTER_PORT}/ 2>/dev/null | grep -qE "200|302"; then
    echo "  ✅ JupyterLab 已启动 (端口 ${JUPYTER_PORT})"
else
    echo "  ⚠️  启动较慢，稍后查看日志: tail -f /tmp/jupyterlab.log"
fi

echo ""
echo "========== JupyterLab 就绪 =========="
echo "  访问: http://127.0.0.1:${JUPYTER_PORT}/lab"
echo "  汉化: 启动后 Settings → Language → 中文(简体)"
echo "  日志: tail -f /tmp/jupyterlab.log"
echo "======================================"