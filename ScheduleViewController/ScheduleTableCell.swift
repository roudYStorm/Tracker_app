import UIKit

final class ScheduleTableCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let identifier = "ScheduleTableCell"
    
    // MARK: - Private Properties
    private let switchButton = UISwitch(frame: .zero)
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .greyColorCell
        setupSwitch()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func configButton(with tag: Int, action: Selector, controller: UIViewController) {
        switchButton.tag = tag
        switchButton.addTarget(controller, action: action, for: .valueChanged)
    }
    
    func setOn() {
        switchButton.setOn(true, animated: true)
    }
    
    // MARK: - Private Methods
    private func setupSwitch() {
        switchButton.setOn(false, animated: true)
        switchButton.onTintColor = #colorLiteral(red: 0.2156862745, green: 0.4470588235, blue: 0.9058823529, alpha: 1)
        self.accessoryView = switchButton
    }
}


