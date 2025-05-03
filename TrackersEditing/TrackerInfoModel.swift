import UIKit

final class TrackerInfoModel {
    let id: UUID
    let daysCount: Int
    let isPinned: Bool
    let state: State
    
    var name: String? {
        didSet {
            nameBinding?(name)
        }
    }
    var color: UIColor? {
        didSet {
            colorBinding?(color)
        }
    }
    var emoji: String? {
        didSet {
            emojiBinding?(emoji)
        }
    }
    var schedule: Set<WeekDays>? {
        didSet {
            scheduleBinding?(schedule)
        }
    }
    var category: TrackerCategory? {
        didSet {
            categoryBinding?(category)
        }
    }
    
    var nameBinding: Binding<String?>?
    var colorBinding: Binding<UIColor?>?
    var emojiBinding: Binding<String?>?
    var scheduleBinding: Binding<Set<WeekDays>?>?
    var categoryBinding: Binding<TrackerCategory?>?
    
    init(
        id: UUID,
        name: String,
        color: UIColor,
        emoji: String,
        schedule: Set<WeekDays>,
        category: TrackerCategory,
        daysCount: Int,
        isPinned: Bool,
        state: State
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.category = category
        self.daysCount = daysCount
        self.isPinned = isPinned
        self.state = state
    }
}

