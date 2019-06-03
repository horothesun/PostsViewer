import Swinject
import SwinjectAutoregistration
import UIKit
import RxSwift

final class AssemblyCenter {

    static let shared = AssemblyCenter()

    private(set) lazy var container = Assembler(
        baseAssembly,
        HttpClientAssembly(),
        RepositoryModule.assembly,
        PostsModule.assembly
    )

    private let baseAssembly: Assembly = assemblyFrom { container in
        container.register(Resolver.self) { _ in
            AssemblyCenter.shared.container.resolver
        }.inObjectScope(.container)

        container.autoregister(Environment.self, initializer: CurrentEnvironment.init)
            .inObjectScope(.container)

        container.register(SchedulerType.self) { _ in
            ConcurrentDispatchQueueScheduler(qos: .userInitiated)
        }.inObjectScope(.transient)
    }
}
