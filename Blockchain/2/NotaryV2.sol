// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title NotaryV2 - 扩展AI代理存证合约
 * @notice 在V1基础上增加签名验证、批量存证、AI权限管理功能
 */
contract NotaryV2 {
    // =====================================================
    // 数据结构
    // =====================================================

    /**
     * @dev 存证记录结构体
     */
    struct NotarizationRecord {
        string documentId;
        bytes32 fileHash;
        address owner;
        uint256 timestamp;
        string operation;
        address aiAgent; // AI代理地址
    }

    /**
     * @dev 批量存证请求结构体
     */
    struct BatchRequest {
        string documentId;
        bytes32 fileHash;
        string operation;
    }

    // =====================================================
    // 状态变量
    // =====================================================

    /// @notice 存证记录映射
    mapping(string => NotarizationRecord) private records;

    /// @notice 文档ID列表
    string[] private documentIds;

    /// @notice 合约管理员
    address public admin;

    /// @notice 存证总数
    uint256 public totalRecords;

    /// @notice 已授权的AI代理映射
    mapping(address => bool) public authorizedAIAgents;

    /// @notice AI代理列表
    address[] private aiAgentList;

    /// @notice 签名验证的nonce，防止重放攻击
    mapping(address => uint256) public nonces;

    // =====================================================
    // 事件
    // =====================================================

    /// @notice 文档存证事件
    event DocumentNotarized(
        string indexed documentId,
        bytes32 fileHash,
        address indexed owner,
        uint256 timestamp,
        string operation,
        address aiAgent
    );

    /// @notice 批量存证事件
    event BatchNotarized(
        uint256 count,
        address indexed operator,
        uint256 timestamp
    );

    /// @notice AI代理授权事件
    event AIAgentAuthorized(
        address indexed agent,
        bool authorized,
        address indexed admin
    );

    /// @notice 签名验证事件
    event SignatureVerified(
        string indexed documentId,
        address indexed signer,
        bool valid
    );

    // =====================================================
    // 修饰器
    // =====================================================

    /// @notice 仅管理员可调用
    modifier onlyAdmin() {
        require(msg.sender == admin, "NotaryV2: caller is not admin");
        _;
    }

    /// @notice 仅授权AI代理可调用
    modifier onlyAuthorizedAI() {
        require(
            authorizedAIAgents[msg.sender],
            "NotaryV2: caller is not authorized AI agent"
        );
        _;
    }

    /// @notice 文档必须存在
    modifier documentExists(string memory _documentId) {
        require(
            records[_documentId].timestamp > 0,
            "NotaryV2: document does not exist"
        );
        _;
    }

    /// @notice 文档必须不存在
    modifier documentNotExists(string memory _documentId) {
        require(
            records[_documentId].timestamp == 0,
            "NotaryV2: document already exists"
        );
        _;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    /**
     * @dev 构造函数
     */
    constructor() {
        admin = msg.sender;
    }

    // =====================================================
    // AI权限管理功能
    // =====================================================

    /**
     * @dev 授权AI代理
     * @param _agent AI代理地址
     */
    function authorizeAIAgent(address _agent) public onlyAdmin {
        require(_agent != address(0), "NotaryV2: invalid address");
        require(!authorizedAIAgents[_agent], "NotaryV2: already authorized");

        authorizedAIAgents[_agent] = true;
        aiAgentList.push(_agent);

        emit AIAgentAuthorized(_agent, true, msg.sender);
    }

    /**
     * @dev 撤销AI代理授权
     * @param _agent AI代理地址
     */
    function revokeAIAgent(address _agent) public onlyAdmin {
        require(authorizedAIAgents[_agent], "NotaryV2: not authorized");

        authorizedAIAgents[_agent] = false;

        // 从列表中移除
        for (uint256 i = 0; i < aiAgentList.length; i++) {
            if (aiAgentList[i] == _agent) {
                aiAgentList[i] = aiAgentList[aiAgentList.length - 1];
                aiAgentList.pop();
                break;
            }
        }

        emit AIAgentAuthorized(_agent, false, msg.sender);
    }

    /**
     * @dev 检查是否为授权AI代理
     * @param _agent 地址
     * @return 是否授权
     */
    function isAuthorizedAI(address _agent) public view returns (bool) {
        return authorizedAIAgents[_agent];
    }

    /**
     * @dev 获取所有授权AI代理
     * @return AI代理地址数组
     */
    function getAllAIAgents() public view returns (address[] memory) {
        return aiAgentList;
    }

    // =====================================================
    // 签名验证功能
    // =====================================================

    /**
     * @dev 生成签名哈希
     * @param _documentId 文档ID
     * @param _fileHash 文件哈希
     * @param _nonce 随机数
     * @return 签名哈希
     */
    function getMessageHash(
        string memory _documentId,
        bytes32 _fileHash,
        uint256 _nonce
    ) public view returns (bytes32) {
        return keccak256(
            abi.encodePacked(_documentId, _fileHash, _nonce, address(this))
        );
    }

    /**
     * @dev 验证签名并存证
     * @param _documentId 文档ID
     * @param _fileHash 文件哈希
     * @param _operation 操作类型
     * @param _signer 签名者地址
     * @param _v 签名参数v
     * @param _r 签名参数r
     * @param _s 签名参数s
     */
    function notarizeWithSignature(
        string memory _documentId,
        bytes32 _fileHash,
        string memory _operation,
        address _signer,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public documentNotExists(_documentId) {
        require(bytes(_documentId).length > 0, "NotaryV2: documentId is empty");
        require(_fileHash != bytes32(0), "NotaryV2: fileHash is empty");

        // 获取签名哈希
        uint256 nonce = nonces[_signer];
        bytes32 messageHash = getMessageHash(_documentId, _fileHash, nonce);

        // 验证签名 - 使用以太坊签名消息格式
        bytes32 ethSignedMessageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );

        // 从签名中恢复地址
        address recoveredAddress = ecrecover(ethSignedMessageHash, _v, _r, _s);
        require(
            recoveredAddress != address(0),
            "NotaryV2: invalid signature"
        );
        require(
            recoveredAddress == _signer,
            "NotaryV2: signature verification failed"
        );

        // 更新nonce
        nonces[_signer]++;

        // 创建存证记录
        records[_documentId] = NotarizationRecord({
            documentId: _documentId,
            fileHash: _fileHash,
            owner: _signer,
            timestamp: block.timestamp,
            operation: _operation,
            aiAgent: msg.sender
        });

        documentIds.push(_documentId);
        totalRecords++;

        emit DocumentNotarized(
            _documentId,
            _fileHash,
            _signer,
            block.timestamp,
            _operation,
            msg.sender
        );

        emit SignatureVerified(_documentId, _signer, true);
    }

    // =====================================================
    // 批量存证功能
    // =====================================================

    /**
     * @dev AI代理批量存证
     * @param _requests 批量存证请求数组
     */
    function batchNotarize(
        BatchRequest[] memory _requests
    ) public onlyAuthorizedAI {
        require(_requests.length > 0, "NotaryV2: empty batch");
        require(_requests.length <= 10, "NotaryV2: batch too large");

        for (uint256 i = 0; i < _requests.length; i++) {
            require(
                records[_requests[i].documentId].timestamp == 0,
                "NotaryV2: document already exists"
            );
            require(
                bytes(_requests[i].documentId).length > 0,
                "NotaryV2: documentId is empty"
            );
            require(
                _requests[i].fileHash != bytes32(0),
                "NotaryV2: fileHash is empty"
            );

            records[_requests[i].documentId] = NotarizationRecord({
                documentId: _requests[i].documentId,
                fileHash: _requests[i].fileHash,
                owner: msg.sender,
                timestamp: block.timestamp,
                operation: _requests[i].operation,
                aiAgent: msg.sender
            });

            documentIds.push(_requests[i].documentId);
            totalRecords++;

            emit DocumentNotarized(
                _requests[i].documentId,
                _requests[i].fileHash,
                msg.sender,
                block.timestamp,
                _requests[i].operation,
                msg.sender
            );
        }

        emit BatchNotarized(_requests.length, msg.sender, block.timestamp);
    }

    // =====================================================
    // 查询功能（继承V1）
    // =====================================================

    /**
     * @dev 查询存证记录
     * @param _documentId 文档ID
     * @return documentId 文档ID
     * @return fileHash 文件哈希
     * @return recordOwner 所有者地址
     * @return timestamp 时间戳
     * @return operation 操作类型
     * @return aiAgent AI代理地址
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
            string memory operation,
            address aiAgent
        )
    {
        NotarizationRecord memory record = records[_documentId];
        return (
            record.documentId,
            record.fileHash,
            record.owner,
            record.timestamp,
            record.operation,
            record.aiAgent
        );
    }

    /**
     * @dev 验证所有者
     * @param _documentId 文档ID
     * @param _address 待验证地址
     * @return 是否为所有者
     */
    function verifyOwner(
        string memory _documentId,
        address _address
    ) public view documentExists(_documentId) returns (bool) {
        return records[_documentId].owner == _address;
    }

    /**
     * @dev 验证文档完整性
     * @param _documentId 文档ID
     * @param _fileHash 待验证哈希
     * @return 是否匹配
     */
    function verifyIntegrity(
        string memory _documentId,
        bytes32 _fileHash
    ) public view documentExists(_documentId) returns (bool) {
        return records[_documentId].fileHash == _fileHash;
    }

    /**
     * @dev 获取所有文档ID
     * @return 文档ID数组
     */
    function getAllDocumentIds() public view returns (string[] memory) {
        return documentIds;
    }

    /**
     * @dev 获取存证总数
     * @return 总数
     */
    function getRecordCount() public view returns (uint256) {
        return totalRecords;
    }
}
