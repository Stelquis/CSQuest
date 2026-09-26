# [AI Agent 编程入门到实践：从底层原理到 Pi 的极简之道](https://mp.weixin.qq.com/s/Q2Fkkp8GrJ49SUeczrjZUQ)

> 这是一个关于"虹桥软件"的故事——一家外包团队接手了跨境电商「鲸购」的订单系统改造，后端工程师陆则在架构顾问温叙的指导下，第一次把 AI Agent 用进真实的交付项目：从"Agent 到底是什么"的底层原理，到五大部分、Agent 循环、可靠性六原则，再到用 Pi 这个 10 万 star 的极简 Agent harness 把理论跑起来。举例时你会反复看到一个名字：Pi——默认只有 read、write、edit、bash 四个工具，系统提示词加工具定义不到 1000 tokens。读完之后你会发现：AI Agent 不是"更会聊天的大模型"，也不是魔法，而是一套由模型、工具、上下文、记忆、反馈和安全机制共同组成的软件工程系统。

---

## 故事的起点：一次让客户皱眉的演示

"虹桥软件"是杭州一家二十来人的外包团队，常年接电商系统的活。跨境电商「鲸购」找上门来，要给订单系统加一整套促销能力，工期压得很紧。

带项目的架构顾问温叙提议：这次用 AI Agent 辅助开发。后端工程师陆则第一个举手赞成——他天天刷到"Agent 十分钟写完一个功能"的视频，觉得拿下这个项目稳了。

演示那天，陆则对着 Agent 敲下一句：

> "给这个项目增加用户登录失败 5 次后锁定 30 分钟的功能，并补上测试。"

几分钟后，Agent 自动读取项目目录、找到登录模块、修改数据库模型、补充接口逻辑、运行测试，然后根据报错继续修复。陆则得意地看向客户方技术负责人，对方却只问了一句：

> "它改了哪些文件？你怎么保证没把别的逻辑改坏？测试失败它自己乱改断言怎么办？"

陆则一个都答不上来。他只会"用"，却讲不清 Agent 是**怎么**把一句自然语言变成项目里的真实代码的，更说不清边界和风险在哪里。

散会后，温叙在白板上写了一行字：

> Agent 负责探索、修改和验证，人负责目标、边界和最终责任。
> 想清楚这句话，再回去用它。

陆则给自己定了目标：**一周之内，从底层原理到实战上手，把 AI Agent 这套体系吃透，下次客户评审会，主动把"它改了什么、怎么验证、边界在哪"讲明白。**

这个故事，就是他从头到尾走完的路线图。文中所有示例都围绕「鲸购」订单系统展开，实战部分使用的是 Pi——一个主打极简的终端 Agent harness。

---

## 第一站：AI Agent 不是"更会聊天的大模型"

温叙没有让陆则立刻上手工具，而是在白板上写了两句话，让他先分辨区别。

过去，我们让 AI "生成一段代码"；现在，我们开始让 AI "完成一个开发任务"。

两者看起来只差几个字，背后却是完全不同的技术体系。

很多人的第一反应是：大模型已经会像程序员一样操作电脑了吗？

更准确的答案是：

> 大模型本身并不会真正"写入文件"或"运行命令"。AI Agent 之所以能完成编码任务，是因为系统给大模型装上了眼睛、双手、记忆和反馈回路。

普通大模型的工作方式，可以简化为：

```text
用户输入问题 → 大模型生成文字 → 对话结束
```

例如你问：

> "请用 Python 写一个快速排序。"

模型生成一段代码，任务就结束了。至于这段代码有没有保存到文件、能不能在你的项目中运行、是否符合现有架构，大模型并不知道。

AI Agent 的工作方式则更像：

```text
理解目标
  ↓
读取环境
  ↓
制定计划
  ↓
调用工具执行
  ↓
观察执行结果
  ↓
根据结果调整
  ↓
直到任务完成或触发停止条件
```

它不再只负责"回答"，而是要围绕一个目标持续行动。

因此，智能体的核心并不是某一次输出有多精彩，而是它能否形成一个稳定的闭环：

```text
思考 → 行动 → 观察 → 修正 → 再行动
```

这就是 AI Agent 编程能力的基础。

---

## 第二站：一个会写代码的 Agent，通常由五个部分组成

"先别急着挑工具。"温叙说，"想清楚它由什么组成，你才知道该在哪一层下功夫。"他让陆则把编程智能体想象成一个刚加入团队的远程开发者。

它至少需要五种能力。

### 1. 大模型：负责理解、推理和决策

大模型是 Agent 的"大脑"。

它负责理解需求、阅读代码、判断应该修改哪些文件，并决定下一步采取什么动作。

例如，当它看到需求"给「鲸购」订单系统增加登录失败锁定机制"时，可能会推断出需要检查：

- 用户模型中是否已有失败次数和锁定时间字段；
- 登录接口在哪里；
- 密码校验失败后如何更新状态；
- 项目使用什么测试框架；
- 是否存在并发更新、时区或缓存问题。

但是，大模型只会生成信息。它不能凭空读取你的硬盘，也不能直接执行命令。

所以，仅有"大脑"还不够。

### 2. 工具系统：负责真正执行动作

工具就是 Agent 的"双手"。

常见工具包括：

- 读取文件；
- 搜索代码；
- 创建或修改文件；
- 应用补丁；
- 执行 Shell 命令；
- 运行测试；
- 调用编译器；
- 查询 Git 状态；
- 获取报错日志；
- 访问浏览器、数据库或外部 API。

大模型不会直接操作这些资源，而是生成结构化的"工具调用请求"。

例如，模型可能输出类似这样的指令：

```json
{
  "tool": "read_file",
  "arguments": {
    "path": "src/auth/login_service.py"
  }
}
```

Agent 框架接收到请求后，才会真正读取文件，并把内容返回给大模型。

再比如，模型决定修改代码时，可能调用：

```json
{
  "tool": "apply_patch",
  "arguments": {
    "path": "src/auth/login_service.py",
    "patch": "..."
  }
}
```

真正把内容写入磁盘的，是工具执行层，而不是大模型本身。

这也是理解 AI Agent 的关键：

> 大模型负责决定做什么，工具负责把决定变成现实。

以 Pi 为例：它默认只给模型提供 4 个工具——`read`（读文件，支持图片）、`write`（写文件，自动建目录）、`edit`（精确文本替换）、`bash`（执行任意命令）。看起来少，但有了 `bash`，搜索文件可以用 `rg`，看日志可以用 `git log`，装依赖可以 `npm install`——大部分需求不用专门做 tool，一个 bash 就能实现。

### 3. 上下文：负责让模型看见当前项目

程序员写代码之前，需要先理解项目。

Agent 同样如此。

它通常会收集以下上下文：

