import UIKit

final class EditTrackerViewController: UIViewController {
    // MARK: - Public Properties
    var viewModel: EditingViewModel
    
    // MARK: - Private Properties
    private let stackView = UIStackView()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private let daysCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("save", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("cancel", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.clipsToBounds = true
        button.setTitleColor(#colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1), for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16
        button.layer.borderWidth = 1
        button.layer.borderColor = #colorLiteral(red: 0.9607843137, green: 0.4196078431, blue: 0.4235294118, alpha: 1)
        button.backgroundColor = .backgroudColor
        return button
    }()
    
    // MARK: - Initializers
    init(viewModel: EditingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = NSLocalizedString("habit.edit", comment: "")
        view.backgroundColor = .backgroudColor
        navigationItem.hidesBackButton = true
        
        setUpLabel()
        setUpStackViewWithButtons()
        initCollection()
        
        viewModel.trackerInfoBinding = { [weak self] _ in
            guard let self = self else {return}
            self.updateSaveButton()
        }
        viewModel.scheduleBinding = { [weak self] schedule in
            guard let self = self else {return}
            self.updateScheduleCell()
        }
        viewModel.categoryBinding = { [weak self] schedule in
            guard let self = self else {return}
            self.updateCategoryCell()
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    //MARK: - Actions
    @objc
    func cancelButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc
    func saveButtonPressed() {
        viewModel.saveTracker()
        dismiss(animated: true)
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Private Methods
    private func initCollection() {
        collectionView.register(NameTrackerCell.self, forCellWithReuseIdentifier: NameTrackerCell.identifier)
        collectionView.register(ButtonsCell.self, forCellWithReuseIdentifier: ButtonsCell.identifier)
        collectionView.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.identifier)
        collectionView.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.identifier)
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.identifier)
        
        collectionView.allowsMultipleSelection = true
        view.addSubview(collectionView)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo:  daysCountLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -16)
        ])
    }
    
    private func updateScheduleCell() {
        if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? ButtonsCell  {
            cell.updateSubtitleLabel(
                forCellAt: IndexPath(row: 1, section: 0),
                text: viewModel.convertSelectedDaysToString())
        }
    }
    
    private func updateCategoryCell() {
        if let cell = collectionView.cellForItem(at: IndexPath(row: 0, section: 1)) as? ButtonsCell  {
            cell.updateSubtitleLabel(
                forCellAt: IndexPath(row: 0, section: 0),
                text: viewModel.trackerInfo.category?.title ?? "")
        }
    }
    
    private func setUpLabel() {
        view.addSubview(daysCountLabel)
        daysCountLabel.text = viewModel.getDaysCountLabelText()
        
        daysCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            daysCountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            daysCountLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            daysCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24)
        ])
    }
    
    func setUpStackViewWithButtons() {
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        updateSaveButton()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.spacing = 8
        stackView.distribution = UIStackView.Distribution.fillEqually
        stackView.alignment = UIStackView.Alignment.fill
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(saveButton)
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            saveButton.heightAnchor.constraint(equalToConstant: 60),
            cancelButton.heightAnchor.constraint(equalToConstant: 60),
            stackView.heightAnchor.constraint(equalToConstant: 60),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func updateSaveButton() {
        if viewModel.saveButtonCanBePressed() {
            saveButton.backgroundColor = .buttonColor
            saveButton.setTitleColor(.textColor, for: .normal)
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
            saveButton.backgroundColor = .grey
            saveButton.setTitleColor(.white, for: .normal)
        }
    }
}

