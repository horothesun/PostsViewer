import Swinject

extension Assembler {

    public convenience init(
        _ assemblies: Assembly...,
        container: Container = Container()) {

        self.init(assemblies, container: container)
    }
}
