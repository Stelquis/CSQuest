# [HTML5 从入门到精通：从第一行标签到完整响应式网站](https://mp.weixin.qq.com/s/ZBfr5Gy8xwpVA7zBVvKG_g)

> 这是一个关于"晓禾"的故事——一个投了三个月前端简历都石沉大海的应届生。她决定不再等面试通知，而是从第一行 `<!DOCTYPE html>` 开始，亲手做一个完整的响应式个人主页，用作品说话。你会跟着她一起，从认识第一个标签，走到一个真正能上线、能打动人、能通过面试官考验的网站。读完之后你会发现：HTML 是所有前端开发者绕不开的第一门语言，它看起来简单，却决定了网页的结构、语义、可访问性、搜索引擎表现和后续维护成本。

---

## 故事的起点：三个月，零面试

晓禾毕业三个月了。计算机专业，简历投了上百份，前端岗位的面试通知一个都没等到。

"你没有项目经验。"一个 HR 在电话里说得直白。

晓禾看着自己空荡荡的简历，忽然想明白了一件事：与其等别人给机会，不如自己先做出一个东西来。她决定——**从零开始学 HTML5，给自己做一个响应式个人主页**，把学习过程和作品都放上去。

她给自己定了三个目标：

1. 做出一个结构清晰、语义正确的页面；
2. 表单、图片、导航都要可用、可访问；
3. 手机、平板、电脑上看都正常。

这个故事，就是她从第一行标签走到完整响应式网站的完整路线图。

---

## 第一站：HTML5 到底是什么？

晓禾的第一课，是搞清楚 HTML 到底是个什么东西。

HTML 的全称是 **HyperText Markup Language**，中文译为"超文本标记语言"。

它不是传统意义上的编程语言，而是一种通过"标签"描述网页结构的**标记语言**。

一个现代网页通常由三部分组成：

- **HTML**：负责网页结构；
- **CSS**：负责视觉样式；
- **JavaScript**：负责交互逻辑。

晓禾的导师（一位愿意在周末远程指点她的老前辈）打了个比方：

> 可以把网页想象成一栋房子：
> - HTML 是房子的梁柱和房间；
> - CSS 是装修、颜色和布局；
> - JavaScript 是电梯、门禁和智能设备。

HTML5 是现代 HTML 标准的重要阶段。它引入了更清晰的语义化标签、更强大的表单能力、原生音视频支持、Canvas 绘图，以及更适合 Web 应用的基础能力。

晓禾在笔记本上写下了一句话："HTML 是地基，地基越扎实，后面学 CSS、JavaScript、Vue、React 就越轻松。"

---

## 第二站：开发环境准备——第一个页面

学习 HTML5 不需要复杂环境，只需要两个工具：

1. 一个现代浏览器；
2. 一个代码编辑器（Visual Studio Code、Sublime Text、WebStorm 都行）。

晓禾创建了一个名为 `index.html` 的文件，输入了人生中第一个 HTML 页面：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>我的第一个网页</title>
</head>
<body>
  <h1>Hello, HTML5!</h1>
  <p>这是我的第一个网页。</p>
</body>
</html>
```

保存文件后，用浏览器打开——屏幕上出现了 "Hello, HTML5!"。

"就这么简单？"晓禾有点不敢相信。没有编译，没有安装依赖，一个文件就是一个网页。

---

## 第三站：理解 HTML5 文档结构

能显示"Hello, HTML5!"之后，晓禾开始逐行理解这个页面的骨架。

一个标准 HTML 文档通常由以下部分组成：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <!-- 页面配置信息 -->
</head>
<body>
  <!-- 页面可见内容 -->
</body>
</html>
```

### 1. `<!DOCTYPE html>`

它告诉浏览器：当前文档使用现代 HTML 标准解析。

```html
<!DOCTYPE html>
```

这一行通常必须放在文档**第一行**。

### 2. `<html>`

`<html>` 是整个页面的**根元素**。

```html
<html lang="zh-CN">
</html>
```

`lang="zh-CN"` 表示页面主要语言为简体中文，有助于搜索引擎、翻译工具和屏幕阅读器正确理解页面。

### 3. `<head>`

`<head>` 中存放页面配置、标题、编码、样式和搜索引擎相关信息——用户看不到，但浏览器和搜索引擎看得到。

```html
<head>
  <meta charset="UTF-8">
  <title>HTML5 教程</title>
</head>
```

### 4. `<body>`

`<body>` 中存放用户能看到的网页内容。

```html
<body>
  <h1>欢迎学习 HTML5</h1>
</body>
```

晓禾把结构记成了口诀："`DOCTYPE` 在最前，`html` 包一切，`head` 放配置，`body` 放内容。"

