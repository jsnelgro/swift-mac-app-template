// swift-tools-version: 6.0
// The whole build is defined here: no .xcodeproj. `swift build` / `swift test` work from the
// terminal, and Xcode can open this folder directly (File › Open… › pick this folder).
import PackageDescription

let package = Package(
    name: "MyApp",
    platforms: [.macOS(.v15)],
    targets: [
        .executableTarget(
            name: "MyApp",
            path: "Sources/MyApp",
            swiftSettings: [
                // Swift 5 mode keeps the compiler's strict concurrency checks as warnings rather
                // than errors. Switch to .v6 once you're comfortable with them.
                .swiftLanguageMode(.v5),
            ],
            linkerSettings: [
                .linkedFramework("AppKit"),
                .linkedFramework("SwiftUI"),
            ]
        ),
        .testTarget(
            name: "MyAppTests",
            dependencies: ["MyApp"],
            path: "Tests/MyAppTests",
            swiftSettings: [.swiftLanguageMode(.v5)]
        ),
    ]
)
