import RxSwift

struct PostListUseCaseDefault {

    private typealias UseCase = PostListUseCaseDefault

    private let localRepositoryRefresher: LocalRepositoryRefresher
    private let allPostsLocalRepository: AllPostsLocalRepositoryRx

    init(
        localRepositoryRefresher: LocalRepositoryRefresher,
        allPostsLocalRepository: AllPostsLocalRepositoryRx) {

        self.localRepositoryRefresher = localRepositoryRefresher
        self.allPostsLocalRepository = allPostsLocalRepository
    }
}

extension PostListUseCaseDefault: PostListUseCase {

    func refresh() { localRepositoryRefresher.refresh() }

    func state(on scheduler: SchedulerType) -> Observable<PostList.UseCaseState> {
        return localRepositoryRefresher
            .localRepositoryStateStartingWithReloading(on: scheduler)
            .flatMap(UseCase.stateFromLocalRepositoryState(with: allPostsLocalRepository))
    }

    private static func stateFromLocalRepositoryState(
        with allPostsLocalRepository: AllPostsLocalRepositoryRx)
        -> (LocalRepositoryState) -> Observable<PostList.UseCaseState> {

        return { localRepositoryState in
            switch localRepositoryState {
            case let .loading(isPreviousDataAvailable):
                return .just(isPreviousDataAvailable ? .reloading : .loadingFromScratch)
            case let .failure(isPreviousDataAvailable):
                return stateFromFailure(isPreviousDataAvailable, with: allPostsLocalRepository)
            case .failureWithInconsistentState:
                return .just(.inconsistencyFailure)
            case let .ready(isLocalDataAvailable):
                return stateFromReady(isLocalDataAvailable, with: allPostsLocalRepository)
            }
        }
    }

    private static func stateFromFailure(
        _ isPreviousDataAvailable: Bool,
        with allPostsLocalRepository: AllPostsLocalRepositoryRx) -> Observable<PostList.UseCaseState> {

        return isPreviousDataAvailable
            ? allPostsLocalRepository.allPosts
                .map(PostList.UseCaseState.reloadingFailed(oldPosts:))
                .asObservable()
            : .just(.loadingFromScratchFailed)
    }

    private static func stateFromReady(
        _ isLocalDataAvailable: Bool,
        with allPostsLocalRepository: AllPostsLocalRepositoryRx) -> Observable<PostList.UseCaseState> {

        return isLocalDataAvailable
            ? allPostsLocalRepository.allPosts
                .map(PostList.UseCaseState.ready(posts:))
                .asObservable()
            : .just(.readyForLoadingFromScratch)
    }
}
