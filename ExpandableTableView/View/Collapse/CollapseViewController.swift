import UIKit

class CollapseViewController: UIViewController {

    let scrollableStack: BrMScrollableStack = BrMScrollableStack()
    let factory = CollapseTableViewFactory()

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

        view.addSubview(scrollableStack)
        scrollableStack.backgroundColor = .cyan
        scrollableStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollableStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollableStack.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollableStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollableStack.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        presenter?.fetchQuestions()
    }
}

extension CollapseViewController: FAQViewControllerProtocol {
    func showView(withFAQs faqs: [FAQModel]) {
        scrollableStack.update(with: [])
    }

    func showErrorView(withError error: Error) {}
    func showEmptyView() {}
}

struct FAQViewModel {
    let title: String
    let rows: [String]
}

//------------------------------------------------- VIEW -------------------------------------------------------------------------------

class CollapseView: UIView {

    let tableView: CollapseTableView = CollapseTableView()

    var sections: [Section] = []
    var title: String = ""

    var viewModels: [FAQViewModel] = []

    init(frame: CGRect = .zero, viewModels: [FAQViewModel]) {
        self.viewModels = viewModels
        super.init(frame: frame)

        setupTableView()

        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = 44
        tableView.didTapSectionHeaderView = { (sectionIndex, isOpen) in
            debugPrint("sectionIndex \(sectionIndex), isOpen \(isOpen)")
        }
    }

    init(frame: CGRect = .zero, title: String, sections: [Section]) {
        self.title = title
        self.sections = sections
        super.init(frame: frame)

        setupTableView()

        tableView.isScrollEnabled = false
        tableView.estimatedRowHeight = 44
        tableView.didTapSectionHeaderView = { (sectionIndex, isOpen) in
            debugPrint("sectionIndex \(sectionIndex), isOpen \(isOpen)")
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

        tableView.backgroundColor = .lightGray
        tableView.delegate = self
        tableView.dataSource = self

        let tableHeaderView = HeaderView(frame: CGRect(origin: .zero, size: CGSize(width: .zero, height: 40)))
        tableHeaderView.titleLabel.text = title

        tableHeaderView.backgroundColor = .purple
        tableView.tableHeaderView = tableHeaderView

        tableView.tableFooterView = UIView(frame: .zero)

        tableView.register(UITableViewCell.self)
        tableView.register(SectionHeaderView.self, forHeaderFooterViewReuseIdentifier: SectionHeaderView.reuseIdentifier)
    }

    func reloadTableView(_ completion: @escaping () -> Void) {
        CATransaction.begin()
        CATransaction.setCompletionBlock { completion() }
        tableView.reloadData()
        CATransaction.commit()
    }
}

extension CollapseView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: SectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as! SectionHeaderView
        view.textLabel?.text = viewModels[section].title
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
