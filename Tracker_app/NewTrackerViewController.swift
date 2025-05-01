import UIKit
import SwiftUI
// MARK: - Preview
struct NewTrackerViewControllerPreview: PreviewProvider {
    static var previews: some View {
        NewTrackerViewController().showPreview()
    }
}

final class NewTrackerViewController: UIViewController, ViewConfigurable {
    
    // MARK: - Public Properties
    weak var delegate: TrackerCreationDelegate?
    
    // MARK: - Private Properties
    private lazy var newHabitButton: UIButton = {
        let button = UIButton()
        button.setTitle("Привычка", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textColor = .white
        button.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(newHabitPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var newEventButton: UIButton = {
        let button = UIButton()
        button.setTitle("Нерегулярное событие", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textColor = .white
        button.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(newEventPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureView()
    }
    
    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        view.addSubview(newHabitButton)
        view.addSubview(newEventButton)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            newHabitButton.heightAnchor.constraint(equalToConstant: 60),
            newHabitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newHabitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newHabitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            newEventButton.heightAnchor.constraint(equalToConstant: 60),
            newEventButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            newEventButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            newEventButton.topAnchor.constraint(equalTo: newHabitButton.bottomAnchor, constant: 16)
        ])
    }
    
    // MARK: - IBAction
    @objc
    private func newHabitPressed() {
        let vc = NewHabitCreationViewController()
        vc.closeCreatingTrackerViewController = { [weak self] in
            guard let self = self else {return}
            self.dismiss(animated: true)
        }
        _ = UINavigationController(rootViewController: vc)
        vc.creationDelegate = delegate
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc
    private func newEventPressed() {
        let vc = NewEventCreationViewController()
        vc.closeCreatingTrackerViewController = { [weak self] in
            guard let self = self else {return}
            self.dismiss(animated: true)
        }
        let navigationController = UINavigationController(rootViewController: vc)
        vc.creationDelegate = delegate
        present(navigationController, animated: true)
    }
}


