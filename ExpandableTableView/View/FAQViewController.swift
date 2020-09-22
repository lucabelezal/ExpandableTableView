import UIKit

protocol FAQViewControllerProtocol: AnyObject {
    func showView(sectionNames: [FAQModel], sectionItems: [FAQSectionViewModel])
    func showErrorView(withError error: Error)
    func showEmptyView()
}

final class FAQViewController: UIViewController {

    private var expandableTableView: ExpandableTableView {
        return view as! ExpandableTableView
    }

    private let presenter: FAQPresenterProtocol?
    private var sectionNames: [FAQModel]
    private var sectionItems: [FAQSectionViewModel]

    init(presenter: FAQPresenterProtocol?) {
        self.presenter = presenter
        self.sectionNames = []
        self.sectionItems = []
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let tableView = ExpandableTableView()
        tableView.tableFooterView = UIView()
        tableView.register(ExpandableCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        view = tableView
        view.backgroundColor = .white
        title = "FAQ"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter?.fetchQuestions()
    }
}

extension FAQViewController: FAQViewControllerProtocol {
    func showView(sectionNames: [FAQModel], sectionItems: [FAQSectionViewModel]) {
        self.sectionNames = sectionNames
        self.sectionItems = sectionItems
        self.expandableTableView.reloadData()
    }

    func showErrorView(withError error: Error) {}

    func showEmptyView() {}
}

//MARK: - ExpandableTableDataSource Protocol -

extension FAQViewController: ExpandableTableDataSource {

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

extension FAQViewController: ExpandableTableDelegate {
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
