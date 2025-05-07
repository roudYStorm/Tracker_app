import Foundation

final class TrackerPresenter {
    // MARK: - Public Properties
    weak var viewController: TrackerViewController?
    
    var categories: [TrackerCategory] = []
    var completedTrackers: [TrackerRecord] = []
    var pinnedTrackers: [Tracker] = []
    var currentDate = Date()
    
    var selectedFilter: Filters {
        get {
            guard let value = userDefaults.string(forKey: "filter"),
                  let filter = Filters(rawValue: value) else { return Filters.allTrackers }
            return filter
        }
        set {
            userDefaults.set(newValue.rawValue, forKey: "filter")
        }
    }
    
    lazy var currentCategories: [TrackerCategory] = {
        filterCategoriesToShow(filter: selectedFilter)
    }()
    
    // MARK: - Private Properties
    private var trackerStore = TrackerStore()
    private var trackerCategoryStore = TrackerCategoryStore()
    private var trackerRecordStore = TrackerRecordStore()
    private let analyticsService = AnalyticsService()
    private let userDefaults = UserDefaults.standard
    
    // MARK: - Initializers
    init() {
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        
        categories = trackerCategoryStore.categories
        completedTrackers = trackerRecordStore.completedTrackers
    }
    
    init(trackerStore: TrackerStore, trackerCategoryStore: TrackerCategoryStore, trackerRecordStore: TrackerRecordStore) {
        self.trackerStore = trackerStore
        self.trackerCategoryStore = trackerCategoryStore
        self.trackerRecordStore = trackerRecordStore
        
        trackerStore.delegate = self
        trackerRecordStore.delegate = self
        
        categories = trackerCategoryStore.categories
        completedTrackers = trackerRecordStore.completedTrackers
    }
    
    // MARK: - Public Methods
    func numberOfItemsInSection(section: Int) -> Int {
        return currentCategories[section].trackers.count
    }
    
    func numberOfSections() -> Int {
        return currentCategories.count
    }
    
    func isLastSection(section: Int) -> Bool {
        if section == currentCategories.count - 1 {
            return true
        }
        return false
    }
    
    func noTrackersToShow() -> Bool {
        currentCategories.count == 0
    }
    
    func noSearchResults() -> Bool {
        return currentCategories.isEmpty
    }
    
    func getTracker(forIndexPath indexPath: IndexPath) -> Tracker {
        return currentCategories[indexPath.section].trackers[indexPath.row]
    }
    
    func getCategory(forIndexPath indexPath: IndexPath) -> TrackerCategory {
        return currentCategories[indexPath.section]
    }
    
    
    func reportToAnalyticService(event: AnaliticEvent, params : [AnyHashable : Any]) {
        analyticsService.report(event: event, params: params)
    }
    
    func deleteTracker(tracker: Tracker) {
        reportToAnalyticService(event: .click, params: ["screen" : "Main", "item" : "delete"])
        do {
            try trackerStore.deleteTracker(tracker: tracker)
            categories = self.trackerCategoryStore.categories
            updateMainScreen()
            NotificationCenter.default.post(name: .dataDidChange, object: nil)
        } catch {
            print("\(tracker.name) was not deleted")
        }
    }
    
    func pinTracker(tracker: Tracker) {
        do {
            try trackerStore.pinTracker(tracker: tracker)
            categories = trackerCategoryStore.categories
            updateMainScreen()
        } catch {
            print("\(tracker.name) was not pinned")
        }
    }
    
    func editTracker(tracker: TrackerInfoCell, category: TrackerCategory) {
        reportToAnalyticService(event: .click, params: ["screen" : "Main", "item" : "edit"])
        let viewModel = EditingViewModel(trackerInfo: TrackerInfoModel(
            id: tracker.id,
            name: tracker.name,
            color: tracker.color,
            emoji: tracker.emoji,
            schedule: tracker.schedule,
            category: category,
            daysCount: calculateTimesTrackerWasCompleted(id: tracker.id),
            isPinned: tracker.isPinned,
            state: tracker.state))
        viewModel.updateTrackerHandler = { [weak self] in
            guard let self = self else {return}
            
            self.categories = self.trackerCategoryStore.categories
            self.updateMainScreen()
            NotificationCenter.default.post(name: .dataDidChange, object: nil)
        }
        let vc = EditTrackerViewController(viewModel: viewModel)
        viewController?.presentViewController(vc: vc)
    }
    
    func datePickerWasChanged(date: Date) {
        currentDate = date
        updateMainScreen()
    }
    
    func filterButtonPressed() {
        reportToAnalyticService(event: .click, params: ["screen" : "Main", "item" : "filter"])
        let vc = FiltersViewController(selectedFilter: selectedFilter)
        vc.filterChangedHandler = { [weak self] filter in
            guard let self = self else {return}
            self.selectedFilter = filter
            if filter == Filters.todayTrackers {
                self.viewController?.datePicker.date = Date()
                self.currentDate = self.viewController?.datePicker.date ?? Date()
            }
            self.viewController?.placeHolder?.setupNoSearchResultsState()
            self.updateMainScreen()
        }
        viewController?.presentViewController(vc: vc)
    }
    
    func filterIsActive() -> Bool {
        !(selectedFilter == Filters.allTrackers)
    }
    
    func filterButtonShoulBeHidden() -> Bool {
        currentCategories.isEmpty && selectedFilter == Filters.allTrackers
    }
    
