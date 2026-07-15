// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title RWAToken - 现实世界资产代币
 * @notice 基于 ERC-20 标准的资产代币，内置白名单合规机制
 * @dev 集成 Compliance 合约进行转账合规检查
 */
contract RWAToken {
    // =====================================================
    // ERC-20 标准状态变量
    // =====================================================

    string public name;
    string public symbol;
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // =====================================================
    // RWA 扩展状态变量
    // =====================================================

    /// @notice 合约管理员
    address public admin;

    /// @notice 合规合约地址
    address public complianceContract;

    /// @notice 资产类型（如：房地产、股权、债券）
    string public assetType;

    /// @notice 资产估值（美元，精度18位）
    uint256 public assetValue;

    /// @notice SPV 地址（特殊目的载体）
    address public spvAddress;

    /// @notice 白名单映射
    mapping(address => bool) public whitelisted;

    /// @notice 合约是否暂停
    bool public paused;

    /// @notice 是否启用合规检查（转账时调用Compliance合约）
    bool public complianceCheckEnabled;

    /// @notice 累计铸造量
    uint256 public totalMinted;

    /// @notice 累计销毁量
    uint256 public totalBurned;

    /// @notice 白名单地址数量
    uint256 public whitelistedCount;

    // =====================================================
    // 事件
    // =====================================================

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event WhitelistUpdated(address indexed account, bool status);
    event AssetValueUpdated(uint256 oldValue, uint256 newValue);
    event ComplianceUpdated(address indexed oldCompliance, address indexed newCompliance);
    event ComplianceCheckToggled(bool enabled);
    event Paused(address account);
    event Unpaused(address account);
    event AdminTransferred(address indexed oldAdmin, address indexed newAdmin);
    event TokensMinted(address indexed to, uint256 amount);
    event TokensBurned(address indexed from, uint256 amount);

    // =====================================================
    // 修饰器
    // =====================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "RWAToken: caller is not admin");
        _;
    }

    modifier onlyWhitelisted() {
        require(whitelisted[msg.sender], "RWAToken: sender not whitelisted");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "RWAToken: contract is paused");
        _;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    /**
     * @dev 构造函数
     * @param _name 代币名称
     * @param _symbol 代币符号
     * @param _assetType 资产类型
     * @param _assetValue 资产估值（wei）
     * @param _spvAddress SPV地址
     */
    constructor(
        string memory _name,
        string memory _symbol,
        string memory _assetType,
        uint256 _assetValue,
        address _spvAddress
    ) {
        name = _name;
        symbol = _symbol;
        assetType = _assetType;
        assetValue = _assetValue;
        spvAddress = _spvAddress;
        admin = msg.sender;
        whitelisted[msg.sender] = true;
        whitelistedCount = 1;
    }

    // =====================================================
    // ERC-20 标准函数
    // =====================================================

    /**
     * @dev 查询余额
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev 转账函数
     */
    function transfer(address to, uint256 amount) public whenNotPaused returns (bool) {
        require(whitelisted[msg.sender], "RWAToken: sender not whitelisted");
        require(whitelisted[to], "RWAToken: recipient not whitelisted");
        require(_balances[msg.sender] >= amount, "RWAToken: insufficient balance");

        // 合规检查
        if (complianceCheckEnabled && complianceContract != address(0)) {
            _checkCompliance(msg.sender, to, amount);
        }

        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    /**
     * @dev 授权额度
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _allowances[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    /**
     * @dev 查询授权额度
     */
    function allowance(address owner_, address spender) public view returns (uint256) {
        return _allowances[owner_][spender];
    }

    /**
     * @dev 代理转账
     */
    function transferFrom(address from, address to, uint256 amount) public whenNotPaused returns (bool) {
        require(whitelisted[from], "RWAToken: sender not whitelisted");
        require(whitelisted[to], "RWAToken: recipient not whitelisted");
        require(_balances[from] >= amount, "RWAToken: insufficient balance");
        require(_allowances[from][msg.sender] >= amount, "RWAToken: insufficient allowance");

        // 合规检查
        if (complianceCheckEnabled && complianceContract != address(0)) {
            _checkCompliance(from, to, amount);
        }

        _balances[from] -= amount;
        _balances[to] += amount;
        _allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    // =====================================================
    // RWA 管理函数
    // =====================================================

    /**
     * @dev 铸造代币（仅管理员）
     */
    function mint(address to, uint256 amount) public onlyAdmin {
        require(whitelisted[to], "RWAToken: recipient not whitelisted");
        require(to != address(0), "RWAToken: mint to zero address");

        totalSupply += amount;
        _balances[to] += amount;
        totalMinted += amount;

        emit Transfer(address(0), to, amount);
        emit TokensMinted(to, amount);
    }

    /**
     * @dev 批量铸造代币
     */
    function batchMint(address[] memory recipients, uint256[] memory amounts) public onlyAdmin {
        require(recipients.length == amounts.length, "RWAToken: array length mismatch");

        for (uint256 i = 0; i < recipients.length; i++) {
            require(whitelisted[recipients[i]], "RWAToken: recipient not whitelisted");
            require(recipients[i] != address(0), "RWAToken: mint to zero address");

            totalSupply += amounts[i];
            _balances[recipients[i]] += amounts[i];
            totalMinted += amounts[i];

            emit Transfer(address(0), recipients[i], amounts[i]);
            emit TokensMinted(recipients[i], amounts[i]);
        }
    }

    /**
     * @dev 销毁代币
     */
    function burn(uint256 amount) public {
        require(_balances[msg.sender] >= amount, "RWAToken: insufficient balance");

        _balances[msg.sender] -= amount;
        totalSupply -= amount;
        totalBurned += amount;

        emit Transfer(msg.sender, address(0), amount);
        emit TokensBurned(msg.sender, amount);
    }

    /**
     * @dev 更新白名单状态（仅管理员）
     */
    function updateWhitelist(address account, bool status) public onlyAdmin {
        require(account != address(0), "RWAToken: zero address");
        bool wasWhitelisted = whitelisted[account];
        whitelisted[account] = status;

        if (status && !wasWhitelisted) {
            whitelistedCount++;
        } else if (!status && wasWhitelisted) {
            whitelistedCount--;
        }

        emit WhitelistUpdated(account, status);
    }

    /**
     * @dev 批量更新白名单
     */
    function batchUpdateWhitelist(address[] memory accounts, bool[] memory statuses) public onlyAdmin {
        require(accounts.length == statuses.length, "RWAToken: array length mismatch");
        for (uint256 i = 0; i < accounts.length; i++) {
            require(accounts[i] != address(0), "RWAToken: zero address");
            bool wasWhitelisted = whitelisted[accounts[i]];
            whitelisted[accounts[i]] = statuses[i];

            if (statuses[i] && !wasWhitelisted) {
                whitelistedCount++;
            } else if (!statuses[i] && wasWhitelisted) {
                whitelistedCount--;
            }

            emit WhitelistUpdated(accounts[i], statuses[i]);
        }
    }

    /**
     * @dev 更新资产估值（仅管理员）
     */
    function updateAssetValue(uint256 newValue) public onlyAdmin {
        uint256 oldValue = assetValue;
        assetValue = newValue;
        emit AssetValueUpdated(oldValue, newValue);
    }

    /**
     * @dev 更新合规合约地址（仅管理员）
     */
    function setComplianceContract(address newCompliance) public onlyAdmin {
        address oldCompliance = complianceContract;
        complianceContract = newCompliance;
        emit ComplianceUpdated(oldCompliance, newCompliance);
    }

    /**
     * @dev 切换合规检查开关
     */
    function toggleComplianceCheck(bool enabled) public onlyAdmin {
        complianceCheckEnabled = enabled;
        emit ComplianceCheckToggled(enabled);
    }

    /**
     * @dev 暂停合约（仅管理员）
     */
    function pause() public onlyAdmin {
        paused = true;
        emit Paused(msg.sender);
    }

    /**
     * @dev 恢复合约（仅管理员）
     */
    function unpause() public onlyAdmin {
        paused = false;
        emit Unpaused(msg.sender);
    }

    /**
     * @dev 转移管理员权限
     */
    function transferAdmin(address newAdmin) public onlyAdmin {
        require(newAdmin != address(0), "RWAToken: zero address");
        address oldAdmin = admin;
        admin = newAdmin;
        emit AdminTransferred(oldAdmin, newAdmin);
    }

    /**
     * @dev 更新 SPV 地址
     */
    function setSPVAddress(address newSPV) public onlyAdmin {
        require(newSPV != address(0), "RWAToken: zero address");
        spvAddress = newSPV;
    }

    // =====================================================
    // 查询函数
    // =====================================================

    /**
     * @dev 查询代币单价（基于估值和供应量）
     */
    function getTokenPrice() public view returns (uint256) {
        if (totalSupply == 0) return 0;
        return (assetValue * 1e18) / totalSupply;
    }

    /**
     * @dev 获取代币信息摘要
     */
    function getTokenInfo() public view returns (
        string memory _name,
        string memory _symbol,
        string memory _assetType,
        uint256 _assetValue,
        uint256 _totalSupply,
        uint256 _tokenPrice,
        uint256 _whitelistedCount
    ) {
        uint256 price = totalSupply > 0 ? (assetValue * 1e18) / totalSupply : 0;
        return (name, symbol, assetType, assetValue, totalSupply, price, whitelistedCount);
    }

    // =====================================================
    // 内部函数
    // =====================================================

    /**
     * @dev 调用合规合约检查转账
     */
    function _checkCompliance(address from, address to, uint256 amount) internal view {
        (bool success, bytes memory data) = complianceContract.staticcall(
            abi.encodeWithSignature("checkTransfer(address,address,uint256)", from, to, amount)
        );
        if (success) {
            (bool compliant, string memory reason) = abi.decode(data, (bool, string));
            require(compliant, string(abi.encodePacked("RWAToken: compliance failed - ", reason)));
        }
        // 如果合规合约调用失败，不阻止转账（降级模式）
    }
}
