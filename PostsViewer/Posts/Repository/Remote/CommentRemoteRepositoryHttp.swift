import RxSwift

struct CommentRemoteRepositoryHttp {

    private let httpFetcher: HttpFetcherRx
    private let environment: Environment

    init(httpFetcher: HttpFetcherRx, environment: Environment) {
        self.httpFetcher = httpFetcher
        self.environment = environment
    }
}

extension CommentRemoteRepositoryHttp: CommentRemoteRepository {

    private var path: String { environment.baseUrl + "comments" }

    var allCommentData: Single<[CommentData]> {
        return httpFetcher.fetch(path: path)
            .map { data -> [CommentData] in
                guard let comments = try? JSONDecoder().decode([CommentData].self, from: data) else {
                    throw RemoteRepositoryError.jsonParsingError
                }
                return comments
            }
    }
}
