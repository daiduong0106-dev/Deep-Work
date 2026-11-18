import WidgetKit
import SwiftUI
import AppIntents

struct WorkEntry: TimelineEntry {
    let date: Date
    let runningStart: Date?
    let weekBase: TimeInterval      // tổng tuần, chưa tính ca đang chạy
    let weekAnchor: Date?           // mốc để Text(.timer) chạy tổng tuần
    let target: Double
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WorkEntry {
        WorkEntry(date: Date(), runningStart: nil, weekBase: 3600 * 5, weekAnchor: nil, target: 20)
    }
    func getSnapshot(in context: Context, completion: @escaping (WorkEntry) -> Void) {
        completion(makeEntry())
    }
    func getTimeline(in context: Context, completion: @escaping (Timeline<WorkEntry>) -> Void) {
        let next = Date().addingTimeInterval(30 * 60)
        completion(Timeline(entries: [makeEntry()], policy: .after(next)))
    }
    private func makeEntry() -> WorkEntry {
        let store = WorkStore.shared
        let now = Date()
        let base = store.weekSeconds(now: now, includeRunning: false)
        let total = store.weekSeconds(now: now, includeRunning: true)
        let run = store.running
        return WorkEntry(date: now,
                         runningStart: run?.start,
                         weekBase: base,
                         weekAnchor: run == nil ? nil : now.addingTimeInterval(-total),
                         target: store.targetHours)
    }
}

struct WorkWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: WorkEntry

    var body: some View {
        switch family {
        case .accessoryRectangular:
            VStack(alignment: .leading) {
                if let s = entry.runningStart {
                    Text("Working").font(.caption2)
                    Text(s, style: .timer).font(.headline).monospacedDigit()
                } else {
                    Text("Week: \(hm(entry.weekBase))").font(.headline)
                }
                Text("/ \(Int(entry.target))h minimum").font(.caption2)
            }
        default:
            VStack(alignment: .leading, spacing: 8) {
                if let s = entry.runningStart {
                    Text("WORKING").font(.caption.bold()).foregroundStyle(.green)
                    Text(s, style: .timer)
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .monospacedDigit()
                } else {
                    Text("Not running").font(.caption.bold()).foregroundStyle(.secondary)
                }
                weekLine
                ProgressView(value: min(1, entry.weekBase / (entry.target * 3600)))
                Spacer(minLength: 0)
                Button(intent: ToggleWorkIntent()) {
                    Label(entry.runningStart == nil ? "START" : "STOP",
                          systemImage: entry.runningStart == nil ? "play.fill" : "stop.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(entry.runningStart == nil ? Color.green : Color.red,
                                    in: RoundedRectangle(cornerRadius: 12))
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
        }
    }

    @ViewBuilder private var weekLine: some View {
        HStack(spacing: 4) {
            Text("Week:").font(.caption)
            if let anchor = entry.weekAnchor {
                Text(anchor, style: .timer).font(.caption.bold()).monospacedDigit()
            } else {
                Text(hm(entry.weekBase)).font(.caption.bold())
            }
            Text("/ \(Int(entry.target))h").font(.caption).foregroundStyle(.secondary)
        }
    }
}

struct WorkWidget: Widget {
    let kind = "WorkWidget"
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WorkWidgetView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Work Timer")
        .description("Tap Start/Stop and see this week's hours")
        .supportedFamilies([.systemSmall, .systemMedium, .accessoryRectangular])
    }
}

@main
struct WorkWidgetBundle: WidgetBundle {
    var body: some Widget { WorkWidget() }
}
