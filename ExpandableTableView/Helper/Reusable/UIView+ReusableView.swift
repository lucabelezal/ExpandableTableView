//
//  UIView+ReusableView.swift
//  StackViewCellExpandable
//
//  Created by Lucas Nascimento on 04/08/18.
//  Copyright © 2018 Lucas Nascimento. All rights reserved.
//

import UIKit

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableView { }
