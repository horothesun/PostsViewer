import Swinject

extension Array where Element == Assembly {
    public var composedAssembly: Assembly { return reduce(assemblyFrom { _ in }, +) }
}
