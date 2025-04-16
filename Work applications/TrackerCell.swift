import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapDoneButton(isCompleted: Bool, trackerId: UUID)
}

final class TrackerCell: UICollectionViewCell {
    
    
    let cardView = UIView()
    let circleView = UIView()
    let emojiLabel = UILabel()
    let textLabel = UILabel()
    let daysLabel = UILabel()
    let doneButton = UIButton()
    
   
    weak var delegate: TrackerCellDelegate?
    var id: UUID?
    var isComplted = false
    var isCompletable = false
    
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(with tracker: Tracker, isCompleted: Bool, daysCompleted: Int, canComplete: Bool) {
        configureAppearance(for: tracker, isCompleted: isCompleted)
        daysLabel.text = formatDaysString(daysCompleted)
        id = tracker.id
        isCompletable = canComplete
        isComplted = isCompleted
    }
    
   
    private func setupViews() {
        [cardView, circleView, textLabel, daysLabel, doneButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        circleView.addSubview(emojiLabel)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.layer.cornerRadius = 16
        circleView.layer.cornerRadius = 12
        circleView.backgroundColor = .white.withAlphaComponent(0.3)
        doneButton.layer.cornerRadius = 17
        
        emojiLabel.font = .systemFont(ofSize: 16, weight: .medium)
        textLabel.font = .systemFont(ofSize: 12, weight: .medium)
        textLabel.textColor = .white
        daysLabel.font = .systemFont(ofSize: 12, weight: .medium)
        daysLabel.textColor = UIColor(resource: .ypBlack)
        
        doneButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            circleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            circleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            circleView.heightAnchor.constraint(equalToConstant: 24),
            circleView.widthAnchor.constraint(equalToConstant: 24),
            
            emojiLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -24),
            textLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            
            doneButton.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 8),
            doneButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            doneButton.heightAnchor.constraint(equalToConstant: 34),
            doneButton.widthAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func configureAppearance(for tracker: Tracker, isCompleted: Bool) {
        cardView.backgroundColor = tracker.color
        textLabel.text = tracker.name
        emojiLabel.text = tracker.emoji
        
        let buttonImage = isCompleted ? UIImage(resource: .done) : UIImage(resource: .plus)
        doneButton.setImage(buttonImage.withTintColor(.white), for: .normal)
        doneButton.backgroundColor = tracker.color
        doneButton.alpha = isCompleted ? 0.3 : 1.0
    }
    
    private func formatDaysString(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        switch (remainder10, remainder100) {
        case (1, _) where remainder100 != 11:
            return "\(count) день"
        case (2...4, _) where !(12...14).contains(remainder100):
            return "\(count) дня"
        default:
            return "\(count) дней"
        }
    }
    
    
    @objc private func didTapDoneButton() {
        guard isCompletable, let id = id else { return }
        
        
        isComplted.toggle()
        let newButtonImage = isComplted ? UIImage(resource: .done) : UIImage(resource: .plus)
        doneButton.setImage(newButtonImage.withTintColor(.white), for: .normal)
        doneButton.alpha = isComplted ? 0.3 : 1.0
        
        delegate?.didTapDoneButton(isCompleted: isComplted, trackerId: id)
    }
}


