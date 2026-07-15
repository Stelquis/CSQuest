// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title LegalEnforcement - 智能合约法律等效
 * @notice 对应设计要求 4.3.1：将法律条款编码到智能合约实现法律等效，
 *         内置争议解决仲裁机制、法律事件自动触发、监管报告自动生成
 */
contract LegalEnforcement {
    // =====================================================
    // 数据结构
    // =====================================================

    /// @dev 法律条款记录
    struct LegalClause {
        uint256 clauseId;
        uint256 assetId;        // 关联资产
        string title;           // 条款标题（如：产权归属、权益分配、违约处理）
        string contentHash;     // 条款内容哈希（链下法律文件上链凭证）
        bytes executionCode;    // 可执行逻辑标识（条款编码）
        uint256 effectiveAt;    // 生效时间
        bool isActive;          // 是否生效
    }

    /// @dev 争议记录
    struct Dispute {
        uint256 disputeId;
        uint256 assetId;
        address plaintiff;      // 申诉方
        address defendant;      // 被诉方
        string reasonHash;      // 争议原因哈希
        uint256 createdAt;
        uint256 resolvedAt;
        Status status;          // 争议状态
        string verdictHash;     // 裁决结果哈希
        bool plaintiffFavored;  // 是否支持申诉方
    }

    /// @dev 法律事件触发器
    struct LegalEvent {
        uint256 eventId;
        uint256 assetId;
        string eventType;       // 事件类型（资产违约、到期赎回等）
        string triggerCondition;// 触发条件描述
        uint256 triggerAt;      // 触发时间
        bool executed;          // 是否已执行
        string executionHash;   // 执行凭证哈希
    }

    /// @dev 监管报告
    struct RegulatoryReport {
        uint256 reportId;
        uint256 assetId;
        string reportType;      // 报告类型（资产登记/交易记录/投资者信息）
        string contentHash;     // 报告内容哈希
        uint256 generatedAt;
        bool verified;
    }

    enum Status { Pending, Arbitrating, Resolved, Cancelled }

    // =====================================================
    // 状态变量
    // =====================================================

    address public admin;

    /// @notice 仲裁员地址（争议解决裁决人）
    address public arbitrator;

    mapping(uint256 => LegalClause) public clauses;
    uint256 public clauseCount;

    mapping(uint256 => Dispute) public disputes;
    uint256 public disputeCount;

    mapping(uint256 => LegalEvent) public legalEvents;
    uint256 public eventCount;

    mapping(uint256 => RegulatoryReport) public reports;
    uint256 public reportCount;

    /// @notice 资产 -> 条款列表
    mapping(uint256 => uint256[]) public assetClauses;

    // =====================================================
    // 事件
    // =====================================================

    event ClauseEncoded(uint256 indexed clauseId, uint256 indexed assetId, string title);
    event ClauseDeactivated(uint256 indexed clauseId);
    event DisputeFiled(uint256 indexed disputeId, uint256 indexed assetId, address plaintiff, address defendant);
    event DisputeResolved(uint256 indexed disputeId, bool plaintiffFavored, string verdictHash);
    event LegalEventTriggered(uint256 indexed eventId, uint256 indexed assetId, string eventType);
    event LegalEventExecuted(uint256 indexed eventId, string executionHash);
    event ReportGenerated(uint256 indexed reportId, uint256 indexed assetId, string reportType);
    event ReportVerified(uint256 indexed reportId);
    event ArbitratorUpdated(address oldArbitrator, address newArbitrator);

    // =====================================================
    // 修饰器
    // =====================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "LegalEnforcement: not admin");
        _;
    }

    modifier onlyArbitrator() {
        require(msg.sender == arbitrator, "LegalEnforcement: not arbitrator");
        _;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    constructor() {
        admin = msg.sender;
        arbitrator = msg.sender;
    }

    // =====================================================
    // 条款编码功能（将法律条款编码到智能合约）
    // =====================================================

    /**
     * @dev 编码法律条款（产权归属、权益分配、违约处理等）
     * @param assetId 关联资产ID
     * @param title 条款标题
     * @param contentHash 法律文件内容哈希
     * @param executionCode 可执行逻辑标识
     */
    function encodeClause(
        uint256 assetId,
        string memory title,
        string memory contentHash,
        bytes memory executionCode
    ) public onlyAdmin returns (uint256) {
        require(bytes(title).length > 0, "LegalEnforcement: empty title");

        uint256 clauseId = clauseCount;
        clauses[clauseId] = LegalClause({
            clauseId: clauseId,
            assetId: assetId,
            title: title,
            contentHash: contentHash,
            executionCode: executionCode,
            effectiveAt: block.timestamp,
            isActive: true
        });

        assetClauses[assetId].push(clauseId);
        clauseCount++;

        emit ClauseEncoded(clauseId, assetId, title);
        return clauseId;
    }

    /**
     * @dev 停用法律条款
     */
    function deactivateClause(uint256 clauseId) public onlyAdmin {
        require(clauseId < clauseCount, "LegalEnforcement: clause not found");
        clauses[clauseId].isActive = false;
        emit ClauseDeactivated(clauseId);
    }

    // =====================================================
    // 争议解决功能（内置仲裁机制）
    // =====================================================

    /**
     * @dev 发起争议仲裁
     * @param assetId 关联资产ID
     * @param defendant 被诉方地址
     * @param reasonHash 争议原因哈希
     */
    function fileDispute(
        uint256 assetId,
        address defendant,
        string memory reasonHash
    ) public returns (uint256) {
        require(defendant != address(0), "LegalEnforcement: zero defendant");
        require(defendant != msg.sender, "LegalEnforcement: cannot dispute self");

        uint256 disputeId = disputeCount;
        disputes[disputeId] = Dispute({
            disputeId: disputeId,
            assetId: assetId,
            plaintiff: msg.sender,
            defendant: defendant,
            reasonHash: reasonHash,
            createdAt: block.timestamp,
            resolvedAt: 0,
            status: Status.Pending,
            verdictHash: "",
            plaintiffFavored: false
        });

        disputeCount++;
        emit DisputeFiled(disputeId, assetId, msg.sender, defendant);
        return disputeId;
    }

    /**
     * @dev 仲裁裁决（仅仲裁员，裁决结果自动记录并执行）
     * @param disputeId 争议ID
     * @param plaintiffFavored 是否支持申诉方
     * @param verdictHash 裁决结果哈希
     */
    function resolveDispute(
        uint256 disputeId,
        bool plaintiffFavored,
        string memory verdictHash
    ) public onlyArbitrator {
        require(disputeId < disputeCount, "LegalEnforcement: dispute not found");
        Dispute storage d = disputes[disputeId];
        require(d.status == Status.Pending || d.status == Status.Arbitrating, "LegalEnforcement: not pending");

        d.status = Status.Resolved;
        d.plaintiffFavored = plaintiffFavored;
        d.verdictHash = verdictHash;
        d.resolvedAt = block.timestamp;

        emit DisputeResolved(disputeId, plaintiffFavored, verdictHash);
    }

    /**
     * @dev 取消争议
     */
    function cancelDispute(uint256 disputeId) public {
        require(disputeId < disputeCount, "LegalEnforcement: dispute not found");
        Dispute storage d = disputes[disputeId];
        require(msg.sender == d.plaintiff || msg.sender == admin, "LegalEnforcement: not authorized");
        require(d.status == Status.Pending, "LegalEnforcement: not pending");
        d.status = Status.Cancelled;
    }

    // =====================================================
    // 法律事件触发功能（资产违约、到期赎回等自动触发）
    // =====================================================

    /**
     * @dev 注册法律事件触发器
     * @param assetId 资产ID
     * @param eventType 事件类型（资产违约/到期赎回）
     * @param triggerCondition 触发条件描述
     */
    function registerLegalEvent(
        uint256 assetId,
        string memory eventType,
        string memory triggerCondition
    ) public onlyAdmin returns (uint256) {
        uint256 eventId = eventCount;
        legalEvents[eventId] = LegalEvent({
            eventId: eventId,
            assetId: assetId,
            eventType: eventType,
            triggerCondition: triggerCondition,
            triggerAt: 0,
            executed: false,
            executionHash: ""
        });

        eventCount++;
        return eventId;
    }

    /**
     * @dev 触发法律事件（条件满足时调用，自动触发相应法律程序）
     * @param eventId 事件ID
     */
    function triggerLegalEvent(uint256 eventId) public onlyAdmin {
        require(eventId < eventCount, "LegalEnforcement: event not found");
        LegalEvent storage e = legalEvents[eventId];
        require(!e.executed, "LegalEnforcement: already executed");

        e.triggerAt = block.timestamp;
        emit LegalEventTriggered(eventId, e.assetId, e.eventType);
    }

    /**
     * @dev 执行法律事件（记录执行凭证）
     * @param eventId 事件ID
     * @param executionHash 执行凭证哈希
     */
    function executeLegalEvent(uint256 eventId, string memory executionHash) public onlyAdmin {
        require(eventId < eventCount, "LegalEnforcement: event not found");
        LegalEvent storage e = legalEvents[eventId];
        require(e.triggerAt > 0, "LegalEnforcement: not triggered");
        require(!e.executed, "LegalEnforcement: already executed");

        e.executed = true;
        e.executionHash = executionHash;
        emit LegalEventExecuted(eventId, executionHash);
    }

    // =====================================================
    // 监管报告功能（自动生成符合监管要求的报告）
    // =====================================================

    /**
     * @dev 生成监管报告（资产登记、交易记录、投资者信息等）
     * @param assetId 资产ID
     * @param reportType 报告类型
     * @param contentHash 报告内容哈希
     */
    function generateReport(
        uint256 assetId,
        string memory reportType,
        string memory contentHash
    ) public onlyAdmin returns (uint256) {
        require(bytes(reportType).length > 0, "LegalEnforcement: empty type");

        uint256 reportId = reportCount;
        reports[reportId] = RegulatoryReport({
            reportId: reportId,
            assetId: assetId,
            reportType: reportType,
            contentHash: contentHash,
            generatedAt: block.timestamp,
            verified: false
        });

        reportCount++;
        emit ReportGenerated(reportId, assetId, reportType);
        return reportId;
    }

    /**
     * @dev 验证监管报告
     */
    function verifyReport(uint256 reportId) public onlyAdmin {
        require(reportId < reportCount, "LegalEnforcement: report not found");
        reports[reportId].verified = true;
        emit ReportVerified(reportId);
    }

    // =====================================================
    // 管理与查询功能
    // =====================================================

    /**
     * @dev 设置仲裁员
     */
    function setArbitrator(address newArbitrator) public onlyAdmin {
        require(newArbitrator != address(0), "LegalEnforcement: zero address");
        address old = arbitrator;
        arbitrator = newArbitrator;
        emit ArbitratorUpdated(old, newArbitrator);
    }

    function getClause(uint256 clauseId) public view returns (LegalClause memory) {
        require(clauseId < clauseCount, "LegalEnforcement: not found");
        return clauses[clauseId];
    }

    function getDispute(uint256 disputeId) public view returns (Dispute memory) {
        require(disputeId < disputeCount, "LegalEnforcement: not found");
        return disputes[disputeId];
    }

    function getLegalEvent(uint256 eventId) public view returns (LegalEvent memory) {
        require(eventId < eventCount, "LegalEnforcement: not found");
        return legalEvents[eventId];
    }

    function getReport(uint256 reportId) public view returns (RegulatoryReport memory) {
        require(reportId < reportCount, "LegalEnforcement: not found");
        return reports[reportId];
    }

    function getAssetClauses(uint256 assetId) public view returns (uint256[] memory) {
        return assetClauses[assetId];
    }

    /**
     * @dev 获取系统统计信息
     */
    function getSystemStats() public view returns (
        uint256 _clauseCount,
        uint256 _disputeCount,
        uint256 _eventCount,
        uint256 _reportCount,
        uint256 _pendingDisputes
    ) {
        uint256 pending = 0;
        for (uint256 i = 0; i < disputeCount; i++) {
            if (disputes[i].status == Status.Pending || disputes[i].status == Status.Arbitrating) {
                pending++;
            }
        }
        return (clauseCount, disputeCount, eventCount, reportCount, pending);
    }
}
