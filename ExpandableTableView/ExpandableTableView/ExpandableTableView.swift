import UIKit

public final class ExpandableTableView: UITableView {

    public weak var expandableDataSource: ExpandableTableDataSource?
    public weak var expandableDelegate: ExpandableTableDelegate?

    public private(set) var expandedSections: [Int: Bool] = [:]

    public override var dataSource: UITableViewDataSource? {
        get { return super.dataSource }
        set(dataSource) {
            guard let dataSource = dataSource else { return }
            expandableDataSource = dataSource as? ExpandableTableDataSource
            super.dataSource = self
        }
    }

    public override var delegate: UITableViewDelegate? {
        get { return super.delegate }
        set(delegate) {
            guard let delegate = delegate else { return }
            expandableDelegate = delegate as? ExpandableTableDelegate
            super.delegate = self
        }
    }

//    public override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: frame, style: style)
//        if expandableDelegate == nil { super.delegate = self }
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    //MARK: - Public Methods -

    public func expand(_ section: Int) {
        animate(with: .expand, forSection: section)
    }

    public func collapse(_ section: Int) {
        animate(with: .collapse, forSection: section)
    }

    //MARK: - Private Methods -

    private func animate(with type: ExpandableActionType, forSection section: Int) {
        guard canExpand(section) else { return }

        let sectionIsExpanded = didExpand(section)

        if ((type == .expand) && (sectionIsExpanded)) || ((type == .collapse) && (!sectionIsExpanded)) { return }

        assign(section, asExpanded: (type == .expand))
        startAnimating(self, with: type, forSection: section)
    }

    private func startAnimating(_ tableView: ExpandableTableView, with type: ExpandableActionType, forSection section: Int) {

        let headerCell = (self.cellForRow(at: IndexPath(row: 0, section: section)))
        let headerCellConformant = headerCell as? ExpandableTableHeaderCell

        CATransaction.begin()
        headerCell?.isUserInteractionEnabled = false

        headerCellConformant?.changeState(cellReuseStatus: false)
        expandableDelegate?.tableView(tableView, changeForSection: section)

        CATransaction.setCompletionBlock {
            headerCellConformant?.changeState(cellReuseStatus: false)

            self.expandableDelegate?.tableView(tableView, changeForSection: section)
            headerCell?.isUserInteractionEnabled = true
        }

        self.beginUpdates()
        if let sectionRowCount = expandableDataSource?.tableView(tableView, numberOfRowsInSection: section), sectionRowCount > 1 {

            var indexesToProcess: [IndexPath] = []

            for row in 1..<sectionRowCount {
                indexesToProcess.append(IndexPath(row: row, section: section))
            }

            if type == .expand {
                self.insertRows(at: indexesToProcess, with: .fade)
            }else if type == .collapse {
                self.deleteRows(at: indexesToProcess, with: .fade)
            }
        }
        self.endUpdates()
        CATransaction.commit()
    }

    private func canExpand(_ section: Int) -> Bool {
        return expandableDataSource?.tableView(self, canExpandSection: section) ?? true
    }

    private func didExpand(_ section: Int) -> Bool {
        return expandedSections[section] ?? false
    }

    private func assign(_ section: Int, asExpanded: Bool) {
        expandedSections[section] = asExpanded
    }
}

//MARK: - UITableViewDataSource Protocol -

extension ExpandableTableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = expandableDataSource?.tableView(self, numberOfRowsInSection: section) ?? 0

        guard canExpand(section) else { return numberOfRows }
        guard numberOfRows != 0 else { return 0 }

        return didExpand(section) ? numberOfRows : 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard canExpand(indexPath.section), indexPath.row == 0 else {
            return expandableDataSource!.tableView(tableView, cellForRowAt: indexPath)
        }

        let headerCell = expandableDataSource!.tableView(self, expandableCellForSection: indexPath.section)

        guard let headerCellConformant = headerCell as? ExpandableTableHeaderCell else {
            return headerCell
        }

        DispatchQueue.main.async {
            if self.didExpand(indexPath.section) {
                headerCellConformant.changeState(cellReuseStatus: true)
                headerCellConformant.changeState(cellReuseStatus: true)
            }else {
                headerCellConformant.changeState(cellReuseStatus: true)
                headerCellConformant.changeState(cellReuseStatus: true)
            }
        }
        return headerCell
    }
}

//MARK: - UITableViewDelegate Protocol -

extension ExpandableTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandableDelegate?.tableView?(tableView, didSelectRowAt: indexPath)

        guard canExpand(indexPath.section), indexPath.row == 0 else { return }
        didExpand(indexPath.section) ? collapse(indexPath.section) : expand(indexPath.section)
    }
}

//MARK: - Helper Protocol -

extension ExpandableTableView {
    fileprivate func verifyProtocol(_ aProtocol: Protocol, contains aSelector: Selector) -> Bool {
        return protocol_getMethodDescription(aProtocol, aSelector, true, true).name != nil ||
            protocol_getMethodDescription(aProtocol, aSelector, false, true).name != nil
    }

    override public func responds(to aSelector: Selector!) -> Bool {
        if verifyProtocol(UITableViewDataSource.self, contains: aSelector) {
            return (super.responds(to: aSelector)) || (expandableDataSource?.responds(to: aSelector) ?? false)

        }else if verifyProtocol(UITableViewDelegate.self, contains: aSelector) {
            return (super.responds(to: aSelector)) || (expandableDelegate?.responds(to: aSelector) ?? false)
        }
        return super.responds(to: aSelector)
    }

    override public func forwardingTarget(for aSelector: Selector!) -> Any? {
        if verifyProtocol(UITableViewDataSource.self, contains: aSelector) {
            return expandableDataSource

        }else if verifyProtocol(UITableViewDelegate.self, contains: aSelector) {
            return expandableDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }
}

