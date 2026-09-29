# [LaTeX 从入门到精通：一篇文章掌握高质量排版](https://mp.weixin.qq.com/s/6w1zKBPXSVsb5Fo7iOBgVg)

> Word 更像"边写边排"，LaTeX 更像"先描述结构，再自动排版"。当文档里出现大量公式、编号、引用、图表和参考文献时，LaTeX 的优势会越来越明显。修改了一段文字，后面的图片和表格全乱了；公式编号改了，正文中的引用要逐个检查；论文改到第十版，目录、页码、参考文献格式仍然不统一——LaTeX 正是为解决这类问题而生。它不是一个传统意义上的文字处理软件，而是一套基于标记语言的高质量排版系统：你负责表达"这是什么"，LaTeX 负责决定"它应该怎样排"。

---

## LaTeX 到底是什么？

LaTeX 建立在 TeX 排版系统之上。简单理解：

- **TeX** 是底层排版引擎；
- **LaTeX** 提供了更易用的命令、文档结构和宏包生态；
- **编译器** 把 `.tex` 源文件转换为 PDF；
- **宏包** 为 LaTeX 增加数学、图表、代码、参考文献等能力。

LaTeX 文档通常经历下面的流程：

```
编写 main.tex
↓
调用 XeLaTeX / LuaLaTeX / pdfLaTeX
↓
处理字体、公式、图片、引用和编号
↓
生成 main.pdf
```

与"所见即所得"的编辑器不同，LaTeX 更接近编程：

```latex
\section{研究方法}

本文采用问卷调查与访谈相结合的方法。
```

你写的是"这一段是一级章节"，而不是"这一行要用 18 号黑体并加粗"。至于字号、字体、间距和编号，由文档类或模板统一决定。

### LaTeX 适合什么？

LaTeX 特别适合：

- 数学、物理、计算机、工程类论文；
- 毕业论文、学位论文和技术报告；
- 包含大量公式、图表、编号和引用的长文档；
- 需要多人协作、版本管理和自动生成的文档；
- 书籍、讲义、试卷、简历和演示文稿。

但如果只是写一页通知、临时记录或强依赖拖拽设计的宣传页，普通文字处理软件往往更高效。

**工具没有高下，只有是否适合任务。**

---

## 搭建环境：本地安装还是在线编辑？

学习 LaTeX 通常有两条路线。

### 路线 A：在线编辑

在线平台的优势是打开浏览器即可使用，不需要处理安装和环境变量，适合：

- 第一次接触 LaTeX；
- 临时写作；
- 多人协作；
- 在不同设备之间切换。

创建项目后，新建 `main.tex`，选择 XeLaTeX 或 LuaLaTeX 编译器，即可开始中文写作。

### 路线 B：本地编辑

本地环境通常由两部分组成：

1. **TeX 发行版**：提供编译器、宏包和字体支持；
2. **代码编辑器**：负责编辑、补全、预览和跳转。

常见组合包括：

- Windows：TeX Live 或 MiKTeX；
- macOS：MacTeX；
- Linux：TeX Live；
- 编辑器：VS Code 配合 LaTeX Workshop，或专用 LaTeX 编辑器。

本地环境更适合：

- 长期使用；
- 大型项目；
- Git 版本控制；
- 自动化编译；
- 自定义字体和复杂模板。

### 新手应该选哪一种？

最省力的路径是：

> **先用在线平台理解语法，再根据长期需求迁移到本地。**

不要把"安装环境"变成学习 LaTeX 的第一道门槛。真正重要的是尽快编译出第一份 PDF。

---

## 5 分钟写出第一份中文 LaTeX 文档

新建文件 `main.tex`，输入以下内容：

```latex
\documentclass[UTF8,a4paper,12pt]{ctexart}

\usepackage{amsmath}
\usepackage{amssymb}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{hyperref}
\usepackage{geometry}

\geometry{left=2.8cm,right=2.8cm,top=2.6cm,bottom=2.6cm}

\title{我的第一份 LaTeX 文档}
\author{你的名字}
\date{\today}

\begin{document}

\maketitle
\tableofcontents
\newpage

\section{你好，LaTeX}

这是我的第一份中文 LaTeX 文档。

\subsection{一个公式}

爱因斯坦质能方程为
\[
E = mc^2.
\]

\subsection{一个列表}

\begin{itemize}
\item 结构清晰；
\item 自动编号；
\item 专注内容；
\item 排版稳定。
\end{itemize}

\end{document}
```

使用 XeLaTeX 编译，你会得到一份包含标题、目录、章节、公式和列表的 PDF。

这段代码已经体现了 LaTeX 文档最重要的三个部分。

### 1. 文档类

```latex
\documentclass[UTF8,a4paper,12pt]{ctexart}
```

它决定文档的基本类型和整体规则。

- `ctexart`：适合中文短文、报告和论文；
- `ctexrep`：适合较长的报告；
- `ctexbook`：适合书籍；
- `beamer`：适合演示文稿。

方括号里是选项，例如：

- `UTF8`：使用 UTF-8 编码；
- `a4paper`：A4 纸张；
- `12pt`：正文字号基准。

### 2. 导言区

从 `\documentclass` 到 `\begin{document}` 之间的部分叫作导言区。

这里通常用于：

- 加载宏包；
- 设置页面尺寸；
- 定义标题、作者和日期；
- 声明自定义命令；
- 配置字体和编号规则。

### 3. 正文区

```latex
\begin{document}
...
\end{document}
```

两者之间是真正会出现在文档里的内容。

---

## 掌握 LaTeX 的五个基本概念

LaTeX 语法看似很多，底层却主要由五类结构组成。

### 1. 命令

命令通常以反斜杠开头：

```latex
\LaTeX
\today
\newpage
\section{标题}
```

有些命令不带参数，有些命令用花括号接收参数。

