import RxSwift

struct NumberOfCommentsForPostIdLocalRepositoryRxAdapter {

    private let baseRepository: NumberOfCommentsForPostIdLocalRepositoryThrowable

    init(adapting baseRepository: NumberOfCommentsForPostIdLocalRepositoryThrowable) {
        self.baseRepository = baseRepository
    }
}

extension NumberOfCommentsForPostIdLocalRepositoryRxAdapter: NumberOfCommentsForPostIdLocalRepositoryRx {

    func numberOfCommentsFor(postId: Post.Id) -> Single<Int> {
        return .deferred { [baseRepository] in
            .just(try baseRepository.numberOfCommentsFor(postId: postId))
        }
    }
}
