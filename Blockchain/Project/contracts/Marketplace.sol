// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title Marketplace - RWA 交易市场
 * @notice 挂单式交易市场，支持代币实际转账、合规检查、手续费机制
 * @dev 包含 ReentrancyGuard 防止重入攻击
 */
contract Marketplace {
    // =====================================================
    // 数据结构
    // =====================================================

    /**
     * @dev 卖单结构体
     */
    struct SellOrder {
        uint256 orderId;
        address seller;
        address tokenAddress;
        uint256 amount;         // 剩余代币数量
        uint256 totalAmount;    // 原始挂单数量
        uint256 pricePerToken;  // 单价（wei）
        uint256 timestamp;
        bool active;
    }

    // =====================================================
    // 状态变量
    // =====================================================

    /// @notice 合约管理员
    address public admin;

    /// @notice 关联的合规合约
    address public complianceContract;

    /// @notice 关联的 RWA 代币合约
    address public rwaToken;

    /// @notice 卖单映射
    mapping(uint256 => SellOrder) public sellOrders;

    /// @notice 卖单计数器
    uint256 public orderCount;

    /// @notice 用户活跃卖单列表
    mapping(address => uint256[]) public userOrders;

    /// @notice 市场手续费率（万分之几，如 25 = 0.25%）
    uint256 public feeRate = 25;

    /// @notice 手续费接收地址
    address public feeReceiver;

    /// @notice 重入锁
    uint256 private _reentrancyStatus;

    /// @notice 市场是否暂停
    bool public paused;

    /// @notice 累计交易量
    uint256 public totalVolume;

    /// @notice 累计手续费收入
    uint256 public totalFeesCollected;

    // =====================================================
    // 事件
    // =====================================================

    event SellOrderCreated(uint256 indexed orderId, address indexed seller, address token, uint256 amount, uint256 pricePerToken);
    event SellOrderCancelled(uint256 indexed orderId, address indexed seller, uint256 refundAmount);
    event SellOrderFilled(uint256 indexed orderId, address indexed buyer, address indexed seller, uint256 amount, uint256 totalPrice, uint256 fee);
    event FeeRateUpdated(uint256 oldRate, uint256 newRate);
    event MarketPaused(address indexed admin);
    event MarketUnpaused(address indexed admin);
    event ComplianceCheckFailed(address indexed from, address indexed to, string reason);

    // =====================================================
    // 修饰器
    // =====================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "Marketplace: caller is not admin");
        _;
    }

    modifier orderExists(uint256 orderId) {
        require(orderId < orderCount, "Marketplace: order does not exist");
        _;
    }

    modifier orderActive(uint256 orderId) {
        require(sellOrders[orderId].active, "Marketplace: order not active");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Marketplace: market is paused");
        _;
    }

    /**
     * @dev 重入保护修饰器
     */
    modifier nonReentrant() {
        require(_reentrancyStatus != 1, "Marketplace: reentrant call");
        _reentrancyStatus = 1;
        _;
        _reentrancyStatus = 0;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    constructor(address _complianceContract, address _rwaToken) {
        admin = msg.sender;
        feeReceiver = msg.sender;
        complianceContract = _complianceContract;
        rwaToken = _rwaToken;
    }

    // =====================================================
    // 卖单功能
    // =====================================================

    /**
     * @dev 创建卖单 - 卖家需先 approve 代币给市场合约
     * @param tokenAddress 代币合约地址
     * @param amount 卖出数量
     * @param pricePerToken 每个代币价格（wei）
     * @return orderId 订单ID
     */
    function createSellOrder(
        address tokenAddress,
        uint256 amount,
        uint256 pricePerToken
    ) public whenNotPaused returns (uint256) {
        require(amount > 0, "Marketplace: amount must be positive");
        require(pricePerToken > 0, "Marketplace: price must be positive");
        require(tokenAddress != address(0), "Marketplace: zero address");

        // 检查卖家是否已授权代币给市场合约
        uint256 allowance = _getTokenAllowance(tokenAddress, msg.sender, address(this));
        require(allowance >= amount, "Marketplace: insufficient token allowance");

        // 检查卖家余额
        uint256 balance = _getTokenBalance(tokenAddress, msg.sender);
        require(balance >= amount, "Marketplace: insufficient token balance");

        uint256 orderId = orderCount;

        sellOrders[orderId] = SellOrder({
            orderId: orderId,
            seller: msg.sender,
            tokenAddress: tokenAddress,
            amount: amount,
            totalAmount: amount,
            pricePerToken: pricePerToken,
            timestamp: block.timestamp,
            active: true
        });

        userOrders[msg.sender].push(orderId);
        orderCount++;

        emit SellOrderCreated(orderId, msg.sender, tokenAddress, amount, pricePerToken);

        return orderId;
    }

    /**
     * @dev 取消卖单
     * @dev 卖家的代币仍在自己手中（创建卖单时仅approve未transfer），
     *      取消后卖家可自行撤销approve或保留授权以便重新挂单
     * @param orderId 订单ID
     */
    function cancelSellOrder(uint256 orderId) public orderExists(orderId) orderActive(orderId) {
        SellOrder storage order = sellOrders[orderId];
        require(order.seller == msg.sender, "Marketplace: not seller");

        order.active = false;

        emit SellOrderCancelled(orderId, msg.sender, order.amount);
    }

    // =====================================================
    // 购买功能
    // =====================================================

    /**
     * @dev 购买代币 - 买家支付ETH，市场合约转代币给买家
     * @param orderId 订单ID
     * @param amount 购买数量
     */
    function buyTokens(uint256 orderId, uint256 amount)
        public
        payable
        whenNotPaused
        nonReentrant
        orderExists(orderId)
        orderActive(orderId)
    {
        SellOrder storage order = sellOrders[orderId];

        require(amount > 0, "Marketplace: zero amount");
        require(amount <= order.amount, "Marketplace: insufficient order amount");

        // pricePerToken 和 amount 都带 18 位精度（代币的最小单位），相乘后需除以 1e18
        uint256 totalPrice = (order.pricePerToken * amount) / 1e18;
        require(msg.value >= totalPrice, "Marketplace: insufficient payment");

        // 合规检查（如果合规合约已配置）
        if (complianceContract != address(0)) {
            (bool compliant, string memory reason) = _checkCompliance(order.seller, msg.sender, amount);
            if (!compliant) {
                emit ComplianceCheckFailed(order.seller, msg.sender, reason);
                revert(string(abi.encodePacked("Marketplace: compliance failed - ", reason)));
            }
        }

        // 计算费用（totalPrice 已在上面计算）
        uint256 fee = (totalPrice * feeRate) / 10000;
        uint256 sellerProceeds = totalPrice - fee;

        // 更新订单状态
        order.amount -= amount;
        if (order.amount == 0) {
            order.active = false;
        }

        // 更新统计
        totalVolume += totalPrice;
        totalFeesCollected += fee;

        // 1. 从卖家转代币给买家（通过代币合约的 transferFrom）
        // 注意：卖家在创建卖单前已 approve 给市场合约
        _transferTokenFrom(order.tokenAddress, order.seller, msg.sender, amount);

        // 2. 转 ETH 给卖家
        (bool sellerSuccess, ) = payable(order.seller).call{value: sellerProceeds}("");
        require(sellerSuccess, "Marketplace: seller ETH transfer failed");

        // 3. 转手续费
        if (fee > 0) {
            (bool feeSuccess, ) = payable(feeReceiver).call{value: fee}("");
            require(feeSuccess, "Marketplace: fee transfer failed");
        }

        // 4. 退还多余支付
        if (msg.value > totalPrice) {
            (bool refundSuccess, ) = payable(msg.sender).call{value: msg.value - totalPrice}("");
            require(refundSuccess, "Marketplace: refund failed");
        }

        emit SellOrderFilled(orderId, msg.sender, order.seller, amount, totalPrice, fee);
    }

    /**
     * @dev 购买订单全部代币
     * @param orderId 订单ID
     */
    function buyAllTokens(uint256 orderId) public payable whenNotPaused nonReentrant orderExists(orderId) orderActive(orderId) {
        SellOrder memory order = sellOrders[orderId];
        buyTokens(orderId, order.amount);
    }

    // =====================================================
    // 查询功能
    // =====================================================

    /**
     * @dev 获取订单详情
     */
    function getOrder(uint256 orderId) public view returns (SellOrder memory) {
        return sellOrders[orderId];
    }

    /**
     * @dev 获取用户的所有订单
     */
    function getUserOrders(address user) public view returns (uint256[] memory) {
        return userOrders[user];
    }

    /**
     * @dev 获取订单总价（含费用）
     * @param orderId 订单ID
     * @param amount 购买数量
     * @return totalPrice 总价
     * @return fee 手续费
     */
    function getOrderTotal(uint256 orderId, uint256 amount) public view returns (uint256 totalPrice, uint256 fee) {
        SellOrder memory order = sellOrders[orderId];
        totalPrice = (order.pricePerToken * amount) / 1e18;
        fee = (totalPrice * feeRate) / 10000;
    }

    /**
     * @dev 获取所有活跃订单ID
     * @return activeOrders 活跃订单ID数组
     */
    function getActiveOrders() public view returns (uint256[] memory) {
        uint256 activeCount = 0;
        for (uint256 i = 0; i < orderCount; i++) {
            if (sellOrders[i].active) {
                activeCount++;
            }
        }

        uint256[] memory activeOrders = new uint256[](activeCount);
        uint256 idx = 0;
        for (uint256 i = 0; i < orderCount; i++) {
            if (sellOrders[i].active) {
                activeOrders[idx] = i;
                idx++;
            }
        }
        return activeOrders;
    }

    /**
     * @dev 获取市场统计信息
     */
    function getMarketStats() public view returns (
        uint256 _orderCount,
        uint256 _totalVolume,
        uint256 _totalFees,
        uint256 _feeRate
    ) {
        return (orderCount, totalVolume, totalFeesCollected, feeRate);
    }

    // =====================================================
    // 内部函数
    // =====================================================

    /**
     * @dev 查询代币余额
     */
    function _getTokenBalance(address token, address account) internal view returns (uint256) {
        (bool success, bytes memory data) = token.staticcall(
            abi.encodeWithSignature("balanceOf(address)", account)
        );
        require(success, "Marketplace: balanceOf call failed");
        return abi.decode(data, (uint256));
    }

    /**
     * @dev 查询代币授权额度
     */
    function _getTokenAllowance(address token, address owner, address spender) internal view returns (uint256) {
        (bool success, bytes memory data) = token.staticcall(
            abi.encodeWithSignature("allowance(address,address)", owner, spender)
        );
        require(success, "Marketplace: allowance call failed");
        return abi.decode(data, (uint256));
    }

    /**
     * @dev 从卖家转代币给买家（通过 transferFrom）
     */
    function _transferTokenFrom(address token, address from, address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Marketplace: transferFrom failed");
    }

    /**
     * @dev 直接转代币（用于取消订单退款）
     */
    function _transferToken(address token, address from, address to, uint256 amount) internal {
        (bool success, bytes memory data) = token.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", from, to, amount)
        );
        require(success && (data.length == 0 || abi.decode(data, (bool))), "Marketplace: token transfer failed");
    }

    /**
     * @dev 调用合规合约检查转账
     */
    function _checkCompliance(address from, address to, uint256 amount) internal view returns (bool, string memory) {
        (bool success, bytes memory data) = complianceContract.staticcall(
            abi.encodeWithSignature("checkTransfer(address,address,uint256)", from, to, amount)
        );
        if (!success) {
            return (false, "Compliance check call failed");
        }
        return abi.decode(data, (bool, string));
    }

    // =====================================================
    // 管理功能
    // =====================================================

    /**
     * @dev 更新手续费率
     */
    function updateFeeRate(uint256 newRate) public onlyAdmin {
        require(newRate <= 1000, "Marketplace: fee too high"); // 最高10%
        uint256 oldRate = feeRate;
        feeRate = newRate;
        emit FeeRateUpdated(oldRate, newRate);
    }

    /**
     * @dev 更新手续费接收地址
     */
    function updateFeeReceiver(address newReceiver) public onlyAdmin {
        require(newReceiver != address(0), "Marketplace: zero address");
        feeReceiver = newReceiver;
    }

    /**
     * @dev 更新合规合约地址
     */
    function setComplianceContract(address _complianceContract) public onlyAdmin {
        complianceContract = _complianceContract;
    }

    /**
     * @dev 更新 RWA 代币地址
     */
    function setRWAToken(address _rwaToken) public onlyAdmin {
        rwaToken = _rwaToken;
    }

    /**
     * @dev 暂停市场
     */
    function pause() public onlyAdmin {
        paused = true;
        emit MarketPaused(msg.sender);
    }

    /**
     * @dev 恢复市场
     */
    function unpause() public onlyAdmin {
        paused = false;
        emit MarketUnpaused(msg.sender);
    }

    /**
     * @dev 提取合约余额（仅管理员）
     */
    function withdraw() public onlyAdmin nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "Marketplace: no balance");

        (bool success, ) = payable(admin).call{value: balance}("");
        require(success, "Marketplace: withdraw failed");
    }

    // =====================================================
    // 做市商系统（对应设计要求 4.2.3 做市商系统）
    // =====================================================

    /// @dev 做市商报价
    struct MarketQuote {
        address maker;          // 做市商
        address token;          // 代币地址
        uint256 bidPrice;       // 买价（做市商愿意买入）
        uint256 askPrice;       // 卖价（做市商愿意卖出）
        uint256 bidAmount;      // 买量
        uint256 askAmount;      // 卖量
        uint256 updatedAt;      // 更新时间
        bool active;            // 是否活跃
    }

    /// @notice 做市商列表
    address[] public marketMakers;

    /// @notice 做市商是否注册
    mapping(address => bool) public isMarketMaker;

    /// @notice 做市商报价：maker => token => quote
    mapping(address => mapping(address => MarketQuote)) public marketQuotes;

    /// @notice 做市商累计成交量
    mapping(address => uint256) public makerVolume;

    event MarketMakerRegistered(address indexed maker);
    event MarketMakerRemoved(address indexed maker);
    event QuoteUpdated(address indexed maker, address indexed token, uint256 bid, uint256 ask);
    event QuoteTaken(address indexed maker, address indexed taker, bool isBuy, uint256 amount, uint256 price);

    /**
     * @dev 注册做市商（仅管理员，做市商为市场提供流动性）
     */
    function registerMarketMaker(address maker) public onlyAdmin {
        require(maker != address(0), "Marketplace: zero address");
        require(!isMarketMaker[maker], "Marketplace: already maker");
        isMarketMaker[maker] = true;
        marketMakers.push(maker);
        emit MarketMakerRegistered(maker);
    }

    /**
     * @dev 移除做市商
     */
    function removeMarketMaker(address maker) public onlyAdmin {
        require(isMarketMaker[maker], "Marketplace: not maker");
        isMarketMaker[maker] = false;
        emit MarketMakerRemoved(maker);
    }

    /**
     * @dev 做市商更新报价（提供买卖报价，提升交易深度，减少滑点）
     */
    function updateQuote(
        address token,
        uint256 bidPrice,
        uint256 askPrice,
        uint256 bidAmount,
        uint256 askAmount
    ) public whenNotPaused {
        require(isMarketMaker[msg.sender], "Marketplace: not market maker");
        require(bidPrice > 0 && askPrice > 0, "Marketplace: zero price");
        require(bidPrice < askPrice, "Marketplace: bid >= ask");

        marketQuotes[msg.sender][token] = MarketQuote({
            maker: msg.sender,
            token: token,
            bidPrice: bidPrice,
            askPrice: askPrice,
            bidAmount: bidAmount,
            askAmount: askAmount,
            updatedAt: block.timestamp,
            active: true
        });

        emit QuoteUpdated(msg.sender, token, bidPrice, askPrice);
    }

    /**
     * @dev 从做市商买入（按 askPrice 成交）
     * @param maker 做市商地址
     * @param token 代币地址
     * @param amount 购买数量
     */
    function buyFromMaker(address maker, address token, uint256 amount) public payable whenNotPaused nonReentrant {
        MarketQuote storage quote = marketQuotes[maker][token];
        require(quote.active, "Marketplace: quote not active");
        require(amount <= quote.askAmount, "Marketplace: exceeds ask amount");

        uint256 cost = quote.askPrice * amount;
        require(msg.value >= cost, "Marketplace: insufficient payment");

        // 合规检查
        if (complianceContract != address(0)) {
            (bool compliant, string memory reason) = _checkCompliance(maker, msg.sender, amount);
            require(compliant, string(abi.encodePacked("Marketplace: compliance - ", reason)));
        }

        quote.askAmount -= amount;

        // 转代币
        _transferTokenFrom(token, maker, msg.sender, amount);

        // 付ETH给做市商
        (bool ok, ) = payable(maker).call{value: cost}("");
        require(ok, "Marketplace: maker payment failed");

        // 退还多余
        if (msg.value > cost) {
            (bool refund, ) = payable(msg.sender).call{value: msg.value - cost}("");
            require(refund, "Marketplace: refund failed");
        }

        makerVolume[maker] += cost;
        totalVolume += cost;
        emit QuoteTaken(maker, msg.sender, true, amount, quote.askPrice);
    }

    /**
     * @dev 卖给做市商（按 bidPrice 成交）
     */
    function sellToMaker(address maker, address token, uint256 amount) public whenNotPaused nonReentrant {
        MarketQuote storage quote = marketQuotes[maker][token];
        require(quote.active, "Marketplace: quote not active");
        require(amount <= quote.bidAmount, "Marketplace: exceeds bid amount");

        // 合规检查
        if (complianceContract != address(0)) {
            (bool compliant, string memory reason) = _checkCompliance(msg.sender, maker, amount);
            require(compliant, string(abi.encodePacked("Marketplace: compliance - ", reason)));
        }

        uint256 proceeds = quote.bidPrice * amount;

        quote.bidAmount -= amount;

        // 转代币给做市商
        _transferTokenFrom(token, msg.sender, maker, amount);

        // 付ETH给卖家
        (bool ok, ) = payable(msg.sender).call{value: proceeds}("");
        require(ok, "Marketplace: seller payment failed");

        makerVolume[maker] += proceeds;
        totalVolume += proceeds;
        emit QuoteTaken(maker, msg.sender, false, amount, quote.bidPrice);
    }

    function getMarketMakers() public view returns (address[] memory) {
        return marketMakers;
    }

    function getMarketQuote(address maker, address token) public view returns (MarketQuote memory) {
        return marketQuotes[maker][token];
    }

    // =====================================================
    // OTC 场外交易（对应设计要求 4.2.3 OTC市场）
    // =====================================================

    /// @dev OTC 交易意向
    struct OTCTrade {
        uint256 tradeId;
        address partyA;         // 发起方
        address partyB;         // 对手方
        address token;          // 代币地址
        uint256 amount;         // 数量
        uint256 price;          // 协商价格
        uint256 createdAt;      // 创建时间
        uint256 settledAt;      // 成交时间
        OTCStatus status;       // 状态
    }

    enum OTCStatus { Pending, Accepted, Settled, Cancelled }

    mapping(uint256 => OTCTrade) public otcTrades;
    uint256 public otcTradeCount;

    event OTCProposed(uint256 indexed tradeId, address indexed partyA, address partyB, uint256 amount, uint256 price);
    event OTCAccepted(uint256 indexed tradeId);
    event OTCSettled(uint256 indexed tradeId, uint256 amount, uint256 price);
    event OTCCancelled(uint256 indexed tradeId);

    /**
     * @dev 发起 OTC 交易意向（机构场外交易，双边协商价格数量）
     * @param partyB 对手方地址
     * @param token 代币地址
     * @param amount 数量
     * @param price 协商价格
     */
    function proposeOTC(
        address partyB,
        address token,
        uint256 amount,
        uint256 price
    ) public whenNotPaused returns (uint256) {
        require(partyB != address(0) && partyB != msg.sender, "Marketplace: invalid party");
        require(amount > 0 && price > 0, "Marketplace: zero amount/price");
        require(token != address(0), "Marketplace: zero token");

        uint256 tradeId = otcTradeCount;
        otcTrades[tradeId] = OTCTrade({
            tradeId: tradeId,
            partyA: msg.sender,
            partyB: partyB,
            token: token,
            amount: amount,
            price: price,
            createdAt: block.timestamp,
            settledAt: 0,
            status: OTCStatus.Pending
        });

        otcTradeCount++;
        emit OTCProposed(tradeId, msg.sender, partyB, amount, price);
        return tradeId;
    }

    /**
     * @dev 接受 OTC 交易（对手方确认）
     */
    function acceptOTC(uint256 tradeId) public whenNotPaused {
        require(tradeId < otcTradeCount, "Marketplace: not found");
        OTCTrade storage t = otcTrades[tradeId];
        require(t.status == OTCStatus.Pending, "Marketplace: not pending");
        require(msg.sender == t.partyB, "Marketplace: not partyB");

        t.status = OTCStatus.Accepted;
        emit OTCAccepted(tradeId);
    }

    /**
     * @dev 结算 OTC 交易（partyA 支付ETH获得代币，系统提供担保清算）
     *      partyB 需先 approve 代币给本合约
     */
    function settleOTC(uint256 tradeId) public payable whenNotPaused nonReentrant {
        require(tradeId < otcTradeCount, "Marketplace: not found");
        OTCTrade storage t = otcTrades[tradeId];
        require(t.status == OTCStatus.Accepted, "Marketplace: not accepted");
        require(msg.sender == t.partyA, "Marketplace: not partyA");

        uint256 total = t.price * t.amount;
        require(msg.value >= total, "Marketplace: insufficient payment");

        // 合规检查
        if (complianceContract != address(0)) {
            (bool compliant, string memory reason) = _checkCompliance(t.partyB, t.partyA, t.amount);
            require(compliant, string(abi.encodePacked("Marketplace: compliance - ", reason)));
        }

        // 转代币：partyB -> partyA
        _transferTokenFrom(t.token, t.partyB, t.partyA, t.amount);

        // 转ETH给partyB
        (bool ok, ) = payable(t.partyB).call{value: total}("");
        require(ok, "Marketplace: partyB payment failed");

        // 退还多余
        if (msg.value > total) {
            (bool refund, ) = payable(msg.sender).call{value: msg.value - total}("");
            require(refund, "Marketplace: refund failed");
        }

        t.status = OTCStatus.Settled;
        t.settledAt = block.timestamp;
        totalVolume += total;
        emit OTCSettled(tradeId, t.amount, t.price);
    }

    /**
     * @dev 取消 OTC 交易
     */
    function cancelOTC(uint256 tradeId) public {
        require(tradeId < otcTradeCount, "Marketplace: not found");
        OTCTrade storage t = otcTrades[tradeId];
        require(t.status == OTCStatus.Pending || t.status == OTCStatus.Accepted, "Marketplace: not cancellable");
        require(msg.sender == t.partyA || msg.sender == t.partyB, "Marketplace: not party");

        t.status = OTCStatus.Cancelled;
        emit OTCCancelled(tradeId);
    }

    function getOTCTrade(uint256 tradeId) public view returns (OTCTrade memory) {
        require(tradeId < otcTradeCount, "Marketplace: not found");
        return otcTrades[tradeId];
    }
}
