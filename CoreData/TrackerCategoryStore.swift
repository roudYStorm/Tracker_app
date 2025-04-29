import UIKit
import CoreData

protocol TrackerCategoryStoreDelegate: AnyObject {
    func newCategoryAdded(insertedIndexes: IndexSet, deletedIndexes: IndexSet, updatedIndexes: IndexSet)
}

final class TrackerCategoryStore: NSObject {
    
    // MARK: - Public Properties
    var categories: [TrackerCategory] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects
        else { return [] }
        
        var result: [TrackerCategory] = []
        do {
            result = try objects.map {
                try self.convertCategoryFromCoreData(from: $0)
            }
        } catch {return []}
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
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
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
    func addNewCategory(name: String) throws {
        let request  = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), name)
        let count = try context.count(for: request)
        
        if count == 0 {
            let categoryCoreData = TrackerCategoryCoreData(context: context)
            categoryCoreData.title = name
            
            
            try context.save()
        }
    }
    
    func fetchCategory(name: String) throws -> TrackerCategoryCoreData {
        let trackerCategoryCoreDataRequest = TrackerCategoryCoreData.fetchRequest()
        trackerCategoryCoreDataRequest.predicate = NSPredicate(format: "%K == %@", #keyPath(TrackerCategoryCoreData.title), name)
        let result = try context.fetch(trackerCategoryCoreDataRequest)
        
        guard let result = result.first else {
            throw CategoryStoreError.fetchingCategoryError
        }
        return result
    }
    
    // MARK: - Public Methods
    private func convertCategoryFromCoreData(from categoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = categoryCoreData.title else {
            throw CategoryStoreError.decodingTitleError
        }
        
        guard let trackersData = categoryCoreData.trackers as? Set<TrackerCoreData> else {
            throw CategoryStoreError.decodingTrackersError
        }
        
        var trackers: [Tracker] = []
        for trackerData in trackersData {
            if
                let id = trackerData.trackerId,
                let name = trackerData.title,
                let emoji = trackerData.emoji,
                let colorString = trackerData.color
            {
                let color = colorConvertor.color(from: colorString)
                let schedule = scheduleConvertor.getSchedule(from: trackerData.schedule)
                let tracker = Tracker(
                    id: id,
                    name: name,
                    color: color,
                    emoji: emoji,
                    schedule: schedule,
                    state: .Habit
                )
                trackers.append(tracker)
            }
        }
        return TrackerCategory(title: title, trackers: trackers)
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexes = IndexSet()
        deletedIndexes = IndexSet()
        updatedIndexes = IndexSet()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard
            let insertedIndexes,
            let deletedIndexes,
            let updatedIndexes
        else {
            return
        }
        
        delegate?.newCategoryAdded(
            insertedIndexes: insertedIndexes,
            deletedIndexes: deletedIndexes,
            updatedIndexes: updatedIndexes
        )
        
        self.insertedIndexes = nil
        self.deletedIndexes = nil
        self.updatedIndexes = nil
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
            insertedIndexes?.insert(indexPath.item)
        case .delete:
            guard let indexPath = newIndexPath else { fatalError() }
            deletedIndexes?.insert(indexPath.item)
        case .update:
            guard let indexPath = newIndexPath else { fatalError() }
            updatedIndexes?.insert(indexPath.item)
        default:
            fatalError()
        }
    }
}

