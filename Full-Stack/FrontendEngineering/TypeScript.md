# [TypeScript从入门到精通：从类型基础到大型项目工程实践](https://mp.weixin.qq.com/s/J7m2cUHZa6vvDnp-fsXgrw)

> 这是一个关于「拾贝协作」的故事——一家做在线白板的设计工具公司，前端新人阮清在一次字段重命名后把付费结算页改出了白屏。前端负责人沈知远带着她把整个前端迁到 TypeScript strict 模式：从第一行类型标注，到泛型、判别联合、运行时校验，再到用类型设计业务规则、让类型检查进入 CI。读完之后你会发现：真正掌握 TypeScript，并不是给每个变量补上 `string`、`number`，而是学会用类型描述业务规则、约束程序边界，并让错误尽可能早地暴露在编辑器和编译阶段。

---

## 故事的起点：一次重命名引发的白屏

「拾贝协作」的核心产品是一块在线白板：多人实时编辑、素材库、模板市场，最近还上线了付费订阅。前端代码几十万行，全是裸写的 JavaScript。

那天下午，后端把用户接口里的 `name` 字段重命名了，阮清负责跟进改动。她全局搜索替换时手一抖，结算页某处写成了 `user.userName.toUpperCase()`。JavaScript 不会在运行前告诉你这个字段不存在——直到第二天上午，第一位付费用户点开结算页，屏幕一片空白，告警群里炸开了锅。

复盘会上，沈知远在白板上写下一行字：

> 这类错误不需要等程序部署到服务器，也不需要等用户点击按钮，只要写代码时就能发现。
> 前提是——让编译器认识你的数据结构。

他给阮清定了个目标：**四周之内，把结算链路的前端代码全部迁到 TypeScript strict 模式，并且让类型检查进入 CI。**

这个故事，就是她从头到尾走完的路线图。

---

## 第一站：TypeScript到底是什么？

TypeScript 是建立在 JavaScript 之上的编程语言。

可以把它理解为：

```text
TypeScript = JavaScript + 静态类型系统 + 更强的开发工具支持
```

任何合法的 JavaScript 代码，通常也可以作为 TypeScript 代码使用。

例如，下面是一段普通 JavaScript：

```js
function add(a, b) {
  return a + b;
}
```

改成 TypeScript 后，可以明确参数和返回值的类型：

```ts
function add(a: number, b: number): number {
  return a + b;
}
```

如果调用时传入字符串：

```ts
add("1", 2);
```

编辑器会立即提示错误：

```text
类型"string"的参数不能赋给类型"number"的参数。
```

这个错误不需要等程序部署到服务器，也不需要等用户点击按钮，只要写代码时就能发现。

### 1. TypeScript不会直接运行

浏览器、Node.js 和大多数 JavaScript 运行时最终执行的仍然是 JavaScript。

TypeScript 代码通常需要经过编译：

```text
.ts / .tsx 文件
      ↓
TypeScript 编译器进行类型检查
      ↓
生成 JavaScript
      ↓
浏览器或 Node.js 执行
```

需要特别理解的一点是：

> TypeScript 的大部分类型信息只存在于开发和编译阶段，生成 JavaScript 后通常会被擦除。

例如：

```ts
const username: string = "Alice";
```

编译后可能变成：

```js
const username = "Alice";
```

因此，TypeScript 不能代替运行时校验。来自接口、表单、本地存储和第三方服务的数据，仍然需要在程序运行时验证——这一点后来在阮清的迁移之旅中反复出现。

---

## 第二站：为什么大型项目更需要TypeScript？

JavaScript 的问题并不在于"不能写大型项目"，而在于大型项目会放大动态类型带来的不确定性。

白屏事故的根源，正是这样一个用户对象：

```js
const user = {
  id: 1001,
  name: "Alice",
};
```

几个月后，另一位开发者（其实就是阮清自己）可能写出：

```js
console.log(user.userName.toUpperCase());
```

真正的字段是`name`，而不是`userName`。在 JavaScript 中，这类错误可能直到代码运行到这一行才暴露。

在 TypeScript 中，可以先定义数据结构：

```ts
interface User {
  id: number;
  name: string;
}

const user: User = {
  id: 1001,
  name: "Alice",
};

console.log(user.userName);
```

编辑器会直接指出：

```text
类型"User"上不存在属性"userName"。
```

TypeScript 的价值并不只是"少写几个 Bug"，更重要的是它为项目建立了一层可以被工具理解的结构。

当你修改接口、重命名字段或调整函数参数时，编译器会告诉你哪些地方受到影响。这种能力在几十万行代码、多人协作和长期维护的项目中尤其重要。

---

## 第三站：搭建第一个TypeScript项目

### 1. 初始化项目

首先确保已安装 Node.js，然后创建项目：

```bash
mkdir typescript-demo
cd typescript-demo
npm init -y
```

安装 TypeScript：

```bash
npm install -D typescript
```

查看版本：

```bash
npx tsc -v
```

初始化配置：

```bash
npx tsc --init
```

项目中会生成`tsconfig.json`。

### 2. 创建第一个文件

新建`src/index.ts`：

```ts
const message: string = "Hello TypeScript";
console.log(message);
```

执行类型检查：

```bash
npx tsc --noEmit
```

编译代码：

```bash
npx tsc
```

### 3. 一个适合现代项目的基础配置

沈知远给「拾贝」定下的基础配置：

```jsonc
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "Bundler",
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "exactOptionalPropertyTypes": true,
    "useUnknownInCatchVariables": true,
    "noImplicitOverride": true,
    "verbatimModuleSyntax": true,
    "rootDir": "./src",
    "outDir": "./dist",
    "declaration": true,
    "sourceMap": true,
    "skipLibCheck": true
  },
  "include": ["src/**/*.ts"],
  "exclude": ["node_modules", "dist"]
}
```

不同项目的配置并不完全相同：

- 前端项目通常由 Vite、Webpack、Rspack 等工具完成打包；
- Node.js 项目需要根据运行时选择 ESM 或 CommonJS；
- 组件库和工具库通常需要生成`.d.ts`类型声明；
- Monorepo 项目可能使用 Project References 管理多个子项目。

不要机械复制配置。先明确运行环境，再决定`target`、`module`和`moduleResolution`。

---

## 第四站：基础类型——TypeScript的第一块积木

### 1. 字符串、数字和布尔值

```ts
const username: string = "Alice";
const age: number = 18;
const isAdmin: boolean = false;
```

JavaScript 中所有普通数字都属于`number`：

```ts
const integer: number = 10;
const decimal: number = 3.14;
const hex: number = 0xff;
const infinity: number = Infinity;
const notANumber: number = NaN;
```

大整数使用`bigint`：

```ts
const value: bigint = 9007199254740993n;
```

### 2. 数组

数组有两种常见写法：

```ts
const scores: number[] = [90, 85, 100];
const names: Array<string> = ["Alice", "Bob"];
```

混合类型可以使用联合类型：

```ts
const values: Array<string | number> = [1, "two", 3];
```

注意这两个类型并不相同：

```ts
// 数组本身只能是 string[] 或 number[]
let a: string[] | number[];
// 数组中的每一项可以是 string 或 number
let b: Array<string | number>;
```

### 3. 元组

元组用于描述长度和位置类型固定的数组：

```ts
const point: [number, number] = [120.1, 30.2];
```

可以为元组成员添加名称：

```ts
type Coordinate = [longitude: number, latitude: number];
const location: Coordinate = [120.1, 30.2];
```

可选成员与剩余成员：

