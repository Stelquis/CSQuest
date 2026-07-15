// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title Compliance - 合规引擎
 * @notice 管理 KYC/AML 验证、投资者认证、转让限制
 */
contract Compliance {
    // =====================================================
    // 数据结构
    // =====================================================

    /**
     * @dev 投资者信息结构体
     */
    struct Investor {
        address wallet;
        string name;
        string kycId;          // KYC 认证编号
        uint256 verifiedAt;    // 认证时间
        uint256 expiresAt;     // 过期时间
        bool isAccredited;     // 是否合格投资者
        bool isBlacklisted;    // 是否黑名单
        uint256 maxInvestment; // 最大投资额限制
    }

    /**
     * @dev 转让限制结构体
     */
    struct TransferRestriction {
        uint256 minHoldingPeriod;  // 最短持有期（秒）
        uint256 maxTransferAmount; // 单次最大转让额
        bool lockupActive;         // 锁定期是否激活
        uint256 lockupEnd;         // 锁定结束时间
    }

    // =====================================================
    // 状态变量
    // =====================================================

    /// @notice 合约管理员
    address public admin;

    /// @notice 投资者信息映射
    mapping(address => Investor) public investors;

    /// @notice 转让限制映射
    mapping(address => TransferRestriction) public transferRestrictions;

    /// @notice 已验证投资者列表
    address[] public verifiedInvestors;

    /// @notice 黑名单列表
    address[] public blacklistedAddresses;

    /// @notice 合约关联的 RWA 代币地址
    address public rwaToken;

    // =====================================================
    // 事件
    // =====================================================

    event InvestorVerified(address indexed investor, string kycId, bool isAccredited);
    event InvestorRevoked(address indexed investor, string reason);
    event BlacklistUpdated(address indexed account, bool status);
    event TransferRestrictionUpdated(address indexed investor, uint256 minHoldingPeriod, uint256 maxTransferAmount);
    event LockupSet(address indexed investor, uint256 lockupEnd);

    // =====================================================
    // 修饰器
    // =====================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "Compliance: caller is not admin");
        _;
    }

    modifier onlyVerified(address investor) {
        require(
            investors[investor].verifiedAt > 0 &&
            !investors[investor].isBlacklisted &&
            (investors[investor].expiresAt == 0 || block.timestamp < investors[investor].expiresAt),
            "Compliance: investor not verified or expired"
        );
        _;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    constructor() {
        admin = msg.sender;
    }

    // =====================================================
    // KYC/AML 验证功能
    // =====================================================

    /**
     * @dev 验证投资者（KYC）
     * @param investor 投资者地址
     * @param investorName 投资者姓名
     * @param kycId KYC 认证编号
     * @param _isAccredited 是否合格投资者
     * @param maxInvestment 最大投资额
     * @param validityPeriod 有效期限（秒，0表示永不过期）
     */
    function verifyInvestor(
        address investor,
        string memory investorName,
        string memory kycId,
        bool _isAccredited,
        uint256 maxInvestment,
        uint256 validityPeriod
    ) public onlyAdmin {
        require(investor != address(0), "Compliance: zero address");
        require(!investors[investor].isBlacklisted, "Compliance: investor is blacklisted");

        investors[investor] = Investor({
            wallet: investor,
            name: investorName,
            kycId: kycId,
            verifiedAt: block.timestamp,
            expiresAt: validityPeriod > 0 ? block.timestamp + validityPeriod : 0,
            isAccredited: _isAccredited,
            isBlacklisted: false,
            maxInvestment: maxInvestment
        });

        verifiedInvestors.push(investor);

        emit InvestorVerified(investor, kycId, _isAccredited);
    }

    /**
     * @dev 撤销投资者认证
     * @param investor 投资者地址
     * @param reason 撤销原因
     */
    function revokeInvestor(address investor, string memory reason) public onlyAdmin {
        require(investors[investor].verifiedAt > 0, "Compliance: investor not found");

        investors[investor].verifiedAt = 0;
        investors[investor].expiresAt = 1; // 设置为已过期

        emit InvestorRevoked(investor, reason);
    }

    // =====================================================
    // 黑名单管理
    // =====================================================

    /**
     * @dev 更新黑名单状态
     * @param account 账户地址
     * @param status 是否加入黑名单
     */
    function updateBlacklist(address account, bool status) public onlyAdmin {
        investors[account].isBlacklisted = status;

        if (status) {
            blacklistedAddresses.push(account);
        }

        emit BlacklistUpdated(account, status);
    }

    /**
     * @dev 批量更新黑名单
     */
    function batchUpdateBlacklist(address[] memory accounts, bool[] memory statuses) public onlyAdmin {
        require(accounts.length == statuses.length, "Compliance: array length mismatch");

        for (uint256 i = 0; i < accounts.length; i++) {
            investors[accounts[i]].isBlacklisted = statuses[i];
            if (statuses[i]) {
                blacklistedAddresses.push(accounts[i]);
            }
            emit BlacklistUpdated(accounts[i], statuses[i]);
        }
    }

    // =====================================================
    // 转让限制管理
    // =====================================================

    /**
     * @dev 设置转让限制
     * @param investor 投资者地址
     * @param minHoldingPeriod 最短持有期
     * @param maxTransferAmount 单次最大转让额
     */
    function setTransferRestriction(
        address investor,
        uint256 minHoldingPeriod,
        uint256 maxTransferAmount
    ) public onlyAdmin {
        transferRestrictions[investor] = TransferRestriction({
            minHoldingPeriod: minHoldingPeriod,
            maxTransferAmount: maxTransferAmount,
            lockupActive: false,
            lockupEnd: 0
        });

        emit TransferRestrictionUpdated(investor, minHoldingPeriod, maxTransferAmount);
    }

    /**
     * @dev 设置锁定期
     * @param investor 投资者地址
     * @param lockupDuration 锁定时长（秒）
     */
    function setLockup(address investor, uint256 lockupDuration) public onlyAdmin {
        transferRestrictions[investor].lockupActive = true;
        transferRestrictions[investor].lockupEnd = block.timestamp + lockupDuration;

        emit LockupSet(investor, block.timestamp + lockupDuration);
    }

    // =====================================================
    // 合规检查函数
    // =====================================================

    /**
     * @dev 检查转账是否合规
     * @param from 发送方
     * @param to 接收方
     * @param amount 转账金额
     * @return 是否合规
     * @return 不合规原因
     */
    function checkTransfer(
        address from,
        address to,
        uint256 amount
    ) public view returns (bool, string memory) {
        // 检查发送方
        if (investors[from].isBlacklisted) {
            return (false, "Sender is blacklisted");
        }
        if (investors[from].verifiedAt == 0) {
            return (false, "Sender not verified");
        }
        if (investors[from].expiresAt > 0 && block.timestamp >= investors[from].expiresAt) {
            return (false, "Sender verification expired");
        }

        // 检查接收方
        if (investors[to].isBlacklisted) {
            return (false, "Recipient is blacklisted");
        }
        if (investors[to].verifiedAt == 0) {
            return (false, "Recipient not verified");
        }

        // 检查最短持有期
        if (transferRestrictions[from].minHoldingPeriod > 0) {
            uint256 holdingTime = block.timestamp - investors[from].verifiedAt;
            if (holdingTime < transferRestrictions[from].minHoldingPeriod) {
                return (false, "Min holding period not met");
            }
        }

        // 检查锁定期
        if (transferRestrictions[from].lockupActive && block.timestamp < transferRestrictions[from].lockupEnd) {
            return (false, "Transfer locked up");
        }

        // 检查最大转让额
        if (transferRestrictions[from].maxTransferAmount > 0 && amount > transferRestrictions[from].maxTransferAmount) {
            return (false, "Exceeds max transfer amount");
        }

        return (true, "");
    }

    /**
     * @dev 检查投资者是否已验证
     */
    function isVerified(address investor) public view returns (bool) {
        return investors[investor].verifiedAt > 0 &&
               !investors[investor].isBlacklisted &&
               (investors[investor].expiresAt == 0 || block.timestamp < investors[investor].expiresAt);
    }

    /**
     * @dev 检查是否为合格投资者
     */
    function isAccredited(address investor) public view returns (bool) {
        return investors[investor].isAccredited;
    }

    /**
     * @dev 获取已验证投资者数量
     */
    function getVerifiedInvestorCount() public view returns (uint256) {
        return verifiedInvestors.length;
    }

    /**
     * @dev 获取所有已验证投资者地址
     */
    function getVerifiedInvestors() public view returns (address[] memory) {
        return verifiedInvestors;
    }

    /**
     * @dev 获取所有黑名单地址
     */
    function getBlacklistedAddresses() public view returns (address[] memory) {
        return blacklistedAddresses;
    }

    /**
     * @dev 获取投资者详细信息
     */
    function getInvestorInfo(address investor) public view returns (
        address wallet,
        string memory investorName,
        string memory kycId,
        uint256 verifiedAt,
        uint256 expiresAt,
        bool accredited,
        bool blacklisted,
        uint256 maxInvestment
    ) {
        Investor memory inv = investors[investor];
        return (
            inv.wallet,
            inv.name,
            inv.kycId,
            inv.verifiedAt,
            inv.expiresAt,
            inv.isAccredited,
            inv.isBlacklisted,
            inv.maxInvestment
        );
    }

    /**
     * @dev 获取投资者转让限制信息
     */
    function getTransferRestriction(address investor) public view returns (
        uint256 minHoldingPeriod,
        uint256 maxTransferAmount,
        bool lockupActive,
        uint256 lockupEnd
    ) {
        TransferRestriction memory tr = transferRestrictions[investor];
        return (tr.minHoldingPeriod, tr.maxTransferAmount, tr.lockupActive, tr.lockupEnd);
    }

    /**
     * @dev 批量验证投资者
     * @param investors_ 投资者地址列表
     * @param names 投资者姓名列表
     * @param kycIds KYC编号列表
     * @param accreditedFlags 是否合格投资者列表
     * @param maxInvestments 最大投资额列表
     * @param validityPeriods 有效期列表
     */
    function batchVerifyInvestors(
        address[] memory investors_,
        string[] memory names,
        string[] memory kycIds,
        bool[] memory accreditedFlags,
        uint256[] memory maxInvestments,
        uint256[] memory validityPeriods
    ) public onlyAdmin {
        require(
            investors_.length == names.length &&
            investors_.length == kycIds.length &&
            investors_.length == accreditedFlags.length &&
            investors_.length == maxInvestments.length &&
            investors_.length == validityPeriods.length,
            "Compliance: array length mismatch"
        );

        for (uint256 i = 0; i < investors_.length; i++) {
            require(investors_[i] != address(0), "Compliance: zero address");
            require(!investors[investors_[i]].isBlacklisted, "Compliance: investor is blacklisted");

            investors[investors_[i]] = Investor({
                wallet: investors_[i],
                name: names[i],
                kycId: kycIds[i],
                verifiedAt: block.timestamp,
                expiresAt: validityPeriods[i] > 0 ? block.timestamp + validityPeriods[i] : 0,
                isAccredited: accreditedFlags[i],
                isBlacklisted: false,
                maxInvestment: maxInvestments[i]
            });

            verifiedInvestors.push(investors_[i]);
            emit InvestorVerified(investors_[i], kycIds[i], accreditedFlags[i]);
        }
    }

    /**
     * @dev 设置关联的 RWA 代币地址
     */
    function setRWAToken(address _rwaToken) public onlyAdmin {
        rwaToken = _rwaToken;
    }

    // =====================================================
    // 发行限制功能（对应设计要求 4.2.2 发行限制）
    // =====================================================

    /// @notice 发行限制配置
    IssuanceLimit public issuanceLimit;

    struct IssuanceLimit {
        uint256 maxSupply;          // 最大发行规模（0表示不限）
        uint256 maxInvestors;       // 最大投资者数量（0表示不限）
        uint256 minLockupPeriod;    // 最短锁定期（秒）
        uint256 maxInvestmentPerInvestor; // 单人最大投资额（0表示不限）
        bool enabled;               // 是否启用发行限制
    }

    event IssuanceLimitUpdated(uint256 maxSupply, uint256 maxInvestors, uint256 minLockupPeriod);

    /**
     * @dev 设置发行限制（规模、投资者数量、锁定期等，确保发行合规）
     */
    function setIssuanceLimit(
        uint256 _maxSupply,
        uint256 _maxInvestors,
        uint256 _minLockupPeriod,
        uint256 _maxInvestmentPerInvestor,
        bool _enabled
    ) public onlyAdmin {
        issuanceLimit = IssuanceLimit({
            maxSupply: _maxSupply,
            maxInvestors: _maxInvestors,
            minLockupPeriod: _minLockupPeriod,
            maxInvestmentPerInvestor: _maxInvestmentPerInvestor,
            enabled: _enabled
        });
        emit IssuanceLimitUpdated(_maxSupply, _maxInvestors, _minLockupPeriod);
    }

    /**
     * @dev 检查发行是否合规（代币发行前调用）
     * @param currentSupply 当前供应量
     * @param currentInvestorCount 当前投资者数
     * @param mintAmount 本次发行量
     */
    function checkIssuance(
        uint256 currentSupply,
        uint256 currentInvestorCount,
        uint256 mintAmount
    ) public view returns (bool, string memory) {
        if (!issuanceLimit.enabled) return (true, "");

        if (issuanceLimit.maxSupply > 0 && currentSupply + mintAmount > issuanceLimit.maxSupply) {
            return (false, "Exceeds max supply");
        }
        if (issuanceLimit.maxInvestors > 0 && currentInvestorCount > issuanceLimit.maxInvestors) {
            return (false, "Exceeds max investors");
        }
        return (true, "");
    }

    /**
     * @dev 检查单投资者投资额度限制
     */
    function checkInvestmentLimit(address investor, uint256 currentInvestment, uint256 newInvestment) public view returns (bool) {
        if (!issuanceLimit.enabled) return true;
        if (issuanceLimit.maxInvestmentPerInvestor == 0) return true;
        return currentInvestment + newInvestment <= investors[investor].maxInvestment;
    }

    // =====================================================
    // AML 反洗钱监测（对应设计要求 4.2.2 反洗钱）
    // =====================================================

    /// @notice AML 监测记录：投资者 -> 累计交易额
    mapping(address => uint256) public cumulativeTradeVolume;

    /// @notice AML 大额交易阈值（超过则标记审查）
    uint256 public amlThreshold;

    /// @notice AML 审查标记
    mapping(address => bool) public amlFlagged;

    /// @notice AML 风险等级 (0-3)
    mapping(address => uint8) public amlRiskLevel;

    event AMLThresholdUpdated(uint256 newThreshold);
    event AMLFlagged(address indexed account, uint8 riskLevel);
    event AMLCleared(address indexed account);

    /**
     * @dev 设置 AML 大额交易阈值
     */
    function setAMLThreshold(uint256 _threshold) public onlyAdmin {
        amlThreshold = _threshold;
        emit AMLThresholdUpdated(_threshold);
    }

    /**
     * @dev 记录交易并执行 AML 监测（交易时由代币合约调用）
     * @param account 交易账户
     * @param amount 交易金额
     */
    function recordTransaction(address account, uint256 amount) public onlyAdmin {
        cumulativeTradeVolume[account] += amount;

        // 超过阈值自动标记审查
        if (amlThreshold > 0 && cumulativeTradeVolume[account] > amlThreshold) {
            amlFlagged[account] = true;
            if (amlRiskLevel[account] < 1) {
                amlRiskLevel[account] = 1;
            }
            emit AMLFlagged(account, amlRiskLevel[account]);
        }
    }

    /**
     * @dev 标记账户 AML 风险等级
     * @param account 账户地址
     * @param riskLevel 风险等级 (0=正常,1=低,2=中,3=高)
     */
    function setAMLRiskLevel(address account, uint8 riskLevel) public onlyAdmin {
        require(riskLevel <= 3, "Compliance: invalid risk level");
        amlRiskLevel[account] = riskLevel;
        if (riskLevel >= 3) {
            amlFlagged[account] = true;
            // 高风险自动加入黑名单
            investors[account].isBlacklisted = true;
            blacklistedAddresses.push(account);
        }
        emit AMLFlagged(account, riskLevel);
    }

    /**
     * @dev 清除 AML 标记（审查通过后）
     */
    function clearAMLFlag(address account) public onlyAdmin {
        amlFlagged[account] = false;
        if (amlRiskLevel[account] > 0) {
            amlRiskLevel[account] = 0;
        }
        emit AMLCleared(account);
    }

    /**
     * @dev 获取 AML 监测信息
     */
    function getAMLInfo(address account) public view returns (
        uint256 volume,
        bool flagged,
        uint8 riskLevel
    ) {
        return (cumulativeTradeVolume[account], amlFlagged[account], amlRiskLevel[account]);
    }
}
