#!/bin/bash
# Turns a square PNG (ideally 1024×1024) into Resources/AppIcon.icns, which the build scripts
# copy into the app.
#
# Usage: scripts/make-icon.sh path/to/icon.png
set -euo pipefail
cd "$(dirname "$0")/.."

SRC="${1:?Usage: scripts/make-icon.sh path/to/icon.png}"
SET="$(mktemp -d)/AppIcon.iconset"
mkdir -p "$SET"
for size in 16 32 128 256 512; do
  sips -z $size $size "$SRC" --out "$SET/icon_${size}x${size}.png" >/dev/null
  sips -z $((size * 2)) $((size * 2)) "$SRC" --out "$SET/icon_${size}x${size}@2x.png" >/dev/null
done
iconutil -c icns "$SET" -o Resources/AppIcon.icns
echo "Wrote Resources/AppIcon.icns"
