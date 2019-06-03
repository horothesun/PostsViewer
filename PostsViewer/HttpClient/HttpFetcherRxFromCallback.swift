import RxSwift

final class HttpFetcherRxFromCallback {

    private let baseFetcher: HttpFetcher

    init(decorating baseFetcher: HttpFetcher) { self.baseFetcher = baseFetcher }
}

extension HttpFetcherRxFromCallback: HttpFetcherRx {

    func fetch(path: String) -> Single<Data> {
        return Single<Data>.create { [baseFetcher] observer -> Disposable in
            baseFetcher.fetch(path: path) { resultData in
                switch resultData {
                case let .success(data):  observer(.success(data))
                case let .failure(error): observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
}
