import UIKit

final class FiltersViewController: UIViewController {
    // MARK: - Public Properties
    var selectedFilter: Filters
    var filterChangedHandler: ((Filters) -> ())?
    
    // MARK: - Private Properties
    private let filters = Filters.allCases
    private let tableView = UITableView()
    
    // MARK: - Initializers
    init(selectedFilter: Filters) {
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("filters", comment: "")
        navigationItem.hidesBackButton = true
        view.backgroundColor = .backgroudColor
        
        initTableView()
    }
    
    // MARK: - Private Methods
    private func initTableView() {
        tableView.register(FiltersTableViewCell.self, forCellReuseIdentifier: FiltersTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.layer.cornerRadius = 16
        view.addSubview(tableView)
        tableView.tableHeaderView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: CGFloat(75 * filters.count))
        ])
    }
}

//MARK: - TableView Data Source
extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiltersTableViewCell.identifier, for: indexPath) as? FiltersTableViewCell else {
            return UITableViewCell()
        }
        cell.prepareForReuse()
        
        if filters.count == 1 {
            cell.setupSingleCell()
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
        } else if indexPath.row == 0 {
            cell.setupFirstCell()
        } else if indexPath.row == filters.count - 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: tableView.bounds.width)
            cell.setupLastCell()
        }
        cell.setLabelText(with: filters[indexPath.row].name)
        if filters[indexPath.row] == selectedFilter {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FiltersTableViewCell  else { return }
        cell.accessoryType = .checkmark
        filterChangedHandler?(filters[indexPath.row])
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? FiltersTableViewCell  else { return }
        cell.accessoryType = .none
    }
}

//MARK: - TableView Delegate
extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CellSize.seventyFive
    }
}