```latex
\textbf{粗体文字}
\textit{斜体文字}
\emph{强调内容}
```

### 2. 环境

环境由 `\begin{...}` 和 `\end{...}` 包围：

```latex
\begin{center}
这段文字居中。
\end{center}
```

常见环境包括：

- `itemize`：无序列表；
- `enumerate`：有序列表；
- `figure`：图片；
- `table`：表格；
- `equation`：带编号公式；
- `align`：多行对齐公式；
- `theorem`：定理。

### 3. 分组

花括号不仅用于传递参数，也可限制格式的作用范围：

```latex
普通文字 {\bfseries 只有这一段加粗} 普通文字
```

分组结束后，格式自动恢复。

### 4. 注释

百分号 `%` 后面的内容不会进入最终文档：

```latex
% 这是注释
正文内容。 % 这里也可以写备注
```

注释非常适合记录：

- 修改原因；
- 待办事项；
- 暂时不用的内容；
- 模板参数说明。

### 5. 特殊字符

以下字符在 LaTeX 中有特殊意义：

```
#  $  %  &  _  {  }  ~  ^  \
```

要直接输出它们，通常需要转义：

```latex
\# \$ \% \& \_ \{ \}
```

反斜杠本身可以这样输出：

```latex
\textbackslash
```

---

## 用"结构"组织文章，而不是手动调字号

LaTeX 的核心思想是**语义化写作**。

不要手动把某行调成大字号来模拟标题，而应明确告诉 LaTeX：它是一个章节。

```latex
\section{一级标题}
\subsection{二级标题}
\subsubsection{三级标题}
\paragraph{段落标题}
```

长文档中还可能使用：

```latex
\part{第一部分}
\chapter{第一章}
```

其中 `\chapter` 通常用于 `report` 或 `book` 类文档，普通 `article` 类没有章级结构。

### 自动生成目录

只需在正文中加入：

```latex
\tableofcontents
```

LaTeX 会根据章节结构自动生成目录。

第一次编译后，目录可能暂时为空；再次编译，编号和页码就会补齐。这是因为 LaTeX 需要先收集结构信息，再生成最终结果。

### 换行与换段

在源文件中，单次回车通常只相当于一个空格。

```latex
这是第一行。
这是第二行。
```

编译后仍会是同一段。

要开始新段落，应在两段之间留一个**空行**：

```latex
这是第一段。

这是第二段。
```

强制换行可以使用：

```latex
第一行。\\
第二行。
```

但正文中不要滥用 `\\`。多数时候，让 LaTeX 自动断行和分页会得到更稳定的结果。

---

## 文本排版：粗体、斜体、引用与脚注

### 常用字体效果

```latex
\textbf{粗体}
\textit{斜体}
\emph{强调}
\underline{下划线}
\texttt{等宽字体}
```

在中文文档中，`\emph` 的具体效果由文档类和字体配置决定。相比直接指定"斜体"，使用"强调"更符合语义化原则。

### 引号

中文引号可以直接输入：

```
“这是中文引号。”
```

英文排版中，建议使用：

```latex
``This is a quotation.''
```

### 脚注

LaTeX 非常适合长文档排版。

```latex
\footnote{尤其适合包含公式和交叉引用的文档。}
```

LaTeX 会自动生成脚注编号并把内容放在页面底部。

### 引用环境

```latex
\begin{quote}
排版的目标，不是堆叠格式，而是建立清晰、稳定、可复用的表达结构。
\end{quote}
```

较长引用可使用 `quotation` 环境。

---

## 数学公式：LaTeX 最耀眼的能力

数学排版是 LaTeX 最广为人知的优势。

建议加载：

```latex
\usepackage{amsmath}
\usepackage{amssymb}
```

### 1. 行内公式

用一对 `$` 包围：

```latex
勾股定理写作 $a^2+b^2=c^2$。
```

行内公式应尽量简短，以免破坏正文行距。

### 2. 独立公式

不编号的独立公式：

```latex
\[
f(x)=ax^2+bx+c.
\]
```

不要优先使用 `$$ ... $$`。`\[ ... \]` 与 `equation` 等 LaTeX 环境在间距和兼容性上更规范。

### 3. 带编号公式

```latex
\begin{equation}
E = mc^2
\label{eq:energy}
\end{equation}
```

正文中引用：

```latex
由式~\eqref{eq:energy} 可知，质量与能量可以相互转化。
```

### 4. 上标、下标与分数

```latex
x^2
a_{n+1}
\frac{a+b}{c+d}
```

多字符上标或下标必须放入花括号：

```latex
x^{n+1}
a_{i,j}
```

### 5. 根号、求和、积分与极限

```latex
\sqrt{x}
\sqrt[n]{x}

\sum_{i=1}^{n} i
\prod_{k=1}^{n} k

\int_{0}^{1} x^2\,\mathrm{d}x

\lim_{x\to 0}\frac{\sin x}{x}=1
```

其中 `\,` 用于增加细小间距，`\mathrm{d}` 可让积分中的微分符号保持正体。

### 6. 多行对齐公式

```latex
\begin{align}
(a+b)^2
&= a^2+2ab+b^2, \\
(a-b)^2
&= a^2-2ab+b^2.
\end{align}
```

`&` 指定对齐位置，通常放在等号前；`\\` 表示换行。

不希望某一行编号时，可加 `\nonumber`，或直接使用不编号环境：

```latex
\begin{align*}
...
\end{align*}
```

### 7. 分段函数

```latex
\[
f(x)=
\begin{cases}
x^2, & x \ge 0, \\
-x,  & x < 0.
\end{cases}
\]
```

### 8. 矩阵

```latex
\[
A=
\begin{pmatrix}
1 & 2 \\
3 & 4
\end{pmatrix}.
\]
```

常见矩阵环境：

