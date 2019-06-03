import RxSwift

struct PostDetailsUseCaseDefault {

    private let postForIdLocalRepository: PostForIdLocalRepositoryRx
    private let userForPostIdLocalRepository: UserForPostIdLocalRepositoryRx
    private let numberOfCommentsForPostIdLocalRepository: NumberOfCommentsForPostIdLocalRepositoryRx

    init(
        postForIdLocalRepository: PostForIdLocalRepositoryRx,
        userForPostIdLocalRepository: UserForPostIdLocalRepositoryRx,
        numberOfCommentsForPostIdLocalRepository: NumberOfCommentsForPostIdLocalRepositoryRx) {

        self.postForIdLocalRepository = postForIdLocalRepository
        self.userForPostIdLocalRepository = userForPostIdLocalRepository
        self.numberOfCommentsForPostIdLocalRepository = numberOfCommentsForPostIdLocalRepository
    }
}

extension PostDetailsUseCaseDefault: PostDetailsUseCase {

    func responseFor(postId: Post.Id) -> Single<PostDetails.UseCaseResponse> {
        return Observable<(Post, User, Int)>
            .combineLatest(
                postForIdLocalRepository
                    .postFor(id: postId)
                    .asObservable(),
                userForPostIdLocalRepository
                    .userFor(postId: postId)
                    .asObservable(),
                numberOfCommentsForPostIdLocalRepository
                    .numberOfCommentsFor(postId: postId)
                    .asObservable()
            ) { ($0, $1, $2) }
            .asSingle()
            .map { post, user, numberOfComments -> PostDetails.UseCaseResponse in
                .init(
                    postTitle: post.title,
                    postDescription: post.body,
                    authorName: user.name,
                    authorUsername: user.username,
                    numberOfComments: numberOfComments
                )
            }
    }
}
