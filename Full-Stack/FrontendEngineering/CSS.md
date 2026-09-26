# [CSS 从入门到精通：从会写样式到构建现代前端界面](https://mp.weixin.qq.com/s/o6fHc8HdNtxj6sVnaXU3_w)

> 这是一个关于"贺川"的故事——一个干了三年 UI 设计、决定转前端开发的设计师。他做设计稿得心应手，可一写 CSS 就崩溃：明明照着稿子写的样式，到了浏览器里总差一点。你会跟着他一起，从"会写样式"走到"会设计 CSS 系统"。读完之后你会发现：真正掌握 CSS，不是背下一百个属性，而是理解浏览器如何计算样式、建立布局并完成绘制。

---

## 故事的起点：设计稿很漂亮，网页总差一点

贺川在"蓝屿工作室"做了三年 UI 设计，最近主动申请转岗前端。理由很朴素：他受够了"设计稿交出去，开发写出来总差一点"的拉扯，想自己把设计变成真的。

但真正动手写 CSS 的第一周，他就撞上了所有初学者都会撞的墙：

- 为什么写了 `width: 100%`，元素还是超出容器？
- 为什么设置了 `z-index: 9999`，弹窗仍然被遮挡？
- 为什么 `margin-top` 没有按预期生效？
- 为什么 Flexbox 一会儿横向，一会儿纵向？
- 为什么同一段 CSS 在不同页面表现不同？
- 为什么为了覆盖一个样式，只能不断增加选择器权重，最后到处都是 `!important`？

贺川翻着前任留下的样式文件——上千行、无数 `!important`、到处是 `left-box` 这种名字——他终于明白：这些问题的根源不是"属性记得不够多"，而是**没有建立完整的 CSS 心智模型**。

工作室接了个新项目：蓝屿的官网改版。贺川给自己定了个目标：这次不靠"多试几个像素"，而是系统地学一遍 CSS，把官网做出来，顺便沉淀一套可复用的样式系统。

学习 CSS，可以分为四个层次：

1. **会写样式**：知道选择器、颜色、字体、边距等基础语法；
2. **会做布局**：掌握盒模型、普通流、定位、Flexbox 和 Grid；
3. **会做响应式界面**：让页面适配不同屏幕和不同组件空间；
4. **会设计 CSS 系统**：处理级联、复用、主题、可维护性、性能和可访问性。

这个故事，就是他沿着这条路线从零走完的全程。

---

## 第一站：CSS 到底是什么？

贺川的第一课，是搞清楚 CSS 的本质。

CSS 的全称是 **Cascading Style Sheets**，中文通常译为"层叠样式表"。它是一种描述 HTML 或 XML 文档呈现方式的样式语言。

一个最基本的 CSS 规则由三部分组成：

```css
p {
  color: #334155;
  font-size: 18px;
}
```

其中：

- `p` 是**选择器**，用来找到需要设置样式的元素；
- `color`、`font-size` 是**属性**；
- `#334155`、`18px` 是**属性值**；
- 花括号中的内容称为**声明块**；
- `color: #334155` 是一条**声明**。

浏览器拿到 HTML 和 CSS 后，会解析文档结构和样式规则，计算每个元素最终应该使用的样式，然后进行布局、绘制与合成，最终形成我们看到的页面。

### CSS 的三种引入方式

#### 行内样式

```html
<p style="color: red;">这是一段文字</p>
```

优点是直接，缺点是难以复用和维护。除临时调试或特殊动态场景外，不建议大量使用。

#### 内部样式表

```html
<head>
  <style>
    p {
      color: red;
    }
  </style>
</head>
```

适合单页面示例、小型演示或邮件模板。

#### 外部样式表

```html
<link rel="stylesheet" href="styles.css" />
```

这是正式项目最常见的方式。HTML 负责结构，CSS 文件负责样式，职责更清晰，也便于缓存和复用。

---

## 第二站：选择器——CSS 如何找到元素？

选择器是 CSS 的入口。写得太弱，匹配不到元素；写得太复杂，又会让样式难以维护。

### 基础选择器

```css
/* 元素选择器 */
p {
  line-height: 1.8;
}

/* 类选择器 */
.card {
  border-radius: 16px;
}

/* ID 选择器 */
#app {
  min-height: 100vh;
}

/* 通配选择器 */
* {
  box-sizing: border-box;
}
```

在组件和业务开发中，**类选择器通常是最实用的选择**。ID 权重较高，不利于覆盖；元素选择器影响范围较大；通配选择器则适合重置或统一基础行为。

### 组合选择器

```css
/* 后代选择器 */
.article p {
  margin-block: 1em;
}

/* 子代选择器 */
.menu > li {
  list-style: none;
}

/* 相邻兄弟选择器 */
h2 + p {
  margin-top: 0;
}

/* 后续兄弟选择器 */
h2 ~ p {
  color: #475569;
}
```

组合选择器很强大，但不宜层级过深。下面这种写法虽然有效，却很脆弱：

```css
.page .content .article .section ul li a span {
  color: red;
}
```

只要 HTML 结构稍有变化，样式就可能失效。更好的做法是直接给目标元素增加语义明确的类名。

### 属性选择器

```css
input[type="email"] {
  border-color: #3b82f6;
}

button[disabled] {
  cursor: not-allowed;
  opacity: 0.5;
}

[class^="icon-"] {
  display: inline-block;
}
```

属性选择器适合表单状态、组件变体和带有特定属性的元素。

### 伪类

伪类用于描述元素的状态或结构关系。

```css
.button:hover {
  transform: translateY(-2px);
}

.input:focus-visible {
  outline: 3px solid rgb(59 130 246 / 35%);
  outline-offset: 2px;
}

.list-item:first-child {
  border-top: 0;
}

.list-item:nth-child(2n) {
  background: #f8fafc;
}

.form-field:has(input:invalid) {
  color: #dc2626;
}
```

常用伪类包括：

