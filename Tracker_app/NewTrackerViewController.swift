import UIKit
import SwiftUI
// MARK: - Preview
struct NewTrackerViewControllerPreview: PreviewProvider {
    static var previews: some View {
        NewTrackerViewController().showPreview()
    }
}

final class NewTrackerViewController: UIViewController {
    // MARK: - Public Properties
    weak var delegate: TrackerCreationDelegate?
    
    // MARK: - Private Properties
    private var newHabitButton = UIButton()
    private var newEventButton = UIButton()
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNewHabitButton()
        setupNewEventButton()
    }
    
    // MARK: - IBAction
    @objc
    private func newHabitPressed() {
        let vc = NewHabitCreationViewController()
        vc.creationDelegate = delegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func newEventPressed() {
        let vc = NewEventCreationViewController()
        vc.creationDelegate = delegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupNewHabitButton() {
        newHabitButton.setTitle("Привычка", for: .normal)
        newHabitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newHabitButton.titleLabel?.textColor = .white
        newHabitButton.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        newHabitButton.layer.cornerRadius = 16
        newHabitButton.addTarget(self, action: #selector(newHabitPressed), for: .touchUpInside)
        newHabitButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newHabitButton)
        
        NSLayoutConstraint.activate([
            newHabitButton.heightAnchor.constraint(equalToConstant: 60),
            newHabitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newHabitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newHabitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupNewEventButton() {
        newEventButton.setTitle("Нерегулярное событие", for: .normal)
        newEventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        newEventButton.titleLabel?.textColor = .white
        newEventButton.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        newEventButton.layer.cornerRadius = 16
        newEventButton.addTarget(self, action: #selector(newEventPressed), for: .touchUpInside)
        newEventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(newEventButton)
        
        NSLayoutConstraint.activate([
            newEventButton.heightAnchor.constraint(equalToConstant: 60),
            newEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newEventButton.topAnchor.constraint(equalTo: newHabitButton.bottomAnchor, constant: 16)
        ])
    }
}


