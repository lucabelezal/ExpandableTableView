import UIKit

public protocol DescribeProtocol: AnyObject {}

extension DescribeProtocol where Self: NSObject {
    public static var identifier: String {
        return String(describing: self)
    }
}

extension NSObject: DescribeProtocol {}

extension UITableView {
    public func register<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.identifier)
    }

    public func registerHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) {
        register(T.self, forHeaderFooterViewReuseIdentifier: T.identifier)
    }

    public func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }

    public func dequeueHeaderFooterView<T: UITableViewHeaderFooterView>() -> T {
        guard let view = dequeueReusableHeaderFooterView(withIdentifier: T.identifier) as? T else {
            fatalError("Could not dequeue header or footer view with identifier: \(T.identifier)")
        }
        return view
    }
}
