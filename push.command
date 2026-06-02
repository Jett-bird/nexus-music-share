#!/bin/bash
cd "$(dirname "$0")"
git add -A
git commit -m "update"
git push https://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@github.com/Jett-bird/nexus-music-share.git main --force
echo "✅ Done! Press any key to close."
read -n 1
