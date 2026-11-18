import SwiftUI
import AppIntents

@main
struct WorkTimerApp: App {
    var body: some Scene {
        WindowGroup { ContentView() }
    }
}

/// Hiện trong Shortcuts / Siri / Action Button
struct WorkShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: StartWorkIntent(),
                    phrases: ["Start work in \(.applicationName)"],
                    shortTitle: "Start work",
                    systemImageName: "play.fill")
        AppShortcut(intent: StopWorkIntent(),
                    phrases: ["Stop work in \(.applicationName)"],
                    shortTitle: "Stop work",
                    systemImageName: "stop.fill")
    }
}
