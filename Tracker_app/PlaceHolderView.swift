import UIKit

final class PlaceHolderView: UIView {
    
    // MARK: - Private Properties
    private let imageView = UIImageView()
    private var label = UILabel()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setupNoTrackersState() {
        imageView.image = UIImage(named: "starIcon")
        label.text = NSLocalizedString("placeholder.noTrackers", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
    }
    
    func setupNoSearchResultsState() {
        imageView.image = UIImage(named: "notFound")
        label.text = NSLocalizedString("placeholder.noSearchResults", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
    }
    
    func setUpNoCategories() {
        let image = UIImage(named: "starIcon")
        imageView.image = image
        
        // Настраиваем стиль параграфа
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 18 - UIFont.systemFont(ofSize: 12, weight: .medium).lineHeight
        
        let attributedText = NSAttributedString(
            string: NSLocalizedString("placeholder.noCategories", comment: ""),
            attributes: [
                .font: UIFont.systemFont(ofSize: 12, weight: .medium),
                .paragraphStyle: paragraphStyle
            ]
        )
        
        label.attributedText = attributedText
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
    }
    
    func setupNoStatisticState() {
        let image = UIImage(named: "cryIcon")
        imageView.image = image
        label.text = NSLocalizedString("placeholder.noStatistics", comment: "")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
    }
    
    // MARK: - Private Methods
    private func setupView() {
        label.textAlignment = .center
        [imageView, label].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        addConstraint ()
    }
    
    private func addConstraint () {
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 193),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}


