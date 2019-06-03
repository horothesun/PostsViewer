import RealmSwift

struct UserForPostIdLocalRepositoryThrowableRealm {

    private let environment: Environment

    init(environment: Environment) { self.environment = environment }
}

extension UserForPostIdLocalRepositoryThrowableRealm: UserForPostIdLocalRepositoryThrowable {

    private enum RepositoryError: Error { case postNotFound, userNotFound }

    func userFor(postId: Post.Id) throws -> User {
        let realm = try environment.realm()
        let postObjects = realm.objects(PostObject.self)
            .filter { $0.id == postId }
        guard postObjects.count == 1, let postObject = postObjects.first else {
            throw RepositoryError.postNotFound
        }
        let userObjects = realm.objects(UserObject.self)
            .filter { $0.id == postObject.userId }
        guard userObjects.count == 1, let userObject = userObjects.first else {
            throw RepositoryError.userNotFound
        }
        return userObject.asUser()
    }
}
