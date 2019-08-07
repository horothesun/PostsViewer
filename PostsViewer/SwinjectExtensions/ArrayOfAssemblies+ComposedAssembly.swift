import Swinject

extension Array where Element == Assembly {
    public var composedAssembly: Assembly { reduce(assemblyFrom { _ in }, +) }
}
