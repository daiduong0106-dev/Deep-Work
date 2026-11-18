import AppIntents
import WidgetKit

struct ToggleWorkIntent: AppIntent {
    static let title: LocalizedStringResource = "Toggle work timer"
    func perform() async throws -> some IntentResult {
        WorkStore.shared.toggle()
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct StartWorkIntent: AppIntent {
    static let title: LocalizedStringResource = "Start work"
    func perform() async throws -> some IntentResult {
        WorkStore.shared.start()
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct StopWorkIntent: AppIntent {
    static let title: LocalizedStringResource = "Stop work"
    func perform() async throws -> some IntentResult {
        WorkStore.shared.stop()
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}
