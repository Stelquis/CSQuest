// =====================================================
// RWA 资产代币化系统 - 前端交互逻辑
// =====================================================

// 合约地址（本地 Hardhat 测试网 - 部署后自动更新）
const CONTRACT_ADDRESSES = {
    rwaToken: "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512",
    compliance: "0x5FbDB2315678afecb367f032d93F642f64180aa3",
    marketplace: "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0",
    revenueDistributor: "0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9",
    riskManager: "0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9",
    assetRegistry: "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707",
    legalEnforcement: "0x0165878A594ca255338adfa4d48449f69242Eb8F",
    valuation: "0xa513E6E4b8f2a923D98304ec87F64353C4D5C853",
    dutchAuction: "0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6",
    insurance: "0x8A791620dd6260079BF849Dc5567aDC3F2FdC318"
};

// 合约 ABI（包含所有需要的函数）
const RWA_TOKEN_ABI = [
    "function name() view returns (string)",
    "function symbol() view returns (string)",
    "function totalSupply() view returns (uint256)",
    "function balanceOf(address) view returns (uint256)",
    "function assetType() view returns (string)",
    "function assetValue() view returns (uint256)",
    "function whitelisted(address) view returns (bool)",
    "function admin() view returns (address)",
    "function spvAddress() view returns (address)",
    "function whitelistedCount() view returns (uint256)",
    "function complianceCheckEnabled() view returns (bool)",
    "function getTokenPrice() view returns (uint256)",
    "function getTokenInfo() view returns (string, string, string, uint256, uint256, uint256, uint256)",
    "function mint(address to, uint256 amount)",
    "function updateWhitelist(address account, bool status)",
    "function transfer(address to, uint256 amount) returns (bool)",
    "function approve(address spender, uint256 amount) returns (bool)",
    "function allowance(address owner, address spender) view returns (uint256)",
    "event Transfer(address indexed from, address indexed to, uint256 value)"
];

const COMPLIANCE_ABI = [
    "function investors(address) view returns (address wallet, string name, string kycId, uint256 verifiedAt, uint256 expiresAt, bool isAccredited, bool isBlacklisted, uint256 maxInvestment)",
    "function isVerified(address) view returns (bool)",
    "function isAccredited(address) view returns (bool)",
    "function verifyInvestor(address investor, string name, string kycId, bool isAccredited, uint256 maxInvestment, uint256 validityPeriod)",
    "function revokeInvestor(address investor, string reason)",
    "function getVerifiedInvestorCount() view returns (uint256)",
    "function getVerifiedInvestors() view returns (address[])",
    "function getBlacklistedAddresses() view returns (address[])",
    "function checkTransfer(address from, address to, uint256 amount) view returns (bool, string)",
    "function updateBlacklist(address account, bool status)",
    "function admin() view returns (address)",
    "function amlThreshold() view returns (uint256)",
    "function amlFlagged(address) view returns (bool)",
    "function amlRiskLevel(address) view returns (uint8)",
    "function cumulativeTradeVolume(address) view returns (uint256)",
    "function setAMLThreshold(uint256 threshold)",
    "function setAMLRiskLevel(address account, uint8 riskLevel)",
    "function clearAMLFlag(address account)",
    "function getAMLInfo(address account) view returns (uint256 volume, bool flagged, uint8 riskLevel)",
    "function issuanceLimit() view returns (uint256 maxSupply, uint256 maxInvestors, uint256 minLockupPeriod, uint256 maxInvestmentPerInvestor, bool enabled)",
    "function setIssuanceLimit(uint256 maxSupply, uint256 maxInvestors, uint256 minLockupPeriod, uint256 maxInvestmentPerInvestor, bool enabled)",
    "function checkIssuance(uint256 currentSupply, uint256 currentInvestorCount, uint256 mintAmount) view returns (bool, string)",
    "function getInvestorInfo(address investor) view returns (address wallet, string name, string kycId, uint256 verifiedAt, uint256 expiresAt, bool accredited, bool blacklisted, uint256 maxInvestment)"
];

const MARKETPLACE_ABI = [
    "function sellOrders(uint256) view returns (uint256 orderId, address seller, address tokenAddress, uint256 amount, uint256 totalAmount, uint256 pricePerToken, uint256 timestamp, bool active)",
    "function orderCount() view returns (uint256)",
    "function feeRate() view returns (uint256)",
    "function paused() view returns (bool)",
    "function totalVolume() view returns (uint256)",
    "function totalFeesCollected() view returns (uint256)",
    "function createSellOrder(address tokenAddress, uint256 amount, uint256 pricePerToken) returns (uint256)",
    "function buyTokens(uint256 orderId, uint256 amount) payable",
    "function cancelSellOrder(uint256 orderId)",
    "function getActiveOrders() view returns (uint256[])",
    "function getMarketStats() view returns (uint256, uint256, uint256, uint256)",
    "function getOrderTotal(uint256 orderId, uint256 amount) view returns (uint256 totalPrice, uint256 fee)",
    "function isMarketMaker(address) view returns (bool)",
    "function marketQuotes(address, address) view returns (address maker, address token, uint256 bidPrice, uint256 askPrice, uint256 bidAmount, uint256 askAmount, uint256 updatedAt, bool active)",
    "function marketMakers(uint256) view returns (address)",
    "function getMarketMakers() view returns (address[])",
    "function registerMarketMaker(address maker)",
    "function removeMarketMaker(address maker)",
    "function updateQuote(address token, uint256 bidPrice, uint256 askPrice, uint256 bidAmount, uint256 askAmount)",
    "function buyFromMaker(address maker, address token, uint256 amount) payable",
    "function sellToMaker(address maker, address token, uint256 amount)",
    "function otcTradeCount() view returns (uint256)",
    "function otcTrades(uint256) view returns (uint256 tradeId, address partyA, address partyB, address token, uint256 amount, uint256 price, uint256 createdAt, uint256 settledAt, uint8 status)",
    "function proposeOTC(address partyB, address token, uint256 amount, uint256 price) returns (uint256)",
    "function acceptOTC(uint256 tradeId)",
    "function settleOTC(uint256 tradeId) payable",
    "function cancelOTC(uint256 tradeId)",
    "function getOTCTrade(uint256 tradeId) view returns (tuple(uint256 tradeId, address partyA, address partyB, address token, uint256 amount, uint256 price, uint256 createdAt, uint256 settledAt, uint8 status))",
    "event SellOrderCreated(uint256 indexed orderId, address indexed seller, address token, uint256 amount, uint256 pricePerToken)",
    "event SellOrderFilled(uint256 indexed orderId, address indexed buyer, address indexed seller, uint256 amount, uint256 totalPrice, uint256 fee)",
    "event QuoteUpdated(address indexed maker, address indexed token, uint256 bid, uint256 ask)",
    "event OTCProposed(uint256 indexed tradeId, address indexed partyA, address partyB, uint256 amount, uint256 price)",
    "event OTCSettled(uint256 indexed tradeId, uint256 amount, uint256 price)"
];

const REVENUE_ABI = [
    "function distributions(uint256) view returns (uint256 distributionId, uint256 totalAmount, uint256 timestamp, uint256 snapshotBlock, string revenueType, bool finalized, uint256 claimedAmount, uint256 investorCount)",
    "function distributionCount() view returns (uint256)",
    "function claimRecords(uint256, address) view returns (uint256 amount, uint256 timestamp, bool claimed)",
    "function pendingClaims(address) view returns (uint256)",
    "function totalClaimed(address) view returns (uint256)",
    "function totalDistributed() view returns (uint256)",
    "function totalClaimedAmount() view returns (uint256)",
    "function claim(uint256 distributionId)",
    "function batchClaim(uint256[] distributionIds)",
    "function depositRevenue(string revenueType) payable",
    "function createDistribution(uint256 totalAmount, string revenueType, address[] investors, uint256[] amounts)",
    "function getSystemStats() view returns (uint256, uint256, uint256, uint256)",
    "function getClaimableDistributions(address investor) view returns (uint256[])",
    "function autoReinvestEnabled(address) view returns (bool)",
    "function reinvestedTotal(address) view returns (uint256)",
    "function toggleAutoReinvest(bool enabled)",
    "function claimWithReinvest(uint256 distributionId)",
    "function getReinvestStats(address investor) view returns (bool enabled, uint256 reinvested, uint256 totalClaimed_)",
    "event DistributionCreated(uint256 indexed distributionId, uint256 totalAmount, string revenueType, uint256 snapshotBlock, uint256 investorCount)",
    "event Claimed(uint256 indexed distributionId, address indexed investor, uint256 amount)",
    "event BatchClaimed(address indexed investor, uint256 count, uint256 totalAmount)",
    "event AutoReinvestToggled(address indexed investor, bool enabled)",
    "event RevenueReinvested(address indexed investor, uint256 amount)"
];

// 全局变量
let signer = null;
let userAddress = null;
let contracts = {};

// =====================================================
// 扩展合约 ABI（对应设计要求 4.2.1 / 4.3.1 / 4.3.2 / 4.2.3 / 4.4）
// =====================================================

const ASSET_REGISTRY_ABI = [
    "function assetCount() view returns (uint256)",
    "function assets(uint256) view returns (uint256 assetId, string name, uint8 category, uint256 totalValue, uint256 tokenizedAmount, address spvAddress, address tokenAddress, address issuer, uint256 registeredAt, bool isActive, string legalDocHash)",
    "function registerAsset(string name, uint8 category, uint256 totalValue, address spvAddress, address tokenAddress, string legalDocHash) returns (uint256)",
    "function publishDisclosure(uint256 assetId, string title, string contentHash) returns (uint256)",
    "function getAsset(uint256 assetId) view returns (tuple)",
    "function getSPVAssets(address spvAddress) view returns (uint256[])",
    "function getAssetDisclosures(uint256 assetId) view returns (uint256[])",
    "function getTokenizationRate(uint256 assetId) view returns (uint256)",
    "event AssetRegistered(uint256 indexed assetId, string name, uint8 category, address spvAddress, address tokenAddress)"
];

const LEGAL_ENFORCEMENT_ABI = [
    "function clauseCount() view returns (uint256)",
    "function disputeCount() view returns (uint256)",
    "function eventCount() view returns (uint256)",
    "function reportCount() view returns (uint256)",
    "function encodeClause(uint256 assetId, string title, string contentHash, bytes executionCode) returns (uint256)",
    "function fileDispute(uint256 assetId, address defendant, string reasonHash) returns (uint256)",
    "function resolveDispute(uint256 disputeId, bool plaintiffFavored, string verdictHash)",
    "function registerLegalEvent(uint256 assetId, string eventType, string triggerCondition) returns (uint256)",
    "function triggerLegalEvent(uint256 eventId)",
    "function generateReport(uint256 assetId, string reportType, string contentHash) returns (uint256)",
    "function getSystemStats() view returns (uint256, uint256, uint256, uint256, uint256)",
    "function getClause(uint256) view returns (tuple(uint256,uint256,string,string,bytes,uint256,bool))",
    "function getDispute(uint256) view returns (tuple(uint256,uint256,address,address,string,uint256,uint256,uint8,string,bool))",
    "function getLegalEvent(uint256) view returns (tuple(uint256,uint256,string,string,uint256,bool,string))",
    "function getReport(uint256) view returns (tuple(uint256,uint256,string,string,uint256,bool))",
    "event ClauseEncoded(uint256 indexed clauseId, uint256 indexed assetId, string title)",
    "event DisputeFiled(uint256 indexed disputeId, uint256 indexed assetId, address plaintiff, address defendant)"
];

