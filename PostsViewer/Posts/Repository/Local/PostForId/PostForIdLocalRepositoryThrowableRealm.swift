import RealmSwift

struct PostForIdLocalRepositoryThrowableRealm {

    private let environment: Environment

    init(environment: Environment) { self.environment = environment }
}

extension PostForIdLocalRepositoryThrowableRealm: PostForIdLocalRepositoryThrowable {

    private enum RepositoryError: Error { case postNotFound }

    func postFor(id: Post.Id) throws -> Post {
        let postObjects = try environment.realm()
            .objects(PostObject.self)
            .filter { $0.id == id }
        guard postObjects.count == 1, let postObject = postObjects.first else {
            throw RepositoryError.postNotFound
        }
        return postObject.asPost()
    }
}
