# [JavaScript 从入门到精通：一篇文章构建完整知识体系](https://mp.weixin.qq.com/s/wYw9iQd8_CVyRL23G5ZKvQ)

> 这是一个关于“白鹭工作室”的故事——一间三人设计小团队，和他们的设计师小满从“只会改模板”到“能独立开发完整项目”的 JavaScript 全程修行。你会跟着小满一起，把变量、函数、闭包、原型、DOM、异步、事件循环、模块化、Node.js、性能与安全一条条打通，最后亲手做出待办、天气查询和简易博客三个项目。读完之后你会发现：JavaScript 入门并不难，真正困难的是建立完整的知识体系——把零散的语法，转化为解决实际问题的能力。

---

## 故事的起点：一个改不动的轮播图

“白鹭工作室”是三个年轻人的设计小团队：两个设计师，加上半路出家的小满。工作室刚接了一个官网外包，页面设计得漂亮，唯独领导图的交互没人会写——小满平时的“开发”，是在别人的模板里找差不多的代码块，改改文字和颜色。

这次客户点名要：首页轮播图、导航滚动高亮、一个能记住用户勾选状态的预约表单。

小满照例去搜代码，抄了一个轮播插件，结果和模板里的旧脚本冲突，页面报了一串红字；表单状态刷新就丢；导航高亮时灵时不灵。熬到第三天，控制台里的报错她已经会背了，但还是不知道从哪儿下手。

合伙人老纪看她把模板改得千疮百孔，把她拉到会议室，在白板上写了一行字：

> JavaScript 不仅是网页交互语言，它已经发展为覆盖前端、后端、桌面端、移动端、自动化脚本、数据可视化和人工智能应用的通用编程语言。你的问题不是抄错了代码，而是没有这套语言的完整知识体系。

老纪定了目标：**四周，从“会改模板”学到“能独立开发项目”，把手上的官网交互全部重写。**

这个故事，就是这四周走完的完整路线图。

---

## 第 1 站：为什么是 JavaScript——一门语言，一整个软件世界

第一周的第一天，老纪没有讲语法，先带小满看了一圈 JavaScript 的应用版图：

- **网页前端开发**：React、Vue、Angular、Svelte；
- **服务端开发**：Node.js、Express、NestJS；
- **桌面应用开发**：Electron、Tauri；
- **移动端开发**：React Native、Ionic；
- **跨平台小程序**：UniApp、Taro；
- **数据可视化**：ECharts、D3.js、Three.js；
- **自动化与工具开发**：命令行工具、爬虫、构建脚本；
- **全栈开发**：前后端统一使用 JavaScript 或 TypeScript。

“JavaScript 最大的优势之一，是让你用同一种语言贯穿完整的软件开发流程。”老纪说，“所以值得系统地学一遍，而不是继续零碎地抄。”

要学的具体是什么语言？老纪列了它的几张“身份证”：

- 动态类型语言；
- 弱类型语言；
- 基于原型的面向对象语言；
- 支持函数式编程；
- 支持事件驱动和异步编程；
- 可以运行在浏览器和服务器中的脚本语言。

“另外记住一件事：**JavaScript 和 Java 是两种完全不同的语言**。名字像而已，语法体系、运行环境和应用场景都完全不同。”他补充道，“JavaScript 的标准由 ECMAScript 规范定义，平时看到的 ES6、ES2015、ES2020，就是不同阶段的 ECMAScript 标准。”

## 第 2 站：搭建环境——三种方式跑起第一行代码

工欲善其事。老纪让小满把三种运行方式都试一遍。

**第一种，浏览器控制台。**打开开发者工具，在 Console 里输入：

```js
console.log("Hello, JavaScript!");
```

按下回车，就能看到输出。这是最快的学习沙盒。

**第二种，嵌入 HTML。**新建一个 `index.html`：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <title>JavaScript 入门</title>
</head>
<body>
  <h1 id="title">Hello</h1>

  <script>
    document.getElementById("title").textContent = "Hello JavaScript";
  </script>
</body>
</html>
```

也可以把 JavaScript 单独放进文件：

```html
<script src="./main.js"></script>
```

**第三种，Node.js。**安装 Node.js 后，新建 `app.js`：

```js
console.log("JavaScript 正在 Node.js 中运行");
```

终端执行：

```bash
node app.js
```

“浏览器是前端的家，Node 是后端的家，”老纪说，“这门语言在两个家里都能跑——这就是它和过去'网页脚本'最大的不同。”

## 第 3 站：变量、类型与运算符——地基的第一层

小满的第一课是变量声明。现代 JavaScript 推荐优先使用 `const` 和 `let`，尽量少用 `var`：

```js
const username = "Alice";
let score = 80;

score = 95;

