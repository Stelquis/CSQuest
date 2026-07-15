use regex::Regex;
use scraper::{ElementRef, Html, Node, Selector};
use serde::{Deserialize, Serialize};
use std::sync::OnceLock;

/// 解析后的文章数据
#[derive(Debug, Serialize, Deserialize, Clone)]
pub struct ArticleData {
    pub title: String,
    pub author: String,
    pub publish_time: String,
    /// 纯文本正文（向后兼容）
    pub content: String,
    /// Markdown 格式正文（保留标题/列表/引用/图片等结构）
    pub content_markdown: String,
    /// 正文中的图片 URL 列表
    pub images: Vec<String>,
}

// ── 预编译选择器（主 + 备用，适应不同页面版本）──

fn title_selectors() -> &'static Vec<Selector> {
    static SEL: OnceLock<Vec<Selector>> = OnceLock::new();
    SEL.get_or_init(|| {
        vec![
            Selector::parse("h1#activity-name").unwrap(),
            Selector::parse("h1.rich_media_title").unwrap(),
        ]
    })
}

fn author_selectors() -> &'static Vec<Selector> {
    static SEL: OnceLock<Vec<Selector>> = OnceLock::new();
    SEL.get_or_init(|| {
        vec![
            Selector::parse("span#js_author_name").unwrap(),
            Selector::parse("span.rich_media_meta_nickname").unwrap(),
            Selector::parse("a#js_name").unwrap(),
        ]
    })
}

fn publish_time_selectors() -> &'static Vec<Selector> {
    static SEL: OnceLock<Vec<Selector>> = OnceLock::new();
    SEL.get_or_init(|| {
        vec![
            Selector::parse("em#publish_time").unwrap(),
            Selector::parse("em.rich_media_meta_text").unwrap(),
        ]
    })
}

fn content_selectors() -> &'static Vec<Selector> {
    static SEL: OnceLock<Vec<Selector>> = OnceLock::new();
    SEL.get_or_init(|| {
        vec![
            Selector::parse("div#js_content").unwrap(),
            Selector::parse("div.rich_media_content").unwrap(),
        ]
    })
}

// ── 预编译正则 ──

fn newlines_regex() -> &'static Regex {
    static RE: OnceLock<Regex> = OnceLock::new();
    RE.get_or_init(|| Regex::new(r"\n{3,}").unwrap())
}

fn spaces_regex() -> &'static Regex {
    static RE: OnceLock<Regex> = OnceLock::new();
    RE.get_or_init(|| Regex::new(r" {2,}").unwrap())
}

/// 微信文章 HTML 解析器
///
/// 将 JS 渲染后的 HTML 转换为结构化数据，支持：
/// - 多选择器兜底提取标题/作者/时间
/// - HTML → Markdown 格式转换（保留标题、列表、引用、图片等）
/// - 图片 URL 自动提取
pub struct WeixinParser;

impl WeixinParser {
    pub fn new() -> Self {
        Self
    }

    /// 解析微信文章 HTML，提取全部结构化数据
    pub fn parse(&self, html: &str) -> ArticleData {
        let document = Html::parse_document(html);

        let author = self.extract_text(&document, author_selectors(), "未知作者");
        let publish_time = self.extract_text(&document, publish_time_selectors(), "");
        let images = self.extract_images(&document);
        let content = self.extract_content_plain(&document);
        let content_markdown = self.content_to_markdown(&document);

        // 标题提取：多优先级
        let title = {
            // 1) 标准选择器
            let t = self.extract_text(&document, title_selectors(), "");
            if !t.is_empty() {
                t
            // 2) og:title meta
            } else if let Some(mt) = self.extract_meta_content(&document, "og:title") {
                mt
            // 3) 其他 meta 兜底
            } else if let Some(mt) = self.extract_meta_content(&document, "twitter:title") {
                mt
            } else {
                String::new()
            }
        };

        // 如果内容 Markdown 的第一个 # 标题比提取的标题更长（更完整），取内容标题
        let title = if let Some(h) = self.extract_first_heading(&content_markdown) {
            if h.len() > title.len() {
                h
            } else {
                title
            }
        } else {
            title
        };

        let title = if title.is_empty() {
            "未找到标题".to_string()
        } else {
            title
        };

        // 发布时间兜底：尝试 meta 标签
        let publish_time = if !publish_time.is_empty() {
            publish_time
        } else if let Some(t) = self.extract_meta_content(&document, "article:published_time")
            .or_else(|| self.extract_meta_content(&document, "og:updated_time"))
        {
            t
        } else {
            "未知时间".to_string()
        };

        ArticleData {
            title,
            author,
            publish_time,
            content,
            content_markdown,
            images,
        }
    }

