# ===================================================================
# Dockerfile
# ===================================================================

# -----------------------------------------------------------------------------
# 基础镜像与环境变量
# -----------------------------------------------------------------------------

# Ubuntu 24.04 LTS，内置 Python 3.12
FROM ubuntu:24.04

# 禁用交互式提示，避免安装时卡住
ENV DEBIAN_FRONTEND=noninteractive

# 腾讯云镜像源加速 apt 下载
RUN . /etc/os-release 2>/dev/null || VERSION_CODENAME="noble" && \
    echo "deb https://mirrors.tencent.com/ubuntu/ ${VERSION_CODENAME} main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb https://mirrors.tencent.com/ubuntu/ ${VERSION_CODENAME}-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tencent.com/ubuntu/ ${VERSION_CODENAME}-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tencent.com/ubuntu/ ${VERSION_CODENAME}-security main restricted universe multiverse" >> /etc/apt/sources.list

# -----------------------------------------------------------------------------
# 系统工具安装
# -----------------------------------------------------------------------------

# 基础开发工具（合并安装减少镜像层数，--no-install-recommends 精简依赖）
#   git / curl / wget / procps:     版本控制、下载、进程管理
#   apt-transport-https / ca-certificates / gpg:  HTTPS 源与证书支持
#   openjdk-21-jdk:                 Java 21 开发工具包
#   g++ / gcc:                      C/C++ 编译器，默认 13.2.0
#   python-is-python3 / python3.12-venv:  python 指向 python3 + 虚拟环境
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        procps \
        apt-transport-https \
        ca-certificates \
        gpg \
        openjdk-21-jdk \
        g++ \
        gcc \
        python-is-python3 \
        python3.12-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && gcc --version && g++ --version && java -version 2>&1 | head -1

# -----------------------------------------------------------------------------
# UV 包管理器与 Python 库
# -----------------------------------------------------------------------------

# UV - 极速 Python 包管理器（比 pip 快 10-100 倍）
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 添加 UV 到 PATH
ENV PATH="/root/.local/bin:$PATH"

# 虚拟环境 + uv 安装
#   numpy==1.26.4   数组/矩阵运算
#   pandas==2.2.2   表格/CSV 处理
# 两者强绑定，不可升级到 numpy 2.x，否则 pandas 崩溃
RUN python3 -m venv /opt/venv && \
    VIRTUAL_ENV=/opt/venv uv pip install --upgrade pip && \
    VIRTUAL_ENV=/opt/venv uv pip install \
        numpy==1.26.4 \
        pandas==2.2.2
ENV PATH="/opt/venv/bin:$PATH"

# -----------------------------------------------------------------------------
# Node.js 安装
# -----------------------------------------------------------------------------

# Node.js 22.x（Claude Code 扩展、汉化包打包、Blockchain 的 Hardhat）
RUN curl -fsSL https://deb.nodesource.com/setup_22.x -o /tmp/nodesource_setup.sh && \
    bash /tmp/nodesource_setup.sh && \
    rm /tmp/nodesource_setup.sh && \
    apt-get update && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    node --version && \
    npm --version

# -----------------------------------------------------------------------------
# D2 图表渲染引擎
# -----------------------------------------------------------------------------

# D2 v0.9.0 - 直接下载官方 release 静态二进制并软链（无需 make / 无依赖）
RUN curl -fsSL -o /tmp/d2.tar.gz \
        https://github.com/Terrastruct/d2/releases/download/v0.9.0/d2-v0.9.0-linux-amd64.tar.gz && \
    tar -xzf /tmp/d2.tar.gz -C /tmp && \
    mv /tmp/d2-v0.9.0/bin/d2 /usr/local/bin/d2 && \
    rm -rf /tmp/d2.tar.gz /tmp/d2-v0.9.0 && \
    d2 --version

# -----------------------------------------------------------------------------
# code-server 与 VS Code 扩展
# -----------------------------------------------------------------------------

# code-server - 浏览器版 VS Code
RUN curl -fsSL https://code-server.dev/install.sh | sh

# VS Code 扩展
#   ms-python.python              Python（智能提示、调试、Linter）
#   vscjava.vscode-java-pack      Java（调试、Maven、IntelliSense）
#   jeff-hykin.better-cpp-syntax  C++ 语法高亮
#   llvm-vs-code-extensions.vscode-clangd  C++ 语言服务器
#   cweijan.vscode-office         Office 预览（Word / Excel / PDF）
#   yss-tazawa.plantuml-markdown-preview  Markdown 预览内嵌渲染 Mermaid/D2 图表 + HTML/PDF 导出
#   oderwat.indent-rainbow        缩进彩虹
#   mechatroner.rainbow-csv       CSV 彩色高亮
#   anthropic.claude-code         Claude Code 助手
#   tencent-cloud.coding-copilot  腾讯 AI 辅助编程
#   openai.chatgpt                ChatGPT 助手
#   cnbcool.cnb-welcome           CNB 平台欢迎页
RUN code-server --install-extension ms-python.python && \
    code-server --install-extension vscjava.vscode-java-pack && \
    code-server --install-extension jeff-hykin.better-cpp-syntax && \
    code-server --install-extension llvm-vs-code-extensions.vscode-clangd && \
    code-server --install-extension cweijan.vscode-office && \
    code-server --install-extension yss-tazawa.plantuml-markdown-preview && \
    code-server --install-extension oderwat.indent-rainbow && \
    code-server --install-extension mechatroner.rainbow-csv && \
    code-server --install-extension anthropic.claude-code && \
    code-server --install-extension tencent-cloud.coding-copilot && \
    code-server --install-extension openai.chatgpt && \
    code-server --install-extension cnbcool.cnb-welcome

# -----------------------------------------------------------------------------
# AI 扩展汉化
# -----------------------------------------------------------------------------

# Claude Code 汉化包（非官方，为官方扩展打中文补丁）
# --allow-star-activation 跳过交互确认
RUN git clone --depth 1 https://github.com/zstings/claude-code-zh-cn.git /tmp/claude-code-zh-cn && \
    cd /tmp/claude-code-zh-cn && \
    npm install && \
    npx vsce package --no-dependencies --allow-star-activation && \
    code-server --install-extension ./claude-code-zhcn-*.vsix && \
    rm -rf /tmp/claude-code-zh-cn

# -----------------------------------------------------------------------------
# 环境变量与系统配置
# -----------------------------------------------------------------------------

ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

# UTF-8 字符集，支持中文显示和输入
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8

# -----------------------------------------------------------------------------
# 配置与启动设置
# -----------------------------------------------------------------------------

# 预配置编辑器主题、字体、格式化规则（code-server 机器级设置目录）
ARG SKIP_SETTINGS_COPY=false
COPY .vscode/setting.jsonc /root/.local/share/code-server/Machine/settings.json

# 工作目录与 CNB 挂载点一致
WORKDIR /workspace

# 实际启动命令由 .cnb.yml 覆盖为 code-server
CMD ["/bin/bash"]