```ts
type ResponseData = [status: number, message?: string];
type Command = [name: string, ...args: string[]];
```

元组适合表达短小、稳定、位置有明确语义的数据。如果字段较多，通常对象更易读。

### 4. null与undefined

在严格模式下，`null`和`undefined`不会自动赋值给其他类型：

```ts
let title: string;
// 错误
// title = undefined;
```

如果变量确实可能为空，需要明确写出：

```ts
let title: string | null = null;
```

### 5. void、never、unknown和any

#### void

`void`常用于没有有效返回值的函数：

```ts
function logMessage(message: string): void {
  console.log(message);
}
```

#### never

`never`表示不可能出现的值。

```ts
function fail(message: string): never {
  throw new Error(message);
}
```

它还可以用于穷尽性检查：

```ts
function assertNever(value: never): never {
  throw new Error(`未处理的值：${String(value)}`);
}
```

#### any

`any`会关闭大部分类型检查：

```ts
let data: any = "hello";
data.notExists().whatever;
```

它适合临时迁移或无法获得类型信息的边界，但不应成为默认选择。

#### unknown

`unknown`表示"当前不知道是什么类型"，但使用前必须检查：

```ts
function printValue(value: unknown): void {
  if (typeof value === "string") {
    console.log(value.toUpperCase());
  }
}
```

在接收外部数据、捕获异常、解析 JSON 时，优先使用`unknown`，而不是`any`。

---

## 第五站：类型推断——不要给所有变量手动标注

TypeScript 能根据上下文自动推断类型：

```ts
const count = 10;
// 推断为 number
const name = "Alice";
// 推断为 "Alice" 字面量类型
let city = "Hangzhou";
// 通常推断为 string
```

函数返回值也可以推断：

```ts
function multiply(a: number, b: number) {
  return a * b;
}
```

返回值会被推断为`number`。

合理使用推断可以减少重复信息：

```ts
// 不必处处重复
const user: { id: number; name: string } = {
  id: 1,
  name: "Alice",
};
```

更推荐：

```ts
interface User {
  id: number;
  name: string;
}
const user: User = {
  id: 1,
  name: "Alice",
};
```

或者在局部变量中直接依赖推断：

```ts
const user = {
  id: 1,
  name: "Alice",
};
```

一个实用原则是：

> 在公共边界处明确类型，在局部实现中充分利用推断。

公共边界包括：

- 导出的函数；
- 公共组件属性；
- API 请求和响应；
- 数据库模型；
- 状态管理接口；
- 类库公开 API。

---

## 第六站：对象类型、interface与type

### 1. 直接描述对象

```ts
function printUser(user: { id: number; name: string }): void {
  console.log(user.name);
}
```

对于会重复使用的结构，应该提取类型：

```ts
interface User {
  id: number;
  name: string;
}
```

### 2. 可选属性

```ts
interface User {
  id: number;
  name: string;
  avatar?: string;
}
```

`avatar?: string`表示这个属性可以不存在。

它与下面的写法不完全相同：

```ts
interface User {
  avatar: string | undefined;
}
```

后者要求属性必须存在，只是值可以为`undefined`。

### 3. 只读属性

```ts
interface User {
  readonly id: number;
  name: string;
}
```

```ts
const user: User = {
  id: 1,
  name: "Alice",
};
// 错误
// user.id = 2;
```

注意：`readonly`默认只是编译期约束，并不意味着运行时对象不可变，也不一定是深度只读。

### 4. interface继承

```ts
interface Entity {
  id: string;
  createdAt: Date;
}
interface User extends Entity {
  name: string;
  email: string;
}
```

### 5. type交叉类型

```ts
type Entity = {
  id: string;
  createdAt: Date;
};
type User = Entity & {
  name: string;
  email: string;
};
```

### 6. interface还是type？

两者都可以描述对象，但各有擅长场景。

`interface`常用于：

- 对象结构；
- 类实现的契约；
- 可扩展的公共 API；
- 声明合并。

`type`常用于：

- 联合类型；
- 交叉类型；
- 元组；
- 条件类型；
- 映射类型；
- 模板字面量类型；
- 基本类型别名。

例如：

```ts
type ID = string | number;
type Status = "idle" | "loading" | "success" | "error";
type Point = [number, number];
```

团队中最重要的并不是争论"只能用哪一个"，而是建立一致、可解释的约定。「拾贝」前端的约定很简单：对象契约用`interface`，其余一律`type`。

---

## 第七站：联合类型与交叉类型

### 1. 联合类型：满足其中之一

```ts
type ID = string | number;
function printId(id: ID): void {
  console.log(id);
}
```

联合类型表示值可以属于多个候选类型中的任意一个。

字面量联合非常适合描述有限状态：

```ts
type Theme = "light" | "dark" | "system";
type RequestStatus = "idle" | "loading" | "success" | "error";
```

与普通`string`相比，它能防止无效值：

```ts
let theme: Theme = "dark";
// 错误
// theme = "blue";
```

### 2. 交叉类型：同时满足多个类型

```ts
type Timestamped = {
  createdAt: Date;
  updatedAt: Date;
};
type User = {
  id: string;
  name: string;
} & Timestamped;
```

交叉类型适合组合能力，但不要盲目拼接存在冲突的属性：

```ts
type A = { id: string };
type B = { id: number };
type C = A & B;
```

此时`C["id"]`会变成`never`，因为一个值不可能同时既是`string`又是`number`。

---

## 第八站：函数类型——TypeScript最常用的部分

「拾贝」的结算页里到处是回调：支付回调、埋点回调、模板渲染回调。阮清迁移的第一批类型，就来自这些函数。

### 1. 参数与返回值

```ts
function greet(name: string): string {
  return `Hello, ${name}`;
}
```

### 2. 可选参数

```ts
function greet(name: string, prefix?: string): string {
  return `${prefix ?? "Hello"}, ${name}`;
}
```

可选参数通常放在必填参数之后。

### 3. 默认参数

```ts
function createPage(page = 1, pageSize = 20) {
  return { page, pageSize };
}
```

### 4. 剩余参数

```ts
function sum(...numbers: number[]): number {
  return numbers.reduce((total, value) => total + value, 0);
}
```

### 5. 函数类型别名

```ts
type Calculator = (a: number, b: number) => number;
const add: Calculator = (a, b) => a + b;
```

### 6. 回调函数

```ts
function processItems<T>(
  items: T[],
  callback: (item: T, index: number) => void,
): void {
  items.forEach(callback);
}
```

### 7. 函数重载

当函数根据不同输入返回不同结果时，可以使用重载：

```ts
function format(value: string): string;
function format(value: number): string;
function format(value: Date): string;
function format(value: string | number | Date): string {
  if (value instanceof Date) {
    return value.toISOString();
  }
  return String(value);
}
```

调用者看到的是重载签名，而不是实现签名。

不过，重载并非越多越好。如果联合类型和泛型已经能清晰表达，就不必强行使用重载。

---

## 第九站：类型收窄——让联合类型真正可用

当一个变量可能属于多种类型时，必须先判断，再使用某个类型特有的能力。

这个过程叫作类型收窄。

### 1. typeof

```ts
function normalize(value: string | number): string {
  if (typeof value === "number") {
    return value.toFixed(2);
  }
  return value.trim();
}
```

### 2. instanceof

```ts
function formatError(error: Error | string): string {
  if (error instanceof Error) {
    return error.message;
  }
  return error;
}
```

### 3. in操作符

