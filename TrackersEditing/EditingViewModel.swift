import Foundation

final class EditingViewModel {
    var trackerInfo: TrackerInfoModel {
        didSet {
            trackerInfoBinding?(trackerInfo)
        }
    }
    
    var trackerInfoBinding: Binding<TrackerInfoModel>?
    var scheduleBinding: Binding<Set<WeekDays>?>?
    var categoryBinding: Binding<TrackerCategory?>?
    var updateTrackerHandler: (() -> ())?
    
    private let trackerStore = TrackerStore()
    
    init(trackerInfo: TrackerInfoModel) {
        self.trackerInfo = trackerInfo
        trackerInfo.nameBinding = { [weak self] name in
            self?.trackerInfoBinding?(trackerInfo)
        }
        trackerInfo.scheduleBinding = { [weak self] schedule in
            self?.scheduleBinding?(trackerInfo.schedule)
            self?.trackerInfoBinding?(trackerInfo)
        }
        trackerInfo.categoryBinding = { [weak self] category in
            self?.categoryBinding?(trackerInfo.category)
            self?.trackerInfoBinding?(trackerInfo)
        }
        trackerInfo.colorBinding = { [weak self] color in
            self?.trackerInfoBinding?(trackerInfo)
        }
        trackerInfo.emojiBinding = { [weak self] emoji in
            self?.trackerInfoBinding?(trackerInfo)
        }
        
    }
    
    func saveTracker() {
        guard let name = trackerInfo.name,
              let emoji = trackerInfo.emoji,
              let color = trackerInfo.color,
              let schedule = trackerInfo.schedule,
              let category = trackerInfo.category
        else {
            return
        }
        let tracker = Tracker(
            id: trackerInfo.id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule,
            state: trackerInfo.state,
            isPinned: trackerInfo.isPinned)
        do {
            try trackerStore.updateTracker(tracker: tracker, category: category)
            updateTrackerHandler?()
        } catch {
            print("\(tracker.name) was not updated")
        }
    }
    
    func saveButtonCanBePressed() -> Bool {
        guard trackerInfo.name != nil,
              trackerInfo.emoji != nil,
              trackerInfo.color != nil,
              trackerInfo.schedule != nil,
              trackerInfo.category != nil
        else {
            return false
        }
        return true
    }
    
    func getDaysCountLabelText() -> String {
        let daysText = String.localizedStringWithFormat(
            NSLocalizedString("numberOfDays", comment: "Number of remaining days"),
            trackerInfo.daysCount
        )
        return daysText
    }
    
    func convertSelectedDaysToString() -> String {
        var scheduleSubText = String()
        guard let schedule = trackerInfo.schedule else {
            return ""
        }
        
        let weekSet = Set(WeekDays.allCases)
        if schedule == weekSet {
            scheduleSubText = NSLocalizedString("weekdays.all", comment: "")
        } else if !schedule.isEmpty {
            schedule.sorted {
                $0.rawValue < $1.rawValue
            }.forEach { day in
                scheduleSubText += day.shortName
                scheduleSubText += ", "
            }
            scheduleSubText = String(scheduleSubText.dropLast(2))
        } else {
            return ""
        }
        return scheduleSubText
    }
}

//MARK: - ScheduleProtocol
extension EditingViewModel: ScheduleProtocol {
    func saveSelectedDays(selectedDays: Set<WeekDays>) {
        if selectedDays.isEmpty {
            trackerInfo.schedule = nil
        } else {
            trackerInfo.schedule = selectedDays
        }
    }
}

//MARK: - CategoryWasSelectedProtocol
extension EditingViewModel: CategoryWasSelectedProtocol {
    func categoryWasSelected(category: TrackerCategory) {
        trackerInfo.category = category
    }
}

//MARK: - SaveNameTrackerDelegate
extension EditingViewModel: SaveNameTrackerDelegate {
    func textFieldWasChanged(text: String) {
        if text == "" {
            trackerInfo.name = nil
            return
        }
        trackerInfo.name = text
    }
}


