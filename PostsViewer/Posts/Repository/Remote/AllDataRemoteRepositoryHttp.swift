import RxSwift

struct AllDataRemoteRepositoryHttp {

    private let postRemoteRepository: PostRemoteRepository
    private let userRemoteRepository: UserRemoteRepository
    private let commentRemoteRepository: CommentRemoteRepository

    init(
        postRemoteRepository: PostRemoteRepository,
        userRemoteRepository: UserRemoteRepository,
        commentRemoteRepository: CommentRemoteRepository) {

        self.postRemoteRepository = postRemoteRepository
        self.userRemoteRepository = userRemoteRepository
        self.commentRemoteRepository = commentRemoteRepository
    }
}

extension AllDataRemoteRepositoryHttp: AllDataRemoteRepository {

    var allData: Single<AllData> {
        return Observable.combineLatest(
            postRemoteRepository.allPostData.asObservable(),
            userRemoteRepository.allUserData.asObservable(),
            commentRemoteRepository.allCommentData.asObservable(),
            resultSelector: AllData.init(posts:users:comments:)
        ).asSingle()
    }
}
