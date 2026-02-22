# Agentic Coding Tips

Claude Code / Codex CLI / Gemini CLI の設定ファイルとスキルを一元管理するリポジトリ。
新しいマシンにクローンして `setup.sh` を実行するだけで、全コーディングエージェントの設定が完了する。

## 概要

各 AI コーディングエージェント間で相互呼び出しが可能なスキルを提供する。

```
Claude Code <---> Codex CLI <---> Gemini CLI
     ^                                 ^
     |_________________________________|
```

## ディレクトリ構成

```
agentic-coding-tips/
├── setup.sh                           # 一括セットアップスクリプト
│
├── claude/
│   ├── CLAUDE.md                      # Claude Code グローバル指示
│   └── skills/
│       ├── codex/SKILL.md             # Claude → Codex 呼び出し
│       ├── gemini/SKILL.md            # Claude → Gemini 呼び出し
│       └── claude-from-codex/SKILL.md # Codex結果 → Claude で再分析
│
├── codex/
│   ├── instructions.md                # Codex CLI グローバル指示
│   └── skills/
│       ├── claude/SKILL.md            # Codex → Claude 呼び出し
│       └── gemini/SKILL.md            # Codex → Gemini 呼び出し
│
└── gemini/
    ├── GEMINI.md                      # Gemini CLI グローバル指示
    └── skills/
        ├── codex/SKILL.md             # Gemini → Codex 呼び出し
        └── claude/SKILL.md            # Gemini → Claude 呼び出し
```

## セットアップ

### 前提条件

以下のいずれか（または全て）がインストール済みであること:

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) (`claude`)
- [Codex CLI](https://github.com/openai/codex) (`codex`)
- [Gemini CLI](https://github.com/google-gemini/gemini-cli) (`gemini`)

### インストール

```bash
# リポジトリをクローン
git clone git@github.com:yuzuhara/agentic-coding-tips.git
cd agentic-coding-tips

# 全ツールの設定を一括インストール
./setup.sh

# 個別にインストールすることも可能
./setup.sh claude
./setup.sh codex
./setup.sh gemini
```

### setup.sh の動作

- 設定ファイルとスキルを **シンボリックリンク** で各ツールのホームディレクトリに配置
- 既存ファイルは `.backup.<timestamp>` としてバックアップ
- リポジトリ内のファイルを編集すれば即座に反映される

### 展開先

| ソース | 展開先 |
|--------|--------|
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/skills/*` | `~/.claude/skills/*` |
| `codex/instructions.md` | `~/.codex/instructions.md` |
| `codex/skills/*` | `~/.codex/skills/*` |
| `gemini/GEMINI.md` | `~/.gemini/GEMINI.md` |
| `gemini/skills/*` | `gemini skills link` で登録 |

## スキル一覧

### Claude Code 用スキル

| スキル名 | トリガー | 機能 |
|---------|---------|------|
| `codex` | 「codex」「セカンドオピニオン」 | Codex CLI でコード分析 |
| `gemini` | 「gemini」「Googleに聞いて」 | Gemini CLI でコード分析 |
| `claude-from-codex` | 「claudeに聞いて」「クロスチェック」 | Codex結果をClaude で再分析 |

### Codex CLI 用スキル

| スキル名 | トリガー | 機能 |
|---------|---------|------|
| `claude` | 「claude」「Claudeの意見」 | Claude CLI でコード分析 |
| `gemini` | 「gemini」「Geminiに聞いて」 | Gemini CLI でコード分析 |

### Gemini CLI 用スキル

| スキル名 | トリガー | 機能 |
|---------|---------|------|
| `codex` | 「codex」「OpenAIに聞いて」 | Codex CLI でコード分析 |
| `claude` | 「claude」「Claudeの意見」 | Claude CLI でコード分析 |

## 使い方の例

### Claude Code から Codex にセカンドオピニオンを求める

```
> このコードについてcodexにレビューしてもらって
```

### Codex から Claude にクロスチェック

```
> claudeにもこの設計を確認してもらって
```

### Gemini から両方に意見を求める

```
> codexとclaudeにもこのバグについて調べてもらって
```

## カスタマイズ

- `claude/CLAUDE.md` / `codex/instructions.md` / `gemini/GEMINI.md` を編集してグローバル指示を変更
- `*/skills/` にスキルディレクトリを追加して新しいスキルを作成
- シンボリックリンクのため、リポジトリ内の変更が即座に反映される

## License

MIT
