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
        let views = faqs.compactMap { faq in
            factory.create(title: faq.title, sections: faq.section)
        }

        scrollableStack.update(with: views)
        
        //scrollableStack.setCustom(space: -560, after: CollapseView.self)

//        let view0 = views[0]
//        let view1 = views[1]
//
//
//        view.addSubview(view0)
//        view.addSubview(view1)
//
//        view0.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            view0.heightAnchor.constraint(equalToConstant: 420),
//            view0.topAnchor.constraint(equalTo: view.topAnchor),
//            view0.bottomAnchor.constraint(equalTo: view1.topAnchor, constant: 16),
//            view0.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            view0.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
//
//        view1.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            //view1.heightAnchor.constraint(equalToConstant: 100),
//            view1.topAnchor.constraint(equalTo: view0.bottomAnchor),
//            view1.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//            view1.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            view1.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
    }

    func showErrorView(withError error: Error) {}

    func showEmptyView() {}
}

//------------------------------------------------- VIEW -------------------------------------------------------------------------------

class CollapseView: UIView {

    let tableView: CollapseTableView = CollapseTableView()

    var sections: [Section]
    var title: String

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

        //tableView.tableFooterView = UIView(frame: .zero)

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
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].questions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        cell.textLabel?.text = sections[indexPath.section].questions[indexPath.row].title
        return cell
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view: SectionHeaderView = tableView.dequeueReusableHeaderFooterView(withIdentifier: SectionHeaderView.reuseIdentifier) as! SectionHeaderView
        view.textLabel?.text = sections[section].title
        return view
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44//UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44 //UITableView.automaticDimension
    }
}
