import RxSwift

struct AllPostsLocalRepositoryRxAdapter {

    private let baseRepository: AllPostsLocalRepositoryThrowable

    init(adapting baseRepository: AllPostsLocalRepositoryThrowable) {
        self.baseRepository = baseRepository
    }
}

extension AllPostsLocalRepositoryRxAdapter: AllPostsLocalRepositoryRx {

    var allPosts: Single<[Post]> {
        return .deferred { [baseRepository] in .just(try baseRepository.allPosts()) }
    }
}
