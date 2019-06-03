import RxSwift

struct PostForIdLocalRepositoryRxAdapter {

    private let baseRepository: PostForIdLocalRepositoryThrowable

    init(adapting baseRepository: PostForIdLocalRepositoryThrowable) {
        self.baseRepository = baseRepository
    }
}

extension PostForIdLocalRepositoryRxAdapter: PostForIdLocalRepositoryRx {

    func postFor(id: Post.Id) -> Single<Post> {
        return .deferred { [baseRepository] in .just(try baseRepository.postFor(id: id)) }
    }
}
