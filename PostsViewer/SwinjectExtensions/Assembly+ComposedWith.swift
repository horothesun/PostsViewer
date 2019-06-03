import Swinject

extension Assembly {
    public func composed(with assembly: Assembly) -> Assembly {
        return ComposedAssembly(self, assembly)
    }
}

private struct ComposedAssembly: Assembly {

    private let lhs: Assembly
    private let rhs: Assembly

    init(_ lhs: Assembly, _ rhs: Assembly) { self.lhs = lhs; self.rhs = rhs }

    func assemble(container: Container) {
        [lhs, rhs].forEach { $0.assemble(container: container) }
    }
}
