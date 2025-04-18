import UIKit

protocol TrackerSettingsViewControllerDelegate: AnyObject {
    func addTracker(category: String, tracker: Tracker)
}

enum TrackerTypes: String {
    case habit = "Новая привычка"
    case notRegular = "Нерегулярное событие"
}

final class TrackerSettingsViewController: UIViewController, ScheduleViewControllerDelegate, UITextFieldDelegate {
    
    
    weak var delegate: TrackerSettingsViewControllerDelegate?
    var trackerType: TrackerTypes?
    
    private var selectedWeekdays: [Weekday]?
    private let textField = UITextField()
    private let button = UIButton()
    private let clearButton = UIButton(type: .custom)
    private let colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18
    ]
    
    
    func setWeekdays(weekdays: [Weekday]) {
        selectedWeekdays = weekdays
        button.backgroundColor = UIColor.colorSelection18
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func makeTitleLabel(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = UIColor.systemGray6
        textField.layer.cornerRadius = 16
        textField.placeholder = "Введите название трекера"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 1))
        textField.leftViewMode = .always
        textField.addTarget(self, action: #selector(didEditTextField), for: .editingChanged)
        textField.delegate = self
        setupClearButton()
        return textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    private func makeCreateButton() -> UIButton {
        guard let trackerType else {
            assertionFailure("no tracker type")
            return button
        }
        button.addTarget(self, action: #selector(self.didTapCreateButton), for: .touchUpInside)
        button.setTitle("Создать", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = trackerType.rawValue ==  TrackerTypes.habit.rawValue ? .gray : .colorSelection5
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    private func makeCancelButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .clear
        button.tintColor = .red
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.cornerRadius = 16
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        return button
    }
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.heightAnchor.constraint(equalToConstant: trackerType == TrackerTypes.habit ? 150 : 75).isActive = true
        return tableView
    }
    
    @objc
    private func didTapCreateButton() {
        guard let trackerType = trackerType else {
            assertionFailure("no tracker type")
            return
        }
        
        if trackerType == .notRegular {
            let tracker = Tracker(
                id: UUID(),
                name: textField.text ?? "",
                color: colors.randomElement() ?? .colorSelection12,
                emoji: "❤️",
                calendar: nil,
                date: Date()
            )
            delegate?.addTracker(category: "Немного веселья", tracker: tracker)
            return
        }
        
        guard let selectedWeekdays = selectedWeekdays else {
            print("noSelectedDays")
            return
        }
        
        let tracker = Tracker(
            id: UUID(),
            name: textField.text ?? "",
            color: colors.randomElement() ?? .colorSelection12,
            emoji: "❤️",
            calendar: selectedWeekdays,
            date: nil
        )
        delegate?.addTracker(category: "Немного веселья", tracker: tracker)
    }
    
    private func setupClearButton() {
        clearButton.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        clearButton.tintColor = .gray
        clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
        clearButton.frame = CGRect(x: 0, y: 0, width: 17, height: 17)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 75))
        clearButton.center = CGPoint(
            x: paddingView.frame.width - 12 - 8.5,
            y: paddingView.frame.height / 2
        )
        paddingView.addSubview(clearButton)
        
        textField.rightView = paddingView
        textField.rightViewMode = .whileEditing
        clearButton.isHidden = true
    }
    @objc
    private func didTapCancelButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func didEditTextField() {
        let isEmpty = textField.text?.isEmpty ?? true
        clearButton.isHidden = isEmpty
    }
    
    @objc
    private func clearTextField() {
        textField.text = ""
        clearButton.isHidden = true
    }
    
    private func setUp() {
        view.backgroundColor = .white
        let label = makeTitleLabel(text: trackerType?.rawValue ?? "")
        let textField = makeTextField()
        let tableView = makeTableView()
        let cancelButton = makeCancelButton()
        let createButton = makeCreateButton()
        
        view.addSubviews([label, textField, tableView, cancelButton, createButton])
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 34),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 38),
            textField.heightAnchor.constraint(equalToConstant: 75),
            textField.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            
            tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 24),
            tableView.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            
            cancelButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 48) / 2),
            
            
            
            createButton.widthAnchor.constraint(equalToConstant: (view.frame.width - 48) / 2),
            createButton.heightAnchor.constraint(equalToConstant: 60),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            
        ])
    }
}

extension TrackerSettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let trackerType = trackerType else {
            
            return 1
        }
        
        if trackerType.rawValue == TrackerTypes.habit.rawValue {
            
            return 2
            
        } else {
            
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = .systemGray6
        
        let image = UIImageView(image: .property)
        image.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(image)
        
        cell.textLabel?.text = indexPath.row == 0 ? "Категория" : "Расписание"
        
        NSLayoutConstraint.activate([
            image.heightAnchor.constraint(equalToConstant: 24),
            image.widthAnchor.constraint(equalToConstant: 24),
            image.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            image.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
        ])
        
        return cell
    }
}

extension TrackerSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight: CGFloat = 75
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 1 else { return }
        
        let scheduleViewController = ScheduleViewController()
        scheduleViewController.delegate = self
        present(scheduleViewController, animated: true)
    }
    
}


