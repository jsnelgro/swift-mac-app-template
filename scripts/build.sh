#!/bin/bash
# Builds the .app bundle into ./build.
#
# A macOS app is just a folder: Name.app/Contents/{MacOS/<binary>, Info.plist, Resources/}.
# SwiftPM builds the binary; this script assembles the folder around it and signs it.
#
# Signing: uses your "Apple Development" certificate if you have one, so macOS remembers
# permissions you grant the app (Accessibility, Screen Recording, …) across rebuilds. Without one
# it signs ad hoc, which runs fine locally but macOS may ask for those permissions again after
# each rebuild. Override with CODESIGN_IDENTITY="Your Identity" (or "-" for ad hoc).
#
# Usage: scripts/build.sh               # release build
#        CONFIG=debug scripts/build.sh  # debug build (faster to compile, slower to run)
set -euo pipefail
cd "$(dirname "$0")/.."

CONFIG="${CONFIG:-release}"
NAME=$(/usr/libexec/PlistBuddy -c "Print :CFBundleExecutable" Resources/Info.plist)
APP="build/$NAME.app"

if [[ -z "${CODESIGN_IDENTITY:-}" ]]; then
  if security find-identity -v -p codesigning 2>/dev/null | grep -q "Apple Development"; then
    CODESIGN_IDENTITY="Apple Development"
  else
    CODESIGN_IDENTITY="-"
  fi
fi

swift build -c "$CONFIG"
BIN="$(swift build -c "$CONFIG" --show-bin-path)/$NAME"

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/$NAME"
cp Resources/Info.plist "$APP/Contents/Info.plist"
[[ -f Resources/AppIcon.icns ]] && cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
codesign --force --timestamp=none --sign "$CODESIGN_IDENTITY" "$APP"

echo "Built $APP (signed with: $CODESIGN_IDENTITY)"