```ts
interface Admin {
  role: "admin";
  permissions: string[];
}
interface Customer {
  role: "customer";
  points: number;
}
function describeUser(user: Admin | Customer): string {
  if ("permissions" in user) {
    return `权限数：${user.permissions.length}`;
  }
  return `积分：${user.points}`;
}
```

### 4. 判别联合

这是业务建模中最重要的模式之一。

```ts
type RequestState<T> =
  | { status: "idle" }
  | { status: "loading" }
  | { status: "success"; data: T }
  | { status: "error"; error: Error };
```

使用时：

```ts
function renderState(state: RequestState<string>): string {
  switch (state.status) {
    case "idle":
      return "尚未请求";
    case "loading":
      return "加载中";
    case "success":
      return state.data;
    case "error":
      return state.error.message;
  }
}
```

相比下面这种松散结构：

```ts
interface BadState<T> {
  loading: boolean;
  data?: T;
  error?: Error;
}
```

判别联合不会产生这些难以解释的状态：

```text
loading = true，同时 data 存在
loading = false，但 data 和 error 都不存在
loading = true，同时 error 也存在
```

好的类型设计，应该让非法状态难以表示，甚至无法表示——阮清在迁移结算页时，把订单状态从三个互相矛盾的布尔值改成了判别联合，那正是这次白屏事故的另一种隐患。

### 5. 自定义类型守卫

```ts
interface User {
  id: number;
  name: string;
}
function isUser(value: unknown): value is User {
  if (typeof value !== "object" || value === null) {
    return false;
  }
  const candidate = value as Record<string, unknown>;
  return (
    typeof candidate.id === "number" &&
    typeof candidate.name === "string"
  );
}
```

这里的`value is User`告诉 TypeScript：当函数返回`true`时，可以把`value`当成`User`。

---

## 第十站：泛型——让类型具有复用能力

白板的素材库 API 有几十个接口，返回结构只有 `data` 字段不同。阮清本来准备复制粘贴几十个 interface，沈知远路过她工位，说了两个字："泛型。"

没有泛型时，我们可能写出多个重复函数：

```ts
function firstString(items: string[]): string | undefined {
  return items[0];
}
function firstNumber(items: number[]): number | undefined {
  return items[0];
}
```

使用泛型：

```ts
function first<T>(items: T[]): T | undefined {
  return items[0];
}
```

调用时：

```ts
const name = first(["Alice", "Bob"]);
// string | undefined
const score = first([90, 100]);
// number | undefined
```

### 1. 泛型接口

```ts
interface ApiResponse<T> {
  code: number;
  message: string;
  data: T;
}
```

```ts
interface User {
  id: number;
  name: string;
}
type UserResponse = ApiResponse<User>;
type UserListResponse = ApiResponse<User[]>;
```

### 2. 多个泛型参数

```ts
function createPair<K, V>(key: K, value: V): [K, V] {
  return [key, value];
}
```

### 3. 泛型约束

```ts
function getLength<T extends { length: number }>(value: T): number {
  return value.length;
}
```

合法调用：

```ts
getLength("hello");
getLength([1, 2, 3]);
```

不合法调用：

```ts
// getLength(100);
```

### 4. keyof约束

```ts
function getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {
  return obj[key];
}
const user = {
  id: 1,
  name: "Alice",
};
const id = getProperty(user, "id");
const name = getProperty(user, "name");
// 错误
// getProperty(user, "email");
```

这段代码表达了三个约束：

1. `K`必须是`T`的键；
2. 参数`key`只能传入真实存在的属性名；
3. 返回值类型会根据具体的属性自动变化。

这就是 TypeScript 类型系统的核心价值：不仅检查值，还能表达值之间的关系。

### 5. 泛型默认值

```ts
interface ApiResponse<T = unknown> {
  code: number;
  data: T;
}
```

### 6. 不要滥用泛型

下面的泛型没有建立任何有意义的关系：

```ts
function log<T>(value: T): void {
  console.log(value);
}
```

这里直接使用`unknown`通常更清晰：

```ts
function log(value: unknown): void {
  console.log(value);
}
```

泛型最适合表达"输入与输出之间的类型关系"，而不是单纯把类型参数写得更复杂。

---

## 第十一站：keyof、typeof与索引访问类型

### 1. keyof

```ts
interface User {
  id: number;
  name: string;
  active: boolean;
}
type UserKey = keyof User;
// "id" | "name" | "active"
```

### 2. typeof

```ts
const config = {
  endpoint: "/api",
  retries: 3,
};
type Config = typeof config;
// { endpoint: string; retries: number }
```

### 3. 索引访问类型

```ts
interface User {
  id: number;
  profile: {
    nickname: string;
    avatar: string;
  };
}
type UserId = User["id"];
type Profile = User["profile"];
type Nickname = User["profile"]["nickname"];
```

从数组中提取元素类型：

```ts
const users = [
  { id: 1, name: "Alice" },
  { id: 2, name: "Bob" },
];
type User = (typeof users)[number];
```

这个技巧在根据配置、常量和静态数据生成类型时非常实用。

---

## 第十二站：字面量类型、as const与satisfies

### 1. 字面量类型

```ts
let direction: "left" | "right";
direction = "left";
// direction = "up"; // 错误
```

### 2. as const

普通对象中的字符串属性通常会被扩大为`string`：

```ts
const config = {
  mode: "production",
};
```

如果希望保留最具体的字面量，并将属性标记为只读：

```ts
const config = {
  mode: "production",
} as const;
```

从常量数组生成联合类型：

```ts
const roles = ["admin", "editor", "viewer"] as const;
type Role = (typeof roles)[number];
// "admin" | "editor" | "viewer"
```

### 3. satisfies

`satisfies`用来验证一个值是否符合某个类型，同时尽量保留值自身更精确的推断。

```ts
type RouteName = "home" | "profile" | "settings";
const routes = {
  home: "/",
  profile: "/profile",
  settings: "/settings",
} satisfies Record<RouteName, string>;
```

如果写错键名或缺少字段，编译器会报错；同时`routes.home`仍然保留精确类型信息。

对配置对象来说，`satisfies`往往比直接类型断言更安全。

---

## 第十三站：类型断言——可以使用，但不要欺骗编译器

类型断言写法：

```ts
const input = document.querySelector("#username") as HTMLInputElement;
```

另一种写法是：

```ts
const input = <HTMLInputElement>document.querySelector("#username");
```

但在`.tsx`文件中会与 JSX 语法冲突，因此更推荐`as`。

### 1. 断言不会进行运行时转换

```ts
const value = "123" as unknown as number;
```

这不会把字符串转换为数字。运行时的值仍然是字符串。

真正的转换应该写成：

```ts
const value = Number("123");
```

### 2. 非空断言

```ts
const button = document.querySelector("button")!;
button.addEventListener("click", () => {});
```

`!`告诉编译器"这里一定不是 null 或 undefined"。

如果判断错误，运行时仍然会崩溃。因此更稳妥的方式是：

```ts
const button = document.querySelector("button");
if (!button) {
  throw new Error("未找到按钮");
}
button.addEventListener("click", () => {});
```

一个重要原则：

> 类型断言应该用于补充编译器无法知道的信息，而不是掩盖真实的类型问题。

---

## 第十四站：类、访问控制与抽象

### 1. 基础类

```ts
class User {
  constructor(
    public readonly id: number,
    public name: string,
  ) {}

  greet(): string {
    return `Hello, ${this.name}`;
  }
}
```

参数属性可以简化代码：

```ts
class User {
  constructor(public name: string) {}
}
```

等价于：

```ts
class User {
  public name: string;
  constructor(name: string) {
    this.name = name;
  }
}
```

