import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let identifier = "TrackerCell"
    
    weak var counterDelegate: TrackerCounterDelegate?
    
    let addButton = UIButton(type: .system)
    let card = UIView()
    let circle = UIView()
    let emojiLabel = UILabel()
    let titleLabel = UILabel()
    let pinImageView = UIImageView()
    let daysCountLabel = UILabel()
    
    var color: UIColor?
    var isPinned: Bool = false
    var daysCount: Int = 0 {
        didSet {
            updateDaysCountLabel()
        }
    }
    
    var trackerInfo: TrackerInfoCell?
    {
        didSet {
            titleLabel.text = trackerInfo?.name
            emojiLabel.text = trackerInfo?.emoji
            card.backgroundColor = trackerInfo?.color
            daysCount = trackerInfo?.daysCount ?? daysCount
            color = trackerInfo?.color
            updateAddButton()
        }
    }
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(card)
        setupCard()
        
        card.addSubview(circle)
        setupCircle()
        
        setupEmojiLabel()
        setupPinImageView()
        setupTitle()
        setupAddButton()
        setupDaysCountLabel()
        
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - IBAction
    @objc
    func buttonClicked() {
        if !checkIfTrackerWasCompleted() {
            guard let id = trackerInfo?.id,
                  let currentDay = trackerInfo?.currentDay,
                  let _ = trackerInfo?.state else { return }
            if currentDay > Date() { return }
            addButton.setImage(UIImage(named: "done"), for: .normal)
            addButton.backgroundColor = color?.withAlphaComponent(0.3)
            
            counterDelegate?.increaseTrackerCounter(id: id, date: currentDay)
            daysCount = counterDelegate?.calculateTimesTrackerWasCompleted(id: id) ?? daysCount
        } else {
            addButton.setImage(UIImage(named: "plus"), for: .normal)
            addButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            addButton.backgroundColor = color
            guard let id = trackerInfo?.id,
                  let currentDay = trackerInfo?.currentDay else { return }
            
            counterDelegate?.decreaseTrackerCounter(id: id, date: currentDay)
            daysCount = counterDelegate?.calculateTimesTrackerWasCompleted(id: id) ?? daysCount
        }
    }
    
    // MARK: - Private Methods
    
    ///MARK: - Check status
    private func checkIfTrackerWasCompleted() -> Bool {
        guard let id = trackerInfo?.id,
              let currentDay = trackerInfo?.currentDay,
              let delegate = counterDelegate else {
            return false
        }
        return delegate.checkIfTrackerWasCompletedAtCurrentDay(id: id, date: currentDay)
    }
    
    private func updateDaysCountLabel() {
        let number = daysCount % 10
        var days: String
        switch number {
        case 1:
            days = "день"
        case 2, 3, 4:
            days = "дня"
        default:
            days = "дней"
        }
        daysCountLabel.text = String(daysCount) + " " + days
    }
    
    private func updateAddButton() {
        if checkIfTrackerWasCompleted() {
            addButton.setImage(UIImage(named: "done"), for: .normal)
            addButton.backgroundColor = color?.withAlphaComponent(0.3)
        } else {
            addButton.setImage(UIImage(named: "plus"), for: .normal)
            addButton.backgroundColor = color
        }
        addButton.layer.cornerRadius = 16
        addButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    ///MARK: - Setup UI
    private func setupCard() {
        card.layer.cornerRadius = 16
        card.layer.masksToBounds = true
        card.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            card.heightAnchor.constraint(equalToConstant: 90),
            card.widthAnchor.constraint(equalToConstant: contentView.frame.width)
        ])
    }
    
    private func setupCircle() {
        circle.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        circle.layer.cornerRadius = 12
        circle.layer.masksToBounds = true
        circle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            circle.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12),
            circle.topAnchor.constraint(equalTo: card.topAnchor, constant: 12),
            circle.widthAnchor.constraint(equalToConstant: 24),
            circle.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func setupEmojiLabel() {
        emojiLabel.font = UIFont.systemFont(ofSize: 12)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(emojiLabel)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: circle.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: circle.centerYAnchor)
        ])
    }
    
    private func setupPinImageView() {
        let image = UIImage(named: "pin")
        pinImageView.image = image
        pinImageView.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(pinImageView)
        
        NSLayoutConstraint.activate([
            pinImageView.centerYAnchor.constraint(equalTo: circle.centerYAnchor),
            pinImageView.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupTitle() {
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.widthAnchor.constraint(equalToConstant: contentView.frame.width - 12 * 2),
            titleLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -12),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 12)
        ])
    }
    
    private func setupDaysCountLabel() {
        contentView.addSubview(daysCountLabel)
        daysCountLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        updateDaysCountLabel()
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            daysCountLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            daysCountLabel.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            daysCountLabel.trailingAnchor.constraint(equalTo: addButton.leadingAnchor, constant: -8)
        ])
    }
    
    private func setupAddButton() {
        contentView.addSubview(addButton)
        updateAddButton()
        addButton.addTarget(
            self,
            action: #selector(buttonClicked),
            for: .touchUpInside
        )
        addButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 34),
            addButton.heightAnchor.constraint(equalToConstant: 34),
            addButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            addButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
}