console.log(username);
console.log(score);
```

三者区别一张表说清：

| 特性 | var | let | const |
| --- | --- | --- | --- |
| 作用域 | 函数作用域 | 块级作用域 | 块级作用域 |
| 是否可重复声明 | 可以 | 不可以 | 不可以 |
| 是否可重新赋值 | 可以 | 可以 | 不可以 |
| 是否存在变量提升 | 是 | 是，但有暂时性死区 | 是，但有暂时性死区 |

接着是七种常见数据类型。字符串用模板字符串插入变量最方便：

```js
const name = "JavaScript";
const message = `我正在学习 ${name}`;
```

数字：整数和小数通常都使用 `Number` 类型：

```js
const age = 18;
const price = 99.9;
const result = 10 / 3;
```

布尔值：

```js
const isLogin = true;
const isAdmin = false;
```

`undefined` 表示变量已声明但没有赋值：

```js
let value;
console.log(value); // undefined
```

`null` 表示“主动设置为空”：

```js
const selectedUser = null;
```

`Symbol` 用于创建唯一值：

```js
const id1 = Symbol("id");
const id2 = Symbol("id");

console.log(id1 === id2); // false
```

`BigInt` 用于表示超大整数：

```js
const bigNumber = 9007199254740993n;
```

对象、数组、函数都属于引用类型：

```js
const user = {
  name: "Alice",
  age: 20
};
```

类型判断用 `typeof`，判断数组推荐用 `Array.isArray([])`：

```js
console.log(typeof "hello");    // string
console.log(typeof 100);        // number
console.log(typeof true);       // boolean
console.log(typeof undefined);  // undefined
console.log(typeof {});         // object
console.log(typeof []);         // object
console.log(typeof function(){}); // function
```

类型转换的常用手段：转数字用 `Number(“123”)`、`parseInt(“123px”)`、`parseFloat(“3.14”)`；转字符串用 `String(123)` 和 `(123).toString()`。转布尔值时，以下值都是 `false`：

```text
false
0
-0
0n
""
null
undefined
NaN
```

其他大多数值都会转换为 `true`。运算符里老纪只强调了一条纪律：**推荐严格比较 `===`，尽量避免依赖隐式类型转换的宽松比较 `==`**——`5 === “5”` 是 `false`，`5 == “5”` 却是 `true`，后者就是小满模板里很多灵异 bug 的源头。逻辑运算符中还有个空值合并值得一提：

```js
const nickname = null;
const displayName = nickname ?? "匿名用户";
```

---

## 第 4 站：控制流——把“交互逻辑”写成代码

官网的表单校验、轮播切换，本质都是条件判断和循环。老纪从最基础的 if 语句讲起：

```js
const score = 85;

if (score >= 90) {
  console.log("优秀");
} else if (score >= 60) {
  console.log("及格");
} else {
  console.log("不及格");
}
```

简单的二选一可以用三元运算符：

```js
const message = age >= 18 ? "成年人" : "未成年人";
```

多分支匹配用 switch：

```js
const day = 2;

switch (day) {
  case 1:
    console.log("星期一");
    break;
  case 2:
    console.log("星期二");
    break;
  default:
    console.log("未知日期");
}
```

循环有四种写法，各有分工。经典 for 循环：

```js
for (let i = 0; i < 5; i++) {
  console.log(i);
}
```

while 循环：

```js
let count = 0;

while (count < 3) {
  console.log(count);
  count++;
}
```

`for...of` 适合遍历数组、字符串等可迭代对象：

```js
const fruits = ["苹果", "香蕉", "橙子"];

for (const fruit of fruits) {
  console.log(fruit);
}
```

`for...in` 用于遍历对象的可枚举属性：

```js
const user = {
  name: "Alice",
  age: 20
};

for (const key in user) {
  console.log(key, user[key]);
}
```

## 第 5 站：函数、作用域与闭包——JS 的灵魂三件套

“函数是 JavaScript 中最重要的概念之一，”老纪说，“先看它的四种形态。”函数声明：

```js
function add(a, b) {
  return a + b;
}

console.log(add(2, 3));
```

函数表达式：

```js
const multiply = function(a, b) {
  return a * b;
};
```

箭头函数，单行可以简写：

```js
const subtract = (a, b) => {
  return a - b;
};

const square = n => n * n;
```

参数还有两个增强：默认参数和剩余参数：

```js
function greet(name = "朋友") {
  console.log(`你好，${name}`);
}

function sum(...numbers) {
  return numbers.reduce((total, item) => total + item, 0);
}

console.log(sum(1, 2, 3, 4));
```

回调函数贯穿整个 JavaScript 世界：

```js
function processUser(name, callback) {
  console.log(`正在处理用户：${name}`);
  callback();
}

processUser("Alice", () => {
  console.log("处理完成");
});
```

**作用域**分四种：全局、函数、块级和模块作用域。变量的查找会沿着作用域链从内向外进行：

```js
const globalValue = "全局变量";

function test() {
  const functionValue = "函数变量";

  if (true) {
    const blockValue = "块级变量";
    console.log(blockValue);
  }

  console.log(functionValue);
}
```

然后是这块地基里最深的一口井——**闭包**：函数能够记住并访问其定义时所在的词法作用域。

```js
function createCounter() {
  let count = 0;

  return function() {
    count++;
    return count;
  };
}

const counter = createCounter();

console.log(counter()); // 1
console.log(counter()); // 2
console.log(counter()); // 3
```

“小满，你那个导航高亮'时灵时不灵'，”老纪说，“就是因为在循环里创建回调时没理解闭包。闭包常用于保存私有状态、封装数据、创建工厂函数、函数柯里化、防抖和节流、事件处理——后面第 11 站会用到它的实战形态。”

---

## 第 6 站：数组、对象与解构——数据的“容器”和“钥匙”

官网预约表单要管理一堆用户数据，正是练数组的好机会。创建数组后，先掌握增删四件套：

```js
const numbers = [1, 2, 3, 4, 5];

