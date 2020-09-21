import UIKit

class TestViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var hiddenSections = Set<Int>()
    let tableViewData = [
        ["1", "2", "3", "4", "5"],
        ["1", "2", "3", "4", "5"],
        ["1", "2", "3", "4", "5"],
        ["1", "2", "3", "4", "5"],
        ["1", "2", "3", "4", "5"]
    ]

    let tableView: UITableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self)

        view.addSubview(tableView)
        tableView.backgroundColor = .lightGray
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    func numberOfSections(in _: UITableView) -> Int {
        return tableViewData.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hiddenSections.contains(section) {
            return 0
        }
        return tableViewData[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        cell.textLabel?.text = tableViewData[indexPath.section][indexPath.row]
        return cell
    }

    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionButton = UIButton()
        sectionButton.setTitle(String(section), for: .normal)
        sectionButton.backgroundColor = .systemBlue
        sectionButton.tag = section
        sectionButton.addTarget(self, action: #selector(hideSection(sender:)), for: .touchUpInside)
        return sectionButton
    }

    @objc
    private func hideSection(sender: UIButton) {
        let section = sender.tag

        func indexPathsForSection() -> [IndexPath] {
            var indexPaths = [IndexPath]()

            for row in 0 ..< tableViewData[section].count {
                indexPaths.append(IndexPath(row: row, section: section))
            }

            return indexPaths
        }

        if hiddenSections.contains(section) {
            hiddenSections.remove(section)
            tableView.insertRows(at: indexPathsForSection(), with: .fade)
        } else {
            hiddenSections.insert(section)
            tableView.deleteRows(at: indexPathsForSection(), with: .fade)
        }
    }
}