const VALUATION_ABI = [
    "function valuationCount() view returns (uint256)",
    "function valuations(uint256) view returns (uint256 valuationId, uint256 assetId, uint8 method, uint256 estimatedValue, uint256 timestamp, string paramsHash, address appraiser, bool verified)",
    "function valuationByDCF(uint256 assetId, uint256[] cashFlows, uint256 discountRate, string paramsHash) returns (uint256)",
    "function valuationByComparable(uint256 assetId, uint256 comparableValue, uint256 adjustmentRate, string paramsHash) returns (uint256)",
    "function valuationByCost(uint256 assetId, uint256 replacementCost, uint256 depreciationRate, string paramsHash) returns (uint256)",
    "function valuationByMarket(uint256 assetId, uint256 recentTradePrice, uint256 marketAdjustFactor, string paramsHash) returns (uint256)",
    "function computeCompositeValue(uint256 assetId, uint256[] valuationIds, uint256[] weights) returns (uint256)",
    "function getLatestCompositeValue(uint256 assetId) view returns (uint256)",
    "function getAssetValuations(uint256 assetId) view returns (uint256[])",
    "event ValuationRecorded(uint256 indexed valuationId, uint256 indexed assetId, uint8 method, uint256 estimatedValue)"
];

const DUTCH_AUCTION_ABI = [
    "function auctionCount() view returns (uint256)",
    "function auctions(uint256) view returns (uint256 auctionId, address seller, address tokenAddress, uint256 tokenAmount, uint256 startPrice, uint256 reservePrice, uint256 priceDecrement, uint256 decrementInterval, uint256 startAt, uint256 endAt, uint256 currentPrice, address winner, uint256 settledAt, uint8 status)",
    "function createAuction(address tokenAddress, uint256 tokenAmount, uint256 startPrice, uint256 reservePrice, uint256 priceDecrement, uint256 decrementInterval, uint256 duration) returns (uint256)",
    "function getCurrentPrice(uint256 auctionId) view returns (uint256)",
    "function bid(uint256 auctionId) payable",
    "function cancelAuction(uint256 auctionId)",
    "function getAuctionStats() view returns (uint256, uint256, uint256)",
    "event AuctionCreated(uint256 indexed auctionId, address indexed seller, address token, uint256 amount, uint256 startPrice, uint256 reservePrice)",
    "event AuctionSettled(uint256 indexed auctionId, address winner, uint256 price)"
];

const INSURANCE_ABI = [
    "function policyCount() view returns (uint256)",
    "function claimCount() view returns (uint256)",
    "function policies(uint256) view returns (uint256 policyId, uint256 assetId, address insured, address insurer, uint256 coverageAmount, uint256 premium, uint256 startAt, uint256 endAt, uint8 status, string termsHash)",
    "function issuePolicy(uint256 assetId, address insured, uint256 coverageAmount, uint256 premium, uint256 duration, string termsHash) returns (uint256)",
    "function fileClaim(uint256 policyId, uint256 claimAmount, string reasonHash) returns (uint256)",
    "function approveClaim(uint256 claimId) payable",
    "function rejectClaim(uint256 claimId)",
    "function isPolicyActive(uint256 policyId) view returns (bool)",
    "function getInsuredPolicies(address insured) view returns (uint256[])",
    "function getInsuranceStats() view returns (uint256, uint256, uint256, uint256, uint256)",
    "event PolicyIssued(uint256 indexed policyId, uint256 indexed assetId, address indexed insured, uint256 coverage, uint256 premium)",
    "event ClaimPaid(uint256 indexed claimId, address indexed claimant, uint256 amount)"
];

const RISK_MANAGER_ABI = [
    "function positionCount() view returns (uint256)",
    "function liquidationCount() view returns (uint256)",
    "function totalCollateralValue() view returns (uint256)",
    "function totalBorrowValue() view returns (uint256)",
    "function stressScenarioCount() view returns (uint256)",
    "function systemSafetyThreshold() view returns (uint256)",
    "function admin() view returns (address)",
    "function insuranceContract() view returns (address)",
    "function positions(uint256) view returns (address owner, address collateralToken, address borrowToken, uint256 collateralAmount, uint256 borrowAmount, uint256 createdAt, bool isActive)",
    "function riskParams() view returns (uint256 minCollateralRatio, uint256 liquidationThreshold, uint256 liquidationPenalty, uint256 maxLeverage)",
    "function createPosition(address collateralToken, address borrowToken, uint256 collateralAmount, uint256 borrowAmount) returns (uint256)",
    "function closePosition(uint256 positionId)",
    "function addCollateral(uint256 positionId, uint256 amount)",
    "function repayDebt(uint256 positionId, uint256 amount)",
    "function liquidate(uint256 positionId)",
    "function liquidateWithInsurance(uint256 positionId)",
    "function getCollateralRatio(uint256 positionId) view returns (uint256)",
    "function isPositionHealthy(uint256 positionId) view returns (bool)",
    "function isLiquidatable(uint256 positionId) view returns (bool)",
    "function getSystemRiskStats() view returns (uint256, uint256, uint256, uint256, uint256)",
    "function detectUnhealthyPositions() view returns (uint256[])",
    "function getUserPositions(address user) view returns (uint256[])",
    "function updateRiskParams(uint256 minCollateralRatio, uint256 liquidationThreshold, uint256 liquidationPenalty, uint256 maxLeverage)",
    "function runStressTest(string name, uint256 priceDropPercent, string reportHash) returns (uint256)",
    "function setSafetyThreshold(uint256 threshold)",
    "function getStressScenario(uint256 scenarioId) view returns (tuple(uint256 scenarioId, string name, uint256 priceDropPercent, uint256 liquidationRatio, uint256 testedAt, uint256 affectedPositions, bool passed, string reportHash))",
    "function bindInsurance(uint256 positionId, uint256 policyId)",
    "function getPositionInsurance(uint256 positionId) view returns (bool insured, uint256 policyId)",
    "function setInsuranceContract(address insurance)",
    "event PositionCreated(uint256 indexed positionId, address indexed owner, uint256 collateralAmount, uint256 borrowAmount)",
    "event StressTestExecuted(uint256 indexed scenarioId, string name, uint256 affectedPositions, bool passed)"
];

// =====================================================
// 导航切换
// =====================================================

const NAV_TITLES = {
    overview: "总览", market: "交易市场", revenue: "收益分配",
    assets: "资产登记", valuation: "动态估值", auction: "荷兰拍卖",
    insurance: "保险集成", legal: "法律等效", risk: "风险管理",
    aml: "AML 合规"
};

document.addEventListener("DOMContentLoaded", () => {
    document.querySelectorAll(".nav-item").forEach(item => {
        item.addEventListener("click", () => switchView(item.dataset.target));
    });
    document.getElementById("menuToggle")?.addEventListener("click", () => {
        document.getElementById("sidebar").classList.toggle("open");
    });

    // 子导航切换（交易市场内）
    document.querySelectorAll(".subnav-btn").forEach(btn => {
        btn.addEventListener("click", () => switchSubView(btn.dataset.sub));
    });

    // 页面加载即初始化（无需 MetaMask，用 Hardhat 默认账户签名）
    init();
});

// Provider：通过前端服务器的 /rpc 代理访问 Hardhat 节点（解决容器外浏览器直连问题）
const RPC_URL = window.location.origin + "/rpc";
const READ_PROVIDER = new ethers.JsonRpcProvider(RPC_URL);

// Hardhat 默认 Account #0 私钥（管理员账户，本地测试用）
const DEFAULT_PRIVATE_KEY = "0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80";

// 写操作用的签名 Wallet（已在上方全局声明）
async function init() {
    console.log("[init] 开始初始化...");
    try {
        // 先验证 provider 可用
        const net = await READ_PROVIDER.getNetwork();
        console.log("[init] 网络连接成功:", net.chainId.toString());
        document.getElementById("walletAddress").textContent = "连接中...";
        document.getElementById("connectBtn").textContent = "验证中...";

        // 用默认私钥创建 Wallet（可签名交易，无需 MetaMask）
        signer = new ethers.Wallet(DEFAULT_PRIVATE_KEY, READ_PROVIDER);
        userAddress = signer.address;
        console.log("[init] 钱包创建成功:", userAddress);

        document.getElementById("walletAddress").textContent =
            userAddress.slice(0, 6) + "..." + userAddress.slice(-4);
        document.getElementById("connectBtn").textContent = "Admin";
        document.getElementById("connectBtn").classList.add("connected");

        initContracts();

        // 种子演示数据（仅首次，各模块独立检测）
        await seedDemoData();

        // 加载所有数据
        console.log("[init] 开始加载数据...");
        await refreshAssetInfo();
        await refreshAccountInfo();
        await refreshOrders();
        await refreshDistributions();
        await refreshAssets();
        await refreshValuations();
        await refreshAuctions();
        await refreshInsurance();
        await refreshLegal();
        await refreshRisk();
        await refreshStressTests();
        await refreshAML();
        await refreshMakers();
        await refreshOTC();
        await refreshReinvest();

        console.log("[init] 初始化完成！");
    } catch (e) {
        console.error("[init] 初始化失败:", e);
        document.getElementById("walletAddress").textContent = "错误";
        document.getElementById("connectBtn").textContent = "重试";
        document.getElementById("connectBtn").onclick = init;
        showStatus("初始化失败: " + e.message, "error");
    }
}



function switchView(target) {
    document.querySelectorAll(".view").forEach(v => v.classList.remove("active"));
    document.getElementById(target)?.classList.add("active");
    document.querySelectorAll(".nav-item").forEach(n => n.classList.remove("active"));
    document.querySelector(`.nav-item[data-target="${target}"]`)?.classList.add("active");
    document.getElementById("pageTitle").textContent = NAV_TITLES[target] || "RWA";
    document.getElementById("sidebar").classList.remove("open");

    // 切换到交易市场时默认显示订单簿
    if (target === "market") switchSubView("market-orders");
}

