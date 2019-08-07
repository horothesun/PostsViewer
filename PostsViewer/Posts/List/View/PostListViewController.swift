import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PostListViewController: UIViewController {

    private typealias View = PostListViewController

    private lazy var refreshBarButton = UIBarButtonItem()
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView(color: .white)
        tableView.backgroundColor = .white
        tableView.contentInset = .zero
        tableView.alwaysBounceVertical = false
        tableView.registerReusableCell(PostTableViewCell.self)
        tableView.registerReusableCell(NoDataTableViewCell.self)
        return tableView
    }()

    private let disposeBag = DisposeBag()

    private let viewModel: PostListViewModel

    init(viewModel: PostListViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViewHierarchy()
        configureLayout()
        configureViews()
        configureBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureNavigationBar()
    }

    private func configureViewHierarchy() {
        view.addSubview(tableView)
    }

    private func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
    }

    private func configureViews() {
        view.backgroundColor = .white
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .darkGray
        navigationItem.leftBarButtonItem?.tintColor = .darkGray
    }

    private func configureBindings() {
        viewModel.staticInfo
            .driveNext(weak: self, View.configure(staticInfo:))
            .disposed(by: disposeBag)

        viewModel.cellDisplayModels.asObservable()
            .bind(
                to: tableView.rx.items,
                curriedArgument: View.tableView(_:at:renderCellDisplayModel:)
            )
            .disposed(by: disposeBag)

        viewModel.isRefreshButtonEnabled.asObservable()
            .bind(to: refreshBarButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.isActivityIndicatorVisible
            .driveNext(weak: self, View.configure(isActivityIndicatorVisible:))
            .disposed(by: disposeBag)

        viewModel.doesTableViewAllowSelection
            .driveNext(weak: self, View.configure(doesTableViewAllowSelection:))
            .disposed(by: disposeBag)

        viewModel.onDidBindToAllDrivers(view: self)
    }

    private func configure(staticInfo: PostList.StaticInfo) {
        title = staticInfo.title
        refreshBarButton.title = staticInfo.refreshButtonTitle
    }

    private static func tableView(
        _ tableView: UITableView,
        at row: Int,
        renderCellDisplayModel cellDisplayModel: PostList.CellDisplayModel) -> UITableViewCell {

        let indexPath = IndexPath(row: row, section: 0)
        switch cellDisplayModel {
        case let .noData(cellDisplayModel):
            let cell: NoDataTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.apply(cellDisplayModel: cellDisplayModel)
            return cell
        case let .post(cellDisplayModel):
            let cell: PostTableViewCell = tableView.dequeueReusableCell(indexPath: indexPath)
            cell.apply(cellDisplayModel: cellDisplayModel)
            return cell
        }
    }

    private func configure(isActivityIndicatorVisible: Bool) {
        navigationItem.rightBarButtonItem = isActivityIndicatorVisible
            ? View.activityIndicatorBarButton()
            : refreshBarButton
    }

    private static func activityIndicatorBarButton() -> UIBarButtonItem {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.startAnimating()
        return UIBarButtonItem(customView: activityIndicatorView)
    }

    private func configure(doesTableViewAllowSelection: Bool) {
        tableView.allowsSelection = doesTableViewAllowSelection
    }
}

extension PostListViewController: PostListView {

    var refreshTap: Observable<Void> { refreshBarButton.rx.tap.asObservable() }

    var cellDisplayModelTap: Observable<PostList.CellDisplayModel> {
        tableView.rx.modelSelected(PostList.CellDisplayModel.self).asObservable()
    }
}