---

## 第四站：常用文本标签——把内容表达清楚

页面骨架有了，晓禾开始学怎么组织内容。

### 标题标签

HTML 提供六级标题：

```html
<h1>一级标题</h1>
<h2>二级标题</h2>
<h3>三级标题</h3>
<h4>四级标题</h4>
<h5>五级标题</h5>
<h6>六级标题</h6>
```

导师强调了两点：

- 通常，一个页面只设置一个主要的 `<h1>`，其他标题按内容层级依次使用；
- **不要为了字体大小而随意选择标题级别**。字体大小应该交给 CSS 控制，HTML 标题负责表达内容结构。

### 段落标签

```html
<p>这是一段正文内容。</p>
```

每个逻辑段落都应该使用独立的 `<p>` 标签。

### 强调标签

```html
<strong>重要内容</strong>
<em>需要强调的内容</em>
```

`<strong>` 表达较高的重要性，`<em>` 表达语气强调。

### 换行与分隔线

```html
第一行<br>第二行
<hr>
```

`<br>` 用于行内换行，`<hr>` 表示主题内容的分隔。

> 不要连续使用多个 `<br>` 制造空白区域，页面间距应该使用 CSS 设置。

### 引用与代码

```html
<blockquote>
  学习编程最重要的是持续实践。
</blockquote>

<p>使用 <code>console.log()</code> 输出信息。</p>

<pre><code>
function hello() {
  console.log("Hello");
}
</code></pre>
```

`<code>` 适合短代码，`<pre>` 会保留空格和换行，适合展示代码块。

---

## 第五站：链接与图片——让页面"走出去"

内容能表达了，晓禾开始给页面加"出口"——链接，以及"眼睛"——图片。

### 超链接

```html
<a href="https://example.com">访问示例网站</a>
```

在新窗口打开：

```html
<a
  href="https://example.com"
  target="_blank"
  rel="noopener noreferrer">
  新窗口打开
</a>
```

`rel="noopener noreferrer"` 可以降低新窗口页面访问原页面对象所带来的安全风险。

页面内跳转：

```html
<a href="#about">跳转到关于部分</a>

<section id="about">
  <h2>关于我们</h2>
</section>
```

邮件与电话链接：

```html
<a href="mailto:hello@example.com">发送邮件</a>
<a href="tel:+8613800000000">拨打电话</a>
```

### 图片标签

```html
<img
  src="images/html5-logo.png"
  alt="HTML5 标志"
  width="300"
  height="300">
```

常用属性：

- `src`：图片路径；
- `alt`：替代文本；
- `width`：图片宽度；
- `height`：图片高度；
- `loading="lazy"`：延迟加载非首屏图片。

示例：

```html
<img
  src="images/course-cover.jpg"
  alt="HTML5 从入门到精通课程封面"
  width="800"
  height="450"
  loading="lazy">
```

导师特别叮嘱：`alt` 不应写成"图片"或"照片"，而应该**描述图片所表达的信息**——这是可访问性和 SEO 的关键。

### 带说明的图片

```html
<figure>
  <img src="images/web-structure.png" alt="网页结构示意图">
  <figcaption>HTML、CSS 与 JavaScript 的分工</figcaption>
</figure>
```

---

## 第六站：列表——组织结构化内容

晓禾的作品集需要一个"技能清单"，她学会了用列表组织。

### 无序列表

```html
<ul>
  <li>HTML</li>
  <li>CSS</li>
  <li>JavaScript</li>
</ul>
```

适合没有严格先后顺序的内容。

### 有序列表

```html
<ol>
  <li>创建 HTML 文件</li>
  <li>编写页面结构</li>
  <li>在浏览器中预览</li>
</ol>
```

适合步骤、排名和流程。

### 描述列表

```html
<dl>
  <dt>HTML</dt>
  <dd>负责网页结构。</dd>
  <dt>CSS</dt>
  <dd>负责网页样式。</dd>
</dl>
```

适合术语解释、参数说明和问答结构。

---

## 第七站：表格——展示二维数据

作品集里要放"项目经历"，用表格最直观。

基础表格：

```html
<table>
  <caption>课程安排</caption>
  <thead>
    <tr>
      <th scope="col">课程</th>
      <th scope="col">难度</th>
      <th scope="col">学习时间</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>HTML5</td>
      <td>入门</td>
      <td>7 天</td>
    </tr>
    <tr>
      <td>CSS3</td>
      <td>进阶</td>
      <td>14 天</td>
    </tr>
  </tbody>
</table>
```

常用标签：