numbers.push(6);     // 尾部添加
numbers.pop();       // 尾部删除
numbers.unshift(0);  // 头部添加
numbers.shift();     // 头部删除
```

遍历用 `forEach`，而真正让老纪重点讲解的是五个“数据流水线”方法。`map` 返回一个新数组：

```js
numbers.forEach(item => {
  console.log(item);
});

const doubled = numbers.map(item => item * 2);
```

`filter` 筛选符合条件的元素：

```js
const evenNumbers = numbers.filter(item => item % 2 === 0);
```

`find` 查找第一个符合条件的元素：

```js
const result = numbers.find(item => item > 3);
```

`some` 与 `every` 做存在性和全称性判断：

```js
numbers.some(item => item > 4);
numbers.every(item => item > 0);
```

`reduce` 把数组归约成一个值：

```js
const total = numbers.reduce((sum, item) => {
  return sum + item;
}, 0);
```

顺手记一个高频技巧——用 `Set` 给数组去重：

```js
const values = [1, 2, 2, 3, 3, 4];
const uniqueValues = [...new Set(values)];
```

对象是另一种容器。方法简写、动态属性名都值得熟练：

```js
const user = {
  name: "Alice",
  age: 20,
  introduce() {
    console.log(`大家好，我是 ${this.name}`);
  }
};

console.log(user.name);
console.log(user["age"]);
```

```js
const key = "email";

const account = {
  [key]: "alice@example.com"
};
```

对象的解构与展开，是现代 JS 代码的日常：

```js
const { name, age } = user;

const updatedUser = {
  ...user,
  age: 21
};

Object.keys(user);
Object.values(user);
Object.entries(user);
```

解构赋值还有一些进阶形态。数组解构、跳过元素、默认值：

```js
const [first, second] = ["A", "B"];

const [a, , c] = [1, 2, 3];

const [value = 100] = [];
```

对象解构重命名：

```js
const { name: username } = user;
```

“记住一条：`const` 锁的是引用不是内容，”老纪说，“`const user = {...}` 之后 `user.age = 21` 完全合法——理解了值类型和引用类型的区别，你才算真正摸到这门语言的脾气。”

## 第 7 站：原型、Class 与 this——面向对象的“js 方式”

“你抄的那个轮播插件里有大量 `prototype`，”老纪说，“JavaScript 的对象继承基于原型。”

```js
const animal = {
  eat() {
    console.log("正在吃东西");
  }
};

const dog = Object.create(animal);

dog.bark = function() {
  console.log("汪汪");
};

dog.eat();
dog.bark();
```

当访问对象属性时，JavaScript 会：先查找对象自身属性；如果没有，查找对象的原型；继续向上查找原型的原型；直到找到属性或到达 `null`。这条查找链就是**原型链**。

传统写法是构造函数：

```js
function Person(name, age) {
  this.name = name;
  this.age = age;
}

Person.prototype.introduce = function() {
  console.log(`我是 ${this.name}，今年 ${this.age} 岁`);
};

const person = new Person("Alice", 20);
person.introduce();
```

`new` 操作符会完成四件事：创建一个新对象；将新对象的原型指向构造函数的 `prototype`；执行构造函数，并将 `this` 指向新对象；返回新对象。

现代 JavaScript 用 `class` 编写面向对象代码：

```js
class Person {
  constructor(name, age) {
    this.name = name;
    this.age = age;
  }

  introduce() {
    console.log(`我是 ${this.name}，今年 ${this.age} 岁`);
  }
}

const person = new Person("Alice", 20);
person.introduce();
```

继承用 `extends` 加 `super`：

```js
class Student extends Person {
  constructor(name, age, school) {
    super(name, age);
    this.school = school;
  }

  study() {
    console.log(`${this.name} 正在 ${this.school} 学习`);
  }
}
```

私有字段用 `#` 开头——外界拿不到，只能通过方法访问：

```js
class BankAccount {
  #balance = 0;

  deposit(amount) {
    this.#balance += amount;
  }

  getBalance() {
    return this.#balance;
  }
}
```

最后是这个阶段的“头号陷阱”——`this`。它的值取决于函数的调用方式。对象方法调用时，`this` 指向该对象：

```js
const user = {
  name: "Alice",
  showName() {
    console.log(this.name);
  }
};

user.showName();
```

严格模式下，普通函数中的 `this` 通常是 `undefined`；构造函数调用时 `this` 指向新对象。需要显式指定时，用 `call`、`apply` 或 `bind`：

```js
function show() {
  console.log(this.name);
}

const user = { name: "Alice" };

show.call(user);
show.apply(user);
const boundShow = show.bind(user);
boundShow();
```

“箭头函数没有自己的 `this`，会继承外层作用域中的 `this`，”老纪总结，“所以回调里要用 `this` 时，箭头函数往往是正确答案——你那个轮播插件的问题就出在普通函数回调丢了 `this`。”

---

## 第 8 站：DOM 与事件——正面硬刚那个轮播图

