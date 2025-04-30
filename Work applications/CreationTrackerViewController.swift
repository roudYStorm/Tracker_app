import UIKit
import SwiftUI
// MARK: - Preview
struct CreationTrackerViewControllerPreview: PreviewProvider {
    static var previews: some View {
        CreationTrackerViewController().showPreview()
    }
}
// MARK: - Types

class CreationTrackerViewController: UIViewController {
    
    // MARK: - Public Properties
    weak var creationDelegate: TrackerCreationDelegate?
    weak var configureUIDelegate: ConfigureUIForTrackerCreationProtocol?
    
    var selectedWeekDays: Set<WeekDays> = [] {
        didSet {
            configureUIDelegate?.checkIfSaveButtonCanBePressed()
        }
    }
    
    var trackerCategory = "Важное" {
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

    // MARK: - Private Properties
    private let stackView = UIStackView()
    private let saveButton = UIButton()
    private let cancelButton = UIButton()
    private let allEmojies = [ "🙂", "😻", "🌺", "🐶", "❤️", "😱",
                               "😇", "😡", "🥶", "🤔", "🙌", "🍔",
                               "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    private let allColors = [UIColor.color1, .color2, .color3, .color4, .color5, .color6,
                             .color7, .color8, .color9, .color10, .color11, .color12,
                             .color13, .color14, .color15, .color16, .color17, .color18]
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStackView()
        setupCollectionView()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - IBAction
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc
    private func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc
    func saveButtonPressed() {
        guard let name = trackerName,
              let color = selectedColor,
              let emoji = selectedEmoji else { return }
        let tracker = Tracker(
            name: name,
            color: color,
            emoji: emoji,
            schedule: selectedWeekDays,
            state: .Habit
        )
        
        creationDelegate?.createTracker(tracker: tracker, category: trackerCategory)
        dismiss(animated: true)
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
        cell.label.text = allEmojies[indexPath.row]
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
            guard let emoji = cell.label.text else { return }
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

//MARK: - ShowCategoriesDelegate
extension CreationTrackerViewController: ShowCategoriesDelegate {
    func showCategoriesViewController() {
        //TODO: добавить функционал создания категорий
    }
}

// посмотри пожалуйста файл прочитай пожалуйста
