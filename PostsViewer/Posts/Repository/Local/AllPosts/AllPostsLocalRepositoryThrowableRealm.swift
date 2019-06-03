import RealmSwift

struct AllPostsLocalRepositoryThrowableRealm {

    private let environment: Environment

    init(environment: Environment) { self.environment = environment }
}

extension AllPostsLocalRepositoryThrowableRealm: AllPostsLocalRepositoryThrowable {

    func allPosts() throws -> [Post] {
        return try environment.realm()
            .objects(PostObject.self)
            .map { $0.asPost() }
    }
}