//MARK: - Data Source
extension EditTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Sections.name.rawValue, Sections.buttons.rawValue:
            return CellSize.one
        case Sections.emoji.rawValue:
            return Constants.allEmojies.count
        case Sections.color.rawValue:
            return Constants.allColors.count
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NameTrackerCell.identifier, for: indexPath) as? NameTrackerCell else {
                return UICollectionViewCell()
            }
            cell.delegate = viewModel
            guard let name = viewModel.trackerInfo.name else { return UICollectionViewCell() }
            cell.setTrackerNameTextField(with: name)
            cell.prepareForReuse()
            return cell
            
        case 1:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonsCell.identifier, for: indexPath) as? ButtonsCell else {
                return UICollectionViewCell()
            }
            configureButtonsCell(cell: cell)
            return cell
        case Sections.emoji.rawValue:
            return configureEmojiCell(cellForItemAt: indexPath)
        case Sections.color.rawValue:
            return configureColorCell(cellForItemAt: indexPath)
        default:
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Sections.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            if let sectionHeader = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCollectionReusableView.identifier,
                for: indexPath) as? HeaderCollectionReusableView {
                
                if indexPath.section == Sections.emoji.rawValue {
                    sectionHeader.titleLabel.text = NSLocalizedString("emoji", comment: "")
                    return sectionHeader
                } else if indexPath.section == Sections.color.rawValue {
                    sectionHeader.titleLabel.text = NSLocalizedString("color", comment: "")
                    return sectionHeader
                }
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 2, 3:
            return CGSize(width: collectionView.bounds.width, height: 18)
        default:
            return CGSize(width: collectionView.bounds.width, height: 0)
        }
    }
    
    private func configureEmojiCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.identifier, for: indexPath) as? EmojiCell else {
            return UICollectionViewCell()
        }
        
        cell.setEmoji(with: Constants.allEmojies[indexPath.row])
        if cell.getEmoji() == viewModel.trackerInfo.emoji {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
        }
        return cell
    }
    
    private func configureColorCell(cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.identifier, for: indexPath) as? ColorCell else {
            return UICollectionViewCell()
        }
        cell.prepareForReuse()
        cell.setColor(with: Constants.allColors[indexPath.row])
        if  UIColorMarshalling().isEqual(color1: Constants.allColors[indexPath.row], to: viewModel.trackerInfo.color!) {
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        }
        return cell
    }
    
    private func configureButtonsCell(cell: ButtonsCell) {
        cell.prepareForReuse()
        cell.scheduleDelegate = self
        cell.categoriesDelegate = self
        cell.state = .Habit
        cell.scheduleSubText = viewModel.convertSelectedDaysToString()
        cell.categorySubText = viewModel.trackerInfo.category?.title
    }
}

//MARK: - Delegate
extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width - 16 * 2
        
        switch indexPath.section {
        case 0:
            return CGSize(width: cellWidth, height: 75)
        case 1:
            return CGSize(width: cellWidth, height: 150)
        case 2, 3:
            let width = collectionView.frame.width - 18 * 2
            return CGSize(width: width / 6, height: width / 6)
        default:
            return CGSize(width: cellWidth, height: 75)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 {
            return UIEdgeInsets(top: 24, left: 16, bottom: 32, right: 16)
        }
        switch section {
        case 1:
            return UIEdgeInsets(top: 24, left: 16, bottom: 32, right: 16)
        case 2, 3:
            return UIEdgeInsets(top: 24, left: 16, bottom: 40, right: 16)
        default:
            return UIEdgeInsets(top: 24, left: 16, bottom: 0, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.indexPathsForSelectedItems?.filter({ $0.section == indexPath.section }).forEach({ collectionView.deselectItem(at: $0, animated: false) })
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if indexPath.section == Sections.emoji.rawValue {
            viewModel.trackerInfo.emoji = nil
        } else if indexPath.section == Sections.color.rawValue {
            viewModel.trackerInfo.color = nil
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == Sections.emoji.rawValue {
            guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiCell else {
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            viewModel.trackerInfo.emoji = cell.getEmoji()
        } else if indexPath.section == Sections.color.rawValue {
            guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCell else {
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            viewModel.trackerInfo.color = cell.getColor()
        } else {
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

//MARK: - ShowScheduleDelegate
extension EditTrackerViewController: ShowScheduleDelegate {
    func showScheduleViewController(viewController: ScheduleViewController) {
        viewController.sheduleDelegate = viewModel
        viewController.selectedDays = viewModel.trackerInfo.schedule ?? []
        navigationController?.pushViewController(viewController, animated: true)
    }
}

//MARK: - ShowCategoriesDelegate
extension EditTrackerViewController: ShowCategoriesDelegate {
    func showCategoriesViewController(viewController: CategoryViewController) {
        if let trackerCategory = viewModel.trackerInfo.category {
            viewController.categoriesViewModel.selectedCategory = CategoryViewModel(title: trackerCategory.title, trackers: trackerCategory.trackers)
        }
        viewController.categoriesViewModel.categoryWasSelectedDelegate = viewModel
        navigationController?.pushViewController(viewController, animated: true)
    }
}


