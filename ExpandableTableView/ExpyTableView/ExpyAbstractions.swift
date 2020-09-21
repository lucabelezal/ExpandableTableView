import UIKit

public struct ExpyTableViewDefaultValues {
    public static let expandableStatus = true
}

public enum ExpyState: Int {
    case willExpand, willCollapse
}

public enum ExpyActionType {
    case expand, collapse
}

public protocol ExpyTableViewHeaderCell: class {
    func changeState(_ state: ExpyState, cellReuseStatus cellReuse: Bool)
}

public protocol ExpyTableViewDataSource: UITableViewDataSource {
    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool
    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell
}

public protocol ExpyTableViewDelegate: UITableViewDelegate {
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int)
}