第二周，小满开始正面处理官网的交互。老纪先讲清概念：**DOM 是浏览器把 HTML 文档转换成的一棵对象树**。

```html
<button id="btn">点击我</button>
```

```js
const button = document.getElementById("btn");

button.addEventListener("click", () => {
  alert("按钮被点击了");
});
```

获取元素的现代写法是 `querySelector` 和 `querySelectorAll`（老的 `getElementById`、`getElementsByClassName`、`getElementsByTagName` 也会遇到）：

```js
document.getElementById("title");
document.getElementsByClassName("item");
document.getElementsByTagName("div");
document.querySelector(".item");
document.querySelectorAll(".item");
```

修改页面内容和样式：

```js
const title = document.querySelector("#title");

title.textContent = "新的标题";
title.innerHTML = "<span>带标签的标题</span>";

title.style.color = "red";
title.style.fontSize = "32px";
```

操作类名是切换状态最推荐的方式：

```js
title.classList.add("active");
title.classList.remove("active");
title.classList.toggle("active");
title.classList.contains("active");
```

创建和删除元素：

```js
const list = document.querySelector("#list");

const item = document.createElement("li");
item.textContent = "新的列表项";

list.appendChild(item);
```

```js
item.remove();
```

**事件机制**是交互的核心。绑定事件后，事件对象里带着一切上下文：

```js
const button = document.querySelector("#btn");

button.addEventListener("click", event => {
  console.log(event);
});
```

常见事件包括 `click`、`dblclick`、`input`、`change`、`submit`、`keydown`、`keyup`、`mouseenter`、`mouseleave`、`scroll`、`resize`。两个常用拦截：

```js
form.addEventListener("submit", event => {
  event.preventDefault(); // 阻止默认行为
});

event.stopPropagation(); // 阻止事件冒泡
```

**事件委托**——官网导航和列表项特别适用的技巧，可以减少事件监听器数量，并支持动态元素：

```js
const list = document.querySelector("#list");

list.addEventListener("click", event => {
  if (event.target.matches("li")) {
    console.log(event.target.textContent);
  }
});
```

表单处理是这些知识的综合演练：

```html
<form id="loginForm">
  <input id="username" type="text">
  <input id="password" type="password">
  <button type="submit">登录</button>
</form>
```

```js
const form = document.querySelector("#loginForm");

form.addEventListener("submit", event => {
  event.preventDefault();

  const username = document.querySelector("#username").value;
  const password = document.querySelector("#password").value;

  if (!username || !password) {
    console.log("请输入完整信息");
    return;
  }

  console.log({ username, password });
});
```

“记住勾选状态”这个需求，用的是浏览器存储。`localStorage` 的数据会长期保存在浏览器中：

```js
localStorage.setItem("username", "Alice");

const username = localStorage.getItem("username");

localStorage.removeItem("username");
localStorage.clear();
```

保存对象时需要序列化：

```js
const user = {
  name: "Alice",
  age: 20
};

localStorage.setItem("user", JSON.stringify(user));

const savedUser = JSON.parse(localStorage.getItem("user"));
```

`sessionStorage` 的使用方式与 `localStorage` 类似，但数据通常只在当前会话中保留。

到这里，官网的轮播图、导航高亮和表单记忆，小满全部用原生动手重写了一遍。“以前是抄，现在是知道每一行为什么这么写。”

## 第 9 站：异步编程——从回调地狱到事件循环

第三周进入全书的重头戏。同步代码按顺序执行，天经地义：

```js
console.log("第一步");
console.log("第二步");
console.log("第三步");
```

但耗时任务不能阻塞页面，异步代码把它们交给运行环境处理：

```js
console.log("开始");

setTimeout(() => {
  console.log("异步任务完成");
}, 1000);

console.log("结束");
```

输出顺序是：

```text
开始
结束
异步任务完成
```

最古老的异步形态是回调函数，层层嵌套时就会出“回调地狱”：

```js
function getData(callback) {
  setTimeout(() => {
    callback({ id: 1, name: "Alice" });
  }, 1000);
}

getData(data => {
  console.log(data);
});
```

**Promise** 是第一剂解药。它像一个“未来才兑现的承诺”，状态只会在 `resolve` 和 `reject` 之间定格一次：

```js
const promise = new Promise((resolve, reject) => {
  const success = true;

  setTimeout(() => {
    if (success) {
      resolve("请求成功");
    } else {
      reject(new Error("请求失败"));
    }
  }, 1000);
});

promise
  .then(result => {
    console.log(result);
  })
  .catch(error => {
    console.error(error);
  })
  .finally(() => {
    console.log("请求结束");
  });
```

并发场景有两个好用的组合器。`Promise.all` 等待多个任务全部完成：

```js
const p1 = Promise.resolve("A");
const p2 = Promise.resolve("B");
const p3 = Promise.resolve("C");

Promise.all([p1, p2, p3]).then(results => {
  console.log(results);
});
```

`Promise.allSettled` 无论成功还是失败，都返回最终结果：

```js
Promise.allSettled([p1, p2, p3]).then(results => {
  console.log(results);
});
```

**async 与 await** 让异步代码读起来像同步：

