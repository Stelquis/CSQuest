#!/usr/bin/env python3
"""将三个 Markdown 文档分别导出为美观的 HTML 文件"""

import markdown
import os

BASE = "/workspace/Blockchain/Project"

docs = [
    ("README.md", "环境部署手册 — 现实世界资产代币化系统（RWA）"),
    ("设计说明文档.md", "设计说明文档 — 现实世界资产代币化系统（RWA）"),
    ("测试报告.md", "测试报告 — 现实世界资产代币化系统（RWA）"),
]

CSS = """
/* ===== 根字体：基于它所有 rem 自动缩放 ===== */
html { font-size: 100%; }  /* 浏览器默认 16px */

* { margin: 0; padding: 0; box-sizing: border-box; }

body {
  font-family: "Noto Sans SC", "Microsoft YaHei", "PingFang SC", sans-serif;
  font-size: 0.95rem;
  line-height: 1.85;
  color: #2c3e50;
  background: #fff;
}

/* ===== 容器：vw 视口宽度，缩放自动重排，无上限 ===== */
.container {
  width: 80vw;
  margin: 0 auto;
  padding: 2.5rem 1.5rem 3.5rem;
  word-wrap: break-word;
  overflow-wrap: break-word;
}

/* ===== 封面 ===== */
.cover {
  text-align: center;
  padding: 5rem 0 3rem;
  border-bottom: 1px solid #eee;
  margin-bottom: 2.5rem;
}
.cover .logo {
  font-size: 3.5rem;
  color: #1a73e8;
  margin-bottom: 1.25rem;
}
.cover h1 {
  font-size: 1.6rem;
  color: #1a2a3a;
  border: none;
  margin-bottom: 0.75rem;
}
.cover .subtitle {
  font-size: 0.85rem;
  color: #888;
}
.cover .meta {
  font-size: 0.8rem;
  color: #999;
  line-height: 2.2;
  margin-top: 2.25rem;
}
.cover .divider {
  width: 4rem;
  height: 0.2rem;
  background: #1a73e8;
  margin: 1.5rem auto;
}

/* ===== 标题 ===== */
h1 {
  font-size: 1.35rem;
  color: #1a73e8;
  border-bottom: 0.15rem solid #1a73e8;
  padding-bottom: 0.6rem;
  margin: 2.25rem 0 1.25rem;
}
h1:first-of-type {
  margin-top: 0;
}

h2 {
  font-size: 1.05rem;
  color: #2c3e50;
  border-left: 0.25rem solid #1a73e8;
  padding-left: 0.75rem;
  margin: 1.8rem 0 0.85rem;
}

h3 {
  font-size: 0.95rem;
  color: #444;
  margin: 1.5rem 0 0.6rem;
}

h4 {
  font-size: 0.9rem;
  color: #555;
  margin: 1.1rem 0 0.5rem;
}

/* ===== 表格：自适应缩放 ===== */
.table-wrapper {
  width: 100%;
  overflow-x: auto;
}
table {
  width: 100%;
  border-collapse: collapse;
  margin: 1rem 0;
  font-size: 0.8rem;
}
th, td {
  border: 1px solid #dde1e7;
  padding: 0.5rem 0.75rem;
  text-align: left;
  word-break: break-word;
}
th {
  background: #e8f0fe;
  color: #1a73e8;
  font-weight: 600;
}
tr:nth-child(even) { background: #f8f9fb; }

/* ===== 代码 ===== */
code {
  background: #f0f0f0;
  padding: 0.125rem 0.4rem;
  border-radius: 0.25rem;
  font-family: "JetBrains Mono", "Fira Code", "Consolas", monospace;
  font-size: 0.82rem;
  color: #c7254e;
  word-break: break-all;
}

pre {
  background: #f6f8fa;
  border: 1px solid #dde1e7;
  border-radius: 0.5rem;
  padding: 1rem 1.25rem;
  overflow-x: auto;
  font-size: 0.78rem;
  line-height: 1.6;
  margin: 0.85rem 0;
  white-space: pre-wrap;       /* 自动换行 */
  word-wrap: break-word;
}
pre code {
  background: none;
  padding: 0;
  color: #24292f;
  font-size: 0.78rem;
  word-break: normal;
}

/* ===== 引用 ===== */
blockquote {
  border-left: 0.25rem solid #1a73e8;
  margin: 1rem 0;
  padding: 0.6rem 1.25rem;
  background: #f0f7ff;
  color: #666;
  border-radius: 0 0.4rem 0.4rem 0;
}

hr {
  border: none;
  border-top: 1px solid #e8eaed;
  margin: 2rem 0;
}

/* ===== 列表 ===== */
ul, ol { padding-left: 1.5rem; margin: 0.5rem 0; }
li { margin: 0.3rem 0; }

/* ===== 图片 ===== */
img {
  max-width: 100%;
  height: auto;
  border-radius: 0.5rem;
  box-shadow: 0 0.125rem 0.75rem rgba(0,0,0,0.10);
  margin: 0.75rem 0;
  display: block;
}

/* ===== 文本 ===== */
strong { color: #1a1a1a; }
p { margin: 0.6rem 0; }
a { color: #1a73e8; text-decoration: none; }
a:hover { text-decoration: underline; }

/* ===== 页脚 ===== */
.footer {
  margin-top: 3rem;
  padding-top: 1.25rem;
  border-top: 1px solid #e8eaed;
  text-align: center;
  color: #aaa;
  font-size: 0.75rem;
}

/* ===== 响应式：小屏进一步优化 ===== */
@media screen and (max-width: 600px) {
  .container {
    width: 96%;
    padding: 1.5rem 1rem 2rem;
  }
  .cover { padding: 3rem 0 2rem; }
  .cover h1 { font-size: 1.3rem; }
}
"""


