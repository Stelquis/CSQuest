# 🔗 区块链

## 📋 一、三次作业

| 序号 | 作业名称 | 说明 |
|:---:|----------|------|
| 1️⃣ | 区块链数字文档存证系统开发 | Python + cryptography，哈希/默克尔树/RSA/数字签名 |
| 2️⃣ | 智能合约、AI代理与可升级合约 | Solidity + Remix/Hardhat，NotaryV1/V2/Upgradeable |
| 3️⃣ | 支持PoW/PoS动态切换的区块链模拟系统 | Python + scikit-learn，共识机制 + AI参数优化 |

### 📦 作业提交要求

- ✅ 项目源码压缩包
- ✅ `README.md`（包含结果截图），同时提交 PDF 格式版本

### 📁 提交格式

```
学号_姓名_作业.zip
├── 作业1_区块链数字文档存证/
│   ├── blockchain_notary.py
│   └── README.md
├── 作业2_智能合约/
│   ├── NotaryV1.sol
│   ├── NotaryV2.sol
│   ├── NotaryUpgradeable.sol
│   └── README.md
└── 作业3_区块链模拟系统/
    ├── blockchain_sim.py
    └── README.md
```

---

## 🚀 二、综合实践

> 可独立完成，可小组合作（至多2人）。如小组合作需另附：分工说明文档（Word/PDF）

| 班级 | 项目主题 |
|:---:|----------|
| 1班 | 🪙 类比特币的发币与挖矿系统 |
| 2班 | 💱 去中心化交易系统 |
| 3班 | 🌿 基于区块链的碳溯源系统 |
| 4班 | 🏠 现实世界资产代币化系统（RWA） |
| 其余 | 🌐 Web3 综合生态系统 |

### 📦 综合实践提交要求

| 文件 | 说明 |
|------|------|
| 📂 项目源码压缩包 | 完整可运行的项目代码 |
| 📖 环境部署手册 | `README.md` 文档，同时提交 PDF 版 |
| 📝 设计文档 | Word / PDF |
| 🧪 测试报告 | Word / PDF |
| 🎬 演示视频 | 5分钟以内 |

### 📁 提交格式

```
# 个人完成
学号_姓名_实践.zip

# 小组完成
学号_姓名_学号_姓名_实践.zip
```

---

## 🛠️ 三、实验环境配置

### 3.1 🐍 Python 环境（实验1 + 实验3）

| 组件 | 版本 | 用途 |
|------|------|------|
| Python | 3.12+ | 运行环境 |
| `cryptography` | 48.0.0 | RSA 加密 / 数字签名 |
| `scikit-learn` | 1.8.0 | AI 参数优化（线性回归/决策树） |
| `matplotlib` | 3.10.9 | 性能分析图表可视化 |
| `numpy` | 2.4.6 | 数值计算 |
| `pandas` | - | 数据处理 |

安装命令：
```bash
pip install cryptography scikit-learn matplotlib numpy pandas
```

### 3.2 📜 Solidity 环境（实验2 + 综合实践）

| 组件 | 版本 | 用途 |
|------|------|------|
| solc | 0.8.28 | Solidity 官方编译器 |
| Hardhat | 3.6.0 | 智能合约开发框架 |
| OpenZeppelin | latest | ERC-20 / ERC-3643 合约库 |
| Node.js | 22.22.2 | Hardhat 运行依赖 |
| npm | 10.9.7 | 包管理器 |

一键安装（使用我们配置的脚本）：
```bash
bash /workspace/scripts/init-blockchain-env.sh
```

### 3.3 🌐 推荐工具

| 工具 | 说明 |
|------|------|
| 🧪 Remix IDE | 在线 Solidity IDE，浏览器访问 https://remix.ethereum.org |
| 🦊 MetaMask | 以太坊钱包浏览器插件 |
| 🔗 Sepolia 测试网 | 免费测试网络，获取测试 ETH |
| 📊 VS Code / PyCharm | 本地开发工具 |

### 3.4 ⚡ 快速开始

```bash
# Python 实验
/opt/venv/bin/python3 your_script.py

# Solidity 编译
cd /opt/hardhat && npx hardhat compile

# Solidity 部署
npx hardhat run scripts/deploy.js --network localhost
```

---

## 📊 四、评分标准总览

### 作业评分（每项100分）

| 类别 | 分值 | 说明 |
|------|:---:|------|
| 🎯 功能完整性 | 65~70分 | 核心功能实现 |
| 💎 代码质量 | 20~30分 | 结构清晰、注释完善、异常处理 |
| 📖 文档说明 | 10分 | README + 测试截图 |
| 💡 创新与扩展 | +10分 | 扩展功能、输出美化 |

### 综合实践评分（参考）

| 类别 | 分值 | 说明 |
|------|:---:|------|
| 🎯 功能完整性 | 70分 | 核心功能全部实现 |
| 💎 代码质量 | 20分 | 规范性 + 安全性 |
| 📖 文档与测试 | 10分 | README + 截图 |
| 💡 创新与扩展 | +10分 | 动态估值、跨链集成等 |

---

## ⚠️ 五、注意事项

- 🚫 **独立完成**，严禁抄袭，代码雷同按 0 分处理
- 🔑 代码必须包含**个性化学号哈希**进行身份验证
- ⏰ 严格遵守提交时限，超时每 30 分钟扣 10 分
- 💻 代码必须**一键运行**，末尾输出个性化学号哈希值
- 📂 打包为 `.zip` 格式提交

---

> 📅 课程组布置 · 2026年春季学期

---

## 📌 缺失项清单

> 详细缺失说明及截图获取方式请参见 [缺失清单与获取方式.md](缺失清单与获取方式.md)
