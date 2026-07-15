// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title Insurance - 保险集成
 * @notice 对应设计要求 4.4 保险集成：与传统保险机构和去中心化保险协议对接，
 *         为资产代币提供保险保障，降低投资者风险
 */
contract Insurance {
    // =====================================================
    // 数据结构
    // =====================================================

    /// @dev 保险状态
    enum PolicyStatus { Active, Claimed, Expired, Cancelled }

    /// @dev 保险单
    struct Policy {
        uint256 policyId;
        uint256 assetId;          // 关联资产ID
        address insured;          // 投保人
        address insurer;          // 保险方（承保机构/去中心化协议）
        uint256 coverageAmount;   // 保额
        uint256 premium;          // 保费
        uint256 startAt;          // 生效时间
        uint256 endAt;            // 到期时间
        PolicyStatus status;      // 保单状态
        string termsHash;         // 保险条款哈希
    }

    /// @dev 理赔记录
    struct Claim {
        uint256 claimId;
        uint256 policyId;
        address claimant;         // 理赔申请人
        uint256 claimAmount;      // 理赔金额
        string reasonHash;        // 理赔原因哈希
        uint256 filedAt;          // 申请时间
        uint256 processedAt;      // 处理时间
        ClaimStatus status;       // 理赔状态
    }

    enum ClaimStatus { Pending, Approved, Rejected, Paid }

    // =====================================================
    // 状态变量
    // =====================================================

    address public admin;

    mapping(uint256 => Policy) public policies;
    uint256 public policyCount;

    mapping(uint256 => Claim) public claims;
    uint256 public claimCount;

    /// @notice 投保人 -> 保单列表
    mapping(address => uint256[]) public insuredPolicies;

    /// @notice 保单 -> 理赔列表
    mapping(uint256 => uint256[]) public policyClaims;

    /// @notice 总保额
    uint256 public totalCoverage;

    /// @notice 总保费收入
    uint256 public totalPremium;

    /// @notice 已赔付总额
    uint256 public totalClaimPaid;

    /// @notice 重入锁
    uint256 private _reentrancyStatus;

    // =====================================================
    // 事件
    // =====================================================

    event PolicyIssued(uint256 indexed policyId, uint256 indexed assetId, address indexed insured, uint256 coverage, uint256 premium);
    event PolicyCancelled(uint256 indexed policyId);
    event PolicyExpired(uint256 indexed policyId);
    event ClaimFiled(uint256 indexed claimId, uint256 indexed policyId, uint256 amount);
    event ClaimApproved(uint256 indexed claimId, uint256 amount);
    event ClaimRejected(uint256 indexed claimId);
    event ClaimPaid(uint256 indexed claimId, address indexed claimant, uint256 amount);

    // =====================================================
    // 修饰器
    // =====================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "Insurance: not admin");
        _;
    }

    modifier nonReentrant() {
        require(_reentrancyStatus != 1, "Insurance: reentrant");
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
    // 保单管理功能
    // =====================================================

    /**
     * @dev 发行保单（保险方承保）
     * @param assetId 关联资产ID
     * @param insured 投保人地址
     * @param coverageAmount 保额
     * @param premium 保费
     * @param duration 保险期限（秒）
     * @param termsHash 保险条款哈希
     */
    function issuePolicy(
        uint256 assetId,
        address insured,
        uint256 coverageAmount,
        uint256 premium,
        uint256 duration,
        string memory termsHash
    ) public onlyAdmin returns (uint256) {
        require(insured != address(0), "Insurance: zero insured");
        require(coverageAmount > 0, "Insurance: zero coverage");
        require(duration > 0, "Insurance: zero duration");

        uint256 policyId = policyCount;

        policies[policyId] = Policy({
            policyId: policyId,
            assetId: assetId,
            insured: insured,
            insurer: msg.sender,
            coverageAmount: coverageAmount,
            premium: premium,
            startAt: block.timestamp,
            endAt: block.timestamp + duration,
            status: PolicyStatus.Active,
            termsHash: termsHash
        });

        insuredPolicies[insured].push(policyId);
        totalCoverage += coverageAmount;
        totalPremium += premium;
        policyCount++;

        emit PolicyIssued(policyId, assetId, insured, coverageAmount, premium);
        return policyId;
    }

    /**
     * @dev 取消保单
     */
    function cancelPolicy(uint256 policyId) public onlyAdmin {
        require(policyId < policyCount, "Insurance: not found");
        Policy storage p = policies[policyId];
        require(p.status == PolicyStatus.Active, "Insurance: not active");

        p.status = PolicyStatus.Cancelled;
        totalCoverage -= p.coverageAmount;
        emit PolicyCancelled(policyId);
    }

    // =====================================================
    // 理赔功能
    // =====================================================

    /**
     * @dev 提交理赔申请
     * @param policyId 保单ID
     * @param claimAmount 理赔金额
     * @param reasonHash 理赔原因哈希
     */
    function fileClaim(
        uint256 policyId,
        uint256 claimAmount,
        string memory reasonHash
    ) public returns (uint256) {
        require(policyId < policyCount, "Insurance: not found");
        Policy storage p = policies[policyId];
        require(p.status == PolicyStatus.Active, "Insurance: policy not active");
        require(block.timestamp < p.endAt, "Insurance: expired");
        require(msg.sender == p.insured, "Insurance: not insured");
        require(claimAmount > 0 && claimAmount <= p.coverageAmount, "Insurance: invalid amount");

        uint256 claimId = claimCount;
        claims[claimId] = Claim({
            claimId: claimId,
            policyId: policyId,
            claimant: msg.sender,
            claimAmount: claimAmount,
            reasonHash: reasonHash,
            filedAt: block.timestamp,
            processedAt: 0,
            status: ClaimStatus.Pending
        });

        policyClaims[policyId].push(claimId);
        claimCount++;

        emit ClaimFiled(claimId, policyId, claimAmount);
        return claimId;
    }

    /**
     * @dev 批准理赔（仅管理员/保险方）
     * @param claimId 理赔ID
     */
    function approveClaim(uint256 claimId) public payable onlyAdmin nonReentrant {
        require(claimId < claimCount, "Insurance: not found");
        Claim storage c = claims[claimId];
        require(c.status == ClaimStatus.Pending, "Insurance: not pending");

        Policy storage p = policies[c.policyId];
        require(msg.value >= c.claimAmount, "Insurance: insufficient payment");

        c.status = ClaimStatus.Approved;
        c.processedAt = block.timestamp;
        emit ClaimApproved(claimId, c.claimAmount);

        // 支付理赔金
        (bool ok, ) = payable(c.claimant).call{value: c.claimAmount}("");
        require(ok, "Insurance: payment failed");

        c.status = ClaimStatus.Paid;
        totalClaimPaid += c.claimAmount;
        p.coverageAmount -= c.claimAmount;

        // 退还多余支付
        if (msg.value > c.claimAmount) {
            (bool refund, ) = payable(admin).call{value: msg.value - c.claimAmount}("");
            require(refund, "Insurance: refund failed");
        }

        emit ClaimPaid(claimId, c.claimant, c.claimAmount);
    }

    /**
     * @dev 拒绝理赔
     */
    function rejectClaim(uint256 claimId, string memory /* reason */) public onlyAdmin {
        require(claimId < claimCount, "Insurance: not found");
        Claim storage c = claims[claimId];
        require(c.status == ClaimStatus.Pending, "Insurance: not pending");

        c.status = ClaimStatus.Rejected;
        c.processedAt = block.timestamp;
        emit ClaimRejected(claimId);
    }

    // =====================================================
    // 查询功能
    // =====================================================

    function getPolicy(uint256 policyId) public view returns (Policy memory) {
        require(policyId < policyCount, "Insurance: not found");
        return policies[policyId];
    }

    function getClaim(uint256 claimId) public view returns (Claim memory) {
        require(claimId < claimCount, "Insurance: not found");
        return claims[claimId];
    }

    function getInsuredPolicies(address insured) public view returns (uint256[] memory) {
        return insuredPolicies[insured];
    }

    function getPolicyClaims(uint256 policyId) public view returns (uint256[] memory) {
        return policyClaims[policyId];
    }

    /**
     * @dev 检查保单是否有效
     */
    function isPolicyActive(uint256 policyId) public view returns (bool) {
        if (policyId >= policyCount) return false;
        Policy memory p = policies[policyId];
        return p.status == PolicyStatus.Active && block.timestamp < p.endAt;
    }

    /**
     * @dev 获取保险系统统计
     */
    function getInsuranceStats() public view returns (
        uint256 _policyCount,
        uint256 _claimCount,
        uint256 _totalCoverage,
        uint256 _totalPremium,
        uint256 _totalClaimPaid
    ) {
        return (policyCount, claimCount, totalCoverage, totalPremium, totalClaimPaid);
    }

    /**
     * @dev 提取余额（仅管理员）
     */
    function withdraw() public onlyAdmin nonReentrant {
        uint256 balance = address(this).balance;
        require(balance > 0, "Insurance: no balance");
        (bool ok, ) = payable(admin).call{value: balance}("");
        require(ok, "Insurance: withdraw failed");
    }
}
