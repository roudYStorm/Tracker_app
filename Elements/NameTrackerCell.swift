import UIKit

protocol SaveNameTrackerDelegate: AnyObject {
    func textFieldWasChanged(text: String)
}

final class NameTrackerCell: UICollectionViewCell {
    
    // MARK: - Public Properties
    static let identifier = "TrackerNameTextFieldCell"
    
    weak var delegate: SaveNameTrackerDelegate?
    
    let trackerNameTextField = UITextField()
    let xButton = UIButton(type: .custom)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTrackerNameTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBAction
    @objc
    func textFieldEditingChanged(_ textField: UITextField) {
        guard let text = trackerNameTextField.text else { return }
        delegate?.textFieldWasChanged(text: text)
    }
    
    // MARK: - Private Methods
    private func setupTrackerNameTextField() {
        trackerNameTextField.layer.cornerRadius = 16
        trackerNameTextField.backgroundColor = .greyColorCell
        trackerNameTextField.placeholder = "Введите название трекера"
        trackerNameTextField.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        trackerNameTextField.setLeftPaddingPoints(12)
        
        trackerNameTextField.clearButtonMode = .whileEditing
        trackerNameTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingDidEnd)
        trackerNameTextField.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackerNameTextField)
        
        NSLayoutConstraint.activate([
            trackerNameTextField.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            trackerNameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerNameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            trackerNameTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}


