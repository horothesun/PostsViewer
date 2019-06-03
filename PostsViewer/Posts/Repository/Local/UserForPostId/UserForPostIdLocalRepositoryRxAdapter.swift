import RxSwift
import RealmSwift

struct UserForPostIdLocalRepositoryRxAdapter {

    private let baseRepository: UserForPostIdLocalRepositoryThrowable

    init(adapting baseRepository: UserForPostIdLocalRepositoryThrowable) {
        self.baseRepository = baseRepository
    }
}

extension UserForPostIdLocalRepositoryRxAdapter: UserForPostIdLocalRepositoryRx {

    func userFor(postId: Post.Id) -> Single<User> {
        return .deferred { [baseRepository] in
            .just(try baseRepository.userFor(postId: postId))
        }
    }
}
