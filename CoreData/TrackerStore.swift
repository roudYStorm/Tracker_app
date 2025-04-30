import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func store(insertedIndexes: [IndexPath], deletedIndexes: IndexSet)
}

final class TrackerStore: NSObject {
    
    // MARK: - Public Properties
    weak var delegate: TrackerStoreDelegate?
    
    // MARK: - Private Properties
    
    private let context: NSManagedObjectContext
    private var insertedIndexes: [IndexPath]?
    private var deletedIndexes: IndexSet?
    
    private let uiColorMarshalling = UIColorMarshalling()
    private let scheduleConvertor = ScheduleConvertor()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.title, ascending: true)
        ]
        
        let fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        fetchedResultsController.delegate = self
        
        try? fetchedResultsController.performFetch()
        return fetchedResultsController
    }()
    
    // MARK: - Initializers
    convenience override init() {
        guard let appDelegate = (UIApplication.shared.delegate as? AppDelegate) else {
            fatalError("Не удалось получить AppDelegate")
        }
        
        let context = appDelegate.persistentContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    // MARK: - Public Methods
    func addNewTracker(tracker: Tracker, forCategory category: String) throws {
        guard self.fetchedResultsController.fetchedObjects != nil
        else {
            throw CategoryStoreError.addNewTrackerError
        }
        
        let trackerCoreData = TrackerCoreData(context: context)
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        
        do {
            let categoryData = try trackerCategoryStore.fetchCategory(name: category)
            trackerCoreData.category = categoryData
        } catch {
            throw CategoryStoreError.fetchingCategoryError
        }
        
        trackerCoreData.trackerId = tracker.id
        trackerCoreData.title = tracker.name
        trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
        trackerCoreData.emoji = tracker.emoji
        trackerCoreData.schedule = scheduleConvertor.convertScheduleToUInt16(from: tracker.schedule)
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    func fetchTracker(trackerId: UUID) throws -> TrackerCoreData {
        let request = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCoreData.trackerId), trackerId as CVarArg)
        
        let result = try context.fetch(request)
        
        guard let result = result.first else {
            throw TrackerStoreError.fetchingTrackerError
        }
        return result
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let insertedIndexes,
            let deletedIndexes
        else {
            return
        }
        
        delegate?.store(insertedIndexes: insertedIndexes, deletedIndexes: deletedIndexes)
        
        self.insertedIndexes?.removeAll()
        self.deletedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.append(indexPath)
        case .delete:
            guard let indexPath = newIndexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        default:
            break
        }
    }
}


