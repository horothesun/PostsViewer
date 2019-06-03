import UIKit

extension UIView {

    public convenience init(color: UIColor) {
        self.init(frame: .zero)
        backgroundColor = color
    }
}
