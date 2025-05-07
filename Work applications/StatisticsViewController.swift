import UIKit
import SwiftUI

// MARK: - Preview
struct StatisticViewControllerPreview: PreviewProvider {
    static var previews: some View {
        StatisticViewController().showPreview()
    }
}

extension Notification.Name {
    static let dataDidChange = Notification.Name("dataDidChange")
}

final class StatisticViewController: UIViewController, ViewConfigurable {
    // MARK: - Private Properties
    private let customNavigationBar: UIView = {
        let navigationBar = UIView()
        navigationBar.backgroundColor = .backgroudColor
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        return navigationBar
    }()
    
    private let statisticCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 12 // Расстояние между строками
        layout.minimumInteritemSpacing = 12 // Расстояние между ячейками в строке
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 32, height: 90) // Ширина и высота ячейки
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .backgroudColor
        collectionView.layer.cornerRadius = 16
        collectionView.layer.masksToBounds = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private let trackerRecordStore = TrackerRecordStore()
    
    // MARK: - Computed Properties
    private var score: Int {
        return calculateCompletedTrackers()
    }
    
    private var bestPeriod: Int {
        return trackerRecordStore.bestPeriod
    }
    
    private var perfectDays: Int {
        return trackerRecordStore.perfectDays
    }
    
    private var averageTrackersPerDay: Double {
        return trackerRecordStore.averageTrackersPerDay
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .backgroudColor
        statisticCollectionView.dataSource = self
        statisticCollectionView.register(StatisticsTableCell.self, forCellWithReuseIdentifier: StatisticsTableCell.identifier)
        
        setupView()
        updateViewAccordingToScore()
        
        NotificationCenter.default.addObserver(self, selector: #selector(dataDidChange), name: .dataDidChange, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Private Methods
    private func updateData() {
        statisticCollectionView.reloadData()
        updateViewAccordingToScore()
    }
    
    @objc private func dataDidChange() {
        updateData()
    }
    
    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        let subViews = [customNavigationBar, statisticCollectionView]
        subViews.forEach { view.addSubview($0) }
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            customNavigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            customNavigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customNavigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customNavigationBar.heightAnchor.constraint(equalToConstant: 182),
            
            statisticCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statisticCollectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 206),
            statisticCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            statisticCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupView() {
        setupNavigationBar()
        configureView()
    }
    
    private func setupNavigationBar() {
        navigationItem.title = NSLocalizedString("statistics", comment: "")
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func showPlaceHolder() {
        let backgroundView = PlaceHolderView(frame: statisticCollectionView.frame)
        backgroundView.setupNoStatisticState()
        statisticCollectionView.backgroundView = backgroundView
    }
    
    private func calculateCompletedTrackers() -> Int {
        guard let result = try? trackerRecordStore.calculateCompletedTrackers() else {
            return .zero
        }
        return result
    }
    
    private func updateViewAccordingToScore() {
        if score == 0 {
            showPlaceHolder()
        } else {
            statisticCollectionView.backgroundView = nil
        }
        statisticCollectionView.reloadData()
    }
}

// MARK: - UICollectionViewDataSource
extension StatisticViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return score == 0 ? 0 : 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StatisticsTableCell.identifier, for: indexPath) as? StatisticsTableCell else {
            return UICollectionViewCell()
        }
        cell.prepareForReuse()
        
        switch indexPath.row {
        case 0:
            cell.setNameLabel(with: "best_period")
            cell.setScore(with: bestPeriod)
        case 1:
            cell.setNameLabel(with: "pefect_days")
            cell.setScore(with: perfectDays)
        case 2:
            cell.setNameLabel(with: "stat.completed")
            cell.setScore(with: score)
        case 3:
            cell.setNameLabel(with: "average_value")
            cell.setScore(with: Int(averageTrackersPerDay))
        default:
            break
        }
        return cell
    }
}

