import Foundation

let appGroupID = "group.com.jun1stic.worktimer"

struct Session: Codable, Identifiable, Hashable {
    var id = UUID()
    var start: Date
    var end: Date?
}

final class WorkStore {
    static let shared = WorkStore()
    private let defaults = UserDefaults(suiteName: appGroupID) ?? .standard
    private let sessionsKey = "sessions"
    private let targetKey = "targetHours"

    var sessions: [Session] {
        get {
            guard let data = defaults.data(forKey: sessionsKey),
                  let list = try? JSONDecoder().decode([Session].self, from: data) else { return [] }
            return list
        }
        set { defaults.set(try? JSONEncoder().encode(newValue), forKey: sessionsKey) }
    }

    /// Mục tiêu tối thiểu mỗi tuần (giờ), mặc định 20
    var targetHours: Double {
        get { let v = defaults.double(forKey: targetKey); return v == 0 ? 20 : v }
        set { defaults.set(newValue, forKey: targetKey) }
    }

    var running: Session? { sessions.first { $0.end == nil } }

    func start() {
        guard running == nil else { return }
        var list = sessions
        list.append(Session(start: Date()))
        sessions = list
    }

    func stop() {
        var list = sessions
        if let i = list.firstIndex(where: { $0.end == nil }) { list[i].end = Date() }
        sessions = list
    }

    func toggle() { running == nil ? start() : stop() }

    func delete(ids: Set<UUID>) { sessions = sessions.filter { !ids.contains($0.id) } }

    // MARK: Tuần (Thứ 2 → Chủ nhật)
    static var calendar: Calendar {
        var c = Calendar.current
        c.firstWeekday = 2
        return c
    }

    func weekInterval(for date: Date = Date()) -> DateInterval {
        Self.calendar.dateInterval(of: .weekOfYear, for: date)!
    }

    func seconds(in interval: DateInterval, now: Date = Date(), includeRunning: Bool = true) -> TimeInterval {
        sessions.reduce(0) { acc, s in
            if s.end == nil && !includeRunning { return acc }
            let end = s.end ?? now
            let a = max(s.start, interval.start)
            let b = min(end, interval.end)
            return acc + max(0, b.timeIntervalSince(a))
        }
    }

    func weekSeconds(now: Date = Date(), includeRunning: Bool = true) -> TimeInterval {
        seconds(in: weekInterval(for: now), now: now, includeRunning: includeRunning)
    }

    func weekSessions(now: Date = Date()) -> [Session] {
        let w = weekInterval(for: now)
        return sessions
            .filter { ($0.end ?? now) > w.start && $0.start < w.end }
            .sorted { $0.start > $1.start }
    }
}

func hm(_ t: TimeInterval) -> String {
    let m = Int(t / 60)
    return String(format: "%dh %02dp", m / 60, m % 60)
}

func clock(_ t: TimeInterval) -> String {
    let s = Int(max(0, t))
    return String(format: "%02d:%02d:%02d", s / 3600, (s % 3600) / 60, s % 60)
}
