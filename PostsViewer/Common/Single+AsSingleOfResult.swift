import RxSwift

extension PrimitiveSequence where Trait == SingleTrait {

    func asSingleOfResult() -> Single<Result<Element>> {
        return self.map(Result<Element>.success(_:))
            .catchError { .just(.failure($0)) }
    }
}