import SwiftUI

struct ContentView: View {
    @State private var count = 0

    var body: some View {
        VStack(spacing: 16) {
            Text("Hello from \(AppInfo.name)")
                .font(.title)
            Text(Counter.label(for: count))
                .foregroundStyle(.secondary)
            Button("Click me") { count += 1 }
                .keyboardShortcut(.defaultAction)
        }
        .padding(32)
        .frame(minWidth: 320, minHeight: 200)
    }
}

/// Logic kept out of the view so tests can call it directly (see Tests/MyAppTests).
enum Counter {
    static func label(for count: Int) -> String {
        switch count {
        case 0: "Not clicked yet"
        case 1: "Clicked once"
        default: "Clicked \(count) times"
        }
    }
}

enum AppInfo {
    /// The app's name from Info.plist, or the executable's name when run outside a bundle
    /// (e.g. `swift run`).
    static var name: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
            ?? ProcessInfo.processInfo.processName
    }

    static var version: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "dev"
    }
}