- 用户的原始需求；
- 项目目录结构；
- 相关源代码；
- 配置文件；
- 依赖版本；
- 编码规范；
- 当前 Git 差异；
- 测试结果和错误日志；
- 前几轮执行过的动作。

这些信息会被整理后放进模型的上下文窗口。

问题在于，一个真实项目可能有几十万甚至上百万行代码，不可能一次全部交给模型。

因此，Agent 需要进行"上下文工程"：只把当前任务最相关的信息找出来。

常见方法包括：

- 按文件名和关键词搜索；
- 使用语义检索寻找相关代码；
- 先读取目录树，再逐步打开文件；
- 根据 import、函数调用和类型引用追踪依赖；
- 对长文件进行摘要；
- 将历史对话压缩成任务状态。

可以说，很多 AI 编程工具之间的差距，并不只在模型大小，更在于：

> 谁能在正确的时间，把正确的代码交给模型。

Pi 在这一点上的取舍很激进：系统提示词加工具定义一共不到 1000 tokens，把宝贵的上下文窗口留给真正的项目代码——因为现在的前沿模型经过大量 RL 训练，天生就知道怎么当一个 coding agent，不需要在 system prompt 里手把手教。

### 4. 记忆与状态：负责记录"已经做过什么"

一个编码任务往往需要几十轮操作。

如果 Agent 每一轮都忘记前面发生过什么，就会不断重复读取、反复修改，甚至推翻自己刚刚做出的决定。

因此，系统通常会维护任务状态，例如：

```text
目标：增加登录失败锁定机制

已确认：
- 登录入口位于 src/auth/login_service.py
- 用户表使用 PostgreSQL
- 项目采用 pytest

已修改：
- User 模型增加 failed_login_count
- User 模型增加 locked_until

待处理：
- 增加并发更新保护
- 补充登录成功后的计数清零
- 运行完整测试
```

这些状态既可以保存在当前对话中，也可以保存在外部存储中。

从工程角度看，记忆不是为了让 Agent "像人一样有回忆"，而是为了降低重复推理成本，并保证多步骤任务的一致性。

### 5. 权限与规则：负责限制它能做什么

编程 Agent 拥有文件和命令执行能力后，也会带来新的风险。

例如，它可能误删文件、覆盖配置、执行危险命令，或者把敏感信息发送到外部服务。

因此，一个可靠的 Agent 必须受到权限系统约束：

- 哪些目录可以读取；
- 哪些文件可以修改；
- 哪些命令允许执行；
- 是否可以联网；
- 是否可以访问密钥；
- 高风险操作是否需要人工确认；
- 每次任务最多执行多少步骤；
- 运行命令的时间和资源上限是多少。

这部分相当于给智能体划定"施工区域"和"安全规范"。

> 没有边界的 Agent，不是更强，而是更不可控。

有意思的是，Pi 在这条路上走了另一个极端：默认不弹任何权限确认，全权限运行。它的理由是——只要 Agent 能写代码、能执行代码、能联网，权限弹窗本质上只是给人安全感，实际拦不住什么。如果你的场景确实需要隔离，Pi 提供了三种容器化方案：Gondolin（本地微虚拟机）、Docker、OpenShell（策略沙箱），按需选用。这正好呼应了温叙写在白板上的话：边界不靠弹窗，靠隔离和审查。

---

## 第三站：Agent 是怎样一步步把需求变成代码的？

下面用一个简化流程，拆解完整的编码过程。

假设陆则在「鲸购」项目里提出需求：

> "在现有登录系统中增加失败锁定：连续输错 5 次密码后，账号锁定 30 分钟；登录成功后清零失败次数；补充单元测试。"

### 第一步：解析任务目标和约束

Agent 首先会把自然语言需求转换成更明确的任务描述：

```text
功能目标：
1. 记录连续登录失败次数；
2. 第 5 次失败后设置 locked_until；
3. 锁定期间拒绝登录；
4. 登录成功后清零失败状态；
5. 增加自动化测试。

潜在约束：
- 保持现有 API 返回格式；
- 不破坏已有用户数据；
- 数据库变更需要迁移脚本；
- 时间处理应统一使用 UTC。
```

这一步常被称为任务分解或规划。

好的规划不一定要非常长，但必须把"完成"的标准说清楚。

### 第二步：定位相关代码

Agent 会先读取项目目录，再搜索与登录、用户模型、认证失败有关的代码。

例如：

```bash
find . -maxdepth 3 -type f
rg "login|authenticate|password" src tests
```

它可能发现：

```text
src/models/user.py
src/auth/login_service.py
src/api/routes/login.py
tests/auth/test_login.py
migrations/
```

随后，它会优先阅读这些文件，而不是扫描整个仓库。

### 第三步：形成修改方案

读完代码后，Agent 会结合项目现状制定方案。

例如：

1. 在 User 模型增加 failed_login_count 和 locked_until；
2. 创建数据库迁移；
3. 登录前检查 locked_until；
4. 密码错误时原子增加失败次数；
5. 达到阈值后写入锁定截止时间；
6. 登录成功后重置两个字段；
7. 新增 4 个测试用例。

这里需要强调：Agent 的"计划"不是一份永远不变的施工图。

它只是当前信息下的最佳判断。后续一旦遇到测试失败、依赖冲突或架构限制，计划就需要更新。

### 第四步：生成并应用代码修改

Agent 通常不会每次重写整个文件，而会优先生成局部补丁。

例如：

```diff
class User(Base):
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True, nullable=False)
+   failed_login_count = Column(Integer, nullable=False, default=0)
+   locked_until = Column(DateTime(timezone=True), nullable=True)
```

局部补丁有三个优势：

1. 降低误删无关代码的风险；
2. 便于审查修改范围；
3. 补丁失败时更容易定位原因。

在应用补丁后，工具会把执行结果返回给模型：

```text
Patch applied successfully.
```

或者：

```text
Patch failed: target context not found at line 42.
```

如果失败，模型会重新读取文件，根据最新内容生成新的补丁。

### 第五步：运行测试或编译

这是 AI Agent 和普通代码生成最大的区别之一。

普通大模型写完代码后，往往只能说"这段代码应该可以运行"。

Agent 则可以真正执行：

```bash
pytest tests/auth/test_login.py -q
```

然后获得真实结果：

```text
3 passed, 1 failed

FAILED test_account_is_locked_after_fifth_failure
Expected status_code == 423, got 401
```

错误日志会成为下一轮推理的新上下文。

### 第六步：根据反馈定位问题并修复

模型会分析失败原因：

- 是第 5 次失败后立即返回锁定状态，还是从第 6 次开始？
- 业务要求是否明确？
- 当前代码是在返回响应后才更新锁定字段吗？
- 测试断言是否符合既有接口规范？

接着，它会修改实现或测试，并再次执行。

这个过程可能重复多轮：

```text
修改代码 → 运行测试 → 读取报错 → 再修改
```

