import Swinject
import SwinjectAutoregistration

struct HttpClientAssembly: Assembly {

    func assemble(container: Container) {
        container.autoregister(HttpFetcherRx.self, initializer: HttpFetcherRxFromCallback.init(decorating:))
        container.autoregister(HttpFetcher.self, initializer: HttpFetcherURLSession.init)
    }
}
