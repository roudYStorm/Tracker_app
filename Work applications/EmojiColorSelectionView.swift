import UIKit

final class NewIrregularEventController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    let categoriesServise = CategoriesServise.shared
    var chuseCategoriesName: String = ""
    let categoriesController = CategoriesController()
    let categories = UILabel()
    let chuseCategoriesNames = UILabel()
    let name = UITextField()
    private let clearButton = UIButton(type: .custom)
    private let tableView = UITableView()
    private let tableData = ["Категория"]
    private var selectedEmojiIndex: IndexPath?
    private var selectedColorIndex: IndexPath?
    var selectedEmoji: String?
    var selectedColors: String?
    let createButton = UIButton(type: .system)
    
    private var categoriesTopConstraint: NSLayoutConstraint?
    private var categoriesTopConstraintSmall: NSLayoutConstraint?
    
    private let emogies = [ "🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    private let colors: [UIColor] = [
        .colorSelection1, .colorSelection2, .colorSelection3, .colorSelection4, .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8, .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12, .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16, .colorSelection17, .colorSelection18
    ]
}
