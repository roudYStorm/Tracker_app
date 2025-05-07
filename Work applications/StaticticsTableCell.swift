import UIKit

final class StatisticsTableCell: UICollectionViewCell {
    // MARK: - Public Properties
    static let identifier = "StatisticsTableCell"
    
    // MARK: - Private Properties
    private var nameLabel = UILabel()
    private var scoreLabel = UILabel()
    
    private var gradient: CAGradientLayer = {
        let leftColor = UIColor.cellColor1.cgColor
        let middleColor = UIColor.cellColor9.cgColor
        let rightColor = UIColor.cellColor3.cgColor
        
        let gr = CAGradientLayer()
        gr.colors = [leftColor, middleColor, rightColor]
        gr.startPoint = CGPoint(x: 0, y: 0.5)
        gr.endPoint = CGPoint(x: 1, y: 0.5)
        return gr
    }()
    
    private let innerView: UIView = {
        let view = UIView()
        view.backgroundColor = .backgroudColor
        view.layer.cornerRadius = 15
        return view
    }()
    
    // MARK: - Overrides Methods
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
        layer.cornerRadius = 16
        layer.masksToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .greyColorCell
        layer.insertSublayer(gradient, at: 0)
        setupInnerView()
        setupScoreLabel()
        setupNameLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func setNameLabel(with title: String) {
        nameLabel.text = NSLocalizedString(title, comment: "")
    }
    
    func setScore(with score: Int) {
        scoreLabel.text = String(score)
    }
    
    // MARK: - Private Methods
    private func setupInnerView() {
        addSubview(innerView)
        innerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            innerView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 1),
            innerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 1),
            innerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -1),
            innerView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1)
        ])
    }
    
    private func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .label
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11),
            nameLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor, constant: 7),
            nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11),
            nameLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -11)
        ])
    }
    
    private func setupScoreLabel() {
        addSubview(scoreLabel)
        scoreLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        scoreLabel.textColor = .label
        
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 11),
            scoreLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 11),
            scoreLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -11),
            scoreLabel.heightAnchor.constraint(equalToConstant: 41)
        ])
    }
}


