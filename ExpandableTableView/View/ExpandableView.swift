//
//  ExpandableView.swift
//  ExpandableTableView
//
//  Created by Lucas Nascimento on 19/08/18.
//  Copyright © 2018 Lucas Nascimento. All rights reserved.
//

import UIKit

class ExpandableView: UIView {
    
    private var cellHeights: [Int: [Int: CGFloat]] = [:]
    private var selectedIndexPath: IndexPath?
    private var tableView: UITableView
    var items = Item.allItems()
    
    override init(frame: CGRect) {
        tableView = UITableView(frame: frame, style: .plain)
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExpandableView: ViewCodable {
    func configureView() {
        tableView.register(ExpandableCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        tableView.separatorInset = .zero
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.backgroundColor = UIColor.white
    }
    
    func configureHierarchy() {
        addView(tableView)
    }
    
    func configureConstraints() {
        
        tableView.layout.makeConstraints { make in
            make.top.equalTo(layout.safeArea.top)
            make.bottom.equalTo(layout.safeArea.bottom)
            make.leading.equalTo(layout.leading)
            make.trailing.equalTo(layout.trailing)
        }
    }
}

extension ExpandableView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: ExpandableCell = tableView.dequeueReusableCell(ExpandableCell.self, for: indexPath)!
        cell.selectionStyle = .none
        
        let item = items[indexPath.row]
        cell.update(item)
        return cell
    }
}

extension ExpandableView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let dict = cellHeights[indexPath.section] {
            if dict.keys.contains(indexPath.row) {
                return dict[indexPath.row]!
            } else {
                cellHeights[indexPath.section]![indexPath.row] = UITableViewAutomaticDimension
                return UITableViewAutomaticDimension
            }
        }
        
        cellHeights[indexPath.section] = [:]
        cellHeights[indexPath.section]![indexPath.row] = UITableViewAutomaticDimension
        return cellHeights[indexPath.section]![indexPath.row]!
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let dict = cellHeights[indexPath.section], dict[indexPath.row] == UITableViewAutomaticDimension {
            cellHeights[indexPath.section]![indexPath.row] = cell.bounds.height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedIndexPath == nil {
            expand(indexPath: indexPath)
        }
        
        if selectedIndexPath == indexPath {
            expand(indexPath: indexPath)
        }
        
        if let lastIndexPath = selectedIndexPath, selectedIndexPath != indexPath {
            collapse(lastIndexPath: lastIndexPath, indexPath: indexPath)
        }
        
        self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.middle, animated: true)
        
        selectedIndexPath = indexPath
    }
    
    func expand(indexPath: IndexPath) {
        let subject = items[indexPath.row]
        subject.isExpanded = !subject.isExpanded
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func collapse(lastIndexPath: IndexPath, indexPath: IndexPath) {
        let lastSubject = items[lastIndexPath.row]
        lastSubject.isExpanded = false
        
        let subject = items[indexPath.row]
        subject.isExpanded = !subject.isExpanded
        
        self.tableView.reloadRows(at: [indexPath, lastIndexPath], with: .fade)
    }
}
