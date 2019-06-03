import UIKit

extension UIImage {

    public convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(cgImage: image.cgImage!)
    }
}
