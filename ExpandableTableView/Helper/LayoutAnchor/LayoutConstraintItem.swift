//
//  LayoutConstraintItem.swift
//  LayoutAnchor
//
//  Created by Vinicius França on 10/05/2018.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import Foundation

class LayoutConstraintItem: LayoutConstraintItemable {
    
    internal let attribute: LayoutAttribute
    internal let view: LayoutView
    internal let isSafeArea: Bool

    required init(view: LayoutView, attribute: LayoutAttribute) {
        self.view = view
        self.attribute = attribute
        self.isSafeArea = false
    }
    
}
