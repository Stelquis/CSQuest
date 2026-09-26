# [React 从入门到精通：一篇文章掌握现代前端开发](https://mp.weixin.qq.com/s/HmZlvHB9MIbjRGmBpOUJTA)

> 这是一个关于“拾光待办”的故事——一个三人小团队，和他们的前端工程师林一舟从“三千行 jQuery 乱麻”到“一套现代 React 工程体系”的完整旅程。你会跟着林一舟一起，把组件、JSX、状态、Hooks、数据请求、性能优化、测试与工程实践一条条打通，最后亲手做出那个完整的待办应用。读完之后你会发现：React 的 API 并不多，难的从来不是 API，而是组件思维、状态思维和数据流思维——而这三样，是可以被一个真实项目练出来的。

---

## 故事的起点：发布日前夜，一次按钮引发的雪崩

“拾光工作室”是三个年轻人的小团队，做一款叫“拾光待办”的任务管理产品。林一舟是团队里唯一的前端，产品最初的界面，是他用 jQuery 一行一行堆出来的：一个 `index.js` 三千多行，八个 `data-*` 属性手工同步状态，改一处按钮颜色要在四个文件里搜半天。

产品要上线的前一晚，运营临时提了个需求：“筛选按钮旁边加个小圆点，显示未完成任务数。”

林一舟心想，这还不简单。他在三个地方各加了一段 DOM 更新代码，然后:

- 完成任务的勾选框，点一下数字加了两次；
- 搜索框一输入，筛选状态莫名其妙被清空；
- 本地保存的任务列表，偶尔少一条。

凌晨两点，他盯着那个三十二个 `if` 组成的 `syncAllState()` 函数，忽然意识到一件事：**他写的不是界面逻辑，是三百个互相踩脚的定时炸弹。**

第二天，合伙人老程看了他半小时，没有让他改 bug，而是说了一句：

> 你现在是在“命令”浏览器每一步怎么动。React 的思路是反过来的——你只描述“某种状态下界面应该长什么样”，剩下的交给它。

老程给他定了个目标：**用 React 把“拾光待办”重写一遍，从第一行代码到上线。**

这个故事，就是这次重写走完的完整路线图。

---

## 第 1 站：为什么是 React——从“命令浏览器”到“描述界面”

周一早上，老程在白板上写下重写的第一个理由。他先让林一舟回顾了旧版“拾光待办”里那些网页早已不只“展示文字和图片”的场景：

- 实时搜索与筛选；
- 表单校验和提交；
- 登录状态与权限；
- 多页面路由；
- 服务端数据缓存；
- 异步加载和错误恢复；
- 大量组件之间的协作；
- 桌面端、移动端和服务端渲染。

“直接用原生 DOM API，交互一复杂，代码就变成事件监听器、DOM 查询和状态变量互相缠绕——你那三千行 `index.js` 就是活教材。”老程说，“React 提供的是另一种思路：**你只需要描述‘某种状态下界面应该长什么样’，React 负责把状态变化同步到界面。**”

React 的三个核心关键词，老程一个个写在白板上：

1. **组件化**：把界面拆成独立、可复用的组件；
2. **声明式**：描述结果，而不是手动编排每一步 DOM 操作；
3. **单向数据流**：数据主要从父组件流向子组件，行为更容易推理。

截至本文写作时，React 官方文档展示的稳定主线为 React 19.2。React 19 引入了 Actions、`useActionState`、`useOptimistic` 等能力，React 19.2 又加入了 `<Activity>`、`useEffectEvent` 等特性，现代 React 还可以配合 React Compiler 自动完成部分记忆化优化。这些后面都会讲到，但老程先立了一条规矩：**先学原则，再追新特性。**

散会前老程问林一舟：“React 是 JavaScript 的替代品吗？”林一舟想了想答：“不是，它是建立在 JavaScript 之上的 UI 库。”老程点头，顺手在白板上列了学前自检清单：

- **HTML 与 CSS**：常见语义化标签、表单元素、Flexbox 和 Grid、响应式布局、盒模型和定位；
- **现代 JavaScript**：变量与常量、解构、展开运算符、数组方法、模块、异步：

```js
// 变量与常量
const name = 'React';
let count = 0;

// 解构
const user = { id: 1, nickname: 'Tiger' };
const { id, nickname } = user;

// 展开运算符
const nextUser = { ...user, nickname: 'React Learner' };

// 数组方法
const numbers = [1, 2, 3];
const doubled = numbers.map((number) => number * 2);
const even = numbers.filter((number) => number % 2 === 0);

// 模块
export function add(a, b) {
  return a + b;
}
import { add } from './math.js';

// 异步
async function loadData() {
  const response = await fetch('/api/data');
  return response.json();
}
```

- **TypeScript**：不是硬性前置条件，但在中大型项目里非常推荐——它能提前发现属性拼写错误、数据结构不一致和空值处理问题。

“清单里有缺的先补，”老程说，“然后建项目。”

## 第 2 站：第一行代码——用 Vite 搭起“拾光待办”的骨架

React 官方建议：构建完整生产应用时优先选择成熟的 React 框架；学习 React、构建纯客户端应用或需要自定义技术栈时，用 Vite。“拾光待办”第一版是纯客户端应用，林一舟选择了 **Vite + React + TypeScript**。

先检查环境——Vite 官方文档要求 Node.js `20.19+` 或 `22.12+`，实际开发建议使用仍在维护周期内的 LTS 版本：

```bash
node -v
npm -v
```

然后创建项目：

```bash
npm create vite@latest react-mastery -- --template react-ts
cd react-mastery
npm install
npm run dev
```

浏览器打开终端给出的本地地址，就能看到项目。骨架长这样：

```text
react-mastery/
├── public/
├── src/
│   ├── assets/
│   ├── App.css
│   ├── App.tsx
│   ├── index.css
│   └── main.tsx
├── index.html
├── package.json
├── tsconfig.json
└── vite.config.ts
```

入口文件 `main.tsx` 只有几行，却值得逐行读懂：

```tsx
// src/main.tsx
import { StrictMode } from 'react';
import { createRoot } from 'react-dom/client';
import './index.css';
import App from './App';

createRoot(document.getElementById('root')!).render(
  <StrictMode>
    <App />
  </StrictMode>,
);
```

`createRoot` 创建 React 根节点，`root.render` 把组件树渲染到页面中。老程指着 `<StrictMode>` 说：“记住这个入口的样子，接下来所有的东西——组件、JSX、状态——最终都会从这里长出去。”

---

## 第 3 站：JSX——在 JavaScript 里“描述”界面

重写真正的第一行界面代码，是一个看起来像 HTML 的东西：

```tsx
const element = <h1>Hello React</h1>;
```

“这叫 JSX，”老程说，“看起来像 HTML，本质上是 JavaScript 的语法扩展，构建工具会把它转换为 React 能理解的 JavaScript。”

林一舟把旧版“拾光待办”里最熟的一个个人资料区块翻译成了 JSX：

```tsx
function Profile() {
  const user = {
    name: '小明',
    score: 95,
  };

  return (
    <section>
      <h2>{user.name}</h2>
      <p>成绩：{user.score}</p>
      <p>评价：{user.score >= 90 ? '优秀' : '继续努力'}</p>
    </section>
  );
}
```

花括号里可以放变量、函数调用、三元表达式、数组 `map` 的结果和计算表达式；不能直接放普通 `if`、`for` 语句，但可以在 `return` 前处理。他顺手记下了几条从旧代码迁移时最容易踩的规则：

- **属性名变了**：`class` 写成 `className`，`for` 写成 `htmlFor`，`onclick` 是 `onClick`，`tabindex` 是 `tabIndex`；

```tsx
function Card() {
  return (
    <article className="card">
      <label htmlFor="email">邮箱</label>
      <input id="email" />
    </article>
  );
}
```

- **必须返回单一根节点**。错误的写法直接过不了编译：

```tsx
// 错误
return (
  <h1>标题</h1>
  <p>正文</p>
);
```