def markdown_to_html(md_content):
    """自定义 markdown 转 HTML，处理表格对齐符号"""
    md = markdown.Markdown(extensions=["tables", "fenced_code"])
    html = md.convert(md_content)

    # 美化：清理 table 中 ":----:" 对齐符号可能产生的问题
    # codehilite 扩展需要额外安装，改用我们自己的 pre code
    return html


for filename, doc_title in docs:
    filepath = os.path.join(BASE, filename)
    if not os.path.exists(filepath):
        print(f"⚠ 跳过不存在的文件: {filepath}")
        continue

    with open(filepath, "r", encoding="utf-8") as f:
        md_content = f.read()

    html_body = markdown_to_html(md_content)

    full_html = f"""<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>{doc_title}</title>
<style>{CSS}</style>
</head>
<body>
<div class="container">

<div class="cover">
  <div class="logo">⬡</div>
  <div class="divider"></div>
  <h1>现实世界资产代币化系统（RWA）</h1>
  <div class="subtitle">Real World Asset Tokenization System</div>
  <div class="meta">
    作者：牛晨勋 &nbsp;|&nbsp; 学号：8208231403 &nbsp;|&nbsp; 班级：大数据 2304<br>
    课程：区块链与 Web3 综合实践项目设计 &nbsp;|&nbsp; 项目类型：项目四<br>
    完成日期：2026-06-30 &nbsp;|&nbsp; 版本：V3.0
  </div>
</div>

{html_body}

<div class="footer">
  © 2026 现实世界资产代币化系统（RWA）— {doc_title.split('—')[0].strip()}
</div>

</div>
</body>
</html>"""

    output_name = filename.replace(".md", ".html")
    output_path = os.path.join(BASE, output_name)
    with open(output_path, "w", encoding="utf-8") as f:
        f.write(full_html)

    size_kb = os.path.getsize(output_path) / 1024
    print(f"✅ {output_name}  ({size_kb:.1f} KB)")

print("\n🎉 三个 HTML 文件已生成完毕！")
