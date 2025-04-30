import UIKit

final class ButtonTableViewCell: UITableViewCell {
    
    // MARK: - Public Properties
    static let identifier = "ButtonTableViewCell"
    
    let titleLabel = UILabel()
    
    // MARK: - Private Properties
    private let subtitleLabel = UILabel()
    private let stackView = UIStackView()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .greyColorCell
        accessoryType = .disclosureIndicator
        layer.masksToBounds = true
        layer.cornerRadius = 16
        
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setupSubtitleLabel(text: String) {
        if text.count > 0 {
            subtitleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
            subtitleLabel.text = text
            subtitleLabel.textColor = .gray
            subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(subtitleLabel)
            
            NSLayoutConstraint.activate([
                subtitleLabel.heightAnchor.constraint(equalToConstant: 22)
            ])
        } else {
            subtitleLabel.text = ""
            stackView.removeArrangedSubview(subtitleLabel)
        }
    }
    
    // MARK: - Private Methods
    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 2
        stackView.addArrangedSubview(titleLabel)
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -41),
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
}


