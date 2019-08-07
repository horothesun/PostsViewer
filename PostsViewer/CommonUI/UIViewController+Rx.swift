import UIKit
import RxSwift


public extension Reactive where Base: UIViewController {

    var viewWillAppear: Observable<Bool> {
        methodInvoked(#selector(UIViewController.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }

    var viewDidAppear: Observable<Bool> {
        methodInvoked(#selector(UIViewController.viewDidAppear))
            .map { $0.first as? Bool ?? false }
    }
}
