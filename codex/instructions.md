日本語で応答してください。また、ドキュメントも基本的には日本語で記述するようにしてください。
指示があるまでコーディングを行わないでください。

## Workflow Orchestration

### 1. Plan First
- 非自明なタスク（3ステップ以上やアーキテクチャ判断が必要）は最初に計画を立てる
- 問題が発生したら即座に計画を見直す — 闇雲に進めない
- 詳細な仕様を先に書いて曖昧さを減らす

### 2. Self-Improvement Loop
- ユーザーから指摘を受けたら: `tasks/lessons.md` にパターンを記録する
- 同じミスを防ぐルールを自分で作成する
- セッション開始時に関連するプロジェクトのレッスンを見直す

### 3. Verification Before Done
- タスク完了前に動作を証明する
- テストを実行し、ログを確認し、正しさを実証する
- 「シニアエンジニアがこれを承認するか？」と自問する

### 4. Autonomous Bug Fixing
- バグ報告を受けたら: ログ、エラー、失敗テストを見つけて修正する
- ユーザーに逐一確認せず自律的に解決する

## Task Management

1. **Plan First**: `tasks/todo.md` にチェック可能な項目で計画を書く
2. **Verify Plan**: 実装開始前に確認する
3. **Track Progress**: 完了したらマークする
4. **Explain Changes**: 各ステップで高レベルの要約を行う
5. **Capture Lessons**: 修正後に `tasks/lessons.md` を更新する

## Core Principles

- **Simplicity First**: 変更は可能な限りシンプルに。影響するコードを最小化する。
- **No Laziness**: 根本原因を見つける。一時的な修正は行わない。シニア開発者の基準。
- **Minimal Impact**: 必要なものだけを変更する。バグを導入しない。
