const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  console.log("=".repeat(60));
  console.log("  RWA 资产代币化系统 - 合约部署（完整版 v2.0）");
  console.log("  对应《项目设计要求文档》4.1-4.4 全模块");
  console.log("=".repeat(60));
  console.log();

  const [owner, user1, user2, user3] = await ethers.getSigners();
  console.log("部署账户:", owner.address);
  console.log();

  // =====================================================
  // 一、部署核心合约（4.1-4.4 对应模块）
  // =====================================================

  // 【4.2.2 合规发行系统】Compliance
  console.log("【4.2.2】部署 Compliance 合规引擎...");
  const Compliance = await ethers.getContractFactory("Compliance");
  const compliance = await Compliance.deploy();
  await compliance.waitForDeployment();
  const complianceAddr = await compliance.getAddress();
  console.log("  ✅ Compliance:", complianceAddr);

  // 【4.2.1 资产登记层】RWAToken (房地产代币)
  console.log("\n【4.2.1】部署 RWAToken 资产代币（房地产）...");
  const RWAToken = await ethers.getContractFactory("RWAToken");
  const rwaToken = await RWAToken.deploy(
    "商业地产代币",         // name
    "CREIT",               // symbol
    "商业地产",             // assetType
    ethers.parseEther("1000000"),  // assetValue: 100万USD
    "0x0000000000000000000000000000000000000001"  // spvAddress (占位，后续更新)
  );
  await rwaToken.waitForDeployment();
  const rwaTokenAddr = await rwaToken.getAddress();
  console.log("  ✅ RWAToken:", rwaTokenAddr);

  // 【4.2.3 二级市场交易】Marketplace
  console.log("\n【4.2.3】部署 Marketplace 交易市场...");
  const Marketplace = await ethers.getContractFactory("Marketplace");
  const marketplace = await Marketplace.deploy(complianceAddr, rwaTokenAddr);
  await marketplace.waitForDeployment();
  const marketplaceAddr = await marketplace.getAddress();
  console.log("  ✅ Marketplace:", marketplaceAddr);

  // 【4.3.3 收益分配自动化】RevenueDistributor
  console.log("\n【4.3.3】部署 RevenueDistributor 收益分配...");
  const RevenueDistributor = await ethers.getContractFactory("RevenueDistributor");
  const revenue = await RevenueDistributor.deploy(rwaTokenAddr);
  await revenue.waitForDeployment();
  const revenueAddr = await revenue.getAddress();
  console.log("  ✅ RevenueDistributor:", revenueAddr);

  // 【4.4 风险管理框架】RiskManager
  console.log("\n【4.4】部署 RiskManager 风险管理...");
  const RiskManager = await ethers.getContractFactory("RiskManager");
  const riskManager = await RiskManager.deploy(complianceAddr);
  await riskManager.waitForDeployment();
  const riskManagerAddr = await riskManager.getAddress();
  console.log("  ✅ RiskManager:", riskManagerAddr);

  // =====================================================
  // 二、部署扩展合约（完善设计要求覆盖）
  // =====================================================

  // 【4.2.1 资产登记层】AssetRegistry - 多资产登记 + SPV管理 + 信息披露
  console.log("\n【4.2.1】部署 AssetRegistry 资产登记层...");
  const AssetRegistry = await ethers.getContractFactory("AssetRegistry");
  const assetRegistry = await AssetRegistry.deploy();
  await assetRegistry.waitForDeployment();
  const assetRegistryAddr = await assetRegistry.getAddress();
  console.log("  ✅ AssetRegistry:", assetRegistryAddr);

  // 【4.3.1 智能合约法律等效】LegalEnforcement
  console.log("\n【4.3.1】部署 LegalEnforcement 法律等效...");
  const LegalEnforcement = await ethers.getContractFactory("LegalEnforcement");
  const legal = await LegalEnforcement.deploy();
  await legal.waitForDeployment();
  const legalAddr = await legal.getAddress();
  console.log("  ✅ LegalEnforcement:", legalAddr);

  // 【4.3.2 动态估值系统】Valuation
  console.log("\n【4.3.2】部署 Valuation 动态估值系统...");
  const Valuation = await ethers.getContractFactory("Valuation");
  const valuation = await Valuation.deploy();
  await valuation.waitForDeployment();
  const valuationAddr = await valuation.getAddress();
  console.log("  ✅ Valuation:", valuationAddr);

  // 【4.2.3 荷兰式拍卖】DutchAuction
  console.log("\n【4.2.3】部署 DutchAuction 荷兰式拍卖...");
  const DutchAuction = await ethers.getContractFactory("DutchAuction");
  const dutchAuction = await DutchAuction.deploy();
  await dutchAuction.waitForDeployment();
  const dutchAuctionAddr = await dutchAuction.getAddress();
  console.log("  ✅ DutchAuction:", dutchAuctionAddr);

  // 【4.4 保险集成】Insurance
  console.log("\n【4.4】部署 Insurance 保险集成...");
  const Insurance = await ethers.getContractFactory("Insurance");
  const insurance = await Insurance.deploy();
  await insurance.waitForDeployment();
  const insuranceAddr = await insurance.getAddress();
  console.log("  ✅ Insurance:", insuranceAddr);

  // =====================================================
  // 三、配置合约关联
  // =====================================================
  console.log("\n" + "=".repeat(60));
  console.log("  配置合约关联");
  console.log("=".repeat(60));

  await rwaToken.setComplianceContract(complianceAddr);
  console.log("  ✅ RWAToken -> Compliance");

  await revenue.setComplianceContract(complianceAddr);
  await revenue.setReinvestToken(rwaTokenAddr);
  console.log("  ✅ RevenueDistributor -> Compliance + 再投资代币");

  await riskManager.setInsuranceContract(insuranceAddr);
  console.log("  ✅ RiskManager -> Insurance");

  await compliance.setRWAToken(rwaTokenAddr);
  console.log("  ✅ Compliance -> RWAToken");

  // =====================================================
  // 四、设置 KYC/AML 投资者认证（4.2.2）
  // =====================================================
  console.log("\n" + "=".repeat(60));
  console.log("  设置 KYC/AML 投资者认证");
  console.log("=".repeat(60));

  await compliance.verifyInvestor(owner.address, "Admin", "KYC-ADMIN-001", true, ethers.parseEther("10000000"), 0);
  await compliance.verifyInvestor(user1.address, "投资者A", "KYC-USER1-001", true, ethers.parseEther("5000000"), 365 * 24 * 3600);
  await compliance.verifyInvestor(user2.address, "投资者B", "KYC-USER2-001", true, ethers.parseEther("5000000"), 365 * 24 * 3600);
  await compliance.verifyInvestor(user3.address, "投资者C", "KYC-USER3-001", false, ethers.parseEther("1000000"), 180 * 24 * 3600);
  console.log("  ✅ 4 个账户 KYC 验证完成");

  // 设置转让限制
  await compliance.setTransferRestriction(user3.address, 30 * 24 * 3600, ethers.parseEther("100000"));
  console.log("  ✅ User3 转让限制设置（30天持有期）");

  // 设置发行限制（4.2.2 发行限制）
  await compliance.setIssuanceLimit(
    ethers.parseEther("1000000"),  // maxSupply: 100万
    1000,                          // maxInvestors: 1000人
    7 * 24 * 3600,                 // minLockupPeriod: 7天
    ethers.parseEther("1000000"),  // 单人最大投资额
    true                           // 启用
  );
  console.log("  ✅ 发行限制配置完成（最大供应100万/最大1000投资者/7天锁定期）");

  // 设置 AML 监测阈值（4.2.2 反洗钱）
  await compliance.setAMLThreshold(ethers.parseEther("50000"));
  console.log("  ✅ AML 监测阈值设置（5万ETH）");

  // =====================================================
  // 五、设置白名单 & 铸造代币
  // =====================================================
  console.log("\n" + "=".repeat(60));
  console.log("  设置白名单 & 铸造代币");
  console.log("=".repeat(60));

  await rwaToken.updateWhitelist(owner.address, true);
  await rwaToken.updateWhitelist(user1.address, true);
  await rwaToken.updateWhitelist(user2.address, true);
  await rwaToken.updateWhitelist(user3.address, true);
  await rwaToken.toggleComplianceCheck(true);
  console.log("  ✅ 4 个账户白名单 + 合规检查开启");

  await rwaToken.mint(owner.address, ethers.parseEther("100000"));
  await rwaToken.mint(user1.address, ethers.parseEther("50000"));
  await rwaToken.mint(user2.address, ethers.parseEther("30000"));
  await rwaToken.mint(user3.address, ethers.parseEther("10000"));
  console.log("  ✅ 初始代币铸造完成");

  // =====================================================
  // 六、资产登记（4.2.1 资产登记层 - 多资产类型 + SPV）
  // =====================================================
  console.log("\n" + "=".repeat(60));
  console.log("  资产登记（多资产类型 + SPV风险隔离）");
  console.log("=".repeat(60));

  // 房地产资产
  const spvRealEstate = "0x0000000000000000000000000000000000000001";
  const asset1Id = await assetRegistry.registerAsset(
    "商业地产-北京CBD", 0, ethers.parseEther("1000000"), spvRealEstate, rwaTokenAddr, "QmRealEstateDoc001"
  );
  await assetRegistry.updateTokenizedAmount(0, ethers.parseEther("190000"));
  console.log("  ✅ 房地产资产登记 (Asset #0, SPV隔离)");

  // 股权资产
  const spvEquity = "0x0000000000000000000000000000000000000002";
  await assetRegistry.registerAsset(
    "科技公司股权A轮", 1, ethers.parseEther("5000000"), spvEquity, rwaTokenAddr, "QmEquityDoc002"
  );
  console.log("  ✅ 股权资产登记 (Asset #1, 独立SPV隔离)");

  // 债券资产
  const spvBond = "0x0000000000000000000000000000000000000003";
  await assetRegistry.registerAsset(
    "国债2026-5年期", 2, ethers.parseEther("2000000"), spvBond, rwaTokenAddr, "QmBondDoc003"
  );
  console.log("  ✅ 债券资产登记 (Asset #2, 独立SPV隔离)");

  // 大宗商品资产
  const spvCommodity = "0x0000000000000000000000000000000000000004";
  await assetRegistry.registerAsset(
    "黄金仓单-上海金交所", 3, ethers.parseEther("800000"), spvCommodity, rwaTokenAddr, "QmGoldDoc004"
  );
  console.log("  ✅ 大宗商品资产登记 (Asset #3, 独立SPV隔离)");

  // 发布信息披露
  await assetRegistry.publishDisclosure(0, "Q1运营报告", "QmDisclosure001");
  await assetRegistry.publishDisclosure(0, "租金收益公告", "QmDisclosure002");
  console.log("  ✅ 信息披露发布（2条）");

  // =====================================================
  // 七、法律条款编码（4.3.1 智能合约法律等效）
  // =====================================================
  console.log("\n" + "=".repeat(60));
  console.log("  法律条款编码（智能合约法律等效）");
  console.log("=".repeat(60));

  await legal.encodeClause(0, "产权归属条款", "QmClause-Property-001", "0x01");
  await legal.encodeClause(0, "租金收益分配条款", "QmClause-Revenue-001", "0x02");
  await legal.encodeClause(0, "违约处理条款", "QmClause-Default-001", "0x03");
  await legal.encodeClause(0, "到期赎回条款", "QmClause-Redemption-001", "0x04");
  console.log("  ✅ 4 条法律条款编码完成（产权/收益/违约/赎回）");

  // 注册法律事件触发器
  await legal.registerLegalEvent(0, "资产违约", "抵押率低于120%");
  await legal.registerLegalEvent(0, "到期赎回", "合约到期日");
  console.log("  ✅ 法律事件触发器注册（违约/赎回）");

  // 生成监管报告
  await legal.generateReport(0, "资产登记报告", "QmReport-Registration-001");
  await legal.generateReport(0, "投资者信息报告", "QmReport-Investors-001");
  console.log("  ✅ 监管报告生成（2份）");

  // =====================================================
  // 八、动态估值（4.3.2 动态估值系统）
  // =====================================================
  console.log("\n" + "=".repeat(60));
  console.log("  动态估值（四种估值方法）");
  console.log("=".repeat(60));

  // 现金流折现法
  const cf = [
    ethers.parseEther("120000"),
    ethers.parseEther("125000"),
    ethers.parseEther("130000"),
    ethers.parseEther("135000"),
    ethers.parseEther("140000")
  ];
  await valuation.valuationByDCF(0, cf, 500, "QmDCF-Params-001"); // 5%折现率
  console.log("  ✅ 现金流折现法估值完成");

  // 可比公司法
  await valuation.valuationByComparable(0, ethers.parseEther("980000"), 200, "QmComp-Params-001"); // +2%调整
  console.log("  ✅ 可比公司法估值完成");

  // 成本法
  await valuation.valuationByCost(0, ethers.parseEther("1100000"), 1000, "QmCost-Params-001"); // 10%折旧
  console.log("  ✅ 成本法估值完成");

  // 市场法
  await valuation.valuationByMarket(0, ethers.parseEther("1020000"), 9800, "QmMarket-Params-001"); // 0.98倍
  console.log("  ✅ 市场法估值完成");

  // 综合估值（加权平均）
  await valuation.computeCompositeValue(0, [0, 1, 2, 3], [4000, 2500, 1500, 2000]);
  const composite = await valuation.getLatestCompositeValue(0);
  console.log("  ✅ 综合估值完成:", ethers.formatEther(composite), "USD");

  // 4.2.1 / 4.3.2 数据一致性：将动态估值同步到 RWAToken.assetValue
  await rwaToken.updateAssetValue(composite);
  console.log("  ✅ 代币估值同步完成（assetValue ← composite）");

  // =====================================================
  // 九、保险集成（4.4 保险集成）
  // =====================================================
  console.log("\n" + "=".repeat(60));
  console.log("  保险集成");
  console.log("=".repeat(60));

  await insurance.issuePolicy(
    0, owner.address, ethers.parseEther("500000"), ethers.parseEther("5000"),
    365 * 24 * 3600, "QmInsurance-Terms-001"
  );
  console.log("  ✅ 保单发行（保额50万/保费5000/1年期）");

  // =====================================================
  // 十、输出部署信息
  // =====================================================
  console.log("\n" + "=".repeat(60));
  console.log("  部署完成！");
  console.log("=".repeat(60));
  console.log();
  console.log("合约地址（10个合约）:");
  console.log("  --- 核心合约 ---");
  console.log(`  Compliance:          ${complianceAddr}`);
  console.log(`  RWAToken:            ${rwaTokenAddr}`);
  console.log(`  Marketplace:         ${marketplaceAddr}`);
  console.log(`  RevenueDistributor:  ${revenueAddr}`);
  console.log(`  RiskManager:         ${riskManagerAddr}`);
  console.log("  --- 扩展合约 ---");
  console.log(`  AssetRegistry:       ${assetRegistryAddr}`);
  console.log(`  LegalEnforcement:    ${legalAddr}`);
  console.log(`  Valuation:           ${valuationAddr}`);
  console.log(`  DutchAuction:        ${dutchAuctionAddr}`);
  console.log(`  Insurance:           ${insuranceAddr}`);
  console.log();
  console.log("测试账户:");
  console.log(`  Owner (Admin): ${owner.address}`);
  console.log(`  User1 (投资者A): ${user1.address}`);
  console.log(`  User2 (投资者B): ${user2.address}`);
  console.log(`  User3 (投资者C): ${user3.address}`);
  console.log();
  console.log("前端配置 (复制到 app.js):");
  console.log(`const CONTRACT_ADDRESSES = {`);
  console.log(`    rwaToken: "${rwaTokenAddr}",`);
  console.log(`    compliance: "${complianceAddr}",`);
  console.log(`    marketplace: "${marketplaceAddr}",`);
  console.log(`    revenueDistributor: "${revenueAddr}",`);
  console.log(`    riskManager: "${riskManagerAddr}",`);
  console.log(`    assetRegistry: "${assetRegistryAddr}",`);
  console.log(`    legalEnforcement: "${legalAddr}",`);
  console.log(`    valuation: "${valuationAddr}",`);
  console.log(`    dutchAuction: "${dutchAuctionAddr}",`);
  console.log(`    insurance: "${insuranceAddr}"`);
  console.log(`};`);
  console.log();
  console.log("✅ 全部 10 个合约部署完成，设计要求 4.1-4.4 全模块覆盖！");
  console.log();

  // =====================================================
  // 十一、导出地址文件（供 init-data.js 和前端使用）
  // =====================================================
  const addresses = {
    rwaToken: rwaTokenAddr,
    compliance: complianceAddr,
    marketplace: marketplaceAddr,
    revenueDistributor: revenueAddr,
    riskManager: riskManagerAddr,
    assetRegistry: assetRegistryAddr,
    legalEnforcement: legalAddr,
    valuation: valuationAddr,
    dutchAuction: dutchAuctionAddr,
    insurance: insuranceAddr,
  };
  const addrPath = path.join(__dirname, "deployed-addresses.json");
  fs.writeFileSync(addrPath, JSON.stringify(addresses, null, 2));
  console.log(`✅ 地址已导出到: ${addrPath}`);
  console.log();
}

main().catch(console.error);