- 用户交互：`:hover`、`:active`、`:focus`、`:focus-visible`；
- 表单状态：`:checked`、`:disabled`、`:valid`、`:invalid`；
- 结构关系：`:first-child`、`:last-child`、`:nth-child()`；
- 逻辑组合：`:is()`、`:where()`、`:not()`；
- 父级匹配：`:has()`。

### 伪元素

伪元素用于选择元素的某个"虚拟部分"。

```css
.quote::before {
  content: "“";
  font-size: 3rem;
}

.badge::after {
  content: "NEW";
  margin-left: 0.5rem;
  font-size: 0.75rem;
}
```

常见伪元素有 `::before`、`::after`、`::first-line`、`::first-letter`、`::selection` 和 `::placeholder`。

> 需要注意：`::before` 和 `::after` 生成的内容不应承担重要语义。关键文本仍应写在 HTML 中，以保证可访问性和内容完整性。

---

## 第三站：层叠、继承与优先级——CSS 最核心的运行规则

CSS 中的 "Cascading" 指的就是层叠。当多条规则同时匹配一个元素时，浏览器必须决定最终采用哪一条声明。贺川说："不理解层叠，就不可能真正理解 CSS——这是'为什么样式不生效'的最终答案。"

### 样式从哪里来？

一个元素的最终样式可能来自：

- 浏览器默认样式；
- 用户样式；
- 网站作者编写的样式；
- 行内样式；
- 动画和过渡状态。

在日常开发中，最常遇到的是多个作者样式之间的竞争。

### 继承

部分属性会从父元素继承，例如：`color`、`font-family`、`font-size`、`line-height`、`text-align`。

而 `width`、`margin`、`padding`、`border` 通常不会继承。

```css
body {
  color: #1e293b;
  font-family: system-ui, sans-serif;
}
```

页面中的文字通常会继承这些基础设置，从而减少重复代码。

还可以显式控制继承：

```css
.button {
  font: inherit;
}
```

常见关键字包括：

- `inherit`：强制继承父元素的计算值；
- `initial`：恢复为属性的初始值；
- `unset`：可继承属性按继承处理，不可继承属性按初始值处理；
- `revert`：回退到较早来源或层级中的样式。

### 选择器优先级

可以把常见选择器的权重大致理解为：

```
行内样式 > ID 选择器 > 类/属性/伪类 > 元素/伪元素
```

例如：

```css
p {
  color: blue;
}

.article p {
  color: green;
}

#main .article p {
  color: red;
}
```

如果这三条规则同时匹配，第三条通常胜出，因为它包含 ID 选择器。

当优先级相同时，后声明的规则会覆盖前面的规则：

```css
.title {
  color: blue;
}

.title {
  color: red;
}
```

最终文字为红色。

### 不要依赖 `!important`

`!important` 会显著提高声明的优先级：

```css
.title {
  color: red !important;
}
```

它并非绝对不能用，但不应成为日常覆盖样式的主要手段。大量使用后，会形成"为了覆盖 `!important`，只能写更强的 `!important`"的恶性循环。

更好的策略是：

- 降低选择器复杂度；
- 使用组件类名；
- 控制样式加载顺序；
- 使用 `@layer` 管理级联层；
- 借助 `:where()` 创建低权重选择器。

### 用 `@layer` 管理大型项目

```css
@layer reset, base, components, utilities;

@layer reset {
  *,
  *::before,
  *::after {
    box-sizing: border-box;
  }
}

@layer base {
  body {
    margin: 0;
    font-family: system-ui, sans-serif;
  }
}

@layer components {
  .button {
    border-radius: 999px;
    padding: 0.75rem 1.25rem;
  }
}

@layer utilities {
  .hidden {
    display: none;
  }
}
```

级联层把样式按来源和职责分组，可以减少团队项目中的优先级冲突。它解决的不是"如何写出更高权重"，而是"如何避免权重竞赛"。

---

## 第四站：盒模型——理解尺寸问题的关键

贺川第一次用 CSS 写卡片时，`width: 100%` 的元素莫名其妙溢出了。答案就在盒模型里。

浏览器中的大多数元素都可以看成一个矩形盒子。一个盒子由四部分组成：

```
content → padding → border → margin
```

- `content`：内容区域；
- `padding`：内容与边框之间的内边距；
- `border`：边框；
- `margin`：元素与外部元素之间的外边距。

### `content-box` 的陷阱

默认情况下：

```css
.box {
  box-sizing: content-box;
  width: 300px;
  padding: 20px;
  border: 2px solid;
}
```

实际占用宽度为：

```
300 + 20 × 2 + 2 × 2 = 344px
```

这就是很多元素"明明设置了 100%，却仍然溢出"的原因。

### 推荐统一使用 `border-box`

```css
*,
*::before,
*::after {
  box-sizing: border-box;
}
```

在 `border-box` 模型下，声明的宽高包含内容、内边距和边框，更符合大多数布局场景的直觉。

### 外边距折叠

块级元素的垂直外边距在某些情况下会发生折叠。例如相邻两个块元素：

```css
.first {
  margin-bottom: 30px;
}

.second {
  margin-top: 20px;
}
```

它们之间的距离不一定是 50px，而可能取较大的 30px。

可以通过以下方式避免或改变折叠行为：

- 使用 `padding` 或 `gap`；
- 建立新的块级格式化上下文；
- 把父容器设为 Flex 或 Grid；
- 使用 `display: flow-root`。

> 现代布局中，推荐优先使用 `gap` 管理项目间距，而不是给每个子项手工设置方向性 `margin`。

---

## 第五站：长度、颜色与函数——别只会用 px

贺川做设计时习惯用 px，但写 CSS 后他发现：**只会用 px 是走不远的。**

### 常用长度单位

#### 绝对单位

```css
.box {
  width: 320px;
}
```

`px` 易于理解，适合边框、图标、精确控制的局部尺寸，但不应成为所有场景的唯一选择。

#### 相对字体单位

```css
.title {
  font-size: 2rem;
}

.button {
  padding: 0.75em 1.2em;
}
```