function switchSubView(subId) {
    const parent = document.getElementById(subId)?.closest(".view");
    if (!parent) return;
    parent.querySelectorAll(".subview").forEach(v => v.classList.remove("active"));
    document.getElementById(subId)?.classList.add("active");
    parent.querySelectorAll(".subnav-btn").forEach(b => b.classList.remove("active"));
    parent.querySelector(`.subnav-btn[data-sub="${subId}"]`)?.classList.add("active");
}

// =====================================================
// 合约初始化（用 signer 实例化，可读可写）
// =====================================================

function initContracts() {
    contracts.rwaToken = new ethers.Contract(CONTRACT_ADDRESSES.rwaToken, RWA_TOKEN_ABI, signer);
    contracts.compliance = new ethers.Contract(CONTRACT_ADDRESSES.compliance, COMPLIANCE_ABI, signer);
    contracts.marketplace = new ethers.Contract(CONTRACT_ADDRESSES.marketplace, MARKETPLACE_ABI, signer);
    contracts.revenue = new ethers.Contract(CONTRACT_ADDRESSES.revenueDistributor, REVENUE_ABI, signer);
    contracts.riskManager = new ethers.Contract(CONTRACT_ADDRESSES.riskManager, RISK_MANAGER_ABI, signer);

    // 扩展合约（设计要求 4.1-4.4 全模块）
    contracts.assetRegistry = new ethers.Contract(CONTRACT_ADDRESSES.assetRegistry, ASSET_REGISTRY_ABI, signer);
    contracts.legal = new ethers.Contract(CONTRACT_ADDRESSES.legalEnforcement, LEGAL_ENFORCEMENT_ABI, signer);
    contracts.valuation = new ethers.Contract(CONTRACT_ADDRESSES.valuation, VALUATION_ABI, signer);
    contracts.dutchAuction = new ethers.Contract(CONTRACT_ADDRESSES.dutchAuction, DUTCH_AUCTION_ABI, signer);
    contracts.insurance = new ethers.Contract(CONTRACT_ADDRESSES.insurance, INSURANCE_ABI, signer);
}

// =====================================================
// 数据刷新
// =====================================================

function setText(id, val) { const el = document.getElementById(id); if (el) el.textContent = val; }

async function refreshAssetInfo() {
    if (!contracts.rwaToken) return;
    try {
        const [name, symbol, assetType, assetValue, totalSupply, tokenPrice, whitelistedCount] = await contracts.rwaToken.getTokenInfo();
        setText("tokenName", name);
        setText("tokenSymbol", symbol);
        setText("assetType", assetType);
        setText("assetValue", formatEther(assetValue) + " USD");
        setText("totalSupply", formatEther(totalSupply) + " RWA");
        setText("tokenPrice", formatEther(tokenPrice) + " USD");
        setText("whitelistedCount", whitelistedCount.toString());
        setText("ovAssetValue", formatEther(assetValue));
        setText("ovTokenPrice", formatEther(tokenPrice));
        setText("ovTotalSupply", formatEther(totalSupply));
        setText("ovWhitelist", whitelistedCount.toString());
        try { const spv = await contracts.rwaToken.spvAddress(); setText("spvAddress", spv.slice(0, 10) + "..."); } catch (e) {}
    } catch (e) { console.error("资产信息失败:", e); }
}


async function refreshAccountInfo() {
    if (!contracts.rwaToken || !userAddress) return;

    try {
        const [balance, isWhitelisted] = await Promise.all([
            contracts.rwaToken.balanceOf(userAddress),
            contracts.rwaToken.whitelisted(userAddress)
        ]);

        document.getElementById("myBalance").textContent = formatEther(balance);
        document.getElementById("whitelistStatus").textContent = isWhitelisted ? "✅ 已认证" : "❌ 未认证";
        document.getElementById("whitelistStatus").style.color = isWhitelisted ? "#10b981" : "#ef4444";

        // 查询 KYC 状态
        if (contracts.compliance) {
            const [isVerified, isAccredited] = await Promise.all([
                contracts.compliance.isVerified(userAddress),
                contracts.compliance.isAccredited(userAddress)
            ]);
            document.getElementById("kycStatus").textContent = isVerified ? "✅ 已验证" : "❌ 未验证";
            document.getElementById("kycStatus").style.color = isVerified ? "#10b981" : "#ef4444";
            document.getElementById("accreditedStatus").textContent = isAccredited ? "✅ 是" : "❌ 否";
            document.getElementById("accreditedStatus").style.color = isAccredited ? "#10b981" : "#ef4444";
        }

        // 查询收益
        if (contracts.revenue) {
            const [pending, claimed] = await Promise.all([
                contracts.revenue.pendingClaims(userAddress),
                contracts.revenue.totalClaimed(userAddress)
            ]);
            document.getElementById("pendingClaims").textContent = formatEther(pending) + " ETH";
            document.getElementById("totalClaimed").textContent = formatEther(claimed) + " ETH";
        }
    } catch (err) {
        console.error("获取账户信息失败:", err);
    }
}

async function refreshOrders() {
    if (!contracts.marketplace) return;

    try {
        const [orderCount, totalVolume, totalFees, feeRate] = await contracts.marketplace.getMarketStats();
        document.getElementById("marketOrderCount").textContent = orderCount.toString();
        document.getElementById("marketFeeRate").textContent = (Number(feeRate) / 100).toFixed(2) + "%";
        document.getElementById("marketTotalVolume").textContent = formatEther(totalVolume) + " ETH";

        const orderList = document.getElementById("orderList");
        orderList.innerHTML = "";

        if (orderCount == 0) {
            orderList.innerHTML = '<p class="empty">暂无订单</p>';
            return;
        }

        let activeCount = 0;
        for (let i = 0; i < orderCount; i++) {
            const order = await contracts.marketplace.sellOrders(i);
            if (order.active) {
                activeCount++;
                // 合约已做精度归一化，pricePerToken 和 amount 相乘后除以 1e18
                const totalPrice = order.pricePerToken * order.amount / (10n ** 18n);
                const fee = (totalPrice * feeRate) / 10000n;

                const div = document.createElement("div");
                div.className = "list-item";
                div.innerHTML = `
                    <div class="li-info">
                        <strong>订单 #${order.orderId}</strong>
                        <span class="sub">卖家 ${order.seller.slice(0, 8)}...${order.seller.slice(-4)}</span>
                    </div>
                    <div class="li-tags">
                        <span class="tag cyan">数量 ${formatEther(order.amount)} RWA</span>
                        <span class="tag">单价 ${formatEther(order.pricePerToken)} ETH</span>
                        <span class="tag purple">总价 ${formatEther(totalPrice)} ETH</span>
                        <span class="tag amber">手续费 ${formatEther(fee)} ETH</span>
                    </div>
                    <button class="btn btn-primary" onclick="buyTokens(${order.orderId})">购买</button>
                `;
                orderList.appendChild(div);
            }
        }

        if (activeCount === 0) {
            orderList.innerHTML = '<p class="empty">暂无活跃订单</p>';
        }
    } catch (err) {
        console.error("获取订单失败:", err);
    }
}

async function refreshDistributions() {
    if (!contracts.revenue) return;

    try {
        const [count, totalDistributed, totalClaimedAmount, contractBalance] = await contracts.revenue.getSystemStats();
        document.getElementById("distCount").textContent = count.toString();
        document.getElementById("distTotalDistributed").textContent = formatEther(totalDistributed) + " ETH";
        document.getElementById("distTotalClaimed").textContent = formatEther(totalClaimedAmount) + " ETH";

        const list = document.getElementById("distributionList");
        list.innerHTML = "";

        if (count == 0) {
            list.innerHTML = '<p class="empty">暂无分配记录</p>';
            return;
        }

        for (let i = 0; i < count; i++) {
            const dist = await contracts.revenue.distributions(i);
            const claimRecord = await contracts.revenue.claimRecords(i, userAddress);

            const div = document.createElement("div");
            div.className = "list-item";
            div.innerHTML = `
                <div class="li-info">
                    <strong>分配 #${dist.distributionId} · ${dist.revenueType}</strong>
                    <span class="sub">总额 ${formatEther(dist.totalAmount)} ETH · ${dist.investorCount} 投资者</span>
                </div>
                <div class="li-tags">
                    <span class="tag ${dist.finalized ? 'green' : 'cyan'}">${dist.finalized ? '已完成' : '进行中'}</span>
                </div>
                <div>
                    ${!claimRecord.claimed && claimRecord.amount > 0 ?
                        `<button class="btn btn-primary" onclick="claimRevenue(${dist.distributionId})">领取 ${formatEther(claimRecord.amount)} ETH</button>` :
                        claimRecord.claimed ?
                        `<span class="tag green">✓ 已领取</span>` :
                        `<span class="tag">无分配</span>`
                    }
                </div>
            `;
            list.appendChild(div);
        }
    } catch (err) {
        console.error("获取分配记录失败:", err);
    }
}

// =====================================================
// 交易操作
// =====================================================

async function mintTokens() {
    const to = document.getElementById("mintTo").value;
    const amount = document.getElementById("mintAmount").value;

    if (!to || !amount) {
        alertModal("缺少参数", "请填写接收地址和代币数量");
        return;
    }

    try {
        showStatus("正在铸造代币...", "info");
        const tx = await contracts.rwaToken.mint(to, ethers.parseEther(amount));
        await tx.wait();
        showStatus("铸造成功！", "success");
        await refreshAssetInfo();
        await refreshAccountInfo();
    } catch (err) {
        showStatus("铸造失败: " + err.message, "error");
    }
}

async function addToWhitelist() {
    const addr = document.getElementById("whitelistAddr").value;

    if (!addr) {
        alertModal("缺少参数", "请填写要加入白名单的地址");
        return;
    }

    try {
        showStatus("正在添加白名单...", "info");
        const tx = await contracts.rwaToken.updateWhitelist(addr, true);
        await tx.wait();
        showStatus("白名单添加成功！", "success");
        await refreshAssetInfo();
    } catch (err) {
        showStatus("添加失败: " + err.message, "error");
    }
}

async function removeFromWhitelist() {
    const addr = document.getElementById("whitelistAddr").value;

    if (!addr) {
        alertModal("缺少参数", "请填写要从白名单移除的地址");
        return;
    }

    try {
        showStatus("正在移除白名单...", "info");
        const tx = await contracts.rwaToken.updateWhitelist(addr, false);
        await tx.wait();
        showStatus("白名单移除成功！", "success");
        await refreshAssetInfo();
    } catch (err) {
        showStatus("移除失败: " + err.message, "error");
    }
}

