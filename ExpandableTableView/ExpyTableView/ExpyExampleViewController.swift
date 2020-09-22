import UIKit

struct FAQSectionViewModel {
    let title: String?
    let rows: [String]
}

class ExpyExampleViewController: UIViewController {

    var faqs: [FAQModel] = []
    var viewModels: [FAQSectionViewModel] = [] {
        didSet {
            expandableTableView.reloadData()
        }
    }

    let expandableTableView: ExpyTableView = ExpyTableView()

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

        view.addSubview(expandableTableView)
        expandableTableView.backgroundColor = .lightGray
        expandableTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            expandableTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            expandableTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            expandableTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            expandableTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

                expandableTableView.dataSource = self
                expandableTableView.delegate = self
                expandableTableView.separatorStyle = .none

                expandableTableView.register(ExpandableCell.self)
                expandableTableView.rowHeight = UITableView.automaticDimension
                expandableTableView.estimatedRowHeight = 44

                expandableTableView.expandingAnimation = .fade
                expandableTableView.collapsingAnimation = .fade

                expandableTableView.tableFooterView = UIView()

                navigationItem.title = "FAQs"

        presenter?.fetchQuestions()
    }

    func transformRows(section: Section) -> [String] {
        return [section.title] + section.questions.compactMap { $0.title }
    }

}

extension ExpyExampleViewController: FAQViewControllerProtocol {
    func showView(withFAQs faqs: [FAQModel]) {
        self.faqs = faqs

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

        self.viewModels = sections
    }

    func showErrorView(withError error: Error) {}

    func showEmptyView() {}
}

//MARK: UITableView Data Source Methods
extension ExpyExampleViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModels.isEmpty { return 0 }
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModels.isEmpty { return 0 }
        return viewModels[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExpandableCell.self)) as! ExpandableCell
        let title = viewModels[indexPath.section].rows[indexPath.row]
         cell.update(title: title)
         cell.arrowImageView.image = nil
         cell.layoutMargins = UIEdgeInsets.zero
         cell.backgroundColor = .blue
         return cell
    }
}

//MARK: ExpyTableViewDataSourceMethods
extension ExpyExampleViewController: ExpyTableViewDataSource {

    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }

    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ExpandableCell.self)) as! ExpandableCell
        cell.textLabel?.text = viewModels[section].rows.first
        cell.layoutMargins = UIEdgeInsets.zero
        cell.backgroundColor = .orange
        return cell
    }
}

//MARK: ExpyTableView delegate methods
extension ExpyExampleViewController: ExpyTableViewDelegate {
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {}
}

extension ExpyExampleViewController {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModels[section].title
    }
}

extension ExpyExampleViewController {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