- `rem`：相对于根元素字体大小；
- `em`：在字体大小上通常相对于父元素，在其他属性上通常相对于当前元素字体大小。

`rem` 适合全局字号和间距系统，`em` 适合随组件字号缩放的局部尺寸。

#### 视口单位

```css
.hero {
  min-height: 100dvh;
}
```

常见单位包括：

- `vw`、`vh`：视口宽高的百分之一；
- `svh`：较小视口高度；
- `lvh`：较大视口高度；
- `dvh`：动态视口高度。

在移动浏览器地址栏会伸缩的场景中，`dvh` 往往比传统 `vh` 更贴近当前可视区域。

#### 容器查询单位

当元素处于查询容器中时，可以使用 `cqw`、`cqh`、`cqi`、`cqb` 等单位，让尺寸相对于容器而不是整个视口变化。

### 百分比并不总是相对同一个对象

百分比值的参照物取决于属性。例如：

- `width: 50%` 通常相对于包含块宽度；
- `font-size: 120%` 相对于父元素字体大小；
- `transform: translateX(50%)` 相对于元素自身宽度。

因此，不能把所有 `%` 都简单理解为"相对父元素"。

### 颜色写法

```css
.demo {
  color: #2563eb;
  background: rgb(15 23 42 / 90%);
  border-color: hsl(215 20% 65%);
}
```

现代 CSS 颜色函数支持更灵活的写法。实际项目中建议建立设计变量，而不是在各处散落硬编码颜色。

### `calc()`、`min()`、`max()` 与 `clamp()`

```css
.sidebar {
  width: min(320px, 30vw);
}

.main {
  width: calc(100% - 2rem);
}

.title {
  font-size: clamp(2rem, 5vw, 4.5rem);
}
```

`clamp(最小值, 理想值, 最大值)` 特别适合流式字号、间距和容器尺寸。

---

## 第六站：文字排版——页面高级感往往来自细节

作为设计师，贺川对文字最敏感。他说："网页的高级感，一半来自排版。"

```css
.article {
  color: #1e293b;
  font-family:
    system-ui,
    -apple-system,
    "Segoe UI",
    "PingFang SC",
    "Microsoft YaHei",
    sans-serif;
  font-size: 1rem;
  line-height: 1.8;
}

.article h1 {
  font-size: clamp(2rem, 6vw, 4rem);
  line-height: 1.1;
  letter-spacing: -0.03em;
}

.article p {
  max-width: 70ch;
}
```

### 常用文字属性

- `font-family`：字体族；
- `font-size`：字号；
- `font-weight`：字重；
- `line-height`：行高；
- `letter-spacing`：字间距；
- `text-align`：对齐方式；
- `text-decoration`：装饰线；
- `text-transform`：大小写转换；
- `white-space`：空白处理；
- `word-break`、`overflow-wrap`：断词与换行策略。

### 单行省略

```css
.single-line {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
```

### 多行省略

```css
.multi-line {
  display: -webkit-box;
  overflow: hidden;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
}
```

多行截断在实际使用前应核对目标浏览器兼容性，并确保用户仍有办法访问完整内容。

---

## 第七站：背景、边框、阴影与视觉层次

卡片是贺川做官网时最常用的元素。他学会了用三层"皮肤"塑造视觉层次：

```css
.card {
  border: 1px solid rgb(148 163 184 / 25%);
  border-radius: 20px;
  background:
    linear-gradient(135deg, rgb(255 255 255 / 92%), rgb(248 250 252 / 78%));
  box-shadow:
    0 1px 2px rgb(15 23 42 / 5%),
    0 20px 50px rgb(15 23 42 / 10%);
}
```

### 背景图控制

```css
.hero {
  background-image: url("hero.jpg");
  background-position: center;
  background-repeat: no-repeat;
  background-size: cover;
}
```

`cover` 会让图片覆盖整个容器，可能裁剪；`contain` 会保证整张图片可见，可能留白。

### 图片适配

```css
.cover-image {
  width: 100%;
  height: 240px;
  object-fit: cover;
  object-position: center;
}
```

`object-fit` 常用于 `<img>` 和 `<video>`：

- `cover`：填满容器，允许裁剪；
- `contain`：完整显示，允许留白；
- `fill`：强制拉伸；
- `none`：保持原始尺寸。

### 固定宽高比

```css
.thumbnail {
  aspect-ratio: 16 / 9;
  overflow: hidden;
}
```

`aspect-ratio` 可以显著减少传统"百分比 padding 占位法"的使用。

---

## 第八站：普通流、display 与定位系统

### 普通文档流

默认情况下：

- 块级元素从上到下排列；
- 行内内容从左到右排列并自动换行；
- 元素通常不会互相覆盖。

这是浏览器最自然、最稳定的布局方式。不要一开始就依赖绝对定位；能使用普通流解决的问题，通常更容易响应式适配。

### `display`

常见值包括：

```css
.block {
  display: block;
}

.inline {
  display: inline;
}

.inline-block {
  display: inline-block;
}

.flex {
  display: flex;
}

.grid {
  display: grid;
}

.hidden {
  display: none;
}
```

`display: none` 会让元素从布局树中消失，通常也不会被辅助技术读取。如果只是视觉隐藏但仍需保留给屏幕阅读器，应使用专门的 visually-hidden 技术，而不是简单设置 `display: none`。

### 定位方式

#### 相对定位

```css
.item {
  position: relative;
  top: 4px;
}
```

元素仍占据原来的布局空间，只是在视觉上发生偏移。更常见的用途，是为绝对定位子元素建立定位参考。

#### 绝对定位

```css
.card {
  position: relative;
}

.card__badge {
  position: absolute;
  top: 12px;
  right: 12px;
}
```

绝对定位元素脱离普通流，其包含块通常与最近的已定位祖先有关。

#### 固定定位

```css
.back-to-top {
  position: fixed;
  right: 24px;
  bottom: 24px;
}
```

常用于悬浮按钮、固定工具栏和全局遮罩。

