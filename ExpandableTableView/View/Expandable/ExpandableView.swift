import UIKit

final class ExpandableView: UIView {

    private var tableView: UITableView = UITableView()

    private var hiddenSections = Set<Int>()

    var viewModels: [FAQViewModel] = [] {
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

//    func update(withFAQs faqs: [FAQModel]) {
//        self.faqs = faqs
//    }
}

extension ExpandableView: ViewCodable {
    func configureView() {
        tableView.register(UITableViewCell.self)
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

    @objc
    private func hideSection(sender: UIButton) {
        let section = sender.tag

        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()

            for row in 0 ..< viewModels[section].rows.count {
                indexPaths.append(IndexPath(row: row, section: section))
            }

            return indexPaths
        }

        if hiddenSections.contains(section) {
            hiddenSections.remove(section)
            tableView.beginUpdates()
            tableView.insertRows(at: indexPathsForSection(), with: .fade)
            tableView.endUpdates()
        } else {
            hiddenSections.insert(section)
            tableView.beginUpdates()
            tableView.deleteRows(at: indexPathsForSection(), with: .fade)
            tableView.endUpdates()
        }
    }
}

extension ExpandableView: UITableViewDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return viewModels.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hiddenSections.contains(section) {
            return 0
        }
        return viewModels[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        cell.selectionStyle = .none
        //cell.textLabel?.text = viewModels[indexPath.section].rows[indexPath.row].first
        return cell
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        sectionButton.setTitle(viewModels[section].title, for: .normal)
        sectionButton.backgroundColor = .systemBlue
        sectionButton.tag = section
        sectionButton.addTarget(self, action: #selector(hideSection(sender:)), for: .touchUpInside)
        return sectionButton
    }
}

extension ExpandableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
