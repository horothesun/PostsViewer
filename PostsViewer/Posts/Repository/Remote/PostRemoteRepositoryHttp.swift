import RxSwift

struct PostRemoteRepositoryHttp {

    private let httpFetcher: HttpFetcherRx
    private let environment: Environment

    init(httpFetcher: HttpFetcherRx, environment: Environment) {
        self.httpFetcher = httpFetcher
        self.environment = environment
    }
}

extension PostRemoteRepositoryHttp: PostRemoteRepository {

    private var path: String { return environment.baseUrl + "posts" }

    var allPostData: Single<[PostData]> {
        return httpFetcher.fetch(path: path)
            .map { data -> [PostData] in
                guard let posts = try? JSONDecoder().decode([PostData].self, from: data) else {
                    throw RemoteRepositoryError.jsonParsingError
                }
                return posts
            }
    }
}