```js
function requestData() {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve({ id: 1, name: "Alice" });
    }, 1000);
  });
}

async function main() {
  const data = await requestData();
  console.log(data);
}

main();
```

错误处理用 `try...catch`：

```js
async function loadData() {
  try {
    const response = await fetch("/api/users");

    if (!response.ok) {
      throw new Error(`HTTP 错误：${response.status}`);
    }

    const data = await response.json();
    console.log(data);
  } catch (error) {
    console.error("加载失败：", error);
  }
}
```

网络请求的主力是 **Fetch API**。GET 请求：

```js
async function getUsers() {
  const response = await fetch("https://example.com/api/users");
  const users = await response.json();

  return users;
}
```

POST 请求：

```js
async function createUser(user) {
  const response = await fetch("https://example.com/api/users", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(user)
  });

  return response.json();
}
```

最后是压轴的**事件循环**——理解它，才算真正掌握 JavaScript 异步编程。运行时包含调用栈、Web APIs（或宿主环境 API）、宏任务队列和微任务队列。看这段经典的输出顺序题：

```js
console.log("1");

setTimeout(() => {
  console.log("2");
}, 0);

Promise.resolve().then(() => {
  console.log("3");
});

console.log("4");
```

输出是：

```text
1
4
3
2
```

原因在于执行顺序：同步代码先执行；Promise 回调进入微任务队列；setTimeout 回调进入宏任务队列；当前同步任务完成后，先清空微任务；再执行下一个宏任务。

“你的轮播图为什么'时灵时不灵'，”老纪说，“另一半答案在这里——你把依赖数据结果的逻辑写在了异步回调外面。弄懂事件循环，这类 bug 以后一眼就能看穿。”

---

## 第 10 站：函数式进阶——高阶函数、柯里化、防抖与节流

异步写顺之后，老纪把工具箱里最常用的几个进阶模式交给小满。

**高阶函数**：接收函数作为参数，或返回一个函数。

```js
function withLog(fn) {
  return function(...args) {
    console.log("参数：", args);
    const result = fn(...args);
    console.log("结果：", result);
    return result;
  };
}

const add = (a, b) => a + b;
const loggedAdd = withLog(add);

loggedAdd(2, 3);
```

**函数柯里化**：把多参数函数拆成逐个接收参数的链：

```js
function curryAdd(a) {
  return function(b) {
    return function(c) {
      return a + b + c;
    };
  };
}

console.log(curryAdd(1)(2)(3));
```

箭头函数写法更简洁：

```js
const add = a => b => c => a + b + c;
```

柯里化适合参数复用、创建可配置函数、函数组合和函数式编程。

**防抖**：事件连续触发时，只在停止触发一段时间后执行一次——搜索框联想、表单校验、窗口缩放、自动保存都靠它：

```js
function debounce(fn, delay) {
  let timer = null;

  return function(...args) {
    clearTimeout(timer);

    timer = setTimeout(() => {
      fn.apply(this, args);
    }, delay);
  };
}
```

**节流**：固定时间间隔内最多执行一次——页面滚动、鼠标移动、拖拽、高频点击：

```js
function throttle(fn, interval) {
  let lastTime = 0;

  return function(...args) {
    const now = Date.now();

    if (now - lastTime >= interval) {
      lastTime = now;
      fn.apply(this, args);
    }
  };
}
```

“看出来了吗？防抖和节流都是**闭包**的实战形态，”老纪说，“`timer` 和 `lastTime` 就靠返回的函数记住。”

**深拷贝与浅拷贝**也要分清。浅拷贝只复制第一层，嵌套对象仍然共享引用：

```js
const original = {
  name: "Alice",
  address: {
    city: "Hangzhou"
  }
};

const copy = { ...original };
```

现代运行环境推荐用 `structuredClone`：

```js
const copy = structuredClone(original);
```

JSON 方式存在明显限制：

```js
const copy = JSON.parse(JSON.stringify(original));
```

它不能正确处理 `undefined`、函数、`Symbol`、`Date`、`Map`、`Set` 和循环引用。

数据结构补充两员大将。**Set** 用于存储不重复值：

```js
const set = new Set([1, 2, 2, 3]);

set.add(4);
set.delete(2);
set.has(3);
```

**Map** 可以使用任意类型作为键：

```js
const userMap = new Map();

const user = { id: 1 };

userMap.set(user, "管理员");
console.log(userMap.get(user));
```

还有两个进阶武器，了解即可。**生成器**适合惰性计算、分批处理数据、自定义迭代流程、状态机和控制异步流程：

```js
function* numberGenerator() {
  yield 1;
  yield 2;
  yield 3;
}

const generator = numberGenerator();

console.log(generator.next());
console.log(generator.next());
console.log(generator.next());
```

**Proxy** 可以拦截对象操作，应用场景包括数据响应式、参数校验、权限控制、日志追踪和数据绑定：

```js
const user = {
  name: "Alice",
  age: 20
};

const proxy = new Proxy(user, {
  get(target, key, receiver) {
    console.log(`读取属性：${String(key)}`);
    return Reflect.get(target, key, receiver);
  },

  set(target, key, value, receiver) {
    console.log(`设置属性：${String(key)} = ${value}`);
    return Reflect.set(target, key, value, receiver);
  }
});

console.log(proxy.name);
proxy.age = 21;
```