#### 粘性定位

```css
.sidebar {
  position: sticky;
  top: 16px;
}
```

`sticky` 可以理解为"在一定滚动范围内保持吸附"。它是否生效还受滚动容器、可用空间以及祖先元素溢出设置等因素影响。

### `z-index` 为什么有时不听话？

`z-index` 不是全局统一比较，而是在不同的**堆叠上下文**中比较。某些属性会创建新的堆叠上下文，例如：

- 已定位元素配合非 `auto` 的 `z-index`；
- `opacity` 小于 1；
- `transform` 不为 `none`；
- `filter`；
- `isolation: isolate`。

如果子元素被困在较低层级的祖先堆叠上下文中，即使写 `z-index: 999999`，也未必能盖过另一个更高层级的祖先。

调试时不要只看当前元素，而要沿祖先链检查谁创建了堆叠上下文。

---

## 第九站：Flexbox——一维布局的主力工具

贺川做官网导航时第一次用 Flexbox，立刻爱上了它。Flexbox 适合在一个主要方向上排列元素，这个方向可以是横向，也可以是纵向。

```css
.toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}
```

### 两条轴

Flexbox 有两个重要方向：

- **主轴**：由 `flex-direction` 决定；
- **交叉轴**：与主轴垂直。

```css
.container {
  display: flex;
  flex-direction: row;
}
```

当 `flex-direction: row` 时：`justify-content` 控制水平方向，`align-items` 控制垂直方向。

当 `flex-direction: column` 时，两者控制的方向会交换。因此不要死记"justify 是水平、align 是垂直"，而应记住"**一个控制主轴，一个控制交叉轴**"。

### 常用容器属性

```css
.container {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: center;
  align-items: stretch;
  align-content: start;
  gap: 1rem;
}
```

- `flex-direction`：主轴方向；
- `flex-wrap`：是否换行；
- `justify-content`：主轴分布；
- `align-items`：单行项目在交叉轴上的对齐；
- `align-content`：多行整体在交叉轴上的分布；
- `gap`：项目间距。

### 子项伸缩

```css
.main {
  flex: 1 1 auto;
  min-width: 0;
}

.sidebar {
  flex: 0 0 280px;
}
```

`flex` 是以下属性的简写：

```
flex-grow flex-shrink flex-basis
```

- `flex-grow`：剩余空间如何分配；
- `flex-shrink`：空间不足时如何缩小；
- `flex-basis`：分配前的基础尺寸。

一个常见坑是：Flex 子项默认可能不愿缩小到内容宽度以下。对于包含长文本的可伸缩项目，常常需要：

```css
.flex-child {
  min-width: 0;
}
```

否则文本可能溢出，省略号也可能失效。

### Flexbox 常见场景

- 导航栏；
- 按钮组；
- 头像与文字信息；
- 水平垂直居中；
- 等高卡片行；
- 固定侧栏 + 自适应主内容；
- 页脚贴底布局。

经典居中：

```css
.center {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
}
```

---

## 第十站：Grid——二维布局的核心能力

Grid 同时管理行和列，适合页面骨架、卡片矩阵和复杂二维布局。

```css
.gallery {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
}
```

### 响应式卡片网格

贺川最喜欢的"一行代码"：

```css
.gallery {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(min(100%, 240px), 1fr));
  gap: 1.5rem;
}
```

这段代码非常实用：

- 每列期望至少 240px；
- 容器较宽时自动增加列数；
- 空间不足时自动换行；
- `min(100%, 240px)` 可减少极窄容器中的溢出风险。

### `fr` 单位

`fr` 表示网格容器中可分配空间的一份：

```css
.layout {
  display: grid;
  grid-template-columns: 240px 1fr 1fr;
}
```

第一列固定 240px，后两列平均分配剩余空间。

### 网格区域

```css
.page {
  display: grid;
  grid-template:
    "header header" auto
    "sidebar main" 1fr
    "footer footer" auto
    / 260px 1fr;
  min-height: 100vh;
}

.header {
  grid-area: header;
}

.sidebar {
  grid-area: sidebar;
}

.main {
  grid-area: main;
}

.footer {
  grid-area: footer;
}
```

这种写法非常适合表达页面整体结构——贺川官网的页面骨架就是这么搭的。

### Flexbox 还是 Grid？

可以用一句话区分：

- **Flexbox 更擅长一维排列**；
- **Grid 更擅长二维布局**。

但它们不是互斥关系。常见做法是：

- 页面大框架用 Grid；
- 卡片内部、导航和按钮组用 Flexbox。

> 不要为了"只用一种技术"而强行选择。根据布局问题本身决定工具。

---

## 第十一站：响应式设计——从适配屏幕到适配空间

响应式设计的目标不是为每一种设备写一套页面，而是让同一套界面在不同空间中保持可读、可用和协调。

### 移动优先

```css
.page {
  padding: 1rem;
}

@media (min-width: 48rem) {
  .page {
    padding: 2rem;
  }
}

@media (min-width: 75rem) {
  .page {
    max-width: 72rem;
    margin-inline: auto;
  }
}
```

移动优先意味着先写小屏基础样式，再使用 `min-width` 增强大屏体验。这样通常更容易保持样式简洁。

### 不要按设备名称设计断点

不要把断点简单理解为"手机、平板、电脑"。更稳妥的方法是：

1. 先让内容自然排列；
2. 缩放浏览器窗口；
3. 在布局开始拥挤或失衡的位置添加断点。

断点应服务于内容，而不是服务于某个具体设备型号。

### 流式布局

```css
.container {
  width: min(100% - 2rem, 72rem);
  margin-inline: auto;
}

.hero-title {
  font-size: clamp(2.25rem, 8vw, 5.5rem);
}
```

流式布局通过百分比、`min()`、`max()`、`clamp()`、Grid 和 Flexbox，让页面在断点之间也能平滑变化。

### 容器查询

媒体查询根据视口判断，而容器查询根据**组件所在容器的尺寸**判断。