async function verifyInvestor() {
    const addr = document.getElementById("kycAddr").value;
    const name = document.getElementById("kycName").value;
    const kycId = document.getElementById("kycId").value;
    const isAccredited = document.getElementById("kycAccredited").checked;
    const maxInvestment = document.getElementById("kycMaxInvestment").value;

    if (!addr || !name || !kycId) {
        alertModal("缺少参数", "请填写投资者地址、姓名和 KYC 编号");
        return;
    }

    try {
        showStatus("正在验证投资者...", "info");
        const tx = await contracts.compliance.verifyInvestor(
            addr,
            name,
            kycId,
            isAccredited,
            ethers.parseEther(maxInvestment || "1000000"),
            365 * 24 * 3600  // 1年有效期
        );
        await tx.wait();
        showStatus("投资者验证成功！", "success");
    } catch (err) {
        showStatus("验证失败: " + err.message, "error");
    }
}

async function depositRevenue() {
    const revenueType = document.getElementById("revenueType").value;
    const amount = document.getElementById("revenueAmount").value;

    if (!revenueType || !amount) {
        alertModal("缺少参数", "请填写收益类型和金额");
        return;
    }

    try {
        showStatus("正在存入收益...", "info");
        const tx = await contracts.revenue.depositRevenue(revenueType, {
            value: ethers.parseEther(amount)
        });
        await tx.wait();
        showStatus("收益存入成功！", "success");
    } catch (err) {
        showStatus("存入失败: " + err.message, "error");
    }
}

async function createDistribution() {
    const amount = document.getElementById("distAmount").value;
    const distType = document.getElementById("distType").value;
    const investorsStr = document.getElementById("distInvestors").value;
    const amountsStr = document.getElementById("distAmounts").value;

    if (!amount || !distType || !investorsStr || !amountsStr) {
        alertModal("缺少参数", "请填写总金额、收益类型、投资者地址和分配比例");
        return;
    }

    try {
        showStatus("正在创建分配...", "info");
        const investors = investorsStr.split(",").map(s => s.trim());
        const amounts = amountsStr.split(",").map(s => ethers.parseEther(s.trim()));

        const tx = await contracts.revenue.createDistribution(
            ethers.parseEther(amount),
            distType,
            investors,
            amounts
        );
        await tx.wait();
        showStatus("分配创建成功！", "success");
        await refreshDistributions();
    } catch (err) {
        showStatus("创建失败: " + err.message, "error");
    }
}

async function createSellOrder() {
    const amount = document.getElementById("sellAmount").value;
    const price = document.getElementById("sellPrice").value;

    if (!amount || !price) {
        alertModal("缺少参数", "请填写卖出数量（代币）和单价（ETH）");
        return;
    }

    if (!CONTRACT_ADDRESSES.rwaToken) {
        alertModal("配置错误", "合约地址未配置，请联系管理员");
        return;
    }

    try {
        showStatus("正在创建卖单...", "info");

        // 先授权给市场合约
        const approveTx = await contracts.rwaToken.approve(CONTRACT_ADDRESSES.marketplace, ethers.parseEther(amount));
        await approveTx.wait();

        // 创建卖单（pricePerToken 以 ETH 为单位的 wei 值）
        const tx = await contracts.marketplace.createSellOrder(
            CONTRACT_ADDRESSES.rwaToken,
            ethers.parseEther(amount),
            ethers.parseEther(price)
        );
        await tx.wait();
        showStatus("卖单创建成功！", "success");
        await refreshOrders();
    } catch (err) {
        showStatus("创建失败: " + err.message, "error");
    }
}

async function buyTokens(orderId) {
    try {
        showStatus("正在购买...", "info");
        const order = await contracts.marketplace.sellOrders(orderId);
        // 合约已做精度归一化：totalPrice = pricePerToken * amount / 1e18
        const totalPrice = order.pricePerToken * order.amount / (10n ** 18n);

        const tx = await contracts.marketplace.buyTokens(orderId, order.amount, {
            value: totalPrice
        });
        await tx.wait();
        showStatus("购买成功！", "success");
        await refreshOrders();
        await refreshAccountInfo();
    } catch (err) {
        showStatus("购买失败: " + err.message, "error");
    }
}

async function claimRevenue(distributionId) {
    try {
        showStatus("正在领取收益...", "info");
        const tx = await contracts.revenue.claim(distributionId);
        await tx.wait();
        showStatus("收益领取成功！", "success");
        await refreshDistributions();
        await refreshAccountInfo();
    } catch (err) {
        showStatus("领取失败: " + err.message, "error");
    }
}

// =====================================================
// 扩展模块：资产登记 / 估值 / 拍卖 / 保险 / 法律
// =====================================================

// --- 资产登记层（4.2.1）---
async function refreshAssets() {
    if (!contracts.assetRegistry) return;
    try {
        const count = await contracts.assetRegistry.assetCount();
        const list = document.getElementById("assetList");
        if (!list) return;
        list.innerHTML = "";
        if (count == 0) { list.innerHTML = '<p class="empty">暂无资产</p>'; return; }
        const categoryNames = ["房地产", "股权", "债券", "大宗商品"];
        const catColors = ["cyan","purple","amber","green"];
        for (let i = 0; i < count; i++) {
            const a = await contracts.assetRegistry.assets(i);
            const div = document.createElement("div");
            div.className = "list-item";
            div.innerHTML = `
                <div class="li-info">
                    <strong>资产 #${a.assetId} · ${a.name}</strong>
                    <span class="sub">SPV ${a.spvAddress.slice(0,8)}...${a.spvAddress.slice(-4)}</span>
                </div>
                <div class="li-tags">
                    <span class="tag ${catColors[a.category]||''}">${categoryNames[a.category] || "未知"}</span>
                    <span class="tag cyan">注册估值 ${formatEther(a.totalValue)}</span>
                    <span class="tag">代币化 ${formatEther(a.tokenizedAmount)} RWA</span>
                    <span class="tag ${a.isActive?'green':'red'}">${a.isActive ? "活跃" : "停用"}</span>
                </div>`;
            list.appendChild(div);
        }
    } catch (err) { console.error("资产列表失败:", err); }
}

// --- 动态估值（4.3.2）---
async function refreshValuations() {
    if (!contracts.valuation) return;
    const assetId = 0; // 当前展示的资产
    try {
        const composite = await contracts.valuation.getLatestCompositeValue(assetId);
        const el = document.getElementById("compositeValue");
        if (el) el.textContent = formatEther(composite);
        const list = document.getElementById("valuationList");
        if (!list) return;
        list.innerHTML = "";

        const valIds = await contracts.valuation.getAssetValuations(assetId);
        if (valIds.length === 0) { list.innerHTML = '<p class="empty">暂无估值</p>'; return; }

        const methodNames = ["现金流折现", "可比公司法", "成本法", "市场法"];
        const methodColors = ["cyan","purple","amber","green"];
        for (let i = 0; i < valIds.length; i++) {
            const v = await contracts.valuation.valuations(valIds[i]);
            const div = document.createElement("div");
            div.className = "list-item";
            div.innerHTML = `
                <div class="li-info">
                    <strong>估值 #${v.valuationId} · ${methodNames[v.method] || "未知"}</strong>
                    <span class="sub">评估人 ${v.appraiser.slice(0,8)}...${v.appraiser.slice(-4)}</span>
                </div>
                <div class="li-tags">
                    <span class="tag ${methodColors[v.method]||''}">${formatEther(v.estimatedValue)} USD</span>
                    <span class="tag ${v.verified?'green':'amber'}">${v.verified ? "已验证" : "待验证"}</span>
                </div>`;
            list.appendChild(div);
        }
    } catch (err) { console.error("估值列表失败:", err); }
}

// --- 荷兰式拍卖（4.2.3）---
async function refreshAuctions() {
    if (!contracts.dutchAuction) return;
    try {
        const [count, settled, volume] = await contracts.dutchAuction.getAuctionStats();
        const el = document.getElementById("auctionStats");
        if (el) el.textContent = `${count}场 · 成交${settled} · ${formatEther(volume)} ETH`;
        const list = document.getElementById("auctionList");
        if (!list) return;
        list.innerHTML = "";
        if (count == 0) { list.innerHTML = '<p class="empty">暂无拍卖</p>'; return; }
        const statusNames = ["进行中", "已成交", "已取消"];
        const statusColors = ["cyan","green","red"];
        for (let i = 0; i < count; i++) {
            const a = await contracts.dutchAuction.auctions(i);
            const price = await contracts.dutchAuction.getCurrentPrice(i);
            const div = document.createElement("div");
            div.className = "list-item";
            div.innerHTML = `
                <div class="li-info">
                    <strong>拍卖 #${a.auctionId}</strong>
                    <span class="sub">卖家 ${a.seller.slice(0,8)}...${a.seller.slice(-4)}</span>
                </div>
                <div class="li-tags">
                    <span class="tag ${statusColors[a.status]||''}">${statusNames[a.status]}</span>
                    <span class="tag cyan">数量 ${formatEther(a.tokenAmount)} RWA</span>
                    <span class="tag purple">当前价 ${formatEther(price)} ETH</span>
                    <span class="tag amber">保留价 ${formatEther(a.reservePrice)} ETH</span>
                </div>
                ${a.status == 0 ? `<button class="btn btn-primary" onclick="bidAuction(${a.auctionId})">竞拍</button>` : ""}
            `;
            list.appendChild(div);
        }
    } catch (err) { console.error("拍卖列表失败:", err); }
}

async function bidAuction(auctionId) {
    try {
        showStatus("正在查询价格...", "info");
        const price = await contracts.dutchAuction.getCurrentPrice(auctionId);
        const tx = await contracts.dutchAuction.bid(auctionId, { value: price });
        await tx.wait();
        showStatus("竞拍成功！", "success");
        await refreshAuctions();
    } catch (err) { showStatus("竞拍失败: " + err.message, "error"); }
}

// --- 保险（4.4）---
async function refreshInsurance() {
    if (!contracts.insurance) return;
    try {
        const [pc, cc, cov, prem, paid] = await contracts.insurance.getInsuranceStats();
        setText("insPolicies", pc.toString());
        setText("insClaims", cc.toString());
        setText("insCoverage", formatEther(cov) + " ETH");
        setText("insPaid", formatEther(paid) + " ETH");
        const list = document.getElementById("insuranceList");
        if (!list) return;
        list.innerHTML = "";
        if (pc == 0) { list.innerHTML = '<p class="empty">暂无保单</p>'; return; }
        for (let i = 0; i < pc; i++) {
            const p = await contracts.insurance.policies(i);
            const active = await contracts.insurance.isPolicyActive(i);
            const div = document.createElement("div");
            div.className = "list-item";
            div.innerHTML = `
                <div class="li-info">
                    <strong>保单 #${p.policyId} · 资产 #${p.assetId}</strong>
                    <span class="sub">到期 ${new Date(Number(p.endAt) * 1000).toLocaleDateString()}</span>
                </div>
                <div class="li-tags">
                    <span class="tag ${active?'green':'red'}">${active ? "有效" : "失效"}</span>
                    <span class="tag cyan">保额 ${formatEther(p.coverageAmount)} ETH</span>
                    <span class="tag amber">保费 ${formatEther(p.premium)} ETH</span>
                    <span class="tag">投保人 ${p.insured.slice(0,6)}...${p.insured.slice(-4)}</span>
                </div>
                <div>
                    ${active ? `<button class="btn btn-accent btn-sm" onclick="fileClaim(${p.policyId})">发起理赔</button>` : ""}
                </div>`;
            list.appendChild(div);
        }
    } catch (err) { console.error("保险列表失败:", err); }
}

