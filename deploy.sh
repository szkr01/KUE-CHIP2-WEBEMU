#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="kue-chip2-web-emulator"
OWNER="szkr01"

if ! command -v gh >/dev/null 2>&1; then
  echo "GitHub CLI (gh) is required." >&2
  exit 1
fi

if [ ! -d .git ]; then
  git init
  git branch -M main
fi

git add .
git commit -m 'Initial KUE-CHIP2 web emulator' || true

gh repo create "$OWNER/$REPO_NAME" --public --source . --remote origin --push

gh api --method POST "/repos/$OWNER/$REPO_NAME/pages" -f build_type=workflow \
  || gh api --method PUT "/repos/$OWNER/$REPO_NAME/pages" -f build_type=workflow

gh workflow run 'Deploy GitHub Pages' --repo "$OWNER/$REPO_NAME"

echo "Repository: https://github.com/$OWNER/$REPO_NAME"
echo "Pages:      https://$OWNER.github.io/$REPO_NAME/"