```css
.product-list {
  container-type: inline-size;
}

.product-card {
  display: grid;
  gap: 1rem;
}

@container (min-width: 34rem) {
  .product-card {
    grid-template-columns: 12rem 1fr;
    align-items: center;
  }
}
```

同一个卡片可能出现在主内容区、侧边栏或弹窗中。容器查询让组件根据"自己实际获得的空间"变化，而不是根据整个浏览器窗口变化。

这使 CSS 从"页面响应式"进一步走向"**组件响应式**"。

### 用户偏好媒体查询

```css
@media (prefers-color-scheme: dark) {
  :root {
    color-scheme: dark;
  }
}

@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    scroll-behavior: auto !important;
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

响应式不仅是屏幕尺寸，也包括深色模式、减少动画、对比度、输入方式和打印环境等用户需求。

---

## 第十二站：CSS 自定义属性——建立设计系统的基础

贺川作为设计师，最关心"设计系统怎么落地"——答案就是 CSS 自定义属性（常被称为 CSS 变量）。

```css
:root {
  --color-primary: #2563eb;
  --color-text: #0f172a;
  --color-muted: #64748b;
  --radius-md: 12px;
  --radius-lg: 20px;
  --space-1: 0.25rem;
  --space-2: 0.5rem;
  --space-3: 0.75rem;
  --space-4: 1rem;
  --space-6: 1.5rem;
}

.button {
  padding: var(--space-3) var(--space-6);
  border-radius: var(--radius-md);
  background: var(--color-primary);
}
```

### 自定义属性可以参与级联

```css
.card {
  --card-accent: #2563eb;
  border-top: 4px solid var(--card-accent);
}

.card--warning {
  --card-accent: #f59e0b;
}
```

不需要重写完整组件，只需覆盖局部变量即可产生变体。

### 变量回退值

```css
.title {
  color: var(--title-color, #0f172a);
}
```

如果 `--title-color` 未定义，就使用后面的回退值。

### 主题切换

```css
:root {
  --surface: #ffffff;
  --text: #0f172a;
}

[data-theme="dark"] {
  --surface: #0f172a;
  --text: #f8fafc;
}

body {
  color: var(--text);
  background: var(--surface);
}
```

CSS 变量非常适合管理颜色、间距、圆角、阴影、字体和动画时长，它们是**设计令牌落地到前端的重要载体**。

---

## 第十三站：过渡、变换与动画

贺川给官网加交互反馈时，学了过渡、变换与动画三件套。

### 过渡

```css
.button {
  transition:
    transform 180ms ease,
    box-shadow 180ms ease,
    background-color 180ms ease;
}

.button:hover {
  transform: translateY(-2px);
  box-shadow: 0 10px 24px rgb(15 23 42 / 18%);
}
```

不要无条件使用：

```css
transition: all 0.3s;
```

`all` 可能让不需要动画的属性也参与过渡，增加调试难度。最好明确指定需要变化的属性。

### 变换

```css
.icon {
  transform: translateX(4px) rotate(6deg) scale(1.05);
}
```

常见函数：

- `translate()`：位移；
- `scale()`：缩放；
- `rotate()`：旋转；
- `skew()`：倾斜。

### 关键帧动画

```css
@keyframes float {
  0%,
  100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-10px);
  }
}

.illustration {
  animation: float 3s ease-in-out infinite;
}
```

动画应服务于反馈、层次和理解，而不是单纯追求炫技。

### 动画性能原则

通常更适合动画的属性包括：

- `transform`
- `opacity`

频繁动画 `width`、`height`、`top`、`left` 等布局相关属性，可能触发更多布局与绘制工作。实际性能还需通过浏览器开发者工具测量，不应只凭经验猜测。

同时，应尊重用户的 `prefers-reduced-motion` 设置，为对动态效果敏感的用户降低或关闭非必要动画。

---

## 第十四站：现代 CSS——少写代码，表达更强

贺川发现，CSS 已经不再只是传统的颜色、边距和浮动布局。现代 CSS 提供了更强的原生能力。

### 原生嵌套

```css
.card {
  padding: 1.5rem;
  border-radius: 1rem;

  & h2 {
    margin-top: 0;
  }

  &:hover {
    box-shadow: 0 16px 40px rgb(15 23 42 / 12%);
  }

  @media (min-width: 48rem) {
    padding: 2rem;
  }
}
```

原生 CSS 嵌套由浏览器直接解析，与 Sass 等预处理器的编译式嵌套不是同一机制。嵌套层级依然应保持克制，否则会重新制造过长选择器。

### 逻辑属性

```css
.card {
  margin-inline: auto;
  padding-block: 1.5rem;
  padding-inline: 2rem;
  border-inline-start: 4px solid #2563eb;
}
```

逻辑属性不直接绑定"左、右、上、下"，而是根据书写模式表示：

- `inline`：文字行进方向；
- `block`：块排列方向。

常见属性：`margin-inline`、`margin-block`、`padding-inline`、`padding-block`、`inset-inline-start`、`border-block-end`。

它们更有利于国际化和不同书写方向的适配。

### `:is()` 与 `:where()`

```css
:is(h1, h2, h3) {
  line-height: 1.2;
}

.article :where(ul, ol) {
  padding-inline-start: 1.5rem;
}
```

`:is()` 可以合并重复选择器；`:where()` 的特殊之处是自身不增加选择器权重，适合编写容易覆盖的基础样式。

### `:has()`

```css
.card:has(.card__image) {
  padding-top: 0;
}

.form-group:has(input:focus-visible) {
  border-color: #2563eb;
}
```

`:has()` 可以根据后代或相对关系选择元素，常被称为"父选择器能力"，但它的用途不止选择父元素。

### `subgrid`

```css
.cards {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
}

