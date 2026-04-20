---
name: RoundCubeメール定期チェック
description: RoundCubeで「新規候補者推薦」未読メールを定期チェックし、履歴書DLフローを自動実行するlaunchdジョブの詳細
type: project
---

## RoundCubeメール定期チェック

### 処理フロー
1. RoundCubeにheadlessでログイン
2. 受信トレイの未読メールをスキャン
3. 件名に「新規候補者推薦」を含む未読メールがあれば：
   - メールを既読にする
   - `download-resumes.js --headless` を自動実行（リクナビ→DL→備考済み→リネーム→Google Drive）
4. なければ終了

### スケジュール
- 毎日 12:00 / 19:00 JST（月〜土、日曜休み）
- macOS launchd で永続化（セッション不要）

### ファイル構成
- `scripts/check-email.js` — メールチェックスクリプト（headless: true）
- `scripts/com.baymax.check-email-noon.plist` — launchd設定（12:00）
- `scripts/com.baymax.check-email-evening.plist` — launchd設定（19:00）
- `logs/` — 実行ログ
- `.env` — ROUNDCUBE_USERNAME, ROUNDCUBE_PASSWORD

### launchd管理
- 登録場所: `~/Library/LaunchAgents/` にシンボリックリンク
- 停止: `launchctl unload ~/Library/LaunchAgents/com.baymax.check-email-noon.plist`
- 再開: `launchctl load ~/Library/LaunchAgents/com.baymax.check-email-noon.plist`

### RoundCubeセレクタ
- ログインユーザー: `#rcmloginuser`
- パスワード: `#rcmloginpwd`
- 送信ボタン: `#rcmloginsubmit`
- メール行: `tr[id^="rcmrow"]`
- 未読クラス: `message unread`

### download-resumes.jsのheadless対応
- `--headless` 引数で画面なし実行（slowMo: 100）
- 引数なしで画面あり実行（slowMo: 500）— 手動実行時用

**Why:** 「新規候補者推薦」メールの検知→履歴書ダウンロードまでを完全自動化し、人手を介さず対応するため。

**How to apply:** launchdが自動実行。手動チェックは `node scripts/check-email.js`。
