#!/bin/bash
# Builds the app (debug) and launches it, quitting any copy that's already running.
# Logs from print() go to this terminal.
set -euo pipefail
cd "$(dirname "$0")/.."

NAME=$(/usr/libexec/PlistBuddy -c "Print :CFBundleExecutable" Resources/Info.plist)
CONFIG="${CONFIG:-debug}" scripts/build.sh
pkill -x "$NAME" 2>/dev/null || true
exec "build/$NAME.app/Contents/MacOS/$NAME"
