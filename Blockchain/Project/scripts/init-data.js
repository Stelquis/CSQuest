/**
 * RWA 系统测试数据初始化脚本
 * 用法: npx hardhat run scripts/init-data.js --network localhost
 * 前提: 已执行 deploy.js 部署合约
 */
const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

// 读取部署地址
function loadAddresses() {
  const addrPath = path.join(__dirname, "deployed-addresses.json");
  if (!fs.existsSync(addrPath)) {
    throw new Error("未找到 deployed-addresses.json，请先运行 deploy.js");
  }
  return JSON.parse(fs.readFileSync(addrPath, "utf8"));
}

// 通用：获取合约实例
async function getContracts(addresses) {
  const [owner, user1, user2, user3] = await ethers.getSigners();

  const Compliance = await ethers.getContractFactory("Compliance");
  const RWAToken = await ethers.getContractFactory("RWAToken");
  const Marketplace = await ethers.getContractFactory("Marketplace");
  const RevenueDistributor = await ethers.getContractFactory("RevenueDistributor");
  const RiskManager = await ethers.getContractFactory("RiskManager");
  const AssetRegistry = await ethers.getContractFactory("AssetRegistry");
  const LegalEnforcement = await ethers.getContractFactory("LegalEnforcement");
  const Valuation = await ethers.getContractFactory("Valuation");
  const DutchAuction = await ethers.getContractFactory("DutchAuction");
  const Insurance = await ethers.getContractFactory("Insurance");

  return {
    owner, user1, user2, user3,
    compliance: Compliance.attach(addresses.compliance),
    rwaToken: RWAToken.attach(addresses.rwaToken),
    marketplace: Marketplace.attach(addresses.marketplace),
    revenue: RevenueDistributor.attach(addresses.revenueDistributor),
    riskManager: RiskManager.attach(addresses.riskManager),
    assetRegistry: AssetRegistry.attach(addresses.assetRegistry),
    legal: LegalEnforcement.attach(addresses.legalEnforcement),
    valuation: Valuation.attach(addresses.valuation),
    dutchAuction: DutchAuction.attach(addresses.dutchAuction),
    insurance: Insurance.attach(addresses.insurance),
  };
}

