import RxSwift

struct PostListUseCaseDefault {

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
        localRepositoryRefresher
            .localRepositoryStateStartingWithReloading(on: scheduler)
            .flatMap(Self.stateFromLocalRepositoryState(with: allPostsLocalRepository))
    }

    private static func stateFromLocalRepositoryState(
        with allPostsLocalRepository: AllPostsLocalRepositoryRx)
        -> (LocalRepositoryState) -> Observable<PostList.UseCaseState> {

        { localRepositoryState in
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

        isPreviousDataAvailable
            ? allPostsLocalRepository.allPosts
                .map(PostList.UseCaseState.reloadingFailed(oldPosts:))
                .asObservable()
            : .just(.loadingFromScratchFailed)
    }

    private static func stateFromReady(
        _ isLocalDataAvailable: Bool,
        with allPostsLocalRepository: AllPostsLocalRepositoryRx) -> Observable<PostList.UseCaseState> {

        isLocalDataAvailable
            ? allPostsLocalRepository.allPosts
                .map(PostList.UseCaseState.ready(posts:))
                .asObservable()
            : .just(.readyForLoadingFromScratch)
    }
}