.card {
  display: grid;
  grid-template-rows: subgrid;
  grid-row: span 3;
}
```

`subgrid` 允许子网格继承父网格的轨道，使多张卡片的标题、正文和按钮更容易对齐。使用前仍应根据目标环境核对兼容性。

---

## 第十五站：CSS 工程化——从"能用"走向"可维护"

随着项目扩大，CSS 的难点往往不再是实现效果，而是控制影响范围、避免重复和降低修改成本。

### 命名要表达职责

不推荐：

```css
.red-text {}
.left-box {}
.big-font {}
```

这些类名绑定了当前视觉效果。一旦设计改变，命名就会失真。

更推荐：

```css
.article-title {}
.product-card {}
.form-error {}
```

它们描述的是**元素角色**，而不是某个暂时的样式值。

### BEM 命名示例

```css
.card {}
.card__title {}
.card__content {}
.card__footer {}
.card--featured {}
```

BEM 的核心不是必须使用双下划线和双连字符，而是明确：

- Block：独立组件；
- Element：组件内部元素；
- Modifier：组件状态或变体。

### 按职责分层

一个中大型项目可以采用类似结构：

```
styles/
├── reset.css
├── tokens.css
├── base.css
├── layout.css
├── components/
│   ├── button.css
│   ├── card.css
│   └── modal.css
├── utilities.css
└── app.css
```

也可以配合 `@layer`：

```css
@layer reset, tokens, base, layout, components, utilities, overrides;
```

### 组件样式应尽量自包含

好的组件通常具备以下特点：

- 不依赖过深的父级结构；
- 不随意污染全局元素；
- 可通过变量控制主题和变体；
- 在不同宽度容器中仍能工作；
- 有明确的焦点、禁用、加载和错误状态；
- 不需要大量 `!important` 才能覆盖。

### Utility 与组件类并不冲突

工具类适合表达原子能力：

```css
.u-visually-hidden {}
.u-text-center {}
.u-stack-lg {}
```

组件类适合表达业务语义：

```css
.product-card {}
.checkout-summary {}
```

关键不是争论"只能选哪一种"，而是**制定一致的团队约定**。

---

## 第十六站：可访问性——样式不能只追求好看

贺川在做设计时就很在意无障碍，写 CSS 后他更确认：样式是用户体验的一部分。

### 保留可见的键盘焦点

错误做法：

```css
button:focus {
  outline: none;
}
```

更好的做法：

```css
button:focus-visible {
  outline: 3px solid rgb(37 99 235 / 40%);
  outline-offset: 3px;
}
```

如果移除浏览器默认焦点样式，就必须提供清晰的替代方案。

### 不要只靠颜色传达状态

错误信息不应只有红色边框，还应有图标、文字说明或其他可辨别信息。

```css
.field-error {
  display: flex;
  gap: 0.5rem;
  color: #b91c1c;
}
```

### 确保文字对比度与可缩放性

- 正文不要使用过浅的灰色；
- 不要锁死用户缩放；
- 重要文字避免放在复杂背景上；
- 控件状态之间要有足够差异。

### 视觉隐藏

有时需要让文字对视觉用户隐藏，但保留给屏幕阅读器：

```css
.visually-hidden {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0 0 0 0);
  white-space: nowrap;
  border: 0;
}
```

这类工具类常用于图标按钮的可访问名称、跳转到主要内容的链接等场景。

### 不要用 CSS 随意打乱阅读顺序

Flexbox 和 Grid 可以改变视觉顺序，但键盘焦点顺序和屏幕阅读器读取顺序通常仍受 DOM 结构影响。

HTML 源码顺序应先满足语义和操作逻辑，CSS 只负责视觉呈现。不要为了视觉布局，把内容顺序设计成辅助技术无法理解的状态。

---

## 第十七站：CSS 性能优化——先测量，再优化

CSS 会参与关键渲染路径。浏览器通常需要解析 CSS、构建 CSSOM，并与 DOM 一起生成用于布局和绘制的信息。

### 减少无用 CSS

大型项目经常积累已经不再使用的规则。无用 CSS 会增加下载、解析和维护成本。

可以通过构建工具、覆盖率工具和代码审查清理，但需要谨慎处理运行时动态类名，避免误删。

### 控制首屏关键样式

关键样式应尽快可用，非首屏或特定页面样式可以按需加载。具体方案取决于框架、构建系统和部署方式。

### 减少反复布局

CSS 本身并不等于慢，但 JavaScript 频繁修改布局属性并立即读取尺寸，可能造成同步布局计算。

常见原则：

- 批量读取、批量写入 DOM；
- 动画优先考虑 `transform` 和 `opacity`；
- 避免无意义的大范围样式变更；
- 用开发者工具观察 Layout、Paint 和 Composite，而不是盲目猜测。

### 谨慎使用昂贵视觉效果

大面积模糊、复杂滤镜、超大阴影和大量半透明叠层可能增加绘制或合成成本。它们并非不能使用，但应在真实设备上测试。

### 使用内容可见性优化长页面

对于内容非常长的页面，可以研究 `content-visibility`：

```css
.article-section {
  content-visibility: auto;
  contain-intrinsic-size: auto 600px;
}
```

它可以让浏览器推迟不可见区域的部分渲染工作，但也需要关注滚动、查找、可访问性和布局占位表现，不能机械地应用到所有元素。

---

## 第十八站：浏览器开发者工具——CSS 调试必修课

真正高效的 CSS 开发者，不是从不遇到问题，而是能快速定位问题。

### Elements / Inspector

重点检查：

- 元素实际匹配了哪些规则；
- 哪些声明被覆盖；
- 规则来自哪个文件和哪一行；
- 最终计算值是什么；
- 是否继承了父元素样式。

### 盒模型面板

查看元素的：content 尺寸、padding、border、margin、最终占用空间。

### Flexbox 与 Grid 调试器

现代浏览器通常可以显示：Flex 主轴和对齐方式、Grid 轨道/网格线/区域、`gap`、项目尺寸和分布。

### 强制元素状态

可以在开发者工具中强制启用 `:hover`、`:focus`、`:active`、`:focus-visible`，无需反复移动鼠标或切换焦点。

### 调试 CSS 的推荐顺序

遇到"样式不生效"，按以下顺序检查：

1. 选择器是否匹配目标元素？
2. CSS 文件是否加载成功？
3. 属性和值是否合法？
4. 声明是否被其他规则覆盖？
5. 继承和优先级是否符合预期？
6. 元素的 `display`、定位和包含块是什么？
7. 父容器是否限制了尺寸或溢出？
8. 是否涉及堆叠上下文？
9. 是否是浏览器兼容性问题？

> 不要一遇到问题就先加 `!important`。

---

## 第十九站：综合实战——现代响应式课程卡片区

官网改版的"课程卡片区"，贺川把所有学到的知识用了一遍：变量、Grid、Flexbox、响应式、容器查询和交互状态。

### 1. HTML

```html
<section class="course-section">
  <header class="course-section__header">
    <div>
      <p class="eyebrow">FRONT-END ROADMAP</p>
      <h2>精选前端课程</h2>
    </div>
    <a class="text-link" href="#">查看全部课程</a>
  </header>

  <div class="course-grid">
    <article class="course-card">
      <img
        class="course-card__cover"
        src="css-course.jpg"
        alt="CSS 课程封面"
      />
      <div class="course-card__body">
        <div class="course-card__meta">
          <span class="tag">CSS</span>
          <span>36 课时</span>
        </div>
        <h3>CSS 从入门到精通</h3>
        <p>
          系统掌握盒模型、Flexbox、Grid、响应式设计与现代 CSS 工程化。
        </p>
        <footer class="course-card__footer">
          <strong>¥199</strong>
          <button class="button" type="button">立即学习</button>
        </footer>
      </div>
    </article>
  </div>
