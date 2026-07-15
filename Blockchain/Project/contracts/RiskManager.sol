// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title RiskManager - 风险管理合约
 * @notice 实现抵押率监控、清算机制、风险预警等风险管理功能
 */
contract RiskManager {
    // =====================================================
    // 数据结构
    // =====================================================

    /**
     * @dev 抵押仓位结构体
     */
    struct Position {
        address owner;           // 仓位所有者
        address collateralToken; // 抵押代币地址
        address borrowToken;     // 借入代币地址
        uint256 collateralAmount; // 抵押数量
        uint256 borrowAmount;     // 借入数量
        uint256 createdAt;        // 创建时间
        bool isActive;            // 是否活跃
    }

    /**
     * @dev 风险参数结构体
     */
    struct RiskParams {
        uint256 minCollateralRatio;  // 最低抵押率（百分比，如150表示150%）
        uint256 liquidationThreshold; // 清算阈值（百分比）
        uint256 liquidationPenalty;   // 清算罚金（百分比）
        uint256 maxLeverage;          // 最大杠杆倍数
    }

    // =====================================================
    // 状态变量
    // =====================================================

    /// @notice 合约管理员
    address public admin;

    /// @notice 关联的合规合约
    address public complianceContract;

    /// @notice 抵押仓位映射
    mapping(uint256 => Position) public positions;

    /// @notice 仓位计数器
    uint256 public positionCount;

    /// @notice 用户仓位列表
    mapping(address => uint256[]) public userPositions;

    /// @notice 风险参数
    RiskParams public riskParams;

    /// @notice 系统总抵押价值
    uint256 public totalCollateralValue;

    /// @notice 系统总借入价值
    uint256 public totalBorrowValue;

    /// @notice 清算事件计数
    uint256 public liquidationCount;

    // =====================================================
    // 事件
    // =====================================================

    event PositionCreated(uint256 indexed positionId, address indexed owner, uint256 collateralAmount, uint256 borrowAmount);
    event PositionClosed(uint256 indexed positionId, address indexed owner);
    event Liquidated(uint256 indexed positionId, address indexed liquidator, uint256 collateralSeized, uint256 debtRepaid);
    event RiskWarning(uint256 indexed positionId, address indexed owner, uint256 currentRatio, uint256 minRatio);
    event RiskParamsUpdated(uint256 minCollateralRatio, uint256 liquidationThreshold);
    event CollateralAdded(uint256 indexed positionId, uint256 amount);
    event DebtRepaid(uint256 indexed positionId, uint256 amount);

    // =====================================================
    // 修饰器
    // =====================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "RiskManager: caller is not admin");
        _;
    }

    modifier positionExists(uint256 positionId) {
        require(positionId < positionCount, "RiskManager: position not found");
        _;
    }

    modifier positionActive(uint256 positionId) {
        require(positions[positionId].isActive, "RiskManager: position not active");
        _;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    constructor(address _complianceContract) {
        admin = msg.sender;
        complianceContract = _complianceContract;

        // 默认风险参数
        riskParams = RiskParams({
            minCollateralRatio: 150,    // 150% 最低抵押率
            liquidationThreshold: 120,  // 120% 触发清算
            liquidationPenalty: 10,     // 10% 清算罚金
            maxLeverage: 3              // 最大3倍杠杆
        });
    }

    // =====================================================
    // 仓位管理
    // =====================================================

    /**
     * @dev 创建抵押仓位
     * @param collateralToken 抵押代币地址
     * @param borrowToken 借入代币地址
     * @param collateralAmount 抵押数量
     * @param borrowAmount 借入数量
     */
    function createPosition(
        address collateralToken,
        address borrowToken,
        uint256 collateralAmount,
        uint256 borrowAmount
    ) public returns (uint256) {
        require(collateralAmount > 0, "RiskManager: zero collateral");
        require(borrowAmount > 0, "RiskManager: zero borrow");
        require(collateralToken != address(0), "RiskManager: zero collateral token");
        require(borrowToken != address(0), "RiskManager: zero borrow token");

        // 检查抵押率
        uint256 ratio = (collateralAmount * 100) / borrowAmount;
        require(ratio >= riskParams.minCollateralRatio, "RiskManager: insufficient collateral ratio");

        uint256 positionId = positionCount;

        positions[positionId] = Position({
            owner: msg.sender,
            collateralToken: collateralToken,
            borrowToken: borrowToken,
            collateralAmount: collateralAmount,
            borrowAmount: borrowAmount,
            createdAt: block.timestamp,
            isActive: true
        });

        userPositions[msg.sender].push(positionId);
        positionCount++;

        totalCollateralValue += collateralAmount;
        totalBorrowValue += borrowAmount;

        emit PositionCreated(positionId, msg.sender, collateralAmount, borrowAmount);

        return positionId;
    }

    /**
     * @dev 关闭仓位（归还借款，取回抵押）
     * @param positionId 仓位ID
     */
    function closePosition(uint256 positionId) public positionExists(positionId) positionActive(positionId) {
        Position storage pos = positions[positionId];
        require(pos.owner == msg.sender, "RiskManager: not owner");

        totalCollateralValue -= pos.collateralAmount;
        totalBorrowValue -= pos.borrowAmount;

        pos.isActive = false;

        emit PositionClosed(positionId, msg.sender);
    }

    /**
     * @dev 增加抵押物
     * @param positionId 仓位ID
     * @param amount 增加数量
     */
    function addCollateral(uint256 positionId, uint256 amount) public positionExists(positionId) positionActive(positionId) {
        Position storage pos = positions[positionId];
        require(pos.owner == msg.sender, "RiskManager: not owner");
        require(amount > 0, "RiskManager: zero amount");

        pos.collateralAmount += amount;
        totalCollateralValue += amount;

        emit CollateralAdded(positionId, amount);
    }

    /**
     * @dev 归还借款
     * @param positionId 仓位ID
     * @param amount 归还数量
     */
    function repayDebt(uint256 positionId, uint256 amount) public positionExists(positionId) positionActive(positionId) {
        Position storage pos = positions[positionId];
        require(pos.owner == msg.sender, "RiskManager: not owner");
        require(amount > 0 && amount <= pos.borrowAmount, "RiskManager: invalid amount");

        pos.borrowAmount -= amount;
        totalBorrowValue -= amount;

        emit DebtRepaid(positionId, amount);
    }

    // =====================================================
    // 清算功能
    // =====================================================

    /**
     * @dev 清算不健康仓位
     * @param positionId 仓位ID
     */
    function liquidate(uint256 positionId) public positionExists(positionId) positionActive(positionId) {
        Position storage pos = positions[positionId];

        uint256 currentRatio = getCollateralRatio(positionId);
        require(currentRatio < riskParams.liquidationThreshold, "RiskManager: position is healthy");

        // 计算清算罚金
        uint256 penalty = (pos.collateralAmount * riskParams.liquidationPenalty) / 100;
        uint256 collateralSeized = pos.borrowAmount + penalty;

        // 确保不超过抵押总量
        if (collateralSeized > pos.collateralAmount) {
            collateralSeized = pos.collateralAmount;
        }

        totalCollateralValue -= pos.collateralAmount;
        totalBorrowValue -= pos.borrowAmount;

        pos.isActive = false;
        liquidationCount++;

        emit Liquidated(positionId, msg.sender, collateralSeized, pos.borrowAmount);
    }

    // =====================================================
    // 查询功能
    // =====================================================

    /**
     * @dev 计算抵押率
     * @param positionId 仓位ID
     * @return 抵押率（百分比）
     */
    function getCollateralRatio(uint256 positionId) public view returns (uint256) {
        Position memory pos = positions[positionId];
        if (pos.borrowAmount == 0) return type(uint256).max;
        return (pos.collateralAmount * 100) / pos.borrowAmount;
    }

    /**
     * @dev 检查仓位是否健康
     * @param positionId 仓位ID
     * @return 是否健康
     */
    function isPositionHealthy(uint256 positionId) public view returns (bool) {
        return getCollateralRatio(positionId) >= riskParams.minCollateralRatio;
    }

    /**
     * @dev 检查仓位是否可清算
     * @param positionId 仓位ID
     * @return 是否可清算
     */
    function isLiquidatable(uint256 positionId) public view returns (bool) {
        return getCollateralRatio(positionId) < riskParams.liquidationThreshold;
    }

    /**
     * @dev 获取用户所有仓位ID
     * @param user 用户地址
     * @return 仓位ID数组
     */
    function getUserPositions(address user) public view returns (uint256[] memory) {
        return userPositions[user];
    }

    /**
     * @dev 获取系统风险统计
     */
    function getSystemRiskStats() public view returns (
        uint256 _positionCount,
        uint256 _totalCollateral,
        uint256 _totalBorrow,
        uint256 _systemCollateralRatio,
        uint256 _liquidationCount
    ) {
        uint256 systemRatio = totalBorrowValue > 0 ? (totalCollateralValue * 100) / totalBorrowValue : type(uint256).max;
        return (positionCount, totalCollateralValue, totalBorrowValue, systemRatio, liquidationCount);
    }

    /**
     * @dev 检测所有仓位的健康状态，返回不健康的仓位ID
     * @return unhealthyPositions 不健康仓位ID数组
     */
    function detectUnhealthyPositions() public view returns (uint256[] memory) {
        uint256 unhealthyCount = 0;
        for (uint256 i = 0; i < positionCount; i++) {
            if (positions[i].isActive && !isPositionHealthy(i)) {
                unhealthyCount++;
            }
        }

        uint256[] memory unhealthyPositions = new uint256[](unhealthyCount);
        uint256 idx = 0;
        for (uint256 i = 0; i < positionCount; i++) {
            if (positions[i].isActive && !isPositionHealthy(i)) {
                unhealthyPositions[idx] = i;
                idx++;
            }
        }
        return unhealthyPositions;
    }

    // =====================================================
    // 管理功能
    // =====================================================

    /**
     * @dev 更新风险参数
     */
    function updateRiskParams(
        uint256 _minCollateralRatio,
        uint256 _liquidationThreshold,
        uint256 _liquidationPenalty,
        uint256 _maxLeverage
    ) public onlyAdmin {
        require(_minCollateralRatio >= 100, "RiskManager: ratio too low");
        require(_liquidationThreshold < _minCollateralRatio, "RiskManager: threshold >= ratio");
        require(_liquidationPenalty <= 50, "RiskManager: penalty too high");
        require(_maxLeverage >= 1, "RiskManager: invalid leverage");

        riskParams.minCollateralRatio = _minCollateralRatio;
        riskParams.liquidationThreshold = _liquidationThreshold;
        riskParams.liquidationPenalty = _liquidationPenalty;
        riskParams.maxLeverage = _maxLeverage;

        emit RiskParamsUpdated(_minCollateralRatio, _liquidationThreshold);
    }

    /**
     * @dev 设置合规合约
     */
    function setComplianceContract(address _complianceContract) public onlyAdmin {
        complianceContract = _complianceContract;
    }

    // =====================================================
    // 压力测试功能（对应设计要求 4.4 压力测试）
    // =====================================================

    /// @dev 压力测试场景
    struct StressScenario {
        uint256 scenarioId;
        string name;              // 场景名称（如：极端下跌、流动性枯竭）
        uint256 priceDropPercent; // 资产价格下跌幅度（基点，如3000=30%）
        uint256 liquidationRatio; // 预期清算比例（基点）
        uint256 testedAt;         // 测试时间
        uint256 affectedPositions;// 受影响仓位数
        bool passed;              // 是否通过（系统是否稳定）
        string reportHash;        // 测试报告哈希
    }

    mapping(uint256 => StressScenario) public stressScenarios;
    uint256 public stressScenarioCount;

    /// @notice 系统安全阈值（压力测试通过的最低抵押率）
    uint256 public systemSafetyThreshold = 130;

    event StressTestExecuted(uint256 indexed scenarioId, string name, uint256 affectedPositions, bool passed);
    event SafetyThresholdUpdated(uint256 newThreshold);

    /**
     * @dev 设置系统安全阈值
     */
    function setSafetyThreshold(uint256 _threshold) public onlyAdmin {
        require(_threshold >= 100, "RiskManager: threshold too low");
        systemSafetyThreshold = _threshold;
        emit SafetyThresholdUpdated(_threshold);
    }

    /**
     * @dev 执行压力测试（模拟极端市场条件，测试系统稳定性和抗风险能力）
     * @param name 场景名称
     * @param priceDropPercent 价格下跌幅度（基点）
     * @param reportHash 测试报告哈希
     */
    function runStressTest(
        string memory name,
        uint256 priceDropPercent,
        string memory reportHash
    ) public onlyAdmin returns (uint256) {
        require(priceDropPercent <= 10000, "RiskManager: invalid drop");
        require(bytes(name).length > 0, "RiskManager: empty name");

        uint256 scenarioId = stressScenarioCount;
        uint256 affected = 0;
        bool passed = true;

        // 模拟价格下跌对各仓位的影响
        for (uint256 i = 0; i < positionCount; i++) {
            if (!positions[i].isActive) continue;

            // 模拟下跌后的抵押率
            uint256 simulatedCollateral = (positions[i].collateralAmount * (10000 - priceDropPercent)) / 10000;
            uint256 simulatedRatio = positions[i].borrowAmount > 0
                ? (simulatedCollateral * 100) / positions[i].borrowAmount
                : type(uint256).max;

            if (simulatedRatio < riskParams.liquidationThreshold) {
                affected++;
            }
            // 若系统整体抵押率低于安全阈值，则未通过
            if (simulatedRatio < systemSafetyThreshold) {
                passed = false;
            }
        }

        uint256 expectedLiquidationRatio = totalBorrowValue > 0
            ? (totalCollateralValue * (10000 - priceDropPercent) * 100) / (totalBorrowValue * 10000)
            : type(uint256).max;

        stressScenarios[scenarioId] = StressScenario({
            scenarioId: scenarioId,
            name: name,
            priceDropPercent: priceDropPercent,
            liquidationRatio: expectedLiquidationRatio,
            testedAt: block.timestamp,
            affectedPositions: affected,
            passed: passed,
            reportHash: reportHash
        });

        stressScenarioCount++;
        emit StressTestExecuted(scenarioId, name, affected, passed);
        return scenarioId;
    }

    /**
     * @dev 获取压力测试场景
     */
    function getStressScenario(uint256 scenarioId) public view returns (StressScenario memory) {
        require(scenarioId < stressScenarioCount, "RiskManager: not found");
        return stressScenarios[scenarioId];
    }

    /**
     * @dev 获取所有压力测试场景ID
     */
    function getStressScenarioCount() public view returns (uint256) {
        return stressScenarioCount;
    }

    // =====================================================
    // 保险集成接口（对应设计要求 4.4 保险集成）
    // =====================================================

    /// @notice 关联的保险合约地址
    address public insuranceContract;

    /// @notice 仓位是否已投保
    mapping(uint256 => bool) public positionInsured;

    /// @notice 仓位 -> 保单ID
    mapping(uint256 => uint256) public positionPolicyId;

    event InsuranceContractUpdated(address indexed insurance);
    event PositionInsured(uint256 indexed positionId, uint256 policyId);

    /**
     * @dev 设置保险合约地址
     */
    function setInsuranceContract(address _insurance) public onlyAdmin {
        require(_insurance != address(0), "RiskManager: zero address");
        insuranceContract = _insurance;
        emit InsuranceContractUpdated(_insurance);
    }

    /**
     * @dev 为仓位绑定保单（与去中心化保险协议对接，降低投资者风险）
     * @param positionId 仓位ID
     * @param policyId 保单ID
     */
    function bindInsurance(uint256 positionId, uint256 policyId) public onlyAdmin positionExists(positionId) {
        positionInsured[positionId] = true;
        positionPolicyId[positionId] = policyId;
        emit PositionInsured(positionId, policyId);
    }

    /**
     * @dev 查询仓位保险状态
     */
    function getPositionInsurance(uint256 positionId) public view returns (bool insured, uint256 policyId) {
        return (positionInsured[positionId], positionPolicyId[positionId]);
    }

    /**
     * @dev 清算并触发保险理赔（资产违约或抵押不足时，自动处置并申请保险赔付）
     */
    function liquidateWithInsurance(uint256 positionId) public positionExists(positionId) positionActive(positionId) {
        // 先执行标准清算
        liquidate(positionId);

        // 若已投保，标记触发保险理赔（实际理赔由 Insurance 合约处理）
        if (positionInsured[positionId]) {
            // 清算事件已由 liquidate 触发，保险理赔通过事件通知
            emit PositionInsured(positionId, positionPolicyId[positionId]);
        }
    }
}