直到测试通过，或者达到步骤、时间、权限等停止条件。

### 第七步：检查最终差异并汇报

任务结束前，Agent 通常还会查看 Git Diff：

```bash
git diff -- src tests migrations
```

它会确认：

- 是否修改了不相关文件；
- 是否残留调试代码；
- 是否漏掉迁移或测试；
- 是否出现明显安全问题；
- 是否满足最初的验收标准。

最后，它才会向用户汇报：修改了什么、测试结果如何、还有哪些风险。

---

## 第四站：智能体循环——真正的核心代码并不复杂

这天晚上，陆则在笔记本上试着用一个 while 循环，把白天学到的东西串起来——他想看看，剥掉所有术语之后，Agent 的核心到底剩下什么。

从抽象层面看，一个最小化的编码 Agent 可以写成下面这样：

```python
state = initialize_task(user_request)

while not state.finished:
    context = observe_environment(state)

    decision = model.generate(
        goal=state.goal,
        context=context,
        history=state.history,
        available_tools=TOOLS,
    )

    if decision.type == "final_answer":
        state.finished = True
        state.result = decision.content
        break

    tool_result = execute_tool(
        name=decision.tool_name,
        arguments=decision.arguments,
    )

    state.history.append({
        "decision": decision,
        "result": tool_result,
    })

    state = update_state(state, tool_result)
```

真正困难的地方，不是这个 while 循环，而是围绕它的一整套工程设计：

- 如何选出最相关的上下文；
- 如何让模型正确调用工具；
- 如何防止无限循环；
- 如何判断任务是否完成；
- 如何处理命令失败；
- 如何控制成本和延迟；
- 如何验证代码真的正确；
- 如何限制危险操作；
- 如何在复杂任务中保持状态一致。

所以，AI Agent 不是一个神秘的新物种。

从系统视角看，它更像是：

```text
大模型 + 工具调用 + 状态管理 + 反馈循环 + 权限控制
```

Pi 把这个循环拆成了清晰的分层架构（TypeScript monorepo）：最底层的 `pi-ai` 统一 15+ 模型提供商的 API（本质只需对接 OpenAI Completions、OpenAI Responses、Anthropic Messages、Google Generative AI 四种协议）；中间的 `pi-agent-core` 实现 Agent 循环——收到用户消息 → 调 LLM → LLM 要用工具 → 执行 → 结果喂回去 → 再调 LLM，直到不再需要工具；上面的 `pi-coding-agent` 是 CLI 应用层（会话持久化、自动压缩、工具注册）；最顶上的 `pi-tui` 用差分渲染做终端 UI。理论里的"Agent 循环"，在 Pi 里就是 `pi-agent-core` 那一层。

---

## 第五站：为什么"运行测试"对 Agent 如此重要？

这一站是温叙在看过陆则第一次让 Agent 生成的代码后专门补的——那段代码读起来毫无破绽，跑起来却连不上项目自己的数据库。

大模型擅长根据已有模式生成看起来合理的代码，但"看起来合理"不等于"在当前项目中正确"。

它可能会：

- 猜错函数名称；
- 使用项目并未安装的库；
- 忽略现有接口约定；
- 混淆不同版本的 API；
- 写出语法正确但业务逻辑错误的实现；
- 修复一个问题，却破坏另一个模块。

测试、编译器、类型检查器和静态分析工具，能够提供比语言描述更可靠的反馈。

例如：

```text
自然语言反馈：
"这里可能存在类型问题。"

编译器反馈：
src/auth/login_service.ts:87:18
Type 'Date | null' is not assignable to type 'Date'.
```

后者更具体、可定位、可验证。

因此，高质量编程 Agent 通常会尽量把开放式问题，转换成可执行的验证信号：

- 能否编译；
- 测试是否通过；
- 类型检查是否通过；
- Lint 是否通过；
- 接口响应是否符合断言；
- 页面是否出现预期元素；
- 数据库迁移能否执行和回滚。

这背后有一个非常重要的原则：

> 不要只让模型判断自己是否正确，要让外部环境提供证据。

---

## 第六站：Agent 常见的三种代码修改方式

"它到底是怎么把代码写进文件里的？"陆则问。温叙没有直接回答，而是在白板上列了三种方式。

1. **整文件重写**：模型读取文件后，生成修改后的完整内容，再覆盖原文件。优点是实现简单，适合短文件。缺点也很明显：文件越长，越容易误删注释、格式或无关逻辑，也更消耗上下文。

2. **基于文本的局部替换**：系统要求模型提供"旧内容"和"新内容"，工具在文件中精确匹配后替换。这种方式比整文件重写安全，但如果原始内容发生变化，匹配就可能失败。

3. **Diff 或 Patch**：模型生成统一差异格式，工具将补丁应用到文件。这是很多编码 Agent 常用的方式，因为它天然适合展示变更、控制范围和进行版本审查。

无论采用哪一种方式，稳定系统都会在写入后重新读取关键片段，或者运行格式化、编译和测试，避免出现"工具说写入成功，但内容并不符合预期"的情况。

Pi 的工具设计正好对应后两种：`edit` 是基于文本的精确替换（要求旧文本完全匹配），`write` 只用于新文件或完全重写——什么时候用哪个，它的极简系统提示词里一句话就说清了。

---

## 第七站：为什么 AI Agent 有时会越改越错？

知道了工作原理，也就更容易理解它为什么会失败。陆则把这一站整理成了排查清单。

1. **上下文不完整**：Agent 只读了登录接口，却没有发现项目中还有一层领域服务；于是它把逻辑写在了错误的位置。这不是代码生成能力不足，而是"看见的项目"不完整。

2. **早期假设错误**：模型一开始误以为项目使用同步数据库驱动，后续所有实现都建立在这个假设上。如果系统没有及时验证依赖和调用方式，错误会不断累积。

3. **只修复表面报错**：测试提示返回码错误，Agent 可能直接修改断言，让测试变绿，却没有修复真实业务逻辑。因此，**测试通过只是必要条件，不是充分条件**。

4. **任务完成标准模糊**："优化一下登录模块"几乎没有明确终点。Agent 可能不断重构，直到耗尽步骤预算。相比之下，"将登录接口的 P95 延迟降低到 200ms 以下，并保持现有测试通过"更容易验证。

5. **工具能力受限**：Agent 可能知道应该运行集成测试，但环境中没有数据库；知道应该查看页面，却没有浏览器工具；知道应该查询文档，却不能联网。智能体能力的上限，不只由模型决定，也由工具和环境决定。

6. **缺少全局审查**：局部修改都合理，但组合起来可能存在重复逻辑、性能退化或架构不一致。因此，成熟的 Agent 需要在最后进行整体 Diff 审查，而不是"最后一个测试通过就立刻结束"。

---

## 第八站：怎样让一个编程 Agent 更可靠？

排查清单整理完，陆则反过来问："那怎么让它少踩坑？"温叙给了他六条原则。

