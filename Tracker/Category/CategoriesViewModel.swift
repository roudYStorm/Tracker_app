import UIKit

protocol CategoryWasSelectedProtocol: AnyObject {
    func categoryWasSelected(category: TrackerCategory)
}

final class CategoriesViewModel {
    // MARK: - Public Properties
    var categoriesBinding: Binding<[CategoryViewModel]>?
    var selectedCategory: CategoryViewModel?
    
    var numberOfRows: Int {
        get {
            categories.count
        }
    }
    
    weak var categoryWasSelectedDelegate: CategoryWasSelectedProtocol?
    
    // MARK: - Private Properties
    private(set) var categories: [CategoryViewModel] = []{
        didSet {
            categoriesBinding?(categories)
        }
    }
    
    private let categoryStore: TrackerCategoryStore
    
    // MARK: - Initializers
    convenience init() {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
            fatalError("Не удалось получить AppDelegate")
        }
        let context = appDelegate.persistentContainer.viewContext
        
        let categoryStore = TrackerCategoryStore(context: context)
        
        self.init(categoryStore: categoryStore)
    }
    
    init(categoryStore: TrackerCategoryStore) {
        self.categoryStore = categoryStore
        categoryStore.delegate = self
        
        categories = getCategoriesFromStore()
    }
    
    // MARK: - Public Methods
    func isLastCategory(index: Int) -> Bool {
        let count = categories.count
        if index == count - 1 {
            return true
        }
        
        return false
    }
    
    func categoryIsChosen(category: CategoryViewModel?) -> Bool {
        guard let selectedCategory = selectedCategory,
              let category = category
        else {
            return false
        }
        
        if selectedCategory.title == category.title {
            return true
        }
        
        return false
    }
    
    func categoryCellWasTapped(at index: Int) {
        selectedCategory = categories[index]
        if let selectedCategory = selectedCategory {
            categoryWasSelectedDelegate?.categoryWasSelected(
                category: TrackerCategory(
                    title: selectedCategory.title,
                    trackers: selectedCategory.trackers
                )
            )
        }
    }
    
    // MARK: - Private Methods
    private func getCategoriesFromStore() -> [CategoryViewModel] {
        return categoryStore.categories.map {
            CategoryViewModel(
                title: $0.title,
                trackers: $0.trackers
            )
        }
    }
}

// MARK: - Delegate
extension CategoriesViewModel: TrackerCategoryStoreDelegate {
    func newCategoryAdded(insertedIndexes: IndexSet, deletedIndexes: IndexSet, updatedIndexes: IndexSet) {
        categories = getCategoriesFromStore()
    }
}


