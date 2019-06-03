import RealmSwift

struct LocalRealmObjectsMapperDefault: LocalRealmObjectsMapper {

    private typealias Mapper = LocalRealmObjectsMapperDefault

    func allObjects(from allData: AllData) -> AllObjects {
        return .init(
            posts: allData.posts.map(Mapper.postObjectFrom(postData:)),
            users: allData.users.map(Mapper.userObjectFrom(userData:)),
            comments: allData.comments.map(Mapper.commentObjectFrom(commentData:))
        )
    }

    private static func postObjectFrom(postData: PostData) -> PostObject {
        let postObject = PostObject()
        postObject.id = postData.id
        postObject.userId = postData.userId
        postObject.title = postData.title
        postObject.body = postData.body
        return postObject
    }

    private static func userObjectFrom(userData: UserData) -> UserObject {
        let userObject = UserObject()
        userObject.id = userData.id
        userObject.email = userData.email
        userObject.name = userData.name
        userObject.username = userData.username
        return userObject
    }

    private static func commentObjectFrom(commentData: CommentData) -> CommentObject {
        let commentObject = CommentObject()
        commentObject.id = commentData.id
        commentObject.postId = commentData.postId
        commentObject.email = commentData.email
        commentObject.body = commentData.body
        return commentObject
    }
}
