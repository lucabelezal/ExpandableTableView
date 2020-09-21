import UIKit

class CustomizationExampleViewController: UIViewController {

    var faqs: [FAQModel] {
        let jsonData = JSONHelper.getDataFrom(json: "FAQs")!
         return try! JSONDecoder().decode([FAQModel].self, from: jsonData)
    }

    private var expandableTableView: ExpyTableView {
        return view as! ExpyTableView
    }

    override func loadView() {
        view = ExpyTableView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        expandableTableView.register(PhoneNameTableViewCell.self)
        expandableTableView.register(BuyTableViewCell.self)
        expandableTableView.register(SpecificationTableViewCell.self)
        expandableTableView.backgroundColor = .white

        expandableTableView.dataSource = self
        expandableTableView.delegate = self

        expandableTableView.rowHeight = UITableView.automaticDimension
        expandableTableView.estimatedRowHeight = 44


        expandableTableView.tableFooterView = UIView()

        navigationItem.title = "FAQs"
    }
}
extension CustomizationExampleViewController: ExpyTableViewDelegate {
    func tableView(_ tableView: ExpyTableView, expyState state: ExpyState, changeForSection section: Int) {

        switch state {
        case .willExpand:
            print("WILL EXPAND")

        case .willCollapse:
            print("WILL COLLAPSE")
        }
    }
}

extension CustomizationExampleViewController: ExpyTableViewDataSource {
      func numberOfSections(in tableView: UITableView) -> Int {
        return faqs[0].section.count
      }

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          let count = faqs[0].section[section].questions.count + 1
          return count
      }

      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SpecificationTableViewCell.self)) as! SpecificationTableViewCell
        cell.labelSpecification.text = faqs[0].section[indexPath.section].questions[indexPath.row - 1].title
          cell.backgroundColor = .white
          cell.labelSpecification.textColor = .black
          cell.selectionStyle = .none
          cell.layoutMargins = UIEdgeInsets.zero
          cell.hideSeparator()
          return cell
      }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return faqs[0].section[section].title
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: ExpyTableView, canExpandSection section: Int) -> Bool {
        return true
    }

    func tableView(_ tableView: ExpyTableView, expandableCellForSection section: Int) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PhoneNameTableViewCell.self)) as! PhoneNameTableViewCell

        cell.titleLabel.text = faqs[0].section[section].title
        cell.layoutMargins = UIEdgeInsets.zero
        cell.showSeparator()
        cell.backgroundColor = .white
        cell.titleLabel.textColor = .black
        cell.selectionStyle = .none
        return cell
    }
}

