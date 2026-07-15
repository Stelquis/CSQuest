// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title DutchAuction - 荷兰式拍卖
 * @notice 对应设计要求 4.2.3：针对大宗资产代币的降价拍卖方式，
 *         通过逐步降价确定交易价格，提高大宗资产交易效率
 */
contract DutchAuction {
    // =====================================================
    // 数据结构
    // =====================================================

    /// @dev 拍卖状态
    enum AuctionStatus { Active, Settled, Cancelled }

    /// @dev 拍卖记录
    struct Auction {
        uint256 auctionId;
        address seller;           // 卖方
        address tokenAddress;     // 代币地址
        uint256 tokenAmount;      // 拍卖代币数量
        uint256 startPrice;       // 起始价格（最高价）
        uint256 reservePrice;     // 保留价（最低价）
        uint256 priceDecrement;   // 每次降价幅度
        uint256 decrementInterval;// 降价间隔（秒）
        uint256 startAt;          // 开始时间
        uint256 endAt;            // 结束时间
        uint256 currentPrice;     // 当前价格
        address winner;           // 中标者
        uint256 settledAt;        // 成交时间
        AuctionStatus status;     // 拍卖状态
    }

    // =====================================================
    // 状态变量
    // =====================================================

    address public admin;

    mapping(uint256 => Auction) public auctions;
    uint256 public auctionCount;

    /// @notice 累计成交额
    uint256 public totalVolume;

    /// @notice 累计成交拍卖数
    uint256 public settledCount;

    /// @notice 重入锁
    uint256 private _reentrancyStatus;

    // =====================================================
    // 事件
    // =====================================================

    event AuctionCreated(uint256 indexed auctionId, address indexed seller, address token, uint256 amount, uint256 startPrice, uint256 reservePrice);
    event PriceUpdated(uint256 indexed auctionId, uint256 newPrice);
    event AuctionBid(uint256 indexed auctionId, address indexed winner, uint256 price, uint256 amount);
    event AuctionCancelled(uint256 indexed auctionId);
    event AuctionSettled(uint256 indexed auctionId, address winner, uint256 price);

    // =====================================================
    // 修饰器
    // =====================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "DutchAuction: not admin");
        _;
    }

    modifier nonReentrant() {
        require(_reentrancyStatus != 1, "DutchAuction: reentrant");
        _reentrancyStatus = 1;
        _;
        _reentrancyStatus = 0;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    constructor() {
        admin = msg.sender;
    }

    // =====================================================
    // 拍卖功能
    // =====================================================

    /**
     * @dev 创建荷兰式拍卖（卖方需先 approve 代币给本合约）
     * @param tokenAddress 代币地址
     * @param tokenAmount 拍卖数量
     * @param startPrice 起始价格（最高，wei）
     * @param reservePrice 保留价格（最低，wei）
     * @param priceDecrement 每次降价幅度（wei）
     * @param decrementInterval 降价间隔（秒）
     * @param duration 拍卖持续时间（秒）
     */
    function createAuction(
        address tokenAddress,
        uint256 tokenAmount,
        uint256 startPrice,
        uint256 reservePrice,
        uint256 priceDecrement,
        uint256 decrementInterval,
        uint256 duration
    ) public returns (uint256) {
        require(tokenAddress != address(0), "DutchAuction: zero token");
        require(tokenAmount > 0, "DutchAuction: zero amount");
        require(startPrice > reservePrice, "DutchAuction: start <= reserve");
        require(priceDecrement > 0, "DutchAuction: zero decrement");
        require(decrementInterval > 0, "DutchAuction: zero interval");
        require(duration > 0, "DutchAuction: zero duration");

        // 验证代币授权
        (bool ok, bytes memory data) = tokenAddress.staticcall(
            abi.encodeWithSignature("allowance(address,address)", msg.sender, address(this))
        );
        require(ok, "DutchAuction: allowance check failed");
        uint256 allowance = abi.decode(data, (uint256));
        require(allowance >= tokenAmount, "DutchAuction: insufficient allowance");

        uint256 auctionId = auctionCount;

        auctions[auctionId] = Auction({
            auctionId: auctionId,
            seller: msg.sender,
            tokenAddress: tokenAddress,
            tokenAmount: tokenAmount,
            startPrice: startPrice,
            reservePrice: reservePrice,
            priceDecrement: priceDecrement,
            decrementInterval: decrementInterval,
            startAt: block.timestamp,
            endAt: block.timestamp + duration,
            currentPrice: startPrice,
            winner: address(0),
            settledAt: 0,
            status: AuctionStatus.Active
        });

        auctionCount++;
        emit AuctionCreated(auctionId, msg.sender, tokenAddress, tokenAmount, startPrice, reservePrice);
        return auctionId;
    }

    /**
     * @dev 获取当前拍卖价格（降价拍卖：价格随时间递减）
     * @param auctionId 拍卖ID
     */
    function getCurrentPrice(uint256 auctionId) public view returns (uint256) {
        require(auctionId < auctionCount, "DutchAuction: not found");
        Auction memory a = auctions[auctionId];

        if (a.status != AuctionStatus.Active) {
            return a.currentPrice;
        }

        // 计算已过去的降价次数
        uint256 elapsed = block.timestamp - a.startAt;
        uint256 decrements = elapsed / a.decrementInterval;

        uint256 price = a.startPrice;
        for (uint256 i = 0; i < decrements; i++) {
            if (price <= a.reservePrice) {
                price = a.reservePrice;
                break;
            }
            if (price > a.priceDecrement) {
                price -= a.priceDecrement;
            } else {
                price = a.reservePrice;
            }
            if (price < a.reservePrice) {
                price = a.reservePrice;
            }
        }
        return price;
    }

    /**
     * @dev 竞价（荷兰式拍卖：第一个出价者以当前价格中标，拍卖立即结束）
     * @param auctionId 拍卖ID
     */
    function bid(uint256 auctionId) public payable nonReentrant {
        require(auctionId < auctionCount, "DutchAuction: not found");
        Auction storage a = auctions[auctionId];
        require(a.status == AuctionStatus.Active, "DutchAuction: not active");
        require(block.timestamp <= a.endAt, "DutchAuction: ended");
        require(a.winner == address(0), "DutchAuction: already won");

        uint256 currentPrice = getCurrentPrice(auctionId);
        require(msg.value >= currentPrice, "DutchAuction: insufficient payment");

        a.winner = msg.sender;
        a.currentPrice = currentPrice;
        a.settledAt = block.timestamp;
        a.status = AuctionStatus.Settled;

        // 转代币给中标者
        (bool tokOk, bytes memory tokData) = a.tokenAddress.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", a.seller, msg.sender, a.tokenAmount)
        );
        require(tokOk && (tokData.length == 0 || abi.decode(tokData, (bool))), "DutchAuction: transfer failed");

        // 转ETH给卖方
        (bool payOk, ) = payable(a.seller).call{value: currentPrice}("");
        require(payOk, "DutchAuction: payment failed");

        // 退还多余支付
        if (msg.value > currentPrice) {
            (bool refundOk, ) = payable(msg.sender).call{value: msg.value - currentPrice}("");
            require(refundOk, "DutchAuction: refund failed");
        }

        totalVolume += currentPrice;
        settledCount++;

        emit AuctionBid(auctionId, msg.sender, currentPrice, a.tokenAmount);
        emit AuctionSettled(auctionId, msg.sender, currentPrice);
    }

    /**
     * @dev 取消拍卖（仅卖方或管理员，且未成交）
     */
    function cancelAuction(uint256 auctionId) public {
        require(auctionId < auctionCount, "DutchAuction: not found");
        Auction storage a = auctions[auctionId];
        require(a.status == AuctionStatus.Active, "DutchAuction: not active");
        require(msg.sender == a.seller || msg.sender == admin, "DutchAuction: not authorized");

        a.status = AuctionStatus.Cancelled;
        emit AuctionCancelled(auctionId);
    }

    // =====================================================
    // 查询功能
    // =====================================================

    function getAuction(uint256 auctionId) public view returns (Auction memory) {
        require(auctionId < auctionCount, "DutchAuction: not found");
        return auctions[auctionId];
    }

    function getAuctionStats() public view returns (uint256 _count, uint256 _settled, uint256 _volume) {
        return (auctionCount, settledCount, totalVolume);
    }

    /**
     * @dev 提取合约余额（仅管理员）
     */
    function withdraw() public onlyAdmin nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "DutchAuction: no balance");
        (bool ok, ) = payable(admin).call{value: balance}("");
        require(ok, "DutchAuction: withdraw failed");
    }
}
