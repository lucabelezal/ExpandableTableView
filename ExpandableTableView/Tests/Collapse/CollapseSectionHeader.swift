import UIKit

public protocol CollapseSectionHeader {
    var indicatorImageView: UIImageView { get }
    var imageAnimationDuration: TimeInterval { get }
    func updateViewForOpenState(animated: Bool)
    func updateViewForCloseState(animated: Bool)
}

extension CollapseSectionHeader {
    public var imageAnimationDuration: TimeInterval {
        return 0.25
    }

    public func updateViewForOpenState(animated: Bool) {
        let duration = animated ? imageAnimationDuration : 0
        UIView.animate(withDuration: duration) {
            self.indicatorImageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }

    public func updateViewForCloseState(animated: Bool) {
        let duration = animated ? imageAnimationDuration : 0
        UIView.animate(withDuration: duration) {
            self.indicatorImageView.transform = CGAffineTransform(rotationAngle: CGFloat(2 * Double.pi))
        }
    }
}
