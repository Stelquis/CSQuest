use reqwest::Client;
use std::time::Duration;

use crate::error::AppError;
use crate::parser::{ArticleData, WeixinParser};

/// HTTP 请求管理器
///
/// 替代原 Headless Chrome 方案，使用纯 HTTP 请求获取文章 HTML。
/// 相比浏览器方案：
/// - ✅ 无环境依赖（不再需要 Chrome/Chromium）
/// - ✅ 启动快（毫秒级）
/// - ✅ 资源少（几十 KB vs 几百 MB）
/// - ✅ 避免被微信反爬检测（浏览器指纹反而更容易被封）
pub struct WeixinScraper {
    parser: WeixinParser,
    client: Client,
}

impl WeixinScraper {
    pub fn new() -> Self {
        let mut default_headers = reqwest::header::HeaderMap::new();
        default_headers.insert(
            reqwest::header::ACCEPT,
            "text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8"
                .parse()
                .unwrap(),
        );
        default_headers.insert(
            reqwest::header::ACCEPT_LANGUAGE,
            "zh-CN,zh;q=0.9,en;q=0.8".parse().unwrap(),
        );
        // Referer 模拟从微信内打开
        default_headers.insert(
            reqwest::header::REFERER,
            "https://mp.weixin.qq.com/".parse().unwrap(),
        );

        let client = Client::builder()
            .timeout(Duration::from_secs(30))
            .user_agent(
                "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 \
                 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            )
            .default_headers(default_headers)
            .build()
            .expect("Failed to build HTTP client");

        Self {
            parser: WeixinParser::new(),
            client,
        }
    }

    /// 获取微信文章内容
    pub async fn fetch_article(&self, url: &str) -> Result<ArticleData, AppError> {
        tracing::info!("Fetching article via HTTP: {}", url);

        let response = self
            .client
            .get(url)
            .send()
            .await
            .map_err(|e| AppError::HttpError(format!("Request failed: {}", e)))?;

        if !response.status().is_success() {
            return Err(AppError::HttpError(format!(
                "HTTP {}: {}",
                response.status().as_u16(),
                response
                    .status()
                    .canonical_reason()
                    .unwrap_or("unknown")
            )));
        }

        let html = response
            .text()
            .await
            .map_err(|e| AppError::HttpError(format!("Read body failed: {}", e)))?;

        tracing::info!("Got HTML ({} bytes), parsing...", html.len());

        Ok(self.parser.parse(&html))
    }
}
