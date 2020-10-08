import UIKit

public final class ExpandableTableView: UITableView {
    public weak var expandableDataSource: ExpandableTableDataSource?
    public weak var expandableDelegate: ExpandableTableDelegate?

    public private(set) var expandedSections: [Int: Bool] = [:]

    public override var dataSource: UITableViewDataSource? {
        get { return super.dataSource }
        set {
            expandableDataSource = newValue as? ExpandableTableDataSource
            super.dataSource = self
        }
    }

    public override var delegate: UITableViewDelegate? {
        get { return super.delegate }
        set {
            expandableDelegate = newValue as? ExpandableTableDelegate
            super.delegate = self
        }
    }

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        if expandableDelegate == nil { super.delegate = self }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public Methods -

    public func expand(_ section: Int) {
        collapseLastExpandedSectionIfNeeded()
        animate(withActionType: .expand, forSection: section)
    }

    public func collapse(_ section: Int) {
        animate(withActionType: .collapse, forSection: section)
    }

    // MARK: - Private Methods -

    private func collapseLastExpandedSectionIfNeeded() {
        expandedSections.forEach { section in
            guard section.value == true else { return }
            collapse(section.key)
        }
    }

    private func animate(withActionType type: ExpandableActionType, forSection section: Int) {
        guard canExpand(section) else { return }

        let isSectionExpanded = didExpand(section)

        if (type == .expand) == isSectionExpanded { return }

        assign(section, asExpanded: type == .expand)
        startAnimating(tableView: self, withActionType: type, forSection: section)
    }

    private func startAnimating(tableView: ExpandableTableView, withActionType type: ExpandableActionType, forSection section: Int) {
        let headerCell = cellForRow(at: IndexPath(row: 0, section: section))
        let headerCellConformant = headerCell as? ExpandableTableHeaderCell

        CATransaction.begin()
        headerCell?.isUserInteractionEnabled = false

        headerCellConformant?.changeState(state: type == .expand ? .willExpand : .willCollapse, cellReuse: false)

        CATransaction.setCompletionBlock {
            headerCellConformant?.changeState(state: type == .expand ? .didExpand : .didCollapse, cellReuse: false)
            headerCell?.isUserInteractionEnabled = true
        }

        beginUpdates()
        let numberOfRowsInSection = expandableDataSource?.tableView(tableView, numberOfRowsInSection: section)
        if let sectionRowCount = numberOfRowsInSection, sectionRowCount > 1 {
            var indexesToProcess: [IndexPath] = []

            for row in 1 ..< sectionRowCount {
                indexesToProcess.append(IndexPath(row: row, section: section))
            }

            switch type {
            case .expand:
                insertRows(at: indexesToProcess, with: .fade)
            case .collapse:
                deleteRows(at: indexesToProcess, with: .fade)
            }
        }
        endUpdates()
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

    // MARK: - Verify Protocol -

    private func verifyProtocol(_ aProtocol: Protocol, contains aSelector: Selector) -> Bool {
        return protocol_getMethodDescription(aProtocol, aSelector, true, true).name != nil ||
            protocol_getMethodDescription(aProtocol, aSelector, false, true).name != nil
    }

    public override func responds(to aSelector: Selector!) -> Bool {
        if verifyProtocol(UITableViewDataSource.self, contains: aSelector) {
            return (super.responds(to: aSelector)) || (expandableDataSource?.responds(to: aSelector) ?? false)

        } else if verifyProtocol(UITableViewDelegate.self, contains: aSelector) {
            return (super.responds(to: aSelector)) || (expandableDelegate?.responds(to: aSelector) ?? false)
        }
        return super.responds(to: aSelector)
    }

    public override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if verifyProtocol(UITableViewDataSource.self, contains: aSelector) {
            return expandableDataSource

        } else if verifyProtocol(UITableViewDelegate.self, contains: aSelector) {
            return expandableDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }
}

// MARK: - UITableViewDataSource -

extension ExpandableTableView: UITableViewDataSource {
    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRows = expandableDataSource?.tableView(self, numberOfRowsInSection: section) ?? 0

        guard canExpand(section) else { return numberOfRows }
        guard numberOfRows != 0 else { return 0 }

        return didExpand(section) ? numberOfRows : 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let expandableDataSource = expandableDataSource else {
            return UITableViewCell()
        }

        guard canExpand(indexPath.section), indexPath.row == 0 else {
            return expandableDataSource.tableView(tableView, cellForRowAt: indexPath)
        }

        let headerCell = expandableDataSource.tableView(self, expandableCellForSection: indexPath.section)

        guard let headerCellConformant = headerCell as? ExpandableTableHeaderCell else {
            return headerCell
        }

        if didExpand(indexPath.section) {
            headerCellConformant.changeState(state: .willExpand, cellReuse: true)
            headerCellConformant.changeState(state: .didExpand, cellReuse: true)
        } else {
            headerCellConformant.changeState(state: .willCollapse, cellReuse: true)
            headerCellConformant.changeState(state: .didCollapse, cellReuse: true)
        }
        return headerCell
    }
}

// MARK: - UITableViewDelegate -

extension ExpandableTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        expandableDelegate?.tableView?(tableView, didSelectRowAt: indexPath)

        guard canExpand(indexPath.section), indexPath.row == 0 else { return }
        didExpand(indexPath.section) ? collapse(indexPath.section) : expand(indexPath.section)
    }
}
