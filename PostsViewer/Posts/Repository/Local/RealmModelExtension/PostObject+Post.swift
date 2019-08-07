import RealmSwift

extension PostObject {
    func asPost() -> Post { .init(id: id, title: title, body: body) }
}
