import RxSwift
import RxSwiftExt
import RxCocoa

final class PostListViewModelDefault {

    private typealias ViewModel = PostListViewModelDefault

    private let stateSubject = PublishSubject<PostList.UseCaseState>()
    private let disposeBag = DisposeBag()

    private let useCase: PostListUseCase
    private let cellDisplayModelBuilder: PostListCellDisplayModelBuilder
    private let postIdStore: PostIdStore
    private weak var coordinator: PostListCoordinator?
    private let scheduler: SchedulerType

    init(
        useCase: PostListUseCase,
        cellDisplayModelBuilder: PostListCellDisplayModelBuilder,
        postIdStore: PostIdStore,
        coordinator: PostListCoordinator,
        scheduler: SchedulerType) {

        self.useCase = useCase
        self.cellDisplayModelBuilder = cellDisplayModelBuilder
        self.postIdStore = postIdStore
        self.coordinator = coordinator
        self.scheduler = scheduler
    }
}

extension PostListViewModelDefault: PostListViewModel {

    var staticInfo: Driver<PostList.StaticInfo> {
        let title = NSLocalizedString(
            "Posts.List.title",
            comment: "Post list screen title"
        )
        let refreshButtonTitle = NSLocalizedString(
            "Posts.List.RefreshButton.title",
            comment: "Refresh button title"
        )
        return .just(.init(title: title, refreshButtonTitle: refreshButtonTitle))
    }

    var cellDisplayModels: Driver<[PostList.CellDisplayModel]> {
        return stateSubject
            .apply(ViewModel.cellDisplayModelsFromState(with: cellDisplayModelBuilder))
            .startWith([])
            .asDriver(onErrorJustReturn: cellDisplayModelBuilder.fatalErrorCellDisplayModels)
    }

    var isRefreshButtonEnabled: Driver<Bool> {
        return stateSubject
            .apply(ViewModel.isLoadingFromState)
            .map { !$0 }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
    }

    var isActivityIndicatorVisible: Driver<Bool> {
        return stateSubject
            .apply(ViewModel.isLoadingFromState)
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
    }

    var doesTableViewAllowSelection: Driver<Bool> {
        return stateSubject
            .apply(ViewModel.isLoadingFromState)
            .map { !$0 }
            .startWith(false)
            .asDriver(onErrorJustReturn: false)
    }

    func onDidBindToAllDrivers(view: PostListView) {
        view.refreshTap
            .subscribe(onNext: { [useCase] in useCase.refresh() })
            .disposed(by: disposeBag)

        view.cellDisplayModelTap
            .apply(ViewModel.keepPostCellDisplayModelTapOnly)
            .map { $0.id }
            .subscribe(weak: self, onNext: ViewModel.proceedToPostDetails(postId:))
            .disposed(by: disposeBag)

        useCase.state(on: scheduler)
            .bind(to: stateSubject)
            .disposed(by: disposeBag)
    }

    private static func cellDisplayModelsFromState(
        with cellDisplayModelBuilder: PostListCellDisplayModelBuilder)
        -> (Observable<PostList.UseCaseState>) -> Observable<[PostList.CellDisplayModel]> {

        return { upstream in
            upstream.filterMap { state -> FilterMap<[PostList.CellDisplayModel]> in
                switch state {
                case .loadingFromScratch,
                     .reloading,
                     .inconsistencyFailure,
                     .readyForLoadingFromScratch:
                    return .ignore
                case .loadingFromScratchFailed:
                    return .map(cellDisplayModelBuilder.errorLoadingFromScratchCellDisplayModels)
                case let .reloadingFailed(oldPosts):
                    return .map(cellDisplayModelBuilder.failedReloadCellDisplayModels(from: oldPosts))
                case let .ready(posts):
                    return .map(cellDisplayModelBuilder.cellDisplayModels(from: posts))
                }
            }
        }
    }

    private static var isLoadingFromState: (Observable<PostList.UseCaseState>) -> Observable<Bool> {

        return { upstream in
            upstream.map { state -> Bool in
                switch state {
                case .loadingFromScratch,
                     .reloading:
                    return true
                case .loadingFromScratchFailed,
                     .reloadingFailed,
                     .inconsistencyFailure,
                     .readyForLoadingFromScratch,
                     .ready:
                    return false
                }
            }
        }
    }

    private static var keepPostCellDisplayModelTapOnly:
        (Observable<PostList.CellDisplayModel>) -> Observable<PostList.CellDisplayModel.Post> {

        return { upstream in
            upstream.filterMap { cellDisplayModel -> FilterMap<PostList.CellDisplayModel.Post> in
                switch cellDisplayModel {
                case .noData:                         return .ignore
                case let .post(postCellDisplayModel): return .map(postCellDisplayModel)
                }
            }
        }
    }

    private func proceedToPostDetails(postId: Post.Id) {
        postIdStore.postId = postId
        coordinator?.proceedToPostDetails()
    }
}
