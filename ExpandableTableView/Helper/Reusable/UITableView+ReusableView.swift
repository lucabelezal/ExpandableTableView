//
//  UITableView+ReusableView.swift
//  StackViewCellExpandable
//
//  Created by Lucas Nascimento on 04/08/18.
//  Copyright © 2018 Lucas Nascimento. All rights reserved.
//

import UIKit

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: cellType.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: cellType.reuseIdentifier, for: indexPath) as? T
    }
}
