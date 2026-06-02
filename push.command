#!/bin/bash
cd "$(dirname "$0")"
git add index.html
git commit -m "update"
git push origin main --force
echo "✅ Done! Press any key to close."
read -n 1
