---
name: RoundCube操作の安全ルール
description: RoundCubeのユーザー設定を書き換えるAPIは事前確認なしで使わない（2026-04-18にカラム設定を吹き飛ばした事故から）
type: feedback
originSessionId: 1112ddd2-2a53-41ef-b0bd-a533bc53940b
---
## RoundCube操作の安全ルール

### ルール
RoundCubeの以下のAPIは**サーバー側にユーザー設定として永続保存される**ため、事前にドキュメント/仕様を確認し、なりさんの承認を得てから使う:

- `rcmail.set_list_options(columns, sort_col, sort_order, threads)` — カラム・ソート・スレッド設定（永続化）
- `rcmail.filter_mailbox(filter)` — 検索フィルタ（値によっては永続化）
- `rcmail.save_pref(...)` — 任意のユーザー設定保存
- その他 `rcmail.command('save-*')` 系

### 特に注意
- `set_list_options` の第1引数に**空配列 `[]` を絶対渡さない** → 「カラム非表示」設定になり、全フォルダで「リストは空です」になる
- デフォルトカラム例: `['threads', 'subject', 'status', 'fromto', 'date', 'size', 'flag', 'attachment']`

### 許可されている操作
- DOM読み取り（`document.querySelectorAll` 等）
- `rcmail.command('move', folderName)` — フォルダ移動のみ

### 禁止されている操作
- メール削除・ゴミ箱移動（`rcmail.command('delete')`, `rcmail.command('movetotrash')`）
- 送信・返信・転送
- ユーザー設定の勝手な変更

**Why:** 2026-04-18に `set_list_options([], null, null, 0)` を実行した結果、全フォルダで「このリストは空です」表示になり、なりさんが「全部削除されてる」と恐怖する事態に。実際はカラム設定が空になっただけでメールは無事だったが、復旧に追加作業が必要になった。

**How to apply:** check-email.js など今後のRoundCube自動化スクリプトを触る時、設定変更系APIは必ず事前にドキュメント確認 + なりさんの承認を得る。