</section>
```

### 2. CSS（分层组织）

```css
@layer reset, tokens, base, components;

@layer reset {
  *,
  *::before,
  *::after {
    box-sizing: border-box;
  }

  body,
  h1,
  h2,
  h3,
  p {
    margin: 0;
  }

  img {
    display: block;
    max-width: 100%;
  }

  button,
  input,
  textarea,
  select {
    font: inherit;
  }
}

@layer tokens {
  :root {
    --color-brand: #2563eb;
    --color-brand-dark: #1d4ed8;
    --color-text: #0f172a;
    --color-muted: #64748b;
    --color-border: #e2e8f0;
    --color-surface: #ffffff;
    --color-page: #f8fafc;
    --radius-md: 12px;
    --radius-lg: 24px;
    --shadow-card: 0 20px 50px rgb(15 23 42 / 10%);
  }
}

@layer base {
  body {
    min-height: 100vh;
    color: var(--color-text);
    background: var(--color-page);
    font-family: system-ui, sans-serif;
    line-height: 1.6;
  }

  a {
    color: inherit;
  }
}

@layer components {
  .course-section {
    width: min(100% - 2rem, 72rem);
    margin-inline: auto;
    padding-block: clamp(3rem, 8vw, 7rem);
  }

  .course-section__header {
    display: flex;
    flex-wrap: wrap;
    align-items: end;
    justify-content: space-between;
    gap: 1rem;
    margin-bottom: 2rem;
  }

  .course-section__header h2 {
    margin-top: 0.35rem;
    font-size: clamp(2rem, 5vw, 3.5rem);
    line-height: 1.1;
  }

  .eyebrow {
    color: var(--color-brand);
    font-size: 0.8rem;
    font-weight: 800;
    letter-spacing: 0.12em;
  }

  .course-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(min(100%, 18rem), 1fr));
    gap: 1.5rem;
    container-type: inline-size;
  }

  .course-card {
    display: grid;
    overflow: hidden;
    border: 1px solid var(--color-border);
    border-radius: var(--radius-lg);
    background: var(--color-surface);
    box-shadow: 0 1px 2px rgb(15 23 42 / 4%);
    transition:
      transform 180ms ease,
      box-shadow 180ms ease;
  }

  .course-card:hover {
    transform: translateY(-4px);
    box-shadow: var(--shadow-card);
  }

  .course-card__cover {
    width: 100%;
    aspect-ratio: 16 / 9;
    object-fit: cover;
  }

  .course-card__body {
    display: flex;
    flex-direction: column;
    gap: 0.75rem;
    padding: 1.5rem;
  }

  .course-card__footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: auto;
  }
}
```

### 3. 这段代码体现了什么？

- 用 `@layer` 组织基础样式、变量和组件；
- 用自定义属性统一颜色、圆角和阴影；
- 用 Grid 实现自动适配的课程列表；
- 用 Flexbox 管理卡片内部纵向结构；
- 用 `margin-top: auto` 把底部价格和按钮推到卡片底部；
- 用 `aspect-ratio` 保持封面比例；
- 用容器查询让卡片根据所在区域变成横向结构；
- 用 `:focus-visible` 提供键盘焦点反馈；
- 用 `prefers-reduced-motion` 尊重减少动画偏好。

这就是现代 CSS 的思路：不是堆砌属性，而是把布局、状态、变量、响应式和可访问性组合成一个稳定组件。

贺川看着浏览器里的卡片区——手机上是单列卡片，宽屏上自动排成多列——他终于找到了"设计稿和网页总差一点"的答案：不是他画得不好，而是以前不懂 CSS 怎么把设计变成系统。

---

## 第二十站：CSS 常见误区与排查方法

贺川把踩过的坑整理成"误区清单"，和团队共享：

### 误区 1：所有尺寸都写死

```css
.page {
  width: 1200px;
}
```

在窄屏上很容易溢出。可以改为：

```css
.page {
  width: min(100% - 2rem, 75rem);
  margin-inline: auto;
}
```

### 误区 2：大量使用绝对定位做页面布局

绝对定位适合徽标、装饰、浮层等局部元素，不适合承载主要文档布局。主要布局优先考虑普通流、Flexbox 和 Grid。

### 误区 3：用固定高度限制动态内容

```css
.card {
  height: 200px;
}
```

当文字变长、字体放大或语言切换后，内容可能溢出。若只是希望至少有一定高度，优先考虑 `min-height`。

### 误区 4：靠 margin 推位置

```css
.button {
  margin-left: 327px;
}
```

这种布局依赖特定宽度，响应式环境下极易失效。应使用 `justify-content`、Grid 列、`margin-inline-start: auto` 等布局机制。

### 误区 5：选择器层级过深

深层选择器使组件和 DOM 强绑定。尽量用简短、稳定、语义明确的类选择器。

### 误区 6：只在自己的屏幕测试

至少应检查：

- 窄屏和宽屏；
- 文字放大；
- 键盘操作；
- 长文本和空数据；
- 深色模式；
- 减少动画偏好；
- 不同浏览器；
- 真机触摸交互。

### 误区 7：把预处理器当作 CSS 基础

Sass、Less、PostCSS 和 CSS-in-JS 都是工具。它们可以提升工程效率，但不会替你理解盒模型、级联、布局和浏览器渲染。

先学好 CSS 本身，再选择合适工具。

---

## 第二十一站：从入门到精通的 30 天学习路线

贺川把学习路径整理成了 30 天计划，分享给工作室的新人。

### 第 1—5 天：语法与基础样式

学习内容：CSS 引入方式、基础选择器、颜色/背景/边框、字体和文本、开发者工具基础。

练习：复刻一篇简单文章页面。

### 第 6—10 天：盒模型与普通流

学习内容：`box-sizing`、`margin`/`padding`/`border`、`display`、宽高与溢出、定位和堆叠上下文。

练习：制作个人资料卡、登录框和顶部导航。

### 第 11—15 天：Flexbox

学习内容：主轴与交叉轴、对齐与间距、伸缩规则、换行、常见溢出问题。

练习：制作导航栏、商品卡片、聊天列表和页脚贴底布局。

### 第 16—20 天：Grid 与响应式

学习内容：网格轨道、`repeat()`/`minmax()`/`auto-fit`、网格区域、媒体查询、流式尺寸、容器查询。

练习：制作仪表盘、相册和响应式博客首页。

### 第 21—25 天：组件、变量与动画

学习内容：自定义属性、组件变体、过渡和关键帧、伪类与伪元素、深色主题、原生嵌套和逻辑属性。

练习：制作一套按钮、输入框、标签、弹窗和通知组件。

### 第 26—30 天：工程化与实战

学习内容：命名规范、BEM 或团队约定、`@layer`、可访问性、性能测量、浏览器兼容策略。

综合项目：完成一个包含首页、列表页、详情页和表单页的响应式网站，并要求：

- 不依赖大量固定宽高；
- 支持键盘操作；
- 支持窄屏和宽屏；
- 使用 CSS 变量；
- 至少使用一次 Grid、Flexbox 和容器查询；
- 使用开发者工具完成性能和布局检查。

---

## 第二十二站：真正精通 CSS，需要建立的五种能力

### 1. 观察能力

看到一个界面时，能够拆解出：页面结构、容器关系、行列布局、间距系统、字体层级、组件状态、响应式变化。

### 2. 建模能力

不要一上来就写属性。先问：

- 这是普通流、Flexbox 还是 Grid 问题？
- 尺寸由内容决定，还是由容器决定？
- 组件是否需要独立响应式？
- 哪些值应该抽成变量？
- 哪些状态需要交互反馈？

### 3. 调试能力

熟练使用浏览器开发者工具，快速判断问题属于：选择器、级联、盒模型、布局、堆叠上下文、溢出、兼容性、性能。

### 4. 系统设计能力

能为项目建立：颜色/字号/间距/圆角体系、稳定的组件接口、可控的级联层、一致的响应式规则、清晰的命名和目录结构。

### 5. 取舍能力

精通不是"每个页面都使用最新属性"，而是知道：

- 什么时候使用新特性；
- 什么时候需要回退方案；
- 什么时候应该保持简单；
- 什么时候应该抽象；
- 什么时候应该先测量再优化。

---

## 结语：CSS 的本质，是给约束寻找稳定解

故事讲完了。

贺川从"设计稿和网页总差一点"的挫败开始，一路走到蓝屿官网改版上线——手机、平板、电脑上都协调统一，深色模式、键盘操作、减少动画偏好都照顾到了。他还顺手沉淀了一套用 CSS 变量组织的设计系统，工作室后来的项目都在复用。

CSS 不是一个靠死记硬背就能掌握的属性清单。

它更像一套约束系统：内容有多长、容器有多宽、元素如何排列、空间如何分配、状态如何反馈、界面如何适应用户和设备。你写下的每一条规则，都在参与这个系统的计算。

从入门到精通，可以牢记下面这条主线：

```
选择器与级联
    ↓
