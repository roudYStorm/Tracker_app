import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func newCategoryAdded(insertedIndexes: IndexSet, deletedIndexes: IndexSet, updatedIndexes: IndexSet)
}

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Public Properties
    var categories: [TrackerCategory] {
        guard let objects = self.fetchedResultsController.fetchedObjects else { return [] }
        
        var result: [TrackerCategory] = []
        do {
            result = try objects.map { try self.convertCategoryFromCoreData(from: $0) }
        } catch { return [] }
        return result
    }
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    private var insertedIndexes: IndexSet?
    private var deletedIndexes: IndexSet?
    private var updatedIndexes: IndexSet?
    
    private let scheduleConvertor = ScheduleConvertor()
    private let colorConvertor = UIColorMarshalling()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchRequest = TrackerCategoryCoreData.fetchRequest()
        
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "title", ascending: true)
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Не удалось получить AppDelegate")
        }
        let context = appDelegate.dataStorageContainer.viewContext
        self.init(context: context)
    }
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    // MARK: - Public Methods
    func addNewCategory(name: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), name)
        let count = try context.count(for: request)
        
        if count == 0 {
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.title = name
            categoryCoreData.trackers =  nil
            try context.save()
        }
    }
    
    func fetchCategory(name: String) throws -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), name)
        let result = try context.fetch(request)
        guard let result = result.first else { throw CategoryStoreError.fetchingCategoryError }
        return result
    }
    
    // MARK: - Private Methods
    private func convertCategoryFromCoreData(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = categoryCoreData.title else {
            throw CategoryStoreError.decodingTitleError
        }
        
        guard let trackersData = categoryCoreData.trackers as? Set<TrackerCoreData> else {
            throw CategoryStoreError.decodingTrackersError
        }
        
        var trackers: [Tracker] = []
        for trackerData in trackersData {
            guard let id = trackerData.trackerId,
                  let name = trackerData.title,
                  let emoji = trackerData.emoji,
                  let colorString = trackerData.color else {
                continue
            }
            
            let color = colorConvertor.color(from: colorString)
            let schedule = scheduleConvertor.getSchedule(from: trackerData.schedule)
            
            let trackerType: TrackerType = schedule.isEmpty ? .event : .habit
            
            let tracker = Tracker(
                id: id,
                name: name,
                color: color,
                emoji: emoji,
                calendar: schedule,
                date: nil, // Убрана зависимость от отсутствующего creationDate
                type: trackerType
            )
            trackers.append(tracker)
        }
        
        return TrackerCategory(category: title, trackers: trackers)
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.newCategoryAdded(
            insertedIndexes: insertedIndexes ?? IndexSet(),
            deletedIndexes: deletedIndexes ?? IndexSet(),
            updatedIndexes: updatedIndexes ?? IndexSet()
        )
        insertedIndexes = nil
        deletedIndexes = nil
        updatedIndexes = nil
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                   didChange anObject: Any,
                   at indexPath: IndexPath?,
                   for type: NSFetchedResultsChangeType,
                   newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexes?.insert(indexPath.item)
            }
        case .delete:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
        case .update:
            if let indexPath = indexPath {
                updatedIndexes?.insert(indexPath.item)
            }
        case .move:
            if let indexPath = indexPath {
                deletedIndexes?.insert(indexPath.item)
            }
            if let newIndexPath = newIndexPath {
                insertedIndexes?.insert(newIndexPath.item)
            }
        @unknown default:
            break
        }
    }
}