```tsx
// 正确：Fragment 不会额外生成 DOM 节点
return (
  <>
    <h1>标题</h1>
    <p>正文</p>
  </>
);
```

- **标签必须闭合**：`<img src=“/logo.svg” alt=“Logo” />`、`<input type=“text” />`。

下午他就被“小写标签”坑了一次：写了个 `function userCard()`，页面上什么都不渲染。老程看了一眼就笑了：“小写开头会被 React 当成原生 HTML 标签。组件命名必须大写开头。”

```tsx
// 错误示例
function userCard() {
  return <div>错误示例</div>;
}
```

```tsx
// 正确示例
function UserCard() {
  return <div>正确示例</div>;
}
```

## 第 4 站：组件与 Props——把三千行拆成一棵树

组件就是返回界面的 JavaScript 函数。老程让林一舟做的第一件事，是把旧版页面最顶上的欢迎语变成组件：

```tsx
function Welcome() {
  return <h1>欢迎学习 React</h1>;
}

function App() {
  return (
    <main>
      <Welcome />
      <Welcome />
    </main>
  );
}
```

“看到 `<Welcome />` 用了两次吗？”老程说，“这就是组件化的第一笔红利。但拆分不是越多越好——**一段 UI 被多次使用、一个区域拥有独立职责、组件代码过长、某部分需要单独测试、某部分拥有独立状态或交互**，满足这些才拆。”

以一个商品页为例，合理的拆分是：

```text
ProductPage
├── Header
├── ProductGallery
├── ProductInfo
│   ├── Price
│   ├── Specification
│   └── BuyButton
├── ReviewList
└── Footer
```

“不要为了‘看起来组件化’而把每一行都拆成组件。拆分的目标是降低认知负担，而不是增加文件数量。”

组件之间怎么传数据？答案叫 **Props**——父组件传给子组件的只读数据：

```tsx
type UserCardProps = {
  name: string;
  age: number;
  isVip?: boolean;
};

function UserCard({ name, age, isVip = false }: UserCardProps) {
  return (
    <article>
      <h2>
        {name}
        {isVip && <span> VIP</span>}
      </h2>
      <p>年龄：{age}</p>
    </article>
  );
}

function App() {
  return <UserCard name="小王" age={20} isVip />;
}
```

老程强调了两条使用纪律：

- **Props 是只读的**。组件需要改变数据时，不要修改 Props，而应通过状态更新函数或回调通知上层：

```tsx
function Counter({ count }: { count: number }) {
  // count += 1; // 错误思路
  return <span>{count}</span>;
}
```

- **用回调把“行为”传下去**：

```tsx
type DeleteButtonProps = {
  onDelete: () => void;
};

function DeleteButton({ onDelete }: DeleteButtonProps) {
  return <button onClick={onDelete}>删除</button>;
}

function App() {
  function handleDelete() {
    console.log('执行删除');
  }

  return <DeleteButton onDelete={handleDelete} />;
}
```

还有一个特殊的 Prop 叫 `children`，它让组件可以包裹任意内容——这是一种非常重要的组合模式：

```tsx
import type { ReactNode } from 'react';

type PanelProps = {
  title: string;
  children: ReactNode;
};

function Panel({ title, children }: PanelProps) {
  return (
    <section className="panel">
      <h2>{title}</h2>
      <div>{children}</div>
    </section>
  );
}

function App() {
  return (
    <Panel title="用户信息">
      <p>用户名：Tiger</p>
      <button>编辑</button>
    </Panel>
  );
}
```

---

## 第 5 站：事件——让界面听懂用户

旧版“拾光待办”里到处是 `addEventListener`，还要人肉记着在页面销毁时解绑。React 把事件变成组件的一个属性：驼峰命名，传入函数。

```tsx
function Button() {
  function handleClick() {
    alert('按钮被点击');
  }

  return <button onClick={handleClick}>点击</button>;
}
```

林一舟第一天就犯了一个经典错误：

```tsx
// 错误：渲染时立即执行函数
<button onClick={handleClick()}>点击</button>
```

“括号一加，函数在渲染时就执行了。”老程提醒道。接着是两个高频场景——传参用箭头函数包一层，事件对象带完整的类型：

```tsx
function ProductList() {
  const products = [
    { id: 1, name: '键盘' },
    { id: 2, name: '鼠标' },
  ];

  function handleBuy(id: number) {
    console.log('购买商品：', id);
  }

  return (
    <ul>
      {products.map((product) => (
        <li key={product.id}>
          {product.name}
          <button onClick={() => handleBuy(product.id)}>购买</button>
        </li>
      ))}
    </ul>
  );
}
```

```tsx
import type { ChangeEvent, FormEvent } from 'react';

function SearchForm() {
  function handleChange(event: ChangeEvent<HTMLInputElement>) {
    console.log(event.target.value);
  }

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    console.log('提交表单');
  }

  return (
    <form onSubmit={handleSubmit}>
      <input onChange={handleChange} />
      <button type="submit">搜索</button>
    </form>
  );
}
```

## 第 6 站：State——组件的“记忆”，也是那次雪崩的病根

重写进行到一半，林一舟忍不住问出了憋了很久的问题：“为什么旧版那个数字会加两次？”老程没有直接回答，先让他看一段“看起来没问题”的代码：

```tsx
function WrongCounter() {
  let count = 0;

  function handleClick() {
    count += 1;
    console.log(count);
  }

  return <button onClick={handleClick}>{count}</button>;
}
```

“控制台里的 `count` 在变，但界面永远不动。普通变量无法让 React 重新渲染。”老程说，“React 用 **State** 保存需要在多次渲染之间保留的数据：”

```tsx
import { useState } from 'react';

function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(count + 1)}>
      点击次数：{count}
    </button>
  );
}
```

调用 `setCount` 之后会发生一串事：

1. React 记录新状态；
2. React 再次调用组件函数；
3. 组件根据新状态生成新的界面描述；
4. React 更新真正需要变化的 DOM。

“**每次渲染都是一次‘快照’。**事件处理函数看到的，是创建它时那次渲染的状态快照。”老程写下了旧版按钮“数字加两次”的同款 bug：

```tsx
function Counter() {
  const [count, setCount] = useState(0);

  function addThreeWrong() {
    setCount(count + 1);
    setCount(count + 1);
    setCount(count + 1);
  }

  return <button onClick={addThreeWrong}>{count}</button>;
}
```

“一次点击通常只增加 1——三次调用看到的 `count` 都是同一个快照。需要基于上一次状态连续更新时，用函数式更新：”

```tsx
function addThree() {
  setCount((current) => current + 1);
  setCount((current) => current + 1);
  setCount((current) => current + 1);
}
```

第三条纪律是**不要直接修改对象和数组**。错误写法：

```tsx
user.name = '新名字';
setUser(user);
```

正确写法：

```tsx
setUser((current) => ({
  ...current,
  name: '新名字',
}));
```

数组同理：

```tsx
setTasks((current) => [...current, newTask]);

setTasks((current) =>
  current.filter((task) => task.id !== id),
);

setTasks((current) =>
  current.map((task) =>
    task.id === id
      ? { ...task, completed: true }
      : task,
  ),
);
```

“React 状态应被视为只读快照。不可变更新让变化更容易追踪，也能帮助性能优化。”林一舟在笔记本上写下一行字：**旧版‘拾光待办’的雪崩，病根就是手工同步三份可变数据。State 把‘数据只有一份’变成语言保证。**

---

## 第 7 站：条件渲染与列表渲染——界面的“分岔路口”

重写筛选功能时，林一舟用上了条件渲染的三种写法。使用 `if`：

```tsx
function Greeting({ loggedIn }: { loggedIn: boolean }) {
  if (!loggedIn) {
    return <button>登录</button>;
  }

  return <p>欢迎回来</p>;
}
```

使用三元表达式：

```tsx
<p>{score >= 60 ? '及格' : '不及格'}</p>
```

使用逻辑与：

```tsx
{isAdmin && <button>管理后台</button>}
```

