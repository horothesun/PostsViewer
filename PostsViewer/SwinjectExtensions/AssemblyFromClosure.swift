import Swinject

public func assemblyFrom(assembleClosure: @escaping (Container) -> Void) -> Assembly {
    return AssemblyFromClosure(assembleClosure: assembleClosure)
}

private struct AssemblyFromClosure: Assembly {

    private let assembleClosure: (Container) -> Void

    init(assembleClosure: @escaping (Container) -> Void) {
        self.assembleClosure = assembleClosure
    }

    func assemble(container: Container) { assembleClosure(container) }
}
