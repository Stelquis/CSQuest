// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title AssetRegistry - 资产登记层
 * @notice 对应设计要求 4.2.1：支持房地产/股权/债券/大宗商品多类资产登记，
 *         管理独立 SPV（特殊目的载体）实现资产风险隔离，并支持信息披露
 */
contract AssetRegistry {
    // =====================================================
    // 数据结构
    // =====================================================

    /// @dev 资产类型枚举
    enum AssetCategory { RealEstate, Equity, Bond, Commodity }

    /// @dev 资产登记记录
    struct AssetRecord {
        uint256 assetId;
        string name;              // 资产名称
        AssetCategory category;   // 资产类型
        uint256 totalValue;       // 资产总估值（精度18）
        uint256 tokenizedAmount;  // 已代币化金额
        address spvAddress;       // SPV 特殊目的载体地址（风险隔离）
        address tokenAddress;     // 对应的代币合约地址
        address issuer;           // 发行方
        uint256 registeredAt;     // 登记时间
        bool isActive;            // 是否活跃
        string legalDocHash;      // 法律文件哈希（确权凭证）
    }

    /// @dev 信息披露记录
    struct Disclosure {
        uint256 disclosureId;
        uint256 assetId;
        string title;             // 披露标题
        string contentHash;       // 内容哈希（链下存储内容，链上存哈希）
        uint256 publishedAt;
        bool active;
    }

    // =====================================================
    // 状态变量
    // =====================================================

    /// @notice 合约管理员
    address public admin;

    /// @notice 资产记录映射
    mapping(uint256 => AssetRecord) public assets;

    /// @notice 资产总数
    uint256 public assetCount;

    /// @notice SPV -> 关联资产ID列表（每个SPV对应独立资产，实现风险隔离）
    mapping(address => uint256[]) public spvAssets;

    /// @notice 披露记录映射
    mapping(uint256 => Disclosure) public disclosures;

    /// @notice 披露总数
    uint256 public disclosureCount;

    /// @notice 资产 -> 披露ID列表
    mapping(uint256 => uint256[]) public assetDisclosures;

    // =====================================================
    // 事件
    // =====================================================

    event AssetRegistered(uint256 indexed assetId, string name, AssetCategory category, address spvAddress, address tokenAddress);
    event AssetUpdated(uint256 indexed assetId, uint256 newValue);
    event AssetDeactivated(uint256 indexed assetId);
    event DisclosurePublished(uint256 indexed disclosureId, uint256 indexed assetId, string title);
    event SPVRegistered(address indexed spvAddress, uint256 assetId);

    // =====================================================
    // 修饰器
    // =====================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "AssetRegistry: caller is not admin");
        _;
    }

    modifier assetExists(uint256 assetId) {
        require(assetId < assetCount, "AssetRegistry: asset not found");
        _;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    constructor() {
        admin = msg.sender;
    }

    // =====================================================
    // 资产登记功能
    // =====================================================

    /**
     * @dev 登记新资产（每个资产绑定独立 SPV 实现风险隔离）
     * @param name 资产名称
     * @param category 资产类型 (0=房地产, 1=股权, 2=债券, 3=大宗商品)
     * @param totalValue 资产总估值
     * @param spvAddress SPV 地址（独立载体，隔离风险）
     * @param tokenAddress 对应代币合约地址
     * @param legalDocHash 法律文件哈希（资产确权凭证）
     */
    function registerAsset(
        string memory name,
        AssetCategory category,
        uint256 totalValue,
        address spvAddress,
        address tokenAddress,
        string memory legalDocHash
    ) public onlyAdmin returns (uint256) {
        require(bytes(name).length > 0, "AssetRegistry: empty name");
        require(totalValue > 0, "AssetRegistry: zero value");
        require(spvAddress != address(0), "AssetRegistry: zero SPV");

        uint256 assetId = assetCount;

        assets[assetId] = AssetRecord({
            assetId: assetId,
            name: name,
            category: category,
            totalValue: totalValue,
            tokenizedAmount: 0,
            spvAddress: spvAddress,
            tokenAddress: tokenAddress,
            issuer: msg.sender,
            registeredAt: block.timestamp,
            isActive: true,
            legalDocHash: legalDocHash
        });

        spvAssets[spvAddress].push(assetId);
        assetCount++;

        emit AssetRegistered(assetId, name, category, spvAddress, tokenAddress);
        emit SPVRegistered(spvAddress, assetId);
        return assetId;
    }

    /**
     * @dev 更新资产代币化金额（发行代币时调用）
     */
    function updateTokenizedAmount(uint256 assetId, uint256 amount) public onlyAdmin assetExists(assetId) {
        assets[assetId].tokenizedAmount += amount;
        require(assets[assetId].tokenizedAmount <= assets[assetId].totalValue, "AssetRegistry: exceeds total value");
        emit AssetUpdated(assetId, assets[assetId].totalValue);
    }

    /**
     * @dev 更新资产估值
     */
    function updateAssetValue(uint256 assetId, uint256 newValue) public onlyAdmin assetExists(assetId) {
        require(newValue > 0, "AssetRegistry: zero value");
        assets[assetId].totalValue = newValue;
        emit AssetUpdated(assetId, newValue);
    }

    /**
     * @dev 停用资产
     */
    function deactivateAsset(uint256 assetId) public onlyAdmin assetExists(assetId) {
        assets[assetId].isActive = false;
        emit AssetDeactivated(assetId);
    }

    // =====================================================
    // 信息披露功能（对应设计要求 4.2.2 信息披露）
    // =====================================================

    /**
     * @dev 发布信息披露（定期向投资者披露资产运营/收益/风险情况）
     * @param assetId 资产ID
     * @param title 披露标题
     * @param contentHash 内容哈希（链下内容上链凭证）
     */
    function publishDisclosure(
        uint256 assetId,
        string memory title,
        string memory contentHash
    ) public onlyAdmin assetExists(assetId) returns (uint256) {
        require(bytes(title).length > 0, "AssetRegistry: empty title");

        uint256 disclosureId = disclosureCount;

        disclosures[disclosureId] = Disclosure({
            disclosureId: disclosureId,
            assetId: assetId,
            title: title,
            contentHash: contentHash,
            publishedAt: block.timestamp,
            active: true
        });

        assetDisclosures[assetId].push(disclosureId);
        disclosureCount++;

        emit DisclosurePublished(disclosureId, assetId, title);
        return disclosureId;
    }

    // =====================================================
    // 查询功能
    // =====================================================

    /**
     * @dev 获取资产详情
     */
    function getAsset(uint256 assetId) public view assetExists(assetId) returns (AssetRecord memory) {
        return assets[assetId];
    }

    /**
     * @dev 获取 SPV 关联的所有资产ID（验证风险隔离）
     */
    function getSPVAssets(address spvAddress) public view returns (uint256[] memory) {
        return spvAssets[spvAddress];
    }

    /**
     * @dev 获取资产的所有披露记录ID
     */
    function getAssetDisclosures(uint256 assetId) public view assetExists(assetId) returns (uint256[] memory) {
        return assetDisclosures[assetId];
    }

    /**
     * @dev 获取披露详情
     */
    function getDisclosure(uint256 disclosureId) public view returns (Disclosure memory) {
        require(disclosureId < disclosureCount, "AssetRegistry: disclosure not found");
        return disclosures[disclosureId];
    }

    /**
     * @dev 获取资产分类名称
     */
    function getCategoryName(AssetCategory category) public pure returns (string memory) {
        if (category == AssetCategory.RealEstate) return unicode"房地产";
        if (category == AssetCategory.Equity) return unicode"股权";
        if (category == AssetCategory.Bond) return unicode"债券";
        if (category == AssetCategory.Commodity) return unicode"大宗商品";
        return unicode"未知";
    }

    /**
     * @dev 获取资产代币化率（已代币化/总估值）
     */
    function getTokenizationRate(uint256 assetId) public view assetExists(assetId) returns (uint256) {
        if (assets[assetId].totalValue == 0) return 0;
        return (assets[assetId].tokenizedAmount * 10000) / assets[assetId].totalValue;
    }
}