老程特意圈出一个坑：“当左侧可能是数字 `0` 时，`0 && <Component />` 会把 `0` 渲染出来。更稳妥的写法是显式比较：”

```tsx
{items.length > 0 && <ItemList items={items} />}
```

列表渲染用 `map`：

```tsx
type Todo = {
  id: string;
  title: string;
};

function TodoList({ todos }: { todos: Todo[] }) {
  return (
    <ul>
      {todos.map((todo) => (
        <li key={todo.id}>{todo.title}</li>
      ))}
    </ul>
  );
}
```

“`key` 为什么重要？”老程问。“帮 React 识别列表中每一项的身份。”林一舟答。

“对。推荐使用稳定、唯一的业务 ID：

```tsx
<li key={todo.id}>...</li>
```

不推荐：

```tsx
<li key={Math.random()}>...</li>
```

当列表可能插入、删除或排序时，也不建议直接用数组下标当 key。错误的 key 可能导致输入框内容错位、组件状态串位或不必要的重新创建——旧版‘拾光待办’里‘搜索框一输入列表就乱’，一半是这个原因。”

## 第 8 站：受控表单——登录框的规范化改造

“拾光待办”有个登录框，旧版是各 input 各自为政。React 的做法叫**受控组件**：表单值由 React State 管理。

```tsx
import { useState, type FormEvent } from 'react';

function LoginForm() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');

  function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();

    if (!email.includes('@')) {
      alert('请输入正确邮箱');
      return;
    }

    console.log({ email, password });
  }

  return (
    <form onSubmit={handleSubmit}>
      <label>
        邮箱
        <input
          type="email"
          value={email}
          onChange={(event) => setEmail(event.target.value)}
        />
      </label>

      <label>
        密码
        <input
          type="password"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
        />
      </label>

      <button type="submit">登录</button>
    </form>
  );
}
```

受控表单的优势：可即时校验、可根据状态禁用按钮、可统一重置、可实现联动、数据来源明确。字段多时用对象统一管理：

```tsx
const [form, setForm] = useState({
  email: '',
  password: '',
});

function updateField(
  event: React.ChangeEvent<HTMLInputElement>,
) {
  const { name, value } = event.target;

  setForm((current) => ({
    ...current,
    [name]: value,
  }));
}
```

## 第 9 站：状态放哪里？——比记 API 更重要的设计题

“Hook API 一个下午就能背完，”老程说，“但**状态设计**决定了项目三个月后还能不能维护。”

**第一，就近放置。**只被一个组件使用的状态，就放在该组件中。

**第二，状态提升。**两个组件需要共享同一份状态时，把它移到最近的共同父组件。林一舟用温度输入框练了手：

```tsx
import { useState } from 'react';

function TemperatureInput({
  value,
  onChange,
}: {
  value: string;
  onChange: (value: string) => void;
}) {
  return (
    <input
      value={value}
      onChange={(event) => onChange(event.target.value)}
    />
  );
}

function App() {
  const [temperature, setTemperature] = useState('');

  return (
    <>
      <TemperatureInput
        value={temperature}
        onChange={setTemperature}
      />
      <p>当前温度：{temperature || '--'}℃</p>
    </>
  );
}
```

**第三，避免冗余状态。**能计算出来的数据，不要重复存一份：

```tsx
// 错误：fullName 是冗余状态
const [firstName, setFirstName] = useState('张');
const [lastName, setLastName] = useState('三');
const [fullName, setFullName] = useState('张三');
```

```tsx
// 正确：渲染时计算
const fullName = `${firstName}${lastName}`;
```

**第四，避免互相矛盾的状态。**三个布尔值可能同时为真：

```tsx
// 错误：isLoading / isSuccess / isError 可能同时为 true
const [isLoading, setIsLoading] = useState(false);
const [isSuccess, setIsSuccess] = useState(false);
const [isError, setIsError] = useState(false);
```

更合理的是用一个互斥的状态机：

```tsx
type Status = 'idle' | 'loading' | 'success' | 'error';
const [status, setStatus] = useState<Status>('idle');
```

林一舟看着自己的旧代码感叹：“三千行里有八百行，是在维护这些互相矛盾的布尔值。”

---

## 第 10 站：Hooks 全面解析（上）——规则与四大基础 Hook

“Hooks 让函数组件用上状态、上下文、引用和副作用这些 React 能力，”老程说，“但先背两条铁律：”

1. 只在 React 函数组件或自定义 Hook 中调用；
2. 只在顶层调用，不要放进条件、循环或嵌套函数。

“为什么？”林一舟问。“因为 React 靠调用顺序识别每个 Hook。放进条件里，顺序一乱，状态就串了。”

**`useState`：简单状态。**适合输入框、开关、当前选中项、简单对象和小型局部状态：

```tsx
const [open, setOpen] = useState(false);
```

**`useReducer`：复杂状态转换。**当状态逻辑较复杂、多个字段一起变化或更新类型较多时使用。它的价值不是“比 useState 高级”，而是**把“发生了什么”和“状态如何变化”分离**：

```tsx
import { useReducer } from 'react';

type State = {
  count: number;
};

type Action =
  | { type: 'increment' }
  | { type: 'decrement' }
  | { type: 'reset'; value: number };

function reducer(state: State, action: Action): State {
  switch (action.type) {
    case 'increment':
      return { count: state.count + 1 };
    case 'decrement':
      return { count: state.count - 1 };
    case 'reset':
      return { count: action.value };
    default:
      return state;
  }
}

function Counter() {
  const [state, dispatch] = useReducer(reducer, { count: 0 });

  return (
    <>
      <p>{state.count}</p>
      <button onClick={() => dispatch({ type: 'decrement' })}>-</button>
      <button onClick={() => dispatch({ type: 'increment' })}>+</button>
      <button onClick={() => dispatch({ type: 'reset', value: 0 })}>
        重置
      </button>
    </>
  );
}
```

**`useContext`：跨层共享数据。**主题、语言、登录用户这类数据需要跨越多层组件传递时使用：

```tsx
import {
  createContext,
  useContext,
  useState,
  type ReactNode,
} from 'react';

type Theme = 'light' | 'dark';

type ThemeContextValue = {
  theme: Theme;
  toggleTheme: () => void;
};

const ThemeContext = createContext<ThemeContextValue | null>(null);

function ThemeProvider({ children }: { children: ReactNode }) {
  const [theme, setTheme] = useState<Theme>('light');

  function toggleTheme() {
    setTheme((current) => (
      current === 'light' ? 'dark' : 'light'
    ));
  }

  return (
    <ThemeContext value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext>
  );
}

function useTheme() {
  const value = useContext(ThemeContext);

  if (!value) {
    throw new Error('useTheme 必须在 ThemeProvider 内使用');
  }

  return value;
}
```

在 React 19 中可以直接使用 `<ThemeContext value={value}>{children}</ThemeContext>`；旧项目里常见的 `<ThemeContext.Provider>` 仍需根据项目版本和代码风格处理。老程补了一句警告：“Context 不应被当作所有状态的默认容器。频繁变化的大对象放进顶层 Context，可能导致大量消费者重新渲染。”

**`useRef`：保存可变值或访问 DOM。**修改 `ref.current` 不会触发重新渲染。访问 DOM：

```tsx
import { useRef } from 'react';

function SearchBox() {
  const inputRef = useRef<HTMLInputElement>(null);

  return (
    <>
      <input ref={inputRef} />
      <button onClick={() => inputRef.current?.focus()}>
        聚焦输入框
      </button>
    </>
  );
}
```

保存计时器、上一次值或外部实例：

```tsx
const timerRef = useRef<number | null>(null);
```

“记住：不要用 Ref 保存‘应该显示在页面上的数据’。界面数据用 State。”

## 第 11 站：Hooks 全面解析（下）——useEffect 与它的三个伙伴

“`useEffect` 最常被误解，”老程说，“它不是‘组件加载后执行代码’。更准确的理解是：**Effect 用于让组件与 React 之外的系统保持同步。**”

