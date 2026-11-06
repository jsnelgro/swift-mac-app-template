# MyApp

A macOS app built with Swift Package Manager: no Xcode project. AppKit for the app shell,
SwiftUI for views.

## Commands

- `scripts/test.sh`: unit tests (`--filter Name` to run some)
- `scripts/run.sh`: debug build and launch
- `scripts/build.sh`: release build into `build/MyApp.app`
- `scripts/release.sh`: signed, notarised GitHub release (`DRY_RUN=1` to skip publishing)

## Layout

- `Package.swift`: targets, frameworks to link, Swift settings
- `Sources/MyApp/main.swift`: entry point; `AppDelegate.swift`: menu and windows
- `Resources/Info.plist`: name, bundle ID, version, permissions usage strings; copied into the app
  by the scripts. Bump `CFBundleShortVersionString` / `CFBundleVersion` for releases.
- `Tests/MyAppTests`: Swift Testing (`import Testing`, `@Test`, `#expect`), `@testable import MyApp`

## Conventions

- Keep logic out of views in plain types so tests can call it.
- Prefer async/await over Combine.
- New frameworks: add `.linkedFramework("Name")` in Package.swift and `import Name`.
- Permissions that need a usage string (camera, microphone, etc.) need the key added to
  `Resources/Info.plist`, or macOS kills the app when it asks.
