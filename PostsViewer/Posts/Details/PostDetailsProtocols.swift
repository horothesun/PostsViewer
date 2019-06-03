import RxSwift
import RxCocoa

protocol PostDetailsUseCase {
    func responseFor(postId: Post.Id) -> Single<PostDetails.UseCaseResponse>
}

protocol PostDetailsViewModel {
    var title: Driver<String> { get }

    var postTitle: Driver<String> { get }
    var postDescription: Driver<String> { get }
    var author: Driver<String> { get }
    var numberOfComments: Driver<String> { get }

    func onDidBindToAllDrivers()
}
