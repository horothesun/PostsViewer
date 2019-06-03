import RxSwift

protocol LocalRepositoryRefresher {
    func refresh()
    func localRepositoryStateStartingWithReloading(
        on scheduler: SchedulerType) -> Observable<LocalRepositoryState>
}

protocol LocalRepositoryWriterRx {
    func write(allData: AllData) -> Completable
    func cleanAllData() -> Completable
}

protocol LocalRepositoryWriterThrowable {
    func write(allData: AllData) throws
    func cleanAllData() throws
}

protocol LocalRealmObjectsMapper {
    func allObjects(from allData: AllData) -> AllObjects
}

protocol AllPostsLocalRepositoryRx {
    var allPosts: Single<[Post]> { get }
}
protocol AllPostsLocalRepositoryThrowable {
    func allPosts() throws -> [Post]
}

protocol PostForIdLocalRepositoryRx {
    func postFor(id: Post.Id) -> Single<Post>
}
protocol PostForIdLocalRepositoryThrowable {
    func postFor(id: Post.Id) throws -> Post
}

protocol UserForPostIdLocalRepositoryRx {
    func userFor(postId: Post.Id) -> Single<User>
}
protocol UserForPostIdLocalRepositoryThrowable {
    func userFor(postId: Post.Id) throws -> User
}

protocol NumberOfCommentsForPostIdLocalRepositoryRx {
    func numberOfCommentsFor(postId: Post.Id) -> Single<Int>
}
protocol NumberOfCommentsForPostIdLocalRepositoryThrowable {
    func numberOfCommentsFor(postId: Post.Id) throws -> Int
}
