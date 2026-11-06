# MyApp

A macOS app template built with plain Swift Package Manager and a few shell scripts. You don't need
Xcode (just its command-line tools), and there's no `.xcodeproj` to fight with.

## Requirements

- macOS 15 or later
- Swift toolchain: `xcode-select --install` installs it (or install the full Xcode)

## Using the template

1. Create your repo from this one (GitHub's **Use this template** button, or copy the folder and
   `git init`).
2. Rename the app:
   ```sh
   scripts/rename.sh CoolThing com.yourname.coolthing
   ```
3. Check that everything works:
   ```sh
   scripts/test.sh
   scripts/run.sh
   ```
4. Optional: add an icon with `scripts/make-icon.sh icon.png` (a 1024×1024 PNG).

## Everyday commands

| Command | What it does |
| --- | --- |
| `scripts/run.sh` | Debug build, then launch (logs print to the terminal) |
| `scripts/test.sh` | Run unit tests (`--filter CounterTests` to run some) |
| `scripts/build.sh` | Release build, giving `build/MyApp.app` (drag it to Applications) |
| `scripts/release.sh` | Signed, notarised GitHub release (see the script for one-time setup) |

## How it fits together

```
Package.swift            The build: targets, frameworks, Swift settings
Sources/MyApp/
  main.swift             Entry point: creates NSApplication + AppDelegate
  AppDelegate.swift      Menu bar and the main window
  ContentView.swift      SwiftUI view, plus plain logic the tests use
Resources/
  Info.plist             App name, bundle ID, version, permissions (copied into the .app)
  AppIcon.icns           Optional icon (scripts/make-icon.sh)
Tests/MyAppTests/        Swift Testing unit tests
scripts/                 Build, run, test, release, rename, icon
.github/workflows/       CI: tests + build on every push/PR
```

`swift build` only produces a bare executable. A Mac app is a folder
(`MyApp.app/Contents/{MacOS,Resources,Info.plist}`). `scripts/build.sh` assembles that folder
around the binary and code-signs it. That's all Xcode would be doing for you.

### Common changes

- **Use another Apple framework**: add `.linkedFramework("Name")` to `linkerSettings` in
  `Package.swift`, then `import Name`.
- **Add a third-party package**: add it to `dependencies:` in `Package.swift` and to the target's
  `dependencies:`.
- **Make a menu-bar-only app** (no Dock icon): set `LSUIElement` to `true` in `Info.plist` and use
  `.accessory` in `main.swift`. Then add an `NSStatusItem` in `AppDelegate`.
- **Ask for camera/microphone/etc.**: add the matching `NS…UsageDescription` key to `Info.plist`.
- **New version**: bump `CFBundleShortVersionString` (e.g. 0.2.0) and `CFBundleVersion` (1, 2, 3…)
  in `Info.plist`.

### Opening in Xcode

You can still use Xcode when you want its debugger or SwiftUI previews: **File › Open…** and pick
this folder. Xcode reads `Package.swift` directly.