async function fileClaim(policyId) {
    const amount = await inputModal("发起理赔", "请输入理赔金额（ETH）", "0.1", "0.1");
    if (!amount) return;
    try {
        showStatus("正在发起理赔...", "info");
        const tx = await contracts.insurance.fileClaim(policyId, ethers.parseEther(amount), "QmClaimReason-" + Date.now());
        await tx.wait();
        showStatus("理赔申请已提交！", "success");
        await refreshInsurance();
    } catch (err) { showStatus("理赔失败: " + err.message, "error"); }
}

// --- 法律等效（4.3.1）---
const LEGAL_STATUS_NAMES = ["待处理", "仲裁中", "已裁决", "已取消"];
const LEGAL_STATUS_COLORS = ["amber", "cyan", "green", "red"];

async function refreshLegal() {
    if (!contracts.legal) return;
    try {
        const [cc, dc, ec, rc, pending] = await contracts.legal.getSystemStats();
        setText("legalClauses", cc.toString());
        setText("legalDisputes", `${dc} (待处理${pending})`);
        setText("legalEvents", ec.toString());
        setText("legalReports", rc.toString());

        const list = document.getElementById("legalList");
        if (!list) return;
        list.innerHTML = "";

        // 加载法律条款
        for (let i = 0; i < cc; i++) {
            try {
                const c = await contracts.legal.getClause(i);
                const div = document.createElement("div");
                div.className = "list-item";
                div.innerHTML = `
                    <div class="li-info">
                        <strong>📜 条款 #${c[0]} · ${c[2]}</strong>
                        <span class="sub">生效 ${new Date(Number(c[5]) * 1000).toLocaleDateString()}</span>
                    </div>
                    <div class="li-tags">
                        <span class="tag ${c[6] ? 'green' : 'amber'}">${c[6] ? "有效" : "已废止"}</span>
                        <span class="tag">资产 #${c[1]}</span>
                    </div>`;
                list.appendChild(div);
            } catch (e) { console.error("条款加载失败:", e); }
        }

        // 加载争议
        for (let i = 0; i < dc; i++) {
            try {
                const d = await contracts.legal.getDispute(i);
                const div = document.createElement("div");
                div.className = "list-item";
                div.innerHTML = `
                    <div class="li-info">
                        <strong>⚖ 争议 #${d[0]}</strong>
                        <span class="sub">原告 ${d[2].slice(0,8)}... vs ${d[3].slice(0,8)}...</span>
                    </div>
                    <div class="li-tags">
                        <span class="tag ${LEGAL_STATUS_COLORS[d[7]]||''}">${LEGAL_STATUS_NAMES[d[7]]||"未知"}</span>
                        <span class="tag">资产 #${d[1]}</span>
                    </div>`;
                list.appendChild(div);
            } catch (e) { console.error("争议加载失败:", e); }
        }

        // 加载法律事件
        for (let i = 0; i < ec; i++) {
            try {
                const ev = await contracts.legal.getLegalEvent(i);
                const div = document.createElement("div");
                div.className = "list-item";
                div.innerHTML = `
                    <div class="li-info">
                        <strong>⚡ 事件 #${ev[0]} · ${ev[2]}</strong>
                        <span class="sub">触发条件: ${ev[3]}</span>
                    </div>
                    <div class="li-tags">
                        <span class="tag ${ev[5] ? 'green' : 'cyan'}">${ev[5] ? "已触发" : "待触发"}</span>
                        <span class="tag">资产 #${ev[1]}</span>
                    </div>`;
                list.appendChild(div);
            } catch (e) { console.error("事件加载失败:", e); }
        }

        // 加载监管报告
        for (let i = 0; i < rc; i++) {
            try {
                const r = await contracts.legal.getReport(i);
                const div = document.createElement("div");
                div.className = "list-item";
                div.innerHTML = `
                    <div class="li-info">
                        <strong>📋 报告 #${r[0]} · ${r[2]}</strong>
                        <span class="sub">生成 ${new Date(Number(r[4]) * 1000).toLocaleDateString()}</span>
                    </div>
                    <div class="li-tags">
                        <span class="tag ${r[5] ? 'green' : 'amber'}">${r[5] ? "已验证" : "待验证"}</span>
                        <span class="tag">资产 #${r[1]}</span>
                    </div>`;
                list.appendChild(div);
            } catch (e) { console.error("报告加载失败:", e); }
        }

        if (list.children.length === 0) {
            list.innerHTML = '<p class="empty">暂无法律记录</p>';
        }
    } catch (err) { console.error("法律统计失败:", err); }
}

// =====================================================
// 种子演示数据（首次加载时自动创建，各模块独立检测）
// =====================================================

// 演示用 SPV 地址（Hardhat 测试账户 #1 #2 #3）
const SPV1 = "0x70997970C51812dc3A010C7d01b50e0d17dc79C8";
const SPV2 = "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC";
const SPV3 = "0x90F79bf6EB2c4f870365E785982E1f101E93b906";

async function seedDemoData() {
    console.log("[seed] 检查演示数据...");

    // --- 1. 资产登记 ---
    try {
        const count = Number(await contracts.assetRegistry.assetCount());
        if (count === 0) {
            console.log("[seed] 创建演示资产...");
            await (await contracts.assetRegistry.registerAsset(
                "上海陆家嘴金融中心写字楼", 0,
                ethers.parseEther("5000000"), SPV1,
                CONTRACT_ADDRESSES.rwaToken, "QmdemoRealEstate001"
            )).wait();
            await (await contracts.assetRegistry.registerAsset(
                "尖端科技股权基金 Alpha", 1,
                ethers.parseEther("3000000"), SPV2,
                CONTRACT_ADDRESSES.rwaToken, "QmdemoEquity002"
            )).wait();
            await (await contracts.assetRegistry.registerAsset(
                "绿色能源基础设施债券", 2,
                ethers.parseEther("2000000"), SPV3,
                CONTRACT_ADDRESSES.rwaToken, "QmdemoBond003"
            )).wait();
            console.log("[seed] 资产创建完成");
        }
    } catch (e) { console.error("[seed] 资产:", e.message); }

    // --- 2. 动态估值 (资产 #0) ---
    try {
        const vCount = Number(await contracts.valuation.valuationCount());
        if (vCount === 0) {
            console.log("[seed] 创建演示估值...");
            const cashFlows = [ethers.parseEther("10"), ethers.parseEther("12"), ethers.parseEther("15")];
            const vid1 = Number(await (await contracts.valuation.valuationByDCF(0, cashFlows, 800, "DCF-8%-3Y")).wait());
            const vid2 = Number(await (await contracts.valuation.valuationByComparable(0, ethers.parseEther("5500000"), 500, "PE-adj5%")).wait());
            const vid3 = Number(await (await contracts.valuation.valuationByCost(0, ethers.parseEther("4800000"), 1000, "Cost-dep10%")).wait());
            const vid4 = Number(await (await contracts.valuation.valuationByMarket(0, ethers.parseEther("5200000"), 300, "Market-adj3%")).wait());
            // 等估值 ID 稳定后计算综合
            const valIds = [];
            for (let i = 0; i < 4; i++) valIds.push(i);
            await (await contracts.valuation.computeCompositeValue(0, valIds, [25, 25, 25, 25])).wait();
            // 4.3.2 → 4.2.1：将动态估值同步到 RWAToken.assetValue，保证总览页数据一致
            const composite = await contracts.valuation.getLatestCompositeValue(0);
            await (await contracts.rwaToken.updateAssetValue(composite)).wait();
            console.log("[seed] 估值创建完成");
        }
    } catch (e) { console.error("[seed] 估值:", e.message); }

    // --- 3. 保险集成 ---
    try {
        const pCount = Number(await contracts.insurance.policyCount());
        if (pCount === 0) {
            console.log("[seed] 创建演示保单...");
            await (await contracts.insurance.issuePolicy(
                0, userAddress, ethers.parseEther("1000000"),
                ethers.parseEther("50000"), 365 * 24 * 3600, "QmPolicyTerms001"
            )).wait();
            // 发起一笔理赔
            await (await contracts.insurance.fileClaim(0, ethers.parseEther("200000"), "QmClaimFloodDamage")).wait();
            console.log("[seed] 保单创建完成");
        }
    } catch (e) { console.error("[seed] 保险:", e.message); }

    // --- 4. 法律等效 ---
    try {
        const lCount = Number(await contracts.legal.clauseCount());
        if (lCount === 0) {
            console.log("[seed] 创建演示法律数据...");
            await (await contracts.legal.encodeClause(0,
                "智能合约电子签名法律等效条款",
                "QmClauseESign", "0x01"
            )).wait();
            await (await contracts.legal.encodeClause(0,
                "链上资产确权与线下权利映射条款",
                "QmClauseTitleMap", "0x02"
            )).wait();
            await (await contracts.legal.encodeClause(0,
                "跨境监管合规自动报告条款",
                "QmClauseCrossBorder", "0x03"
            )).wait();
            await (await contracts.legal.encodeClause(0,
                "投资者适当性管理与风险披露条款",
                "QmClauseInvestor", "0x04"
            )).wait();
            // 登记一条争议
            await (await contracts.legal.fileDispute(0, SPV1, "QmDisputeValuation")).wait();
            // 法律事件
            await (await contracts.legal.registerLegalEvent(0, "违约触发", "标的资产净值跌破合约阈值70%")).wait();
            await (await contracts.legal.registerLegalEvent(0, "到期清算", "资产到期或提前赎回触发清算流程")).wait();
            // 监管报告
            await (await contracts.legal.generateReport(0, "季度合规审查", "QmReportQ1Compliance")).wait();
            await (await contracts.legal.generateReport(0, "反洗钱专项审计", "QmReportAMLAudit")).wait();
            console.log("[seed] 法律数据创建完成");
        }
    } catch (e) { console.error("[seed] 法律:", e.message); }

    // --- 5. 荷兰拍卖 ---
    try {
        const aCount = Number(await contracts.dutchAuction.auctionCount());
        if (aCount === 0) {
            console.log("[seed] 创建演示拍卖...");
            // 先铸币并授权
            await (await contracts.rwaToken.mint(userAddress, ethers.parseEther("5000"))).wait();
            await (await contracts.rwaToken.approve(CONTRACT_ADDRESSES.dutchAuction, ethers.parseEther("5000"))).wait();
            await (await contracts.dutchAuction.createAuction(
                CONTRACT_ADDRESSES.rwaToken, ethers.parseEther("1000"),
                ethers.parseEther("0.1"), ethers.parseEther("0.05"),
                ethers.parseEther("0.01"), 60, 3600
            )).wait();
            console.log("[seed] 拍卖创建完成");
        }
    } catch (e) { console.error("[seed] 拍卖:", e.message); }

    // --- 6. 交易市场 ---
    try {
        const oCount = Number(await contracts.marketplace.orderCount());
        if (oCount === 0) {
            console.log("[seed] 创建演示订单...");
            // 确保有代币并授权
            await (await contracts.rwaToken.mint(userAddress, ethers.parseEther("2000"))).wait();
            await (await contracts.rwaToken.approve(CONTRACT_ADDRESSES.marketplace, ethers.parseEther("2000"))).wait();
            await (await contracts.marketplace.createSellOrder(
                CONTRACT_ADDRESSES.rwaToken, ethers.parseEther("500"),
                ethers.parseEther("0.08")
            )).wait();
            await (await contracts.marketplace.createSellOrder(
                CONTRACT_ADDRESSES.rwaToken, ethers.parseEther("300"),
                ethers.parseEther("0.09")
            )).wait();
            await (await contracts.marketplace.createSellOrder(
                CONTRACT_ADDRESSES.rwaToken, ethers.parseEther("200"),
                ethers.parseEther("0.075")
            )).wait();
            console.log("[seed] 订单创建完成");
        }
    } catch (e) { console.error("[seed] 市场:", e.message); }

    // --- 7. 收益分配 ---
    try {
        const dCount = Number(await contracts.revenue.distributionCount());
        if (dCount === 0) {
            console.log("[seed] 创建演示收益分配...");
            await (await contracts.revenue.depositRevenue("写字楼租金收入 Q1", {
                value: ethers.parseEther("10")
            })).wait();
            const investors = [SPV1, SPV2, SPV3];
            const amounts = [ethers.parseEther("4"), ethers.parseEther("3"), ethers.parseEther("3")];
            await (await contracts.revenue.createDistribution(
                ethers.parseEther("10"), "租金收入", investors, amounts
            )).wait();
            await (await contracts.revenue.depositRevenue("股息收入", {
                value: ethers.parseEther("5")
            })).wait();
            const amounts2 = [ethers.parseEther("2"), ethers.parseEther("1.5"), ethers.parseEther("1.5")];
            await (await contracts.revenue.createDistribution(
                ethers.parseEther("5"), "股息收入", investors, amounts2
            )).wait();
            console.log("[seed] 收益分配创建完成");
        }
    } catch (e) { console.error("[seed] 收益:", e.message); }

    console.log("[seed] 演示数据检查完毕");
}