**第一，把需求写成可验证的结果。**

不要只说：

> "帮我把这个功能做好。"

更好的表达是：

> "增加账号锁定功能：连续失败 5 次锁定 30 分钟；成功登录后清零；保持现有响应结构；新增对应测试，并确保认证模块测试全部通过。"

目标越清晰，Agent 越不容易在错误方向上消耗时间。

**第二，先探索，再修改。**

可靠的 Agent 不应该一看到需求就立刻写代码。

它应该先确认：

- 项目结构是什么；
- 是否已有类似实现；
- 使用哪些框架和依赖；
- 修改会影响哪些模块；
- 如何验证结果。

"先读后写"看起来变慢了，实际往往能减少返工。

**第三，小步修改，小步验证。**

一次修改 20 个文件后再测试，出错时很难定位。

更稳妥的方式是：

```text
修改数据模型 → 检查迁移
修改核心逻辑 → 跑单元测试
修改接口层 → 跑接口测试
最后 → 跑完整测试
```

这和优秀工程师的工作方式并没有本质区别。

**第四，优先使用可执行反馈。**

能用编译器判断的，不要只靠模型猜；能用测试验证的，不要只靠文字总结；能用数据库查询确认的，不要只看代码表面。

外部反馈越强，Agent 的自我纠错能力越强。

**第五，限制权限和修改范围。**

让 Agent 只访问完成任务所需的目录和命令。

对于删除文件、修改生产配置、执行数据库写入、安装系统软件等高风险操作，应该增加人工确认。

**第六，保留人工审查。**

即使所有测试通过，也不代表实现一定符合真实业务、安全要求和长期维护需求。

当前更合理的协作方式仍然是：

> Agent 负责探索、修改和验证，人负责目标、边界和最终责任。

---

## 第九站：从"代码补全"到"软件工程闭环"

一周的理论学习接近尾声，温叙让陆则把视野从单个 Agent 抬到整个行业。

早期 AI 编程工具主要解决的是：

```text
"下一行代码应该写什么？"
```

而 AI Agent 试图解决的是：

```text
"为了完成这个开发目标，下一步应该做什么？"
```

这两个问题的层级完全不同。

前者关注局部代码生成，后者需要处理任务规划、环境操作、错误恢复和结果验证。

因此，未来的 AI 编程竞争，很可能不只是比较谁生成代码更快，而是比较谁能更稳定地完成完整工程任务：

- 能否理解大型代码库；
- 能否跨多个文件完成修改；
- 能否正确使用项目工具链；
- 能否从真实报错中恢复；
- 能否控制修改范围；
- 能否给出可审查、可回滚的结果；
- 能否在安全边界内持续运行。

真正有价值的智能体，不是一次写出几百行代码，而是能在复杂环境中持续减少不确定性。

---

## 第十站：Pi 实战——把理论跑起来

理论吃透了，陆则决定用 Pi 在「鲸购」项目里实际跑一遍。

### 1. 安装与配置

一行命令搞定：

```bash
# 推荐方式
curl -fsSL https://pi.dev/install.sh | sh

# 或者用 npm
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
```

装完之后终端里直接敲 `pi` 就能进入交互界面。

Pi 支持 15+ 模型提供商（Anthropic、OpenAI、Google、DeepSeek、xAI、Groq、Ollama 等）。配置方式：

- 有订阅的话（Claude Pro/Max、ChatGPT Plus 等），直接 `/login` 走 OAuth；
- 用 API Key 的话，设好环境变量就行，比如 `ANTHROPIC_API_KEY`。

进去之后 `/model` 切模型，`Ctrl+P` 快速循环常用模型列表，而且支持会话中途换模型，上下文会自动做跨提供商转换。

### 2. 基本使用

```bash
# 交互模式
pi

# 一行式调用，适合脚本或 CI
pi -p "给这个函数加单元测试"
```

### 3. 会话管理：会话是一棵树

Pi 的会话不是普通的线性记录，而是一棵树。每次对话都保存为树形结构，可以在任意节点分支出去：

```bash
pi -c              # 继续上次的会话
pi -r              # 浏览历史会话列表
pi --fork <id>     # 从某个历史节点分出新分支
```

会话里用 `/tree` 可以看到完整的对话树，想跳回哪个节点就跳回哪个节点。

### 4. 四种运行模式

除了终端交互，Pi 还有三种无头模式，方便集成到其他地方：

| 模式 | 命令 | 适合场景 |
| --- | --- | --- |
| Interactive | `pi` | 日常开发，完整终端体验 |
| Print/JSON | `pi -p "query"` | 脚本调用、CI 流水线 |
| RPC | `--mode rpc` | stdin/stdout JSON 协议，给非 Node 项目用 |
| SDK | TypeScript API | 嵌入你自己的应用 |

四种模式共享同一套 session 格式和事件流——不管从终端、Web 还是 CI 调用，看到的都是同一个 Agent。

### 5. 极简的设计哲学

Pi 的作者 Mario Zechner 说过一句话："if I don't need it, it won't be built"——没用的东西我不做。

**极简系统 Prompt。** 作者在 2025 年 11 月那篇《What I learned building an opinionated and minimal coding agent》里贴出的完整系统提示词（当时的版本）：

```text
You are an expert coding assistant. You help users with coding tasks
by reading files, executing commands, editing code, and writing new files.

Available tools:
- read: Read file contents
- bash: Execute bash commands
- edit: Make surgical edits to files
- write: Create or overwrite files

Guidelines:
- Use bash for file operations like ls, grep, find
- Use read to examine files before editing
- Use edit for precise changes (old text must match exactly)
- Use write only for new files or complete rewrites
- When summarizing your actions, output plain text directly - do NOT use cat or bash to display what you did
- Be concise in your responses
- Show file paths clearly when working with files

Documentation:
- Your own documentation (including custom model setup and theme creation) is at: /path/to/README.md
- Read it when users ask about features, configuration, or setup, and especially if the user asks you to add a custom model or provider, or create a custom theme.
```

就这？就这！加上工具定义一共不到 1000 tokens，而且更稳定、缓存更容易命中、每次请求成本更低。如今的源码版本把每一段包进同名 XML 标签（见第十一站第 4 节），再追加项目上下文、可用技能和文档路径——结构更规整，默认的工具与规则仍是上面这些。作者的理由是：前沿模型经过大量 RL 训练，天生就知道怎么当一个 coding agent，不需要用上万 token 的提示词手把手教。

**4 个工具。** 与其他 Agent 动辄十几个 tool 不同，Pi 只留 read、write、edit、bash。工具少，模型做决策更快——工具越多，模型越容易纠结用哪个，甚至选错。

**被简化的功能。** 很多 Agent 产品当成卖点的功能，Pi 一个都不做，但每个都给了更简单的替代思路：

