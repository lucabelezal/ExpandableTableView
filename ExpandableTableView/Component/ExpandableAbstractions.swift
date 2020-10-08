import UIKit

public enum ExpandableActionType {
    case expand, collapse
}

@objc public enum ExpandableState: Int {
    case willExpand, willCollapse, didExpand, didCollapse
}

@objc public protocol ExpandableTableHeaderCell: AnyObject {
    func changeState(state: ExpandableState, cellReuse: Bool)
}

@objc public protocol ExpandableTableDataSource: UITableViewDataSource {
    func tableView(_ tableView: ExpandableTableView, canExpandSection section: Int) -> Bool
    func tableView(_ tableView: ExpandableTableView, expandableCellForSection section: Int) -> UITableViewCell
}

@objc public protocol ExpandableTableDelegate: UITableViewDelegate {}