// =====================================================
// 风险管理模块（4.4 风险管理框架）
// =====================================================

async function refreshRisk() {
    if (!contracts.riskManager) return;
    try {
        const [posCount, totalColl, totalBor, sysRatio, liqCount] = await contracts.riskManager.getSystemRiskStats();
        setText("riskSysRatio", sysRatio == 0 || sysRatio > 1e10 ? "N/A" : formatEther(sysRatio) + "%");
        setText("riskTotalColl", formatEther(totalColl) + " ETH");
        setText("riskTotalBor", formatEther(totalBor) + " ETH");
        setText("riskLiqCount", liqCount.toString());

        // 加载风险参数
        const rp = await contracts.riskManager.riskParams();
        setText("rpMinRatio", rp.minCollateralRatio.toString() + "%");
        setText("rpLiqTh", rp.liquidationThreshold.toString() + "%");
        setText("rpLiqPen", rp.liquidationPenalty.toString() + "%");
        setText("rpMaxLev", rp.maxLeverage.toString() + "x");

        // 加载仓位列表
        const list = document.getElementById("riskPositionList");
        if (!list) return; list.innerHTML = "";
        if (posCount == 0) { list.innerHTML = '<p class="empty">暂无仓位</p>'; return; }

        for (let i = 0; i < posCount; i++) {
            const p = await contracts.riskManager.positions(i);
            if (!p.isActive) continue;
            const ratio = await contracts.riskManager.getCollateralRatio(i);
            const healthy = await contracts.riskManager.isPositionHealthy(i);
            const liquidatable = await contracts.riskManager.isLiquidatable(i);
            const [insured, policyId] = await contracts.riskManager.getPositionInsurance(i);

            const div = document.createElement("div");
            div.className = "list-item";
            div.innerHTML = `
                <div class="li-info">
                    <strong>仓位 #${i} · 抵押率 ${ratio > 1e10 ? "∞" : ratio + "%"}</strong>
                    <span class="sub">持有人 ${p.owner.slice(0,8)}...${p.owner.slice(-4)}</span>
                </div>
                <div class="li-tags">
                    <span class="tag cyan">抵押 ${formatEther(p.collateralAmount)}</span>
                    <span class="tag amber">借入 ${formatEther(p.borrowAmount)}</span>
                    <span class="tag ${healthy ? 'green' : 'red'}">${healthy ? '健康' : '风险'}</span>
                    ${insured ? '<span class="tag purple">📋 已投保 #' + policyId + '</span>' : ''}
                </div>
                <div class="btn-row">
                    <button class="btn btn-primary btn-sm" onclick="addCollateral(${i})">加抵押</button>
                    <button class="btn btn-accent btn-sm" onclick="repayDebt(${i})">还款</button>
                    ${liquidatable ? `<button class="btn btn-danger btn-sm" onclick="liquidatePos(${i})">清算</button>` : ''}
                    <button class="btn btn-mini" onclick="closePosition(${i})">✕</button>
                </div>`;
            list.appendChild(div);
        }
    } catch (e) { console.error("风险管理刷新失败:", e); }
}

async function refreshStressTests() {
    if (!contracts.riskManager) return;
    try {
        const count = Number(await contracts.riskManager.stressScenarioCount());
        const threshold = await contracts.riskManager.systemSafetyThreshold();
        document.getElementById("safetyThreshold").value = threshold.toString();

        const list = document.getElementById("riskStressList");
        if (!list) return; list.innerHTML = "";
        if (count === 0) { list.innerHTML = '<p class="empty">暂无压力测试</p>'; return; }

        for (let i = 0; i < count; i++) {
            const s = await contracts.riskManager.getStressScenario(i);
            const div = document.createElement("div");
            div.className = "list-item";
            div.innerHTML = `
                <div class="li-info">
                    <strong>场景 #${s.scenarioId} · ${s.name}</strong>
                    <span class="sub">测试时间 ${new Date(Number(s.testedAt)*1000).toLocaleDateString()}</span>
                </div>
                <div class="li-tags">
                    <span class="tag cyan">跌幅 ${Number(s.priceDropPercent)/100}%</span>
                    <span class="tag amber">影响 ${s.affectedPositions} 仓位</span>
                    <span class="tag ${s.passed ? 'green' : 'red'}">${s.passed ? '通过' : '未通过'}</span>
                    <span class="tag">清算比 ${Number(s.liquidationRatio)/100}%</span>
                </div>`;
            list.appendChild(div);
        }
    } catch (e) { console.error("压力测试刷新失败:", e); }
}

async function createPosition() {
    const collToken = document.getElementById("riskCollToken").value;
    const borToken = document.getElementById("riskBorToken").value;
    const collAmt = document.getElementById("riskCollAmount").value;
    const borAmt = document.getElementById("riskBorAmount").value;
    if (!collToken || !borToken || !collAmt || !borAmt) {
        alertModal("缺少参数", "请填写抵押/借入代币地址及数量");
        return;
    }
    try {
        showStatus("创建仓位中...", "info");
        const tx = await contracts.riskManager.createPosition(
            collToken, borToken,
            ethers.parseEther(collAmt), ethers.parseEther(borAmt)
        );
        await tx.wait();
        showStatus("仓位创建成功！", "success");
        await refreshRisk();
    } catch (e) { showStatus("创建失败: " + e.message, "error"); }
}

async function closePosition(posId) {
    try {
        showStatus("关闭仓位中...", "info");
        const tx = await contracts.riskManager.closePosition(posId);
        await tx.wait();
        showStatus("仓位已关闭", "success");
        await refreshRisk();
    } catch (e) { showStatus("关闭失败: " + e.message, "error"); }
}

async function addCollateral(posId) {
    const amt = await inputModal("追加抵押", "请输入追加数量 (ETH)", "1", "1");
    if (!amt) return;
    try {
        showStatus("追加抵押中...", "info");
        const tx = await contracts.riskManager.addCollateral(posId, ethers.parseEther(amt));
        await tx.wait();
        showStatus("抵押追加成功", "success");
        await refreshRisk();
    } catch (e) { showStatus("追加失败: " + e.message, "error"); }
}

async function repayDebt(posId) {
    const amt = await inputModal("归还借款", "请输入归还数量 (ETH)", "0.5", "0.5");
    if (!amt) return;
    try {
        showStatus("还款中...", "info");
        const tx = await contracts.riskManager.repayDebt(posId, ethers.parseEther(amt));
        await tx.wait();
        showStatus("还款成功", "success");
        await refreshRisk();
    } catch (e) { showStatus("还款失败: " + e.message, "error"); }
}

async function liquidatePos(posId) {
    try {
        showStatus("清算中...", "info");
        const tx = await contracts.riskManager.liquidate(posId);
        await tx.wait();
        showStatus("清算完成！", "success");
        await refreshRisk();
    } catch (e) { showStatus("清算失败: " + e.message, "error"); }
}

async function updateRiskParams() {
    const minRatio = await inputModal("更新风险参数", "最低抵押率 (%)", "150", "150");
    if (!minRatio) return;
    const liqTh = await inputModal("清算阈值", "清算阈值 (%)", "120", "120");
    if (!liqTh) return;
    const liqPen = await inputModal("清算罚金", "清算罚金 (%)", "10", "10");
    if (!liqPen) return;
    const maxLev = await inputModal("最大杠杆", "最大杠杆倍数", "3", "3");
    if (!maxLev) return;
    try {
        showStatus("更新参数中...", "info");
        const tx = await contracts.riskManager.updateRiskParams(parseInt(minRatio), parseInt(liqTh), parseInt(liqPen), parseInt(maxLev));
        await tx.wait();
        showStatus("参数更新成功", "success");
        await refreshRisk();
    } catch (e) { showStatus("更新失败: " + e.message, "error"); }
}

async function runStressTest() {
    const name = document.getElementById("stressName").value;
    const drop = document.getElementById("stressDrop").value;
    if (!name || !drop) { alertModal("缺少参数", "请填写场景名称和跌幅"); return; }
    try {
        showStatus("压力测试中...", "info");
        const tx = await contracts.riskManager.runStressTest(name, parseInt(drop), "QmStress-" + Date.now());
        await tx.wait();
        showStatus("压力测试完成！", "success");
        await refreshStressTests();
    } catch (e) { showStatus("测试失败: " + e.message, "error"); }
}