- `matrix`：无括号；
- `pmatrix`：圆括号；
- `bmatrix`：方括号；
- `vmatrix`：单竖线；
- `Vmatrix`：双竖线。

### 9. 常用数学符号

```latex
\alpha \beta \gamma \theta \lambda \mu \pi \sigma \omega

\le \ge \ne \approx \equiv

\in \notin \subset \subseteq \cup \cap

\forall \exists \Rightarrow \Leftrightarrow

\infty \partial \nabla
```

### 10. 给复杂公式加语义

不要只追求"能显示"，还应追求"好维护"。

例如，定义实数集合：

```latex
\newcommand{\R}{\mathbb{R}}
```

正文中写：

```latex
设 $x\in\R$。
```

比每次重复 `\mathbb{R}` 更清晰，也更容易统一修改。

---

## 列表：让信息层次更清楚

### 无序列表

```latex
\begin{itemize}
\item 第一项；
\item 第二项；
\item 第三项。
\end{itemize}
```

### 有序列表

```latex
\begin{enumerate}
\item 安装环境；
\item 编写源码；
\item 编译文档；
\item 检查输出。
\end{enumerate}
```

### 描述列表

```latex
\begin{description}
\item[TeX] 底层排版系统；
\item[LaTeX] 建立在 TeX 之上的文档准备系统；
\item[宏包] 为 LaTeX 增加扩展功能。
\end{description}
```

### 嵌套列表

列表可以嵌套，但不宜层级过深：

```latex
\begin{enumerate}
\item 文本排版
\begin{itemize}
\item 标题
\item 段落
\end{itemize}
\item 数学排版
\end{enumerate}
```

复杂列表可使用 `enumitem` 宏包自定义间距和编号：

```latex
\usepackage{enumitem}

\begin{enumerate}[label=\arabic*.]
\item 第一项
\item 第二项
\end{enumerate}
```

---

## 图片：别再手动拖来拖去

加载宏包：

```latex
\usepackage{graphicx}
```

插入图片：

```latex
\begin{figure}[htbp]
\centering
\includegraphics[width=0.75\textwidth]{images/architecture.pdf}
\caption{系统架构示意图}
\label{fig:architecture}
\end{figure}
```

正文中引用：

```latex
系统整体结构如图~\ref{fig:architecture} 所示。
```

### 关键参数解释

- `[htbp]`：建议 LaTeX 按当前位置、页顶、页底或浮动页尝试放置；
- `\centering`：居中；
- `width=0.75\textwidth`：图片宽度为正文宽度的 75%；
- `\caption`：图题；
- `\label`：交叉引用标签。

### 为什么图片会"跑"？

`figure` 是**浮动体**。LaTeX 会综合页面剩余空间、图片尺寸和排版规则，为它寻找更合适的位置。

**这不是错误，而是自动排版机制。**

常用处理方法：

1. 优先接受合理浮动，不要强行控制每一张图；
2. 缩小图片尺寸；
3. 调整图片在源码中的位置；
4. 使用 `\FloatBarrier` 限制浮动体越过某个位置。

使用 `\FloatBarrier` 需要：

```latex
\usepackage{placeins}
```

不建议一遇到浮动问题就使用 `[H]` 强制固定，因为它可能造成大片空白或分页不自然。确实需要时，可加载：

```latex
\usepackage{float}
```

然后使用：

```latex
\begin{figure}[H]
```

### 图片格式怎么选？

一般建议：

- 照片：JPG；
- 截图：PNG；
- 线图、示意图、曲线图：PDF 等矢量格式；
- 统一将图片放入 `images/` 文件夹。

---

## 表格：从"能用"到"专业"

LaTeX 的基础表格使用 `tabular` 环境：

```latex
\begin{tabular}{lcr}
左对齐 & 居中 & 右对齐 \\
A & B & C \\
1 & 2 & 3
\end{tabular}
```

列格式含义：

- `l`：左对齐；
- `c`：居中；
- `r`：右对齐；
- `p{3cm}`：固定宽度并自动换行。

### 推荐使用三线表

加载：

```latex
\usepackage{booktabs}
```

示例：

```latex
\begin{table}[htbp]
\centering
\caption{不同模型的实验结果}
\label{tab:results}
\begin{tabular}{lcc}
\toprule
模型 & 准确率 & 推理时间/ms \\
\midrule
Baseline & 89.2\% & 18.4 \\
Model A  & 92.7\% & 20.1 \\
Model B  & 94.1\% & 23.6 \\
\bottomrule
\end{tabular}
\end{table}
```

三线表通常比带大量竖线的表格更清爽。

### 表格太宽怎么办？

可以使用 `tabularx`：

```latex
\usepackage{tabularx}

\begin{tabularx}{\textwidth}{lXr}
\toprule
项目 & 说明 & 状态 \\
\midrule
环境搭建 & 安装编译器、宏包与编辑器 & 完成 \\
公式排版 & 掌握行内公式与多行公式 & 进行中 \\
\bottomrule
\end{tabularx}
```

其中 `X` 列会自动占用剩余宽度并换行。

也可以缩放：

```latex
\resizebox{\textwidth}{!}{
\begin{tabular}{...}
...
\end{tabular}
}
```

但缩放会同时缩小字体，应谨慎使用。优先考虑：

- 精简内容；
- 调整列宽；
- 横向页面；
- 拆分表格。

### 跨行与跨列

跨列：

```latex
\multicolumn{2}{c}{合并两列}
```

跨行需要 `multirow` 宏包：

```latex
\usepackage{multirow}
```

长表格可使用 `longtable` 宏包，让表格自动跨页。

---

## 交叉引用：改一次，全篇自动更新

大型文档最怕手动维护"见图 3""见表 5""见第 2.1 节"。

LaTeX 的解决方案是：

1. 在目标位置放置标签；
2. 在正文中引用标签；
3. 由编译器自动维护编号。

