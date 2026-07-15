# ===================================================================
# Dockerfile
# ===================================================================

# -----------------------------------------------------------------------------
# 第一部分: 基础镜像与环境变量
# -----------------------------------------------------------------------------

# 使用 Ubuntu 24.04 LTS 作为基础镜像
# 选择理由: 长期支持版本(LTS)，稳定性好，软件包丰富
FROM ubuntu:24.04

# 环境变量配置
#   DEBIAN_FRONTEND=noninteractive: 禁用交互式提示，避免安装时卡住
ENV DEBIAN_FRONTEND=noninteractive

# 配置国内镜像源
# 说明: 使用清华大学 TUNA 镜像加速 apt 下载
RUN . /etc/os-release 2>/dev/null || VERSION_CODENAME="noble" && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${VERSION_CODENAME} main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${VERSION_CODENAME}-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${VERSION_CODENAME}-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ ${VERSION_CODENAME}-security main restricted universe multiverse" >> /etc/apt/sources.list

# -----------------------------------------------------------------------------
# 第二部分: 系统工具安装
# -----------------------------------------------------------------------------

# 安装基础开发工具
# 说明: 合并安装减少镜像层数，--no-install-recommends 避免安装不必要的包
#
# 工具说明:
#   git:                        版本控制系统，代码管理必备
#   curl/wget:                  命令行下载工具，用于获取文件和脚本
#   procps:                     进程管理工具(ps, top等)
#   software-properties-common: 软件源管理工具
#   apt-transport-https:        HTTPS 软件源支持
#   ca-certificates/gpg:        HTTPS 证书与 GPG 密钥管理
#   openjdk-21-jdk:             Java 21 开发工具包
#   g++-14:                     C++20 编译器，企业主流选择，支持 C++14/17/20/23
#   gcc-14:                     C 编译器，与 g++-14 配套
#   python-is-python3:          让 python 命令指向 python3（Ubuntu 24.04 内置 python3）
#
# 清理: apt-get clean + rm -rf 删除缓存，减小镜像体积
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        software-properties-common && \
    add-apt-repository -y ppa:ubuntu-toolchain-r/test && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        curl \
        wget \
        procps \
        apt-transport-https \
        ca-certificates \
        gpg \
        openjdk-21-jdk \
        g++-14 \
        gcc-14 \
        python-is-python3 \
        python3.12-venv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && ln -sf /usr/bin/g++-14 /usr/bin/g++ \
    && ln -sf /usr/bin/gcc-14 /usr/bin/gcc

# -----------------------------------------------------------------------------
# 第三部分: UV 包管理器与 Python 库
# -----------------------------------------------------------------------------

# 安装 UV - 极速 Python 包管理器
# 说明: 比 pip 快 10-100 倍，支持并行安装，与系统 Python 3.12 完美兼容
# Ubuntu 24.04 内置 Python 3.12，无需额外安装
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 添加 UV 到 PATH
ENV PATH="/root/.local/bin:$PATH"

# 使用虚拟环境安装华为 Python 机考必备库
# 说明: 创建虚拟环境避免系统Python保护限制，设为默认Python
RUN python3 -m venv /opt/venv && \
    /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install numpy pandas
ENV PATH="/opt/venv/bin:$PATH"

# -----------------------------------------------------------------------------
# 第三点五部分: Node.js 安装
# -----------------------------------------------------------------------------

# 安装 Node.js 22.x (Claude Code CLI 运行依赖)
# 说明: 使用 NodeSource 官方源安装，确保版本 >= 22
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
# 第四部分: code-server 与 VS Code 扩展
# -----------------------------------------------------------------------------

# 安装 code-server - 浏览器版 VS Code
# 说明: 官方 install.sh 自动下载最新版本并安装
RUN curl -fsSL https://code-server.dev/install.sh | sh

