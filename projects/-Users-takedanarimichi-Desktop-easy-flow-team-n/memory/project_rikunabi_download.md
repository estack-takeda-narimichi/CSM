---
name: リクナビ履歴書自動ダウンロードの仕組み
description: Playwrightでリクナビ候補者一覧から書類選考かつ備考空欄の候補者の履歴書をDLし、備考に「済み」を入力、リネームしてGoogle Driveにアップロードする自動化スクリプトの詳細
type: project
---

## リクナビ履歴書自動ダウンロードスクリプト

ワークスペース: `~/conductor/workspaces/team-n/kathmandu/`

### ファイル構成
- `scripts/download-resumes.js` — メインスクリプト
- `.env` — ログイン情報（RIKUNABI_USERNAME, RIKUNABI_PASSWORD, GOOGLE_DRIVE_FOLDER_ID）
- `oauth_credentials.json` — Google OAuth認証情報（git管理外）
- `oauth_token.json` — 認証トークン（自動保存、git管理外）
- `credentials.json` — サービスアカウント（未使用、OAuth に移行済み）
- `downloads/` — 一時保存（アップロード後自動削除）
- `renamed/` — 一時保存（アップロード後自動削除）

### 処理フロー
1. Playwrightでブラウザ起動（headless: false）
2. `https://ats.hrtech.rikunabi.com/client/candidate` にアクセス
3. `.env`の認証情報で自動ログイン
4. 「運営からのお知らせ」ポップアップを自動で閉じる
5. ループ開始:
   - テーブルを上から走査し、**「書類選考」かつ備考が空（"メモを入力する"）** の最初の1行を見つける
   - [1/3] 履歴書セル（Cell[3]）内のアイコンをクリックしてダウンロード
   - [2/3] メモセル（Cell[4]）をクリック → MemoModalが開く → textareaに「済み」入力 → 「確定」ボタンクリック
   - [3/3] ZIP展開 → リネーム（[ポジション]_[管理番号]_[日付].pdf）→ Google Driveアップロード → **ローカルファイル削除**
   - テーブルを再スキャンして次の対象者へ
6. 対象者がいなくなったら終了

### リネームルール
- PDFファイル名例: `クスバハ様_0414_38362.pdf` → `QA_38362_0414.pdf`
- ポジション変換: QAエンジニア→QA、インフラエンジニア→インフラ、その他→OTHER

### Google Drive
- フォルダ: ☆Input Folder（ID: 1tMuzSL1YcUm1v-KT8lfq05WA4K07gakx）
- 認証: OAuth2（ウェブアプリケーションタイプ、リダイレクトURI: http://localhost:3000）
- サービスアカウントはストレージ容量制限のため使用不可 → OAuthに切り替え済み

### 個人情報保護
- **ローカルのZIP・PDFは常に即削除**（アップロードの成否に関わらず）
- アップロード失敗時は再実行すればリクナビから再ダウンロードできる
- credentials系ファイルはすべて.gitignoreに登録済み

### 重要な技術的ポイント
- **毎回DOMを再取得**: 1人処理するたびにテーブルを再スキャンする
- **ポップアップ閉じ**: `div[class*="Modal-styles_header"]`の2番目の子要素（×アイコン）
- **メモモーダル**: `div[class*="MemoModal-styles_root"]`を使う
- **テーブル行セレクタ**: `tr[class*="CandidateTable-styles_body-table"]`
- **カラム構成**: Cell[0]=チェックボックス, [1]=氏名, [2]=ポジション, [3]=履歴書, [4]=メモ・備考, [5]=選考ステータス
- **ZIP展開**: `ditto -x -k`を使用（日本語ファイル名対応）

### ベイマックスの役割：「ササッとダウンロード係」
リクナビからの履歴書ダウンロード、メモ更新、ファイルリネーム・整理、Googleドライブへのアップロードを自動実行する。

### 全体フロー（自動 + 手動）
```
[自動] 毎日 12:00 / 19:00（月〜土） — launchd
  RoundCubeメールチェック（check-email.js headless）
    ↓ 「新規候補者推薦」未読あり
  リクナビ履歴書DLフロー（download-resumes.js --headless）

[手動] なりさんが「履歴書ダウンロードして」と送信
  → node scripts/download-resumes.js を実行（画面付き）
```

**Why:** なりさんの「ササッとダウンロード係」業務を自動化し、個人情報の漏洩リスクを最小化するため。

**How to apply:** 自動はlaunchdで常時稼働。手動はなりさんが「履歴書ダウンロードして」と送ったら即実行。
