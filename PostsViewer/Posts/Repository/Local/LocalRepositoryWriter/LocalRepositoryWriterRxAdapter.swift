import RxSwift

struct LocalRepositoryWriterRxAdapter {

    private let baseWriter: LocalRepositoryWriterThrowable

    init(adapting baseWriter: LocalRepositoryWriterThrowable) {
        self.baseWriter = baseWriter
    }
}

extension LocalRepositoryWriterRxAdapter: LocalRepositoryWriterRx {

    private enum WriterError: Error { case generic }

    func write(allData: AllData) -> Completable {
        let writer = baseWriter
        return Completable.create { observer in
            do {
                try writer.write(allData: allData)
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }

    func cleanAllData() -> Completable {
        let writer = baseWriter
        return Completable.create { observer in
            do {
                try writer.cleanAllData()
                observer(.completed)
            } catch {
                observer(.error(error))
            }
            return Disposables.create()
        }
    }
}
