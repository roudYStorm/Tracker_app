import UIKit

final class ColorCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let identifier = "ColorCell"
    
    let colorView = UIView()
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = self.isSelected ? 3 : 0
            self.layer.borderColor = self.isSelected ? colorView.backgroundColor?.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 8
        
        setupColorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func setupColorView() {
        colorView.layer.cornerRadius = 8
        colorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(colorView)
        
        NSLayoutConstraint.activate([
            colorView.widthAnchor.constraint(equalToConstant: 40),
            colorView.heightAnchor.constraint(equalToConstant: 40),
            colorView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}


