import RealmSwift

extension PostObject {
    func asPost() -> Post { return .init(id: id, title: title, body: body) }
}
