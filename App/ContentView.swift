import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.scenePhase) private var phase
    @State private var tick = 0
    @State private var target = WorkStore.shared.targetHours
    private let store = WorkStore.shared

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: Date(), by: 1)) { ctx in
                content(now: ctx.date)
            }
            .navigationTitle("Work Timer")
        }
        .onChange(of: phase) { _, new in if new == .active { tick += 1 } }
    }

    @ViewBuilder
    private func content(now: Date) -> some View {
        let _ = tick
        let running = store.running
        let week = store.weekSeconds(now: now)
        let goal = target * 3600
        let missing = max(0, goal - week)
        let weekList = store.weekSessions(now: now)

        List {
            Section {
                VStack(spacing: 16) {
                    Text(clock(running.map { now.timeIntervalSince($0.start) } ?? 0))
                        .font(.system(size: 56, weight: .semibold, design: .rounded).monospacedDigit())
                    Button {
                        store.toggle()
                        WidgetCenter.shared.reloadAllTimelines()
                        tick += 1
                    } label: {
                        Label(running == nil ? "START" : "STOP",
                              systemImage: running == nil ? "play.fill" : "stop.fill")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(running == nil ? Color.green : Color.red,
                                        in: RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)
                }
                .padding(.vertical, 8)
            }

            Section("This week (Mon → Sun)") {
                LabeledContent("Total hours", value: hm(week))
                ProgressView(value: min(1, week / goal))
                Text(missing > 0 ? "\(hm(missing)) left to reach \(Int(target))h"
                                 : "Reached \(Int(target))h ✅")
                    .foregroundStyle(missing > 0 ? Color.orange : Color.green)
                Stepper("Weekly minimum: \(Int(target))h", value: $target, in: 1...80)
            }

            Section("Sessions this week") {
                if weekList.isEmpty { Text("No sessions yet").foregroundStyle(.secondary) }
                ForEach(weekList) { s in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(s.start, format: .dateTime.weekday().day().month().hour().minute())
                            if let e = s.end {
                                Text("→ " + e.formatted(date: .omitted, time: .shortened))
                                    .font(.caption).foregroundStyle(.secondary)
                            } else {
                                Text("running").font(.caption).foregroundStyle(.green)
                            }
                        }
                        Spacer()
                        Text(hm((s.end ?? now).timeIntervalSince(s.start))).monospacedDigit()
                    }
                }
                .onDelete { idx in
                    store.delete(ids: Set(idx.map { weekList[$0].id }))
                    WidgetCenter.shared.reloadAllTimelines()
                    tick += 1
                }
            }
        }
        .onChange(of: target) { _, new in store.targetHours = new }
    }
}
