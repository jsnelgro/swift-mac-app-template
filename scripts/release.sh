#!/bin/bash
# Builds a signed, notarised, universal (Apple Silicon + Intel) .app and publishes it as a GitHub
# release. Only needed when you want to hand the app to other people: for your own use,
# scripts/build.sh is enough.
#
# One-time setup (needs a paid Apple Developer account):
#   1. A "Developer ID Application" certificate in your keychain
#      (Xcode › Settings › Accounts › Manage Certificates › + › Developer ID Application).
#   2. Notarisation credentials saved in the keychain under the profile "notary":
#        xcrun notarytool store-credentials notary --apple-id <you@example.com> --team-id <TEAMID>
#      (it asks for an app-specific password from account.apple.com).
#   3. The GitHub CLI (`brew install gh`, then `gh auth login`).
#
# Usage: scripts/release.sh            # version from Resources/Info.plist
#        DRY_RUN=1 scripts/release.sh  # everything except notarising and publishing
set -euo pipefail
cd "$(dirname "$0")/.."

NAME=$(/usr/libexec/PlistBuddy -c "Print :CFBundleExecutable" Resources/Info.plist)
VERSION=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" Resources/Info.plist)
IDENTITY="${CODESIGN_IDENTITY:-Developer ID Application}"
PROFILE="${NOTARY_PROFILE:-notary}"
OUT="build/release"
APP="$OUT/$NAME.app"
ZIP="$OUT/$NAME-$VERSION.zip"

echo "==> $NAME $VERSION"
if [[ -z "${DRY_RUN:-}" ]] && git tag --list | grep -qx "v$VERSION"; then
  echo "Tag v$VERSION already exists; bump CFBundleShortVersionString in Resources/Info.plist." >&2
  exit 1
fi

echo "==> Building universal binary"
swift build -c release --arch arm64 --arch x86_64
BIN="$(swift build -c release --arch arm64 --arch x86_64 --show-bin-path)/$NAME"
lipo -info "$BIN"

rm -rf "$OUT"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/$NAME"
cp Resources/Info.plist "$APP/Contents/Info.plist"
[[ -f Resources/AppIcon.icns ]] && cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

echo "==> Signing with $IDENTITY (hardened runtime)"
codesign --force --options runtime --timestamp --sign "$IDENTITY" "$APP"
codesign --verify --strict --verbose=2 "$APP"

if [[ -n "${DRY_RUN:-}" ]]; then
  echo "==> Dry run: skipping notarisation and publishing. App at $APP"
  exit 0
fi

echo "==> Notarising (this takes a few minutes)"
ditto -c -k --keepParent "$APP" "$OUT/notarise.zip"
xcrun notarytool submit "$OUT/notarise.zip" --keychain-profile "$PROFILE" --wait
xcrun stapler staple "$APP"
spctl --assess --type execute --verbose=2 "$APP"

echo "==> Packaging"
ditto -c -k --keepParent "$APP" "$ZIP"
shasum -a 256 "$ZIP"

echo "==> Publishing GitHub release v$VERSION"
gh release create "v$VERSION" "$ZIP" --title "$NAME $VERSION" --generate-notes
echo "==> Done"