- `<table>`：表格容器；
- `<caption>`：表格标题；
- `<thead>`：表头区域；
- `<tbody>`：表格主体；
- `<tfoot>`：表格底部；
- `<tr>`：表格行；
- `<th>`：表头单元格；
- `<td>`：普通单元格。

合并单元格：

```html
<td colspan="2">横向合并两列</td>
<td rowspan="2">纵向合并两行</td>
```

> 注意：表格应该用于展示数据，**不要用表格完成整个网页布局**——那是上个世纪的做法了。

---

## 第八站：表单——让用户输入数据

作品集需要一个"联系我"表单。表单是登录、注册、搜索、评论和提交订单的基础，也是晓禾第一次感觉到"网页是活的"。

### 基础表单

```html
<form action="/submit" method="post">
  <label for="username">用户名</label>
  <input
    id="username"
    name="username"
    type="text"
    required
  >
  <button type="submit">提交</button>
</form>
```

`label` 的 `for` 值应该与输入框的 `id` 一致，这样点击文字时也能聚焦输入框。

### 常用输入类型

```html
<input type="text">
<input type="password">
<input type="email">
<input type="number">
<input type="tel">
<input type="url">
<input type="date">
<input type="time">
<input type="color">
<input type="range">
<input type="file">
```

HTML5 提供了丰富的输入类型。浏览器可以根据类型提供基础校验，并在移动设备上显示更合适的键盘。

### 常用校验属性

```html
<input
  type="text"
  name="nickname"
  minlength="2"
  maxlength="20"
  required>

<input
  type="number"
  name="age"
  min="1"
  max="120">

<input
  type="text"
  name="code"
  pattern="[A-Z0-9]{6}">
```

常见属性：

- `required`：必填；
- `minlength`、`maxlength`：字符长度；
- `min`、`max`：数值范围；
- `pattern`：正则表达式规则；
- `placeholder`：输入提示；
- `autocomplete`：自动填充策略。

### 单选框与复选框

```html
<p>请选择学习方向：</p>
<label>
  <input type="radio" name="direction" value="frontend">
  前端开发
</label>
<label>
  <input type="radio" name="direction" value="backend">
  后端开发
</label>
```

> 同组单选框的 `name` 必须一致。

复选框：

```html
<label>
  <input type="checkbox" name="skills" value="html">
  HTML
</label>
<label>
  <input type="checkbox" name="skills" value="css">
  CSS
</label>
```

### 下拉列表

```html
<label for="city">所在城市</label>
<select id="city" name="city">
  <option value="">请选择</option>
  <option value="hangzhou">杭州</option>
  <option value="shanghai">上海</option>
  <option value="shenzhen">深圳</option>
</select>
```

### 多行文本

```html
<label for="message">留言内容</label>
<textarea
  id="message"
  name="message"
  rows="6"
  maxlength="500">
</textarea>
```

### 分组表单

```html
<form>
  <fieldset>
    <legend>账号信息</legend>
    <label for="email">邮箱</label>
    <input id="email" type="email" name="email">
    <label for="password">密码</label>
    <input id="password" type="password" name="password">
  </fieldset>
</form>
```

`fieldset` 和 `legend` 可以为相关控件建立清晰分组。

---

## 第九站：语义化标签——让结构自己"说话"

晓禾最初写的页面，到处是 `<div>`：

```html
<div class="header"></div>
<div class="nav"></div>
<div class="content"></div>
<div class="footer"></div>
```

导师看了直摇头："这种写法虽然能工作，但标签本身没有表达内容含义。"

HTML5 提供了更清晰的语义化标签：

```html
<header>页面或区域头部</header>
<nav>导航区域</nav>
<main>页面主要内容</main>
<section>主题分区</section>
<article>独立文章或内容单元</article>
<aside>补充内容或侧边栏</aside>
<footer>页面或区域底部</footer>
```

一个常见页面结构如下：

```html
<body>
  <header>
    <h1>前端学习站</h1>
    <nav aria-label="主导航">
      <a href="/">首页</a>
      <a href="/articles">文章</a>
      <a href="/about">关于</a>
    </nav>
  </header>

  <main>
    <article>
      <header>
        <h2>HTML5 从入门到精通</h2>
        <p>发布时间：2026-07-23</p>
      </header>
      <section>
        <h3>HTML5 基础</h3>
        <p>这里是文章正文。</p>
      </section>
    </article>

    <aside>
      <h2>相关推荐</h2>
    </aside>
  </main>

  <footer>
    <p>&copy; 2026 前端学习站</p>
  </footer>
</body>
```

### 如何选择语义标签？

导师教她用问题来判断：