### 2. public、protected与private

```ts
class Account {
  public owner: string;
  protected balance: number;
  private password: string;

  constructor(owner: string, password: string) {
    this.owner = owner;
    this.balance = 0;
    this.password = password;
  }
}
```

需要注意：

- TypeScript 的`private`主要用于类型检查；
- JavaScript 原生私有字段使用`#field`；
- 如果需要真正的运行时私有性，可以使用`#`。

```ts
class Counter {
  #value = 0;

  increment(): void {
    this.#value += 1;
  }

  get value(): number {
    return this.#value;
  }
}
```

### 3. 抽象类

```ts
abstract class Shape {
  abstract area(): number;

  describe(): string {
    return `面积：${this.area()}`;
  }
}

class Circle extends Shape {
  constructor(private readonly radius: number) {
    super();
  }

  area(): number {
    return Math.PI * this.radius ** 2;
  }
}
```

### 4. implements

```ts
interface Serializable {
  serialize(): string;
}

class User implements Serializable {
  constructor(
    public id: number,
    public name: string,
  ) {}

  serialize(): string {
    return JSON.stringify(this);
  }
}
```

`implements`只检查实例结构是否符合接口，不会自动生成任何实现代码。

---

## 第十五站：枚举是否值得使用？

TypeScript 支持`enum`：

```ts
enum Direction {
  Up,
  Down,
  Left,
  Right,
}
```

字符串枚举：

```ts
enum Role {
  Admin = "admin",
  Editor = "editor",
  Viewer = "viewer",
}
```

但在很多业务项目中，字面量联合更轻量：

```ts
type Role = "admin" | "editor" | "viewer";
```

或者使用常量对象：

```ts
const Role = {
  Admin: "admin",
  Editor: "editor",
  Viewer: "viewer",
} as const;
type Role = (typeof Role)[keyof typeof Role];
```

常量对象的优点：

- 运行时真实存在；
- 与普通 JavaScript 更一致；
- 易于遍历；
- 容易配合`as const`推导类型；
- 构建工具通常更容易优化。

`enum`并非绝对不能用，但团队应该明确它的运行时代码、编译结果和跨工具兼容性。「拾贝」最终选择了常量对象方案。

---

## 第十六站：内置工具类型

TypeScript 提供了大量常用工具类型。阮清的第一反应是"这么多记不住"，沈知远说：不用背，先看懂 `Partial` 和 `Pick`，其余的都是同一个思路的变体。

### 1. Partial

将所有属性变为可选：

```ts
interface User {
  id: number;
  name: string;
  email: string;
}
type UserPatch = Partial<User>;
```

适合局部更新：

```ts
function updateUser(id: number, patch: Partial<User>): void {
  // 更新逻辑
}
```

### 2. Required

将所有属性变为必填：

```ts
type CompleteUser = Required<User>;
```

### 3. Readonly

```ts
type ReadonlyUser = Readonly<User>;
```

### 4. Pick

选择部分属性：

```ts
type UserPreview = Pick<User, "id" | "name">;
```

### 5. Omit

排除部分属性：

```ts
type CreateUserInput = Omit<User, "id">;
```

### 6. Record

```ts
type Permission = "read" | "write" | "delete";
type PermissionMap = Record<Permission, boolean>;
```

### 7. Exclude与Extract

```ts
type Status = "idle" | "loading" | "success" | "error";
type FinishedStatus = Exclude<Status, "idle" | "loading">;
type ErrorStatus = Extract<Status, "error" | "cancelled">;
```

### 8. NonNullable

```ts
type Value = string | null | undefined;
type SafeValue = NonNullable<Value>;
// string
```

### 9. Parameters与ReturnType

```ts
function createUser(name: string, age: number) {
  return {
    id: crypto.randomUUID(),
    name,
    age,
  };
}
type CreateUserParams = Parameters<typeof createUser>;
type CreatedUser = ReturnType<typeof createUser>;
```

### 10. Awaited

```ts
type Result = Awaited<Promise<Promise<string>>>;
// string
```

工具类型的本质不是"背 API"，而是理解它们背后的映射类型、条件类型和索引访问。

---

## 第十七站：映射类型——批量变换属性

映射类型可以遍历一组键，生成新的对象类型。

```ts
type MyReadonly<T> = {
  readonly [K in keyof T]: T[K];
};
```

自定义可选类型：

```ts
type MyPartial<T> = {
  [K in keyof T]?: T[K];
};
```

移除可选修饰符：

```ts
type Concrete<T> = {
  [K in keyof T]-?: T[K];
};
```

移除只读修饰符：

```ts
type Mutable<T> = {
  -readonly [K in keyof T]: T[K];
};
```

键名重映射：

```ts
type Getters<T> = {
  [K in keyof T as `get${Capitalize<string & K>}`]: () => T[K];
};
```

```ts
interface User {
  id: number;
  name: string;
}
type UserGetters = Getters<User>;
```

得到：

```ts
type UserGetters = {
  getId: () => number;
  getName: () => string;
};
```

---

## 第十八站：条件类型与infer

条件类型的形式类似三元表达式：

```ts
type IsString<T> = T extends string ? true : false;
```

```ts
type A = IsString<string>; // true
type B = IsString<number>; // false
```

### 1. 提取数组元素类型

```ts
type ElementType<T> = T extends Array<infer U> ? U : T;
```

```ts
type A = ElementType<string[]>;
// string
type B = ElementType<number>;
// number
```

### 2. 提取Promise结果

```ts
type UnwrapPromise<T> = T extends Promise<infer U> ? U : T;
```

### 3. 提取函数返回值

```ts
type MyReturnType<T> = T extends (...args: never[]) => infer R
  ? R
  : never;
```

### 4. 分布式条件类型

当条件类型作用于泛型联合类型时，通常会分发到每个成员：

```ts
type ToArray<T> = T extends unknown ? T[] : never;
type Result = ToArray<string | number>;
// string[] | number[]
```

如果不希望分发，可以使用元组包裹：

```ts
type ToArrayNonDistributed<T> = [T] extends [unknown] ? T[] : never;
type Result = ToArrayNonDistributed<string | number>;
// (string | number)[]
```

条件类型非常强大，但复杂条件类型也可能降低可读性和编译性能。能用简单类型表达时，不要为了炫技堆叠多层`infer`。

---

## 第十九站：模板字面量类型

模板字面量类型可以拼接字符串类型：

```ts
type Size = "small" | "medium" | "large";
type Variant = `button-${Size}`;
```

得到：

```ts
type Variant =
  | "button-small"
  | "button-medium"
  | "button-large";
```

结合对象属性生成事件名：

```ts
type PropEventSource<T> = {
  on<K extends string & keyof T>(
    eventName: `${K}Changed`,
    callback: (newValue: T[K]) => void,
  ): void;
};
```

```ts
interface User {
  name: string;
  age: number;
}
declare const user: User & PropEventSource<User>;
user.on("nameChanged", (name) => {
  name.toUpperCase();
});
user.on("ageChanged", (age) => {
  age.toFixed(0);
});
```

模板字面量类型适合：

- 事件名；
- CSS 类名；
- 路由参数；
- 国际化键；
- API 命名约定；
- 状态管理 action 名称。

---

## 第二十站：模块系统——ESM、CommonJS与类型导入

### 1. ESM导出与导入

```ts
// math.ts
export function add(a: number, b: number): number {
  return a + b;
}
export const PI = 3.1415926;
```

```ts
// index.ts
import { add, PI } from "./math.js";
```

