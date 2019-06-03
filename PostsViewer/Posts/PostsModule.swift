import Swinject
import SwinjectAutoregistration
import UIKit

enum PostsModule {

    static let assembly = composedAssembly(from:
        coordinatorAssembly,
        storesAssembly,
        PostListAssembly(),
        PostDetailsAssembly()
    )

    private static let coordinatorAssembly = assemblyFrom { container in
        container
            .register(
                PostsCoordinator.self,
                factory: PostsCoordinatorDefault.init(resolver:)
            )
            .implements(PostListCoordinator.self)
            .inObjectScope(.weak)
    }

    private static let storesAssembly = assemblyFrom { container in
        container
            .autoregister(PostIdStore.self, initializer: PostIdStoreDefault.init)
            .inObjectScope(.weak)
    }
}
