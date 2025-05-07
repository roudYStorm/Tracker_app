import UIKit

final class ColorCell: UICollectionViewCell, ViewConfigurable {
    
    // MARK: - Public Properties
    static let identifier = "ColorCell"
    
    // MARK: - Public Properties
    public lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        contentView.addSubview(colorView)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 46),
            colorView.heightAnchor.constraint(equalToConstant: 46),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    // MARK: - Public Methods
    func setColor(with color: UIColor) {
        colorView.backgroundColor = color
    }
    
    func getColor() -> UIColor {
        guard let color = colorView.backgroundColor else { return UIColor() }
        return color
    }
    
    // MARK: - Private Methods
    internal func configureView() {
        addSubviews()
        addConstraints()
    }
    
    private func updateBorder() {
        layer.borderWidth = isSelected ? 3 : 0
        layer.borderColor = isSelected ? colorView.backgroundColor?.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
        layer.cornerRadius = 8
    }
}

