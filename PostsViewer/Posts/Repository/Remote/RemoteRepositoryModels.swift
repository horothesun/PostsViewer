struct PostData: Decodable {
    typealias Id = Int // TODO: move to Tagged

    let id: Id
    let userId: UserData.Id
    let title: String
    let body: String
}

struct UserData: Decodable {
    typealias Id = Int // TODO: move to Tagged
    typealias Email = String // TODO: move to Tagged

    let id: Id
    let email: UserData.Email
    let name: String
    let username: String
}

struct CommentData: Decodable {
    typealias Id = Int // TODO: move to Tagged

    let id: Id
    let postId: PostData.Id
    let email: UserData.Email
    let body: String
}

struct AllData {
    var posts: [PostData]
    var users: [UserData]
    var comments: [CommentData]
}

struct AllObjects {
    var posts: [PostObject]
    var users: [UserObject]
    var comments: [CommentObject]
}

enum RemoteRepositoryError: Error {
    case jsonParsingError
}
