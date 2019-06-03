import RxSwift

protocol SynchronisationRepositoryRx {
    var isLocalDataAvailable: Single<Bool> { get }
    func set(isLocalDataAvailable: Bool) -> Completable
}

protocol SynchronisationRepositoryThrowable {
    func isLocalDataAvailable() throws -> Bool
    func set(isLocalDataAvailable: Bool) throws
}