### 给章节加标签

```latex
\section{实验设计}
\label{sec:experiment}
```

引用：

```latex
实验流程见第~\ref{sec:experiment} 节。
```

### 给公式、图片和表格加标签

```latex
\begin{equation}
a^2+b^2=c^2
\label{eq:pythagorean}
\end{equation}

\begin{figure}[htbp]
...
\caption{实验流程}
\label{fig:workflow}
\end{figure}

\begin{table}[htbp]
...
\caption{实验结果}
\label{tab:result}
\end{table}
```

### 标签命名建议

给标签增加类型前缀：

```
sec:   章节
fig:   图片
tab:   表格
eq:    公式
thm:   定理
alg:   算法
```

例如：

```latex
\label{sec:method}
\label{fig:system}
\label{tab:ablation}
\label{eq:loss}
```

标签名应稳定、可读，不要把当前编号写进标签：

```latex
% 不推荐
\label{fig:3}

% 推荐
\label{fig:model-architecture}
```

### 自动显示引用类型

加载：

```latex
\usepackage{hyperref}
```

可以使用：

```latex
\autoref{fig:workflow}
```

它会根据目标类型自动生成"图""表"或"节"等前缀。更复杂的引用需求还可以使用 `cleveref` 宏包。

---

## 参考文献：把手工编号交给工具

参考文献管理是 LaTeX 在学术写作中的核心优势之一。

推荐使用 `biblatex` 配合 Biber。

### 第一步：创建文献库

新建 `references.bib`：

```bibtex
@book{lamport1994latex,
author    = {Leslie Lamport},
title     = {LaTeX: A Document Preparation System},
year      = {1994},
publisher = {Addison-Wesley}
}

@article{knuth1984literate,
author  = {Donald E. Knuth},
title   = {Literate Programming},
journal = {The Computer Journal},
year    = {1984},
volume  = {27},
number  = {2},
pages   = {97--111}
}
```

`lamport1994latex` 和 `knuth1984literate` 是引用键，可以自行设计，但要保持唯一。

### 第二步：在导言区加载文献库

```latex
\usepackage[
backend=biber,
style=numeric,
sorting=none
]{biblatex}

\addbibresource{references.bib}
```

### 第三步：正文中引用

```latex
LaTeX 由 Lamport 在 TeX 基础上发展而来\cite{lamport1994latex}。
```

一次引用多篇：

```latex
\cite{lamport1994latex,knuth1984literate}
```

### 第四步：输出参考文献

在文档末尾加入：

```latex
\printbibliography
```

### 本地编译顺序

如果手动编译，通常需要：

```
XeLaTeX
Biber
XeLaTeX
XeLaTeX
```

更省心的方法是使用 `latexmk` 自动处理依赖：

```bash
latexmk -xelatex main.tex
```

### 文献管理的正确思路

不要在正文末尾手工输入：

```
[1] 某某某，某本书……
```

更稳妥的做法是：

- 文献信息统一存入 `.bib` 文件；
- 正文只保留引用键；
- 格式由样式文件统一控制；
- 新增或删除文献时自动重排编号。

---

## 代码排版：展示命令、程序和输出

简单代码可以使用 `verbatim`：

```latex
\begin{verbatim}
print("Hello, LaTeX!")
\end{verbatim}
```

更灵活的方式是使用 `listings`：

```latex
\usepackage{listings}
\usepackage{xcolor}

\lstset{
basicstyle=\ttfamily\small,
numbers=left,
numberstyle=\tiny,
frame=single,
breaklines=true,
showstringspaces=false
}
```

正文中：

```latex
\begin{lstlisting}[language=Python,caption={一个简单的 Python 程序}]
def greet(name: str) -> str:
    return f"Hello, {name}!"

print(greet("LaTeX"))
\end{lstlisting}
```

对于需要语法高亮的复杂场景，还可以使用 `minted`。它依赖外部高亮工具，并通常需要开启 shell escape，因此在模板受限或安全要求较高的环境中，应先确认编译条件。

---

## 定理、定义、证明与学术结构

加载：

```latex
\usepackage{amsthm}
```

在导言区定义环境：

```latex
\newtheorem{theorem}{定理}[section]
\newtheorem{lemma}[theorem]{引理}
\newtheorem{proposition}[theorem]{命题}

\theoremstyle{definition}
\newtheorem{definition}[theorem]{定义}

\theoremstyle{remark}
\newtheorem{remark}[theorem]{注}
```

正文中：

```latex
\begin{definition}
若函数 $f$ 在点 $x_0$ 的某邻域内有定义，并且
\[
\lim_{x\to x_0}f(x)=f(x_0),
\]
则称 $f$ 在 $x_0$ 处连续。
\end{definition}

\begin{theorem}
若函数在闭区间上连续，则它在该区间上有界。
\end{theorem}

\begin{proof}
根据闭区间上连续函数的性质，可得结论。
\end{proof}
```

定理编号会自动维护，也可以通过 `\label` 和 `\ref` 进行引用。

---

## 中文字体与页面设置

使用 `ctex` 文档类后，中文基本排版通常已经可以正常工作。

### 页面边距

使用 `geometry`：

```latex
\usepackage{geometry}

\geometry{
a4paper,
left=2.8cm,
right=2.8cm,
top=2.6cm,
bottom=2.6cm
}
```

### 行距

```latex
\usepackage{setspace}

\onehalfspacing
```

也可以局部设置：

```latex
\begin{spacing}{1.25}
这部分使用 1.25 倍行距。
\end{spacing}
```

### 段首缩进与段间距

中文文档一般由 ctex 处理段首缩进。需要自定义时，可以设置：

```latex
\setlength{\parindent}{2em}
\setlength{\parskip}{0.3em}
```

不要同时把段首缩进和段间距都调得很大，否则层次会显得松散。