    // ── 通用提取 ──

    /// 通用文本提取：按选择器列表逐个尝试，取第一个非空结果
    fn extract_text(&self, doc: &Html, selectors: &[Selector], fallback: &str) -> String {
        for sel in selectors {
            if let Some(el) = doc.select(sel).next() {
                let text = el.text().collect::<Vec<_>>().join("").trim().to_string();
                if !text.is_empty() {
                    return text;
                }
            }
        }
        fallback.to_string()
    }

    /// 从 meta[property] 标签提取 content 属性值
    fn extract_meta_content(&self, doc: &Html, property: &str) -> Option<String> {
        // 动态构建选择器 (property 不含引号，安全)
        let selector_str = format!("meta[property='{}']", property);
        let sel = Selector::parse(&selector_str).ok()?;
        let el = doc.select(&sel).next()?;
        elem_attr(el.value(), "content")
    }

    /// 从 Markdown 内容中提取第一个 # 标题
    fn extract_first_heading(&self, markdown: &str) -> Option<String> {
        let line = markdown.lines().find(|l| l.starts_with("# "))?;
        let heading = line.trim_start_matches("# ").trim().to_string();
        if heading.is_empty() { None } else { Some(heading) }
    }

    /// 提取正文纯文本（向后兼容）
    fn extract_content_plain(&self, doc: &Html) -> String {
        for sel in content_selectors() {
            if let Some(content_el) = doc.select(sel).next() {
                let inner_html = content_el.inner_html();
                let fragment = Html::parse_fragment(&inner_html);
                let text: String = fragment
                    .root_element()
                    .text()
                    .collect::<Vec<_>>()
                    .join("\n");
                let cleaned = self.clean_text(&text);
                if !cleaned.is_empty() {
                    return cleaned;
                }
            }
        }
        "未找到正文内容".to_string()
    }

    /// 提取正文中所有图片的真实 URL
    fn extract_images(&self, doc: &Html) -> Vec<String> {
        let img_selector = Selector::parse("img").unwrap();
        let mut images = Vec::new();
        for el in doc.select(&img_selector) {
            // 微信使用懒加载：真实 URL 在 data-src，src 可能是 base64 占位
            let src = elem_attr(el.value(), "data-src")
                .or_else(|| elem_attr(el.value(), "src"))
                .filter(|s| !s.starts_with("data:"));
            if let Some(url) = src {
                images.push(url);
            }
        }
        images
    }

    // ── Markdown 转换 ──

    /// 将正文 HTML 转换为 Markdown
    fn content_to_markdown(&self, doc: &Html) -> String {
        for sel in content_selectors() {
            if let Some(content_el) = doc.select(sel).next() {
                let inner_html = content_el.inner_html();
                let fragment = Html::parse_fragment(&inner_html);
                let result = self.element_to_markdown(fragment.root_element());
                let cleaned = self.clean_text(&result);
                if !cleaned.is_empty() {
                    return cleaned;
                }
            }
        }
        String::new()
    }

    /// 递归转换 ElementRef 及其子节点为 Markdown
    fn element_to_markdown(&self, elem: ElementRef) -> String {
        let mut parts = Vec::new();
        for child in elem.children() {
            match child.value() {
                Node::Text(t) => {
                    let text = t.text.trim();
                    if !text.is_empty() {
                        parts.push(text.to_string());
                    }
                }
                Node::Element(_) => {
                    if let Some(child_elem) = ElementRef::wrap(child) {
                        self.push_element_markdown(child_elem, &mut parts);
                    }
                }
                _ => {}
            }
        }
        parts.concat()
    }

