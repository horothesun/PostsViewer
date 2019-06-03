import RealmSwift

public protocol Environment {
    var baseUrl: String { get set }
    var realm: () throws -> Realm { get set }
}

struct CurrentEnvironment: Environment {

    var baseUrl = "http://jsonplaceholder.typicode.com/"
    var realm = { try Realm() }

    init() { }
}