async function setSafetyThreshold() {
    const v = document.getElementById("safetyThreshold").value;
    if (!v) { alertModal("缺少参数", "请输入安全阈值"); return; }
    try {
        showStatus("设置中...", "info");
        const tx = await contracts.riskManager.setSafetyThreshold(parseInt(v));
        await tx.wait();
        showStatus("阈值更新成功", "success");
    } catch (e) { showStatus("设置失败: " + e.message, "error"); }
}

async function bindInsurance() {
    const posId = document.getElementById("insBindPosId").value;
    const policyId = document.getElementById("insBindPolicyId").value;
    if (!posId || !policyId) { alertModal("缺少参数", "请填写仓位ID和保单ID"); return; }
    try {
        showStatus("绑定中...", "info");
        const tx = await contracts.riskManager.bindInsurance(parseInt(posId), parseInt(policyId));
        await tx.wait();
        showStatus("保险绑定成功", "success");
        await refreshRisk();
    } catch (e) { showStatus("绑定失败: " + e.message, "error"); }
}

// =====================================================
// AML 合规模块（4.2.2 反洗钱 + 发行限制）
// =====================================================

async function refreshAML() {
    if (!contracts.compliance) return;
    try {
        const thr = await contracts.compliance.amlThreshold();
        setText("amlThresholdVal", formatEther(thr) + " ETH");

        const verified = await contracts.compliance.getVerifiedInvestors();
        const blacklisted = await contracts.compliance.getBlacklistedAddresses();
        if (blacklisted.length > 0) setText("amlBlackCnt", blacklisted.length.toString());

        // 发行限制
        const iss = await contracts.compliance.issuanceLimit();
        setText("amlIssEnabled", iss.enabled ? "✅ 启用" : "❌ 禁用");
        document.getElementById("issMaxSupply").value = formatEther(iss.maxSupply);
        document.getElementById("issMaxInvestors").value = iss.maxInvestors.toString();
        document.getElementById("issMinLockup").value = iss.minLockupPeriod.toString();
        document.getElementById("issMaxPerInv").value = formatEther(iss.maxInvestmentPerInvestor);
        document.getElementById("issEnabled").checked = iss.enabled;

        // 投资者列表
        const list = document.getElementById("amlInvestorList");
        if (!list) return; list.innerHTML = "";
        let flaggedCount = 0;
        for (let i = 0; i < verified.length; i++) {
            const addr = verified[i];
            try {
                const [volume, flagged, riskLevel] = await contracts.compliance.getAMLInfo(addr);
                if (flagged) flaggedCount++;
                const inv = await contracts.compliance.getInvestorInfo(addr);
                const div = document.createElement("div");
                div.className = "list-item";
                div.innerHTML = `
                    <div class="li-info">
                        <strong>${inv.name || addr.slice(0,8)}</strong>
                        <span class="sub mono">${addr.slice(0,10)}...${addr.slice(-6)}</span>
                    </div>
                    <div class="li-tags">
                        <span class="tag cyan">交易量 ${formatEther(volume)}</span>
                        <span class="tag ${riskLevel >= 2 ? 'red' : riskLevel >= 1 ? 'amber' : 'green'}">
                            AML ${['正常','低风险','中风险','高风险'][riskLevel]}</span>
                        <span class="tag ${flagged ? 'red' : 'green'}">${flagged ? '已标记' : '正常'}</span>
                        <span class="tag ${inv.blacklisted ? 'red' : ''}">${inv.blacklisted ? '⛔ 黑名单' : '✅ 正常'}</span>
                    </div>`;
                list.appendChild(div);
            } catch (e) { console.error("AML:", addr, e); }
        }
        setText("amlFlaggedCnt", flaggedCount.toString());
        if (list.children.length === 0) list.innerHTML = '<p class="empty">暂无投资者数据</p>';
    } catch (e) { console.error("AML刷新失败:", e); }
}

async function setAMLThreshold() {
    const v = document.getElementById("amlThrInput").value;
    if (!v) { alertModal("缺少参数", "请输入AML阈值"); return; }
    try {
        showStatus("设置AML阈值...", "info");
        const tx = await contracts.compliance.setAMLThreshold(ethers.parseEther(v));
        await tx.wait();
        showStatus("AML阈值更新成功", "success");
        await refreshAML();
    } catch (e) { showStatus("设置失败: " + e.message, "error"); }
}

async function setAMLRiskLevel() {
    const addr = document.getElementById("amlAcct").value;
    const lvl = parseInt(document.getElementById("amlRiskLvl").value);
    if (!addr) { alertModal("缺少参数", "请填写投资者地址"); return; }
    try {
        showStatus("更新风险等级...", "info");
        const tx = await contracts.compliance.setAMLRiskLevel(addr, lvl);
        await tx.wait();
        showStatus("风险等级更新成功", "success");
        await refreshAML();
    } catch (e) { showStatus("设置失败: " + e.message, "error"); }
}

async function clearAMLFlag() {
    const addr = document.getElementById("amlAcct").value;
    if (!addr) { alertModal("缺少参数", "请填写投资者地址"); return; }
    try {
        showStatus("清除AML标记...", "info");
        const tx = await contracts.compliance.clearAMLFlag(addr);
        await tx.wait();
        showStatus("AML标记已清除", "success");
        await refreshAML();
    } catch (e) { showStatus("清除失败: " + e.message, "error"); }
}

async function updateBlacklist(status) {
    const addr = document.getElementById("amlAcct").value;
    if (!addr) { alertModal("缺少参数", "请填写投资者地址"); return; }
    try {
        showStatus(status ? "加入黑名单..." : "移除黑名单...", "info");
        const tx = await contracts.compliance.updateBlacklist(addr, status);
        await tx.wait();
        showStatus(status ? "已加入黑名单" : "已移出黑名单", "success");
        await refreshAML();
    } catch (e) { showStatus("操作失败: " + e.message, "error"); }
}

async function setIssuanceLimit() {
    const maxSupply = document.getElementById("issMaxSupply").value;
    const maxInvestors = document.getElementById("issMaxInvestors").value;
    const minLockup = document.getElementById("issMinLockup").value;
    const maxPerInv = document.getElementById("issMaxPerInv").value;
    const enabled = document.getElementById("issEnabled").checked;
    try {
        showStatus("保存发行限制...", "info");
        const tx = await contracts.compliance.setIssuanceLimit(
            ethers.parseEther(maxSupply || "0"),
            parseInt(maxInvestors || "0"),
            parseInt(minLockup || "0"),
            ethers.parseEther(maxPerInv || "0"),
            enabled
        );
        await tx.wait();
        showStatus("发行限制保存成功", "success");
        await refreshAML();
    } catch (e) { showStatus("保存失败: " + e.message, "error"); }
}

// =====================================================
// 做市商系统（4.2.3 做市商系统）
// =====================================================

async function refreshMakers() {
    if (!contracts.marketplace) return;
    try {
        const makers = await contracts.marketplace.getMarketMakers();
        const list = document.getElementById("makerList");
        if (!list) return; list.innerHTML = "";
        if (makers.length === 0) { list.innerHTML = '<p class="empty">暂无做市商</p>'; return; }

        for (const maker of makers) {
            try {
                const quote = await contracts.marketplace.marketQuotes(maker, CONTRACT_ADDRESSES.rwaToken);
                const div = document.createElement("div");
                div.className = "list-item";
                div.innerHTML = `
                    <div class="li-info">
                        <strong>做市商</strong>
                        <span class="sub mono">${maker.slice(0,10)}...${maker.slice(-6)}</span>
                    </div>
                    <div class="li-tags">
                        ${quote.active ?
                            `<span class="tag cyan">买价 ${formatEther(quote.bidPrice)} ETH</span>
                            <span class="tag amber">卖价 ${formatEther(quote.askPrice)} ETH</span>
                            <span class="tag">买量 ${formatEther(quote.bidAmount)}</span>
                            <span class="tag">卖量 ${formatEther(quote.askAmount)}</span>` :
                            '<span class="tag red">无报价</span>'}
                    </div>
                    <div class="btn-row">
                        ${quote.active && quote.askAmount > 0 ?
                            `<button class="btn btn-primary btn-sm" onclick="buyFromMaker('${maker}')">买入</button>
                             <button class="btn btn-accent btn-sm" onclick="sellToMaker('${maker}')">卖出</button>` : ''}
                    </div>`;
                list.appendChild(div);
            } catch (e) { console.error("做市商:", e); }
        }
    } catch (e) { console.error("做市商列表失败:", e); }
}

async function registerMarketMaker() {
    const addr = document.getElementById("makerAddr").value;
    if (!addr) { alertModal("缺少参数", "请填写做市商地址"); return; }
    try {
        showStatus("注册做市商...", "info");
        const tx = await contracts.marketplace.registerMarketMaker(addr);
        await tx.wait();
        showStatus("做市商注册成功", "success");
        await refreshMakers();
    } catch (e) { showStatus("注册失败: " + e.message, "error"); }
}

async function removeMarketMaker() {
    const addr = document.getElementById("makerAddr").value;
    if (!addr) { alertModal("缺少参数", "请填写做市商地址"); return; }
    try {
        showStatus("移除做市商...", "info");
        const tx = await contracts.marketplace.removeMarketMaker(addr);
        await tx.wait();
        showStatus("做市商已移除", "success");
        await refreshMakers();
    } catch (e) { showStatus("移除失败: " + e.message, "error"); }
}

async function updateQuote() {
    const maker = document.getElementById("quoteMaker").value;
    const bidP = document.getElementById("quoteBidPrice").value;
    const askP = document.getElementById("quoteAskPrice").value;
    const bidA = document.getElementById("quoteBidAmt").value;
    const askA = document.getElementById("quoteAskAmt").value;
    if (!maker || !bidP || !askP || !bidA || !askA) {
        alertModal("缺少参数", "请填写所有报价参数");
        return;
    }
    try {
        showStatus("更新报价中...", "info");
        const tx = await contracts.marketplace.updateQuote(
            CONTRACT_ADDRESSES.rwaToken,
            ethers.parseEther(bidP),
            ethers.parseEther(askP),
            ethers.parseEther(bidA),
            ethers.parseEther(askA)
        );
        await tx.wait();
        showStatus("报价更新成功", "success");
        await refreshMakers();
    } catch (e) { showStatus("更新失败: " + e.message, "error"); }
}

async function buyFromMaker(makerAddr) {
    const amt = await inputModal("从做市商买入", "请输入购买数量", "10", "10");
    if (!amt) return;
    try {
        const quote = await contracts.marketplace.marketQuotes(makerAddr, CONTRACT_ADDRESSES.rwaToken);
        const cost = quote.askPrice * ethers.parseEther(amt) / (10n ** 18n);
        showStatus("交易中...", "info");
        const tx = await contracts.marketplace.buyFromMaker(
            makerAddr, CONTRACT_ADDRESSES.rwaToken, ethers.parseEther(amt),
            { value: cost }
        );
        await tx.wait();
        showStatus("买入成功", "success");
        await refreshMakers();
    } catch (e) { showStatus("买入失败: " + e.message, "error"); }
}