# 安装 VS Code 扩展
#
# 扩展列表（按功能分类）:
#   语言支持:
#     ms-python.python              Python 语言支持（智能提示、调试、Linter）
#     vscjava.vscode-java-pack      Java 语言支持包（调试、Maven、IntelliSense）
#     jeff-hykin.better-cpp-syntax  C++ 语法高亮
#     llvm-vs-code-extensions.vscode-clangd  C++ 语言服务器
#   文档预览:
#     cweijan.vscode-office         Office 文档预览（Word / Excel）
#     mathematic.vscode-pdf         PDF 文档预览与阅读
#   编辑器增强:
#     oderwat.indent-rainbow        缩进彩虹，代码层级可视化
#     mechatroner.rainbow-csv       CSV 文件彩色高亮
#   AI 编程助手:
#     anthropic.claude-code         Claude Code AI 编程助手
#     tencent-cloud.coding-copilot  腾讯 AI 辅助编程
#     openai.chatgpt                ChatGPT AI 编程助手
#   CNB 平台扩展:
#     cnbcool.cnb-welcome           CNB 平台欢迎页
RUN code-server --install-extension ms-python.python && \
    code-server --install-extension vscjava.vscode-java-pack && \
    code-server --install-extension jeff-hykin.better-cpp-syntax && \
    code-server --install-extension llvm-vs-code-extensions.vscode-clangd && \
    code-server --install-extension cweijan.vscode-office && \
    code-server --install-extension mathematic.vscode-pdf && \
    code-server --install-extension oderwat.indent-rainbow && \
    code-server --install-extension mechatroner.rainbow-csv && \
    code-server --install-extension anthropic.claude-code && \
    code-server --install-extension tencent-cloud.coding-copilot && \
    code-server --install-extension openai.chatgpt && \
    code-server --install-extension cnbcool.cnb-welcome

# -----------------------------------------------------------------------------
# 第四点五部分: CodeX CLI 配置
# -----------------------------------------------------------------------------

# 说明: 配置文件会在容器启动时通过 init-codex.sh 脚本动态生成

# 创建 CodeX 配置目录
RUN mkdir -p /root/.codex /home/admin/.codex

# 复制 CodeX 初始化脚本
COPY scripts/init-codex.sh /usr/local/bin/init-codex.sh
RUN chmod +x /usr/local/bin/init-codex.sh

# -----------------------------------------------------------------------------
# 第四点六部分: Claude Code CLI 配置 + 汉化包
# -----------------------------------------------------------------------------

# 安装 Claude Code CLI (需要 Node.js 22+)
RUN npm install -g @anthropic-ai/claude-code

# 复制 Claude Code 初始化脚本
COPY scripts/init-claude.sh /usr/local/bin/init-claude.sh
RUN chmod +x /usr/local/bin/init-claude.sh

# 安装 Claude Code 汉化包（非官方社区扩展）
# 说明: 克隆仓库、打包并安装汉化扩展，使用 --allow-star-activation 避免交互确认
RUN git clone --depth 1 https://github.com/zstings/claude-code-zh-cn.git /tmp/claude-code-zh-cn && \
    cd /tmp/claude-code-zh-cn && \
    npm install && \
    npx vsce package --no-dependencies --allow-star-activation && \
    code-server --install-extension ./claude-code-zhcn-*.vsix && \
    rm -rf /tmp/claude-code-zh-cn

# -----------------------------------------------------------------------------
# 第五部分: 环境变量与系统配置
# -----------------------------------------------------------------------------

# Java 环境变量
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64

# 字符集配置
# 说明: 设置 UTF-8 编码，支持中文显示和输入
ENV LANG=C.UTF-8
ENV LANGUAGE=C.UTF-8

# -----------------------------------------------------------------------------
# 第六部分: 配置与启动设置
# -----------------------------------------------------------------------------

# 复制 VS Code 设置文件到容器
# 路径说明: code-server 的机器级设置目录
# 作用: 预配置编辑器主题、字体、格式化规则等
ARG SKIP_SETTINGS_COPY=false
COPY .vscode/setting.jsonc /root/.local/share/code-server/Machine/settings.json

# 设置容器工作目录
# 说明: 容器启动后默认进入 /workspace，与 CNB 平台挂载点一致
WORKDIR /workspace

# 容器默认启动命令
# 说明: 启动 bash shell，实际运行由 .cnb.yml 配置文件控制
#       CNB 平台会覆盖此命令以启动 code-server 服务
CMD ["/bin/bash"]