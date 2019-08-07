import UIKit

public protocol Reusable: class {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    public static var reuseIdentifier: String { "\(Self.self)" }
}

extension UITableView {

    public func registerReusableCell<T: UITableViewCell & Reusable>(_ type: T.Type) {
        register(type, forCellReuseIdentifier: T.reuseIdentifier)
    }

    public func dequeueReusableCell<T: UITableViewCell & Reusable>(indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as! T
    }

    public func registerReusableHeaderFooterView<T: UITableViewHeaderFooterView & Reusable>(_ type: T.Type) {
        register(type, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
    }

    public func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView & Reusable>() -> T {
        dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as! T
    }
}
