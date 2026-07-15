// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title NotaryUpgradeable - 可升级存证合约
 * @notice 使用透明代理模式实现可升级合约
 *
 * 存储布局设计原则：
 * 1. 使用固定插槽存储避免存储冲突
 * 2. 新版本合约继承旧版本存储布局
 * 3. 禁止修改已有存储变量的顺序和类型
 */

// =====================================================
// 存储合约 - 定义共享存储布局
// =====================================================

/**
 * @title NotaryStorageV1 - V1版本存储布局
 * @notice 所有版本合约必须继承此合约以确保存储布局一致
 */
contract NotaryStorageV1 {
    /**
     * @dev 存证记录结构体
     */
    struct NotarizationRecord {
        string documentId;
        bytes32 fileHash;
        address owner;
        uint256 timestamp;
        string operation;
    }

    // =====================================================
    // 存储变量（固定顺序，不可修改）
    // =====================================================

    /// @notice 合约管理员
    address public admin;

    /// @notice 存证记录映射
    mapping(string => NotarizationRecord) internal _records;

    /// @notice 文档ID列表
    string[] internal _documentIds;

    /// @notice 存证总数
    uint256 public totalRecords;

    /// @notice 合约是否已初始化
    bool public initialized;

    /// @notice 实现合约地址
    address public implementation;
}

/**
 * @title NotaryStorageV2 - V2版本存储布局（扩展）
 * @notice 在V1基础上新增存储变量
 */
contract NotaryStorageV2 is NotaryStorageV1 {
    /**
     * @dev 扩展存证记录结构体
     */
    struct NotarizationRecordV2 {
        string documentId;
        bytes32 fileHash;
        address owner;
        uint256 timestamp;
        string operation;
        address aiAgent; // 新增：AI代理地址
    }

    // =====================================================
    // V2新增存储变量（追加在V1之后）
    // =====================================================

    /// @notice V2存证记录映射
    mapping(string => NotarizationRecordV2) internal _recordsV2;

    /// @notice 已授权的AI代理
    mapping(address => bool) public authorizedAIAgents;

    /// @notice AI代理列表
    address[] internal _aiAgentList;

    /// @notice 签名nonce
    mapping(address => uint256) public nonces;

    /// @notice 合约版本
    uint256 public version;
}

// =====================================================
// 接口定义
// =====================================================

/**
 * @title INotaryImplementation - 合约实现接口
 */
interface INotaryImplementation {
    function initialize(address _admin) external;

    function notarizeDocument(
        string memory _documentId,
        bytes32 _fileHash,
        string memory _operation
    ) external;

    function getRecord(
        string memory _documentId
    )
        external
        view
        returns (
            string memory,
            bytes32,
            address,
            uint256,
            string memory
        );

    function verifyOwner(
        string memory _documentId,
        address _address
    ) external view returns (bool);
}

// =====================================================
// 代理合约
// =====================================================

/**
 * @title NotaryProxy - 透明代理合约
 * @notice 转发调用到实现合约，支持升级
 */
