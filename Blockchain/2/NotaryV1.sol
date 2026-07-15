// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title NotaryV1 - 基础存证智能合约
 * @notice 实现文档存证、查询、所有者验证等基础功能
 */
contract NotaryV1 {
    // =====================================================
    // 数据结构
    // =====================================================

    /**
     * @dev 存证记录结构体
     * @param documentId 文档唯一标识
     * @param fileHash 文件哈希值（SHA-256）
     * @param owner 存证所有者地址
     * @param timestamp 存证时间戳
     * @param operation 操作类型（如：REGISTER, UPDATE, REVOKE）
     */
    struct NotarizationRecord {
        string documentId;
        bytes32 fileHash;
        address owner;
        uint256 timestamp;
        string operation;
    }

    // =====================================================
    // 状态变量
    // =====================================================

    /// @notice 存证记录映射：文档ID => 存证记录
    mapping(string => NotarizationRecord) private records;

    /// @notice 文档ID列表（用于枚举）
    string[] private documentIds;

    /// @notice 合约所有者
    address public owner;

    /// @notice 存证总数
    uint256 public totalRecords;

    // =====================================================
    // 事件
    // =====================================================

    /// @notice 文档存证事件
    event DocumentNotarized(
        string indexed documentId,
        bytes32 fileHash,
        address indexed owner,
        uint256 timestamp,
        string operation
    );

    /// @notice 文档撤销事件
    event DocumentRevoked(
        string indexed documentId,
        address indexed owner,
        uint256 timestamp
    );

    // =====================================================
    // 修饰器
    // =====================================================

    /// @notice 仅合约所有者可调用
    modifier onlyOwner() {
        require(msg.sender == owner, "NotaryV1: caller is not the owner");
        _;
    }

    /// @notice 文档必须存在
    modifier documentExists(string memory _documentId) {
        require(
            records[_documentId].timestamp > 0,
            "NotaryV1: document does not exist"
        );
        _;
    }

    /// @notice 文档必须不存在
    modifier documentNotExists(string memory _documentId) {
        require(
            records[_documentId].timestamp == 0,
            "NotaryV1: document already exists"
        );
        _;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    /**
     * @dev 构造函数，设置合约所有者
     */
    constructor() {
        owner = msg.sender;
    }

    // =====================================================
    // 核心功能
    // =====================================================

    /**
     * @dev 文档存证功能
     * @param _documentId 文档唯一标识
     * @param _fileHash 文件哈希值
     * @param _operation 操作类型
     */
    function notarizeDocument(
        string memory _documentId,
        bytes32 _fileHash,
        string memory _operation
    ) public documentNotExists(_documentId) {
        require(bytes(_documentId).length > 0, "NotaryV1: documentId is empty");
        require(_fileHash != bytes32(0), "NotaryV1: fileHash is empty");
        require(bytes(_operation).length > 0, "NotaryV1: operation is empty");

        records[_documentId] = NotarizationRecord({
            documentId: _documentId,
            fileHash: _fileHash,
            owner: msg.sender,
            timestamp: block.timestamp,
            operation: _operation
        });

        documentIds.push(_documentId);
        totalRecords++;

        emit DocumentNotarized(
            _documentId,
            _fileHash,
            msg.sender,
            block.timestamp,
            _operation
        );
    }

    /**
     * @dev 存证查询功能
     * @param _documentId 文档唯一标识
     * @return documentId 文档ID
     * @return fileHash 文件哈希
     * @return recordOwner 所有者地址
     * @return timestamp 时间戳
     * @return operation 操作类型
     */
    function getRecord(
        string memory _documentId
    )
        public
        view
        documentExists(_documentId)
        returns (
            string memory documentId,
            bytes32 fileHash,
            address recordOwner,
            uint256 timestamp,
            string memory operation
        )
    {
        NotarizationRecord memory record = records[_documentId];
        return (
            record.documentId,
            record.fileHash,
            record.owner,
            record.timestamp,
            record.operation
        );
    }

    /**
     * @dev 所有者验证功能
     * @param _documentId 文档唯一标识
     * @param _address 待验证的地址
     * @return 是否为文档所有者
     */
    function verifyOwner(
        string memory _documentId,
        address _address
    ) public view documentExists(_documentId) returns (bool) {
        return records[_documentId].owner == _address;
    }

    /**
     * @dev 检查文档是否存在
     * @param _documentId 文档唯一标识
     * @return 文档是否存在
     */
    function isDocumentExists(
        string memory _documentId
    ) public view returns (bool) {
        return records[_documentId].timestamp > 0;
    }

    /**
     * @dev 获取所有文档ID
     * @return 文档ID数组
     */
    function getAllDocumentIds() public view returns (string[] memory) {
        return documentIds;
    }

    /**
     * @dev 获取存证记录数量
     * @return 存证总数
     */
    function getRecordCount() public view returns (uint256) {
        return totalRecords;
    }

    /**
     * @dev 验证文档完整性
     * @param _documentId 文档唯一标识
     * @param _fileHash 待验证的文件哈希
     * @return 哈希是否匹配
     */
    function verifyIntegrity(
        string memory _documentId,
        bytes32 _fileHash
    ) public view documentExists(_documentId) returns (bool) {
        return records[_documentId].fileHash == _fileHash;
    }
}