在 Node.js ESM 项目中，源码导入路径是否需要`.js`，取决于模块解析策略、编译方式和运行环境。不要只看源文件扩展名，要考虑最终输出文件。

### 2. 类型导入

```ts
import type { User } from "./types.js";
```

类型导入可以明确表示该依赖只在类型检查阶段使用。

```ts
export type { User } from "./types.js";
```

### 3. 不要混淆模块解析与打包

TypeScript 可以检查模块和生成 JavaScript，但它不是所有场景下的打包器。

常见职责划分：

```text
TypeScript：类型检查、语法转换、声明文件生成
Vite/Rollup/Webpack/Rspack/esbuild：依赖分析、打包、拆包、压缩、资源处理
Node.js/浏览器：运行最终代码
```

理解这些工具的边界，可以避免大量`moduleResolution`、路径别名和 ESM/CJS 兼容问题。

---

## 第二十一站：声明文件与第三方库类型

TypeScript 使用`.d.ts`文件描述 JavaScript 模块的类型。

### 1. 使用已有类型

很多库已经自带类型声明：

```bash
npm install axios
```

一些库需要单独安装 DefinitelyTyped 类型包：

```bash
npm install -D @types/node
```

### 2. 为没有类型的模块补充声明

```ts
// src/types/some-library.d.ts
declare module "some-library" {
  export function doSomething(value: string): number;
}
```

### 3. 声明全局变量

```ts
declare global {
  interface Window {
    analytics: {
      track(eventName: string): void;
    };
  }
}
export {};
```

### 4. 发布类库时生成声明文件

在`tsconfig.json`中开启：

```jsonc
{
  "compilerOptions": {
    "declaration": true,
    "declarationMap": true,
    "emitDeclarationOnly": false
  }
}
```

公共类型就是类库 API 的一部分。发布前要像检查运行时代码一样检查`.d.ts`输出。

---

## 第二十二站：运行时数据校验——TypeScript不是防火墙

假设接口返回：

```ts
interface User {
  id: number;
  name: string;
}
```

有人可能写出：

```ts
const response = await fetch("/api/user/1");
const user = (await response.json()) as User;
```

这只是告诉编译器"把它当作 User"，并没有真正验证数据。

如果服务器返回：

```json
{
  "id": "not-a-number",
  "name": null
}
```

TypeScript 不会在运行时自动阻止它。迁移到第四周时，阮清在结算链路里就揪出了这样一个被 `as` 掩盖的脏数据。

### 1. 手写校验

```ts
function isUser(value: unknown): value is User {
  if (typeof value !== "object" || value === null) {
    return false;
  }
  const data = value as Record<string, unknown>;
  return typeof data.id === "number" && typeof data.name === "string";
}
```

### 2. 使用Schema库

以常见的 Schema 思路为例：

```ts
const UserSchema = object({
  id: number(),
  name: string(),
});
```

实际项目中可以选择 Zod、Valibot、ArkType、TypeBox 等工具，关键不是具体库，而是建立以下边界意识：

```text
外部世界的数据默认不可信
        ↓
运行时解析与验证
        ↓
进入系统内部的强类型数据
```

应该重点校验：

- HTTP 请求与响应；
- URL 参数；
- 表单输入；
- localStorage；
- 数据库查询结果；
- 消息队列事件；
- 第三方 SDK 回调；
- 配置文件和环境变量。

---

## 第二十三站：用类型建模业务，而不是机械翻译数据库字段

初学者常把类型理解为"字段清单"：

```ts
interface Order {
  status: string;
  paid: boolean;
  shipped: boolean;
  cancelled: boolean;
}
```

这个类型允许大量矛盾状态：

- 已取消但已发货；
- 未付款但已发货；
- 已完成但状态仍是处理中。

可以使用判别联合重构：

```ts
type Order =
  | {
      status: "pending-payment";
      orderId: string;
      expiresAt: Date;
    }
  | {
      status: "paid";
      orderId: string;
      paidAt: Date;
    }
  | {
      status: "shipped";
      orderId: string;
      paidAt: Date;
      trackingNumber: string;
    }
  | {
      status: "completed";
      orderId: string;
      completedAt: Date;
    }
  | {
      status: "cancelled";
      orderId: string;
      reason: string;
    };
```

这样，每种状态只能访问自己真正拥有的数据。

```ts
function getTrackingNumber(order: Order): string | null {
  if (order.status === "shipped") {
    return order.trackingNumber;
  }
  return null;
}
```

这就是从"会写 TypeScript"到"会设计 TypeScript"的关键跨越：

> 类型不只是描述数据长什么样，还应该描述业务允许发生什么。

---

## 第二十四站：品牌类型——区分结构相同但含义不同的数据

TypeScript 使用结构类型系统。两个结构相同的类型通常可以互相赋值。

```ts
type UserId = string;
type OrderId = string;
```

编译器无法阻止把`OrderId`传给需要`UserId`的函数。

可以使用品牌类型：

```ts
declare const brand: unique symbol;
type Brand<T, Name extends string> = T & {
  readonly [brand]: Name;
};
type UserId = Brand<string, "UserId">;
type OrderId = Brand<string, "OrderId">;
```

```ts
function createUserId(value: string): UserId {
  if (!value.startsWith("user_")) {
    throw new Error("无效的用户ID");
  }
  return value as UserId;
}
```

```ts
function findUser(id: UserId): void {
  // 查询用户
}
```

品牌类型适合区分：

- 用户 ID 与订单 ID；
- 米与千米；
- 摄氏度与华氏度；
- 原始字符串与已验证字符串；
- 普通文本与经过转义的 HTML；
- 不同货币金额。

不要在完全没有运行时验证的情况下随意断言品牌类型，否则只是换一种方式欺骗编译器。

---

## 第二十五站：错误处理——不要把所有异常都当成Error

在 JavaScript 中，任何值都可以被`throw`：

```ts
throw new Error("失败");
throw "失败";
throw { code: 500 };
```

因此，捕获到的值应当按`unknown`处理：

```ts
try {
  await doSomething();
} catch (error: unknown) {
  if (error instanceof Error) {
    console.error(error.message);
  } else {
    console.error("未知错误", error);
  }
}
```

对于可预期的业务失败，可以使用结果类型：

```ts
type Result<T, E> =
  | { ok: true; value: T }
  | { ok: false; error: E };
```

```ts
type LoginError =
  | { type: "invalid-credentials" }
  | { type: "account-locked"; retryAt: Date }
  | { type: "network-error"; cause: Error };

async function login(
  username: string,
  password: string,
): Promise<Result<{ token: string }, LoginError>> {
  // 省略实现
  return {
    ok: false,
    error: { type: "invalid-credentials" },
  };
}
```

调用者必须显式处理成功和失败：

```ts
const result = await login("alice", "123456");
if (result.ok) {
  console.log(result.value.token);
} else {
  switch (result.error.type) {
    case "invalid-credentials":
      console.log("账号或密码错误");
      break;
    case "account-locked":
      console.log(`账号已锁定：${result.error.retryAt}`);
      break;
    case "network-error":
      console.log(result.error.cause.message);
      break;
  }
}
```

异常适合真正异常的情况；结果类型适合调用者需要正常处理的业务分支。

---

## 第二十六站：tsconfig核心选项详解

### 1. strict

```jsonc
{
  "compilerOptions": {
    "strict": true
  }
}
```

它会启用一组严格检查。新项目应优先开启。

### 2. noImplicitAny

禁止在无法推断时悄悄使用`any`。

### 3. strictNullChecks

