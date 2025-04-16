import Foundation
import UIKit

final class TrackersViewController: UIViewController, TrackerSettingsViewControllerDelegate {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: "header",
            for: indexPath) as? SupplementaryView else {
            return UICollectionReusableView()
        }
        
       
        guard indexPath.section < visibleCategories.count else {
            header.titleLabel.text = "ljjlkhk"
            return header
        }
        
        header.titleLabel.text = visibleCategories[indexPath.section].category
        return header
    }
    
    private let datePicker = UIDatePicker()
    private var currentDate = Date()
    private var categories = [TrackerCategory]()
    private var visibleCategories = [TrackerCategory]()
    private var completedTrackers = Set<TrackerRecord>()
    private let weekdays = ["Воскресенье", "Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота" ]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadInitialData()
    }
    
   
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        configureNavigationBar()
        setupCollectionView()
        setupConstraints()
    }
    
    private func configureNavigationBar() {
        title = "Трекеры"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(addTrackerButtonTapped)
        )
        
        datePicker.preferredDatePickerStyle = .compact
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
    }
    
    private func setupCollectionView() {
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.register(SupplementaryView.self,
                              forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                              withReuseIdentifier: "header")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
    }
    
    private func loadInitialData() {
      
        updateVisibleTrackers()
    }
    
    
    @objc private func addTrackerButtonTapped() {
        let createVC = MakeTrackerViewController()
        createVC.trackersViewController = self
        present(createVC, animated: true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        currentDate = sender.date
        updateVisibleTrackers()
    }
    
    
    
    private func updateVisibleTrackers() {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: currentDate) - 1
        var filteredTrackers = [Tracker]()
        
        for category in categories {
            for tracker in category.trackers {
                if let schedule = tracker.calendar {
                    if schedule.contains(where: { weekdays.firstIndex(of: $0.rawValue) == weekday }) {
                        filteredTrackers.append(tracker)
                    }
                } else if let date = tracker.date, calendar.isDate(date, inSameDayAs: currentDate) {
                    filteredTrackers.append(tracker)
                }
            }
        }
        
      
        visibleCategories = filteredTrackers.isEmpty ? [] : [
            TrackerCategory(category: "Активные трекеры", trackers: filteredTrackers)
        ]
        
        
        collectionView.reloadData()
        collectionView.isHidden = visibleCategories.isEmpty
    }
    
    
    
    private func isTrackerCompleted(trackerId: UUID) -> Bool {
        completedTrackers.contains { $0.id == trackerId && $0.date == currentDate }
    }
    
    private func formatDaysString(numberOfDays: Int) -> String {
        let lastDigit = numberOfDays % 10
        let lastTwoDigits = numberOfDays % 100
        
        if numberOfDays == 0 || (lastTwoDigits >= 11 && lastTwoDigits <= 19) {
            return "\(numberOfDays) дней"
        } else if lastDigit == 1 {
            return "\(numberOfDays) день"
        } else if (2...4).contains(lastDigit) {
            return "\(numberOfDays) дня"
        } else {
            return "\(numberOfDays) дней"
        }
    }
    
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visibleCategories.first?.trackers.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = visibleCategories[indexPath.section].trackers[indexPath.item]
        let isCompleted = isTrackerCompleted(trackerId: tracker.id)
        let canComplete = Calendar.current.compare(Date(), to: currentDate, toGranularity: .day) != .orderedAscending
        
        cell.configure(
            with: tracker,
            isCompleted: isCompleted,
            daysCompleted: completedTrackers.filter { $0.id == tracker.id }.count,
            canComplete: canComplete
        )
        cell.delegate = self
        
        return cell
    }
}


extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 167, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}


extension TrackersViewController: TrackerCellDelegate {
    func didTapDoneButton(isCompleted: Bool, trackerId: UUID) {
        collectionView.performBatchUpdates {
            if isCompleted {
                completedTrackers.insert(TrackerRecord(id: trackerId, date: currentDate))
            } else {
                completedTrackers.remove(TrackerRecord(id: trackerId, date: currentDate))
            }
        }
    }
}


extension TrackersViewController {
    func addTracker(category: String, tracker: Tracker) {
        dismiss(animated: true)
        
        categories = categories.map { existingCategory in
            if existingCategory.category == category {
                var trackers = existingCategory.trackers
                trackers.append(tracker)
                return TrackerCategory(category: category, trackers: trackers)
            }
            return existingCategory
        }
        
        if !categories.contains(where: { $0.category == category }) {
            categories.append(TrackerCategory(category: category, trackers: [tracker]))
        }
        
            updateVisibleTrackers()
        }
}


