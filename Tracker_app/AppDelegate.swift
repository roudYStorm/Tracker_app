import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?
    
   
    func application(_ app: UIApplication,
                    didFinishLaunchingWithOptions opts: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupAppearanceConfiguration()
        return true
    }
    
    private func setupAppearanceConfiguration() {
    }
    
    
    func application(_ application: UIApplication,
                    configurationForConnecting connectingScene: UISceneSession,
                    options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        initializeRootWindow()
        return UISceneConfiguration(
            name: "Standard Configuration",
            sessionRole: connectingScene.role
        )
    }
    
    private func initializeRootWindow() {
        let newWindow = UIWindow(frame: UIScreen.main.bounds)
        newWindow.rootViewController = TabBarController()
        newWindow.makeKeyAndVisible()
        self.window = newWindow
    }
    
    func application(_ application: UIApplication,
                    didDiscardSceneSessions sessions: Set<UISceneSession>) {
    }
    
    
    lazy var dataStorageContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        
        container.loadPersistentStores { storeDetails, error in
            if let loadError = error as NSError? {
                fatalError("""
                Unresolved storage error:
                \(loadError.localizedDescription),
                \(loadError.userInfo)
                """)
            }
        }
        
        return container
    }()
    
    
    func saveContext() {
        let context = dataStorageContainer.viewContext
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch let saveError as NSError {
            fatalError("""
            Critical data saving failure:
            \(saveError.localizedDescription),
            \(saveError.userInfo)
            """)
        }
    }
}

