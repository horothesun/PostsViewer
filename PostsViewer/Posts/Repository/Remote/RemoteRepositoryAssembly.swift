import Swinject
import SwinjectAutoregistration

struct RemoteRepositoryAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(
            PostRemoteRepository.self,
            initializer: PostRemoteRepositoryHttp.init(httpFetcher:environment:)
        )
        container.autoregister(
            UserRemoteRepository.self,
            initializer: UserRemoteRepositoryHttp.init(httpFetcher:environment:)
        )
        container.autoregister(
            CommentRemoteRepository.self,
            initializer: CommentRemoteRepositoryHttp.init(httpFetcher:environment:)
        )
        container.autoregister(
            AllDataRemoteRepository.self,
            initializer: AllDataRemoteRepositoryHttp
                .init(postRemoteRepository:userRemoteRepository:commentRemoteRepository:)
        )
    }
}
