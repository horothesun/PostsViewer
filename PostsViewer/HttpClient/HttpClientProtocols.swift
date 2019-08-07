import RxSwift

protocol HttpFetcherRx {
    func fetch(path: String) -> Single<Data>
}

protocol HttpFetcher {
    func fetch(path: String, completion: @escaping (Result<Data, HttpClientError>) -> Void)
}