- 这是页面主要内容吗？使用 `<main>`；
- 这是可以独立发布的内容吗？使用 `<article>`；
- 这是一个主题分区吗？使用 `<section>`；
- 这是导航链接集合吗？使用 `<nav>`；
- 这是补充信息吗？使用 `<aside>`；
- 只是为了布局，没有明确语义吗？使用 `<div>`。

语义化的价值包括：

1. 让代码更容易阅读；
2. 提升页面可维护性；
3. 帮助搜索引擎理解内容；
4. 改善屏幕阅读器用户的使用体验；
5. 让团队协作更加高效。

---

## 第十站：音频与视频——网页里直接播放

HTML5 可以直接在网页中播放音频和视频，不需要 Flash。

### 音频

```html
<audio controls>
  <source src="audio/course.mp3" type="audio/mpeg">
  <source src="audio/course.ogg" type="audio/ogg">
  你的浏览器不支持音频播放。
</audio>
```

常见属性：

- `controls`：显示播放控件；
- `autoplay`：自动播放；
- `loop`：循环播放；
- `muted`：默认静音；
- `preload`：控制预加载方式。

> 自动播放通常会受到浏览器策略限制，因此不要依赖带声音的自动播放。

### 视频

```html
<video
  controls
  width="960"
  height="540"
  poster="images/video-cover.jpg">
  <source src="video/html5-course.mp4" type="video/mp4">
  <source src="video/html5-course.webm" type="video/webm">
  <track
    src="subtitles/zh.vtt"
    kind="subtitles"
    srclang="zh"
    label="中文"
    default
  >
  你的浏览器不支持视频播放。
</video>
```

`poster` 用于设置视频播放前的封面，`track` 可以添加字幕。

---

## 第十一站：Canvas——在网页上绘图

晓禾的导师给她演示了一个"很酷"的东西：`<canvas>` 提供了一块可由 JavaScript 控制的画布。

HTML：

```html
<canvas id="canvas" width="600" height="300">
  你的浏览器不支持 Canvas。
</canvas>
```

JavaScript：

```html
<script>
  const canvas = document.querySelector("#canvas");
  const context = canvas.getContext("2d");

  context.fillStyle = "#ff6b35";
  context.fillRect(40, 40, 180, 100);

  context.beginPath();
  context.arc(360, 90, 50, 0, Math.PI * 2);
  context.fillStyle = "#1e88e5";
  context.fill();

  context.font = "24px sans-serif";
  context.fillStyle = "#222";
  context.fillText("Hello Canvas", 200, 220);
</script>
```

Canvas 适合：游戏、数据可视化、图片处理、签名板、动画、自定义绘图工具。

需要注意：Canvas 中的图形本身不是普通 DOM 元素，无法像 HTML 标签那样直接被搜索引擎或辅助工具理解。如果图形需要良好的可访问性、可缩放性和 DOM 交互，也可以考虑 SVG。

---

## 第十二站：HTML5 中的实用元素

### 可折叠内容

```html
<details>
  <summary>点击查看答案</summary>
  <p>HTML 负责网页结构，CSS 负责样式。</p>
</details>
```

非常适合 FAQ、答案解析和折叠说明。

### 进度条

```html
<label for="progress">课程进度</label>
<progress id="progress" value="70" max="100">70%</progress>
```

### 数值范围

```html
<p>磁盘使用率：</p>
<meter min="0" max="100" low="30" high="80" optimum="20" value="65">
  65%
</meter>
```

> `progress` 表示任务完成进度，`meter` 表示已知范围内的测量值，两者用途不同。

### 时间元素

```html
<time datetime="2026-07-23">2026 年 7 月 23 日</time>
```

`datetime` 属性提供机器可识别的时间值。

### 高亮文本

```html
<p>搜索结果中包含 <mark>HTML5</mark> 关键词。</p>
```

### 对话框

```html
<dialog id="welcomeDialog">
  <h2>欢迎学习 HTML5</h2>
  <p>这是一个原生对话框。</p>
  <button id="closeDialog">关闭</button>
</dialog>

<button id="openDialog">打开对话框</button>

<script>
  const dialog = document.querySelector("#welcomeDialog");
  const openButton = document.querySelector("#openDialog");
  const closeButton = document.querySelector("#closeDialog");

  openButton.addEventListener("click", () => {
    dialog.showModal();
  });

  closeButton.addEventListener("click", () => {
    dialog.close();
  });
</script>
```

---

## 第十三站：路径——初学者最容易出错的地方

晓禾第一次在作品集里引图片时，图片裂了。问题出在路径上。

### 相对路径

当前目录：

```html
<img src="logo.png" alt="网站标志">
```

子目录：

```html
<img src="images/logo.png" alt="网站标志">
```