### 字体设置

在 XeLaTeX 或 LuaLaTeX 下，可以使用系统字体。中文文档通常通过 ctex 的字体接口进行配置，例如：

```latex
\setCJKmainfont{Noto Serif CJK SC}
\setCJKsansfont{Noto Sans CJK SC}
\setCJKmonofont{Noto Sans Mono CJK SC}
```

只有在确定目标机器安装了这些字体时，才应写死字体名称。多人协作时，最好在项目说明中列出字体依赖，或使用团队都能获得的字体。

---

## 页眉页脚与页面风格

加载：

```latex
\usepackage{fancyhdr}
```

设置：

```latex
\pagestyle{fancy}
\fancyhf{}

\fancyhead[L]{LaTeX 学习笔记}
\fancyhead[R]{\leftmark}
\fancyfoot[C]{\thepage}

\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}
```

其中：

- `\fancyhf{}`：先清空默认页眉页脚；
- `L`、`C`、`R`：分别表示左、中、右；
- `\thepage`：当前页码；
- `\leftmark`：通常表示当前章或节的信息，具体行为与文档类有关。

页眉页脚很容易"越调越乱"。正式论文中，应优先遵守学校、期刊或单位提供的模板，不要自行覆盖关键样式。

---

## 自定义命令：从重复劳动中解放出来

当某段写法频繁出现时，可以把它封装成命令。

### 无参数命令

```latex
\newcommand{\R}{\mathbb{R}}
```

使用：

```latex
设 $x\in\R$。
```

### 带参数命令

```latex
\newcommand{\vect}[1]{\boldsymbol{#1}}
```

使用：

```latex
向量 $\vect{x}$ 的二范数为 $\|\vect{x}\|_2$。
```

### 多参数命令

```latex
\newcommand{\inner}[2]{\left\langle #1,#2 \right\rangle}
```

使用：

```latex
$\inner{x}{y}$
```

### 带默认值的命令

```latex
\newcommand{\keyword}[2][blue]{\textcolor{#1}{\textbf{#2}}}
```

使用：

```latex
\keyword{默认蓝色}
\keyword[red]{红色强调}
```

### 定义数学运算符

```latex
\DeclareMathOperator{\rank}{rank}
\DeclareMathOperator*{\argmin}{arg\,min}
\DeclareMathOperator*{\argmax}{arg\,max}
```

使用：

```latex
\[
x^\star=\argmin_x f(x).
\]
```

与直接写 `argmin` 相比，运算符命令能获得更规范的字体和间距。

### 自定义命令的原则

一个好命令应表达"语义"，而不只是"外观"。

例如：

```latex
% 更偏语义
\newcommand{\important}[1]{\textbf{#1}}
```

比：

```latex
\newcommand{\redbold}[1]{\textcolor{red}{\textbf{#1}}}
```

更容易在未来统一更换样式。

---

## 条件、变量与可复用模板

当同一份文档需要输出不同版本时，可以使用布尔开关。

```latex
\usepackage{ifthen}

\newboolean{showanswer}
\setboolean{showanswer}{true}
```

正文中：

```latex
\ifthenelse{\boolean{showanswer}}
{这里显示参考答案。}
{}
```

这样可以用同一套源码生成：

- 学生版与教师版；
- 匿名版与署名版；
- 完整版与摘要版；
- 内部版与公开版。

更复杂的模板还可以使用 `etoolbox`、`\newif` 或 LaTeX3 提供的编程接口。

不过，在真正需要之前，不要过早把文档写成"宏包"。先保证结构清楚，再逐步抽象。

---

## 多文件项目：长文档不要全塞进 main.tex

当文档超过十几页后，建议拆分目录。

```
latex-project/
├── main.tex
├── preamble.tex
├── references.bib
├── chapters/
│   ├── introduction.tex
│   ├── method.tex
│   ├── experiments.tex
│   └── conclusion.tex
├── figures/
│   ├── architecture.pdf
│   └── results.png
└── tables/
    └── ablation.tex
```

### main.tex 示例

```latex
\documentclass[UTF8,a4paper,12pt]{ctexrep}

\input{preamble}

\begin{document}

\maketitle
\tableofcontents

\include{chapters/introduction}
\include{chapters/method}
\include{chapters/experiments}
\include{chapters/conclusion}

\printbibliography

\end{document}
```

### \input 与 \include 的区别

`\input{file}`：

- 直接插入文件内容；
- 可用于导言区或正文；
- 不会自动分页；
- 适合小模块、表格和公共配置。

`\include{file}`：

- 通常用于正文中的大章节；
- 会在前后分页；
- 可配合 `\includeonly` 只编译部分章节。

例如：

```latex
\includeonly{chapters/method,chapters/experiments}
```

这样在调试长文档时，可以减少不必要的编译内容。

### 不要在子文件中重复写完整结构

被 `\input` 或 `\include` 的章节文件通常只写正文：

```latex
\chapter{研究方法}

本章介绍数据、模型与实验流程。
```

不需要再次写 `\documentclass`、`\begin{document}`、`\end{document}`。

---

## 自动化编译：让工具管理编译顺序

LaTeX 项目中可能同时存在：

- 目录；
- 交叉引用；
- 参考文献；
- 索引；
- 术语表；
- 多个辅助文件。

手工记忆编译顺序很容易出错。推荐使用 `latexmk`：

```bash
latexmk -xelatex main.tex
```

持续监听文件变化：

```bash
latexmk -xelatex -pvc main.tex
```

清理辅助文件：

```bash
latexmk -c
```

清理包括 PDF 在内的生成文件：

```bash
latexmk -C
```

可以在项目根目录创建 `.latexmkrc`，统一指定编译器和参数。

一个简单示例：

```
$xelatex = 'xelatex -synctex=1 -interaction=nonstopmode %O %S';
$pdf_mode = 5;
```