async function main() {
  console.log("=".repeat(60));
  console.log("  RWA 系统测试数据初始化");
  console.log("=".repeat(60));

  const addresses = loadAddresses();
  const c = await getContracts(addresses);
  const { owner, user1, user2, user3 } = c;

  console.log("读取合约地址: OK\n");

  // =====================================================
  // 1. 资产登记层：补充更多资产
  // =====================================================
  console.log("【1/10】资产登记层 - 补充资产...");
  const spv5 = "0x0000000000000000000000000000000000000005";
  const spv6 = "0x0000000000000000000000000000000000000006";
  await c.assetRegistry.registerAsset("上海陆家嘴写字楼", 0, ethers.parseEther("3000000"), spv5, addresses.rwaToken, "QmRE-Shanghai-001");
  await c.assetRegistry.registerAsset("新能源公司B轮股权", 1, ethers.parseEther("8000000"), spv6, addresses.rwaToken, "QmEQ-NewEnergy-001");
  await c.assetRegistry.updateTokenizedAmount(4, ethers.parseEther("600000"));
  await c.assetRegistry.updateTokenizedAmount(5, ethers.parseEther("2000000"));
  // 信息披露
  await c.assetRegistry.publishDisclosure(1, "A轮融资进展", "QmDisc-Equity-001");
  await c.assetRegistry.publishDisclosure(2, "国债付息公告", "QmDisc-Bond-001");
  await c.assetRegistry.publishDisclosure(3, "黄金库存盘点", "QmDisc-Gold-001");
  console.log("  ✅ 新增 2 个资产 + 3 条信息披露\n");

  // =====================================================
  // 2. 交易市场：创建卖单
  // =====================================================
  console.log("【2/10】交易市场 - 创建卖单...");
  // user1 挂卖单（先 approve）
  await c.rwaToken.connect(user1).approve(addresses.marketplace, ethers.parseEther("5000"));
  await c.marketplace.connect(user1).createSellOrder(addresses.rwaToken, ethers.parseEther("1000"), ethers.parseEther("0.5"));
  await c.marketplace.connect(user1).createSellOrder(addresses.rwaToken, ethers.parseEther("2000"), ethers.parseEther("0.48"));
  // user2 挂卖单
  await c.rwaToken.connect(user2).approve(addresses.marketplace, ethers.parseEther("3000"));
  await c.marketplace.connect(user2).createSellOrder(addresses.rwaToken, ethers.parseEther("1500"), ethers.parseEther("0.52"));
  await c.marketplace.connect(user2).createSellOrder(addresses.rwaToken, ethers.parseEther("800"), ethers.parseEther("0.55"));
  console.log("  ✅ 创建 4 个卖单\n");

  // =====================================================
  // 3. 做市商系统：注册做市商并设置报价
  // =====================================================
  console.log("【3/10】做市商系统 - 注册做市商...");
  await c.marketplace.registerMarketMaker(owner.address);
  // 做市商需要代币用于卖出，owner 已有代币，approve 给市场
  await c.rwaToken.connect(owner).approve(addresses.marketplace, ethers.parseEther("50000"));
  await c.marketplace.updateQuote(
    addresses.rwaToken,
    ethers.parseEther("0.49"),  // bid 买价
    ethers.parseEther("0.51"),  // ask 卖价
    ethers.parseEther("10000"), // bid 量
    ethers.parseEther("10000")  // ask 量
  );
  console.log("  ✅ 做市商注册 + 报价设置 (bid:0.49 / ask:0.51)\n");

  // =====================================================
  // 4. 荷兰式拍卖：创建拍卖
  // =====================================================
  console.log("【4/10】荷兰式拍卖 - 创建拍卖...");
  // owner 拍卖大宗代币
  await c.rwaToken.connect(owner).approve(addresses.dutchAuction, ethers.parseEther("10000"));
  await c.dutchAuction.createAuction(
    addresses.rwaToken,
    ethers.parseEther("5000"),    // 数量
    ethers.parseEther("1.0"),     // 起始价
    ethers.parseEther("0.3"),     // 保留价
    ethers.parseEther("0.05"),    // 每次降价
    60,                            // 60秒降一次
    3600                           // 持续1小时
  );
  await c.dutchAuction.createAuction(
    addresses.rwaToken,
    ethers.parseEther("3000"),
    ethers.parseEther("0.8"),
    ethers.parseEther("0.2"),
    ethers.parseEther("0.04"),
    120,
    7200
  );
  console.log("  ✅ 创建 2 场荷兰式拍卖\n");

  // =====================================================
  // 5. OTC 场外交易：发起交易意向
  // =====================================================
  console.log("【5/10】OTC 场外交易 - 发起意向...");
  await c.marketplace.connect(user1).proposeOTC(
    user2.address,
    addresses.rwaToken,
    ethers.parseEther("500"),
    ethers.parseEther("0.5")
  );
  console.log("  ✅ 发起 1 笔 OTC 交易意向 (user1 → user2)\n");

  // =====================================================
  // 6. 收益分配：存入收益 + 创建分配
  // =====================================================
  console.log("【6/10】收益分配 - 存入收益 + 创建分配...");
  // 存入租金收益
  await c.revenue.depositRevenue("租金", { value: ethers.parseEther("10") });
  // 创建租金分配（按投资者持仓）
  const investors = [owner.address, user1.address, user2.address, user3.address];
  const amounts = [
    ethers.parseEther("5"),
    ethers.parseEther("2.5"),
    ethers.parseEther("1.5"),
    ethers.parseEther("0.5")
  ];
  await c.revenue.createDistribution(ethers.parseEther("9.5"), "租金", investors, amounts);

  // 存入股息收益
  await c.revenue.depositRevenue("股息", { value: ethers.parseEther("5") });
  await c.revenue.createDistribution(
    ethers.parseEther("5"),
    "股息",
    [owner.address, user1.address],
    [ethers.parseEther("3"), ethers.parseEther("2")]
  );

  // 存入利息收益
  await c.revenue.depositRevenue("利息", { value: ethers.parseEther("3") });
  console.log("  ✅ 存入租金10/股息5/利息3 ETH + 2笔分配方案\n");

  // =====================================================
  // 7. 保险集成：发行多个保单
  // =====================================================
  console.log("【7/10】保险集成 - 发行保单...");
  await c.insurance.issuePolicy(
    1, user1.address, ethers.parseEther("200000"), ethers.parseEther("2000"),
    180 * 24 * 3600, "QmIns-Equity-Policy-001"
  );
  await c.insurance.issuePolicy(
    2, user2.address, ethers.parseEther("500000"), ethers.parseEther("4500"),
    365 * 24 * 3600, "QmIns-Bond-Policy-001"
  );
  await c.insurance.issuePolicy(
    3, user3.address, ethers.parseEther("100000"), ethers.parseEther("1000"),
    90 * 24 * 3600, "QmIns-Gold-Policy-001"
  );
  console.log("  ✅ 发行 3 个新保单（股权/债券/大宗商品）\n");

  // =====================================================
  // 8. 法律等效：补充条款 + 发起争议
  // =====================================================
  console.log("【8/10】法律等效 - 补充条款 + 争议...");
  await c.legal.encodeClause(1, "股东投票权条款", "QmClause-Voting-001", "0x05");
  await c.legal.encodeClause(1, "股息分配条款", "QmClause-Dividend-001", "0x06");
  await c.legal.encodeClause(2, "利息支付条款", "QmClause-Interest-001", "0x07");
  await c.legal.encodeClause(3, "仓单溯源条款", "QmClause-Traceability-001", "0x08");

  // user1 向 user2 发起争议
  await c.legal.connect(user1).fileDispute(0, user2.address, "QmDispute-Reason-001");
  console.log("  ✅ 新增 4 条法律条款 + 1 笔争议\n");

  // =====================================================
  // 9. 动态估值：补充其他资产估值
  // =====================================================
  console.log("【9/10】动态估值 - 补充估值...");
  // 资产1（股权）估值
  const cf2 = [
    ethers.parseEther("800000"),
    ethers.parseEther("900000"),
    ethers.parseEther("1000000"),
    ethers.parseEther("1100000")
  ];
  await c.valuation.valuationByDCF(1, cf2, 800, "QmDCF-Equity-001");
  await c.valuation.valuationByComparable(1, ethers.parseEther("7500000"), 500, "QmComp-Equity-001");
  await c.valuation.computeCompositeValue(1, [4, 5], [5000, 5000]);

  // 资产2（债券）估值
  await c.valuation.valuationByCost(2, ethers.parseEther("2100000"), 200, "QmCost-Bond-001");
  await c.valuation.valuationByMarket(2, ethers.parseEther("1980000"), 10100, "QmMarket-Bond-001");
  await c.valuation.computeCompositeValue(2, [6, 7], [5000, 5000]);

  // 验证之前资产的估值
  await c.valuation.verifyValuation(0);
  await c.valuation.verifyValuation(1);
  console.log("  ✅ 补充资产1/2估值 + 验证2条\n");

  // =====================================================
  // 10. 风险管理：创建仓位 + 压力测试
  // =====================================================
  console.log("【10/10】风险管理 - 创建仓位 + 压力测试...");
  await c.riskManager.connect(owner).createPosition(
    addresses.rwaToken,
    addresses.rwaToken,
    ethers.parseEther("200"),   // 抵押 200
    ethers.parseEther("100")    // 借入 100 (抵押率200%)
  );
  await c.riskManager.connect(user1).createPosition(
    addresses.rwaToken,
    addresses.rwaToken,
    ethers.parseEther("180"),
    ethers.parseEther("100")    // 抵押率180%
  );
  await c.riskManager.connect(user2).createPosition(
    addresses.rwaToken,
    addresses.rwaToken,
    ethers.parseEther("160"),
    ethers.parseEther("100")    // 抵押率160%
  );

  // 绑定保险
  await c.riskManager.bindInsurance(0, 0);

  // 压力测试
  await c.riskManager.runStressTest("极端下跌30%", 3000, "QmStress-30pct-001");
  await c.riskManager.runStressTest("中度下跌15%", 1500, "QmStress-15pct-001");
  console.log("  ✅ 创建 3 个仓位 + 绑定保险 + 2 次压力测试\n");

  // =====================================================
  // 完成
  // =====================================================
  console.log("=".repeat(60));
  console.log("  测试数据初始化完成！");
  console.log("=".repeat(60));
  console.log();
  console.log("生成数据汇总:");
  console.log("  资产登记: 6 个资产 + 5 条信息披露");
  console.log("  交易市场: 4 个卖单");
  console.log("  做市商:   1 个做市商 + 报价");
  console.log("  荷兰拍卖: 2 场拍卖");
  console.log("  OTC:      1 笔交易意向");
  console.log("  收益分配: 3 笔收益存入 + 2 笔分配方案");
  console.log("  保险:     4 个保单");
  console.log("  法律:     8 条条款 + 1 笔争议");
  console.log("  估值:     8 条估值 + 3 个综合估值");
  console.log("  风险:     3 个仓位 + 2 次压力测试");
  console.log();
}

main().catch((e) => { console.error(e); process.exit(1); });
