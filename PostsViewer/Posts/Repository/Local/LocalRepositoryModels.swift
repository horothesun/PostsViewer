import RealmSwift

enum LocalRepositoryState {
    case loading(isPreviousDataAvailable: Bool)
    case failure(isPreviousDataAvailable: Bool)
    case failureWithInconsistentState
    case ready(isLocalDataAvailable: Bool)
}

final class PostObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var userId: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var body: String = ""
}

final class UserObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var email: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var username: String = ""
}

final class CommentObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var postId: Int = 0
    @objc dynamic var email: String = ""
    @objc dynamic var body: String = ""
}
