import UIKit
import Swinject
import SwinjectAutoregistration

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    private var resolver: Resolver { return AssemblyCenter.shared.container.resolver }

    private(set) var window: UIWindow?
    private lazy var mainNavigationController = UINavigationController(nibName: nil, bundle: nil)
    private lazy var postsCoordinator: PostsCoordinator = resolver~>

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        guard let window = window else { return true }

        window.rootViewController = mainNavigationController
        window.makeKeyAndVisible()

        postsCoordinator.start(from: mainNavigationController) { /* do nothing */ }

        return true
    }
}
