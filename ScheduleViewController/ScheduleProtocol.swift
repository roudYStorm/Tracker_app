import Foundation

protocol ScheduleProtocol: AnyObject {
    func saveSelectedDays(selectedDays: Set<WeekDays>)
}

