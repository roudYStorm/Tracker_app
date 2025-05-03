import UIKit
import CoreData

protocol TrackerRecordStoreDelegate: AnyObject {
    func recordUpdate()
}

final class TrackerRecordStore: NSObject {
    
    // MARK: - Public Properties
    weak var delegate: TrackerRecordStoreDelegate?
    
    var totalTrackersCount: Int {
        let request = TrackerCoreData.fetchRequest()
        do {
            let trackers = try context.fetch(request)
            return trackers.count
        } catch {
            print("Error fetching trackers: \(error)")
            return 0
        }
    }
    
    var completedTrackers: [TrackerRecord] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects
        else { return [] }
        
        var result: [TrackerRecord] = []
        do {
            result = try objects.map {
                try self.convertTrackerRecordFromCoreData(from: $0)
            }
        } catch { return [] }
        return result
    }
    
    var bestPeriod: Int {
        guard let objects = self.fetchedResultsController.fetchedObjects else { return 0 }
        
        var currentStreak = 0
        var longestStreak = 0
        var previousDate: Date?
        
        for record in objects {
            guard let trackerRecord = try? self.convertTrackerRecordFromCoreData(from: record) else { continue }
            let recordDate = trackerRecord.date
            
            if let previous = previousDate, Calendar.current.isDate(recordDate, inSameDayAs: previous.addingTimeInterval(86400)) {
                // Если текущая дата идет подряд
                currentStreak += 1
            } else {
                // Если последовательность прервалась
                longestStreak = max(longestStreak, currentStreak)
                currentStreak = 1 // Начинаем новую последовательность
            }
            previousDate = recordDate
        }
        
        // Проверяем последнюю последовательность
        return max(longestStreak, currentStreak)
    }
    
    var perfectDays: Int {
        guard let objects = self.fetchedResultsController.fetchedObjects else { return 0 }
        
        var dayRecords: [Date: [TrackerRecord]] = [:]
        
        // Собираем трекеры по датам
        for record in objects {
            guard let trackerRecord = try? self.convertTrackerRecordFromCoreData(from: record) else { continue }
            let recordDate = Calendar.current.startOfDay(for: trackerRecord.date)
            
            if dayRecords[recordDate] == nil {
                dayRecords[recordDate] = []
            }
            dayRecords[recordDate]?.append(trackerRecord)
        }
        
        // Проверяем дни, когда все трекеры выполнены
        var perfectDayCount = 0
        for (_, records) in dayRecords {
            if records.count == totalTrackersCount { // totalTrackersCount - общее количество трекеров
                perfectDayCount += 1
            }
        }
        
        return perfectDayCount
    }
    
    var averageTrackersPerDay: Double {
        guard let objects = self.fetchedResultsController.fetchedObjects else { return 0.0 }
        
        var dayRecords: [Date: Int] = [:]
        
        // Считаем количество трекеров по дням
        for record in objects {
            guard let trackerRecord = try? self.convertTrackerRecordFromCoreData(from: record) else { continue }
            let recordDate = Calendar.current.startOfDay(for: trackerRecord.date)
            
            if dayRecords[recordDate] == nil {
                dayRecords[recordDate] = 0
            }
            dayRecords[recordDate]? += 1
        }
        
        // Рассчитываем среднее количество трекеров за день
        let totalTrackersCompleted = dayRecords.values.reduce(0, +)
        return Double(totalTrackersCompleted) / Double(dayRecords.count)
    }
    
    // MARK: - Private Properties
    private let context: NSManagedObjectContext
    
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData> = {
        let fetchRequest = TrackerRecordCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerRecordCoreData.date, ascending: true)
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
    func addRecord(trackerId: UUID, date: Date) throws {
        let trackerRecordCoreData = TrackerRecordCoreData(context: context)
        let trackerStore = TrackerStore(context: context)
        
        do {
            let tracker = try trackerStore.fetchTracker(trackerId: trackerId)
            trackerRecordCoreData.tracker = tracker
        } catch {
            throw TrackerStoreError.decodingTrackerError
        }
        
        trackerRecordCoreData.trackerId = trackerId
        trackerRecordCoreData.date = date
        
        if context.hasChanges {
            try context.save()
            NotificationCenter.default.post(name: .dataDidChange, object: nil)
        }
    }
    
    func deleteRecord(trackerId: UUID, date: Date) throws {
        do {
            let record = try fetchTrackerRecord(trackerId: trackerId, date: date)
            context.delete(record)
        } catch {
            throw TrackerRecordStoreError.fetchTrackerRecordError
        }
        if context.hasChanges {
            try context.save()
            NotificationCenter.default.post(name: .dataDidChange, object: nil)
        }
    }
    
    func calculateCompletedTrackers() throws -> Int {
        let request = TrackerRecordCoreData.fetchRequest()
        do {
            let count = try context.count(for: request)
            return count
        } catch {
            throw TrackerRecordStoreError.fetchTrackerRecordError
        }
    }
    
    // MARK: - Private Methods
    private func fetchTrackerRecord(trackerId: UUID, date: Date) throws -> TrackerRecordCoreData {
        let calendar = Calendar.current
        let dateFrom = calendar.startOfDay(for: date)
        guard let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom) else {
            throw TrackerRecordStoreError.fetchTrackerRecordError
        }
        
        let fromPredicate = NSPredicate(format: "%K >= %@", #keyPath(TrackerRecordCoreData.date), dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "%K < %@", #keyPath(TrackerRecordCoreData.date), dateTo as NSDate)
        let idPredicate = NSPredicate(format: "%K == %@", #keyPath(TrackerRecordCoreData.trackerId), trackerId as CVarArg)
        
        let request = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, fromPredicate, toPredicate])
        
        let result = try context.fetch(request)
        
        guard let result = result.first else {
            throw TrackerRecordStoreError.fetchTrackerRecordError
        }
        return result
    }
    
    private func convertTrackerRecordFromCoreData(from trackerRecordCoreData: TrackerRecordCoreData) throws -> TrackerRecord {
        guard let id = trackerRecordCoreData.trackerId else {
            throw TrackerRecordStoreError.decodingTrackerRecordIdError
        }
        guard let date = trackerRecordCoreData.date else {
            throw TrackerRecordStoreError.decodingTrackerRecordDateError
        }
        return TrackerRecord(id: id, date: date)
    }
}

//MARK: - NSFetchedResultsControllerDelegate
extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.recordUpdate()
    }
}