上一级目录：

```html
<img src="../images/logo.png" alt="网站标志">
```

### 根路径

```html
<img src="/images/logo.png" alt="网站标志">
```

以 `/` 开头的路径从网站根目录开始计算。

### 绝对 URL

```html
<img src="https://example.com/images/logo.png" alt="网站标志">
```

### 推荐项目结构

晓禾把项目目录整理成了这样：

```
html5-project/
├── index.html
├── about.html
├── css/
│   └── style.css
├── js/
│   └── main.js
├── images/
│   ├── logo.png
│   └── hero.jpg
├── audio/
└── video/
```

> 合理的目录结构可以减少路径错误，也方便后续维护。

---

## 第十四站：`<head>` 中的重要配置

晓禾发现，很多"看不见"的配置决定了页面的成败。

### 字符编码

```html
<meta charset="UTF-8">
```

### 移动端视口

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">
```

如果缺少这行，移动设备可能会以桌面网页宽度缩放页面——这是响应式的基础。

### 页面描述

```html
<meta
  name="description"
  content="系统学习 HTML5 语法、语义化、表单、多媒体与响应式网页开发。">
```

### 网站图标

```html
<link rel="icon" href="/favicon.ico">
```

### 引入 CSS

```html
<link rel="stylesheet" href="css/style.css">
```

### 引入 JavaScript

推荐写法：

```html
<script src="js/main.js" defer></script>
```

`defer` 表示脚本可以并行下载，但会等 HTML 解析完成后再按顺序执行。

---

## 第十五站：可访问性——让更多人顺利使用网页

导师给晓禾布置了一个"看不见的作业"：把眼睛蒙上，用键盘操作一遍自己的页面。

一个专业网页不仅要"看起来正常"，还应该让键盘用户和辅助技术用户能够正常操作。

### 图片提供替代文本

```html
<img src="chart.png" alt="2026 年上半年用户增长趋势图">
```

装饰性图片可以使用空替代文本：

```html
<img src="decoration.svg" alt="">
```

### 表单标签与控件关联

```html
<label for="email">邮箱地址</label>
<input id="email" name="email" type="email">
```

### 使用原生按钮

推荐：

```html
<button type="button">打开菜单</button>
```

不推荐：

```html
<div onclick="openMenu()">打开菜单</div>
```

原生按钮天然支持键盘操作、焦点和辅助技术识别。

### 保持合理标题层级

```html
<h1>页面标题</h1>
<h2>第一部分</h2>
<h3>第一部分的小节</h3>
<h2>第二部分</h2>
```

### 必要时使用 ARIA

```html
<nav aria-label="主导航">
  ...
</nav>
```

ARIA 应该用于补充语义，而不是替代原生 HTML 元素。例如，能使用 `<button>` 时，不要优先使用：

```html
<div role="button" tabindex="0">提交</div>
```

---

## 第十六站：SEO 基础——让搜索引擎看懂页面

作品集做好了，没人搜得到也不行。HTML 结构会直接影响搜索引擎对页面内容的理解。

建议做到：

1. 设置准确的 `<title>`；
2. 编写有价值的页面描述；
3. 使用清晰的标题层级；
4. 使用语义化标签；
5. 为图片添加合理的 `alt`；
6. 使用可读的链接文字；
7. 避免把重要文字只放在图片中。

不推荐：

```html
<a href="/course">点击这里</a>
```

推荐：

```html
<a href="/course">查看 HTML5 完整课程</a>
```

页面标题示例：

```html
<title>HTML5 从入门到精通：完整教程与实战案例</title>
```

页面描述示例：

```html
<meta
  name="description"
  content="从零学习 HTML5，掌握常用标签、语义化、表单、多媒体、Canvas、可访问性与响应式网页实战。">
```

---

## 第十七站：响应式网页的 HTML 基础

晓禾的第三个目标——手机、平板、电脑上都要正常——在这里实现。响应式网页需要 HTML 与 CSS 配合完成。

HTML 侧的核心是 viewport 和响应式图片：

```html
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<picture>
  <source
    media="(min-width: 900px)"
    srcset="images/banner-large.jpg"
  >
  <source
    media="(min-width: 600px)"
    srcset="images/banner-medium.jpg"
  >
  <img
    src="images/banner-small.jpg"
    alt="HTML5 课程横幅"
  >
</picture>
```

使用 `srcset` 提供不同分辨率图片：

```html
<img
  src="images/photo-800.jpg"
  srcset="
    images/photo-400.jpg 400w,
    images/photo-800.jpg 800w,
    images/photo-1200.jpg 1200w
  "
  sizes="
    (max-width: 600px) 100vw,
    800px
  "
  alt="正在编写网页代码的开发者">
