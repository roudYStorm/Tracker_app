import UIKit


enum TrackerType {
    case habit       // привычка (имеет расписание)
    case event       // разовое событие (имеет дату, но не имеет расписания)
}

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let calendar: Set<WeekDays>
    let date: Date?
    let type: TrackerType
}
struct TrackerCategory {
    let category: String
    let trackers: [Tracker]
}
struct TrackerRecord: Hashable {
    let id: UUID
    let date: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(date)
    }
    
    static func == (lhs: TrackerRecord, rhs: TrackerRecord) -> Bool {
        return lhs.id == rhs.id && lhs.date == rhs.date
    }
}

