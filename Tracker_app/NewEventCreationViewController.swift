import UIKit

final class NewEventCreationViewController: CreationTrackerViewController {
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUIDelegate = self
        configureUIDelegate?.setupBackground()
    }
    
    // MARK: - IBAction
    @objc
    override func saveButtonPressed() {
        guard let name = trackerName,
              let color = selectedColor,
              let emoji = selectedEmoji,
              let categoryTitle = trackerCategory?.title
        else { return }
        let week = WeekDays.allCases
        let weekSet = Set(week)
        let tracker = Tracker(
            name: name,
            color: color,
            emoji: emoji,
            schedule: weekSet,
            state: .Event,
            isPinned: false
        )
        
        creationDelegate?.createTracker(tracker: tracker, category: categoryTitle)
        dismiss(animated: true)
    }
}

//MARK: - ConfigureUIForTrackerCreationProtocol
extension NewEventCreationViewController: ConfigureUIForTrackerCreationProtocol {
    
    // MARK: - Public Methods
    func configureButtonsCell(cell: ButtonsCell) {
        cell.prepareForReuse()
        cell.categoriesDelegate = self
        cell.state = .Event
    }
    
    func setupBackground() {
        self.title = NSLocalizedString("event.new", comment: "")
        view.backgroundColor = .backgroudColor
        navigationItem.hidesBackButton = true
    }
    
    func calculateTableViewHeight(width: CGFloat) -> CGSize {
        return CGSize(width: width, height: 75)
    }
    
    func checkIfSaveButtonCanBePressed() {
        if trackerName != nil,
           selectedEmoji != nil,
           selectedColor != nil
        {
            saveButtonCanBePressed = true
        } else {
            saveButtonCanBePressed = false
        }
    }
}

