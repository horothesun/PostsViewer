import Swinject
import SwinjectAutoregistration

struct SynchronisationRepositoryAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(
            SynchronisationRepositoryRx.self,
            initializer: SynchronisationRepositoryRxAdapter.init(adapting:)
        )
        container.autoregister(
            SynchronisationRepositoryThrowable.self,
            initializer: SynchronisationRepositoryThrowableRealm.init(environment:)
        )
    }
}