    //MARK: - Collection Updating
    func updateMainScreen() {
        currentCategories = filterCategoriesToShow(filter: selectedFilter)
        viewController?.updateCollectionView()
    }
    
    func updateCollectionAccordingToSearchBarResults(name: String) {
        currentCategories = []
        categories.forEach { category in
            let title = category.title
            let trackers = category.trackers.filter { tracker in
                tracker.name.contains(name)
            }
            
            if trackers.count > 0 {
                currentCategories.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
    }
    
    //MARK: - Filtering
    func filterCategoriesToShow(filter: Filters) -> [TrackerCategory] {
        switch filter {
        case .allTrackers:
            viewController?.placeHolder?.setupNoTrackersState()
            return filterPinnedTrackers(categories: filterCategoriesBySelectedDay())
        case .todayTrackers:
            viewController?.placeHolder?.setupNoTrackersState()
            return  filterPinnedTrackers(categories: filterCategoriesBySelectedDay())
        case .completedTrackers:
            viewController?.placeHolder?.setupNoSearchResultsState()
            return filterPinnedTrackers(categories: filterCategoriesByCompletion(isCompleted: true))
        case .uncompletedTrackers:
            viewController?.placeHolder?.setupNoSearchResultsState()
            return filterPinnedTrackers(categories: filterCategoriesByCompletion(isCompleted: false))
        }
    }
    
    func filterCategoriesBySelectedDay() -> [TrackerCategory] {
        var filteredCategories: [TrackerCategory] = []
        
        let weekdayInt = Calendar.current.component(.weekday, from: currentDate)
        let day = (weekdayInt == 1) ?  WeekDays(rawValue: 7) : WeekDays(rawValue: weekdayInt - 1)
        
        categories.forEach { category in
            let title = category.title
            let trackers = category.trackers.filter { tracker in
                tracker.schedule.contains(day!)
            }
            
            if !trackers.isEmpty {
                filteredCategories.append(TrackerCategory(title: title, trackers: trackers))
            }
        }
        
        return filteredCategories
    }
    
    func filterPinnedTrackers(categories: [TrackerCategory]) -> [TrackerCategory] {
        var filteredCategories: [TrackerCategory] = []
        pinnedTrackers = []
        categories.forEach { category in
            let pinned = category.trackers.filter {
                $0.isPinned
            }
            
            let notPinned = category.trackers.filter {
                !$0.isPinned
            }
            
            if pinned.count > 0 {
                pinnedTrackers.append(contentsOf: pinned)
            }
            if notPinned.count > 0 {
                filteredCategories.append(TrackerCategory(title: category.title, trackers: notPinned))
            }
        }
        if !pinnedTrackers.isEmpty {
            filteredCategories.insert(TrackerCategory(title: NSLocalizedString("pinned", comment: ""), trackers: pinnedTrackers), at: 0)
        }
        return filteredCategories
    }
    
    func filterCategoriesByCompletion(isCompleted: Bool) -> [TrackerCategory] {
        let categoriesToFilter = filterCategoriesBySelectedDay()
        var allCompletedTrackers: [TrackerCategory] = []
        var allUncompletedTrackers: [TrackerCategory] = []
        
        categoriesToFilter.forEach { category in
            let completed = category.trackers.filter {
                checkIfTrackerWasCompletedAtCurrentDay(id: $0.id, date: currentDate)
            }
            let uncompleted = category.trackers.filter {
                !checkIfTrackerWasCompletedAtCurrentDay(id: $0.id, date: currentDate)
            }
            if !completed.isEmpty {
                allCompletedTrackers.append(TrackerCategory(title: category.title, trackers: completed))
            }
            if !uncompleted.isEmpty {
                allUncompletedTrackers.append(TrackerCategory(title: category.title, trackers: uncompleted))
            }
        }
        
        if isCompleted {
            return allCompletedTrackers
        } else {
            return allUncompletedTrackers
        }
    }
    
}

//MARK: - TrackerStoreDelegate
extension TrackerPresenter: TrackerStoreDelegate {
    func store(insertedIndexes: [IndexPath], deletedIndexes: IndexSet) {
        categories = trackerCategoryStore.categories
        updateMainScreen()
    }
}

//MARK: - TrackerRecordStoreDelegate
extension TrackerPresenter: TrackerRecordStoreDelegate {
    func recordUpdate() {
        completedTrackers = trackerRecordStore.completedTrackers
    }
}

extension TrackerPresenter: TrackerCreationDelegate {
    func createTracker(tracker: Tracker, category: String) {
        try? trackerStore.addNewTracker(tracker: tracker, forCategory: category)
    }
}

//MARK: - TrackerCounterDelegate
extension TrackerPresenter: TrackerCounterDelegate {
    func calculateTimesTrackerWasCompleted(id trackerId: UUID) -> Int {
        let contains = completedTrackers.filter {
            $0.id == trackerId
        }
        return contains.count
    }
    
    func checkIfTrackerWasCompletedAtCurrentDay(id trackerId: UUID, date: Date) -> Bool {
        let contains = completedTrackers.filter {
            ($0.id == trackerId && Calendar.current.isDate($0.date, equalTo: currentDate, toGranularity: .day))
        }.count > 0
        return contains
    }
    
    func increaseTrackerCounter(id trackerId: UUID, date: Date) {
        try? trackerRecordStore.addRecord(trackerId: trackerId, date: date)
    }
    
    func decreaseTrackerCounter(id trackerId: UUID, date: Date) {
        try? trackerRecordStore.deleteRecord(trackerId: trackerId, date: date)
    }
}


