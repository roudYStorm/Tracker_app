import UIKit

final class FiltersTableViewCell: UITableViewCell {
    // MARK: - Public Properties
    static let identifier = "FiltersCell"
    
    private var label = UILabel()
    
    // MARK: - Overrides Methods
    override var isSelected: Bool {
        didSet {
            self.accessoryType = self.isSelected ? AccessoryType.checkmark : .none
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .greyColorCell
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layer.maskedCorners = []
        
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setupFirstCell() {
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        layer.cornerRadius = 16
    }
    
    func setupLastCell() {
        layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        layer.cornerRadius = 16
    }
    
    func setupSingleCell() {
        layer.cornerRadius = 16
        layer.maskedCorners = [.layerMaxXMinYCorner,
                               .layerMinXMinYCorner,
                               .layerMinXMaxYCorner,
                               .layerMaxXMaxYCorner]
    }
    
    func setLabelText(with string: String) {
        label.text = string
    }
    
    // MARK: - Private Methods
    private func setupLabel() {
        contentView.addSubview(label)
        
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}


