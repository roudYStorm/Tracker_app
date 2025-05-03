import UIKit

final class OnboardingViewController: UIPageViewController, ViewConfigurable {
    
    // MARK: - Public Properties
    lazy var pages: [UIViewController] = {
        let blue = SinglePageOnboardingViewController (
            text: "Отслеживайте только то, что хотите",
            imageTitle: "backgrBlue"
        )
        let red = SinglePageOnboardingViewController(
            text: "Даже если это не литры воды и йога",
            imageTitle: "backgrRed"
        )
        return [blue, red]
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 0.3024110099)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // MARK: - Private Properties
    private lazy var onboardingButton: UIButton = {
        let button = UIButton()
        button.setTitle("Вот это технологии!", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.titleLabel?.textColor = .white
        button.backgroundColor = #colorLiteral(red: 0.1352768838, green: 0.1420838535, blue: 0.1778985262, alpha: 1)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Public Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        if let first = pages.first {
            setViewControllers(
                [first],
                direction: .forward,
                animated: true,
                completion: nil
            )
        }
        configureView()
    }
    
    // MARK: - ViewConfigurable Methods
    func addSubviews() {
        let subViews = [onboardingButton, pageControl]
        subViews.forEach { view.addSubview($0) }
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            onboardingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            onboardingButton.heightAnchor.constraint(equalToConstant: 60),
            onboardingButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            onboardingButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            pageControl.bottomAnchor.constraint(equalTo: onboardingButton.topAnchor, constant: -24),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - IBAction
    @objc
    private func didTapButton() {
        let tabBarVC = TabBarController()
        guard let window = UIApplication.shared.windows.first
        else {
            fatalError("Invalid Configuration")
        }
        
        tabBarVC.tabBar.alpha = 0
        UIView.transition(
            with: window,
            duration: 0.6,
            options: UIView.AnimationOptions.curveEaseOut,
            animations: {
                window.rootViewController = tabBarVC
                tabBarVC.tabBar.alpha = 1
            })
    }
    
    // MARK: - Private Methods
    internal func  configureView() {
        addSubviews()
        addConstraints()
    }
}

// MARK: - DataSource
extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        var previousIndex = viewControllerIndex - 1
        
        if previousIndex < 0 {
            previousIndex = pages.count - 1
        }
        
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        var nextIndex = viewControllerIndex + 1
        
        if nextIndex >= pages.count  {
            nextIndex = 0
        }
        return pages[nextIndex]
    }
}

// MARK: - Delegate
extension OnboardingViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}

