import UIKit

extension UIImage {

    public convenience init(
        safeNamed name: String,
        in bundle: Bundle? = nil,
        compatibleWith traitCollection: UITraitCollection? = nil,
        defaultColor: UIColor = .clear) {

        let image = UIImage(named: name, in: bundle, compatibleWith: traitCollection)
            ?? .init(color: defaultColor)
        self.init(cgImage: image.cgImage!)
    }
}