编辑器通常也能调用 latexmk，实现保存后自动编译、源码与 PDF 双向跳转。

---

## 用 Git 管理 LaTeX：把写作变成可追踪的工程

LaTeX 源文件是纯文本，非常适合版本控制。

Git 可以帮助你：

- 查看每次修改了什么；
- 恢复到任意历史版本；
- 创建分支尝试不同写法；
- 与合作者合并修改；
- 给投稿版、答辩版、最终版打标签。

### 推荐忽略辅助文件

在 `.gitignore` 中加入：

```
*.aux
*.bbl
*.bcf
*.blg
*.fdb_latexmk
*.fls
*.log
*.out
*.run.xml
*.synctex.gz
*.toc
*.lof
*.lot
```

是否提交 PDF 取决于协作方式：

- 只管理源码：忽略 PDF；
- 需要方便预览：可提交稳定版本 PDF；
- 自动发布：让持续集成系统生成 PDF。

### 提交信息要表达"内容变化"

推荐：

- 补充实验设置与数据预处理说明；
- 修正公式 3 的符号定义；
- 重绘系统架构图；
- 统一参考文献引用格式。

不推荐：

- 修改；
- update；
- final；
- final-final。

---

## 常见报错：先看第一条真正的错误

LaTeX 的报错信息可能很长，但后续很多错误只是连锁反应。

> **排错原则：从日志中找到第一条真正的错误，从那里开始修复。**

### 1. Undefined control sequence

含义：使用了未定义命令。

常见原因：

- 命令拼写错误；
- 忘记加载宏包；
- 自定义命令没有声明；
- 使用了当前编译器不支持的命令。

例如：

```latex
\includegraphic{image.png}
```

正确命令是：

```latex
\includegraphics{image.png}
```

### 2. Missing $ inserted

含义：LaTeX 认为这里需要进入或退出数学模式。

常见原因：

- 正文中直接使用 `_` 或 `^`；
- 数学命令写在普通文本模式；
- `$` 数量不匹配。

错误：

```latex
变量名是 user_id。
```

正确：

```latex
变量名是 user\_id。
```

或放在等宽文本中：

```latex
变量名是 \texttt{user\_id}。
```

### 3. Extra alignment tab has been changed to \cr

含义：表格或对齐公式中 `&` 数量不对。

例如三列表格，每一行应有两个 `&`：

```latex
A & B & C \\
```

### 4. File ... not found

检查：

- 文件是否存在；
- 路径是否正确；
- 文件名大小写是否一致；
- 是否写错扩展名；
- 图片是否位于编译器可访问的目录。

### 5. Citation ... undefined

检查：

- 引用键是否与 `.bib` 文件一致；
- 是否运行 Biber；
- 是否重复编译；
- `\addbibresource` 路径是否正确。

### 6. Reference ... undefined

通常需要再次编译。如果反复出现，则检查：

- `\label` 是否存在；
- 标签名是否拼写一致；
- 是否出现重复标签。

### 7. Overfull \hbox

表示某一行内容超出了版心。

常见原因：

- 很长的网址；
- 无法断行的英文单词；
- 过宽公式；
- 过宽表格；
- 长代码或文件路径。

不要简单忽略。应定位日志中的行号，再根据内容处理。

网址建议使用：

```latex
\url{https://example.com/a/very/long/path}
```

需要加载：

```latex
\usepackage{hyperref}
```

### 8. 中文显示为方框或乱码

检查：

- 源文件是否使用 UTF-8；
- 是否使用 XeLaTeX 或 LuaLaTeX；
- 是否使用 ctex；
- 指定字体是否真实存在；
- 编辑器与编译器配置是否一致。

### 9. 宏包冲突

遇到宏包冲突时：

1. 阅读日志中的冲突提示；
2. 检查宏包加载顺序；
3. 删除不必要的宏包；
4. 用最小示例复现；
5. 查看宏包官方文档。

---

## 最小工作示例：排错的终极方法

当一个大型项目无法编译时，不要在几千行代码里盲猜。

创建一个最小文件：

```latex
\documentclass{article}

\begin{document}

Hello, LaTeX!

\end{document}
```

确认能编译后，逐步加入：

1. 文档类选项；
2. 宏包；
3. 自定义命令；
4. 出错公式；
5. 出错图片或表格；
6. 参考文献配置。

直到错误重新出现。

这个方法叫作**最小工作示例**（Minimal Working Example，MWE）。它不仅适合自己排错，也是向他人提问时最有效的方式。

一个好的 MWE 应满足：

- 足够短；
- 可以直接编译；
- 能稳定复现问题；
- 删除了与问题无关的内容；
- 包含必要的错误信息。

---

## LaTeX 进阶：把格式与内容彻底分离

熟练使用 LaTeX 的分水岭，不是记住更多命令，而是学会控制复杂度。

### 1. 把公共配置放进 preamble.tex

```latex
% preamble.tex
\usepackage{amsmath,amssymb}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{hyperref}
\usepackage{geometry}

\geometry{margin=2.7cm}

\newcommand{\R}{\mathbb{R}}
\newcommand{\vect}[1]{\boldsymbol{#1}}
```

主文件只需要：

```latex
\input{preamble}
```

### 2. 把复杂表格放到单独文件

```latex
\begin{table}[htbp]
\centering
\caption{消融实验结果}
\label{tab:ablation}
\input{tables/ablation}
\end{table}
```

这样正文更易读，表格也可独立生成或复用。

### 3. 统一图片路径

```latex
\graphicspath{{figures/}{images/}}
```

之后可以写：

```latex
\includegraphics{architecture.pdf}
```

而不必每次重复完整目录。

### 4. 给常见概念建立宏

```latex
\newcommand{\dataset}{ExampleBench}
\newcommand{\modelname}{SmartNet}
```

正文中：

