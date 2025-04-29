import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        generateTabBar()
    }
    
    private func generateTabBar() {
        let navigationViewController = UINavigationController(rootViewController: TrackerViewController())
        tabBar.tintColor = .tabBarAccentIcon
        tabBar.unselectedItemTintColor = .unselectedTabBarIcon
        viewControllers = [
            generateVC(viewController: navigationViewController,
                       title: "Трекеры",
                       image: UIImage(named: "statisticIcon")
                      ),
            generateVC(viewController: StatisticViewController(),
                       title: "Статистика",
                       image: UIImage(named: "TrackersTabBarIcon")
                      )
        ]
    }
    
    private func generateVC(viewController: UIViewController, title: String, image: UIImage?) -> UIViewController {
        viewController.tabBarItem.title = title
        viewController.tabBarItem.image = image
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .medium)]
        viewController.tabBarItem.setTitleTextAttributes(attributes, for: .normal)
        viewController.tabBarItem.setTitleTextAttributes(attributes, for: .selected)
        
        return viewController
    }
    
}

