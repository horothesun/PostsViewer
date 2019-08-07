import RealmSwift

final class SynchronisationObject: Object {
    @objc dynamic var isLocalDataAvailable = false
}

struct SynchronisationRepositoryThrowableRealm {

    private let environment: Environment

    init(environment: Environment) { self.environment = environment }
}

extension SynchronisationRepositoryThrowableRealm: SynchronisationRepositoryThrowable {

    private enum RepositoryError: Error { case moreThanOneSynchronisationObjectFound }

    func isLocalDataAvailable() throws -> Bool {
        let syncObjects = try getSyncObjects(with: environment.realm)
        guard let syncObject = syncObjects.first else { return false }
        return syncObject.isLocalDataAvailable
    }

    func set(isLocalDataAvailable: Bool) throws {
        let realm = environment.realm
        let syncObjects = try getSyncObjects(with: realm)
        guard syncObjects.count < 2 else {
            throw RepositoryError.moreThanOneSynchronisationObjectFound
        }
        guard let syncObject = syncObjects.first else {
            let syncObject = SynchronisationObject()
            syncObject.isLocalDataAvailable = isLocalDataAvailable
            try realm().write { try realm().add(syncObject) }
            return
        }
        try realm().write {
            syncObject.isLocalDataAvailable = isLocalDataAvailable
        }
    }

    private func getSyncObjects(with realm: () throws -> Realm) throws -> Results<SynchronisationObject> {
        try realm().objects(SynchronisationObject.self)
    }
}
