---
name: タスク追加時はGitHub Issueも作成
description: 「タスクに追加」依頼時はTaskCreateだけでなくestack-inc/team-nのGitHub Issueも作成する
type: feedback
originSessionId: b1f386ad-4621-4da5-89e3-9242d432e5da
---
ユーザーから「タスクに追加」「タスクにしといて」等の依頼を受けた際は、ローカルのTaskCreateだけでなく、**GitHub Issue** も `estack-inc/team-n` リポジトリに作成する。

**Why:** 2026-04-22、demo-studioの社内共有タスクをローカルタスクのみで追加したところ「team-n/issuesに追加しましたか?」と確認された。ローカルタスクは会話内の進捗管理用で、GitHub Issueは将来作業の永続的な備忘録として両方必要。

**How to apply:**
- デフォルトで両方作成(ローカル TaskCreate + `gh issue create --repo estack-inc/team-n`)
- 「ローカルだけでいい」「GitHubはいらない」と明示された場合のみローカルのみ
- GitHub Issueのタイトルに重要度が指定された場合は `[重要度:高]` のように接頭辞を付ける
- GitHub Issue本文にローカルタスク番号を関連として記載すると追跡しやすい
