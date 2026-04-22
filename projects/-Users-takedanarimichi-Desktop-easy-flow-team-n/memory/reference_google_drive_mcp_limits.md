---
name: Google Drive MCPの書き込み制約
description: claude.ai Google Drive MCPは既存ファイル更新ができず、新規create_fileのみ対応
type: reference
originSessionId: 77bc0c6e-2624-47f7-a34d-79eeb39547f8
---
claude.ai Google Drive MCPの書き込み系ツールは `create_file` のみ。`update_file` / Sheets APIの `batchUpdate` 相当は提供されていない。

## 影響
- **既存Google Sheetsへのセル書き込み不可**
- 既存Docsの編集不可
- ファイル上書きも不可

## 回避策
- **Playwright経由でブラウザ操作**して書き込む（ただし認証済みChromeプロファイルが必要、新規contextだと未ログイン）
- ユーザーに整形テキストを渡して手動貼り付けしてもらう（最も確実・簡単）
- Google Sheets APIを直接OAuthで叩くスクリプトを別途作る

## 使い分け
- 書き込み量少・一回限り → 手動貼り付けが最速
- 書き込み量多・繰り返し → Playwright + 永続プロファイル
