import RxSwift

struct UserRemoteRepositoryHttp {

    private let httpFetcher: HttpFetcherRx
    private let environment: Environment

    init(httpFetcher: HttpFetcherRx, environment: Environment) {
        self.httpFetcher = httpFetcher
        self.environment = environment
    }
}

extension UserRemoteRepositoryHttp: UserRemoteRepository {

    private var path: String { environment.baseUrl + "users" }

    var allUserData: Single<[UserData]> {
        return httpFetcher.fetch(path: path)
            .map { data -> [UserData] in
                guard let users = try? JSONDecoder().decode([UserData].self, from: data) else {
                    throw RemoteRepositoryError.jsonParsingError
                }
                return users
            }
    }
}
