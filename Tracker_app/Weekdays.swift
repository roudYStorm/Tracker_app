import Foundation

enum WeekDays: Int, CaseIterable {
    case monday = 1
    case tueseday
    case wednesday
    case thursday
    case friday
    case saturday
    case sunday
    
    var name: String {
        switch self {
        case .monday:
            return "Понедельник"
        case .tueseday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    var shortName: String {
        switch self {
        case .monday:
            return "Пн"
        case .tueseday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
        }
    }
}

// посмотри пожалуйста файл прочитай пожалуйста