```

这样可以根据设备和布局选择更合适的图片资源，减少不必要的网络传输。

---

## 第十八站：HTML 编码规范

导师给晓禾的代码提了一堆"小意见"。她把这些整理成了规范。

### 1. 使用统一缩进

推荐使用两个空格：

```html
<main>
  <section>
    <h2>课程介绍</h2>
    <p>这是课程内容。</p>
  </section>
</main>
```

### 2. 属性值使用引号

推荐：

```html
<input type="text" name="username">
```

### 3. 标签名称保持小写

推荐：

```html
<section></section>
```

### 4. 使用有意义的类名

推荐：

```html
<article class="course-card"></article>
```

不推荐：

```html
<article class="box1"></article>
```

### 5. 减少无意义嵌套

不推荐：

```html
<div>
  <div>
    <div>
      <p>正文</p>
    </div>
  </div>
</div>
```

推荐：

```html
<article>
  <p>正文</p>
</article>
```

### 6. 对特殊字符进行实体编码

```html
&lt;    <!-- < -->
&gt;    <!-- > -->
&amp;   <!-- & -->
&quot;  <!-- " -->
&copy;  <!-- © -->
```

例如，在正文中展示标签：

```html
<p>段落标签写作 &lt;p&gt;。</p>
```

---

## 第十九站：常见错误与解决方法

晓禾把自己踩过的坑、导师指出的错，整理成了一份"错误清单"。

### 错误 1：忘记闭合标签

错误：

```html
<p>第一段
<p>第二段
```

推荐：

```html
<p>第一段</p>
<p>第二段</p>
```

虽然浏览器可能自动修复部分结构，但不要依赖自动修复。

### 错误 2：标签嵌套顺序错误

错误：

```html
<strong><em>重要内容</strong></em>
```

正确：

```html
<strong><em>重要内容</em></strong>
```

### 错误 3：重复使用相同 `id`

错误：

```html
<section id="about"></section>
<section id="about"></section>
```

`id` 应该在同一页面中保持唯一。

### 错误 4：把按钮写成链接

如果操作会提交、打开菜单或切换状态，应优先使用 `<button>`；如果行为是跳转到另一个地址，应使用 `<a>`。

### 错误 5：表单控件没有 `name`

```html
<input type="email" id="email">
```

如果需要提交到服务器，还应该设置：

```html
<input type="email" id="email" name="email">
```

### 错误 6：图片没有替代文本

错误：

```html
<img src="product.jpg">
```

推荐：

```html
<img src="product.jpg" alt="黑色无线机械键盘">
```

### 错误 7：使用过时的展示标签

字体、颜色、居中和布局应由 CSS 完成，不要依赖纯展示型旧标签。

---

## 第二十站：完整实战——晓禾的响应式个人主页

学到这里，晓禾把前面的知识全部串了起来，做成了她投简历用的作品集。这是她给自己交的答卷。

### 1. 项目结构

```
portfolio/
├── index.html
├── css/
│   └── style.css
├── js/
│   └── main.js
└── images/
    ├── avatar.jpg
    └── project-cover.jpg
