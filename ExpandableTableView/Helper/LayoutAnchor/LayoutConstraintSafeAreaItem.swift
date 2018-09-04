//
//  LayoutConstraintSafeAreaItem.swift
//  LayoutAnchor
//
//  Created by Vinicius França Nunes Silva on 16/05/2018.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import Foundation

class LayoutConstraintSafeAreaItem: LayoutConstraintItemable {

    internal let attribute: LayoutAttribute
    internal let view: LayoutView
    internal let isSafeArea: Bool

    required init(view: LayoutView, attribute: LayoutAttribute) {
        self.view = view
        self.attribute = attribute
        self.isSafeArea = true
    }

}
