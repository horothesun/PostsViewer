import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class PostDetailsViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.alwaysBounceVertical = false
        return scrollView
    }()
    private lazy var containerView = UIView(color: .clear)
    private lazy var postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 11)
        label.textColor = .lightGray
        return label
    }()
    private lazy var postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()
    private lazy var numberOfCommentsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        return label
    }()

    private let disposeBag = DisposeBag()

    private let viewModel: PostDetailsViewModel

    init(viewModel: PostDetailsViewModel) {
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
        [postTitleLabel, authorLabel, postDescriptionLabel, numberOfCommentsLabel]
            .forEach(containerView.addSubview(_:))
        scrollView.addSubview(containerView)
        view.addSubview(scrollView)
    }

    private func configureLayout() {
        postTitleLabel.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(15)
        }
        authorLabel.snp.makeConstraints { make in
            make.top.equalTo(postTitleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
        }
        postDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(authorLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(15)
        }
        numberOfCommentsLabel.snp.makeConstraints { make in
            make.top.equalTo(postDescriptionLabel.snp.bottom).offset(10)
            make.right.bottom.equalToSuperview().inset(15)
        }
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(view)
        }
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.right.equalToSuperview()
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
        viewModel.title.asObservable()
            .bind(to: rx.title)
            .disposed(by: disposeBag)

        viewModel.postTitle.asObservable()
            .bind(to: postTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.author.asObservable()
            .bind(to: authorLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.postDescription.asObservable()
            .bind(to: postDescriptionLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.numberOfComments.asObservable()
            .bind(to: numberOfCommentsLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.onDidBindToAllDrivers()
    }
}
