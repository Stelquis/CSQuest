# ===================================================================
# 408 复习系统 — 一键配置脚本
# ===================================================================
# 功能: 安装 6 个 community skill + 知识图谱 MCP + Foam 知识管理
#   - 注册 AtomCode 官方插件市场
#   - 安装 excalidraw / memento-flashcards / baoyu-infographic
#   - 安装 book-study / quiz-maker / mermaid-diagrams
#   - 安装 knowledgeGraph MCP（Qwen3 中文知识图谱）
#   - 安装 Foam VS Code 扩展（双链笔记 + 知识图谱可视化）
#   - 创建 /review408 命令入口和 408-loop Rule
#   - 验证安装完整性
#
# 一键运行:
#   bash /workspace/scripts/setup-408.sh
# ===================================================================

set -e

info()  { echo "  $1"; }
ok()    { echo "  ✓ $1"; }
err()   { echo "  ✗ $1" >&2; }

# -----------------------------------------------------------------------------
# 前置检查
# -----------------------------------------------------------------------------

if ! command -v atomcode &>/dev/null; then err "atomcode 未安装"; exit 1; fi
if ! command -v git &>/dev/null; then err "git 未安装"; exit 1; fi

PROJECT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

# -----------------------------------------------------------------------------
# 注册插件市场
# -----------------------------------------------------------------------------

if ! atomcode plugin marketplace list 2>/dev/null | grep -q "atomcode-plugins-official"; then
    atomcode plugin marketplace add https://atomgit.com/atomgit_atomcode/atomcode-plugins-official.git
fi
if ! atomcode plugin marketplace list 2>/dev/null | grep -q "superpowers-marketplace"; then
    atomcode plugin marketplace add https://github.com/obra/superpowers-marketplace.git 2>/dev/null || true
fi

# -----------------------------------------------------------------------------
# 从市场安装 skill
# -----------------------------------------------------------------------------

for pair in "excalidraw:概念结构图" "memento-flashcards:间隔重复闪卡" "baoyu-infographic:信息图生成"; do
    name="${pair%%:*}"
    if ! atomcode plugin list 2>/dev/null | grep -q "^  ${name}@"; then
        atomcode plugin install "${name}@atomcode-plugins-official"
        ok "$name"
    fi
done

# -----------------------------------------------------------------------------
# 从 GitHub 社区安装 skill
# -----------------------------------------------------------------------------

