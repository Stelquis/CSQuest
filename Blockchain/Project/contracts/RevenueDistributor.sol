// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title RevenueDistributor - 收益分配合约
 * @notice 自动化收益分配（租金、股息、利息等），支持按持仓比例分配
 * @dev 包含 ReentrancyGuard 防止重入攻击
 */
contract RevenueDistributor {
    // =====================================================
    // 数据结构
    // =====================================================

    /**
     * @dev 分配记录结构体
     */
    struct Distribution {
        uint256 distributionId;
        uint256 totalAmount;     // 分配总额
        uint256 timestamp;       // 分配时间
        uint256 snapshotBlock;   // 快照区块
        string revenueType;      // 收益类型（租金/股息/利息）
        bool finalized;          // 是否已完成分配
        uint256 claimedAmount;   // 已领取金额
        uint256 investorCount;   // 参与投资者数量
    }

    /**
     * @dev 投资者领取记录
     */
    struct ClaimRecord {
        uint256 amount;
        uint256 timestamp;
        bool claimed;
    }

    // =====================================================
    // 状态变量
    // =====================================================

    /// @notice 合约管理员
    address public admin;

    /// @notice 关联的 RWA 代币合约
    address public rwaToken;

    /// @notice 关联的合规合约
    address public complianceContract;

    /// @notice 分配记录映射
    mapping(uint256 => Distribution) public distributions;

    /// @notice 分配计数器
    uint256 public distributionCount;

    /// @notice 投资者领取记录：distributionId => investor => ClaimRecord
    mapping(uint256 => mapping(address => ClaimRecord)) public claimRecords;

    /// @notice 投资者待领取总额
    mapping(address => uint256) public pendingClaims;

    /// @notice 投资者已领取总额
    mapping(address => uint256) public totalClaimed;

    /// @notice 收益类型列表
    string[] public revenueTypes;

    /// @notice 重入锁
    uint256 private _reentrancyStatus;

    /// @notice 累计分配总额
    uint256 public totalDistributed;

    /// @notice 累计领取总额
    uint256 public totalClaimedAmount;

    // =====================================================
    // 事件
    // =====================================================

    event DistributionCreated(
        uint256 indexed distributionId,
        uint256 totalAmount,
        string revenueType,
        uint256 snapshotBlock,
        uint256 investorCount
    );

    event RevenueDeposited(address indexed depositor, uint256 amount, string revenueType);

    event Claimed(
        uint256 indexed distributionId,
        address indexed investor,
        uint256 amount
    );

    event BatchClaimed(address indexed investor, uint256 count, uint256 totalAmount);

    event DistributionFinalized(uint256 indexed distributionId);

    event ComplianceContractUpdated(address indexed oldContract, address indexed newContract);

    // =====================================================
    // 修饰器
    // =====================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "RevenueDistributor: caller is not admin");
        _;
    }

    modifier distributionExists(uint256 distributionId) {
        require(distributionId < distributionCount, "RevenueDistributor: distribution not found");
        _;
    }

    /**
     * @dev 重入保护修饰器
     */
    modifier nonReentrant() {
        require(_reentrancyStatus != 1, "RevenueDistributor: reentrant call");
        _reentrancyStatus = 1;
        _;
        _reentrancyStatus = 0;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    constructor(address _rwaToken) {
        admin = msg.sender;
        rwaToken = _rwaToken;
    }

    // =====================================================
    // 收益存入功能
    // =====================================================

    /**
     * @dev 存入收益（仅管理员）
     * @param revenueType 收益类型（如：rent, dividend, interest）
     */
    function depositRevenue(string memory revenueType) public payable onlyAdmin {
        require(msg.value > 0, "RevenueDistributor: zero amount");

        // 记录收益类型（如果不存在）
        bool typeExists = false;
        for (uint256 i = 0; i < revenueTypes.length; i++) {
            if (keccak256(bytes(revenueTypes[i])) == keccak256(bytes(revenueType))) {
                typeExists = true;
                break;
            }
        }
        if (!typeExists) {
            revenueTypes.push(revenueType);
        }

        emit RevenueDeposited(msg.sender, msg.value, revenueType);
    }

    // =====================================================
    // 分配功能
    // =====================================================

    /**
     * @dev 手动指定投资者创建收益分配
     * @param totalAmount 分配总额
     * @param revenueType 收益类型
     * @param investors 投资者地址列表
     * @param amounts 每个投资者的分配金额
     */
    function createDistribution(
        uint256 totalAmount,
        string memory revenueType,
        address[] memory investors,
        uint256[] memory amounts
    ) public onlyAdmin {
        require(totalAmount > 0, "RevenueDistributor: zero amount");
        require(investors.length == amounts.length, "RevenueDistributor: array length mismatch");
        require(investors.length > 0, "RevenueDistributor: empty investors");
        require(address(this).balance >= totalAmount, "RevenueDistributor: insufficient balance");

        // 验证分配总额
        uint256 sum = 0;
        for (uint256 i = 0; i < amounts.length; i++) {
            sum += amounts[i];
            require(amounts[i] > 0, "RevenueDistributor: zero investor amount");
        }
        require(sum == totalAmount, "RevenueDistributor: amounts mismatch");

        uint256 distributionId = distributionCount;

        distributions[distributionId] = Distribution({
            distributionId: distributionId,
            totalAmount: totalAmount,
            timestamp: block.timestamp,
            snapshotBlock: block.number,
            revenueType: revenueType,
            finalized: false,
            claimedAmount: 0,
            investorCount: investors.length
        });

        // 设置每个投资者的分配金额
        for (uint256 i = 0; i < investors.length; i++) {
            claimRecords[distributionId][investors[i]] = ClaimRecord({
                amount: amounts[i],
                timestamp: 0,
                claimed: false
            });
            pendingClaims[investors[i]] += amounts[i];
        }

        distributionCount++;
        totalDistributed += totalAmount;

        emit DistributionCreated(distributionId, totalAmount, revenueType, block.number, investors.length);
    }

    /**
     * @dev 按持仓比例自动分配收益
     * @param revenueType 收益类型
     * @param holders 持仓者地址列表
     * @param balances 持仓者对应的代币余额
     */
    function distributeByHolding(
        string memory revenueType,
        address[] memory holders,
        uint256[] memory balances
    ) public payable onlyAdmin {
        require(msg.value > 0, "RevenueDistributor: zero amount");
        require(holders.length == balances.length, "RevenueDistributor: array length mismatch");
        require(holders.length > 0, "RevenueDistributor: empty holders");

        // 计算总持仓量
        uint256 totalStake = 0;
        for (uint256 i = 0; i < balances.length; i++) {
            totalStake += balances[i];
        }
        require(totalStake > 0, "RevenueDistributor: zero total stake");

        uint256 distributionId = distributionCount;
        uint256 distributedAmount = 0;

        distributions[distributionId] = Distribution({
            distributionId: distributionId,
            totalAmount: msg.value,
            timestamp: block.timestamp,
            snapshotBlock: block.number,
            revenueType: revenueType,
            finalized: false,
            claimedAmount: 0,
            investorCount: holders.length
        });

        // 按持仓比例分配
        for (uint256 i = 0; i < holders.length; i++) {
            uint256 share = (msg.value * balances[i]) / totalStake;
            if (share > 0) {
                claimRecords[distributionId][holders[i]] = ClaimRecord({
                    amount: share,
                    timestamp: 0,
                    claimed: false
                });
                pendingClaims[holders[i]] += share;
                distributedAmount += share;
            }
        }

        distributionCount++;
        totalDistributed += distributedAmount;

        emit DistributionCreated(distributionId, msg.value, revenueType, block.number, holders.length);
    }

    // =====================================================
    // 领取功能
    // =====================================================

    /**
     * @dev 领取单个分配的收益
     * @param distributionId 分配ID
     */
    function claim(uint256 distributionId) public distributionExists(distributionId) nonReentrant {
        ClaimRecord storage record = claimRecords[distributionId][msg.sender];

        require(record.amount > 0, "RevenueDistributor: no allocation");
        require(!record.claimed, "RevenueDistributor: already claimed");

        record.claimed = true;
        record.timestamp = block.timestamp;

        uint256 amount = record.amount;

        distributions[distributionId].claimedAmount += amount;
        pendingClaims[msg.sender] -= amount;
        totalClaimed[msg.sender] += amount;
        totalClaimedAmount += amount;

        // 转账
        (bool success, ) = payable(msg.sender).call{value: amount}("");
        require(success, "RevenueDistributor: transfer failed");

        emit Claimed(distributionId, msg.sender, amount);
    }

    /**
     * @dev 批量领取多个分配
     * @param distributionIds 分配ID列表
     */
    function batchClaim(uint256[] memory distributionIds) public nonReentrant {
        uint256 claimedCount = 0;
        uint256 totalAmount = 0;

        for (uint256 i = 0; i < distributionIds.length; i++) {
            uint256 distId = distributionIds[i];
            if (distId < distributionCount) {
                ClaimRecord storage record = claimRecords[distId][msg.sender];
                if (record.amount > 0 && !record.claimed) {
                    record.claimed = true;
                    record.timestamp = block.timestamp;

                    uint256 amount = record.amount;
                    distributions[distId].claimedAmount += amount;
                    pendingClaims[msg.sender] -= amount;
                    totalClaimed[msg.sender] += amount;
                    totalClaimedAmount += amount;
                    totalAmount += amount;
                    claimedCount++;

                    emit Claimed(distId, msg.sender, amount);
                }
            }
        }

        require(claimedCount > 0, "RevenueDistributor: nothing to claim");

        // 一次性转账
        (bool success, ) = payable(msg.sender).call{value: totalAmount}("");
        require(success, "RevenueDistributor: batch transfer failed");

        emit BatchClaimed(msg.sender, claimedCount, totalAmount);
    }

    // =====================================================
    // 查询功能
    // =====================================================

    /**
     * @dev 获取分配详情
     */
    function getDistribution(uint256 distributionId) public view returns (Distribution memory) {
        return distributions[distributionId];
    }

    /**
     * @dev 获取投资者的领取记录
     */
    function getClaimRecord(uint256 distributionId, address investor) public view returns (ClaimRecord memory) {
        return claimRecords[distributionId][investor];
    }

    /**
     * @dev 获取投资者待领取总额
     */
    function getPendingClaims(address investor) public view returns (uint256) {
        return pendingClaims[investor];
    }

    /**
     * @dev 获取投资者已领取总额
     */
    function getTotalClaimed(address investor) public view returns (uint256) {
        return totalClaimed[investor];
    }

    /**
     * @dev 获取分配数量
     */
    function getDistributionCount() public view returns (uint256) {
        return distributionCount;
    }

    /**
     * @dev 获取投资者可领取的所有分配ID
     * @param investor 投资者地址
     * @return claimableIds 可领取的分配ID数组
     */
    function getClaimableDistributions(address investor) public view returns (uint256[] memory) {
        uint256 claimableCount = 0;
        for (uint256 i = 0; i < distributionCount; i++) {
            ClaimRecord memory record = claimRecords[i][investor];
            if (record.amount > 0 && !record.claimed) {
                claimableCount++;
            }
        }

        uint256[] memory claimableIds = new uint256[](claimableCount);
        uint256 idx = 0;
        for (uint256 i = 0; i < distributionCount; i++) {
            ClaimRecord memory record = claimRecords[i][investor];
            if (record.amount > 0 && !record.claimed) {
                claimableIds[idx] = i;
                idx++;
            }
        }
        return claimableIds;
    }

    /**
     * @dev 获取所有收益类型
     */
    function getRevenueTypes() public view returns (string[] memory) {
        return revenueTypes;
    }

    /**
     * @dev 获取系统统计信息
     */
    function getSystemStats() public view returns (
        uint256 _distributionCount,
        uint256 _totalDistributed,
        uint256 _totalClaimedAmount,
        uint256 _contractBalance
    ) {
        return (distributionCount, totalDistributed, totalClaimedAmount, address(this).balance);
    }

    // =====================================================
    // 管理功能
    // =====================================================

    /**
     * @dev 完成分配
     */
    function finalizeDistribution(uint256 distributionId) public onlyAdmin distributionExists(distributionId) {
        distributions[distributionId].finalized = true;
        emit DistributionFinalized(distributionId);
    }

    /**
     * @dev 更新 RWA 代币地址
     */
    function setRWAToken(address _rwaToken) public onlyAdmin {
        rwaToken = _rwaToken;
    }

    /**
     * @dev 更新合规合约地址
     */
    function setComplianceContract(address _complianceContract) public onlyAdmin {
        address oldContract = complianceContract;
        complianceContract = _complianceContract;
        emit ComplianceContractUpdated(oldContract, _complianceContract);
    }

    /**
     * @dev 提取未分配余额（仅管理员）
     */
    function withdrawUnallocated() public onlyAdmin nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "RevenueDistributor: no balance");

        (bool success, ) = payable(admin).call{value: balance}("");
        require(success, "RevenueDistributor: withdraw failed");
    }

    // =====================================================
    // 自动再投资功能（对应设计要求 4.3.3 自动再投资）
    // =====================================================

    /// @notice 投资者是否开启自动再投资
    mapping(address => bool) public autoReinvestEnabled;

    /// @notice 自动再投资累计金额
    mapping(address => uint256) public reinvestedTotal;

    /// @notice 收益类型计数：投资者 -> 收益类型 -> 累计
    mapping(address => mapping(string => uint256)) public revenueByType;

    /// @notice RWA 代币合约接口（用于再投资购买代币）
    address public rwaTokenForReinvest;

    event AutoReinvestToggled(address indexed investor, bool enabled);
    event RevenueReinvested(address indexed investor, uint256 amount);
    event RevenueTypeRecorded(address indexed investor, string revenueType, uint256 amount);

    /**
     * @dev 设置再投资代币地址
     */
    function setReinvestToken(address _token) public onlyAdmin {
        require(_token != address(0), "RevenueDistributor: zero address");
        rwaTokenForReinvest = _token;
    }

    /**
     * @dev 投资者开启/关闭自动再投资（收益自动购买更多资产代币，实现复利）
     */
    function toggleAutoReinvest(bool enabled) public {
        autoReinvestEnabled[msg.sender] = enabled;
        emit AutoReinvestToggled(msg.sender, enabled);
    }

    /**
     * @dev 带再投资选项的领取收益
     *      若开启自动再投资，领取的收益将用于从管理员购买代币实现复利
     * @param distributionId 分配ID
     */
    function claimWithReinvest(uint256 distributionId) public distributionExists(distributionId) nonReentrant {
        ClaimRecord storage record = claimRecords[distributionId][msg.sender];
        require(record.amount > 0, "RevenueDistributor: no allocation");
        require(!record.claimed, "RevenueDistributor: already claimed");

        record.claimed = true;
        record.timestamp = block.timestamp;

        uint256 amount = record.amount;
        distributions[distributionId].claimedAmount += amount;
        pendingClaims[msg.sender] -= amount;
        totalClaimed[msg.sender] += amount;
        totalClaimedAmount += amount;

        // 记录收益类型
        string memory revType = distributions[distributionId].revenueType;
        revenueByType[msg.sender][revType] += amount;

        if (autoReinvestEnabled[msg.sender] && rwaTokenForReinvest != address(0)) {
            // 自动再投资：用收益从管理员处购买代币
            _executeReinvest(msg.sender, amount);
            reinvestedTotal[msg.sender] += amount;
            emit RevenueReinvested(msg.sender, amount);
        } else {
            // 直接转账
            (bool success, ) = payable(msg.sender).call{value: amount}("");
            require(success, "RevenueDistributor: transfer failed");
        }

        emit Claimed(distributionId, msg.sender, amount);
    }

    /**
     * @dev 内部：执行再投资（从管理员购买代币转给投资者）
     *      管理员需先 approve 代币给本合约
     */
    function _executeReinvest(address investor, uint256 amount) internal {
        // 计算可购买代币数量（基于代币单价）
        (bool ok, bytes memory data) = rwaTokenForReinvest.staticcall(
            abi.encodeWithSignature("getTokenPrice()")
        );
        require(ok, "RevenueDistributor: price call failed");
        uint256 tokenPrice = abi.decode(data, (uint256));
        require(tokenPrice > 0, "RevenueDistributor: zero price");

        uint256 tokenAmount = amount / tokenPrice;
        require(tokenAmount > 0, "RevenueDistributor: too small to reinvest");

        // 获取管理员地址
        (bool ok2, bytes memory data2) = rwaTokenForReinvest.staticcall(
            abi.encodeWithSignature("admin()")
        );
        require(ok2, "RevenueDistributor: admin call failed");
        address tokenAdmin = abi.decode(data2, (address));

        // 从管理员转代币给投资者
        (bool tokOk, bytes memory tokData) = rwaTokenForReinvest.call(
            abi.encodeWithSignature("transferFrom(address,address,uint256)", tokenAdmin, investor, tokenAmount)
        );
        require(tokOk && (tokData.length == 0 || abi.decode(tokData, (bool))), "RevenueDistributor: reinvest transfer failed");

        // 支付ETH给管理员
        (bool payOk, ) = payable(tokenAdmin).call{value: amount}("");
        require(payOk, "RevenueDistributor: admin payment failed");
    }

    /**
     * @dev 查询投资者各类收益累计
     */
    function getRevenueByType(address investor, string memory revenueType) public view returns (uint256) {
        return revenueByType[investor][revenueType];
    }

    /**
     * @dev 查询再投资统计
     */
    function getReinvestStats(address investor) public view returns (
        bool enabled,
        uint256 reinvested,
        uint256 totalClaimed_
    ) {
        return (autoReinvestEnabled[investor], reinvestedTotal[investor], totalClaimed[investor]);
    }
}
