import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
        setupViewControllers()
    }
    
    private func configureTabBarAppearance() {
        tabBar.tintColor = .yPblue
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .white
    }
    
    private func setupViewControllers() {
        let trackersVC = createTrackersViewController()
        let statisticsVC = createStatisticsViewController()
        
        viewControllers = [
            embedInNavigationController(trackersVC),
            statisticsVC
        ]
    }
    
    private func createTrackersViewController() -> UIViewController {
        let controller = TrackersViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(resource: .trackersTabBarIcon),
            tag: 0
        )
        return controller
    }
    
    private func createStatisticsViewController() -> UIViewController {
        let controller = StatisticsViewController()
        controller.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(resource: .statisticsTabBarItem),
            tag: 1
        )
        return controller
    }
    
    private func embedInNavigationController(_ controller: UIViewController) -> UINavigationController {
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}
