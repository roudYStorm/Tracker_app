import UIKit

struct TrackerInfoCell {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: Set<WeekDays>
    
    var isPinned: Bool
    let daysCount: Int
    let currentDay: Date
    let state: State
    
    init(
        id: UUID,
        name: String,
        color: UIColor,
        emoji: String,
        schedule: Set<WeekDays>,
        daysCount: Int,
        currentDay: Date,
        state: State,
        isPinned: Bool
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.daysCount = daysCount
        self.currentDay = currentDay
        self.state = state
        self.isPinned = isPinned
    }
}

