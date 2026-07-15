const { ethers } = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  const addr = JSON.parse(fs.readFileSync(path.join(__dirname, "deployed-addresses.json"), "utf8"));
  const [owner] = await ethers.getSigners();
  const checks = [];
  const pass = (msg) => checks.push(`✅ ${msg}`);
  const fail = (msg, e) => checks.push(`❌ ${msg}: ${e.message || e}`);

  // 1. RWAToken
  try {
    const t = await ethers.getContractAt("RWAToken", addr.rwaToken);
    const info = await t.getTokenInfo();
    pass(`RWAToken: ${info[0]} (${info[1]}), supply=${ethers.formatEther(info[4])}`);
  } catch(e) { fail("RWAToken", e); }

  // 2. Compliance
  try {
    const c = await ethers.getContractAt("Compliance", addr.compliance);
    const cnt = await c.getVerifiedInvestorCount();
    const inv = await c.investors(owner.address);
    pass(`Compliance: ${cnt} verified, KYC=${inv.kycId}`);
  } catch(e) { fail("Compliance", e); }

  // 3. Marketplace
  try {
    const m = await ethers.getContractAt("Marketplace", addr.marketplace);
    const stats = await m.getMarketStats();
    pass(`Marketplace: ${stats[0]} orders, volume=${ethers.formatEther(stats[1])}`);
  } catch(e) { fail("Marketplace", e); }

  // 4. RevenueDistributor
  try {
    const r = await ethers.getContractAt("RevenueDistributor", addr.revenueDistributor);
    const s = await r.getSystemStats();
    pass(`RevenueDistributor: ${s[0]} dists, total=${ethers.formatEther(s[1])} ETH`);
  } catch(e) { fail("RevenueDistributor", e); }

  // 5. RiskManager
  try {
    const rm = await ethers.getContractAt("RiskManager", addr.riskManager);
    const pc = await rm.positionCount();
    const s = await rm.getSystemRiskStats();
    pass(`RiskManager: ${pc} positions, collat=${ethers.formatEther(s[1])}, borrow=${ethers.formatEther(s[2])}`);
  } catch(e) { fail("RiskManager", e); }

  // 6. AssetRegistry
  try {
    const ar = await ethers.getContractAt("AssetRegistry", addr.assetRegistry);
    const cnt = await ar.assetCount();
    const a = await ar.assets(0);
    pass(`AssetRegistry: ${cnt} assets, #0=${a.name} (cat ${a.category})`);
  } catch(e) { fail("AssetRegistry", e); }

  // 7. LegalEnforcement
  try {
    const l = await ethers.getContractAt("LegalEnforcement", addr.legalEnforcement);
    const s = await l.getSystemStats();
    pass(`LegalEnforcement: ${s[0]} clauses, ${s[1]} disputes, ${s[2]} events`);
  } catch(e) { fail("LegalEnforcement", e); }

  // 8. Valuation
  try {
    const v = await ethers.getContractAt("Valuation", addr.valuation);
    const cnt = await v.valuationCount();
    const comp = await v.getLatestCompositeValue(0);
    pass(`Valuation: ${cnt} records, composite #0=${ethers.formatEther(comp)}`);
  } catch(e) { fail("Valuation", e); }

  // 9. DutchAuction
  try {
    const da = await ethers.getContractAt("DutchAuction", addr.dutchAuction);
    const cnt = await da.auctionCount();
    const a = await da.auctions(0);
    pass(`DutchAuction: ${cnt} auctions, #0 start=${ethers.formatEther(a.startPrice)}`);
  } catch(e) { fail("DutchAuction", e); }

  // 10. Insurance
  try {
    const ins = await ethers.getContractAt("Insurance", addr.insurance);
    const s = await ins.getInsuranceStats();
    pass(`Insurance: ${s[0]} policies, coverage=${ethers.formatEther(s[2])}`);
  } catch(e) { fail("Insurance", e); }

  // 输出详细统计 + 验证结果
  console.log("\n" + "=".repeat(55));
  console.log("  完整合约验证 + 链上统计");
  console.log("=".repeat(55));
  checks.forEach(c => console.log(c));

  const allPass = checks.every(c => c.startsWith("✅"));
  console.log("\n" + (allPass ? "🎉 全部 10 个合约验证通过！" : "⚠️ 存在失败项"));
}

main().catch(console.error);
