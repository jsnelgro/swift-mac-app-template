import AppKit

// Entry point. No storyboard or @main: we create the app and its delegate by hand, which keeps
// everything visible in code.
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
// .regular = normal app with a Dock icon and menu bar. For a menu-bar-only app use .accessory
// (and set LSUIElement to true in Resources/Info.plist).
app.setActivationPolicy(.regular)
app.run()