盒模型与普通流
    ↓
Flexbox 与 Grid
    ↓
响应式与容器查询
    ↓
变量、组件与级联层
    ↓
可访问性、性能与工程化
```

当你不再依靠"多试几个像素"，而是能够解释一个布局为什么成立、为什么失效、如何在不同空间中保持稳定时，你才真正跨过了 CSS 的门槛。

CSS 的上限，远比"给网页换颜色"高得多。它既是布局语言，也是设计系统的实现层，更是用户体验的重要组成部分。

> 少背属性，多做页面；少堆代码，多建系统。

---

## 参考资料

- MDN Web Docs：CSS — https://developer.mozilla.org/en-US/docs/Web/CSS
- MDN Web Docs：CSS Layout — https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/CSS_layout
- MDN Web Docs：CSS Grid Layout — https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Grid_layout
- MDN Web Docs：Flexbox — https://developer.mozilla.org/en-US/docs/Learn_web_development/Core/CSS_layout/Flexbox
- MDN Web Docs：Container Queries — https://developer.mozilla.org/en-US/docs/Web/CSS/Guides/Containment/Container_queries
- MDN Web Docs：CSS Performance Optimization — https://developer.mozilla.org/en-US/docs/Learn_web_development/Extensions/Performance/CSS
- W3C：CSS Snapshot — https://www.w3.org/Style/CSS/