```

### 2. `index.html`

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta
    name="viewport"
    content="width=device-width, initial-scale=1.0"
  >
  <meta
    name="description"
    content="前端开发者个人主页，展示技能、项目和联系方式。"
  >
  <title>晓禾｜前端开发者</title>
  <link rel="stylesheet" href="css/style.css">
  <script src="js/main.js" defer></script>
</head>
<body>
  <a class="skip-link" href="#main-content">跳到主要内容</a>

  <header class="site-header">
    <div class="container header-inner">
      <a class="brand" href="/" aria-label="返回首页">
        晓禾
      </a>
      <nav aria-label="主导航">
        <ul class="nav-list">
          <li><a href="#about">关于我</a></li>
          <li><a href="#skills">技能</a></li>
          <li><a href="#projects">项目</a></li>
          <li><a href="#contact">联系我</a></li>
        </ul>
      </nav>
    </div>
  </header>

  <main id="main-content">
    <section class="hero">
      <div class="container hero-layout">
        <div>
          <p class="eyebrow">HELLO, I AM</p>
          <h1>晓禾，一名前端开发者</h1>
          <p class="hero-description">
            专注于构建快速、易用、可访问的现代 Web 产品。
          </p>
          <div class="hero-actions">
            <a class="button primary" href="#projects">
              查看项目
            </a>
            <a class="button secondary" href="#contact">
              联系我
            </a>
          </div>
        </div>
        <img
          class="avatar"
          src="images/avatar.jpg"
          alt="前端开发者晓禾的头像"
          width="420"
          height="420"
        >
      </div>
    </section>

    <section id="about" class="section">
      <div class="container">
        <h2>关于我</h2>
        <p>
          我热爱 Web 技术，重视语义化、性能、可访问性和用户体验。
          目前主要使用 HTML、CSS、JavaScript 和现代前端框架开发产品。
        </p>
      </div>
    </section>

    <section id="skills" class="section section-muted">
      <div class="container">
        <h2>专业技能</h2>
        <ul class="skill-list">
          <li>HTML5 与语义化结构</li>
          <li>CSS3 与响应式布局</li>
          <li>JavaScript 与前端交互</li>
          <li>Web 性能优化</li>
          <li>无障碍与可访问性</li>
        </ul>
      </div>
    </section>

    <section id="projects" class="section">
      <div class="container">
        <h2>我的项目</h2>
        <article class="project-card">
          <img
            src="images/project-cover.jpg"
            alt="响应式个人主页项目截图"
            loading="lazy"
          >
          <h3>响应式个人主页</h3>
          <p>使用 HTML5 语义化标签与 CSS 完成的响应式作品集。</p>
        </article>
      </div>
    </section>

    <section id="contact" class="section section-muted">
      <div class="container">
        <h2>联系我</h2>
        <form action="/contact" method="post">
          <div class="form-field">
            <label for="name">姓名</label>
            <input id="name" name="name" type="text" required>
          </div>
          <div class="form-field">
            <label for="email">邮箱</label>
            <input id="email" name="email" type="email" required>
          </div>
          <div class="form-field">
            <label for="message">留言</label>
            <textarea id="message" name="message" rows="5" required></textarea>
          </div>
          <button class="button primary" type="submit">发送</button>
        </form>
      </div>
    </section>
  </main>

  <footer class="site-footer">
    <div class="container">
      <p>&copy; <span id="currentYear"></span> 晓禾</p>
    </div>
  </footer>
</body>
</html>
```

### 3. `js/main.js`

```javascript
const currentYear = document.querySelector("#currentYear");
if (currentYear) {
  currentYear.textContent = new Date().getFullYear();
}
```

### 4. 实战中用到的 HTML5 知识

这个项目综合使用了：

- 标准文档结构；
- `meta viewport`；
- 语义化标签；
- 导航列表；
- 响应式图片；
- 文章与分区结构；
- 表单校验；
- 可访问性跳转链接；
- 合理的标题层级；
- 延迟加载图片；
- `defer` 脚本加载；
- HTML、CSS、JavaScript 分离。

晓禾看着浏览器里完整呈现的页面，给导师发了条消息："我做到了。从第一行标签，到一个完整的网站。"

---

## 第二十一站：性能优化技巧

页面能跑了，晓禾开始关心"快不快"。

### 1. 为图片指定尺寸

```html
<img
  src="images/banner.jpg"
  alt="课程宣传图"
  width="1200"
  height="675">
```

明确尺寸有助于浏览器提前预留空间，减少页面加载过程中的布局跳动。

### 2. 延迟加载非首屏图片

```html
<img
  src="images/project.jpg"
  alt="项目截图"
  loading="lazy">
```

首屏最重要的主图不要盲目设置延迟加载。

### 3. 使用响应式图片

通过 `<picture>`、`srcset` 和 `sizes` 让浏览器选择更合适的资源。

### 4. 合理加载脚本

```html
<script src="js/main.js" defer></script>
```

不要在页面顶部加载会阻塞 HTML 解析的大型同步脚本。

### 5. 减少无意义 DOM 节点

标签嵌套越复杂，浏览器维护的 DOM 树越大，代码也越难维护。

---

## 第二十二站：HTML5 学习路线

晓禾把她的学习路径整理成了四阶段，分享给了同届的同学。

### 第一阶段：基础语法

重点掌握：文档结构、标题与段落、链接与图片、列表、表格、表单、路径。

练习项目：个人简历页、新闻文章页、产品介绍页。

### 第二阶段：语义化与规范

重点掌握：语义化标签、标题层级、可访问性、SEO 基础、代码规范。

练习项目：博客详情页、企业官网首页、技术文档页面。

### 第三阶段：HTML5 高级能力

重点掌握：音视频、Canvas、响应式图片、原生对话框、表单校验、Web 页面性能。

练习项目：在线播放器、绘图工具、响应式作品集、在线课程页面。

### 第四阶段：综合实战

将 HTML 与 CSS、JavaScript 结合，完成：响应式企业官网、电商商品详情页、管理后台界面、个人博客、Web App 页面。

---

## 第二十三站：面试常见问题

晓禾带着作品集去面试，面试官问的问题，大部分她都能对答如流了。

