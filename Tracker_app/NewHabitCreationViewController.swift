import UIKit

final class NewHabitCreationViewController: CreationTrackerViewController {
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIDelegate = self
        configureUIDelegate?.setupBackground()
    }
    
    // MARK: - Private Methods
    private func convertSelectedDaysToString() -> String {
        let weekSet = Set(WeekDays.allCases)
        
        var scheduleSubtext = String()
        
        if selectedWeekDays == weekSet {
            scheduleSubtext = NSLocalizedString("weekdays.all", comment: "")
        } else if !selectedWeekDays.isEmpty {
            selectedWeekDays.sorted {
                $0.rawValue < $1.rawValue
            }.forEach { day in
                scheduleSubtext += day.shortName
                scheduleSubtext += ", "
            }
            scheduleSubtext = String(scheduleSubtext.dropLast(2))
        } else {
            return ""
        }
        return scheduleSubtext
    }
}

//MARK: - ShowScheduleDelegate
extension NewHabitCreationViewController: ShowScheduleDelegate {
    
    // MARK: - Public Methods
    func showScheduleViewController(viewController: ScheduleViewController) {
        viewController.sheduleDelegate = self
        viewController.selectedDays = selectedWeekDays
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - ScheduleProtocol
extension NewHabitCreationViewController: ScheduleProtocol {
    
    // MARK: - Public Methods
    func saveSelectedDays(selectedDays: Set<WeekDays>) {
        if selectedDays.isEmpty {
            selectedWeekDays = []
        } else {
            selectedWeekDays = []
            selectedDays.forEach {
                selectedWeekDays.insert($0)
            }
        }
        
        if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? ButtonsCell {
            cell.updateSubtitleLabel( forCellAt: IndexPath( row: 1, section: 0), text: convertSelectedDaysToString())
        }
    }
}

//MARK: - ConfigureUIForTrackerCreationProtocol
extension NewHabitCreationViewController: ConfigureUIForTrackerCreationProtocol {
    
    // MARK: - Public Methods
    func configureButtonsCell(cell: ButtonsCell) {
        cell.prepareForReuse()
        cell.scheduleDelegate = self
        cell.categoriesDelegate = self
        cell.state = .Habit
    }
    
    func setupBackground() {
        self.title = NSLocalizedString("habit.new", comment: "")
        view.backgroundColor = .backgroudColor
        navigationItem.hidesBackButton = true
    }
    
    func calculateTableViewHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 150)
    }
    
    func checkIfSaveButtonCanBePressed() {
        if trackerName != nil,
           selectedEmoji != nil,
           selectedColor != nil,
           !selectedWeekDays.isEmpty
        {
            saveButtonCanBePressed = true
        } else {
            saveButtonCanBePressed = false
        }
    }
}

