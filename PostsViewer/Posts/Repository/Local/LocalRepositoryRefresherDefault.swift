import RxSwift
import RxSwiftExt
import RealmSwift

final class LocalRepositoryRefresherDefault {

    private typealias Refresher = LocalRepositoryRefresherDefault

    private let refreshSubject = PublishSubject<Void>()

    private let allDataRemoteRepository: AllDataRemoteRepository
    private let localRepositoryWriter: LocalRepositoryWriterRx
    private let synchronisationRepository: SynchronisationRepositoryRx

    init(
        allDataRemoteRepository: AllDataRemoteRepository,
        localRepositoryWriter: LocalRepositoryWriterRx,
        synchronisationRepository: SynchronisationRepositoryRx) {

        self.allDataRemoteRepository = allDataRemoteRepository
        self.localRepositoryWriter = localRepositoryWriter
        self.synchronisationRepository = synchronisationRepository
    }
}

extension LocalRepositoryRefresherDefault: LocalRepositoryRefresher {

    func refresh() { refreshSubject.onNext(()) }

    func localRepositoryStateStartingWithReloading(
        on scheduler: SchedulerType) -> Observable<LocalRepositoryState> {

        let getRemoteDataAndStoreItLocallyStates
            = Refresher.getRemoteDataAndStoreItLocally(with:
                allDataRemoteRepository,
                localRepositoryWriter,
                synchronisationRepository
            )
        let remainingStates = refreshSubject
            .observeOn(scheduler)
            .flatMapLatest { _ in getRemoteDataAndStoreItLocallyStates }
        return getRemoteDataAndStoreItLocallyStates
            .concat(remainingStates)
            .subscribeOn(scheduler)
    }

    private static func getRemoteDataAndStoreItLocally(
        with allDataRemoteRepository: AllDataRemoteRepository,
        _ localRepositoryWriter: LocalRepositoryWriterRx,
        _ synchronisationRepository: SynchronisationRepositoryRx)
        -> Observable<LocalRepositoryState> {

        let initialLoadingState = synchronisationRepository.isLocalDataAvailable
            .map(LocalRepositoryState.loading(isPreviousDataAvailable:))
        let remainingStates = allDataRemoteRepository.allData
            .asSingleOfResult()
            .asObservable()
            .flatMap(Refresher.singleStateFromResultAllData(
                with: localRepositoryWriter, synchronisationRepository
            ))
        return initialLoadingState.asObservable()
            .concat(remainingStates)
    }

    private static func singleStateFromResultAllData(
        with localRepositoryWriter: LocalRepositoryWriterRx,
        _ synchronisationRepository: SynchronisationRepositoryRx)
        -> (Result<AllData>) -> Single<LocalRepositoryState> {

        return { resultAllData in
            switch resultAllData {
            case let .success(allData):
                return Refresher.singleState(
                    from: allData,
                    with: localRepositoryWriter, synchronisationRepository
                )
            case .failure:
                return synchronisationRepository.isLocalDataAvailable
                    .map(LocalRepositoryState.failure(isPreviousDataAvailable:))
            }
        }
    }

    private static func singleState(
        from allData: AllData,
        with localRepositoryWriter: LocalRepositoryWriterRx,
        _ synchronisationRepository: SynchronisationRepositoryRx)
        -> Single<LocalRepositoryState> {

        return localRepositoryWriter.cleanAllData()
            .andThen(localRepositoryWriter.write(allData: allData))
            .andThen(synchronisationRepository.set(isLocalDataAvailable: true))
            .andThen(Single<LocalRepositoryState>.just(.ready(isLocalDataAvailable: true)))
            .catchError { error in
                localRepositoryWriter.cleanAllData()
                    .andThen(synchronisationRepository.set(isLocalDataAvailable: false))
                    .andThen(Single<LocalRepositoryState>.just(.failure(isPreviousDataAvailable: false)))
                    .catchErrorJustReturn(.failureWithInconsistentState)
            }
    }
}