外部系统包括网络连接、浏览器事件、定时器、DOM API、第三方组件、本地存储、地图或播放器实例：

```tsx
import { useEffect } from 'react';

function OnlineStatus() {
  useEffect(() => {
    function handleOnline() {
      console.log('网络恢复');
    }

    window.addEventListener('online', handleOnline);

    return () => {
      window.removeEventListener('online', handleOnline);
    };
  }, []);

  return null;
}
```

返回函数是清理逻辑。依赖数组决定何时重新同步：

```tsx
useEffect(() => {
  connect(roomId);
  return () => disconnect(roomId);
}, [roomId]);
```

- 不写依赖数组：每次渲染后执行；
- `[]`：组件挂载后执行，并在卸载时清理；
- `[roomId]`：`roomId` 变化后重新同步。

“不要为了‘让 Effect 少执行’而随意删除依赖。依赖反映了 Effect 使用的响应式值。”老程接着展示了最常见的误用——下面这种写法是多余的：

```tsx
const [fullName, setFullName] = useState('');

useEffect(() => {
  setFullName(`${firstName}${lastName}`);
}, [firstName, lastName]);
```

```tsx
// 直接计算即可
const fullName = `${firstName}${lastName}`;
```

“事件导致的操作，放在事件处理函数里，而不是先改一个状态再让 Effect 猜用户做了什么。”

**`useEffectEvent`（React 19.2）：把“事件逻辑”从 Effect 中分离。**它在 Effect 内读取最新值，同时避免把本不该触发重新连接的值加进依赖：

```tsx
import { useEffect, useEffectEvent } from 'react';

function ChatRoom({
  roomId,
  theme,
}: {
  roomId: string;
  theme: string;
}) {
  const onConnected = useEffectEvent(() => {
    console.log(`已连接，当前主题：${theme}`);
  });

  useEffect(() => {
    const connection = createConnection(roomId);

    connection.on('connected', () => {
      onConnected();
    });

    connection.connect();

    return () => connection.disconnect();
  }, [roomId]);

  return null;
}
```

“切换主题不需要断开重连聊天室，但连接成功时仍能读到最新主题。注意：`useEffectEvent` 不是‘逃避依赖数组’的工具，只应用于真正由 Effect 触发的事件逻辑。”

剩下三个和性能有关。**`useMemo` 缓存计算结果**：

```tsx
import { useMemo } from 'react';

const visibleProducts = useMemo(() => {
  return products.filter((product) =>
    product.name.toLowerCase().includes(keyword.toLowerCase()),
  );
}, [products, keyword]);
```

适合确实昂贵的计算、需要稳定对象引用传给已优化子组件、依赖不变时复用结果的场景。“不要给每个计算都套 `useMemo`。记忆化本身也有成本，并会增加代码复杂度。”

**`useCallback` 缓存函数引用**，通常与 `memo` 或依赖稳定性配合，而不是“性能优化必写项”：

```tsx
import { useCallback } from 'react';

const handleDelete = useCallback((id: string) => {
  setTasks((current) =>
    current.filter((task) => task.id !== id),
  );
}, []);
```

**`memo` 跳过不必要的子组件渲染**——只有 Props 没变化时才有机会跳过：

```tsx
import { memo } from 'react';

type ItemProps = {
  title: string;
};

const Item = memo(function Item({ title }: ItemProps) {
  return <li>{title}</li>;
});
```

“使用前先用 React DevTools Profiler 确认真正的瓶颈，不要凭感觉优化。”

老程还提了 **React Compiler 1.0**：它已稳定发布，是构建时优化工具，能自动分析组件和 Hooks，完成部分原本需要手写 `useMemo`、`useCallback`、`memo` 的优化。但它不意味着可以忽略基本原则：组件和 Hook 必须保持纯函数、不要在渲染期间产生副作用、不要直接修改 Props/State/上下文值、遵守 Hooks 规则、保持数据流清晰。“自动优化修复不了错误的状态设计和混乱的组件边界。”

最后是**自定义 Hook**：名字必须以 `use` 开头，复用的是逻辑而非 State 本身——每次调用都会拥有独立状态：

```tsx
import { useEffect, useState } from 'react';

function useOnlineStatus() {
  const [online, setOnline] = useState(navigator.onLine);

  useEffect(() => {
    const handleOnline = () => setOnline(true);
    const handleOffline = () => setOnline(false);

    window.addEventListener('online', handleOnline);
    window.addEventListener('offline', handleOffline);

    return () => {
      window.removeEventListener('online', handleOnline);
      window.removeEventListener('offline', handleOffline);
    };
  }, []);

  return online;
}

function StatusBadge() {
  const online = useOnlineStatus();

  return (
    <span>
      {online ? '在线' : '离线'}
    </span>
  );
}
```

---

## 第 12 站：数据请求——从“能用”到“工程化”

待办应用要拉取云端任务列表了。林一舟写的第一个版本，在 Effect 里发请求：

```tsx
import { useEffect, useState } from 'react';

type User = {
  id: number;
  name: string;
};

function UserList() {
  const [users, setUsers] = useState<User[]>([]);
  const [status, setStatus] = useState<
    'idle' | 'loading' | 'success' | 'error'
  >('idle');
  const [error, setError] = useState('');

  useEffect(() => {
    const controller = new AbortController();

    async function loadUsers() {
      setStatus('loading');
      setError('');

      try {
        const response = await fetch('/api/users', {
          signal: controller.signal,
        });

        if (!response.ok) {
          throw new Error(`请求失败：${response.status}`);
        }

        const data: User[] = await response.json();

        setUsers(data);
        setStatus('success');
      } catch (reason) {
        if (reason instanceof DOMException &&
            reason.name === 'AbortError') {
          return;
        }

        setError(
          reason instanceof Error
            ? reason.message
            : '未知错误',
        );
        setStatus('error');
      }
    }

    loadUsers();

    return () => {
      controller.abort();
    };
  }, []);

  if (status === 'loading') {
    return <p>加载中……</p>;
  }

  if (status === 'error') {
    return <p role="alert">{error}</p>;
  }

  return (
    <ul>
      {users.map((user) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

“这一个例子处理了加载状态、HTTP 错误、异常信息、组件卸载时取消请求和列表 key，”老程说，“但真实应用还需要缓存、去重、失效重取、重试、分页、乐观更新、后台刷新、服务端渲染与预取、并发请求协调——这些属于‘**服务端状态管理**’，不该到处手写请求 Effect。可以用框架的数据加载能力，或 TanStack Query 这类专门工具：”

```tsx
import { useQuery } from '@tanstack/react-query';

type User = {
  id: number;
  name: string;
};

async function fetchUsers(): Promise<User[]> {
  const response = await fetch('/api/users');

  if (!response.ok) {
    throw new Error('获取用户失败');
  }

  return response.json();
}

