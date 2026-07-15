#!/bin/bash
# =====================================================
# RWA 系统控制脚本
#   bash Blockchain/Project/rwa.sh start
#   bash Blockchain/Project/rwa.sh stop
# =====================================================
set -e

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="/tmp/rwa-logs"
PID_DIR="$LOG_DIR"
mkdir -p "$LOG_DIR"

G='\033[0;32m'; C='\033[0;36m'; R='\033[0;31m'; NC='\033[0m'
ok()   { echo -e "${G}✓${NC} $1"; }
info() { echo -e "${C}ℹ${NC} $1"; }
err()  { echo -e "${R}✗${NC} $1"; }
port_in_use() { (echo > /dev/tcp/127.0.0.1/$1) >/dev/null 2>&1; }

# ============================================================
do_start() {
    echo -e "\n${C}  RWA 资产代币化系统 - 启动...${NC}\n"

    # 0. 如果端口被占，先清
    port_in_use 8545 && { info "清理旧区块链节点..."; pkill -f "hardhat node" 2>/dev/null; sleep 2; }
    port_in_use 8080 && { info "清理旧前端服务..."; pkill -f "node server.js" 2>/dev/null; sleep 1; }

    # 1. 依赖
    if [ ! -d "$PROJECT_DIR/node_modules/hardhat" ]; then
        info "安装依赖..."
        cd "$PROJECT_DIR" && PUPPETEER_SKIP_DOWNLOAD=true npm install --no-audit --no-fund > "$LOG_DIR/npm.log" 2>&1
    fi
    ok "依赖就绪"

    # 2. 编译
    cd "$PROJECT_DIR" && npx hardhat compile > "$LOG_DIR/compile.log" 2>&1 || { err "编译失败"; exit 1; }
    ok "合约编译完成"

    # 3. 启动 Hardhat 节点
    info "启动区块链节点..."
    nohup npx hardhat node > "$LOG_DIR/hardhat.log" 2>&1 &
    echo $! > "$PID_DIR/hardhat.pid"
    for i in $(seq 1 20); do port_in_use 8545 && break; sleep 1; done
    port_in_use 8545 && ok "区块链节点启动成功" || { err "节点启动失败"; exit 1; }

    # 4. 部署 + 初始化
    info "部署合约..."
    npx hardhat run scripts/deploy.js --network localhost > "$LOG_DIR/deploy.log" 2>&1 || { err "部署失败"; exit 1; }
    ok "合约部署完成"
    npx hardhat run scripts/init-data.js --network localhost > "$LOG_DIR/data.log" 2>&1 || { err "数据初始化失败"; exit 1; }
    ok "数据初始化完成"

    # 5. 同步地址
    node scripts/sync-addresses.js >/dev/null 2>&1; ok "前端地址已同步"

    # 6. 启动前端
    info "启动前端服务..."
    nohup node server.js > "$LOG_DIR/server.log" 2>&1 &
    echo $! > "$PID_DIR/server.pid"
    for i in $(seq 1 10); do port_in_use 8080 && break; sleep 0.5; done
    port_in_use 8080 && ok "前端服务启动成功" || { err "前端服务启动失败"; exit 1; }

    echo ""
    echo -e "${G}  ═════════════════════════════════════════${NC}"
    echo -e "${G}  ✅ 系统已启动${NC}"
    echo -e "${G}  ═════════════════════════════════════════${NC}"
    echo -e "  🌐  http://localhost:8080"
    echo -e "  ⛓   http://127.0.0.1:8545 (Chain 31337)"
    echo -e "  ⏹   bash Blockchain/Project/rwa.sh stop"
    echo ""
}

# ============================================================
do_stop() {
    echo -e "\n${C}  RWA 资产代币化系统 - 停止...${NC}\n"

    info "停止前端服务..."
    pkill -f "node server.js" 2>/dev/null; sleep 1
    port_in_use 8080 && { pkill -9 -f "node server.js" 2>/dev/null; sleep 1; }
    port_in_use 8080 && err "前端服务停止失败" || ok "前端服务已停止"

    info "停止区块链节点..."
    pkill -f "hardhat node" 2>/dev/null; sleep 2
    port_in_use 8545 && { pkill -9 -f "hardhat node" 2>/dev/null; sleep 2; }
    port_in_use 8545 && err "区块链节点停止失败" || ok "区块链节点已停止"

    rm -f "$PID_DIR/hardhat.pid" "$PID_DIR/server.pid"

    echo ""
    if port_in_use 8080 || port_in_use 8545; then
        err "部分端口未释放"
    else
        echo -e "${G}  ✅ 所有服务已安全退出${NC}"
    fi
    echo ""
}

# ============================================================
case "${1:-}" in
    start) do_start ;;
    stop)  do_stop ;;
    *)
        echo "用法: bash Blockchain/Project/rwa.sh {start|stop}"
        exit 1
        ;;
esac
