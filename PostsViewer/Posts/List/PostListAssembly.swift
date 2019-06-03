import Swinject
import SwinjectAutoregistration

struct PostListAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(
            PostListUseCase.self,
            initializer: PostListUseCaseDefault
                .init(localRepositoryRefresher:allPostsLocalRepository:)
        )
        container.autoregister(
            PostListCellDisplayModelBuilder.self,
            initializer: PostListCellDisplayModelBuilderDefault.init
        )
        container.autoregister(
            PostListViewModel.self,
            initializer: PostListViewModelDefault
                .init(useCase:cellDisplayModelBuilder:postIdStore:coordinator:scheduler:)
        )
        container.autoregister(
            PostListViewController.self,
            initializer: PostListViewController.init(viewModel:)
        )
    }
}
