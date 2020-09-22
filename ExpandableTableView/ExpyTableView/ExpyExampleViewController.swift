import UIKit

struct FAQTestViewModel {
    let title: String?
    let rows: [String]
}

class ExpyExampleViewController: UIViewController {

    var viewModels: [FAQTestViewModel] = [] {
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

    func transformModel(section: Section) -> [String] {
        return [section.title] + section.questions.compactMap { $0.title}
    }

}

extension ExpyExampleViewController: FAQViewControllerProtocol {
    func showView(withFAQs faqs: [FAQModel]) {

        let sections: [[String]] = faqs.enumerated().compactMap { (index, element) -> [String] in
            return transformModel(section: element.section[index])
        }

        let data: [FAQTestViewModel] = sections.enumerated().compactMap { index, rows in
            return FAQTestViewModel(title: faqs[index].title, rows: rows)
        }
        self.viewModels = data
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

//    let first: [[String]] = [
//        ["F SECTION 1 (2 Items)", "ROW 1", "ROW 2"],
//        ["F SECTION 2 (3 Items)", "ROW 1", "ROW 2", "ROW 3",]
//    ]
//
//    let second: [[String]] = [
//        ["S SECTION 1 (4 Items)", "ROW 1", "ROW 2", "ROW 3", "ROW 4"],
//        ["S SECTION 2 (1 Items)", "ROW 1"],
//        ["S SECTION 3 (2 Items)", "ROW 1", "ROW 2"],
//        ["S SECTION 4 (1 Items)", "ROW 1"],
//        ["S SECTION 5 (1 Items)", "ROW 1"],
//        ["S SECTION 6 (1 Items)", "ROW 1"],
//    ]
//
//    let third: [[String]] = [
//        ["T SECTION 1 (2 Items)", "ROW 1", "ROW 2"],
//        ["T SECTION 2 (3 Items)", "ROW 1", "ROW 2", "ROW 3",]
//    ]
//
//    let fourth: [[String]] = [
//        ["FTH SECTION 1 (4 Items)", "ROW 1", "ROW 2", "ROW 3", "ROW 4"],
//        ["FTH SECTION 2 (1 Items)", "ROW 1"]
//    ]
//
//    var sampleData: [[String]] = []

//    func transformModel(faqModels: [FAQModel]) -> [FAQViewModel] {
//        return faqModels.enumerated().compactMap { (index, faq) -> FAQViewModel in
//            let rows: [[String]] = faq.section.compactMap { section -> [String] in
//                return [section.title] + section.questions.compactMap { $0.title}
//            }
//            return FAQViewModel(title: faq.title, rows: rows)
//        }
//    }

//        let models: [[FAQViewModel]] = rows.enumerated().compactMap { (index, element) -> [FAQViewModel] in
//            return [FAQViewModel(title: "", rows: element[index])]
//        }

//            [
//            FAQViewModel(title: "DÚVIDAS GERAIS", rows: rows),
//            FAQViewModel(title: "PROGRAMA DE RELACIONAMENTO VIVA", rows: [])
//        ]

        //let dataTest: [FAQTestViewModel] = [FAQTestViewModel(models: models)]

//        let data: [FAQTestViewModel] = [
//            FAQTestViewModel(title: "DÚVIDAS GERAIS", sections: []),
//            FAQTestViewModel(title: "PROGRAMA DE RELACIONAMENTO VIVA", sections: [])
//        ]

//        let data: [FAQModel] = [
//            FAQModel(title: "DÚVIDAS GERAIS", section: [Section(title: "Cadastro", questions: [Question(id: 0, title: "1"), Question(id: 1, title: "2")])]),
//            FAQModel(title: "PROGRAMA DE RELACIONAMENTO VIVA", section: [Section(title: "Adesão", questions: [Question(id: 0, title: "1")])])
//        ]

//        let viewModels = faqs.enumerated().compactMap { (index, faq) -> FAQViewModel in
//            let rows: [[String]] = faq.section.compactMap { section -> [String] in
//                return [section.title] + section.questions.compactMap { $0.title}
//            }
//            return FAQViewModel(title: faq.title, rows: rows)
//        }

//        let section1 = [
//            ["titulo", "queation 1"],
//            ["titulo", "queation 1"],
//        ]
//
//        let section2 = [
//            [""],
//            [""],
//        ]

//        let viewModels = faqs.enumerated().compactMap { (index, faq) -> FAQViewModel in
//            var rows: [[String]] = []
//            rows += [[faq.section[index].title] + faq.section[index].questions.compactMap { $0.title}]
//
//            return FAQViewModel(title: faq.title, rows: rows)
//        }
