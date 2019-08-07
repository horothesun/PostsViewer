import RxSwift

extension PrimitiveSequence where Trait == SingleTrait {

    func asSingleOfResult() -> Single<Result<Element, Error>> {
        map(Result<Element, Error>.success(_:))
            .catchError { .just(.failure($0)) }
    }
}