正则表达式是文本处理利器：

```js
const phonePattern = /^1\d{10}$/;

console.log(phonePattern.test("13800138000"));
```

```js
pattern.test(text);
text.match(pattern);
text.replace(pattern, replacement);
text.search(pattern);
text.split(pattern);
```

```js
const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
```

“实际项目中，正则要尽量保持清晰，不要为了'一个表达式解决所有问题'而写出无法维护的规则。”老纪补了一句。

## 第 11 站：模块化与工程化——从“脚本”到“项目”

官网代码越来越多，小满开始把脚本拆成文件。**ES Modules** 是现代方案。导出：

```js
export const name = "JavaScript";

export function add(a, b) {
  return a + b;
}

export default class User {}
```

导入：

```js
import User, { name, add } from "./utils.js";
```

在浏览器中使用模块：

```html
<script type="module" src="./main.js"></script>
```

模块化的优势：降低代码耦合、避免全局变量污染、提高代码复用性、方便测试和维护、支持按需加载。

依赖管理交给 **npm**。初始化项目：

```bash
npm init -y
```

安装依赖和开发依赖：

```bash
npm install axios
npm install eslint --save-dev
```

`package.json` 是项目的身份证：

```js
{
  "name": "javascript-demo",
  "version": "1.0.0",
  "scripts": {
    "dev": "vite",
    "build": "vite build"
  },
  "dependencies": {},
  "devDependencies": {}
}
```

构建工具用 **Vite**，提供快速开发服务器、模块热更新、静态资源处理、生产环境构建、TypeScript 支持以及 React、Vue 等框架支持：

```bash
npm create vite@latest
npm install
npm run dev
npm run build
```

代码规范用两件套。**ESLint** 检查代码质量：未使用变量、潜在错误、不一致的代码风格、不推荐的语法写法。**Prettier** 自动格式化：缩进、引号、换行、分号、对象与数组格式。“团队项目中，ESLint 和 Prettier 通常会同时使用。”

**错误处理**也是工程化的一部分。`try...catch` 捕获异常：

```js
try {
  const data = JSON.parse("{错误的 JSON}");
  console.log(data);
} catch (error) {
  console.error("解析失败：", error.message);
}
```

主动抛出错误：

```js
function divide(a, b) {
  if (b === 0) {
    throw new Error("除数不能为 0");
  }

  return a / b;
}
```

自定义错误：

```js
class ValidationError extends Error {
  constructor(message) {
    super(message);
    this.name = "ValidationError";
  }
}
```

良好的错误处理应该做到：错误信息清晰、不吞掉异常、对用户展示友好提示、对开发者保留调试信息、对关键错误进行日志记录。

---

## 第 12 站：Node.js——把 JavaScript 写到服务器上

“你不是问过'JavaScript 能不能写后端'吗，”老纪说，“**Node.js 是一个能让 JavaScript 运行在服务器端的运行环境**。它可以用来开发 REST API、实时聊天服务、命令行工具、文件处理工具、自动化脚本、构建工具、微服务和服务端渲染应用。”

先看文件系统操作。读取文件：

```js
import fs from "node:fs/promises";

async function readFile() {
  const content = await fs.readFile("./data.txt", "utf-8");
  console.log(content);
}

readFile();
```

写入文件：

```js
await fs.writeFile("./output.txt", "Hello Node.js", "utf-8");
```

用原生 `http` 模块创建服务，能看清服务器的本质：

```js
import http from "node:http";

const server = http.createServer((request, response) => {
  response.writeHead(200, {
    "Content-Type": "application/json; charset=utf-8"
  });

  response.end(JSON.stringify({
    message: "Hello Node.js"
  }));
});

server.listen(3000, () => {
  console.log("服务器运行在 http://localhost:3000");
});
```

实际项目更常用 **Express** 框架。安装：

```bash
npm install express
```

创建服务：

```js
import express from "express";

const app = express();

app.use(express.json());

app.get("/api/users", (req, res) => {
  res.json([
    { id: 1, name: "Alice" },
    { id: 2, name: "Bob" }
  ]);
});

app.post("/api/users", (req, res) => {
  const user = req.body;

  res.status(201).json({
    message: "创建成功",
    data: user
  });
});

app.listen(3000, () => {
  console.log("API 服务已启动");
});
```

“第四周的博客项目后端就用它，”老纪说，“你已经会浏览器端的 JavaScript，这些代码读起来是不是格外亲切？”

## 第 13 站：性能与安全——上线前的必修课

官网要交付了，老纪把性能优化清单摊开。

**第一，减少不必要的 DOM 操作。**频繁修改 DOM 会触发页面重排和重绘，可以先在内存中创建再一次性插入：

```js
const fragment = document.createDocumentFragment();

for (let i = 0; i < 1000; i++) {
  const item = document.createElement("li");
  item.textContent = `第 ${i + 1} 项`;
  fragment.appendChild(item);
}

document.querySelector("#list").appendChild(fragment);
```

**第二，使用事件委托**，避免给大量子元素分别绑定事件。**第三，图片懒加载**：

```html
<img src="image.jpg" loading="lazy" alt="示例图片">
```