function UserList() {
  const {
    data = [],
    isPending,
    error,
  } = useQuery({
    queryKey: ['users'],
    queryFn: fetchUsers,
  });

  if (isPending) {
    return <p>加载中……</p>;
  }

  if (error) {
    return <p role="alert">{error.message}</p>;
  }

  return (
    <ul>
      {data.map((user) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}
```

“关键认识只有一句：**本地 UI 状态和服务端状态不是同一种问题。**输入框内容、弹窗开关属于本地状态；API 数据需要缓存、同步和失效策略。”

## 第 13 站：React 19 的三件新武器——useTransition、useActionState 与乐观更新

“React 19 强化了‘异步操作’的表达方式，”老程说，“先看 `useTransition`——把某些状态更新标记为非阻塞更新，并提供等待状态。”

搜索框是典型场景：输入值需要立即响应，较重的结果更新可以降低优先级：

```tsx
import { useState, useTransition } from 'react';

function SearchPage() {
  const [input, setInput] = useState('');
  const [keyword, setKeyword] = useState('');
  const [isPending, startTransition] = useTransition();

  function handleChange(value: string) {
    setInput(value);

    startTransition(() => {
      setKeyword(value);
    });
  }

  const results = searchLargeList(keyword);

  return (
    <>
      <input
        value={input}
        onChange={(event) => handleChange(event.target.value)}
      />

      {isPending && <p>正在更新结果……</p>}

      <ResultList results={results} />
    </>
  );
}
```

**`useActionState`** 适合管理 Action 的结果和等待状态（具体可用方式取决于客户端架构或全栈框架支持）：

```tsx
import { useActionState } from 'react';

type FormState = {
  message: string;
};

async function saveName(
  previousState: FormState,
  formData: FormData,
): Promise<FormState> {
  const name = String(formData.get('name') ?? '').trim();

  if (name.length < 2) {
    return { message: '名字至少需要两个字符' };
  }

  await updateUserName(name);

  return { message: '保存成功' };
}

function ProfileForm() {
  const [state, formAction, isPending] = useActionState(
    saveName,
    { message: '' },
  );

  return (
    <form action={formAction}>
      <input name="name" />
      <button disabled={isPending}>
        {isPending ? '保存中……' : '保存'}
      </button>
      <p aria-live="polite">{state.message}</p>
    </form>
  );
}
```

**`useOptimistic`** 是林一舟最喜欢的：先假设操作会成功，立即更新界面；失败后再回滚或提示：

```tsx
import { useOptimistic, startTransition } from 'react';

type Message = {
  id: string;
  text: string;
  sending?: boolean;
};

function MessageList({
  messages,
  sendMessage,
}: {
  messages: Message[];
  sendMessage: (text: string) => Promise<void>;
}) {
  const [optimisticMessages, addOptimisticMessage] =
    useOptimistic(
      messages,
      (current, text: string) => [
        ...current,
        {
          id: crypto.randomUUID(),
          text,
          sending: true,
        },
      ],
    );

  function handleSend(text: string) {
    startTransition(async () => {
      addOptimisticMessage(text);
      await sendMessage(text);
    });
  }

  return (
    <>
      <ul>
        {optimisticMessages.map((message) => (
          <li key={message.id}>
            {message.text}
            {message.sending && '（发送中）'}
          </li>
        ))}
      </ul>

      <button onClick={() => handleSend('你好')}>
        发送
      </button>
    </>
  );
}
```

“乐观更新必须设计失败策略，”老程提醒，“否则用户会看到‘成功假象’。”

## 第 14 站：Activity 与路由——切页不丢状态

重写侧边栏时，林一舟遇到一个老问题：旧版切换侧边栏会把输入内容清空。React 19.2 的 `<Activity>` 解决了它——控制一部分界面的可见性和优先级：

```tsx
import { Activity } from 'react';

function Dashboard({
  showSidebar,
}: {
  showSidebar: boolean;
}) {
  return (
    <Activity mode={showSidebar ? 'visible' : 'hidden'}>
      <Sidebar />
    </Activity>
  );
}
```

与简单条件渲染 `{showSidebar && <Sidebar />}` 相比：条件渲染会卸载组件并丢失其局部状态；隐藏 Activity 可以保留状态，并在重新显示时恢复，隐藏期间相关 Effect 会被清理。适用场景：标签页切换、侧边栏、暂时隐藏但希望保留输入状态的面板、预渲染可能很快展示的内容。

React 本身专注 UI，不内置完整路由，实际项目通常使用 React Router 或全栈框架自带路由。路由负责 URL 与页面组件映射、嵌套路由、路由参数、导航、404、数据加载和权限控制。一个简化的 React Router 示例：

```tsx
import {
  createBrowserRouter,
  RouterProvider,
} from 'react-router-dom';
import HomePage from './pages/HomePage';
import UserPage from './pages/UserPage';
import NotFoundPage from './pages/NotFoundPage';

const router = createBrowserRouter([
  {
    path: '/',
    element: <HomePage />,
  },
  {
    path: '/users/:userId',
    element: <UserPage />,
  },
  {
    path: '*',
    element: <NotFoundPage />,
  },
]);

export default function App() {
  return <RouterProvider router={router} />;
}
```

“路由不是简单‘切换组件’。生产项目还要考虑刷新页面时服务器回退、页面级代码分割、路由级错误边界这些事。”老程说。

---

## 第 15 站：TypeScript 正确配合——让类型替你守住数据流

“拾光待办”是 TS 项目，类型和 React 的配合有四招。**第一，组件 Props 用类型建模，默认值写进解构：**

```tsx
type ButtonProps = {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary';
  disabled?: boolean;
  onClick?: () => void;
};

function Button({
  children,
  variant = 'primary',
  disabled = false,
  onClick,
}: ButtonProps) {
  return (
    <button
      className={`button button--${variant}`}
      disabled={disabled}
      onClick={onClick}
    >
      {children}
    </button>
  );
}
```

**第二，原生元素属性透传**——想包一层 `input` 又不想丢掉原生属性时：

```tsx
import type {
  ComponentPropsWithoutRef,
} from 'react';

type InputProps =
  ComponentPropsWithoutRef<'input'> & {
    label: string;
  };

function Input({
  label,
  id,
  ...inputProps
}: InputProps) {
  return (
    <label htmlFor={id}>
      {label}
      <input id={id} {...inputProps} />
    </label>
  );
}
```

**第三，用联合类型建模状态**，每种状态拥有明确字段，减少非法组合：

```tsx
type RequestState<T> =
  | { status: 'idle' }
  | { status: 'loading' }
  | { status: 'success'; data: T }
  | { status: 'error'; error: string };
```

**第四，不要滥用 `any`。**它会关闭类型检查；无法确定类型时优先用 `unknown` 并缩小范围：

```tsx
function getErrorMessage(error: unknown) {
  if (error instanceof Error) {
    return error.message;
  }

  return '未知错误';
}
```

## 第 16 站：样式方案怎么选——没有最流行，只有最合适

React 不强制样式方案，老程把常见选择摆在一起对比。普通 CSS（`import './Button.css'`）适合中小项目和简单组件；CSS Modules 类名局部化、减少冲突：

```tsx
import styles from './Button.module.css';

function Button() {
  return (
    <button className={styles.button}>
      保存
    </button>
  );
}
```

Utility-first CSS（如 Tailwind CSS）适合希望快速搭建一致设计系统的团队；CSS-in-JS 适合动态主题或组件库，但要关注运行时成本、服务端渲染和工具链兼容性。

“选择标准不是‘哪个最流行’，而是：团队熟悉度、设计系统需求、构建和运行时成本、服务端渲染、可维护性、调试体验。”

## 第 17 站：性能优化——先测量，再优化

重写基本完成，林一舟想一波优化到位，被老程拦住了。“React 性能问题通常来自这些地方，先对照排查：”

- 组件树过大；
- 不合理的全局状态；
- Context 值频繁变化；
- 大列表一次性渲染；
- 昂贵计算重复执行；
- 请求瀑布；
- Bundle 过大；
- 不必要的 Effect；
- 错误 key 导致组件反复重建。

对应的第一批手段是原则性的：

1. **保持状态局部化**——不要把所有状态都塞进全局 Store；
2. **让组件保持纯净**——同样的 Props 和 State 应产生同样的 JSX，渲染中不要修改外部变量、发起请求、操作 DOM、写本地存储、启动定时器；
3. **使用代码分割**：

```tsx
import { lazy, Suspense } from 'react';

const AdminPage = lazy(() => import('./AdminPage'));

function App() {
  return (
    <Suspense fallback={<p>页面加载中……</p>}>
      <AdminPage />
    </Suspense>
  );
}
```

4. **大列表虚拟化**——列表成千上万项时只渲染可视区域，而不是同时创建全部 DOM；
5. **用 Profiler 找瓶颈**——React DevTools Profiler 能看到哪些组件重新渲染、每次提交耗时、为什么组件更新、优化是否真的有效；
6. **手动记忆化不是默认答案**——`memo`、`useMemo`、`useCallback` 不是越多越好，优先处理错误状态建模、过大的组件、过宽的 Context、不必要的 Effect、大量 DOM、请求与 Bundle 问题，最后才考虑局部记忆化。

## 第 18 站：错误边界——上线前的保险丝

渲染过程中抛出的错误需要错误边界兜底。传统错误边界通常使用类组件：

```tsx
import {
  Component,
  type ErrorInfo,
  type ReactNode,
} from 'react';

type Props = {
  children: ReactNode;
};

type State = {
  hasError: boolean;
};

class ErrorBoundary extends Component<Props, State> {
  state: State = {
    hasError: false,
  };

  static getDerivedStateFromError(): State {
    return {
      hasError: true,
    };
  }

  componentDidCatch(
    error: Error,
    info: ErrorInfo,
  ) {
    console.error(error, info);
  }

  render() {
    if (this.state.hasError) {
      return (
        <div role="alert">
          页面出现问题，请刷新后重试。
        </div>
      );
    }

    return this.props.children;
  }
}
```

```tsx
<ErrorBoundary>
  <App />
</ErrorBoundary>
```

老程列了四条注意：错误边界不能代替请求错误处理；事件处理函数中的错误应自行捕获；应把错误上报到监控系统；页面级、模块级和组件级边界可以分层设计。

## 第 19 站：测试——验证用户行为，而不是实现细节

现代 React 项目常用 Vitest（测试运行器）、React Testing Library（组件测试）、Playwright（端到端测试）。组件：

```tsx
// Counter.tsx
import { useState } from 'react';

export function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount((value) => value + 1)}>
      点击次数：{count}
    </button>
  );
}
```

测试：

```tsx
// Counter.test.tsx
import { render, screen } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import { describe, expect, it } from 'vitest';
import { Counter } from './Counter';

