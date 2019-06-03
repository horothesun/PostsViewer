import RxSwift

struct SynchronisationRepositoryRxAdapter {

    private let baseRepository: SynchronisationRepositoryThrowable

    init(adapting baseRepository: SynchronisationRepositoryThrowable) {
        self.baseRepository = baseRepository
    }
}

extension SynchronisationRepositoryRxAdapter: SynchronisationRepositoryRx {

    var isLocalDataAvailable: Single<Bool> {
        let repository = baseRepository
        return .deferred { .just(try repository.isLocalDataAvailable()) }
    }

    func set(isLocalDataAvailable: Bool) -> Completable {
        let repository = baseRepository
        return Completable.create { observer in
            do {
                try repository.set(isLocalDataAvailable: isLocalDataAvailable)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}