```latex
我们在 \dataset{} 上评估 \modelname{}。
```

将来更换数据集或模型名，只改一处即可。

### 5. 不要在正文里散落大量样式命令

如果正文中到处都是 `\vspace`、`\hspace`、`\fontsize`、`\color`、`\renewcommand`，通常说明结构与样式已经混在一起。

优先考虑：

- 修改文档类；
- 修改统一样式；
- 定义语义化命令；
- 使用专门环境；
- 把布局规则放进模板。

---

## 绘图与自动生成内容

LaTeX 不只能"插入图片"，还可以生成图。

### TikZ

TikZ 适合：

- 流程图；
- 网络结构；
- 几何图形；
- 坐标图；
- 简单技术示意图。

示例：

```latex
\usepackage{tikz}

\begin{tikzpicture}
\draw[->] (0,0) -- (4,0) node[right] {$x$};
\draw[->] (0,0) -- (0,3) node[above] {$y$};
\draw (0,0) parabola (3,2.5);
\end{tikzpicture}
```

### PGFPlots

PGFPlots 适合从数据生成学术图表：

```latex
\usepackage{pgfplots}
\pgfplotsset{compat=1.18}

\begin{tikzpicture}
\begin{axis}[
xlabel={Epoch},
ylabel={Accuracy},
grid=major
]
\addplot coordinates {
(1,0.71)
(2,0.78)
(3,0.84)
(4,0.88)
};
\end{axis}
\end{tikzpicture}
```

对于数据分析项目，也可以用 Python、R 或其他工具生成 PDF/SVG 图，再交给 LaTeX 排版。更推荐的原则是：

> **数据处理交给擅长计算的工具，文档结构和最终排版交给 LaTeX。**

---

## 性能优化：文档越大，越需要策略

大型项目编译慢时，可以采取以下方法。

### 1. 只编译当前章节

```latex
\includeonly{chapters/experiments}
```

### 2. 草稿模式跳过图片

```latex
\documentclass[draft]{ctexrep}
```

或：

```latex
\usepackage[draft]{graphicx}
```

编译时只显示图片占位框。

### 3. 外部化复杂 TikZ 图

复杂图可以单独编译并缓存，避免每次重新绘制。

### 4. 压缩图片

超高分辨率照片会显著增加编译时间和 PDF 体积。按最终版面尺寸准备合理分辨率即可。

### 5. 删除无用宏包

每加载一个宏包，都可能增加编译时间、引入依赖或造成冲突。模板中不需要的宏包应及时移除。

### 6. 定期清理辅助文件

```bash
latexmk -c
```

当引用、目录或文献状态异常时，清理后重新完整编译常能解决缓存问题。

---

## 模板使用原则：能不改底层，就不要改底层

学校论文、期刊投稿和会议论文通常会提供模板。

使用模板时，建议遵守以下顺序：

1. 先编译原始示例；
2. 确认环境正常；
3. 复制一份作为自己的项目；
4. 只替换示例内容；
5. 不随意删除不理解的配置；
6. 出现问题时与原始模板对比；
7. 提交前按要求清理辅助文件。

不要因为"看起来不够漂亮"就擅自更改：

- 页边距；
- 标题字号；
- 行距；
- 图表标题格式；
- 参考文献样式；
- 页眉页脚；
- 匿名审稿设置。

**正式文档首先要合规，其次才是个性化。**

---

## LaTeX 学习路线：从会写到会设计

### 第一阶段：能编译

目标：

- 理解导言区与正文区；
- 会写章节、段落和列表；
- 会插入简单公式；
- 能生成 PDF。

练习：

- 写一页学习笔记；
- 写一份课程作业；
- 重现本文的最小示例。

### 第二阶段：能完成完整文档

目标：

- 会插入图片和表格；
- 会使用 `\label`、`\ref` 和 `\eqref`；
- 会生成目录；
- 会管理参考文献；
- 会处理常见报错。

练习：

- 写一份 5～10 页的技术报告；
- 加入 3 张图、2 个表和 10 条参考文献；
- 保证所有编号自动生成。

### 第三阶段：能维护长项目

目标：

- 拆分多文件；
- 使用 latexmk；
- 使用 Git；
- 建立统一目录和命名规范；
- 编写自定义命令。

练习：

- 把报告拆成多个章节；
- 为模型名、数据集名和常用符号定义宏；
- 用 Git 管理每一轮修改。

### 第四阶段：能设计模板

目标：

- 理解文档类、宏包与样式的边界；
- 自定义标题、定理和页面风格；
- 编写可复用环境；
- 处理不同输出版本；
- 阅读宏包文档和模板源码。

练习：

- 制作个人技术报告模板；
- 制作试卷与答案双版本；
- 封装统一的图表、提示框和代码环境。

### 第五阶段：理解 LaTeX3 与宏编程

目标：

- 理解 token、展开和作用域；
- 学习 expl3 语法；
- 编写结构稳定的宏包；
- 为团队或组织维护文档系统。

这一步并非大多数用户的必需项。能把长文档写得清楚、稳定、可维护，已经属于高水平使用。

---

## 一份可直接复用的中文文章模板

下面给出一个适合课程报告、技术文章和普通论文初稿的模板。