describe('Counter', () => {
  it('点击后计数增加', async () => {
    const user = userEvent.setup();

    render(<Counter />);

    await user.click(
      screen.getByRole('button', {
        name: '点击次数：0',
      }),
    );

    expect(
      screen.getByRole('button', {
        name: '点击次数：1',
      }),
    ).toBeInTheDocument();
  });
});
```

“测试重点是用户能看到和操作的行为，而不是组件内部是否调用了某个 State 更新函数。”老程说，“组合上建议：较多纯函数单元测试、适量组件与集成测试、少量关键路径端到端测试。不要追求‘覆盖率数字漂亮’，要覆盖真正高风险的业务行为。”

---

## 第 20 站：完整实战——重写“拾光待办”

验收的时刻到了。林一舟交出的，是一个可直接替换 `src/App.tsx` 的待办应用，包含：TypeScript 数据建模、新增任务、完成与取消完成、删除任务、全部/未完成/已完成筛选、搜索、剩余数量统计、`useReducer`、`useMemo`、LocalStorage 持久化、空状态和基础可访问性。

`src/App.tsx`：

```tsx
import {
  useEffect,
  useMemo,
  useReducer,
  useState,
  type FormEvent,
} from 'react';
import './App.css';

type Filter = 'all' | 'active' | 'completed';

type Task = {
  id: string;
  title: string;
  completed: boolean;
  createdAt: number;
};

type State = {
  tasks: Task[];
};

type Action =
  | { type: 'add'; title: string }
  | { type: 'toggle'; id: string }
  | { type: 'remove'; id: string }
  | { type: 'clearCompleted' };

const STORAGE_KEY = 'react-mastery-tasks';

function loadInitialState(): State {
  try {
    const value = localStorage.getItem(STORAGE_KEY);

    if (!value) {
      return { tasks: [] };
    }

    const tasks = JSON.parse(value) as Task[];

    if (!Array.isArray(tasks)) {
      return { tasks: [] };
    }

    return { tasks };
  } catch {
    return { tasks: [] };
  }
}

function taskReducer(
  state: State,
  action: Action,
): State {
  switch (action.type) {
    case 'add': {
      const task: Task = {
        id: crypto.randomUUID(),
        title: action.title,
        completed: false,
        createdAt: Date.now(),
      };

      return {
        tasks: [task, ...state.tasks],
      };
    }

    case 'toggle':
      return {
        tasks: state.tasks.map((task) =>
          task.id === action.id
            ? {
                ...task,
                completed: !task.completed,
              }
            : task,
        ),
      };

    case 'remove':
      return {
        tasks: state.tasks.filter(
          (task) => task.id !== action.id,
        ),
      };

    case 'clearCompleted':
      return {
        tasks: state.tasks.filter(
          (task) => !task.completed,
        ),
      };

    default:
      return state;
  }
}

function App() {
  const [state, dispatch] = useReducer(
    taskReducer,
    undefined,
    loadInitialState,
  );

  const [title, setTitle] = useState('');
  const [filter, setFilter] =
    useState<Filter>('all');
  const [keyword, setKeyword] = useState('');

  useEffect(() => {
    localStorage.setItem(
      STORAGE_KEY,
      JSON.stringify(state.tasks),
    );
  }, [state.tasks]);

  const visibleTasks = useMemo(() => {
    const normalizedKeyword =
      keyword.trim().toLowerCase();

    return state.tasks.filter((task) => {
      const matchesFilter =
        filter === 'all' ||
        (filter === 'active' && !task.completed) ||
        (filter === 'completed' && task.completed);

      const matchesKeyword =
        normalizedKeyword.length === 0 ||
        task.title
          .toLowerCase()
          .includes(normalizedKeyword);

      return matchesFilter && matchesKeyword;
    });
  }, [state.tasks, filter, keyword]);

  const activeCount = useMemo(
    () =>
      state.tasks.filter(
        (task) => !task.completed,
      ).length,
    [state.tasks],
  );

  const completedCount =
    state.tasks.length - activeCount;

  function handleSubmit(
    event: FormEvent<HTMLFormElement>,
  ) {
    event.preventDefault();

    const trimmedTitle = title.trim();

    if (!trimmedTitle) {
      return;
    }

    dispatch({
      type: 'add',
      title: trimmedTitle,
    });

    setTitle('');
  }

  return (
    <main className="app-shell">
      <section className="todo-card">
        <header className="hero">
          <p className="eyebrow">React 实战项目</p>
          <h1>智能待办清单</h1>
          <p>
            {activeCount > 0
              ? `还有 ${activeCount} 项任务待完成`
              : '今天的任务已经全部完成'}
          </p>
        </header>

        <form
          className="add-form"
          onSubmit={handleSubmit}
        >
          <label
            className="sr-only"
            htmlFor="task-title"
          >
            新任务
          </label>

          <input
            id="task-title"
            value={title}
            onChange={(event) =>
              setTitle(event.target.value)
            }
            placeholder="输入任务内容……"
            maxLength={80}
          />

          <button
            type="submit"
            disabled={!title.trim()}
          >
            添加
          </button>
        </form>

        <div className="toolbar">
          <label>
            <span className="sr-only">
              搜索任务
            </span>
            <input
              type="search"
              value={keyword}
              onChange={(event) =>
                setKeyword(event.target.value)
              }
              placeholder="搜索任务"
            />
          </label>

          <div
            className="filters"
            aria-label="任务筛选"
          >
            {(
              [
                ['all', '全部'],
                ['active', '未完成'],
                ['completed', '已完成'],
              ] as const
            ).map(([value, label]) => (
              <button
                key={value}
                type="button"
                className={
                  filter === value
                    ? 'active'
                    : ''
                }
                aria-pressed={filter === value}
                onClick={() => setFilter(value)}
              >
                {label}
              </button>
            ))}
          </div>
        </div>

        {visibleTasks.length > 0 ? (
          <ul className="task-list">
            {visibleTasks.map((task) => (
              <li
                key={task.id}
                className={
                  task.completed
                    ? 'task completed'
                    : 'task'
                }
              >
                <label>
                  <input
                    type="checkbox"
                    checked={task.completed}
                    onChange={() =>
                      dispatch({
                        type: 'toggle',
                        id: task.id,
                      })
                    }
                  />
                  <span>{task.title}</span>
                </label>

                <button
                  type="button"
                  className="danger"
                  aria-label={`删除任务：${task.title}`}
                  onClick={() =>
                    dispatch({
                      type: 'remove',
                      id: task.id,
                    })
                  }
                >
                  删除
                </button>
              </li>
            ))}
          </ul>
        ) : (
          <div className="empty-state">
            <p>没有符合条件的任务</p>
            <span>
              添加一项新任务，或者修改筛选条件。
            </span>
          </div>
        )}

        <footer className="summary">
          <span>
            共 {state.tasks.length} 项，
            已完成 {completedCount} 项
          </span>

          <button
            type="button"
            disabled={completedCount === 0}
            onClick={() =>
              dispatch({
                type: 'clearCompleted',
              })
            }
          >
            清除已完成
          </button>
        </footer>
      </section>
    </main>
  );
}

