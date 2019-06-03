struct Post: Equatable {
    typealias Id = Int // TODO: move to Tagged

    let id: Id
    let title: String
    let body: String
}

struct User {
    typealias Id = Int // TODO: move to Tagged

    let id: Id
    let name: String
    let username: String
}

struct Comment {
    typealias Id = Int // TODO: move to Tagged

    let id: Id
    let email: String
    let body: String
}
