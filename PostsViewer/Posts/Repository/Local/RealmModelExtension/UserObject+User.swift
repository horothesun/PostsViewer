import RealmSwift

extension UserObject {
    func asUser() -> User { return .init(id: id, name: name, username: username) }
}
