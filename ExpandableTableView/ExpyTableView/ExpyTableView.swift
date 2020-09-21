import UIKit

@objcMembers open class ExpyTableView: UITableView {
	
	private weak var expyDataSource: ExpyTableViewDataSource?
	private weak var expyDelegate: ExpyTableViewDelegate?
    private var expandedSections: [Int: Bool] = [:]

    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
    }

    @available(*, unavailable)
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	open override var dataSource: UITableViewDataSource? {
		get { return super.dataSource }
		set(dataSource) {
			guard let dataSource = dataSource else { return }
			expyDataSource = dataSource as? ExpyTableViewDataSource
			super.dataSource = self
		}
	}

	open override var delegate: UITableViewDelegate? {
		get { return super.delegate }
		set(delegate) {
			guard let delegate = delegate else { return }
			expyDelegate = delegate as? ExpyTableViewDelegate
			super.delegate = self
		}
	}
	
	open override func awakeFromNib() {
		super.awakeFromNib()
		if expyDelegate == nil {
			super.delegate = self
		}
	}
}

extension ExpyTableView {
	public func expand(_ section: Int) {
		animate(with: .expand, forSection: section)
	}
	
	public func collapse(_ section: Int) {
		animate(with: .collapse, forSection: section)
	}
	
	private func animate(with type: ExpyActionType, forSection section: Int) {
		guard canExpand(section) else { return }
		
		let sectionIsExpanded = didExpand(section)

		if ((type == .expand) && (sectionIsExpanded)) || ((type == .collapse) && (!sectionIsExpanded)) { return }
		
		assign(section, asExpanded: (type == .expand))
		startAnimating(self, with: type, forSection: section)
	}
	
	private func startAnimating(_ tableView: ExpyTableView, with type: ExpyActionType, forSection section: Int) {
	
		let headerCell = (self.cellForRow(at: IndexPath(row: 0, section: section)))
		let headerCellConformant = headerCell as? ExpyTableViewHeaderCell
		
		CATransaction.begin()
		headerCell?.isUserInteractionEnabled = false

		headerCellConformant?.changeState((type == .expand ? .willExpand : .willCollapse), cellReuseStatus: false)
		expyDelegate?.tableView(tableView, expyState: (type == .expand ? .willExpand : .willCollapse), changeForSection: section)

		CATransaction.setCompletionBlock {
			//headerCellConformant?.changeState((type == .expand ? .didExpand : .didCollapse), cellReuseStatus: false)
			//self.expyDelegate?.tableView(tableView, expyState: (type == .expand ? .didExpand : .didCollapse), changeForSection: section)
			headerCell?.isUserInteractionEnabled = true
		}
		
		self.beginUpdates()

		if let sectionRowCount = expyDataSource?.tableView(tableView, numberOfRowsInSection: section), sectionRowCount > 1 {
			
			var indexesToProcess: [IndexPath] = []

			for row in 1..<sectionRowCount {
				indexesToProcess.append(IndexPath(row: row, section: section))
			}

			if type == .expand {
                self.insertRows(at: indexesToProcess, with: .fade)
			} else if type == .collapse {
                self.deleteRows(at: indexesToProcess, with: .fade)
			}
		}
		self.endUpdates()
		
		CATransaction.commit()
	}
}

extension ExpyTableView: UITableViewDataSource {
	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		let numberOfRows = expyDataSource?.tableView(self, numberOfRowsInSection: section) ?? 0
		
		guard canExpand(section) else { return numberOfRows }
		guard numberOfRows != 0 else { return 0 }
		
		return didExpand(section) ? numberOfRows : 1
	}
	
	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard canExpand(indexPath.section), indexPath.row == 0 else {
			return expyDataSource!.tableView(tableView, cellForRowAt: indexPath)
		}
		
		let headerCell = expyDataSource!.tableView(self, expandableCellForSection: indexPath.section)
		
		guard let headerCellConformant = headerCell as? ExpyTableViewHeaderCell else {
			return headerCell
		}
		
		DispatchQueue.main.async {
			if self.didExpand(indexPath.section) {
				headerCellConformant.changeState(.willExpand, cellReuseStatus: true)
			} else {
				headerCellConformant.changeState(.willCollapse, cellReuseStatus: true)
			}
		}
		return headerCell
	}
}

extension ExpyTableView: UITableViewDelegate {
	
	open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		expyDelegate?.tableView?(tableView, didSelectRowAt: indexPath)
		
		guard canExpand(indexPath.section), indexPath.row == 0 else { return }
		didExpand(indexPath.section) ? collapse(indexPath.section) : expand(indexPath.section)
	}
}

extension ExpyTableView {
	fileprivate func canExpand(_ section: Int) -> Bool {
		return expyDataSource?.tableView(self, canExpandSection: section) ?? ExpyTableViewDefaultValues.expandableStatus
	}
	
	fileprivate func didExpand(_ section: Int) -> Bool {
		return expandedSections[section] ?? false
	}
	
	fileprivate func assign(_ section: Int, asExpanded: Bool) {
		expandedSections[section] = asExpanded
	}
}

