import UIKit

final class ExampleViewController: UIViewController {

    private var sectionNames: [FAQModel] = []
    private var sectionItems: [FAQSectionViewModel] = [] {
        didSet {
            expandableTableView.reloadData()
        }
    }

    private let expandableTableView = ExpandableTableView()
    private let presenter: FAQPresenterProtocol?

    init(presenter: FAQPresenterProtocol?) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        expandableTableView.dataSource = self
        expandableTableView.delegate = self
        expandableTableView.separatorStyle = .none
        expandableTableView.register(ExpandableCell.self)
        expandableTableView.rowHeight = UITableView.automaticDimension
        expandableTableView.estimatedRowHeight = 56
        expandableTableView.tableFooterView = UIView()

        view.addSubview(expandableTableView)
        expandableTableView.backgroundColor = .lightGray
        expandableTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandableTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            expandableTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            expandableTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandableTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        navigationItem.title = "FAQs"
        presenter?.fetchQuestions()
    }

    func transformRows(section: Section) -> [String] {
        return [section.title] + section.questions.compactMap { $0.title }
    }

}

extension ExampleViewController: FAQViewControllerProtocol {
    func showView(withFAQs faqs: [FAQModel]) {
        self.sectionNames = faqs

        var sections: [FAQSectionViewModel] = []


        for (index, element) in faqs.enumerated() {
            for section in faqs[index].section {
                var title: String?
                if section == faqs[index].section.first {
                    title = element.title
                }
                sections += [FAQSectionViewModel(title: title, rows: transformRows(section: section))]
            }
        }

        self.sectionItems = sections
    }

    func showErrorView(withError error: Error) {}

    func showEmptyView() {}
}

//MARK: - ExpandableTableDataSource Protocol -

extension ExampleViewController: ExpandableTableDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionItems.isEmpty { return 0 }
        return sectionItems.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sectionItems.isEmpty { return 0 }
        return sectionItems[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExpandableCell.self)) as! ExpandableCell
        let title = sectionItems[indexPath.section].rows[indexPath.row]
        cell.update(title: title)
        cell.arrowImageView.image = nil
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = .blue
        return cell
    }

    func tableView(_ tableView: ExpandableTableView, canExpandSection section: Int) -> Bool {
        return true
    }

    func tableView(_ tableView: ExpandableTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExpandableCell.self)) as! ExpandableCell
        cell.textLabel?.text = sectionItems[section].rows.first
        cell.layoutMargins = .zero
        cell.backgroundColor = .orange
        cell.selectionStyle = .none
        return cell
    }
}

//MARK: - ExpandableTableDelegate Protocol -

extension ExampleViewController: ExpandableTableDelegate {
    func tableView(_ tableView: ExpandableTableView, changeForSection section: Int) {}

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionItems[section].title
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
