import RxSwift
import RxCocoa

protocol PostListUseCase {
    func refresh()
    func state(on scheduler: SchedulerType) -> Observable<PostList.UseCaseState>
}

protocol PostListViewModel {
    var staticInfo: Driver<PostList.StaticInfo> { get }
    var cellDisplayModels: Driver<[PostList.CellDisplayModel]> { get }
    var isRefreshButtonEnabled: Driver<Bool> { get }
    var isActivityIndicatorVisible: Driver<Bool> { get }
    var doesTableViewAllowSelection: Driver<Bool> { get }

    func onDidBindToAllDrivers(view: PostListView)
}

protocol PostListCellDisplayModelBuilder {
    var fatalErrorCellDisplayModels: [PostList.CellDisplayModel] { get }
    var errorLoadingFromScratchCellDisplayModels: [PostList.CellDisplayModel] { get }
    func failedReloadCellDisplayModels(from oldPosts: [Post]) -> [PostList.CellDisplayModel]
    func cellDisplayModels(from posts: [Post]) -> [PostList.CellDisplayModel]
}

protocol PostListView {
    var refreshTap: Observable<Void> { get }
    var cellDisplayModelTap: Observable<PostList.CellDisplayModel> { get }
}

protocol PostListCoordinator: class {
    func proceedToPostDetails()
}
