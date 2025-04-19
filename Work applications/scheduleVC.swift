import UIKit
protocol ScheduleViewControllerDelegate: AnyObject {
    func setWeekdays(weekdays: [Weekday])
}
final class ScheduleViewController: UIViewController {
    
    weak var delegate: ScheduleViewControllerDelegate?
    
    private let tableView = UITableView()
    
    private let weekdays = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    
    
    
    private var selectedWeekdays = [Weekday]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func makeLabel() -> UILabel {
        let label = UILabel()
        label.text = "Расписание"
        label.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    private func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(resource: .ypBlack)
        button.layer.cornerRadius = 16.0
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }
    
    private func makeTableView() -> UITableView {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.allowsMultipleSelection = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        return tableView
    }
    
    @objc
    private func didTapButton() {
        
        delegate?.setWeekdays(weekdays: selectedWeekdays)
        dismiss(animated: true)
    }
    
    
    private func setUp() {
        view.backgroundColor = .white
        
        let label = makeLabel()
        let button = makeButton()
        let tableView = makeTableView()
        
        
        [label, button, tableView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        
        NSLayoutConstraint.activate([
            
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60),
            button.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -47)
        ])
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let rowHeight = tableView.bounds.height / CGFloat(weekdays.count)
        return rowHeight
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Количество дней недели
        let numberOfDays = 7
        return numberOfDays
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        let switchView = UISwitch()
        switchView.translatesAutoresizingMaskIntoConstraints = false
        switchView.addTarget(self, action: #selector(didSwitch(_:)), for: .valueChanged)
        
        cell.selectionStyle = .none
        cell.backgroundColor = .systemGray6
        cell.textLabel?.text = weekdays[indexPath.row]
        cell.accessoryView = switchView
        
        return cell
    }
    
    @objc
    private func didSwitch(_ sender: UISwitch) {
        guard let tableCell = sender.superview as? UITableViewCell,
              let cellPosition = tableView.indexPath(for: tableCell),
              cellPosition.row < weekdays.count else {
            return
        }
        
        let selectedDay = weekdays[cellPosition.row]
        guard let weekday = Weekday(rawValue: selectedDay) else { return }
        
        if sender.isOn {
            selectedWeekdays.append(weekday)
        } else {
            selectedWeekdays.removeAll { $0 == weekday }
        }
        
        debugPrint("Selected weekdays updated: \(selectedWeekdays)")
    }
}



enum Weekday: String, CaseIterable {
    case sunday = "Воскресенье"
    case monday = "Понедельник"
    case tuesday = "Вторник"
    case wednesday = "Среда"
    case thursday = "Четверг"
    case friday = "Пятница"
    case saturday = "Суббота"
}


