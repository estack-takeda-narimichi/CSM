---
name: 毎月の業務サマリー自動通知
description: 毎月21日にカレンダーから業務サマリーを自動生成しTomボット経由でSlack通知
type: project
originSessionId: 77bc0c6e-2624-47f7-a34d-79eeb39547f8
---
毎月21日 11:00 (JST) に Claude Code のリモートトリガーが実行され、なりさんのGoogleカレンダーから前月21日〜当月20日の予定を取得、週ごとに集計して業務管理スプレッドシート「TJ_営業採用_作業タスク_竹田」貼付用テキストを整形し、**Tomボット（Slack Incoming Webhook）** 経由でSlack通知する。

## 設定情報
- トリガーID: `trig_016H7mFA3YGAhGDwgjD3ViJZ`
- cron: `0 2 21 * *`（UTC） = 毎月21日 11:00 JST
- 管理画面: https://claude.ai/code/scheduled/trig_016H7mFA3YGAhGDwgjD3ViJZ
- 通知元: Tom Bot（Slack Incoming Webhook）
- 対象スプレッドシート: `1hxSeoJWYjXc4xw_T8l0XgM4tDi8g7XQ5_mwZ4AOVCQ`（gid=2146523797）

**Why:** 手動で毎月カレンダーを見返して4〜5週分を記入する作業が繰り返し発生するため、40万円予算案件の対応と並行してコア業務時間を確保すべく自動化。

**How to apply:** 
- 通知フォーマット変更、期間調整、除外ルール追加などの要望があればトリガーのプロンプトを更新
- Google Drive MCPは既存Sheets更新不可のため、書き込みは必ずユーザー手動貼付で運用
- Webhook URL はトリガープロンプトに直接埋め込まれているため、漏洩懸念時は Slack App 設定で Regenerate → プロンプト更新
