import UIKit
import SwiftUI
// MARK: - Preview
struct CreationTrackerViewControllerPreview: PreviewProvider {
    static var previews: some View {
        CreationTrackerViewController().showPreview()
    }
}

class CreationTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var creationDelegate: TrackerCreationDelegate?
    weak var configureUIDelegate: ConfigureUIForTrackerCreationProtocol?
    
    var closeCreatingTrackerViewController: (() -> ())?
    
    var selectedWeekDays: Set<WeekDays> = [] {
        didSet {
            configureUIDelegate?.checkIfSaveButtonCanBePressed()
        }
    }
    
    var trackerCategory: TrackerCategory? {
        didSet {
            configureUIDelegate?.checkIfSaveButtonCanBePressed()
        }
    }
    
    var trackerName: String? {
        didSet {
            configureUIDelegate?.checkIfSaveButtonCanBePressed()
        }
    }
    
    var selectedEmoji: String? {
        didSet {
            configureUIDelegate?.checkIfSaveButtonCanBePressed()
        }
    }
    
    var selectedColor: UIColor? {
        didSet {
            configureUIDelegate?.checkIfSaveButtonCanBePressed()
        }
    }
    
    var saveButtonCanBePressed: Bool? {
        didSet {
            let isEnabled = saveButtonCanBePressed ?? false
            
            if isEnabled {
                saveButton.isEnabled = true
                updateSaveButtonAppearance(enabled: true)
            } else {
                saveButton.isEnabled = false
                updateSaveButtonAppearance(enabled: false)
            }
        }
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    // MARK: - Private Properties
    private let stackView = UIStackView()
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    private let allEmojies = Constants.allEmojies
    private let allColors = Constants.allColors
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroudColor
        setupStackView()
        setupCollectionView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Проверяем, изменилась ли цветовая схема (светлая/темная тема)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateCancelButtonBackgroundColor()  // Обновляем фон cancelButton при смене темы
        }
    }
    
    // MARK: - IBAction
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func cancelButtonPressed() {
        dismiss(animated: true)
        closeCreatingTrackerViewController?()
    }
    
    @objc
    func saveButtonPressed() {
        guard let name = trackerName,
              let color = selectedColor,
              let emoji = selectedEmoji,
              let categoryTitle = trackerCategory?.title
        else { return }
        let tracker = Tracker(
            name: name,
            color: color,
            emoji: emoji,
            schedule: selectedWeekDays,
            state: .habit,
            isPinned: false
        )
        
        creationDelegate?.createTracker(tracker: tracker, category: categoryTitle)
        dismiss(animated: true)
        closeCreatingTrackerViewController?()
    }
    
    // MARK: - Private Methods
    
    ///MARK: - Setup StackView And Buttons
    private func setupSaveButton() {
        saveButton.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        saveButton.titleLabel?.textColor = .white
        saveButton.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)
        saveButton.layer.cornerRadius = 16
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func setupCancelButton() {
        cancelButton.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        cancelButton.clipsToBounds = true
        cancelButton.setTitleColor(#colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1), for: .normal)
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1)
        updateCancelButtonBackgroundColor()
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func updateSaveButtonAppearance(enabled: Bool) {
        if enabled {
            // Кнопка активна, настройка фона для активного состояния
            if #available(iOS 13.0, *) {
                saveButton.backgroundColor = UIColor { traitCollection -> UIColor in
                    switch traitCollection.userInterfaceStyle {
                    case .dark:
                        // Белый фон с черным текстом для темной темы
                        self.saveButton.setTitleColor(#colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1), for: .normal)
                        return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    default:
                        // Черный фон с белым текстом для светлой темы
                        self.saveButton.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                        return #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1)
                    }
                }
            }
        } else {
            saveButton.backgroundColor = #colorLiteral(red: 0.6823529412, green: 0.6862745098, blue: 0.7058823529, alpha: 1)
            saveButton.setTitleColor(.white, for: .normal)
        }
    }
    
    private func updateCancelButtonBackgroundColor() {
        if #available(iOS 13.0, *) {
            cancelButton.layer.backgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
                return traitCollection.userInterfaceStyle == .dark ?
                #colorLiteral(red: 0.1019607843, green: 0.1058823529, blue: 0.1333333333, alpha: 1) :  // Цвет для тёмной темы
                #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)  // Цвет для светлой темы
            }.cgColor
        }
    }
    
    private func setupStackView() {
        setupSaveButton()
        setupCancelButton()
        
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.spacing = 8
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(saveButton)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    ///MARK: - Setup CollectionView
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(NameTrackerCell.self, forCellWithReuseIdentifier: NameTrackerCell.identifier)
        collectionView.register(ButtonsCell.self, forCellWithReuseIdentifier: ButtonsCell.identifier)
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.identifier)
        collectionView.allowsMultipleSelection = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16)
        ])
    }
}