install_github_skill() {
    local name="$1" repo_url="$2" skill_path="$3"
    if atomcode plugin list 2>/dev/null | grep -q "^  ${name}@"; then return 0; fi

    local tmpdir="/tmp/408-install-${name}"
    rm -rf "$tmpdir"
    git clone --depth=1 "$repo_url" "$tmpdir" 2>/dev/null || { err "克隆 $name 失败"; return 1; }

    local src="$tmpdir/$skill_path"
    if [ ! -f "$src/SKILL.md" ]; then rm -rf "$tmpdir"; err "$name 缺少 SKILL.md"; return 1; fi

    local dest="$HOME/.atomcode/plugins/installed/atomcode-plugins-official/${name}/skills/${name}"
    mkdir -p "$dest"
    cp -r "$src"/* "$dest/"

    python3 -c "
import json, os
path = os.path.expanduser('~/.atomcode/plugins/installed_plugins.json')
with open(path) as f: data = json.load(f)
data['plugins']['${name}@atomcode-plugins-official'] = {
    'marketplace': 'atomcode-plugins-official', 'plugin': '${name}',
    'plugin_dir': 'installed/atomcode-plugins-official/${name}/skills/${name}',
    'installed_at': '$(date -Iseconds)', 'scope': 'user'}
with open(path, 'w') as f: json.dump(data, f, indent=2)
" 2>/dev/null

    rm -rf "$tmpdir"
    ok "$name"
}

install_github_skill "book-study"       "https://github.com/sanyuan0704/sanyuan-skills.git" "skills/book-study"
install_github_skill "quiz-maker"       "https://github.com/OneWave-AI/claude-skills.git"   "quiz-maker"
install_github_skill "mermaid-diagrams" "https://github.com/softaworks/agent-toolkit.git"  "skills/mermaid-diagrams"

# -----------------------------------------------------------------------------
# 安装 knowledgeGraph MCP 知识图谱
# -----------------------------------------------------------------------------

MCP_DIR="$PROJECT_DIR/.agent/mcp/knowledge-graph"
if [ ! -f "$MCP_DIR/main.js" ]; then
    info "正在安装 knowledgeGraph MCP (Qwen3 中文知识图谱)..."
    mkdir -p "$PROJECT_DIR/mcp"
    git clone --depth=1 https://github.com/ChenLiangChong/knowledgeGraph.git "$MCP_DIR"
    cd "$MCP_DIR" && npm install --silent
    ok "knowledgeGraph MCP 已安装 (首次启动会自动下载 Qwen3 模型 ~560MB)"
else
    # 目录存在但可能缺少 node_modules（如克隆中断或手动清理后）
    if [ ! -d "$MCP_DIR/node_modules" ]; then
        info "补装 knowledgeGraph MCP 依赖..."
        cd "$MCP_DIR" && npm install --silent
    fi
    ok "knowledgeGraph MCP 已存在"
fi

# 注册 MCP 到 .mcp.json
if ! grep -q "knowledge-graph" "$PROJECT_DIR/.mcp.json" 2>/dev/null; then
    atomcode mcp add knowledge-graph node "$MCP_DIR/main.js"
    ok "knowledgeGraph 已注册到 .mcp.json"
else
    ok "knowledgeGraph 已注册"
fi

# -----------------------------------------------------------------------------
# 安装 Foam VS Code 扩展（知识图谱可视化 + 双链笔记）
# -----------------------------------------------------------------------------

if command -v code-server &>/dev/null; then
    if code-server --list-extensions 2>/dev/null | grep -q "foam.foam-vscode"; then
        ok "Foam 已安装"
    else
        code-server --install-extension foam.foam-vscode
        ok "Foam VS Code 扩展已安装"
    fi
else
    info "code-server 未运行，跳过 Foam 安装（可在 VS Code 手动安装 foam.foam-vscode）"
fi

# -----------------------------------------------------------------------------
# 创建配置文件
# -----------------------------------------------------------------------------

mkdir -p "$PROJECT_DIR/.atomcode/commands" "$PROJECT_DIR/.atomcode/rules"

if [ -f "$PROJECT_DIR/.atomcode/commands/review408.md" ] && [ -f "$PROJECT_DIR/.atomcode/rules/408-learning-loop.mdc" ]; then
    ok "配置文件已存在"
else
    err "请先克隆完整仓库，确保 .atomcode/ 目录完整"
    exit 1
fi

# -----------------------------------------------------------------------------
# 验证安装完整性
# -----------------------------------------------------------------------------

errors=0
for skill in "book-study" "excalidraw" "mermaid-diagrams" "quiz-maker" "memento-flashcards" "baoyu-infographic"; do
    if atomcode plugin list 2>/dev/null | grep -q "^  ${skill}@"; then
        dir=$(atomcode plugin list 2>/dev/null | grep "^  ${skill}@" | awk '{print $2}')
        [ -f "$HOME/.atomcode/plugins/$dir/SKILL.md" ] && ok "$skill" || { err "$skill 文件缺失"; errors=$((errors+1)); }
    else
        err "$skill 未安装"
        errors=$((errors+1))
    fi
done

for f in ".atomcode/commands/review408.md" ".atomcode/rules/408-learning-loop.mdc"; do
    [ -f "$PROJECT_DIR/$f" ] && ok "$f" || { err "$f 缺失"; errors=$((errors+1)); }
done

# 验证 knowledgeGraph MCP
if [ -f "$MCP_DIR/main.js" ]; then
    ok "knowledgeGraph MCP"
else
    err "knowledgeGraph MCP 文件缺失"
    errors=$((errors+1))
fi

# 验证 Foam（如果 code-server 在运行）
if command -v code-server &>/dev/null; then
    if code-server --list-extensions 2>/dev/null | grep -q "foam.foam-vscode"; then
        ok "Foam VS Code 扩展"
    else
        err "Foam 未安装"
        errors=$((errors+1))
    fi
fi

[ "$errors" -eq 0 ] && echo "  安装完成" || { err "有 $errors 个错误"; exit 1; }