```latex
\documentclass[UTF8,a4paper,12pt]{ctexart}

% ---------- 基础宏包 ----------
\usepackage{amsmath,amssymb,amsthm}
\usepackage{graphicx}
\usepackage{booktabs}
\usepackage{tabularx}
\usepackage{geometry}
\usepackage{hyperref}
\usepackage{cleveref}
\usepackage{enumitem}
\usepackage{xcolor}
\usepackage{listings}
\usepackage[
backend=biber,
style=numeric,
sorting=none
]{biblatex}

% ---------- 资源 ----------
\graphicspath{{figures/}}
\addbibresource{references.bib}

% ---------- 页面 ----------
\geometry{
left=2.8cm,
right=2.8cm,
top=2.6cm,
bottom=2.6cm
}

% ---------- 超链接 ----------
\hypersetup{
colorlinks=true,
linkcolor=black,
citecolor=black,
urlcolor=blue,
pdftitle={LaTeX 示例文章},
pdfauthor={作者姓名}
}

% ---------- 列表 ----------
\setlist{
itemsep=0.2em,
topsep=0.4em
}

% ---------- 代码 ----------
\lstset{
basicstyle=\ttfamily\small,
numbers=left,
numberstyle=\tiny,
frame=single,
breaklines=true,
showstringspaces=false
}

% ---------- 自定义命令 ----------
\newcommand{\R}{\mathbb{R}}
\newcommand{\vect}[1]{\boldsymbol{#1}}
\DeclareMathOperator*{\argmin}{arg\,min}

% ---------- 定理环境 ----------
\newtheorem{theorem}{定理}[section]
\newtheorem{definition}[theorem]{定义}

% ---------- 文档信息 ----------
\title{文章标题}
\author{作者姓名}
\date{\today}

\begin{document}

\maketitle

\begin{abstract}
这里填写摘要。用几句话说明背景、问题、方法和结论。
\end{abstract}

\tableofcontents
\newpage

\section{引言}
\label{sec:introduction}

这里填写研究背景与文章结构。

\section{方法}
\label{sec:method}

设输入向量为 $\vect{x}\in\R^d$，目标函数为
\begin{equation}
x^\star=\argmin_x f(x).
\label{eq:objective}
\end{equation}

如式~\eqref{eq:objective} 所示，我们希望找到目标函数的最优解。

\section{实验}
\label{sec:experiments}

图~\ref{fig:example} 展示了实验流程。

\begin{figure}[htbp]
\centering
\includegraphics[width=0.7\textwidth]{example.pdf}
\caption{实验流程示意图}
\label{fig:example}
\end{figure}

表~\ref{tab:result} 汇总了主要结果。

\begin{table}[htbp]
\centering
\caption{实验结果}
\label{tab:result}
\begin{tabular}{lcc}
\toprule
方法 & 准确率 & 时间/ms \\
\midrule
Baseline & 89.2\% & 18.4 \\
Proposed & 94.1\% & 23.6 \\
\bottomrule
\end{tabular}
\end{table}

\section{结论}
\label{sec:conclusion}

这里总结主要发现、局限与未来工作。

\printbibliography

\end{document}
```

这个模板不是为了覆盖所有需求，而是提供一个清晰、可扩展的起点。

---

## LaTeX 常用命令速查表

**文档结构**

```latex
\part{部分}
\chapter{章}
\section{节}
\subsection{小节}
\subsubsection{子小节}
\tableofcontents
```

**文本格式**

```latex
\textbf{粗体}
\textit{斜体}
\emph{强调}
\texttt{等宽}
\footnote{脚注}
```

**列表**

```latex
\begin{itemize}
\item 项目
\end{itemize}

\begin{enumerate}
\item 项目
\end{enumerate}
```

**数学**

```latex
$x^2$

\[
\frac{a}{b}
\]

\begin{equation}
...
\end{equation}

\begin{align}
...
\end{align}
```

**图片**

```latex
\includegraphics[width=0.8\textwidth]{figure.pdf}
```

**表格**

```latex
\begin{tabular}{lcr}
A & B & C \\
\end{tabular}
```

**引用**

```latex
\label{fig:demo}
\ref{fig:demo}
\eqref{eq:demo}
\autoref{sec:demo}
```

**参考文献**

```latex
\cite{key}
\printbibliography
```

**文件拆分**

```latex
\input{file}
\include{chapter}
```

**间距与分页**

```latex
\newpage
\clearpage
\vspace{1em}
\hspace{1em}
```

其中 `\clearpage` 不仅分页，还会尽量排出此前尚未放置的浮动体。

---

## 十条真正有用的经验

1. **先写内容，再做样式**。不要在第一段还没写完时就纠结页眉线宽和标题颜色。
2. **优先使用结构命令**。用 `\section`，不要手动放大字体模拟标题。
3. **所有编号都交给 LaTeX**。图、表、公式、章节、定理、参考文献都不要手工编号。
4. **标签要有语义**。使用 `fig:model-architecture`，不要使用 `fig:3`。
5. **长文档尽早拆分文件**。项目越晚拆，迁移成本越高。
6. **重复内容尽早定义命令**。模型名、数据集名、单位和数学符号尤其适合封装。
7. **遇到错误先做最小示例**。不要靠删除随机代码碰运气。
8. **不要加载自己不理解的宏包**。宏包越多，不代表功能越强，反而可能增加冲突。
9. **正式投稿优先服从模板**。不要为了"更好看"破坏格式规范。
10. **定期提交版本**。使用 Git 时，每完成一个逻辑修改就提交一次，别等到深夜再提交"最终最终版"。

---

## 结语：LaTeX 的终点不是"记住命令"

初学 LaTeX 时，你会觉得它是一堆反斜杠、花括号和编译错误。

用得稍久一些，你会发现它真正教会你的，是另一种写作方式：

- 用结构代替手工格式；
- 用标签代替硬编码编号；
- 用文献库代替手工参考文献；
- 用命令代替重复输入；
- 用模板代替反复调整；
- 用版本控制代替"最终版 7"；
- 用自动化代替机械劳动。

真正的"精通"，不是能写出最复杂的宏，而是能让文档始终保持：

> **结构清楚、格式统一、修改安全、协作顺畅、长期可维护。**

从今天开始，新建一个 `main.tex`，编译出第一份 PDF。

你会发现，LaTeX 的学习曲线虽然有一点陡，但一旦跨过起点，它会把大量排版时间还给真正重要的事情——思考与表达。