//MARK: DataSource
extension CreationTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Sections.name.rawValue, Sections.buttons.rawValue:
            return 1
        case Sections.emoji.rawValue:
            return allEmojies.count
        case Sections.color.rawValue:
            return allColors.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case Sections.name.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NameTrackerCell.identifier, for: indexPath) as? NameTrackerCell else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            cell.prepareForReuse()
            return cell
        case Sections.buttons.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonsCell.identifier, for: indexPath) as? ButtonsCell else {
                return UICollectionViewCell()
            }
            configureUIDelegate?.configureButtonsCell(cell: cell)
            return cell
        case Sections.emoji.rawValue:
            return configureEmojiCell(cellForItemAt: indexPath)
        case Sections.color.rawValue:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else {
                return UICollectionViewCell()
            }
            cell.prepareForReuse()
            cell.colorView.backgroundColor = allColors[indexPath.row]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let sectionHeader  = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCollectionReusableView.identifier,
                for: indexPath
            ) as? HeaderCollectionReusableView {
                if indexPath.section == Sections.emoji.rawValue {
                    sectionHeader.titleLabel.text = "Emoji"
                    return sectionHeader
                } else if indexPath.section == Sections.color.rawValue {
                    sectionHeader.titleLabel.text = "Цвет"
                    return sectionHeader
                }
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section{
        case Sections.emoji.rawValue, Sections.color.rawValue:
            return CGSize(width: collectionView.bounds.width, height: 18)
        default:
            return CGSize(width: collectionView.bounds.width, height: 0)
        }
    }
    
    private func configureEmojiCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else {
            return UICollectionViewCell()
        }
        cell.emojiLabel.text = allEmojies[indexPath.row]
        return cell
    }
}

//MARK: - Delegate
extension CreationTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 16 * 2
        
        switch indexPath.section {
        case Sections.name.rawValue:
            return CGSize(width: cellWidth, height: 75)
        case Sections.buttons.rawValue:
            return configureUIDelegate?.calculateTableViewHeight(width: cellWidth) ?? CGSize(width: cellWidth, height: 150)
        case Sections.emoji.rawValue, Sections.color.rawValue:
            let width = collectionView.frame.width - 18 * 2
            return CGSize(width: width / 6, height: width / 6)
        default:
            return CGSize(width: cellWidth, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == Sections.buttons.rawValue {
            return UIEdgeInsets(top: 24, left: 16, bottom: 32, right: 16)
        }
        switch section {
        case Sections.buttons.rawValue:
            return UIEdgeInsets(top: 24, left: 16, bottom: 32, right: 16)
        case Sections.emoji.rawValue, Sections.color.rawValue:
            return UIEdgeInsets(top: 24, left: 16, bottom: 40, right: 16)
        default:
            return UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: false) })
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == Sections.emoji.rawValue {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            guard let emoji = cell.emojiLabel.text else { return }
            selectedEmoji = emoji
        } else if indexPath.section == Sections.color.rawValue {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else {
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            guard let color = cell.colorView.backgroundColor else { return }
            selectedColor = color
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == Sections.emoji.rawValue {
            selectedEmoji = nil
        } else if indexPath.section == Sections.color.rawValue {
            selectedColor = nil
        }
    }
}

//MARK: - SaveNameTrackerDelegate
extension CreationTrackerViewController: SaveNameTrackerDelegate {
    func textFieldWasChanged(text: String) {
        if text == "" {
            trackerName = nil
            return
        } else {
            trackerName = text
        }
    }
}

// MARK: - CategorySelectProtocol
extension CreationTrackerViewController: CategoryWasSelectedProtocol {
    func categoryWasSelected(category: TrackerCategory) {
        trackerCategory = category
        
        if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? ButtonsCell  {
            cell.updateSubtitleLabel(
                forCellAt: IndexPath(row: 0, section: 0),
                text: trackerCategory?.title ?? "")
        }
    }
}

//MARK: - ShowCategoriesDelegate
extension CreationTrackerViewController: ShowCategoriesDelegate {
    func showCategoriesViewController(viewController: CategoryViewController) {
        
        if let trackerCategory = trackerCategory {
            viewController.categoriesViewModel.selectedCategory = CategoryViewModel(title: trackerCategory.title, trackers: trackerCategory.trackers)
        }
        viewController.categoriesViewModel.categoryWasSelectedDelegate = self
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

