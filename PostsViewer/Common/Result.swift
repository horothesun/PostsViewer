public enum Result<T> {
    case success(T)
    case failure(Error)
}

public extension Result {

    func map<R>(_ f: (T) -> R) -> Result<R> {
        switch self {
        case let .success(result): return .success(f(result))
        case let .failure(error):  return .failure(error)
        }
    }

    func mapThrowing<R>(_ f: (T) throws -> R) -> Result<R> {
        switch self {
        case let .success(result):
            do { let newResult = try f(result); return .success(newResult) }
            catch { return .failure(error) }
        case let .failure(error):
            return .failure(error)
        }
    }
}
