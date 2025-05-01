import UIKit

final class CategoryCell: UITableViewCell, ViewConfigurable {
    // MARK: - Public Properties
    static let identifier = "CategoryCell"
    
    var viewModel: CategoryViewModel? {
        didSet {
            viewModel?.titleBinding = { [weak self] title in
                self?.categorylabel.text = title
            }
        }
    }
    
    // MARK: - Private Properties
    private lazy var categorylabel: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        lable.translatesAutoresizingMaskIntoConstraints = false
        return lable
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .greyColorCell
        separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layer.maskedCorners = []
        
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        contentView.addSubview(categorylabel)
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            categorylabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            categorylabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    // MARK: - Private Methods
    internal func  configureView() {
        addSubviews()
        addConstraints()
    }
}