### 1. HTML5 语义化有什么好处？

语义化可以提升代码可读性、可维护性、搜索引擎理解能力和辅助技术兼容性。

### 2. `<section>` 和 `<div>` 有什么区别？

`<section>` 表示有明确主题的内容分区，通常应该有标题；`<div>` 没有特殊语义，主要用于布局或样式分组。

### 3. `<article>` 适合什么场景？

适合可以独立存在、独立发布或复用的内容，例如文章、新闻、评论、论坛帖子和商品卡片。

### 4. `alt` 属性有什么作用？

当图片无法显示时提供替代信息，也帮助屏幕阅读器用户理解图片内容。

### 5. `defer` 和 `async` 有什么区别？

- `defer`：脚本并行下载，等待 HTML 解析完成后按文档顺序执行；
- `async`：脚本并行下载，下载完成后尽快执行，执行顺序不确定。

多个存在依赖关系的脚本通常更适合使用 `defer`。

### 6. `id` 和 `class` 有什么区别？

- `id` 应该在页面中唯一；
- `class` 可以被多个元素复用。

### 7. GET 和 POST 有什么区别？

在表单中：GET 通常把参数放在 URL 中，适合搜索、筛选等可分享请求；POST 通常把数据放在请求体中，适合创建或提交数据。

> 敏感数据不能仅因为使用 POST 就被认为安全，实际项目还需要 HTTPS 和服务器端安全处理。

### 8. 为什么不建议用 `<div>` 模拟按钮？

`<button>` 原生支持键盘操作、焦点、禁用状态和辅助技术语义。使用 `<div>` 模拟按钮需要额外补充大量行为。

---

## 第二十四站：HTML5 自检清单

每次完成页面后，可以检查以下内容：

- 是否声明了 `<!DOCTYPE html>`；
- 是否设置了正确的页面语言；
- 是否设置了 UTF-8 编码；
- 是否设置了移动端 viewport；
- 是否有清晰的页面标题；
- 是否合理使用标题层级；
- 是否使用语义化标签；
- 图片是否设置了合适的 `alt`；
- 表单控件是否有对应的 `label`；
- `id` 是否保持唯一；
- 链接文字是否清楚表达目标；
- 按钮和链接的用途是否正确；
- 非首屏图片是否考虑延迟加载；
- 页面是否可以使用键盘操作；
- HTML 是否通过浏览器开发者工具检查；
- 移动端页面是否正常显示。

---

## 结语：地基越扎实，走得越远

故事讲完了。

三个月零面试的晓禾，凭借自己从第一行 `<!DOCTYPE html>` 做起的响应式个人主页，拿到了一家公司的前端 offer。面试官对她说："你的作品集不是最炫的，但它的语义、结构和可访问性，比很多工作三年的人做得都认真。"

HTML5 入门不难，但真正写好 HTML，需要建立"**结构优先、语义优先、可访问性优先**"的意识。

初学阶段，不要只追求浏览器能显示，而要不断思考：

- 这个标签是否表达了正确含义？
- 这个页面是否有清晰的信息层级？
- 没有 CSS 时，内容是否仍然可读？
- 用户只使用键盘，能否完成操作？
- 搜索引擎和屏幕阅读器能否理解页面？
- 代码交给其他开发者，是否容易维护？

从第一行 `<!DOCTYPE html>` 到完整响应式网站，HTML 始终是前端开发的地基。地基越扎实，后续学习 CSS、JavaScript、Vue、React 和各种工程化工具就越轻松。

真正掌握 HTML5 的方法只有一个：

> 少背标签，多做页面；少堆代码，多理解语义。

建议你从今天开始完成三个项目：

1. 一个语义化个人简历；
2. 一个带完整表单的注册页面；
3. 一个响应式个人作品集。

完成这三个项目，你就不再只是"看懂 HTML"，而是真正具备了使用 HTML5 构建网页的能力。

---

## 附：最小可复用 HTML5 模板

晓禾把最终沉淀的模板贴在了自己博客上，随时复用：

```html
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta
    name="viewport"
    content="width=device-width, initial-scale=1.0"
  >
  <meta
    name="description"
    content="页面描述"
  >
  <title>页面标题</title>
  <link rel="stylesheet" href="css/style.css">
  <script src="js/main.js" defer></script>
</head>
<body>
  <header>
    <nav aria-label="主导航">
      <!-- 导航内容 -->
    </nav>
  </header>

  <main>
    <h1>页面主标题</h1>
    <!-- 页面主要内容 -->
  </main>

  <footer>
    <p>&copy; 2026 网站名称</p>
  </footer>
</body>
</html>
```