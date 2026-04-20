#!/bin/bash
# Auto-backup ~/.claude/ to GitHub (estack-takeda-narimichi/CSM)
# Triggered by Stop hook in settings.json.

set +e
cd ~/.claude || exit 0

# Skip if nothing changed (both working tree and staged)
if git diff --quiet && git diff --cached --quiet && [ -z "$(git ls-files --others --exclude-standard)" ]; then
    exit 0
fi

git add -A
if git diff --cached --quiet; then
    exit 0
fi

TIMESTAMP=$(TZ=Asia/Tokyo date '+%Y-%m-%d %H:%M JST')
git commit -m "自動バックアップ: ${TIMESTAMP}" >/dev/null 2>&1
git push origin main >/dev/null 2>&1
exit 0