严格区分`null`、`undefined`和其他类型。

### 4. noUncheckedIndexedAccess

```ts
const values: string[] = [];
const first = values[0];
```

开启后，`first`会被视为：

```ts
string | undefined
```

这更符合真实运行时行为。

### 5. exactOptionalPropertyTypes

更精确地区分"属性不存在"和"属性值为 undefined"。

### 6. noImplicitOverride

```ts
class BaseService {
  start(): void {}
}

class RenderService extends BaseService {
  override start(): void {}
}
```

当父类方法重命名时，这能减少无意间创建新方法的风险。

### 7. noFallthroughCasesInSwitch

避免`switch`分支意外穿透。

### 8. noEmit

只做类型检查，不生成 JavaScript：

```jsonc
{
  "compilerOptions": {
    "noEmit": true
  }
}
```

常见于由 Vite、Babel、SWC 或其他工具负责转译的项目。

### 9. declaration

生成`.d.ts`，适合类库和共享包。

### 10. skipLibCheck

跳过第三方声明文件内部的完整检查，可以缩短构建时间。但它不会让你自己的代码失去类型检查。

### 11. paths不是运行时解析器

```jsonc
{
  "compilerOptions": {
    "paths": {
      "@/*": ["./src/*"]
    }
  }
}
```

`paths`主要告诉 TypeScript 如何理解模块路径。你的运行时或打包器也必须配置相同规则，否则可能出现"编辑器不报错，运行时找不到模块"。

---

## 第二十七站：一个完整的小型实战——类型安全的任务管理器

四周迁移计划的收官作业：沈知远让阮清用 TypeScript 设计一个白板内的任务分配系统。

### 1. 定义领域模型

```ts
type TaskId = string;
type TaskStatus = "todo" | "doing" | "done";
type TaskPriority = "low" | "medium" | "high";

interface Task {
  readonly id: TaskId;
  title: string;
  description: string;
  status: TaskStatus;
  priority: TaskPriority;
  createdAt: Date;
  updatedAt: Date;
}
```

### 2. 区分创建输入与持久化对象

```ts
type CreateTaskInput = Pick<
  Task,
  "title" | "description" | "priority"
>;
```

### 3. 定义更新输入

```ts
type UpdateTaskInput = Partial<
  Pick<Task, "title" | "description" | "status" | "priority">
>;
```

### 4. 定义仓储接口

```ts
interface TaskRepository {
  findAll(): Promise<readonly Task[]>;
  findById(id: TaskId): Promise<Task | null>;
  create(input: CreateTaskInput): Promise<Task>;
  update(id: TaskId, input: UpdateTaskInput): Promise<Task | null>;
  delete(id: TaskId): Promise<boolean>;
}
```

### 5. 内存实现

```ts
class InMemoryTaskRepository implements TaskRepository {
  private readonly tasks = new Map<TaskId, Task>();

  async findAll(): Promise<readonly Task[]> {
    return [...this.tasks.values()];
  }

  async findById(id: TaskId): Promise<Task | null> {
    return this.tasks.get(id) ?? null;
  }

  async create(input: CreateTaskInput): Promise<Task> {
    const now = new Date();
    const task: Task = {
      id: crypto.randomUUID(),
      title: input.title,
      description: input.description,
      priority: input.priority,
      status: "todo",
      createdAt: now,
      updatedAt: now,
    };
    this.tasks.set(task.id, task);
    return task;
  }

  async update(
    id: TaskId,
    input: UpdateTaskInput,
  ): Promise<Task | null> {
    const current = this.tasks.get(id);
    if (!current) {
      return null;
    }
    const updated: Task = {
      ...current,
      ...input,
      id: current.id,
      createdAt: current.createdAt,
      updatedAt: new Date(),
    };
    this.tasks.set(id, updated);
    return updated;
  }

  async delete(id: TaskId): Promise<boolean> {
    return this.tasks.delete(id);
  }
}
```

### 6. 定义服务层错误

```ts
type TaskServiceError =
  | { type: "not-found"; taskId: TaskId }
  | { type: "invalid-title" }
  | { type: "invalid-transition"; from: TaskStatus; to: TaskStatus };
```

### 7. 约束状态流转

```ts
const allowedTransitions = {
  todo: ["doing"],
  doing: ["todo", "done"],
  done: [],
} as const satisfies Record<TaskStatus, readonly TaskStatus[]>;
```

### 8. 服务层

```ts
type Result<T, E> =
  | { ok: true; value: T }
  | { ok: false; error: E };

class TaskService {
  constructor(private readonly repository: TaskRepository) {}

  async createTask(
    input: CreateTaskInput,
  ): Promise<Result<Task, TaskServiceError>> {
    if (input.title.trim().length === 0) {
      return {
        ok: false,
        error: { type: "invalid-title" },
      };
    }

    const task = await this.repository.create({
      ...input,
      title: input.title.trim(),
    });

    return { ok: true, value: task };
  }

  async changeStatus(
    taskId: TaskId,
    nextStatus: TaskStatus,
  ): Promise<Result<Task, TaskServiceError>> {
    const task = await this.repository.findById(taskId);
    if (!task) {
      return {
        ok: false,
        error: { type: "not-found", taskId },
      };
    }

    const allowed: readonly TaskStatus[] = allowedTransitions[task.status];
    if (!allowed.includes(nextStatus)) {
      return {
        ok: false,
        error: {
          type: "invalid-transition",
          from: task.status,
          to: nextStatus,
        },
      };
    }

    const updated = await this.repository.update(taskId, {
      status: nextStatus,
    });
    if (!updated) {
      return {
        ok: false,
        error: { type: "not-found", taskId },
      };
    }

    return { ok: true, value: updated };
  }
}
```

这个例子体现了多个 TypeScript 设计原则：

- 用字面量联合表示有限状态；
- 用`Pick`、`Partial`派生输入类型；
- 用接口隔离业务逻辑和数据存储；
- 用`satisfies`校验配置完整性；
- 用结果类型显式表达业务失败；
- 用类型约束状态流转；
- 避免让无效数据进入系统核心。

---

## 第二十八站：TypeScript与React

「拾贝」的前端是 React 技术栈，这一站的内容直接用在了白板的组件库里。

React 组件属性可以使用接口或类型别名：

```tsx
interface ButtonProps {
  children: React.ReactNode;
  variant?: "primary" | "secondary";
  disabled?: boolean;
  onClick?: React.MouseEventHandler<HTMLButtonElement>;
}

export function Button({
  children,
  variant = "primary",
  disabled = false,
  onClick,
}: ButtonProps) {
  return (
    <button
      type="button"
      data-variant={variant}
      disabled={disabled}
      onClick={onClick}
    >
      {children}
    </button>
  );
}
```

### 1. useState

```ts
const [count, setCount] = useState(0);
```

通常可以自动推断。

联合状态需要明确：

```ts
const [user, setUser] = useState<User | null>(null);
```

### 2. 事件类型

```ts
function handleChange(event: React.ChangeEvent<HTMLInputElement>) {
  console.log(event.target.value);
}
```

### 3. ref

```ts
const inputRef = useRef<HTMLInputElement>(null);
```

### 4. 组件变体建模

```ts
type LinkButtonProps = {
  as: "a";
  href: string;
  onClick?: never;
};

type NativeButtonProps = {
  as?: "button";
  href?: never;
  onClick?: React.MouseEventHandler<HTMLButtonElement>;
};

type ButtonProps = (LinkButtonProps | NativeButtonProps) & {
  children: React.ReactNode;
};
```

