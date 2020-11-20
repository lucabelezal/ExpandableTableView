# Expandable Table View


### Copy the files that are in the Skeleton folder

```
ExpandableTableView    
├───Component
│   ├───ExpandableAbstractions.swift
│   └───ExpandableTableView.swift
│
```

### How to use

Instead of using the standard protocols `UITableViewDataSource` and `UITableViewDelegate`, use `ExpandableTableDataSource` and
ExpandableTableDelegate`.

See the implementation below used in the class [FAQView](https://github.com/lucabelezal/ExpandableTableView/blob/master/ExpandableTableView/Example/View/FAQView.swift):

```swift
   private lazy var expandableTableView: ExpandableTableView = {
        let tableView = ExpandableTableView()
        tableView.register(FAQHeaderViewCell.self)
        tableView.register(FAQViewCell.self)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
```

```swift
extension FAQView: ExpandableTableDataSource {
    func numberOfSections(in _: UITableView) -> Int {
        return faqItems.count
    }

    func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqItems[section].rows.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FAQViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let title = faqItems[indexPath.section].rows[indexPath.row]
        cell.update(title: title)
        cell.accessibilityLabel = title
        return cell
    }

    func tableView(_: ExpandableTableView, canExpandSection _: Int) -> Bool {
        return true
    }

    func tableView(_ tableView: ExpandableTableView, expandableCellForSection section: Int) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: FAQHeaderViewCell.self)) as? FAQHeaderViewCell
        else { return UITableViewCell() }
        let title = faqItems[section].rows.first
        cell.update(title: title)
        return cell
    }
}

extension FAQView: ExpandableTableDelegate {
    func tableView(_: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = FAQHeaderView()
        headerView.update(title: faqItems[section].title)
        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard isFirstRowAt(indexPath: indexPath) else { return }
        let sectionItem = faqItems[indexPath.section]
        let questionAnswer = QuestionAnswerModel(
            navigationTitle: sectionItem.rows.first,
            title: sectionItem.rows[indexPath.row],
            answerID: sectionItem.ids[indexPath.row]
        )
        delegate?.didSelectQuestion(questionAnswer: questionAnswer)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 56
    }

    func tableView(_: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return faqItems[section].title != nil ? 80 : 0
    }
}
```

<p align="center">
  <img src="https://github.com/lucabelezal/ExpandableTableView/blob/master/gif/example.gif" width="250" />
</p>
