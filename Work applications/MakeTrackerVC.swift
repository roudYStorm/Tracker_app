import UIKit

final class MakeTrackerViewController: UIViewController {
    weak var trackersViewController: TrackerSettingsViewControllerDelegate?
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewAppearance()
        setUp()
    }
    
    
    
    private func configureViewAppearance() {
        view.backgroundColor = .white
    }
    
    private func setUp() {
        let titleLabel = makeLabel()
        let buttons = [
            makeButton(text: "Привычка", action: #selector(didTapHabitButton)),
            makeButton(text: "Нерегулярное событие", action: #selector(didTapNotHabitButton))
        ]
        
        view.addSubviews([titleLabel] + buttons)
        activateConstraints(for: titleLabel, buttons: buttons)
    }
    
   
    
    private func makeLabel() -> UILabel {
        let headerLabel = UILabel(frame: .zero)
        headerLabel.textAlignment = .center
        headerLabel.attributedText = NSAttributedString(
            string: "Создание трекера",
            attributes: [
                .font: UIFont.systemFont(ofSize: 16, weight: .medium),
                .foregroundColor: UIColor.label
            ]
        )
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.setContentHuggingPriority(.required, for: .vertical)
        return headerLabel
    }
    
    private func makeButton(text: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        configureButtonAppearance(button: button, text: text)
        button.addTarget(self, action: action, for: .touchUpInside)
        return button
    }
    
    private func configureButtonAppearance(button: UIButton, text: String) {
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(resource: .ypBlack)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
    }
    
   
    
    private func activateConstraints(for label: UILabel, buttons: [UIButton]) {
        guard let habitButton = buttons.first, let eventButton = buttons.last else { return }
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 34),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            habitButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 295),
            habitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            habitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.leadingAnchor.constraint(equalTo: habitButton.leadingAnchor),
            eventButton.trailingAnchor.constraint(equalTo: habitButton.trailingAnchor),
            eventButton.heightAnchor.constraint(equalTo: habitButton.heightAnchor)
        ])
    }
    
    
    
    @objc private func didTapHabitButton() {
        presentTrackerSettingsController(with: .habit)
    }
    
    @objc private func didTapNotHabitButton() {
        presentTrackerSettingsController(with: .notRegular)
    }
    
    private func presentTrackerSettingsController(with type: TrackerTypes) {
        let controller = TrackerSettingsViewController()
        controller.trackerType = type
        controller.delegate = trackersViewController
        present(controller, animated: true)
    }
}


