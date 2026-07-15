# ===================================================================
# 区块链环境初始化脚本
# ===================================================================
# 功能: 为区块链系列 demo（文档存证、智能合约、区块链模拟、RWA项目）
#       配置完整的开发环境
#
# 适用实验:
#   1: 区块链数字文档存证系统 (Python + cryptography)
#   2: 智能合约、AI代理与可升级合约 (Solidity + Remix/Hardhat)
#   3: 区块链模拟系统 (Python + scikit-learn + matplotlib)
#   Project: 现实世界资产代币化系统 RWA (Solidity + Hardhat + React)
#
# 一键运行:
#   bash /workspace/scripts/init-blockchain-env.sh
# ===================================================================

set -e

# -----------------------------------------------------------------------------
# 第一部分: Python 依赖库安装（实验1 + 实验3）
# -----------------------------------------------------------------------------
# 说明: 使用 Dockerfile 中已创建的 /opt/venv 虚拟环境
#       Dockerfile 已预装 numpy、pandas，此处补充区块链实验所需库
#
# 依赖说明:
#   cryptography:    RSA 非对称加密、数字签名（实验1）
#   scikit-learn:    AI 参数优化模块，线性回归/决策树（实验3）
#   matplotlib:      性能分析图表可视化（实验3）

echo "=== 区块链实验环境初始化 ==="
echo ""
echo "--- 第一部分: Python 依赖库 ---"

# 确保虚拟环境存在
if [ ! -d "/opt/venv" ]; then
    echo "📦 虚拟环境不存在，正在创建..."
    python3 -m venv /opt/venv
    /opt/venv/bin/pip install --upgrade pip
    /opt/venv/bin/pip install numpy pandas
fi

# 安装区块链实验所需的 Python 库
# 说明: 逐个安装，便于定位失败原因
echo "📦 正在安装 cryptography（RSA 加密/数字签名）..."
/opt/venv/bin/pip install cryptography

echo "📦 正在安装 scikit-learn（AI 参数优化）..."
/opt/venv/bin/pip install scikit-learn

echo "📦 正在安装 matplotlib（性能可视化）..."
/opt/venv/bin/pip install matplotlib

echo "✅ Python 依赖库安装完成"
echo ""

# -----------------------------------------------------------------------------
# 第二部分: Solidity 编译器安装（实验2 + RWA项目）
# -----------------------------------------------------------------------------
# 说明: solc 是 Solidity 官方编译器，用于本地编译 .sol 合约文件
#       实验2 推荐使用 Remix IDE，但本地 solc 可用于快速验证语法
#       版本选择: 0.8.28 为当前稳定版，兼容实验要求的 0.8+

echo "--- 第二部分: Solidity 编译器 ---"

if command -v solc &>/dev/null; then
    echo "⏭️  solc 已安装: $(solc --version | head -1)"
else
    echo "📦 正在安装 solc 0.8.28..."
    curl -L -o /usr/local/bin/solc \
        https://github.com/ethereum/solidity/releases/download/v0.8.28/solc-static-linux
    chmod +x /usr/local/bin/solc
    echo "✅ solc 安装完成: $(solc --version | head -1)"
fi
echo ""

# -----------------------------------------------------------------------------
# 第三部分: Hardhat 开发框架（实验2 + RWA项目）
# -----------------------------------------------------------------------------
# 说明: Hardhat 是以太坊主流开发框架，支持编译、测试、部署智能合约
#       实验2 可选使用，RWA 项目推荐使用
#       安装在 /opt/hardhat 作为全局可用的独立项目

echo "--- 第三部分: Hardhat 开发框架 ---"

if [ -d "/opt/hardhat" ]; then
    echo "⏭️  Hardhat 已安装，跳过"
else
    echo "📦 正在初始化 Hardhat 项目..."
    mkdir -p /opt/hardhat
    cd /opt/hardhat

    # 初始化 Node.js 项目
    # 说明: -y 使用默认配置，避免交互式提示
    npm init -y > /dev/null 2>&1

    # 安装 Hardhat 核心及插件
    # 说明:
    #   @nomicfoundation/hardhat-toolbox: 集成工具箱（ethers、chai、mocha 等）
    #   @openzeppelin/contracts:          OpenZeppelin 合约库（ERC-20/ERC-3643）
    npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox
    npm install @openzeppelin/contracts

    # 创建 Hardhat 配置文件
    # 说明: 配置 Solidity 0.8.28 编译器，与 solc 版本一致
    cat > hardhat.config.js << 'HARDHAT_EOF'
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
};
HARDHAT_EOF

    # 创建标准目录结构
    mkdir -p contracts test scripts

    echo "✅ Hardhat 安装完成"
    echo "   项目目录: /opt/hardhat"
    echo "   合约目录: /opt/hardhat/contracts"
fi
echo ""

# -----------------------------------------------------------------------------
# 第四部分: 环境验证
# -----------------------------------------------------------------------------
# 说明: 逐一验证各组件是否安装成功，输出版本信息

echo "--- 第四部分: 环境验证 ---"
echo ""

# 验证 Python 环境
echo "🐍 Python 环境:"
echo -n "   Python 版本:    "
python3 --version
echo -n "   cryptography:   "
/opt/venv/bin/python3 -c "import cryptography; print(cryptography.__version__)"
echo -n "   scikit-learn:   "
/opt/venv/bin/python3 -c "import sklearn; print(sklearn.__version__)"
echo -n "   matplotlib:     "
/opt/venv/bin/python3 -c "import matplotlib; print(matplotlib.__version__)"
echo ""

# 验证 Solidity 编译器
echo "📜 Solidity 编译器:"
if command -v solc &>/dev/null; then
    echo -n "   solc 版本:      "
    solc --version | tail -1
else
    echo "   solc:           未安装"
fi
echo ""

# 验证 Hardhat
echo "⚒️  Hardhat 框架:"
if [ -d "/opt/hardhat" ]; then
    echo -n "   hardhat 版本:   "
    cd /opt/hardhat && npx hardhat --version 2>/dev/null || echo "运行异常"
else
    echo "   hardhat:        未安装"
fi
echo ""

# 验证 Node.js
echo "🟢 Node.js 环境:"
echo -n "   Node.js 版本:   "
node --version
echo -n "   npm 版本:       "
npm --version
echo ""

# -----------------------------------------------------------------------------
# 第五部分: 输出总结
# -----------------------------------------------------------------------------

echo "============================================================"
echo "  区块链实验环境配置完成"
echo "============================================================"
echo ""
echo "  实验1 (文档存证):   Python + cryptography     ✅"
echo "  实验2 (智能合约):   Solidity + Hardhat/Remix   ✅"
echo "  实验3 (区块链模拟): Python + scikit-learn      ✅"
echo "  项 目 (RWA):        Hardhat + OpenZeppelin     ✅"
echo ""
echo "  快速开始:"
echo "    Python 实验:  /opt/venv/bin/python3 your_script.py"
echo "    Solidity:     cd /opt/hardhat && npx hardhat compile"
echo "    Remix IDE:    浏览器访问 https://remix.ethereum.org"
echo ""
echo "============================================================"
