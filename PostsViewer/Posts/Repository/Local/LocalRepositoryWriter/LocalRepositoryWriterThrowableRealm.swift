import RealmSwift

struct LocalRepositoryWriterThrowableRealm {

    private let localRealmObjectsMapper: LocalRealmObjectsMapper
    private let environment: Environment

    init(
        localRealmObjectsMapper: LocalRealmObjectsMapper,
        environment: Environment) {

        self.localRealmObjectsMapper = localRealmObjectsMapper
        self.environment = environment
    }
}

extension LocalRepositoryWriterThrowableRealm: LocalRepositoryWriterThrowable {

    func write(allData: AllData) throws {
        let allObjects = localRealmObjectsMapper.allObjects(from: allData)
        let realm = try environment.realm()
        try realm.write {
            allObjects.posts.map { ($0, .error) }.forEach(realm.add(_:update:))
            allObjects.users.map { ($0, .error) }.forEach(realm.add(_:update:))
            allObjects.comments.map { ($0, .error) }.forEach(realm.add(_:update:))
        }
    }

    func cleanAllData() throws {
        try [PostObject.self, UserObject.self, CommentObject.self]
            .forEach(clean(objectType:))
    }

    private func clean(objectType: Object.Type) throws {
        let realm = try environment.realm()
        let allObjects = realm.objects(objectType)
        try realm.write { realm.delete(allObjects) }
    }
}
