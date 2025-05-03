import UIKit
import CoreData

protocol TrackerStoreDelegate: AnyObject {
    func store(insertedIndexes: [IndexPath], deletedIndexes: IndexSet)
}

final class TrackerStore: NSObject {
    weak var delegate: TrackerStoreDelegate?
    
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
    
    func addNewTracker(tracker: Tracker, forCategory category: String) throws {
        _ = self.fetchedResultsController.fetchedObjects
        
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
        trackerCoreData.isPinned = tracker.isPinned
        
        if context.hasChanges {
            try context.save()
            NotificationCenter.default.post(name: .dataDidChange, object: nil)
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
    
    func updateTracker(tracker: Tracker, category: TrackerCategory) throws {
        let trackerCategoryStore = TrackerCategoryStore(context: context)
        
        do {
            let trackerCoreData = try fetchTracker(trackerId: tracker.id)
            let categoryData = try trackerCategoryStore.fetchCategory(name: category.title)
            trackerCoreData.title = tracker.name
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.color = uiColorMarshalling.hexString(from: tracker.color)
            trackerCoreData.schedule = scheduleConvertor.convertScheduleToUInt16(from: tracker.schedule)
            trackerCoreData.category = categoryData
            if context.hasChanges {
                try context.save()
            }
        } catch {
            throw TrackerStoreError.fetchingTrackerError
        }
    }
    
    func deleteTracker(tracker: Tracker) throws {
        do {
            let tracker = try fetchTracker(trackerId: tracker.id)
            context.delete(tracker)
            if context.hasChanges {
                try context.save()
                NotificationCenter.default.post(name: .dataDidChange, object: nil)
            }
        } catch {
            throw TrackerStoreError.fetchingTrackerError
        }
    }
    
    func pinTracker(tracker: Tracker) throws {
        let willBePinned = tracker.isPinned ? false : true
        do {
            let trackerCoreData = try fetchTracker(trackerId: tracker.id)
            trackerCoreData.isPinned = willBePinned
            if context.hasChanges {
                try context.save()
            }
        } catch {
            throw TrackerStoreError.fetchingTrackerError
        }
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = []
        deletedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.store(insertedIndexes: insertedIndexes!, deletedIndexes: deletedIndexes!)
        insertedIndexes?.removeAll()
        deletedIndexes = nil
    }
    
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?)
    {
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { fatalError() }
            insertedIndexes?.append(indexPath)
        default:
            break
        }
    }
}