| 被 Pi 简化的功能 | Pi 的替代思路 |
| --- | --- |
| Plan Mode | 直接写一个 `PLAN.md`，Agent 能读能改，人也能手动编辑，还能用 git 管版本 |
| Sub-agents | 通过 `bash` 自调用：`pi -p "review this PR" --provider anthropic --model claude-sonnet-4-5`，丢进 tmux 跑，全程可见，不像黑盒 |
| MCP | 做成普通 CLI 工具 + README，Agent 需要时用 bash 调，顺便读 README 看用法，只在真正用到时才付 token 成本（Playwright MCP 一注册就是 21 个 tool、13.7k tokens，不管用不用都占着窗口） |
| 后台进程 | 用 tmux：`tmux new-session -d -s dev "npm run dev"`，Agent 随时 `tmux capture-pane` 看日志，可观测性更好 |

### 6. 扩展系统：三层生态

极简不等于不能扩展。Pi 的扩展机制分三层：

**Extensions（代码级）**：TypeScript 模块，可以注册工具、添加命令、绑快捷键、拦截工具调用、自定义 UI 组件。保存后 `/reload` 热加载：

```ts
// ~/.pi/agent/extensions/my-tool.ts
import type { ExtensionAPI } from '@earendil-works/pi-coding-agent';
import { Type } from 'typebox';

export default function(pi: ExtensionAPI) {
  pi.registerTool({
    name: 'search_docs',
    description: '搜索项目文档',
    parameters: Type.Object({
      query: Type.String()
    }),
    async execute(id, params, ctx) {
      const result = await searchIndex(params.query);
      return { content: [{ type: 'text', text: result }] };
    }
  });
}
```

**Skills（提示词级）**：Markdown 文件，定义特定任务的指令和工作流。与 Extensions 的关键区别是按需加载——平时只在上下文里保留一行描述（几十个 token），真正被触发时才加载完整内容，也就是"渐进式上下文披露"。装几十个 Skill 也不会撑爆上下文窗口。

**Packages（生态打包）**：Extensions、Skills、Prompt Templates、Themes 都可以打包成 Package，通过 npm 或 git 安装：

```bash
pi install npm:pi-autoresearch
pi install git:github.com/badlogic/pi-doom
```

最出圈的 Package 是 Shopify 工程师 David Cortés 写的 `pi-autoresearch`：一个自动化性能优化循环——设定要优化的指标（比如构建时间），Agent 自动尝试改代码、跑 benchmark、比基线快就保留、慢了就回滚，循环往复直到你打断。有意思的是，这个扩展本身就是让 Pi 写出来的，后来 Shopify CEO Tobi Lütke 看到后直接贡献了 32 个 commit。Shopify 内部用它把单测速度提升了 300 倍，React 组件挂载快了 20%。

---

## 第十一站：深入 Pi 源码——分层架构与关键机制

温叙看完陆则的实战笔记，说："会用了，接下来读读它的源码。一个 Agent harness 把五脏六腑摊开给你看的机会不多。"

在动源码之前，先补一段来龙去脉——理解一个框架，要先理解作者为什么不满。

Pi 的作者 Mario Zechner 最初是 Claude Code 的热情用户，但随着产品功能越堆越多，他遇到了一个更深层的问题：**harness，而不是开发者，控制着进入模型上下文的内容**。系统提示词悄悄变化、工具定义改版、自动插入的 reminders，都可能在版本升级后改变 Agent 的行为，破坏他已经建立的工作流。他审视其他方案时发现同类问题：OpenCode 会条件性裁剪工具输出（丢掉模型可能还需要的上下文）；有的工具每次编辑后自动注入语言服务报错——但中间态代码本来就是非法的，过早暴露诊断只会干扰模型。他的结论是：

> 看起来贴心的 harness 功能，一旦不顾任务实际地干预上下文，就会从帮助变成伤害。

2026 年 4 月，Zechner 带着 Pi 加入 Earendil Inc. 成为重要股东，包名也从 `@mariozechner` 换成了如今的 `@earendil-works`。他在 AI Engineer 大会的演讲把设计哲学浓缩为三句话：**keep the core small（核心要小）、make customization part of the workflow（把定制变成工作流本身）、be honest about what it does not do（对不做什么保持诚实）**。

还有一层更根本的理由——**透明性才是你真正买到的**。四个工具加约 150 词的系统提示词不是产品本身，而是「让 Agent 成为程序员能完全理解的东西」这一个决定的必然结果。当 Pi 出错时，你只有四个地方可以查：一次错误的文件读取、一次写错路径的写入、一条返回噪音的 bash 命令、一次误读指令的模型响应——**调试面与工具面完全重合**。而多数 Agent 恰恰做不到：MCP 层挂着你没写过的上万 token 工具描述、隐藏的 planner 在你看到第一个输出前已经跑了三步、subagent 池分发了你没观察到的任务——失败发生在你打不开的盒子里。Pi 把盒子打开了：装它、看工具调用、读会话文件，所见即所运行。

Pi 是一个 TypeScript monorepo，六个核心包各司其职：

| 包 | 职责 |
| --- | --- |
| `pi-ai` | 统一多提供商 LLM API（OpenAI、Anthropic、Google 等） |
| `pi-agent-core` | Agent 运行时：工具调用与状态管理 |
| `pi-coding-agent` | 交互式编码 Agent CLI（自扩展） |
| `pi-tui` | 差分渲染的终端 UI 库 |
| `pi-telemetry` | 厂商中立的可观测性契约与类型化 schema |
| `chord` | 服务组合运行时：RPC、副本状态、插件（实验性的 facet 服务原语） |

### 1. pi-agent-core：Agent 循环的完整事件流

第四站那个 while 循环，在 `pi-agent-core` 里有精确的事件时序。调用 `prompt("Hello")` 时：

```text
prompt("Hello")
├─ agent_start
├─ turn_start
├─ message_start   { userMessage }        // 你的提问
├─ message_end     { userMessage }
├─ message_start   { assistantMessage }   // LLM 开始响应
├─ message_update  { partial... }         // 流式 chunk
├─ message_end     { assistantMessage }
├─ turn_end        { toolResults: [] }
└─ agent_end
```

如果 Assistant 发起了工具调用，循环会继续：

```text
├─ message_start/end  { assistantMessage with toolCall }
├─ tool_execution_start  { toolCallId, toolName, args }
├─ tool_execution_update { partialResult }   // 工具可流式上报进度
├─ tool_execution_end    { toolCallId, result }
├─ message_start/end  { toolResultMessage }
├─ turn_end
├─ turn_start                                // 下一轮
├─ ...                                       // LLM 响应工具结果
└─ agent_end
```

两个值得学习的细节：

