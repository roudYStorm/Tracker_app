import UIKit
import SwiftUI
// MARK: - Preview
struct ScheduleViewControllerPreview: PreviewProvider {
    static var previews: some View {
        ScheduleViewController().showPreview()
    }
}

// MARK: - Constants
private enum Constants {
    static let numberOfRowsInSection: Int = 7
}

final class ScheduleViewController: UIViewController, ViewConfigurable {
    
    // MARK: - Public Properties
    weak var sheduleDelegate: ScheduleProtocol?
    var selectedDays: Set<WeekDays> = []
    
    // MARK: - Private Properties
    private lazy var scheduleTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ScheduleTableCell.self, forCellReuseIdentifier: ScheduleTableCell.identifier)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.tableHeaderView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        configureView()
        self.title = "Расписание"
        navigationItem.hidesBackButton = true
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        let subViews = [scheduleTableView, saveButton]
        subViews.forEach { view.addSubview($0) }
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            scheduleTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scheduleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleTableView.heightAnchor.constraint(equalToConstant: 525),
            scheduleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
    
    // MARK: - IBAction
    @objc
    private func didTapSaveButton() {
        navigationController?.popViewController(animated: true)
        sheduleDelegate?.saveSelectedDays(selectedDays: selectedDays)
        
    }
    
    @objc
    private func switchChanged(_ sender: UISwitch) {
        guard let weekDay = WeekDays(rawValue: sender.tag + 1) else { return }
        if sender.isOn {
            selectedDays.insert(weekDay)
        } else {
            selectedDays.remove(weekDay)
        }
    }
    
    // MARK: - Private Methods
    private func configureCell(cell: ScheduleTableCell, cellForRowAt indexPath: IndexPath) {
        guard let weekDay = WeekDays(rawValue: indexPath.row + 1) else { return }
        cell.textLabel?.text = weekDay.name
        cell.prepareForReuse()
        cell.configButton(with: indexPath.row, action: #selector(switchChanged(_:)), controller: self)
        
        let lastCell = indexPath.row == Constants.numberOfRowsInSection - 1
        let firstCell = indexPath.row == Constants.numberOfRowsInSection - 7
        
        if lastCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: scheduleTableView.bounds.width)
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            cell.layer.cornerRadius = 16
        } else if firstCell {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.layer.cornerRadius = 16
        }
        
        if selectedDays.contains(weekDay) {
            cell.setOn()
        }
    }
}

//MARK: - DataSource
extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleTableCell.identifier, for: indexPath) as? ScheduleTableCell else {
            return UITableViewCell()
        }
        configureCell(cell: cell, cellForRowAt: indexPath)
        return cell
    }
}

//MARK: - Delegate
extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

