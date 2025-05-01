import UIKit

final class CategoryViewController: UIViewController, ViewConfigurable {
    // MARK: - Public Properties
    var categoriesViewModel = CategoriesViewModel()
    
    // MARK: - Private Properties
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
        tableView.layer.cornerRadius = 16
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var createCategoryButton: UIButton = {
        let button = UIButton()
        button.setTitle("Добавить категорию", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(createCategoryButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
        
        self.title = "Категория"
        navigationItem.hidesBackButton = true
        view.backgroundColor = .white
        
        configureView()
        
        categoriesViewModel.categoriesBinding = { [weak self] _ in
            guard let self = self else {return}
            self.categoryTableView.reloadData()
        }
    }
    
    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        let subViews = [createCategoryButton, categoryTableView]
        subViews.forEach { view.addSubview($0) }
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            categoryTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            categoryTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            categoryTableView.bottomAnchor.constraint(equalTo: createCategoryButton.topAnchor, constant: -16)
        ])
    }
    
    // MARK: - Private Methods
    @objc
    private func createCategoryButtonTapped() {
        navigationController?.pushViewController(CategoryCreationViewController(), animated: true)
    }
    
    private func showPlaceholder() {
        let backgroundView = PlaceHolderView(frame: categoryTableView.frame)
        backgroundView.setUpNoCategories()
        categoryTableView.backgroundView = backgroundView
    }
}

//MARK: - TableView Data Source
extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (categoriesViewModel.numberOfRows == 0) {
            showPlaceholder()
        } else {
            tableView.backgroundView = nil
        }
        return categoriesViewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        
        let isOnlyOneCell = categoriesViewModel.categories.count == 1
        let isFirstCell = indexPath.row == 0
        let isLastCell = categoriesViewModel.isLastCategory(index: indexPath.row)
        
        cell.prepareForReuse()
        cell.viewModel = categoriesViewModel.categories[indexPath.row]
        if categoriesViewModel.categoryIsChosen(category: cell.viewModel) {
            cell.accessoryType = .checkmark
        }
        
        if isOnlyOneCell {
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [
                .layerMaxXMinYCorner,
                .layerMinXMinYCorner,
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else if isFirstCell {
            cell.layer.maskedCorners = [
                .layerMinXMinYCorner,
                .layerMaxXMinYCorner
            ]
            cell.layer.cornerRadius = 16
        } else if isLastCell {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            cell.layer.maskedCorners = [
                .layerMinXMaxYCorner,
                .layerMaxXMaxYCorner
            ]
            cell.layer.cornerRadius = 16
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell  else { return }
        cell.accessoryType = .checkmark
        categoriesViewModel.categoryCellWasTapped(at: indexPath.row)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CategoryCell  else { return }
        cell.accessoryType = .none
    }
}

//MARK: - TableView Delegate
extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