async function sellToMaker(makerAddr) {
    const amt = await inputModal("卖给做市商", "请输入卖出数量", "10", "10");
    if (!amt) return;
    try {
        // 授权
        const approveTx = await contracts.rwaToken.approve(CONTRACT_ADDRESSES.marketplace, ethers.parseEther(amt));
        await approveTx.wait();
        showStatus("交易中...", "info");
        const tx = await contracts.marketplace.sellToMaker(makerAddr, CONTRACT_ADDRESSES.rwaToken, ethers.parseEther(amt));
        await tx.wait();
        showStatus("卖出成功", "success");
        await refreshMakers();
    } catch (e) { showStatus("卖出失败: " + e.message, "error"); }
}

// =====================================================
// OTC 场外交易（4.2.3 OTC市场）
// =====================================================

async function refreshOTC() {
    if (!contracts.marketplace) return;
    try {
        const count = Number(await contracts.marketplace.otcTradeCount());
        const list = document.getElementById("otcList");
        if (!list) return; list.innerHTML = "";
        if (count === 0) { list.innerHTML = '<p class="empty">暂无OTC交易</p>'; return; }
        const statusNames = ["待接受", "已接受", "已结算", "已取消"];
        const statusColors = ["amber", "cyan", "green", "red"];
        for (let i = 0; i < count; i++) {
            const t = await contracts.marketplace.otcTrades(i);
            const div = document.createElement("div");
            div.className = "list-item";
            div.innerHTML = `
                <div class="li-info">
                    <strong>OTC #${t.tradeId} · ${statusNames[t.status]}</strong>
                    <span class="sub">${t.partyA.slice(0,8)}... ↔ ${t.partyB.slice(0,8)}...</span>
                </div>
                <div class="li-tags">
                    <span class="tag cyan">数量 ${formatEther(t.amount)}</span>
                    <span class="tag purple">单价 ${formatEther(t.price)} ETH</span>
                    <span class="tag ${statusColors[t.status]}">${statusNames[t.status]}</span>
                </div>
                <div class="btn-row">
                    ${t.status == 0 ? `<button class="btn btn-accent btn-sm" onclick="acceptOTC(${t.tradeId})">接受</button>` : ''}
                    ${t.status == 1 ? `<button class="btn btn-primary btn-sm" onclick="settleOTC(${t.tradeId})">结算</button>` : ''}
                    ${t.status <= 1 ? `<button class="btn btn-danger btn-sm" onclick="cancelOTC(${t.tradeId})">取消</button>` : ''}
                </div>`;
            list.appendChild(div);
        }
    } catch (e) { console.error("OTC列表失败:", e); }
}

async function proposeOTC() {
    const partyB = document.getElementById("otcPartyB").value;
    const amount = document.getElementById("otcAmount").value;
    const price = document.getElementById("otcPrice").value;
    if (!partyB || !amount || !price) {
        alertModal("缺少参数", "请填写对手方、数量和价格");
        return;
    }
    try {
        showStatus("发起OTC中...", "info");
        const tx = await contracts.marketplace.proposeOTC(
            partyB, CONTRACT_ADDRESSES.rwaToken,
            ethers.parseEther(amount), ethers.parseEther(price)
        );
        await tx.wait();
        showStatus("OTC交易已发起", "success");
        await refreshOTC();
    } catch (e) { showStatus("发起失败: " + e.message, "error"); }
}

async function acceptOTC(tradeId) {
    try {
        showStatus("接受OTC中...", "info");
        const tx = await contracts.marketplace.acceptOTC(tradeId);
        await tx.wait();
        showStatus("OTC已接受", "success");
        await refreshOTC();
    } catch (e) { showStatus("接受失败: " + e.message, "error"); }
}

async function settleOTC(tradeId) {
    try {
        showStatus("结算OTC中...", "info");
        const t = await contracts.marketplace.otcTrades(tradeId);
        const total = t.price * t.amount / (10n ** 18n);
        const tx = await contracts.marketplace.settleOTC(tradeId, { value: total });
        await tx.wait();
        showStatus("OTC已结算", "success");
        await refreshOTC();
        await refreshAccountInfo();
    } catch (e) { showStatus("结算失败: " + e.message, "error"); }
}

async function cancelOTC(tradeId) {
    try {
        showStatus("取消OTC中...", "info");
        const tx = await contracts.marketplace.cancelOTC(tradeId);
        await tx.wait();
        showStatus("OTC已取消", "success");
        await refreshOTC();
    } catch (e) { showStatus("取消失败: " + e.message, "error"); }
}

// =====================================================
// 自动再投资（4.3.3 自动再投资）
// =====================================================

async function refreshReinvest() {
    if (!contracts.revenue || !userAddress) return;
    try {
        const [enabled, reinvested, totalClaimed_] = await contracts.revenue.getReinvestStats(userAddress);
        setText("reinStatus", enabled ? "✅ 已开启" : "❌ 关闭");
        setText("reinTotal", formatEther(reinvested) + " ETH");
        setText("reinClaimed", formatEther(totalClaimed_) + " ETH");
    } catch (e) { console.error("再投资刷新失败:", e); }
}

async function toggleReinvest(enabled) {
    try {
        showStatus(enabled ? "开启再投资..." : "关闭再投资...", "info");
        const tx = await contracts.revenue.toggleAutoReinvest(enabled);
        await tx.wait();
        showStatus(enabled ? "自动再投资已开启" : "自动再投资已关闭", "success");
        await refreshReinvest();
    } catch (e) { showStatus("操作失败: " + e.message, "error"); }
}

async function claimWithReinvest() {
    const distId = document.getElementById("reinDistId").value;
    if (!distId) { alertModal("缺少参数", "请填写分配ID"); return; }
    try {
        showStatus("领取并再投资中...", "info");
        const tx = await contracts.revenue.claimWithReinvest(parseInt(distId));
        await tx.wait();
        showStatus("领取并再投资成功", "success");
        await refreshReinvest();
        await refreshDistributions();
        await refreshAccountInfo();
    } catch (e) { showStatus("再投资失败: " + e.message, "error"); }
}

// =====================================================
// 工具函数
// =====================================================

function formatEther(wei) {
    try {
        const num = parseFloat(ethers.formatEther(wei));
        if (!isFinite(num) || isNaN(num)) return "0";
        if (num === 0) return "0";
        // 去掉多余小数位，保留有效数字
        let s;
        if (Math.abs(num) >= 1e8) s = (num / 1e8).toFixed(2) + "亿";
        else if (Math.abs(num) >= 1e4) s = (num / 1e4).toFixed(2) + "万";
        else if (Math.abs(num) < 0.01) s = parseFloat(num.toPrecision(3)).toString();
        else s = num.toFixed(2);
        // 去掉尾部无意义的 0 和小数点
        return s.replace(/\.?0+$/, '').replace(/\.00$/, '');
    } catch {
        return wei.toString();
    }
}

let _modalAutoCloseTimer = null;

function showStatus(message, type) {
    // 清除之前的自动关闭定时器，防止冲突
    if (_modalAutoCloseTimer) {
        clearTimeout(_modalAutoCloseTimer);
        _modalAutoCloseTimer = null;
    }

    const icon = type === "success" ? "✅" : type === "error" ? "❌" : "ℹ";
    const title = type === "success" ? "操作成功" : type === "error" ? "操作失败" : "处理中";

    showModal({ type: "alert", title, message, icon });

    // info 消息 2 秒后自动关闭，success/error 需手动点"知道了"
    if (type === "info") {
        _modalAutoCloseTimer = setTimeout(() => {
            closeModal();
            _modalAutoCloseTimer = null;
        }, 2000);
    }
}

// =====================================================
// 通用弹窗
// =====================================================

/**
 * 全局弹窗。type 支持:
 *   'alert'  — 纯消息 + 关闭按钮
 *   'input'  — 带输入框 + 确认/取消，返回 Promise<string|null>
 */
function showModal(opts) {
    const overlay = document.getElementById("modalOverlay");
    const titleEl  = document.getElementById("modalTitle");
    const iconEl   = document.getElementById("modalIcon");
    const bodyEl   = document.getElementById("modalBody");
    const footEl   = document.getElementById("modalFoot");

    const { type="alert", title="提示", icon="ℹ", message, placeholder, value, onConfirm } = opts;
    titleEl.textContent = title;
    iconEl.textContent = icon;
    bodyEl.innerHTML = `<p>${message}</p>`;
    footEl.innerHTML = "";
    overlay.style.display = "flex";

    if (type === "input") {
        bodyEl.innerHTML += `<input class="modal-input" id="modalInputField" placeholder="${placeholder||''}" value="${value||''}" autofocus>`;
        const inputEl = bodyEl.querySelector("#modalInputField");

        return new Promise((resolve) => {
            footEl.innerHTML = `
                <button class="btn" id="modalCancel">取消</button>
                <button class="btn btn-primary" id="modalConfirm">确认</button>`;
            document.getElementById("modalCancel").onclick = () => { closeModal(); resolve(null); };
            document.getElementById("modalConfirm").onclick = () => {
                const v = inputEl.value.trim();
                closeModal();
                resolve(v || null);
            };
            inputEl.addEventListener("keydown", (e) => {
                if (e.key === "Enter") { document.getElementById("modalConfirm").click(); }
                if (e.key === "Escape") { document.getElementById("modalCancel").click(); }
            });
            setTimeout(() => inputEl.focus(), 100);
        });
    }

    // alert 类型
    footEl.innerHTML = `<button class="btn btn-primary" id="modalClose">知道了</button>`;
    document.getElementById("modalClose").onclick = closeModal;
    overlay.addEventListener("keydown", (e) => {
        if (e.key === "Escape" || e.key === "Enter") closeModal();
    }, { once: true });
}

function closeModal() {
    if (_modalAutoCloseTimer) {
        clearTimeout(_modalAutoCloseTimer);
        _modalAutoCloseTimer = null;
    }
    document.getElementById("modalOverlay").style.display = "none";
}

/** 快捷弹窗：错误提示 */
function alertModal(title, message) {
    return showModal({ type:"alert", title, message, icon:"⚠" });
}
/** 快捷弹窗：成功提示 */
function successModal(title, message) {
    return showModal({ type:"alert", title, message, icon:"✅" });
}
/** 快捷弹窗：带输入框，返回用户输入字符串 */
function inputModal(title, message, placeholder, defaultValue) {
    return showModal({ type:"input", title, message, placeholder, value:defaultValue, icon:"💬" });
}
