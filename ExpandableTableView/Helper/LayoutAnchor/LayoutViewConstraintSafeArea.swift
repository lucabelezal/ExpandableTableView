//
//  LayoutConstraintSafeArea.swift
//  LayoutAnchor
//
//  Created by Vinicius França Nunes Silva on 16/05/2018.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import Foundation

class LayoutViewConstraintSafeArea {

    internal let view: LayoutView

    required init(view: LayoutView) {
        self.view = view
    }

}

extension LayoutViewConstraintSafeArea {

    public var left: LayoutConstraintSafeAreaItem {
        return LayoutConstraintSafeAreaItem(view: view, attribute: .left)
    }

    public var right: LayoutConstraintSafeAreaItem {
        return LayoutConstraintSafeAreaItem(view: view, attribute: .right)
    }

    public var top: LayoutConstraintSafeAreaItem {
        return LayoutConstraintSafeAreaItem(view: view, attribute: .top)
    }

    public var bottom: LayoutConstraintSafeAreaItem {
        return LayoutConstraintSafeAreaItem(view: view, attribute: .bottom)
    }

    public var width: LayoutConstraintSafeAreaItem {
        return LayoutConstraintSafeAreaItem(view: view, attribute: .width)
    }

    public var height: LayoutConstraintSafeAreaItem {
        return LayoutConstraintSafeAreaItem(view: view, attribute: .height)
    }

    public var centerX: LayoutConstraintSafeAreaItem {
        return LayoutConstraintSafeAreaItem(view: view, attribute: .centerX)
    }

    public var centerY: LayoutConstraintSafeAreaItem {
        return LayoutConstraintSafeAreaItem(view: view, attribute: .centerY)
    }

    public var leading: LayoutConstraintSafeAreaItem {
        return LayoutConstraintSafeAreaItem(view: view, attribute: .leading)
    }

    public var trailing: LayoutConstraintSafeAreaItem {
        return LayoutConstraintSafeAreaItem(view: view, attribute: .trailing)
    }
}
