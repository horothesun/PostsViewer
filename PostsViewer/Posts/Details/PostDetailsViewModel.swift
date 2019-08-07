import RxSwift
import RxCocoa

final class PostDetailsViewModelDefault {

    private let displayModelSubject = PublishSubject<PostDetails.DisplayModel>()
    private let disposeBag = DisposeBag()

    private let useCase: PostDetailsUseCase
    private let postIdStore: PostIdStore
    private let scheduler: SchedulerType

    init(
        useCase: PostDetailsUseCase,
        postIdStore: PostIdStore,
        scheduler: SchedulerType) {

        self.useCase = useCase
        self.postIdStore = postIdStore
        self.scheduler = scheduler
    }
}

extension PostDetailsViewModelDefault: PostDetailsViewModel {

    var title: Driver<String> {
        let title = NSLocalizedString(
            "Posts.Details.title",
            comment: "Post details screen title"
        )
        return .just(title)
    }

    var postTitle: Driver<String> {
        displayModelSubject
            .map { $0.postTitle }
            .asDriver(onErrorJustReturn: Self.errorPlaceholder)
    }

    var postDescription: Driver<String> {
        displayModelSubject
            .map { $0.postDescription }
            .asDriver(onErrorJustReturn: Self.errorPlaceholder)
    }

    var author: Driver<String> {
        displayModelSubject
            .map { $0.author }
            .asDriver(onErrorJustReturn: Self.errorPlaceholder)
    }

    var numberOfComments: Driver<String> {
        displayModelSubject
            .map { $0.numberOfComments }
            .asDriver(onErrorJustReturn: Self.errorPlaceholder)
    }

    func onDidBindToAllDrivers() {
        useCase.responseFor(postId: postIdStore.postId)
            .map(Self.displayModelFrom(response:))
            .subscribeOn(scheduler)
            .asObservable()
            .bind(to: displayModelSubject)
            .disposed(by: disposeBag)
    }

    private static func displayModelFrom(
        response: PostDetails.UseCaseResponse) -> PostDetails.DisplayModel {

        .init(
            postTitle: response.postTitle,
            postDescription: response.postDescription,
            author: authorTextFrom(name: response.authorName, username: response.authorUsername),
            numberOfComments: numberOfCommentsText(from: response.numberOfComments)
        )
    }

    private static func authorTextFrom(name: String, username: String) -> String {
        let authorLocalizedFormat = NSLocalizedString(
            "Posts.Details.authorNameAndUsername",
            comment: "Author name and username"
        )
        return String(format: authorLocalizedFormat, name, username)
    }

    private static func numberOfCommentsText(from numberOfComments: Int) -> String {
        switch numberOfComments {
        case 0:
            return NSLocalizedString(
                "Posts.Details.Comments.none",
                comment: "No comments"
            )
        case 1:
            return NSLocalizedString(
                "Posts.Details.Comments.one",
                comment: "One comment"
            )
        case 2...:
            let localizedFormat = NSLocalizedString(
                "Posts.Details.Comments.moreThanOne",
                comment: "More than one comment"
            )
            return String(format: localizedFormat, numberOfComments)
        default:
            return errorPlaceholder
        }
    }

    private static var errorPlaceholder: String {
        NSLocalizedString(
            "Posts.Details.Error.dataPlaceholder",
            comment: "Error data placeholder"
        )
    }
}
