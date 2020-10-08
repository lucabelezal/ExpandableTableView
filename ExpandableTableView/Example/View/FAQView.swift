import UIKit

protocol FAQViewDelegate: AnyObject {
    func didSelectQuestion(questionAnswer: QuestionAnswerModel)
}

final class FAQView: UIView {
    weak var delegate: FAQViewDelegate?

    private var faqItems: [FAQItemsModel] = [] {
        didSet {
            expandableTableView.reloadData()
        }
    }

    private lazy var expandableTableView: ExpandableTableView = {
        let tableView = ExpandableTableView()
        tableView.register(FAQHeaderViewCell.self)
        tableView.register(FAQViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(faqItems: [FAQItemsModel]) {
        self.faqItems = faqItems
    }

    private func isFirstRowAt(indexPath: IndexPath) -> Bool {
        guard let firstRow = faqItems[indexPath.section].rows.first else {
            return false
        }

        return faqItems[indexPath.section].rows[indexPath.row] != firstRow
    }
}

extension FAQView: ViewCodable {
    func configureHierarchy() {
        addSubview(expandableTableView)
    }

    func configureConstraints() {
        expandableTableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            expandableTableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            expandableTableView.leftAnchor.constraint(equalTo: leftAnchor),
            expandableTableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            expandableTableView.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func configureView() {
        expandableTableView.backgroundColor = .white
        expandableTableView.separatorColor = .clear
        expandableTableView.separatorStyle = .none
    }
}

extension FAQView: ExpandableTableDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return faqItems.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqItems[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FAQViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let title = faqItems[indexPath.section].rows[indexPath.row]
        cell.update(title: title)
        cell.accessibilityLabel = title
        return cell
    }

    func tableView(_: ExpandableTableView, canExpandSection _: Int) -> Bool {
        return true
    }

    func tableView(_ tableView: ExpandableTableView, expandableCellForSection section: Int) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FAQHeaderViewCell.self)) as? FAQHeaderViewCell
        else { return UITableViewCell() }
        let title = faqItems[section].rows.first
        cell.update(title: title)
        return cell
    }
}

extension FAQView: ExpandableTableDelegate {
    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = FAQHeaderView()
        headerView.update(title: faqItems[section].title)
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard isFirstRowAt(indexPath: indexPath) else { return }
        let sectionItem = faqItems[indexPath.section]
        let questionAnswer = QuestionAnswerModel(
            navigationTitle: sectionItem.rows.first,
            title: sectionItem.rows[indexPath.row],
            answerID: sectionItem.ids[indexPath.row]
        )
        delegate?.didSelectQuestion(questionAnswer: questionAnswer)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 56
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return faqItems[section].title != nil ? 80 : 0
    }
}
