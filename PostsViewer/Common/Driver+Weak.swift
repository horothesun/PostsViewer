import RxSwift
import RxSwiftExt
import RxCocoa

private let driveWeakErrorMessage =
    "`drive*` family of methods can be only called from `MainThread`.\n"
        + "This is required to ensure that the last replayed `Driver` element is delivered on `MainThread`.\n"

extension SharedSequenceConvertibleType where Self.SharingStrategy == RxCocoa.DriverSharingStrategy {

    public func driveNext<A: AnyObject>(
        weak: A,
        _ onNext: @escaping (A) -> (Self.E) -> Void) -> Disposable {

        let optionalOnNext: ((A) -> (Self.E) -> Void)? = onNext
        return drive(
            weak: weak,
            onNext: optionalOnNext,
            onCompleted: nil,
            onDisposed: nil
        )
    }

    public func drive<A: AnyObject>(
        weak: A,
        onNext: ((A) -> (Self.E) -> Void)?,
        onCompleted: ((A) -> () -> Void)? = nil,
        onDisposed: ((A) -> () -> Void)? = nil) -> Disposable {

        MainScheduler.ensureExecutingOnScheduler(errorMessage: driveWeakErrorMessage)
        return asSharedSequence()
            .asObservable()
            .subscribe(
                weak: weak,
                onNext: onNext,
                onError: nil,
                onCompleted: onCompleted,
                onDisposed: onDisposed
            )
    }
}
