// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

/**
 * @title Valuation - 动态估值系统
 * @notice 对应设计要求 4.3.2：实现四种资产估值方法
 *         现金流折现、可比公司法、成本法、市场法，综合得出资产代币合理估值
 */
contract Valuation {
    // =====================================================
    // 数据结构
    // =====================================================

    /// @dev 估值方法枚举
    enum Method { DiscountedCashFlow, ComparableCompany, Cost, Market }

    /// @dev 估值记录
    struct ValuationRecord {
        uint256 valuationId;
        uint256 assetId;        // 关联资产
        Method method;          // 估值方法
        uint256 estimatedValue; // 估算价值（精度18）
        uint256 timestamp;      // 估值时间
        string paramsHash;      // 估值参数哈希（链下详细参数上链凭证）
        address appraiser;      // 评估人
        bool verified;          // 是否验证
    }

    /// @dev 现金流折现参数
    struct DCFParams {
        uint256[] cashFlows;    // 未来各期现金流
        uint256 discountRate;   // 折现率（基点，如500=5%）
        uint256 periods;        // 期数
    }

    /// @dev 可比公司参数
    struct ComparableParams {
        uint256 comparableValue;// 可比资产价值
        uint256 adjustmentRate; // 调整率（基点）
    }

    // =====================================================
    // 状态变量
    // =====================================================

    address public admin;

    mapping(uint256 => ValuationRecord) public valuations;
    uint256 public valuationCount;

    /// @notice 资产 -> 估值记录列表
    mapping(uint256 => uint256[]) public assetValuations;

    /// @notice 资产最新综合估值
    mapping(uint256 => uint256) public latestCompositeValue;

    // =====================================================
    // 事件
    // =====================================================

    event ValuationRecorded(uint256 indexed valuationId, uint256 indexed assetId, Method method, uint256 estimatedValue);
    event ValuationVerified(uint256 indexed valuationId);
    event CompositeValueUpdated(uint256 indexed assetId, uint256 newValue);

    // =====================================================
    // 修饰器
    // =====================================================

    modifier onlyAdmin() {
        require(msg.sender == admin, "Valuation: not admin");
        _;
    }

    // =====================================================
    // 构造函数
    // =====================================================

    constructor() {
        admin = msg.sender;
    }

    // =====================================================
    // 估值方法实现
    // =====================================================

    /**
     * @dev 方法一：现金流折现法（DCF）
     *      预测资产未来现金流（租金/股息/利息），通过折现率计算现值
     * @param assetId 资产ID
     * @param cashFlows 未来各期现金流数组
     * @param discountRate 折现率（基点，500=5%）
     * @param paramsHash 参数哈希
     */
    function valuationByDCF(
        uint256 assetId,
        uint256[] memory cashFlows,
        uint256 discountRate,
        string memory paramsHash
    ) public onlyAdmin returns (uint256) {
        require(cashFlows.length > 0, "Valuation: empty cashflows");
        require(discountRate > 0, "Valuation: zero discount rate");

        uint256 presentValue = _calculateDCF(cashFlows, discountRate);

        return _recordValuation(assetId, Method.DiscountedCashFlow, presentValue, paramsHash);
    }

    /**
     * @dev 方法二：可比公司法
     *      参考同类资产估值水平，调整参数计算合理价格
     * @param assetId 资产ID
     * @param comparableValue 可比资产价值
     * @param adjustmentRate 调整率（基点，可为负数用补码表示，这里用正数表示调整后比例）
     * @param paramsHash 参数哈希
     */
    function valuationByComparable(
        uint256 assetId,
        uint256 comparableValue,
        uint256 adjustmentRate,
        string memory paramsHash
    ) public onlyAdmin returns (uint256) {
        require(comparableValue > 0, "Valuation: zero comparable");

        // 调整后价值 = 可比价值 * (1 + 调整率/10000)
        uint256 estimatedValue = (comparableValue * (10000 + adjustmentRate)) / 10000;

        return _recordValuation(assetId, Method.ComparableCompany, estimatedValue, paramsHash);
    }

    /**
     * @dev 方法三：成本法
     *      基于资产重置成本，扣除折旧和损耗计算价值
     * @param assetId 资产ID
     * @param replacementCost 重置成本
     * @param depreciationRate 折旧率（基点，500=5%）
     * @param paramsHash 参数哈希
     */
    function valuationByCost(
        uint256 assetId,
        uint256 replacementCost,
        uint256 depreciationRate,
        string memory paramsHash
    ) public onlyAdmin returns (uint256) {
        require(replacementCost > 0, "Valuation: zero cost");
        require(depreciationRate <= 10000, "Valuation: depreciation too high");

        // 估值 = 重置成本 * (1 - 折旧率/10000)
        uint256 estimatedValue = (replacementCost * (10000 - depreciationRate)) / 10000;

        return _recordValuation(assetId, Method.Cost, estimatedValue, paramsHash);
    }

    /**
     * @dev 方法四：市场法
     *      参考近期类似资产交易价格，结合市场供需调整估值
     * @param assetId 资产ID
     * @param recentTradePrice 近期交易价格
     * @param marketAdjustFactor 市场调整因子（基点，10000=1倍）
     * @param paramsHash 参数哈希
     */
    function valuationByMarket(
        uint256 assetId,
        uint256 recentTradePrice,
        uint256 marketAdjustFactor,
        string memory paramsHash
    ) public onlyAdmin returns (uint256) {
        require(recentTradePrice > 0, "Valuation: zero price");

        // 估值 = 近期交易价格 * 市场调整因子/10000
        uint256 estimatedValue = (recentTradePrice * marketAdjustFactor) / 10000;

        return _recordValuation(assetId, Method.Market, estimatedValue, paramsHash);
    }

    /**
     * @dev 综合估值：对资产的多种估值结果加权平均，得出最终估值
     * @param assetId 资产ID
     * @param valuationIds 参与的估值记录ID
     * @param weights 各估值权重（基点）
     */
    function computeCompositeValue(
        uint256 assetId,
        uint256[] memory valuationIds,
        uint256[] memory weights
    ) public onlyAdmin returns (uint256) {
        require(valuationIds.length == weights.length, "Valuation: length mismatch");
        require(valuationIds.length > 0, "Valuation: empty");

        uint256 totalWeight = 0;
        uint256 weightedSum = 0;

        for (uint256 i = 0; i < valuationIds.length; i++) {
            require(valuationIds[i] < valuationCount, "Valuation: invalid id");
            require(valuations[valuationIds[i]].assetId == assetId, "Valuation: asset mismatch");
            weightedSum += valuations[valuationIds[i]].estimatedValue * weights[i];
            totalWeight += weights[i];
        }

        require(totalWeight > 0, "Valuation: zero weight");
        uint256 composite = weightedSum / totalWeight;

        latestCompositeValue[assetId] = composite;
        emit CompositeValueUpdated(assetId, composite);

        return composite;
    }

    // =====================================================
    // 内部函数
    // =====================================================

    /**
     * @dev 计算现金流折现现值
     * PV = Σ CF_t / (1 + r)^(t+1)，t 从第 1 期开始
     * 即 CF_0/(1+r) + CF_1/(1+r)^2 + ... + CF_n/(1+r)^(n+1)
     */
    function _calculateDCF(uint256[] memory cashFlows, uint256 discountRate) internal pure returns (uint256) {
        uint256 presentValue = 0;
        uint256 base = 10000; // 基点基数
        uint256 rateFactor = base + discountRate; // (1 + r)，例如 10500

        for (uint256 t = 0; t < cashFlows.length; t++) {
            // PV_t = CF_t * base^(t+1) / rateFactor^(t+1)
            uint256 numerator = cashFlows[t];
            for (uint256 k = 0; k <= t; k++) {
                numerator = (numerator * base);
            }
            uint256 denom = rateFactor;
            for (uint256 k = 1; k <= t; k++) {
                denom = (denom * rateFactor);
            }
            presentValue += numerator / denom;
        }
        return presentValue;
    }

    /**
     * @dev 记录估值结果
     */
    function _recordValuation(
        uint256 assetId,
        Method method,
        uint256 estimatedValue,
        string memory paramsHash
    ) internal returns (uint256) {
        uint256 valuationId = valuationCount;

        valuations[valuationId] = ValuationRecord({
            valuationId: valuationId,
            assetId: assetId,
            method: method,
            estimatedValue: estimatedValue,
            timestamp: block.timestamp,
            paramsHash: paramsHash,
            appraiser: msg.sender,
            verified: false
        });

        assetValuations[assetId].push(valuationId);
        valuationCount++;

        emit ValuationRecorded(valuationId, assetId, method, estimatedValue);
        return valuationId;
    }

    // =====================================================
    // 查询与管理功能
    // =====================================================

    function getValuation(uint256 valuationId) public view returns (ValuationRecord memory) {
        require(valuationId < valuationCount, "Valuation: not found");
        return valuations[valuationId];
    }

    function getAssetValuations(uint256 assetId) public view returns (uint256[] memory) {
        return assetValuations[assetId];
    }

    function getLatestCompositeValue(uint256 assetId) public view returns (uint256) {
        return latestCompositeValue[assetId];
    }

    function verifyValuation(uint256 valuationId) public onlyAdmin {
        require(valuationId < valuationCount, "Valuation: not found");
        valuations[valuationId].verified = true;
        emit ValuationVerified(valuationId);
    }

    function getMethodName(Method method) public pure returns (string memory) {
        if (method == Method.DiscountedCashFlow) return unicode"现金流折现";
        if (method == Method.ComparableCompany) return unicode"可比公司法";
        if (method == Method.Cost) return unicode"成本法";
        if (method == Method.Market) return unicode"市场法";
        return unicode"未知";
    }
}
