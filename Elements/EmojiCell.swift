import UIKit

final class EmojiCell: UICollectionViewCell, ViewConfigurable {
    static let identifier = "EmojiCell"
    
    // MARK: - Public Properties
    lazy var emojiLabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    // MARK: - Override Properties
    override var isSelected: Bool {
        didSet {
            updateBorder()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        contentView.addSubview(emojiLabel)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func setEmoji(with string: String) {
        emojiLabel.text = string
    }
    
    func getEmoji() -> String {
        guard let text = emojiLabel.text else { return String() }
        return text
    }
    
    // MARK: - Private Methods
    internal func configureView() {
        addSubviews()
        addConstraints()
    }
    
    private func updateBorder() {
        self.backgroundColor = self.isSelected ? .grey : .clear
        self.layer.cornerRadius = 16
    }
}


