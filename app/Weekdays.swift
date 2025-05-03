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
            return NSLocalizedString("weekdays.monday", comment: "")
        case .tueseday:
            return NSLocalizedString("weekdays.tuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("weekdays.wednesday", comment: "")
        case .thursday:
            return NSLocalizedString("weekdays.thursday", comment: "")
        case .friday:
            return NSLocalizedString("weekdays.friday", comment: "")
        case .saturday:
            return NSLocalizedString("weekdays.saturday", comment: "")
        case .sunday:
            return NSLocalizedString("weekdays.sunday", comment: "")
        }
    }
    var shortName: String {
        switch self {
        case .monday:
            return NSLocalizedString("weekdays.mon", comment: "")
        case .tueseday:
            return NSLocalizedString("weekdays.tue", comment: "")
        case .wednesday:
            return NSLocalizedString("weekdays.wed", comment: "")
        case .thursday:
            return NSLocalizedString("weekdays.thu", comment: "")
        case .friday:
            return NSLocalizedString("weekdays.fri", comment: "")
        case .saturday:
            return NSLocalizedString("weekdays.sat", comment: "")
        case .sunday:
            return NSLocalizedString("weekdays.sun", comment: "")
        }
    }
}

