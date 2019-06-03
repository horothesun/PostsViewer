import Swinject
import SwinjectAutoregistration

struct LocalRepositoryAssembly: Assembly {

    func assemble(container: Container) {

        container.autoregister(
            LocalRepositoryRefresher.self,
            initializer: LocalRepositoryRefresherDefault
                .init(allDataRemoteRepository:localRepositoryWriter:synchronisationRepository:)
        ).inObjectScope(.container)

        container.autoregister(
            AllPostsLocalRepositoryRx.self,
            initializer: AllPostsLocalRepositoryRxAdapter.init(adapting:)
        )
        container.autoregister(
            AllPostsLocalRepositoryThrowable.self,
            initializer: AllPostsLocalRepositoryThrowableRealm.init(environment:)
        )
        container.autoregister(
            PostForIdLocalRepositoryRx.self,
            initializer: PostForIdLocalRepositoryRxAdapter.init(adapting:)
        )
        container.autoregister(
            PostForIdLocalRepositoryThrowable.self,
            initializer: PostForIdLocalRepositoryThrowableRealm.init(environment:)
        )
        container.autoregister(
            UserForPostIdLocalRepositoryRx.self,
            initializer: UserForPostIdLocalRepositoryRxAdapter.init(adapting:)
        )
        container.autoregister(
            UserForPostIdLocalRepositoryThrowable.self,
            initializer: UserForPostIdLocalRepositoryThrowableRealm.init(environment:)
        )
        container.autoregister(
            NumberOfCommentsForPostIdLocalRepositoryRx.self,
            initializer: NumberOfCommentsForPostIdLocalRepositoryRxAdapter.init(adapting:)
        )
        container.autoregister(
            NumberOfCommentsForPostIdLocalRepositoryThrowable.self,
            initializer: NumberOfCommentsForPostIdLocalRepositoryThrowableRealm.init(environment:)
        )
        container.autoregister(
            LocalRepositoryWriterRx.self,
            initializer: LocalRepositoryWriterRxAdapter.init(adapting:)
        )
        container.autoregister(
            LocalRepositoryWriterThrowable.self,
            initializer: LocalRepositoryWriterThrowableRealm
                .init(localRealmObjectsMapper:environment:)
        )
        container.autoregister(
            LocalRealmObjectsMapper.self,
            initializer: LocalRealmObjectsMapperDefault.init
        )
    }
}
