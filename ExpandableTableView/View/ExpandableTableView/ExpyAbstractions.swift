import UIKit

public enum ExpandableActionType {
    case expand, collapse
}

@objc public protocol ExpandableTableHeaderCell: class {
    func changeState(cellReuseStatus cellReuse: Bool)
}

@objc public protocol ExpandableTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: ExpandableTableView, canExpandSection section: Int) -> Bool
    func tableView(_ tableView: ExpandableTableView, expandableCellForSection section: Int) -> UITableViewCell
}

@objc public protocol ExpandableTableDelegate: UITableViewDelegate {
    func tableView(_ tableView: ExpandableTableView, changeForSection section: Int)
}
