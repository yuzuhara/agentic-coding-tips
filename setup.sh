#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# agentic-coding-tips セットアップスクリプト
#
# Claude Code / Codex CLI / Gemini CLI の設定ファイルとスキルを
# 一括でインストールする。
# ============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# 色付き出力
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

info()  { echo -e "${BLUE}[INFO]${NC} $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $*"; }
ok()    { echo -e "${GREEN}[OK]${NC} $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; }

# ------------------------------------------------------------
# ヘルパー: シンボリックリンクを作成（既存ファイルはバックアップ）
# ------------------------------------------------------------
link_file() {
    local src="$1"
    local dst="$2"

    if [ ! -e "$src" ]; then
        warn "ソースが見つかりません: $src"
        return 1
    fi

    # 既にリンク済みの場合はスキップ
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        ok "既にリンク済み: $dst"
        return 0
    fi

    # 既存ファイルをバックアップ
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
        warn "既存ファイルをバックアップ: $dst -> $backup"
        mv "$dst" "$backup"
    fi

    # 親ディレクトリを作成
    mkdir -p "$(dirname "$dst")"

    ln -s "$src" "$dst"
    ok "リンク作成: $dst -> $src"
}

# ------------------------------------------------------------
# ヘルパー: ディレクトリをシンボリックリンク
# ------------------------------------------------------------
link_dir() {
    local src="$1"
    local dst="$2"

    if [ ! -d "$src" ]; then
        warn "ソースディレクトリが見つかりません: $src"
        return 1
    fi

    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        ok "既にリンク済み: $dst"
        return 0
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        local backup="${dst}.backup.$(date +%Y%m%d%H%M%S)"
        warn "既存をバックアップ: $dst -> $backup"
        mv "$dst" "$backup"
    fi

    mkdir -p "$(dirname "$dst")"

    ln -s "$src" "$dst"
    ok "リンク作成: $dst -> $src"
}

# ============================================================
# Claude Code セットアップ
# ============================================================
setup_claude() {
    info "=== Claude Code セットアップ ==="

    local claude_dir="$HOME/.claude"
    mkdir -p "$claude_dir"

    # CLAUDE.md
    link_file "$SCRIPT_DIR/claude/CLAUDE.md" "$claude_dir/CLAUDE.md"

    # Skills
    for skill_dir in "$SCRIPT_DIR"/claude/skills/*/; do
        if [ -d "$skill_dir" ]; then
            local skill_name
            skill_name="$(basename "$skill_dir")"
            link_dir "$skill_dir" "$claude_dir/skills/$skill_name"
        fi
    done

    ok "Claude Code セットアップ完了"
    echo ""
}

# ============================================================
# Codex CLI セットアップ
# ============================================================
setup_codex() {
    info "=== Codex CLI セットアップ ==="

    local codex_dir="$HOME/.codex"
    mkdir -p "$codex_dir"

    # instructions.md
    link_file "$SCRIPT_DIR/codex/instructions.md" "$codex_dir/instructions.md"

    # Skills
    for skill_dir in "$SCRIPT_DIR"/codex/skills/*/; do
        if [ -d "$skill_dir" ]; then
            local skill_name
            skill_name="$(basename "$skill_dir")"
            mkdir -p "$codex_dir/skills"
            link_dir "$skill_dir" "$codex_dir/skills/$skill_name"
        fi
    done

    ok "Codex CLI セットアップ完了"
    echo ""
}

# ============================================================
# Gemini CLI セットアップ
# ============================================================
setup_gemini() {
    info "=== Gemini CLI セットアップ ==="

    local gemini_dir="$HOME/.gemini"
    mkdir -p "$gemini_dir"

    # GEMINI.md
    link_file "$SCRIPT_DIR/gemini/GEMINI.md" "$gemini_dir/GEMINI.md"

    # Skills（gemini skills install を使用）
    if command -v gemini &> /dev/null; then
        for skill_dir in "$SCRIPT_DIR"/gemini/skills/*/; do
            if [ -d "$skill_dir" ]; then
                local skill_name
                skill_name="$(basename "$skill_dir")"
                info "Gemini スキルをリンク: $skill_name"
                gemini skills link "$skill_dir" 2>/dev/null || warn "Gemini スキル '$skill_name' のリンクに失敗（手動で gemini skills install を実行してください）"
            fi
        done
    else
        warn "Gemini CLI が見つかりません。スキルのインストールをスキップします。"
        warn "Gemini CLI インストール後に以下を実行してください:"
        for skill_dir in "$SCRIPT_DIR"/gemini/skills/*/; do
            if [ -d "$skill_dir" ]; then
                warn "  gemini skills link $skill_dir"
            fi
        done
    fi

    ok "Gemini CLI セットアップ完了"
    echo ""
}

# ============================================================
# メイン
# ============================================================
main() {
    echo ""
    echo "============================================"
    echo "  Agentic Coding Tips - セットアップ"
    echo "============================================"
    echo ""
    info "リポジトリ: $SCRIPT_DIR"
    echo ""

    # 引数なしの場合は全ツールをセットアップ
    if [ $# -eq 0 ]; then
        setup_claude
        setup_codex
        setup_gemini
    else
        # 個別指定も可能
        for tool in "$@"; do
            case "$tool" in
                claude)  setup_claude ;;
                codex)   setup_codex ;;
                gemini)  setup_gemini ;;
                *)       error "不明なツール: $tool (claude, codex, gemini のいずれかを指定)" ;;
            esac
        done
    fi

    echo "============================================"
    ok "セットアップ完了!"
    echo ""
    info "検証コマンド:"
    echo "  Claude:  新しいセッションを開始してスキル一覧を確認"
    echo "  Codex:   codex (スキルが自動認識される)"
    echo "  Gemini:  gemini skills list"
    echo ""
}

main "$@"