    /// 将单个 Element 按标签类型转换为 Markdown，追加到 parts
    fn push_element_markdown(&self, elem: ElementRef, parts: &mut Vec<String>) {
        let el = elem.value();
        let tag = &*el.name.local;
        match tag {
            // ── 块级元素 ──
            "p" | "section" | "div" => {
                let inner = self.element_to_markdown(elem);
                let trimmed = inner.trim();
                if !trimmed.is_empty() {
                    parts.push(trimmed.to_string());
                    parts.push("\n\n".to_string());
                }
            }

            // ── 标题 ──
            "h1" | "h2" | "h3" | "h4" | "h5" | "h6" => {
                let level = tag[1..].parse::<usize>().unwrap_or(1);
                let inner = self.element_to_markdown(elem);
                let trimmed = inner.trim();
                if !trimmed.is_empty() {
                    parts.push(format!("{} {}", "#".repeat(level), trimmed));
                    parts.push("\n\n".to_string());
                }
            }

            // ── 图片 ──
            "img" => {
                let src = elem_attr(el, "data-src")
                    .or_else(|| elem_attr(el, "src"))
                    .filter(|s| !s.starts_with("data:"));
                if let Some(url) = src {
                    let alt = elem_attr(el, "alt").unwrap_or_default();
                    parts.push(format!("![{}]({})", alt, url));
                    parts.push("\n\n".to_string());
                }
            }

            // ── 换行 ──
            "br" => {
                parts.push("\n".to_string());
            }

            // ── 粗体 ──
            "strong" | "b" => {
                let inner = self.element_to_markdown(elem);
                let trimmed = inner.trim();
                if !trimmed.is_empty() {
                    parts.push(format!("**{}**", trimmed));
                }
            }

            // ── 斜体 ──
            "em" | "i" => {
                let inner = self.element_to_markdown(elem);
                let trimmed = inner.trim();
                if !trimmed.is_empty() {
                    parts.push(format!("*{}*", trimmed));
                }
            }

            // ── 链接 ──
            "a" => {
                let href = elem_attr(el, "href").unwrap_or_default();
                let inner = self.element_to_markdown(elem);
                let trimmed = inner.trim().to_string();
                if !trimmed.is_empty() && !href.is_empty() {
                    parts.push(format!("[{}]({})", trimmed, href));
                } else if !trimmed.is_empty() {
                    parts.push(trimmed);
                }
            }

            // ── 行内代码 ──
            "code" => {
                let inner = self.element_to_markdown(elem);
                let trimmed = inner.trim();
                if !trimmed.is_empty() {
                    parts.push(format!("`{}`", trimmed));
                }
            }

            // ── 代码块 ──
            "pre" => {
                let inner = self.element_to_markdown(elem);
                let trimmed = inner.trim();
                if !trimmed.is_empty() {
                    parts.push(format!("\n```\n{}\n```\n", trimmed));
                }
            }

            // ── 引用 ──
            "blockquote" => {
                let inner = self.element_to_markdown(elem);
                let trimmed = inner.trim();
                if !trimmed.is_empty() {
                    let quoted: Vec<String> =
                        trimmed.lines().map(|l| format!("> {}", l)).collect();
                    parts.push(quoted.join("\n"));
                    parts.push("\n\n".to_string());
                }
            }

            // ── 列表 ──
            "ul" | "ol" => {
                self.process_list(elem, tag == "ol", parts);
            }

            // ── 水平线 ──
            "hr" => {
                parts.push("\n---\n\n".to_string());
            }

            // ── 其他标签：透传子元素 ──
            _ => {
                let inner = self.element_to_markdown(elem);
                let trimmed = inner.trim();
                if !trimmed.is_empty() {
                    parts.push(trimmed.to_string());
                }
            }
        }
    }

    /// 处理列表（ul/ol）
    fn process_list(&self, elem: ElementRef, ordered: bool, parts: &mut Vec<String>) {
        for (idx, child) in elem.children().enumerate() {
            if let Some(li) = ElementRef::wrap(child) {
                if li.value().name.local.as_ref() == "li" {
                    let inner = self.element_to_markdown(li);
                    let trimmed = inner.trim();
                    if !trimmed.is_empty() {
                        if ordered {
                            parts.push(format!("{}. {}", idx + 1, trimmed));
                        } else {
                            parts.push(format!("- {}", trimmed));
                        }
                        parts.push("\n".to_string());
                    }
                }
            }
        }
        parts.push("\n".to_string());
    }

    // ── 文本清理 ──

    /// 合并多余换行和空格
    fn clean_text(&self, text: &str) -> String {
        let text = newlines_regex().replace_all(text, "\n\n");
        let text = spaces_regex().replace_all(&text, " ");
        text.trim().to_string()
    }
}

// ── 工具函数 ──

/// 从 scraper::node::Element 中按属性名取值
fn elem_attr(el: &scraper::node::Element, name: &str) -> Option<String> {
    el.attrs
        .iter()
        .find(|(n, _)| &*n.local == name)
        .map(|(_, v)| v.to_string())
}