**第四，代码分割**，按需加载重模块：

```js
const module = await import("./heavy-module.js");
```

**第五，合理缓存**：浏览器缓存、内存缓存、localStorage、Service Worker、接口缓存。**第六，避免阻塞主线程**：大计算任务可以考虑分片执行、Web Worker、服务端计算，或使用高效算法和数据结构。

安全方面，老纪列了五条红线。**XSS**：不要直接把不可信内容插入 `innerHTML`，用 `element.textContent = userInput` 代替。**CSRF**：后端应使用 CSRF Token、SameSite Cookie、来源校验和合理的身份认证机制。**敏感信息泄露**：不要在前端代码中保存数据库密码、私钥、管理员密钥和永久有效的访问令牌。**依赖安全**：定期执行 `npm audit` 检查依赖。**输入校验**：“前端校验用于改善用户体验，后端校验才是安全边界。”

测试与调试贯穿始终。开发者工具的常用功能：Console（查看日志和错误）、Elements（检查 DOM 和样式）、Sources（设置断点）、Network（分析网络请求）、Performance（分析性能）、Application（查看缓存和存储）、Memory（分析内存使用）。断点可以直接写在代码里：

```js
function calculate(a, b) {
  debugger;
  return a + b;
}
```

日志有一套全家福：

```js
console.log();
console.table();
console.group();
console.time();
console.timeEnd();
console.trace();
```

“优秀开发者并不是不写错误，而是能够快速定位错误。”老纪说，“养成习惯：阅读完整报错信息、缩小问题范围、添加日志、设置断点、检查网络请求、构造最小复现、搜索关键错误信息、编写自动化测试。”

单元测试先从原理写起——一个最小的断言函数：

```js
function add(a, b) {
  return a + b;
}

function assertEqual(actual, expected, message) {
  if (actual !== expected) {
    throw new Error(
      `${message}：期望 ${expected}，实际 ${actual}`
    );
  }
}

assertEqual(add(2, 3), 5, "add 函数测试失败");
```

真实项目使用 Vitest、Jest、Mocha、Playwright 或 Cypress。测试通常分为单元测试、集成测试、端到端测试、性能测试和回归测试。

---

## 第 14 站：三个实战项目——四周修行的毕业设计

第四周是项目周。老纪设计了由易到难的三个项目。

**项目一：待办事项应用。**功能需求是添加任务、删除任务、标记完成、筛选任务、保存到 localStorage。核心数据结构：

```js
let todos = [
  {
    id: crypto.randomUUID(),
    title: "学习 JavaScript",
    completed: false
  }
];
```

添加任务：

```js
function addTodo(title) {
  const todo = {
    id: crypto.randomUUID(),
    title,
    completed: false
  };

  todos.push(todo);
  saveTodos();
  renderTodos();
}
```

保存与读取数据：

```js
function saveTodos() {
  localStorage.setItem("todos", JSON.stringify(todos));
}

function loadTodos() {
  const data = localStorage.getItem("todos");
  todos = data ? JSON.parse(data) : [];
}
```

这个小项目能练到 DOM 操作、事件处理、数组方法、状态管理、本地存储和模块化设计。

**项目二：天气查询应用。**核心流程五步：用户输入城市 → 调用天气接口 → 解析响应数据 → 渲染天气信息 → 处理加载和错误状态：

```js
async function getWeather(city) {
  const loading = document.querySelector("#loading");
  const errorBox = document.querySelector("#error");

  loading.hidden = false;
  errorBox.textContent = "";

  try {
    const response = await fetch(
      `/api/weather?city=${encodeURIComponent(city)}`
    );

    if (!response.ok) {
      throw new Error("天气数据加载失败");
    }

    const data = await response.json();
    renderWeather(data);
  } catch (error) {
    errorBox.textContent = error.message;
  } finally {
    loading.hidden = true;
  }
}
```

它覆盖 Fetch、async/await、错误处理、表单交互、加载状态和 API 数据渲染。

**项目三：简易博客系统**，包含文章列表、文章详情、新建文章、编辑文章、删除文章、用户登录、评论系统、后端 API 和数据库存储。推荐技术组合：

```text
前端：HTML + CSS + JavaScript
构建工具：Vite
后端：Node.js + Express
数据库：SQLite / PostgreSQL / MySQL
测试：Vitest + Playwright
```

“这个项目把 JavaScript 基础、浏览器编程、异步请求、后端开发和数据库操作全部串联起来，”老纪说，“做完它，你就不再是'改模板的人'了。”

## 第 15 站：路线图与 30 天计划——把路走完的方法

临别前，老纪把整套学习路线和一份 30 天计划交给了小满。

路线分四个阶段。**第一阶段：入门**——变量与数据类型、运算符、条件判断、循环、函数、数组、对象、基础 DOM 操作，练习项目选计算器、猜数字、颜色切换器、简单表单校验、待办事项列表。**第二阶段：进阶**——作用域与闭包、原型与原型链、this、Class、模块化、Promise、async/await、Fetch、事件循环、浏览器存储，练习项目选天气查询、记账应用、笔记应用、图片搜索、分页列表、Markdown 编辑器。**第三阶段：工程化**——npm、Vite、ESLint、Prettier、Git、单元测试、模块拆分、代码规范、性能优化、安全基础，练习项目选多页面网站、组件化后台管理界面、数据可视化看板、REST API 客户端。**第四阶段：框架与全栈**——前端方向有 React、Vue、Angular、Svelte；后端方向有 Node.js、Express、NestJS、数据库、身份认证、REST API、WebSocket；全栈项目可选博客系统、在线商城、实时聊天、项目管理工具、在线协作文档、SaaS 管理后台。

