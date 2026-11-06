#!/bin/bash
# Renames the template app. Run once, right after creating your repo from the template.
#
# Usage: scripts/rename.sh NewName [com.yourname.newname]
#
# Replaces "MyApp" with NewName in file contents and folder/file names, and sets the bundle
# identifier (defaults to com.example.<newname-lowercase>).
set -euo pipefail
cd "$(dirname "$0")/.."

NEW="${1:-}"
if [[ ! "$NEW" =~ ^[A-Za-z][A-Za-z0-9]*$ ]]; then
  echo "Usage: scripts/rename.sh NewName [bundle.identifier]  (NewName: letters and digits, no spaces)" >&2
  exit 1
fi
LOWER=$(tr '[:upper:]' '[:lower:]' <<<"$NEW")
BUNDLE_ID="${2:-com.example.$LOWER}"

# File contents (skipping .git, build output and this script).
grep -rlI --exclude-dir=.git --exclude-dir=.build --exclude-dir=build --exclude=rename.sh -e MyApp -e com.example.myapp . |
  while read -r f; do
    sed -i '' -e "s/com\.example\.myapp/$BUNDLE_ID/g" -e "s/MyApp/$NEW/g" "$f"
  done

# Folder and file names, deepest first so parents are renamed after their children.
find . -depth -name '*MyApp*' -not -path './.git/*' -not -path './.build/*' -not -path './build/*' |
  while read -r p; do
    mv "$p" "$(dirname "$p")/$(basename "$p" | sed "s/MyApp/$NEW/g")"
  done

rm -rf .build build
echo "Renamed to $NEW ($BUNDLE_ID). Try: scripts/test.sh && scripts/run.sh"
