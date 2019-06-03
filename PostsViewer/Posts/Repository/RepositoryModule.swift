import Swinject

enum RepositoryModule {

    static let assembly = composedAssembly(from:
        LocalRepositoryAssembly(),
        RemoteRepositoryAssembly(),
        SynchronisationRepositoryAssembly()
    )
}