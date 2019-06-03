import Swinject
import SwinjectAutoregistration

struct PostDetailsAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(
            PostDetailsUseCase.self,
            initializer: PostDetailsUseCaseDefault.init(
                postForIdLocalRepository:
                userForPostIdLocalRepository:
                numberOfCommentsForPostIdLocalRepository:
            )
        )
        container.autoregister(
            PostDetailsViewModel.self,
            initializer: PostDetailsViewModelDefault
                .init(useCase:postIdStore:scheduler:)
        )
        container.autoregister(
            PostDetailsViewController.self,
            initializer: PostDetailsViewController.init(viewModel:)
        )
    }
}