对应到 30 天，节奏是这样的：

- **第 1—5 天，语法基础**：变量、数据类型、运算符、条件判断、循环。练习：成绩判断、九九乘法表、数组求和、最大值和最小值、简单计算器；
- **第 6—10 天，函数与数据结构**：函数、箭头函数、数组方法、对象、解构、展开运算符。练习：商品数据筛选、学生成绩统计、数组去重、对象合并、购物车总价计算；
- **第 11—15 天，DOM 与事件**：选择元素、修改内容、创建元素、表单处理、事件机制、事件委托。项目：待办事项、标签页、模态框、图片轮播、表单校验；
- **第 16—20 天，异步编程**：回调、Promise、async/await、Fetch、错误处理、事件循环。项目：天气查询、随机用户生成器、图片搜索、新闻列表、分页数据加载；
- **第 21—25 天，工程化**：模块化、npm、Vite、ESLint、Prettier、Git、测试。项目：模块化记账应用、数据看板、Markdown 编辑器；
- **第 26—30 天，综合项目**：完成一个完整项目——需求分析、页面设计、数据结构设计、模块划分、API 调用、错误处理、测试、构建与发布。

同时要绕开四个常见误区。**只看教程不写代码**：编程不是靠“看懂”的，而是靠“写会”的——每学一个知识点，完成五步：手写一个最小示例、修改示例中的变量和逻辑、独立完成一道练习、在项目中使用一次、总结错误和解决方法。**过早学习框架**：如果函数、数组方法、对象、解构、模块、Promise、async/await、DOM 与事件、闭包、this 还没掌握，就直接学框架，容易只会复制代码——框架会变化，但 JavaScript 基础不会轻易过时。**只背语法不理解运行机制**：真正拉开差距的是作用域链、闭包、原型链、this 绑定、事件循环、内存管理、异步任务调度、模块加载和浏览器渲染过程——这些知识决定你能否解决复杂问题。**忽视调试能力**：定位错误的习惯本身就是竞争力。

## 尾声：交付日，客户没有改需求

四周后的交付会上，客户说轮播图想换成淡入淡出、表单要加两个字段、导航要加一个下拉菜单。

小满打开自己拆好的模块，改了三个文件，二十分钟全部演示完毕——没有冲突，没有报错，控制台干干净净。那个曾经让她熬了三个通宵的轮播图，如今只是她代码库里一个 `carousel.js`。

老纪在庆功时把她这四周的笔记浓缩成了一段话：

> “精通 JavaScript”并不意味着记住所有 API，而是五种能力：能够解释核心原理——为什么 Promise 回调比 setTimeout 更早执行、为什么箭头函数不能作为构造函数、为什么闭包能够保存变量；能够设计可维护的代码——模块边界清晰、函数职责单一、数据流可追踪；能够阅读源码——从入口文件、主要数据结构、核心执行流程读起；能够解决真实问题——需求拆解、技术选型、性能优化、故障排查；能够持续学习——先理解标准与原理，再学习框架和工具，通过项目验证知识。

学习路线始终是那一条：

```text
基础语法
→ 函数与数据结构
→ DOM 与浏览器
→ 异步编程
→ 模块化与工程化
→ 框架开发
→ Node.js 全栈
→ 性能、安全与架构
```

不要追求一次记住所有知识，也不要只停留在复制教程代码。每学完一个阶段，就做一个能运行、能展示、能继续迭代的项目。

> JavaScript 入门并不困难，真正困难的是建立完整的知识体系，并把零散的语法转化为解决实际问题的能力。

白鹭工作室的故事告一段落，但你的故事才刚刚开始。打开浏览器控制台，敲下第一行 `console.log` 吧。

---

## 官方资料与延伸阅读

- JavaScript 教程（MDN）：https://developer.mozilla.org/zh-CN/docs/Web/JavaScript
- ECMAScript 语言规范：https://tc39.es/ecma262/
- Node.js 官方文档：https://nodejs.org/docs/latest/api/
- Express 官方指南：https://expressjs.com/
- Vite 官方指南：https://vite.dev/guide/
- npm 官方文档：https://docs.npmjs.com/
- ESLint 官方文档：https://eslint.org/docs/latest/
- Prettier 官方文档：https://prettier.io/docs/
- Vitest 官方指南：https://vitest.dev/guide/
- TypeScript 官方手册：https://www.typescriptlang.org/docs/handbook/intro.html

> 版本提示：本文基于 ES2020+ 现代语法。JavaScript 生态迭代较快，实际使用时请以 MDN 与 ECMAScript 规范的最新说明为准。下一篇 TypeScript 深入可配合库内《TypeScript.md》阅读——先掌握 JavaScript 基础，再学类型系统，不要只会写类型而不理解运行机制。

