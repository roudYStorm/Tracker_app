import UIKit

final class PlaceHolderView
: UIView {
    
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
        imageView.image = UIImage(named: "star")
        label.text = "Что будем отслеживать?"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
    }
    
    func setupNoSearchResultsState() {
        imageView.image = UIImage(named: "notFound")
        label.text = "Ничего не найдено"
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
    }
    
    func setUpNoCategories() {
        let image = UIImage(named: "star")
        imageView.image = image
        
        // Настраиваем стиль параграфа
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 18 - UIFont.systemFont(ofSize: 12, weight: .medium).lineHeight
        
        let attributedText = NSAttributedString(
            string: "Привычки и события можно \n объединить по смыслу",
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
        // TODO:
    }
    
    // MARK: - Private Methods
    private func setupView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 223),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        
        NSLayoutConstraint.activate([
           // label.heightAnchor.constraint(equalToConstant: 18),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}