contract NotaryProxy is NotaryStorageV2 {
    // =====================================================
    // 事件
    // =====================================================

    /// @notice 升级事件
    event Upgraded(
        address indexed oldImplementation,
        address indexed newImplementation,
        uint256 version
    );

    /// @notice 管理员变更事件
    event AdminChanged(
        address indexed oldAdmin,
        address indexed newAdmin
    );

    // =====================================================
    // 修饰器
    // =====================================================

    /// @notice 仅管理员可调用
    modifier onlyAdmin() {
        require(msg.sender == admin, "Proxy: caller is not admin");
        _;
    }

    /// @notice 非代理管理调用（透明代理模式）
    modifier ifNotAdmin() {
        require(msg.sender != admin, "Proxy: admin cannot call implementation");
        _;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    /**
     * @dev 构造函数
     * @param _implementation 初始实现合约地址
     * @param _admin 管理员地址
     */
    constructor(address _implementation, address _admin) {
        require(
            _implementation != address(0),
            "Proxy: invalid implementation"
        );
        require(_admin != address(0), "Proxy: invalid admin");

        implementation = _implementation;
        admin = _admin;
        version = 1;
    }

    // =====================================================
    // 代理管理功能（仅管理员）
    // =====================================================

    /**
     * @dev 升级实现合约
     * @param _newImplementation 新实现合约地址
     */
    function upgrade(address _newImplementation) external onlyAdmin {
        require(
            _newImplementation != address(0),
            "Proxy: invalid implementation"
        );
        require(
            _newImplementation != implementation,
            "Proxy: same implementation"
        );

        address oldImplementation = implementation;
        implementation = _newImplementation;
        version++;

        emit Upgraded(oldImplementation, _newImplementation, version);
    }

    /**
     * @dev 变更管理员
     * @param _newAdmin 新管理员地址
     */
    function changeAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Proxy: invalid admin");
        require(_newAdmin != admin, "Proxy: same admin");

        address oldAdmin = admin;
        admin = _newAdmin;

        emit AdminChanged(oldAdmin, _newAdmin);
    }

    /**
     * @dev 获取当前实现合约地址
     * @return 实现合约地址
     */
    function getImplementation() external view returns (address) {
        return implementation;
    }

    // =====================================================
    // 回退函数 - 转发调用到实现合约
    // =====================================================

    /**
     * @dev 回退函数，转发所有非管理员调用到实现合约
     */
    fallback() external payable ifNotAdmin {
        _delegate(implementation);
    }

    /**
     * @dev 接收ETH
     */
    receive() external payable {
        _delegate(implementation);
    }

    /**
     * @dev 委托调用实现合约
     * @param _implementation 实现合约地址
     */
    function _delegate(address _implementation) internal {
        assembly {
            // 复制calldata
            calldatacopy(0, 0, calldatasize())

            // 委托调用
            let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)

            // 复制返回数据
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}

// =====================================================
// 实现合约V1
// =====================================================

/**
 * @title NotaryImplV1 - V1版本实现合约
 * @notice 实现基础存证功能
 */
contract NotaryImplV1 is NotaryStorageV1 {
    // =====================================================
    // 事件
    // =====================================================

    event DocumentNotarized(
        string indexed documentId,
        bytes32 fileHash,
        address indexed owner,
        uint256 timestamp,
        string operation
    );

    // =====================================================
    // 初始化函数（替代构造函数）
    // =====================================================

    /**
     * @dev 初始化函数（只能调用一次）
     * @param _admin 管理员地址
     */
    function initialize(address _admin) external {
        require(!initialized, "Already initialized");
        require(_admin != address(0), "Invalid admin");

        admin = _admin;
        initialized = true;
    }

    // =====================================================
    // 核心功能
    // =====================================================

    /**
     * @dev 文档存证
     */
    function notarizeDocument(
        string memory _documentId,
        bytes32 _fileHash,
        string memory _operation
    ) external {
        require(
            _records[_documentId].timestamp == 0,
            "Document already exists"
        );
        require(bytes(_documentId).length > 0, "Empty documentId");
        require(_fileHash != bytes32(0), "Empty fileHash");

        _records[_documentId] = NotarizationRecord({
            documentId: _documentId,
            fileHash: _fileHash,
            owner: msg.sender,
            timestamp: block.timestamp,
            operation: _operation
        });

        _documentIds.push(_documentId);
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
     * @dev 查询存证记录
     */
    function getRecord(
        string memory _documentId
    )
        external
        view
        returns (
            string memory,
            bytes32,
            address,
            uint256,
            string memory
        )
    {
        require(_records[_documentId].timestamp > 0, "Document not found");

        NotarizationRecord memory record = _records[_documentId];
        return (
            record.documentId,
            record.fileHash,
            record.owner,
            record.timestamp,
            record.operation
        );
    }

    /**
     * @dev 验证所有者
     */
    function verifyOwner(
        string memory _documentId,
        address _address
    ) external view returns (bool) {
        require(_records[_documentId].timestamp > 0, "Document not found");
        return _records[_documentId].owner == _address;
    }

    /**
     * @dev 验证文档完整性
     */
    function verifyIntegrity(
        string memory _documentId,
        bytes32 _fileHash
    ) external view returns (bool) {
        require(_records[_documentId].timestamp > 0, "Document not found");
        return _records[_documentId].fileHash == _fileHash;
    }

    /**
     * @dev 获取所有文档ID
     */
    function getAllDocumentIds() external view returns (string[] memory) {
        return _documentIds;
    }

    /**
     * @dev 获取存证总数
     */
    function getRecordCount() external view returns (uint256) {
        return totalRecords;
    }
}

// =====================================================
// 实现合约V2
// =====================================================

/**
 * @title NotaryImplV2 - V2版本实现合约
 * @notice 在V1基础上扩展AI代理、批量存证、签名验证功能
 */
contract NotaryImplV2 is NotaryStorageV2 {
    // =====================================================
    // 事件
    // =====================================================

    event DocumentNotarized(
        string indexed documentId,
        bytes32 fileHash,
        address indexed owner,
        uint256 timestamp,
        string operation,
        address aiAgent
    );

    event BatchNotarized(
        uint256 count,
        address indexed operator,
        uint256 timestamp
    );

    event AIAgentAuthorized(
        address indexed agent,
        bool authorized
    );

    // =====================================================
    // 初始化函数
    // =====================================================

    /**
     * @dev 初始化V2版本（仅管理员可调用）
     */
    function initializeV2() external {
        require(msg.sender == admin, "Not authorized");
        require(version == 1, "Already upgraded");
        version = 2;
    }

    // =====================================================
    // 签名验证功能
    // =====================================================

    /**
     * @dev 生成签名哈希
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
     * @dev 使用签名验证进行存证
     */
    function notarizeWithSignature(
        string memory _documentId,
        bytes32 _fileHash,
        string memory _operation,
        address _signer,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) external {
        require(bytes(_documentId).length > 0, "DocumentId is empty");
        require(_fileHash != bytes32(0), "FileHash is empty");
        require(_recordsV2[_documentId].timestamp == 0, "Document already exists");

        // 获取签名哈希
        uint256 nonce = nonces[_signer];
        bytes32 messageHash = getMessageHash(_documentId, _fileHash, nonce);

        // 验证签名
        bytes32 ethSignedMessageHash = keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", messageHash)
        );

        address recoveredAddress = ecrecover(ethSignedMessageHash, _v, _r, _s);
        require(recoveredAddress != address(0), "Invalid signature");
        require(recoveredAddress == _signer, "Signature verification failed");

        // 更新nonce
        nonces[_signer]++;

        // 创建存证记录
        _recordsV2[_documentId] = NotarizationRecordV2({
            documentId: _documentId,
            fileHash: _fileHash,
            owner: _signer,
            timestamp: block.timestamp,
            operation: _operation,
            aiAgent: msg.sender
        });

        _documentIds.push(_documentId);
        totalRecords++;

        emit DocumentNotarized(
            _documentId,
            _fileHash,
            _signer,
            block.timestamp,
            _operation,
            msg.sender
        );
    }

    // =====================================================
    // AI权限管理
    // =====================================================

    /**
     * @dev 授权AI代理
     */
    function authorizeAIAgent(address _agent) external {
        require(msg.sender == admin, "Not authorized");
        require(_agent != address(0), "Invalid address");
        require(!authorizedAIAgents[_agent], "Already authorized");

        authorizedAIAgents[_agent] = true;
        _aiAgentList.push(_agent);

        emit AIAgentAuthorized(_agent, true);
    }

    /**
     * @dev 撤销AI代理
     */
    function revokeAIAgent(address _agent) external {
        require(msg.sender == admin, "Not authorized");
        require(authorizedAIAgents[_agent], "Not authorized agent");

        authorizedAIAgents[_agent] = false;

        for (uint256 i = 0; i < _aiAgentList.length; i++) {
            if (_aiAgentList[i] == _agent) {
                _aiAgentList[i] = _aiAgentList[_aiAgentList.length - 1];
                _aiAgentList.pop();
                break;
            }
        }

        emit AIAgentAuthorized(_agent, false);
    }

    /**
     * @dev 批量存证
     */
    function batchNotarize(
        string[] memory docIds,
        bytes32[] memory fileHashes,
        string[] memory operations
    ) external {
        require(authorizedAIAgents[msg.sender], "Not authorized AI agent");
        require(
            docIds.length == fileHashes.length &&
                docIds.length == operations.length,
            "Array length mismatch"
        );
        require(docIds.length > 0 && docIds.length <= 10, "Invalid batch size");

        for (uint256 i = 0; i < docIds.length; i++) {
            require(
                _recordsV2[docIds[i]].timestamp == 0,
                "Document already exists"
            );

            _recordsV2[docIds[i]] = NotarizationRecordV2({
                documentId: docIds[i],
                fileHash: fileHashes[i],
                owner: msg.sender,
                timestamp: block.timestamp,
                operation: operations[i],
                aiAgent: msg.sender
            });

            _documentIds.push(docIds[i]);
            totalRecords++;

            emit DocumentNotarized(
                docIds[i],
                fileHashes[i],
                msg.sender,
                block.timestamp,
                operations[i],
                msg.sender
            );
        }

        emit BatchNotarized(docIds.length, msg.sender, block.timestamp);
    }

    // =====================================================
    // V2查询功能
    // =====================================================

    /**
     * @dev 查询V2存证记录
     */
    function getRecordV2(
        string memory _documentId
    )
        external
        view
        returns (
            string memory,
            bytes32,
            address,
            uint256,
            string memory,
            address
        )
    {
        require(_recordsV2[_documentId].timestamp > 0, "Document not found");

        NotarizationRecordV2 memory record = _recordsV2[_documentId];
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
     * @dev 继承V1的查询功能
     */
    function getRecord(
        string memory _documentId
    )
        external
        view
        returns (
            string memory,
            bytes32,
            address,
            uint256,
            string memory
        )
    {
        require(_records[_documentId].timestamp > 0, "Document not found");

        NotarizationRecord memory record = _records[_documentId];
        return (
            record.documentId,
            record.fileHash,
            record.owner,
            record.timestamp,
            record.operation
        );
    }

    /**
     * @dev 验证所有者
     */
    function verifyOwner(
        string memory _documentId,
        address _address
    ) external view returns (bool) {
        if (_recordsV2[_documentId].timestamp > 0) {
            return _recordsV2[_documentId].owner == _address;
        }
        require(_records[_documentId].timestamp > 0, "Document not found");
        return _records[_documentId].owner == _address;
    }

    /**
     * @dev 获取所有文档ID
     */
    function getAllDocumentIds() external view returns (string[] memory) {
        return _documentIds;
    }

    /**
     * @dev 获取AI代理列表
     */
    function getAllAIAgents() external view returns (address[] memory) {
        return _aiAgentList;
    }
}