**消息双轨制。** Agent 内部流转的是灵活的 `AgentMessage`（可以包含应用自定义消息类型），而 LLM 只认识 `user`、`assistant`、`toolResult` 三种。桥接靠两步：`transformContext`（裁剪旧消息、注入外部上下文）→ `convertToLlm`（过滤 UI 专用消息、转换自定义类型）。这解释了"框架怎么在保持自己状态模型的同时喂给模型干净的上下文"。`agent-loop.ts` 的文件头注释把设计说得很直白：*Agent loop that works with AgentMessage throughout. Transforms to Message[] only at the LLM call boundary*——全程用 AgentMessage，只在调用 LLM 的边界处转换。

**错误用 throw，不用返回值。** 官方文档明确要求：工具失败时应该抛异常而不是把错误消息当内容返回——抛出的错误会被 Agent 捕获，以 `isError: true` 的工具错误形式上报给 LLM，模型能明确区分"执行失败"和"执行成功但结果是错误信息"。

源码里还能看到几个教科书级的循环细节：

**Steering 消息。** 循环每轮开始前都会轮询 `config.getSteeringMessages?.()`——用户在 Agent 执行中途打的字不会丢，会在下一轮工具调用前被注入。压缩（prepareNextTurn 可能长耗时）结束后还会补一次轮询，防止只轮询一次导致排队消息丢失。

**截断参数防御。** 当模型响应以 `stopReason === "length"` 结束（输出被 token 上限截断），该消息里所有工具调用的参数都可能是不完整的——循环直接把整批工具调用判为失败（`failToolCallsFromTruncatedMessage`），而不是冒险执行可能残缺的命令。

**停止是可配置的。** `shouldStopAfterTurn` 钩子让上层（比如 coding-agent 的压缩检查）可以决定"这一轮之后就停"，配合工具结果里的 `terminate: true` 信号，实现受控退出。

### 2. 会话即树：JSONL 树形结构

「鲸购」项目里，陆则最常后悔的就是"早知道刚才换个思路"。Pi 的会话设计正好治这个病。

会话自动保存到 `~/.pi/agent/sessions/`（按工作目录组织），每个会话是一个 JSONL 文件，结构是树。源码里 `session-manager.ts` 对自己的定义只有一行注释，却把精髓说完了：

> Manages conversation sessions as append-only trees stored in JSONL files.

```text
├─ user: "Hello, can you help..."
│  └─ assistant: "Of course! I can..."
│     ├─ user: "Let's try approach A..."
│     │  └─ assistant: "For approach A..."
│     │     └─ user: "That worked..."  ← active
│     └─ user: "Actually, approach B..."
│        └─ assistant: "For approach B..."
```

每条消息带 `id` 和 `parentId`，当前位置就是活动叶子（active leaf）。`/tree` 可以跳回任意节点继续，不需要新建文件；`/fork` 从某条历史消息开新会话；`/clone` 把当前活动分支复制成独立会话。

切换分支时，Pi 可以对被放弃的分支做摘要并挂在新位置——保留重要上下文，又不重放整个分支。

对陆则来说，这意味着方案 A 试到一半不行，不用"撤销到天荒地老"——直接 `/tree` 跳回分叉点走方案 B，方案 A 的教训以摘要形式跟着你。

### 3. Compaction：上下文满了的应对机制

这是 Agent 长任务的核心工程问题，Pi 的实现非常工程化：

**触发条件**：`contextTokens > contextWindow - reserveTokens`（`reserveTokens` 默认 16384，给 LLM 留响应空间）。源码里这是一个一行函数（`shouldCompact`），但配合两个工程细节才完整：

- **token 估算用 chars/4 启发式**：`estimateTokens` 把文本长度除以 4 估算 token（刻意保守、宁高勿低），图片按固定 4800 字符估算——不需要 tokenizer 依赖，还能离线快速判断；
- **找不到确切用量时保守估计**：上下文 token 优先取最近一次 assistant 响应的真实 `usage`，取不到时退回启发式估算。

**工作流程**：

1. **找切点**：从最新消息向前走，累积 token 估算直到 `keepRecentTokens`（默认 20k）；
2. **提取消息**：收集上一个保留边界到切点之间的消息；
3. **生成摘要**：调 LLM 用结构化格式摘要，把上一次的摘要作为迭代上下文传入；
4. **追加条目**：保存 `CompactionEntry`（含摘要和 `firstKeptEntryId`）；
5. **重建上下文**：下一轮请求用「摘要 + 保留消息」重建。

所有参数可配置，还支持按模型覆盖——比如给 1M 窗口的模型设 `reserveTokens: 400000`（超过 60 万 token 才压缩），其他模型保持默认。压缩与分支摘要共用同一套结构化摘要格式，并且都会累计跟踪文件操作，避免摘要后"忘记改过哪些文件"。

### 4. 扩展系统：事件驱动的完整生命周期

第十站只讲了三层扩展的分类，源码层面更值得看的是事件系统。扩展可以订阅的钩子覆盖了 Agent 的一生：

```text
project_trust → session_start
  → before_agent_start   ← 可改写 systemPrompt！
    → agent_start
      → turn_start
        → message_start / message_update / message_end
        → tool_execution_start / update / end
      → turn_end
    → agent_end（可能还有自动重试/自动压缩重试）
  → agent_settled        ← 确认不会再自动继续
  → session_compact_failed / session_before_tree
```

其中 `before_agent_start` 最强大：扩展可以修改 systemPrompt——而且 Pi 做了精细的 diff 优化，改动的 section 会以增量补丁形式追加，支持 mid-conversation system message 的模型能保住缓存前缀，不破坏提示词缓存。

这不是扩展层的权宜之计，而是 `system-prompt.ts` 的一等设计：系统提示词按名字组织成有序分节（`SystemPromptSections`），`preamble` 之外每节都用同名 XML 标签包裹（如 `<project_instructions path="...">`），这样模型能把后续增量补丁精确匹配到某一节。默认工具集就是源码里的 `[read, bash, edit, write]`，每个工具向提示词贡献一段一句话简介（snippet）和若干 guidelines——第十站看到的"极简系统提示词"，就是这些小贡献拼出来的。

一个实用例子——用扩展实现"危险命令闸门"（这正是第六站权限问题的 Pi 式解法）：

```typescript
pi.on("tool_call", async (event, ctx) => {
  if (event.toolName === "bash" && event.input.command?.includes("rm -rf")) {
    const ok = await ctx.ui.confirm("Dangerous!", "Allow rm -rf?");
    if (!ok) return { block: true, reason: "Blocked by user" };
  }
});
```

扩展还能注册自定义工具（`pi.registerTool`）、注册命令（`pi.registerCommand`）、通过 `pi.appendEntry()` 存储跨重启的状态。官方示例库有 50+ 个实现：权限闸门、Git 检查点（每轮 stash）、路径保护（禁止写 `.env` 和 `node_modules/`）、自定义压缩策略，甚至还有个贪吃蛇。

### 5. 内置工具的源码实现：极简哲学在代码层面成立

