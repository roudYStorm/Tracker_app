import UIKit

final class SinglePageOnboardingViewController: UIViewController, ViewConfigurable {
    
    // MARK: - Private Properties
    private var text: String?
    private var imageTitle: String?
    private lazy var onboardingImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var onboardingTextLabel: UILabel = {
        let textLable = UILabel()
        textLable.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        textLable.lineBreakMode = .byWordWrapping
        textLable.numberOfLines = 0
        textLable.textAlignment = .center
        textLable.translatesAutoresizingMaskIntoConstraints = false
        return textLable
    }()
    
    // MARK: - Initializers
    init(text: String, imageTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.text = text
        self.imageTitle = imageTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        let subViews = [onboardingImage, onboardingTextLabel]
        subViews.forEach { view.addSubview($0) }
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            onboardingImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            onboardingImage.topAnchor.constraint(equalTo: view.topAnchor),
            onboardingImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            onboardingImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            onboardingTextLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            onboardingTextLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            onboardingTextLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Private Methods
    private func configureImageView() {
        guard let imageTitle = imageTitle else { return }
        onboardingImage.image = UIImage(named: imageTitle)
    }
    
    private func configureTextLable() {
        guard let text = text else { return }
        onboardingTextLabel.text = text
    }
    
    internal func  configureView() {
        addSubviews()
        addConstraints()
        configureImageView()
        configureTextLable()
    }
}

