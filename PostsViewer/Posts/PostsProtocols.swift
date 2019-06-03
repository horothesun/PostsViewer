import UIKit

protocol PostsCoordinator: class {
    func start(
        from navigationController: UINavigationController,
        completionHandler: @escaping () -> Void
    )
}

protocol PostIdStore: class {
    var postId: Post.Id { get set }
}