export default App;
```

配套的 `src/App.css`：

```css
* {
  box-sizing: border-box;
}

button,
input {
  font: inherit;
}

button {
  cursor: pointer;
}

button:disabled {
  cursor: not-allowed;
  opacity: 0.55;
}

body {
  margin: 0;
  min-width: 320px;
  min-height: 100vh;
  color: #172033;
  background:
    radial-gradient(
      circle at top,
      #eef4ff,
      #f7f8fc 48%,
      #edf0f7
    );
}

.app-shell {
  width: min(920px, calc(100% - 32px));
  margin: 0 auto;
  padding: 64px 0;
}

.todo-card {
  overflow: hidden;
  border: 1px solid rgba(23, 32, 51, 0.08);
  border-radius: 28px;
  background: rgba(255, 255, 255, 0.94);
  box-shadow:
    0 30px 80px rgba(45, 61, 96, 0.14);
}

.hero {
  padding: 36px;
  color: white;
  background:
    linear-gradient(135deg, #315efb, #7b4dff);
}

.hero h1 {
  margin: 8px 0;
  font-size: clamp(32px, 7vw, 54px);
}

.hero p {
  margin: 0;
  opacity: 0.88;
}

.eyebrow {
  font-size: 13px;
  font-weight: 700;
  letter-spacing: 0.14em;
  text-transform: uppercase;
}

.add-form {
  display: grid;
  grid-template-columns: 1fr auto;
  gap: 12px;
  padding: 28px 32px 16px;
}

.add-form input,
.toolbar input {
  width: 100%;
  border: 1px solid #dfe4ef;
  border-radius: 14px;
  outline: none;
  background: #f9faff;
}

.add-form input {
  padding: 15px 16px;
}

.toolbar input {
  padding: 10px 12px;
}

.add-form input:focus,
.toolbar input:focus {
  border-color: #5876ff;
  box-shadow: 0 0 0 4px rgba(88, 118, 255, 0.12);
}

.add-form button {
  border: 0;
  border-radius: 14px;
  padding: 0 22px;
  color: white;
  background: #315efb;
}

.toolbar {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  padding: 12px 32px 20px;
}

.filters {
  display: flex;
  gap: 8px;
}

.filters button,
.summary button {
  border: 1px solid #dfe4ef;
  border-radius: 999px;
  padding: 9px 14px;
  color: #45506a;
  background: white;
}

.filters button.active {
  border-color: #315efb;
  color: white;
  background: #315efb;
}

.task-list {
  display: grid;
  gap: 10px;
  margin: 0;
  padding: 8px 32px 24px;
  list-style: none;
}

.task {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  border: 1px solid #e7eaf2;
  border-radius: 16px;
  padding: 14px 16px;
  background: white;
}

.task label {
  display: flex;
  align-items: center;
  gap: 12px;
  min-width: 0;
}

.task label span {
  overflow-wrap: anywhere;
}

.task.completed label span {
  color: #9098aa;
  text-decoration: line-through;
}

.danger {
  flex: 0 0 auto;
  border: 0;
  padding: 8px 10px;
  color: #c6374d;
  background: transparent;
}

.empty-state {
  margin: 8px 32px 28px;
  border: 1px dashed #cfd5e2;
  border-radius: 18px;
  padding: 44px 20px;
  text-align: center;
  background: #fafbfe;
}

.empty-state p {
  margin: 0 0 8px;
  font-weight: 700;
}

.empty-state span {
  color: #7a8499;
}

.summary {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  border-top: 1px solid #eceef4;
  padding: 18px 32px;
  color: #69748b;
}

.sr-only {
  position: absolute;
  overflow: hidden;
  width: 1px;
  height: 1px;
  margin: -1px;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
}

@media (max-width: 680px) {
  .app-shell {
    padding: 24px 0;
  }

  .hero,
  .add-form,
  .toolbar,
  .task-list,
  .summary {
    padding-left: 20px;
    padding-right: 20px;
  }

  .toolbar,
  .summary {
    align-items: stretch;
    flex-direction: column;
  }

  .filters {
    overflow-x: auto;
  }
}
```

老程在 code review 时圈出了这个项目体现的 React 思想：

- **状态是最小必要集合**：只保存原始任务数组、当前输入、筛选条件和搜索关键词；`visibleTasks`、`activeCount` 和 `completedCount` 都可以计算，因此不重复存入 State；
- **使用 Reducer 表达业务动作**：动作名称是 `add`、`toggle`、`remove`、`clearCompleted`，读代码时可以直接理解用户做了什么；
- **Effect 只负责外部同步**：LocalStorage 是 React 外部系统，用 Effect 同步是合理的；
- **派生数据使用 useMemo**：筛选和统计依赖任务列表，这里用 `useMemo` 展示缓存派生数据的方式——小数据量下即使不用也不会有明显问题，是否保留应由真实性能需求决定；
- **受控组件**：输入框、搜索框、复选框都由 React 状态控制；
- **不可变更新**：Reducer 中始终返回新数组和新对象，没有直接修改旧 State。

## 第 21 站：从 Demo 到生产——目录结构、状态分层与全栈 React

项目要多人协作了，老程给出一种按业务功能组织的目录结构：

```text
src/
├── app/
│   ├── App.tsx
│   ├── providers.tsx
│   └── router.tsx
├── features/
│   ├── auth/
│   │   ├── api/
│   │   ├── components/
│   │   ├── hooks/
│   │   ├── model/
│   │   └── pages/
│   └── tasks/
│       ├── api/
│       ├── components/
│       ├── hooks/
│       ├── model/
│       └── pages/
├── shared/
│   ├── components/
│   ├── hooks/
│   ├── lib/
│   ├── styles/
│   └── types/
└── main.tsx
```

“与其把所有组件放进一个巨大的 `components` 文件夹，不如按业务域聚合代码。目录结构应服务于：快速定位、低耦合、可删除、可测试、清晰的依赖方向。”

关于状态管理工具，老程的忠告是：**不要一上来就安装全局状态库。**分四层来看：

- **第一层：组件 State**——优先使用 `useState`、`useReducer`；
- **第二层：共享 UI 状态**——使用状态提升、Context、Reducer + Context；
- **第三层：复杂客户端全局状态**——当存在跨页面编辑、撤销重做、复杂选择器或大量共享写操作时，再考虑 Zustand、Redux Toolkit 等；
- **第四层：服务端状态**——优先使用框架的数据加载能力，或 TanStack Query 等服务端状态工具。

判断问题时问自己：**这份数据是“浏览器自己拥有的”，还是“服务器拥有、前端只是缓存的”？**

最后是全栈方向。React Server Components（RSC）是在打包前、独立于客户端环境执行的组件类型，可以在服务器或构建阶段读取数据，并减少发送到浏览器的 JavaScript：

```tsx
async function ProductPage({
  productId,
}: {
  productId: string;
}) {
  const product =
    await database.products.find(productId);

  return <ProductDetail product={product} />;
}
```

需要明确：RSC 不是在普通 Vite 客户端项目中随手开启的 Hook；它依赖框架、打包器和服务端协议支持；Server Component 不能直接使用浏览器 API；交互组件通常需要明确客户端边界；安全边界和序列化边界必须认真处理。如果项目需要 SEO、服务端渲染、静态生成、流式渲染、服务端数据访问、Server Actions、路由级数据加载，应优先评估成熟 React 框架，而不是自行拼装整套基础设施。使用 RSC 相关框架和打包器时，还应持续关注 React 官方安全公告并及时升级依赖。

---

## 第 22 站：可访问性与常见错误——上线前的最后一遍巡检

“React 组件最终仍然是 HTML，”老程在上线检查清单的第一行写道，“可访问性不是‘最后再做’。”良好的可访问性包括：使用正确语义标签；表单输入有 `<label>`；图片有合理 `alt`；按钮使用 `<button>` 而不是 `<div onClick>` 模拟；键盘可以完整操作；焦点状态清晰；错误提示使用 `role=“alert”` 或 `aria-live`；颜色对比度足够；弹窗正确管理焦点；不只用颜色表达状态。“可访问性做得好，自动化测试、SEO 和代码语义质量通常也会跟着变好。”

然后是一份用血泪换来的错误清单——每一条都是旧版“拾光待办”或别人项目里真实出现过的：

**错误 1：把所有逻辑塞进一个组件。**结果：组件数百行，状态互相影响，难以测试。纠正：按职责拆分 UI，并把可复用状态逻辑提取到自定义 Hook。

**错误 2：滥用 useEffect。**结果：依赖循环、重复请求、状态不同步。纠正：先问“这是不是在与外部系统同步”。能在渲染中计算的不要使用 Effect。

**错误 3：直接修改 State。**结果：React 无法可靠识别变化，历史状态被污染。纠正：使用展开、`map`、`filter` 等创建新对象和新数组。

**错误 4：使用不稳定 key。**结果：组件反复创建、输入状态错位。纠正：使用稳定业务 ID。

**错误 5：到处使用 Context。**结果：依赖关系隐蔽，更新范围过大。纠正：状态就近放置，Context 只承载真正跨层共享的值。

**错误 6：过早优化。**结果：到处都是 `memo`、`useMemo`、`useCallback`，代码更难读。纠正：先测量，再针对瓶颈优化；评估 React Compiler。

**错误 7：把请求数据放进普通全局 Store 当缓存。**结果：自己重复实现缓存、重试和失效逻辑。纠正：区分客户端状态和服务端状态。

**错误 8：忽略加载、空、错误和权限状态。**结果：Demo 能跑，真实网络环境下体验崩溃。纠正：每个异步页面至少设计：

```text
loading
success
empty
error
unauthorized
```

## 第 23 站：学习路线图——从“会写”到“精通”的五段路

重写上线后，老程给林一舟，也给所有后来者画了一张五阶段路线图。

**第一阶段：基础。**掌握 JSX、函数组件、Props、事件、`useState`、条件渲染、列表、表单。练习项目：计数器、购物清单、计算器、简单待办。

**第二阶段：状态与副作用。**掌握状态快照、不可变更新、状态提升、`useReducer`、Context、`useRef`、`useEffect`、自定义 Hook。练习项目：带筛选的待办、天气查询、记账应用、Markdown 编辑器。

**第三阶段：工程化。**掌握 TypeScript、路由、数据请求、表单库、测试、错误边界、代码分割、环境变量、ESLint、构建部署。练习项目：后台管理系统、博客、电商前台、知识库。

**第四阶段：进阶。**掌握服务端状态、并发更新、Suspense、Actions、乐观更新、React Compiler、性能分析、SSR/SSG/RSC、设计系统、Monorepo。

**第五阶段：精通。**“精通”不是记住所有 Hook，而是能够：建立正确状态模型；设计稳定组件 API；控制复杂度；定位性能瓶颈；处理失败与边界；做合理技术选型；阅读源码和 RFC；在团队中形成可维护规范。

## 第 24 站：面试高频问题——把故事讲给面试官听

庆功宴上，合伙人笑着问：“下次面试官问你 React，你打算怎么答？”林一舟把这段时间最常被问到的十个问题整理成了一页纸：

1. **React 为什么使用 key？**为了在列表更新时识别元素身份，帮助 React 正确复用、移动、创建或删除组件。
2. **State 和普通变量有什么区别？**State 能跨渲染保留，并且更新 State 会请求 React 重新渲染；普通局部变量每次渲染都会重新创建，修改它也不会触发界面更新。
3. **Props 和 State 有什么区别？**Props 由父组件传入，组件不应修改；State 由组件管理，可以通过更新函数改变。
4. **useEffect 什么时候使用？**当组件需要与外部系统同步时使用，例如订阅、网络连接、浏览器事件、定时器或第三方实例。
5. **为什么不能直接修改 State？**直接修改会污染旧快照，并破坏 React 基于引用和不可变数据进行更新判断的假设。
6. **useMemo 与 useCallback 的区别？**`useMemo` 缓存计算结果，`useCallback` 缓存函数本身。
7. **Context 能替代所有状态管理库吗？**不能。Context 适合跨层传值，但不自动提供复杂状态建模、细粒度订阅、时间旅行、服务端缓存等能力。
8. **受控组件与非受控组件的区别？**受控组件的值由 React State 驱动；非受控组件主要由 DOM 自身维护，通常通过 Ref 读取。
9. **React 组件为什么要保持纯净？**纯组件更容易预测、并发渲染、重试、测试和优化。
10. **React 19 带来了什么重要变化？**包括 Actions、`useActionState`、`useOptimistic`、表单 Action 改进、Ref 作为属性等；React 19.2 进一步加入 `<Activity>`、`useEffectEvent` 和性能相关能力。

## 尾声：发布日又来了，这次没有雪崩

新“拾光待办”上线那天，运营又临时提了个需求：“筛选按钮旁边加个小圆点，显示未完成任务数。”

林一舟打开 `App.tsx`，在 header 里加了一行 `{activeCount > 0 && <span className=“dot”>{activeCount}</span>}`，五分钟，上线，没有雪崩。那个曾经由三百个互相踩脚的定时炸弹组成的旧版，安安静静躺进了 Git 历史里。

他把自己的重写笔记浓缩成五句话，贴在工位上：

1. **UI 是状态的函数**——`UI = f(state)`。不要手动命令每个 DOM 如何改变，而要描述当前状态对应的界面；
2. **组件是职责边界**——组件不是为了拆文件，而是为了隔离职责、降低复杂度和实现复用；
3. **状态要最小、单一、可推导**——能计算出来的不要重复存储；多个组件共享时，找到合适的状态所有者；
4. **Effect 只解决外部同步**——不要用 Effect 修补错误的数据流；
5. **优化必须建立在测量之上**——先写正确、清晰的代码，再使用 Profiler、代码分割、虚拟化、缓存或 React Compiler 解决真实瓶颈。

React 的 API 会持续演进，但这些原则长期有效。掌握它们之后，无论使用纯 React、Vite、React Router，还是 Next.js 等全栈框架，都能建立稳定的理解框架。

> React 的难点，从来不是 API 多，而是你能否建立起正确的组件思维、状态思维和数据流思维——用声明式描述界面，用最小状态驱动变化，用清晰的边界管理复杂度。

拾光待办的故事告一段落，但你的故事才刚刚开始。打开终端，敲下 `npm create vite@latest` 吧。

---

## 官方资料与延伸阅读

- React 官方文档：https://react.dev/
- React 快速入门：https://react.dev/learn
- React Hooks 参考：https://react.dev/reference/react/hooks
- React 19 发布说明：https://react.dev/blog/2024/12/05/react-19
- React 19.2 发布说明：https://react.dev/blog/2025/10/01/react-19-2
- React Compiler：https://react.dev/learn/react-compiler
- React Server Components：https://react.dev/reference/rsc/server-components
- React TypeScript 指南：https://react.dev/learn/typescript
- Vite 官方指南：https://vite.dev/guide/
- TanStack Query React 文档：https://tanstack.com/query/latest/docs/framework/react/overview
- Vitest 官方指南：https://vitest.dev/guide/
- React Testing Library：https://testing-library.com/docs/react-testing-library/intro/

> 版本提示：本文以 React 19.2 为基线。React 迭代较快，实际使用时请以官方文档的最新说明为准。