**edit 工具：一次调用，多个补丁。** `tools/edit.ts` 的 schema 不是单个 `oldText/newText`，而是一个 `edits[]` 数组——一次调用可以完成同一文件里多处不相交的替换。但有三条硬约束写进了参数描述和系统提示词贡献（`editToolSystemPromptContribution`）：

- 每个 `oldText` 必须**在原文件中唯一**，且彼此不重叠、不嵌套；
- 所有 `oldText` 都对**原始文件**匹配，而不是前面替换的中间结果——避免顺序耦合；
- 相邻改动应合并为一个 edit，`oldText` 在保证唯一的前提下尽量小。

另外它还通过 `withFileMutationQueue` 排队变更、处理行尾差异（`detectLineEnding` / `normalizeToLF`），避免并发写坏文件。

**bash 工具：无默认超时，但有截断上限。** `tools/bash.ts` 的 schema 只有两个参数——`command` 和可选的 `timeout`（秒，没有默认超时，上限约 214.7 万秒，即 `2^31-1` 毫秒）。输出经 `OutputAccumulator` 累积、按 `DEFAULT_MAX_BYTES` / `DEFAULT_MAX_LINES` 截断，还有 `BASH_UPDATE_THROTTLE_MS` 节流的流式渲染——长命令的输出不会撑爆上下文，但用户能实时看到进展。

### 6. Skills：渐进式上下文披露的标准化实现

Pi 实现了 Agent Skills 标准（agentskills.io 规范），机制是：

1. 启动时扫描技能目录，只提取 name 和 description；
2. 系统提示词以 XML 形式包含可用技能列表；
3. 任务匹配时，Agent 用 `read`（或 `bash`）加载完整 `SKILL.md`；
4. Agent 按技能指令执行，用相对路径引用脚本和资源。

```text
my-skill/
├── SKILL.md              # 必需：frontmatter + 指令
├── scripts/              # 辅助脚本
│   └── process.sh
├── references/           # 按需加载的详细文档
│   └── api-reference.md
└── assets/
    └── template.json
```

这套机制就是第十站说的"装几十个 Skill 也不撑爆上下文"的实现细节——**只有 description 常驻上下文，完整指令按需加载**。Pi 还兼容 Claude Code / Codex 的技能目录（settings 里加路径即可）。

description 写得好坏直接决定技能何时被触发。规范建议写得具体：

```yaml
# 好：
description: Extracts text and tables from PDF files, fills PDF forms, and merges multiple PDFs. Use when working with PDF documents.

# 差：
description: Helps with PDFs.
```

### 7. 安全模型：诚实到"反直觉"的程度

Pi 的安全文档开头就坦白：**Pi 没有内置沙箱**。它以启动用户的权限运行，用户可写的文件都在同一信任边界内。

更值得咀嚼的是它给出的理由：

> 一个部分的进程内沙箱很容易被误解为安全边界，但它仍然依赖宿主 shell、文件系统、包管理器、凭证和扩展代码。真正的隔离必须来自操作系统或虚拟化/容器边界。

所以 Pi 的安全设计分两层：

**项目信任（Project Trust）**：控制是否加载项目本地的 settings、扩展、技能、提示词模板——防止一个仓库在你不知情时改掉你的 Pi 配置。首次进入含 `.pi/` 资源的项目会询问（存到 `~/.pi/agent/trust.json`），这解决的是"配置投毒"，不是"模型作恶"。

**容器化隔离**：真正要跑不可信代码或无人值守任务时，用三种方案之一——Gondolin 扩展（宿主跑 pi，工具执行路由进本地 Linux 微虚拟机）、纯 Docker（整个 pi 进程进容器）、OpenShell（策略沙箱）。

文档甚至明说：来自仓库文件、注释、文档的提示词注入是"预期的本地 Agent 风险"，Pi 无法可靠阻止——这种把边界说清楚的诚实，比"我们很安全"的营销话术更值得学。

### 8. 极简主义真的有效吗？让数据说话

温叙提醒陆则："哲学讲得再好听，也要看实测。"

Mario 在 2025 年 11 月那篇博客里就做过一次实测：用 **Claude Opus 4.5** 跑 **Terminal-Bench 2.0**，每个任务五轮取平均，结果提交给了官方榜单。至于 Pi 自己跑了多少分，他没在正文里写数字——数据和提交用的 `results.json` 都放在截图里，正文只留了一句提醒：基准测试并不代表真实使用体验。

但那篇博客最有价值的不是自己的名次，而是他顺手指出的一个现象：**Terminus 2 排在前列**。Terminus 2 是 Terminal-Bench 团队自己写的极简 Agent，"本质就是一个裸 tmux 会话，没有任何专用文件工具"。如果前沿模型连这种脚手架都能打，那"堆工具、堆提示词"就不是取胜的必要条件。

官方榜单本身也印证了同一个判断：**榜单只记录"模型 + harness"的组合，从不单独给模型排名**。同一个 Claude Opus 4.6，挂在几乎不带专用工具的 Terminus 2 上是 62.9%，挂在 Meta-Harness 上却是 76.4%——十几个点的差距，全部来自脚手架。反过来看，Terminus 2 这种"裸 tmux 会话"能稳稳压住一大半精心打磨过的 harness，也说明工具数量与提示词长度从来不是分数的唯一来源。

不过陆则也看清了硬币的另一面：**极简不是免费午餐**。榜单头部仍然被专门优化的 harness 占据（Codex CLI 一类），复杂工具链带来的稳定收益客观存在。Pi 的选择不是去争这个头部，而是把省下来的上下文预算全部留给项目代码——它赌的是模型能力继续上涨，而不是脚手架继续加厚。

对个人开发者更有参考价值的，是 **DEV Community 上对 Pi v0.84.2 的评测**（2026 年 8 月）。评测者逐项打分：

| 评测维度 | 得分 | 说明 |
| --- | --- | --- |
| 扩展性 | 10/10 | TypeScript 扩展可以改工具、事件、上下文和 UI |
| 架构清晰度 | 9/10 | 核心小，扩展点异常清楚 |
| 模型灵活性 | 9/10 | 提供商覆盖广，切模型方便 |
| 会话树 | 9/10 | 树形会话让试验变得自然 |
| 初次上手 | 8/10 | 起步容易，进阶需要技术信心 |
| 团队治理 | 6/10 | 能力都能造，但刻意不内置 |
| 安全默认值 | 5/10 | 无内置沙箱与完整权限边界 |
| **总评** | **8.4/10** | 不是各项平均，而是编辑结论 |

结论一针见血：

> Pi 最大的弱点与最大的强项是同一件事：**它不替你完成 Agent**。

