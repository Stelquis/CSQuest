use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    /// HTTP 请求失败
    #[error("HTTP error: {0}")]
    HttpError(String),
}
