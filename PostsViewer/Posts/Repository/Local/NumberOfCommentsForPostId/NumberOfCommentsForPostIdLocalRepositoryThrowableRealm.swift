import RealmSwift

struct NumberOfCommentsForPostIdLocalRepositoryThrowableRealm {

    private let environment: Environment

    init(environment: Environment) { self.environment = environment }
}

extension NumberOfCommentsForPostIdLocalRepositoryThrowableRealm: NumberOfCommentsForPostIdLocalRepositoryThrowable {

    func numberOfCommentsFor(postId: Post.Id) throws -> Int {
        try environment.realm().objects(CommentObject.self)
            .filter { $0.postId == postId }
            .count
    }
}
