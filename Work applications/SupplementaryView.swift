import UIKit

final class SupplementaryView: UICollectionReusableView {
    
    
    let titleLabel = UILabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLabel()
        setupLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureLabel()
        setupLabelConstraints()
    }
    
    
    private func configureLabel() {
        titleLabel.font = UIFont.systemFont(
            ofSize: 19,
            weight: .bold
        )
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
    }
    
    
    private func setupLabelConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 28
            ),
            titleLabel.centerYAnchor.constraint(
                equalTo: centerYAnchor
            ),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -16
            )
        ])
    }
}