评测者还点出了那笔"隐形的 Pi 税"：你换来了对 harness 的完全掌控，代价是这份掌控要自己维护。对个人开发者，它是「可编程的 Agent 实验室」；对想要开箱即用权限体系、subagent、hooks 的团队，Claude Code 这类「托管型 Agent 产品」可能更合适——评测者甚至建议两者共存：Claude Code 当日常主力，Pi 当实验室。

### 9. 生态的另一面：Mario 说不做，社区照样造

第十一站讲的「被简化的功能」清单（Plan Mode、Sub-agents、MCP），社区用行动补齐了另一面——**Mario 说不做，并不妨碍别人用扩展 API 做**：

- 有开发者写了 subagents 扩展，通过 Pi 的扩展 API 加上了子智能体能力；
- 有人写了 interactive-shell 扩展补足交互式命令场景；
- `pi-autoresearch`（第十站介绍过的 Shopify 自动优化循环）证明扩展 API 强到能承载完整产品级功能；
- 甚至有 Skills 用 frontmatter 的 `model` 和 `thinking` 字段做「技能驱动的模型路由」：加载 explore 技能切到便宜的全景模型，加载 build 技能切到精确的编码模型——而且实现者诚实标注了它的边界：这是**被动**的路由，Pi 仍然自己决定加载哪个技能，包不猜你的意图。「路由靠猜」正是 Pi 存在要避免的隐藏魔法。

这正是极简哲学的完整闭环：**核心拒绝的功能，扩展生态可以自由补齐；而因为核心足够小，这些补齐的能力你都能在一下午里读完源码**。重型 harness 的功能要等厂商排期，这里的同等能力只是一个能一行安装的 package。

### 10. 供应链加固：把依赖当受审代码

源码仓库里还有一块容易忽略的工程亮点：Pi 把 npm 依赖变更当作**受审的代码变更**对待——

- 直接外部依赖锁定精确版本；
- `.npmrc` 设 `save-exact=true` 和 `min-release-age=2`（避免装上当天刚发布的依赖）；
- 发布的 CLI 包带 shrinkwrap 钉死传递依赖；
- 依赖生命周期脚本有显式白名单，新的脚本类依赖不审查就无法通过检查；
- 定期跑 `npm audit` 与签名校验。

对一个每天被 `curl | sh` 安装的工具来说，这套供应链纪律本身就是设计哲学的一部分：**极简不等于随意，连依赖都要极简且受控。**

---

## 第十二站：验收会——把底层原理讲给客户听

一周后，「鲸购」的客户评审会。

还是那个登录锁定需求，这次陆则让 Pi 先读项目结构、搜索登录相关代码、形成方案再动手；改完模型跑迁移，改完逻辑跑单元测试，一步一验证；最后把 Git Diff 和测试报告一起放到客户面前，风险点单独标注。

客户技术负责人看完，问的还是那三个问题：改了哪些文件、怎么保证没改坏、测试失败怎么办。这一次，陆则一条条答了上去。

散会后他在笔记里写下这周最深的体会：

早期 AI 编程工具解决的是"下一行代码应该写什么"，AI Agent 解决的是"为了完成这个开发目标，下一步应该做什么"。前者的竞争是生成速度，后者的竞争是稳定性：

- 能否理解大型代码库；
- 能否跨多个文件完成修改；
- 能否正确使用项目工具链；
- 能否从真实报错中恢复；
- 能否控制修改范围；
- 能否给出可审查、可回滚的结果；
- 能否在安全边界内持续运行。

真正有价值的智能体，不是一次写出几百行代码，而是能在复杂环境中持续减少不确定性。

---

## 结语：AI 写代码，本质上是一个"受约束的自动试错系统"

回到最初的问题：AI Agent 为什么能把代码真正写进项目？

答案可以浓缩成一句话：

> 大模型根据目标做决策，工具替它执行操作，环境返回真实结果，系统再把结果交给模型继续修正。

它看起来像一个会自主工作的程序员，是因为这个循环运行得足够快、足够连续，也足够像人类解决问题的过程。

但不要忘记，大模型的每一步仍然可能出错。

AI Agent 的可靠性，不来自"模型永远正确"，而来自另一种思路：

> 允许它犯错，但必须让错误尽快暴露；允许它尝试，但必须限制尝试的边界；允许它自主行动，但必须用测试、权限和人工审查约束结果。

理解这一点，也就理解了 AI Agent 编程的真正底层逻辑。

它不是魔法，也不是简单的代码生成。

它是一套由模型、工具、上下文、记忆、反馈和安全机制共同组成的软件工程系统。

> Agent 编程的难点，从来不是"让 AI 写出代码"，而是你能否说清：它看见了什么、改了什么、怎么验证、边界在哪里。

「鲸购」的项目验收通过了，虹桥软件把 Agent 协作规范写进了团队 wiki。而 Pi 的启示也留在了那一页：不是功能越多越好，把核心的东西做到位就行。

---

## 参考资料

- [智能体（AI Agent）编程的底层原理 - 微信文章](https://mp.weixin.qq.com/s/Q2Fkkp8GrJ49SUeczrjZUQ)
- [一文吃透 Pi：10w+ stars 的极简 Agent harness - 微信文章](https://mp.weixin.qq.com/s/uW6RmcPD0pC3FzswY4xyfA)
- [Pi 官方文档](https://pi.dev/docs/latest)
- [Pi GitHub 仓库](https://github.com/earendil-works/pi)
- [pi-agent-core README（Agent 循环与事件流）](https://github.com/earendil-works/pi/tree/main/packages/agent)
- [Sessions（树形会话）](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/sessions.md)
- [Compaction（上下文压缩）](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/compaction.md)
- [Extensions（扩展与事件系统）](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/extensions.md)
- [Skills（渐进式上下文披露）](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/skills.md)
- [Security（信任模型与沙箱边界）](https://github.com/earendil-works/pi/blob/main/packages/coding-agent/docs/security.md)
- [What I learned building an opinionated and minimal coding agent - Mario Zechner](https://mariozechner.at/posts/2025-11-30-pi-coding-agent/)
- [Building pi in a World of Slop - AI Engineer 大会演讲](https://ai.engineer/talks/pi-coding-agent)
- [Terminal-Bench 2.0 官方榜单](https://www.tbench.ai/leaderboard/terminal-bench/2.0)
- [Autoresearch isn't just for training models - Shopify Engineering](https://shopify.engineering/autoresearch)
- [Pi: The Coding Agent Built Around What It Won't Do - Rushi's](https://www.rushis.com/pi-the-coding-agent-built-around-what-it-wont-do/)
- [Pi Coding Agent Review: Minimal, Hackable AI Coding CLI - DEV Community](https://dev.to/rosgluk/pi-coding-agent-review-minimal-hackable-ai-coding-cli-4ge8)

Pi 的版本、模型目录与扩展生态更新很快（本文源码分析对应仓库 v0.85.x，评测数据来自 2026 年 8 月）。正式升级或迁移前，应以对应版本的官方文档与发布说明为准。
