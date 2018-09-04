//
//  LayoutView.swift
//  AnchorConstraints
//
//  Created by Vinicius França on 17/04/2018.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import UIKit

extension LayoutView {
    
    var layout: LayoutViewConstraint {
        return LayoutViewConstraint(view: self)
    }
    
    @available(*, deprecated)
    func add(_ subviews: UIView...) {
        subviews.forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func addView(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
}