通过联合类型，可以避免出现"渲染为链接却没有 href"等非法组合。

---

## 第二十九站：TypeScript与Node.js

### 1. 安装Node类型

```bash
npm install -D @types/node
```

### 2. 环境变量不能直接相信

```ts
const port = process.env.PORT;
```

`port`的类型通常是：

```ts
string | undefined
```

应该解析：

```ts
function getRequiredEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`缺少环境变量：${name}`);
  }
  return value;
}

const databaseUrl = getRequiredEnv("DATABASE_URL");
```

数字还需要额外转换：

```ts
function getNumberEnv(name: string, fallback: number): number {
  const raw = process.env[name];
  if (raw === undefined) {
    return fallback;
  }
  const value = Number(raw);
  if (!Number.isFinite(value)) {
    throw new Error(`环境变量 ${name} 必须是数字`);
  }
  return value;
}
```

### 3. ESM与CommonJS

Node.js 项目必须同时关注：

- `package.json`中的`type`；
- `tsconfig.json`中的`module`；
- 文件扩展名；
- 导入路径；
- 最终运行的 Node.js 版本；
- 测试工具和构建工具的模块支持。

很多"TypeScript 配置问题"本质上是 JavaScript 模块系统问题。

---

## 第三十站：测试TypeScript代码

类型检查不能替代测试，测试也不能替代类型检查。

它们解决不同问题：

```text
类型检查：这段代码在结构上是否合法？
单元测试：给定输入后，结果是否符合预期？
集成测试：多个模块协作是否正确？
端到端测试：真实用户流程是否可用？
```

### 1. 类型层测试

可以通过注释确认预期错误：

```ts
// @ts-expect-error 用户ID必须是字符串
findUser(123);
```

`@ts-expect-error`比`@ts-ignore`更安全，因为当下一行不再产生错误时，编译器会提醒你删除无效注释。

### 2. 运行时测试

```ts
import { describe, expect, it } from "vitest";

function add(a: number, b: number): number {
  return a + b;
}

describe("add", () => {
  it("应该返回两个数字之和", () => {
    expect(add(1, 2)).toBe(3);
  });
});
```

大型 TypeScript 项目应把类型检查作为 CI 的独立步骤：

```bash
npx tsc --noEmit
```

不要只依赖构建成功，因为有些构建工具只转译代码，并不执行完整类型检查。

---

## 第三十一站：代码质量工具

一个常见的工程组合是：

```text
TypeScript：类型检查
ESLint：代码规则与潜在问题
Prettier：代码格式化
Vitest/Jest：单元测试
Vite/Rollup/Rspack：构建
```

建议在`package.json`中定义统一脚本：

```jsonc
{
  "scripts": {
    "dev": "vite",
    "build": "tsc -b && vite build",
    "typecheck": "tsc --noEmit",
    "lint": "eslint .",
    "test": "vitest run"
  }
}
```

CI 中可以执行：

```bash
npm run typecheck
npm run lint
npm run test
npm run build
```

类型安全不是某个配置开关，而是一整套持续执行的工程流程。

---

## 第三十二站：Monorepo与Project References

大型项目可能包含多个包：

```text
packages/
├── api-client/
├── shared-types/
├── ui/
└── utils/

apps/
├── admin/
└── web/
```

TypeScript Project References 可以显式描述项目依赖。

根目录`tsconfig.json`：

```jsonc
{
  "files": [],
  "references": [
    { "path": "./packages/shared-types" },
    { "path": "./packages/api-client" },
    { "path": "./apps/web" }
  ]
}
```

子项目：

```jsonc
{
  "compilerOptions": {
    "composite": true,
    "declaration": true,
    "rootDir": "src",
    "outDir": "dist"
  },
  "include": ["src"]
}
```

构建：

```bash
npx tsc -b
```

清理：

```bash
npx tsc -b --clean
```

Project References 可以改善：

- 构建顺序；
- 增量构建；
- 包之间的边界；
- 声明文件生成；
- 编辑器在大型仓库中的理解能力。

但 Monorepo 还涉及包管理器工作区、构建缓存、发布策略和模块解析，不能只靠 TypeScript 配置解决全部问题。

---

## 第三十三站：常见错误与反模式

这一站是沈知远在代码评审里攒下来的"黑名单"，也是迁移期间阮清犯过一半以上的错。

### 1. 到处使用any

```ts
function process(data: any): any {
  return data.user.profile.name;
}
```

问题：

- 自动补全失效；
- 错误沿调用链传播；
- 重构无法得到可靠反馈。

更好的做法：

```ts
function process(data: unknown): string {
  // 先校验，再使用
  return "";
}
```

### 2. 过度使用as

```ts
const user = response as User;
```

断言不是验证。边界数据应进行运行时解析。

### 3. 只定义"万能对象"

```ts
interface Data {
  [key: string]: any;
}
```

这种类型几乎没有提供有效信息。

### 4. 所有字段都写成可选

```ts
interface User {
  id?: number;
  name?: string;
  email?: string;
}
```

这会迫使整个项目不断处理本不应该为空的数据。应该区分创建输入、更新输入、数据库实体和接口响应。

### 5. 使用Boolean、Number、String包装类型

不推荐：

```ts
let name: String;
let age: Number;
let enabled: Boolean;
```

推荐：

```ts
let name: string;
let age: number;
let enabled: boolean;
```

### 6. 忽视undefined

```ts
const user = users.find((item) => item.id === id);
console.log(user.name);
```

`find`可能返回`undefined`：

```ts
const user = users.find((item) => item.id === id);
if (!user) {
  throw new Error("用户不存在");
}
console.log(user.name);
```

### 7. 复杂类型没有命名

```ts
function execute(
  callback: (
    input: { id: string; payload: Record<string, unknown> },
  ) => Promise<{ success: boolean; error?: string }>,
): void {}
```

提取语义名称更易读：

```ts
interface CommandInput {
  id: string;
  payload: Record<string, unknown>;
}
interface CommandResult {
  success: boolean;
  error?: string;
}
type CommandHandler = (
  input: CommandInput,
) => Promise<CommandResult>;
```

### 8. 为了"高级"而制造高级类型

类型系统的目标是帮助人理解代码，不是证明作者会写复杂类型。

如果一个类型需要十分钟才能看懂，而且只节省了三行重复代码，它很可能不值得。

---

## 第三十四站：TypeScript性能优化思路

TypeScript 7.0 已显著提升编译器与语言服务性能，但类型设计和项目结构仍会影响大型项目体验。

### 1. 避免无限扩张的复杂类型

大量嵌套条件类型、递归类型和巨型联合可能增加检查成本。

### 2. 为公共边界添加显式返回类型

```ts
export function createConfig(): AppConfig {
  // ...
}
```

这有助于稳定公开 API，避免类型推断跨越过多实现细节。

### 3. 拆分大型项目

使用包边界、Project References 或构建工具的项目图，避免每次改动都检查整个仓库。

### 4. 控制自动引入的全局类型

在需要时显式配置：

```jsonc
{
  "compilerOptions": {
    "types": ["node", "vitest/globals"]
  }
}
```

### 5. 使用增量构建

```jsonc
{
  "compilerOptions": {
    "incremental": true
  }
}
```

### 6. 定期检查类型依赖

一个基础包的类型变化，可能让整个仓库重新检查。共享类型包应保持稳定、清晰、低耦合。

### 7. 不要把所有实现细节暴露为公共类型

公开 API 越大，消费者和编译器需要理解的内容就越多。通过明确的接口隔离内部实现。

---

## 第三十五站：从初学到精通的学习路线

