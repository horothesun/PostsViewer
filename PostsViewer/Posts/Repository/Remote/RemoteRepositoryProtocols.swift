import RxSwift

protocol PostRemoteRepository {
    var allPostData: Single<[PostData]> { get }
}

protocol UserRemoteRepository {
    var allUserData: Single<[UserData]> { get }
}

protocol CommentRemoteRepository {
    var allCommentData: Single<[CommentData]> { get }
}

protocol AllDataRemoteRepository {
    var allData: Single<AllData> { get }
}
