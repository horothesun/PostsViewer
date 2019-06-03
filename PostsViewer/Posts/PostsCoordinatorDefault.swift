import UIKit
import Swinject
import SwinjectAutoregistration

final class PostsCoordinatorDefault {

    private lazy var postListViewController: PostListViewController = resolver~>

    private weak var navigationController: UINavigationController?
    private var completionHandler: (() -> Void)?

    private let resolver: Resolver

    init(resolver: Resolver) { self.resolver = resolver }
}

extension PostsCoordinatorDefault: PostsCoordinator {

    func start(
        from navigationController: UINavigationController,
        completionHandler: @escaping () -> Void) {

        self.navigationController = navigationController
        self.completionHandler = completionHandler

        self.navigationController?.viewControllers = [postListViewController]
    }
}

extension PostsCoordinatorDefault: PostListCoordinator {

    func proceedToPostDetails() {
        let postDetailsViewController: PostDetailsViewController = resolver~>
        navigationController?.pushViewController(postDetailsViewController, animated: true)
    }
}