### 第一阶段：掌握基础语法

重点学习：

- 基本类型；
- 数组与元组；
- 对象类型；
- 函数类型；
- 联合与交叉；
- `interface`与`type`；
- 类型推断；
- 类型收窄；
- `unknown`与`any`。

练习目标：把一个小型 JavaScript 项目迁移为 TypeScript，并开启`strict`。

### 第二阶段：掌握类型复用

重点学习：

- 泛型；
- `keyof`；
- `typeof`；
- 索引访问类型；
- 工具类型；
- `as const`；
- `satisfies`；
- 类型守卫。

练习目标：为 API、表单、状态管理和组件属性建立可复用类型。

### 第三阶段：掌握高级类型

重点学习：

- 映射类型；
- 条件类型；
- `infer`；
- 模板字面量类型；
- 分布式条件类型；
- 品牌类型；
- 判别联合；
- 声明文件。

练习目标：阅读常见类库的`.d.ts`文件，并实现几个自定义工具类型。

### 第四阶段：掌握工程化

重点学习：

- `tsconfig.json`；
- ESM 与 CommonJS；
- 模块解析；
- 声明文件生成；
- ESLint 与格式化；
- 单元测试；
- CI 类型检查；
- Monorepo；
- Project References；
- 构建性能。

练习目标：独立搭建一个包含应用、共享类型和工具包的多包项目。

### 第五阶段：掌握类型设计

重点学习：

- 领域建模；
- 非法状态不可表示；
- 运行时验证；
- 公共 API 设计；
- 类型与实现边界；
- 可维护性和编译性能之间的平衡。

练习目标：不再只是"为已有代码补类型"，而是先用类型设计业务规则，再编写实现。

---

## 第三十六站：精通TypeScript的十条原则

### 原则一：类型是设计工具，不是注释工具

不要只在代码写完后补类型。先思考数据结构、状态和边界。

### 原则二：让非法状态无法表示

优先使用判别联合，而不是一组互相矛盾的布尔值和可选字段。

### 原则三：公共边界明确，局部实现依赖推断

对外暴露的函数和模块保持稳定，内部避免冗余标注。

### 原则四：外部数据一律按unknown处理

来自网络、文件、存储和用户的数据都需要运行时验证。

### 原则五：尽量减少any

确实需要时限制在很小的边界内，不让它扩散到业务核心。

### 原则六：断言不是转换，也不是校验

`as`只影响编译器，不改变运行时值。

### 原则七：泛型用于表达关系

输入和输出之间没有关系时，不一定需要泛型。

### 原则八：类型越复杂，越要有业务价值

高级类型不是目的。可读、稳定、可调试才是目的。

### 原则九：类型检查必须进入CI

本地编辑器没有报错，不等于仓库在统一配置下没有错误。

### 原则十：先学好JavaScript，再深入TypeScript

TypeScript 不会替你理解闭包、原型、事件循环、异步、模块系统和运行时行为。

---

## 第三十七站：TypeScript 7.0意味着什么？

TypeScript 7.0 的重要变化，不是增加了某一个语法糖，而是编译器和语言服务底层实现的重大升级。

它采用原生实现与共享内存多线程能力，重点改善：

- 全量构建速度；
- 类型检查速度；
- 编辑器启动与项目加载；
- 自动补全和跳转响应；
- 大型代码库的开发体验；
- 标准语言服务器协议支持。

这意味着 TypeScript 正在解决一个长期问题：类型系统越强、项目越大，工具链性能压力也越明显。

但对普通开发者来说，不必因为版本升级重新学习整套语言。基础类型、泛型、收窄、条件类型和工程设计原则仍然适用。

升级大型项目时，建议：

1. 先在独立分支运行完整类型检查；
2. 检查已废弃的编译选项；
3. 验证构建工具、测试框架和编辑器插件；
4. 比较生成的声明文件；
5. 关注类型错误顺序和推断差异；
6. 在 CI 和实际大型项目中测量性能，而不是只看小型示例。

---

## 第三十八站：结语——TypeScript的终点不是"零报错"

刚开始学习 TypeScript 时，我们最关心的是：

```text
这个变量应该写什么类型？
```

继续深入后，我们会开始思考：

```text
这个泛型该如何约束？
这个联合类型该如何收窄？
这个工具类型该如何复用？
```

真正进入大型项目后，更重要的问题变成：

```text
这个类型是否准确表达了业务规则？
这个接口是否稳定？
这个状态是否允许出现矛盾？
这个外部数据是否经过验证？
这个高级类型是否值得维护？
这个类型设计会不会拖慢整个项目？
```

TypeScript 的终点并不是让项目"没有红色波浪线"，而是让程序结构更清晰，让团队沟通更准确，让重构更安全，让错误更早暴露。

从入门到精通的真正分水岭是：

> 初学者用类型描述代码，熟练者用类型约束代码，高手用类型设计系统。

---

## 附录一：常用命令速查

```bash
# 安装 TypeScript
npm install -D typescript

# 查看版本
npx tsc -v

# 创建 tsconfig.json
npx tsc --init

# 类型检查但不输出文件
npx tsc --noEmit

# 编译项目
npx tsc

# 监听文件变化
npx tsc --watch

# 构建 Project References
npx tsc -b

# 清理构建结果
npx tsc -b --clean
```

---

## 附录二：常用类型语法速查

```ts
// 联合类型
type ID = string | number;

// 交叉类型
type Admin = User & Permissions;

// 字面量联合
type Status = "idle" | "loading" | "success" | "error";

// 数组
type Names = string[];

// 元组
type Point = [number, number];

// 泛型
type ApiResponse<T> = {
  data: T;
};

// keyof
type UserKey = keyof User;

// 索引访问
type UserId = User["id"];

// 从变量提取类型
type Config = typeof config;

// 从数组提取成员类型
type Item = (typeof items)[number];

// 映射类型
type Optional<T> = {
  [K in keyof T]?: T[K];
};

// 条件类型
type IsString<T> = T extends string ? true : false;

// infer
type Element<T> = T extends Array<infer U> ? U : T;

// 模板字面量类型
type EventName<K extends string> = `${K}Changed`;

// 判别联合
type Result<T> =
  | { ok: true; value: T }
  | { ok: false; error: Error };
```

---

## 附录三：推荐学习资料

- [TypeScript 官方网站](https://www.typescriptlang.org/)
- [TypeScript 官方文档](https://www.typescriptlang.org/docs/)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [TypeScript Playground](https://www.typescriptlang.org/play)
- [TypeScript 7.0 官方发布说明](https://devblogs.microsoft.com/typescript/announcing-typescript-7-0/)
- [TypeScript GitHub 仓库](https://github.com/microsoft/TypeScript)

建议学习时遵循以下顺序：

```text
官方 Handbook
    ↓
在真实项目中开启 strict
    ↓
阅读项目依赖的 .d.ts 文件
    ↓
学习高级类型与类型建模
    ↓
研究大型项目配置和性能
```

不要试图一次背完全部语法。最有效的方式，是在真实代码中不断遇到问题、查阅文档、重构类型，并逐渐形成自己的类型设计判断。

---

> TypeScript 的难点，从来不是类型语法多，而是你能否让非法状态无法表示、让外部数据经过验证、让类型真正描述业务规则。

四周之期已到，「拾贝」的前端仓库全量 strict、CI 里多了一道 `tsc --noEmit`。阮清在周报里写下她这趟旅程的收获：类型不是给变量补的注释，而是把那次白屏事故，永远关进编译器的能力范围之内。
