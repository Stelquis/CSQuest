# /review408 — 408 复习统一入口

一键启动 408 复习工作流。根据你的输入，自动路由到合适的工具链。

## 使用方式

```
/review408 [动作] [主题]
```

## 快速命令

| 你说 | 触发流程 |
|------|---------|
| `/review408` | 交互式引导：先问状态 → 推荐模式 → 路由到对应工具 |
| `/review408 学习 [主题]` | 预习+精读 → 走 408-loop 元流程 |
| `/review408 做题 [主题]` | 出题 + 批改 + 错题定级 |
| `/review408 缝合 [主题A] [主题B]` | 跨科缝合测试 |
| `/review408 画图 [主题]` | 画概念结构图 (Excalidraw) |
| `/review408 数据流 [主题]` | 画数据流路径图 (Mermaid) |
| `/review408 闪卡 [主题]` | 生成 Anki 闪卡 |
| `/review408 格式化` | 整理笔记格式 |
| `/review408 规划` | 三幕式定位 + 本周安排 |
| `/review408 瓶颈` | 约束理论找短板 |
| `/review408 解冻` | 冷宫解冻日执行 |

## 工作流路由

### 1. 学习新知识
```
/review408 学习 [主题]
→ 加载 408-loop Rule
→ 定位矛盾 → 定级(梁柱/砖墙/涂料)
→ book-study 辅助精读
→ 如果是梁柱级 → 三层加工:
    L1 结构化 → 调用 excalidraw 画概念图
    L2 关联化 → 标注跨科缝合点
    L3 模型化 → 抽象为思维模型
→ 费曼检验
→ 产出: 概念图 + 笔记 + 缝合点标注
```

### 2. 刷题巩固
```
/review408 做题 [主题]
→ 加载 408-loop Rule 做题方法论
→ quiz-maker 自动出题（选择题+大题）
→ 你做完后批改
→ 错题按 A/B/C 定级
→ A 级 → 四阶归因 + 补充笔记
→ C 级 → 罚抄提醒
→ 涂料 2 错升舱检查
→ 可选: 推送至 memento-flashcards 做间隔重复
```

### 3. 跨科缝合
```
/review408 缝合 Cache 页表
→ 读取你的笔记
→ 调用 mermaid-diagrams 画数据流路径图
   虚拟地址 → 页表(OS) → 物理地址 → Cache(计组) → CPU
→ 标注缝合点
→ 出 1 道缝合题
→ 贴到笔记上
```

### 4. 画概念图
```
/review408 画图 Cache 映射
→ 调用 excalidraw
→ 生成: 直接映射 / 组相联 / 全相联 结构图
→ 保存到笔记
```

### 5. 记忆保持
```
/review408 闪卡 Cache 映射
→ 提取关键概念
→ 生成闪卡
→ 推送至 memento-flashcards（本地 JSON 闪卡系统）
→ 或直接在对话中展示
```

### 6. 笔记整理
```
/review408 格式化
→ 调用 baoyu-infographic
→ 将笔记生成为信息图（21种布局 × 21种风格）
→ 输出可视化笔记
```

### 7. 规划
```
/review408 规划
→ 加载 408-loop Rule 三幕式定位
→ 判断当前阶段（抢梁柱/砌砖墙/精装修）
→ 根据身体状态推荐模式（满血/巡航/苟活）
→ 输出今日计划
```

## 安装的工具清单

```
📦 已安装工具:
├── book-study              — 教材精读 [已安装 ✅ book-study@atomcode-plugins-official]
├── excalidraw              — 概念结构图 [已安装 ✅ excalidraw@atomcode-plugins-official]
├── mermaid-diagrams        — 数据流路径图 [已安装 ✅ mermaid-diagrams@atomcode-plugins-official]
├── quiz-maker              — 自动出题 [已安装 ✅ quiz-maker@atomcode-plugins-official]
├── memento-flashcards      — 间隔重复闪卡 [已安装 ✅ memento-flashcards@atomcode-plugins-official]
├── baoyu-infographic       — 信息图/笔记可视化 [已安装 ✅ baoyu-infographic@atomcode-plugins-official]
├── 408-loop Rule           — 核心方法论
└── 三张卡片                — 启动/纠错/休战
```