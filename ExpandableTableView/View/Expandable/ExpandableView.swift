import UIKit

final class ExpandableView: UIView {

    private var cellHeights: [Int: [Int: CGFloat]] = [:]
    private var selectedIndexPath: IndexPath?
    private var tableView: UITableView = UITableView()

    private var faqs: [FAQModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(withFAQs faqs: [FAQModel]) {
        self.faqs = faqs
    }
}

extension ExpandableView: ViewCodable {
    func configureView() {
        tableView.register(ExpandableCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = .white
    }

    func configureHierarchy() {
        addSubview(tableView)
    }

    func configureConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

extension ExpandableView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle(faqs[section].title, for: .normal)
        return button
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return faqs.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqs[section].section.count + faqs[section].section[section + 1].questions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: ExpandableCell = tableView.dequeueReusableCell(ExpandableCell.self, for: indexPath)!
        cell.selectionStyle = .none

        let title = faqs[indexPath.section].section[indexPath.row].title
        let description = faqs[indexPath.section].section[indexPath.row].questions[indexPath.row].title
        cell.update(title: title, description: description)
        return cell
    }
}

extension ExpandableView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let dict = cellHeights[indexPath.section] {
            if dict.keys.contains(indexPath.row) {
                return dict[indexPath.row]!
            } else {
                cellHeights[indexPath.section]![indexPath.row] = UITableView.automaticDimension
                return UITableView.automaticDimension
            }
        }

        cellHeights[indexPath.section] = [:]
        cellHeights[indexPath.section]![indexPath.row] = UITableView.automaticDimension
        return cellHeights[indexPath.section]![indexPath.row]!
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dict = cellHeights[indexPath.section], dict[indexPath.row] == UITableView.automaticDimension {
            cellHeights[indexPath.section]![indexPath.row] = cell.bounds.height
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if selectedIndexPath == nil {
            expand(indexPath: indexPath)
        }

        if selectedIndexPath == indexPath {
            expand(indexPath: indexPath)
        }

        if let lastIndexPath = selectedIndexPath, selectedIndexPath != indexPath {
            collapse(lastIndexPath: lastIndexPath, indexPath: indexPath)
        }

        self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.middle, animated: true)

        selectedIndexPath = indexPath
    }

    func expand(indexPath: IndexPath) {
        let subject = faqs[indexPath.section].section[indexPath.row].questions[indexPath.row]
        subject.isExpanded? = !(subject.isExpanded ?? false)
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }

    func collapse(lastIndexPath: IndexPath, indexPath: IndexPath) {
        let lastSubject = faqs[indexPath.section].section[indexPath.row].questions[indexPath.row]
        lastSubject.isExpanded = false

        let subject = faqs[indexPath.section].section[indexPath.row].questions[indexPath.row]
        subject.isExpanded = !(subject.isExpanded ?? false)

        self.tableView.reloadRows(at: [indexPath, lastIndexPath], with: .fade)
    }
}
