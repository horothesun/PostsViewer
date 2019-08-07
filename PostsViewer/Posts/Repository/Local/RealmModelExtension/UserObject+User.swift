import RealmSwift

extension UserObject {
    func asUser() -> User { .init(id: id, name: name, username: username) }
}
