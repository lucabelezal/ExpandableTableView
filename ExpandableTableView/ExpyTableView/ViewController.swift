import UIKit

final class ViewController: UIViewController {
    var expandableTableView: UITableView = UITableView()

    let kHeaderSectionTag: Int = 6900
    var currentExpandedSectionHeader: UITableViewHeaderFooterView = UITableViewHeaderFooterView()
    var currentExpandedSectionHeaderNumbers: [Int] = [-1, -1, -1]

    var sectionNames: [String] = []
    var sectionItems: [[String]] = [[]]

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

        sectionNames = ["Asia", "Europe", "Africa"]
        sectionItems = [
            ["Pakistan", "India", "Srilanka", "China", "Bangladesh", "Japan"],
            ["Germany", "Italy", "France", "Greece"],
            ["Algeria", "Nigeria", "Senegal"]
        ]

        expandableTableView.register(UITableViewCell.self)
        expandableTableView.delegate = self
        expandableTableView.dataSource = self

        let headerView = HeaderView(frame: CGRect(origin: .zero, size: CGSize(width: .zero, height: 60)))
        headerView.titleLabel.text = "headerView"
        headerView.backgroundColor = .orange

        let footerView = HeaderView(frame: CGRect(origin: .zero, size: CGSize(width: .zero, height: 60)))
        footerView.titleLabel.text = "footerView"
        footerView.backgroundColor = .purple

        expandableTableView.tableFooterView = footerView
        expandableTableView.tableHeaderView = headerView
    }
}

// MARK: - Expand / Collapse Methods

extension ViewController {
    @objc
    func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section = headerView.tag
        let currentlyTouchedHeaderImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView

        if !isAnySectionExpanded() {
            currentExpandedSectionHeaderNumbers[section] = section
            expandTableViewSection(section, imageView: currentlyTouchedHeaderImageView!)
        } else {
            if currentExpandedSectionHeaderNumbers[section] != -1 {
                collapseTableViewSection(section, imageView: currentlyTouchedHeaderImageView!)
            } else {
                collpaseAlreadyExpandedSection()
                expandTableViewSection(section, imageView: currentlyTouchedHeaderImageView!)
            }
        }
    }

    func collapseTableViewSection(_ section: Int, imageView: UIImageView) {
        let sectionData = sectionItems[section]

        currentExpandedSectionHeaderNumbers[section] = -1

        if sectionData.count == 0 {
            return
        } else {
            UIView.animate(withDuration: 0.4) {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
            }

            var indexPaths = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexPaths.append(index)
            }

            expandableTableView.beginUpdates()
            expandableTableView.deleteRows(at: indexPaths, with: .fade)
            expandableTableView.endUpdates()
        }
    }

    func expandTableViewSection(_ section: Int, imageView: UIImageView) {
        let sectionData = sectionItems[section]

        if sectionData.count == 0 {
            currentExpandedSectionHeaderNumbers[section] = -1
            return
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (180.0 * CGFloat(Double.pi)) / 180.0)
            })

            var indexesPath = [IndexPath]()

            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }

            currentExpandedSectionHeaderNumbers[section] = section

            expandableTableView.beginUpdates()
            expandableTableView.insertRows(at: indexesPath, with: .fade)
            expandableTableView.endUpdates()
        }
    }

    private func isAnySectionExpanded() -> Bool {
        for i in 0 ..< currentExpandedSectionHeaderNumbers.count {
            if currentExpandedSectionHeaderNumbers[i] != -1 {
                return true
            }
        }
        return false
    }

    private func collpaseAlreadyExpandedSection() {
        for section in 0 ..< currentExpandedSectionHeaderNumbers.count {
            if currentExpandedSectionHeaderNumbers[section] != -1 {
                let alreadyExpandedHeaderImageView = view.viewWithTag(kHeaderSectionTag + section) as? UIImageView ?? UIImageView()
                collapseTableViewSection(section, imageView: alreadyExpandedHeaderImageView)
            }
        }
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tableView.backgroundView = nil
            return sectionNames.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentExpandedSectionHeaderNumbers[section] != -1 {
            let arrayOfItems = sectionItems[section]
            return arrayOfItems.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self))!
        let section = sectionItems[indexPath.section]
        cell.textLabel?.textColor = .green
        cell.textLabel?.text = section[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60.0
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {

        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = .red
        header.textLabel?.textColor = .blue
        header.tag = section

        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(ViewController.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)

        if let viewWithTag = view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }

        let headerFrame = view.frame.size

        let chevronImageView = UIImageView(frame: CGRect(x: headerFrame.width - 32, y: 13, width: 18, height: 18))
        chevronImageView.image = UIImage(named: "expand-button")
        chevronImageView.tag = kHeaderSectionTag + section

        header.addSubview(chevronImageView)
    }
}
