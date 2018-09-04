//
//  LayoutConstraint.swift
//  AnchorConstraints
//
//  Created by Vinicius França on 12/04/2018.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import Foundation

class LayoutViewConstraint {
    
    internal let view: LayoutView
    
    required init(view: LayoutView) {
        self.view = view
    }

    public func makeConstraints(_ completion: (_ make: LayoutConstraintMaker) -> Void) {
        completion(LayoutConstraintMaker(view: configureTranslatesAutoresizing(view)))
    }
    
    public func make(then completion: (_ make: LayoutConstraintMaker) -> Void) {
        completion(LayoutConstraintMaker(view: configureTranslatesAutoresizing(view)))
    }
    
    private func configureTranslatesAutoresizing(_ view: LayoutView) -> LayoutView {
        if view.translatesAutoresizingMaskIntoConstraints {
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }
        return view
    }
    
}

extension LayoutViewConstraint {
    
    public var left: LayoutConstraintItem {
        return LayoutConstraintItem(view: view, attribute: .left)
    }

    public var right: LayoutConstraintItem {
        return LayoutConstraintItem(view: view, attribute: .right)
    }

    public var top: LayoutConstraintItem {
        return LayoutConstraintItem(view: view, attribute: .top)
    }

    public var bottom: LayoutConstraintItem {
        return LayoutConstraintItem(view: view, attribute: .bottom)
    }
    
    public var width: LayoutConstraintItem {
        return LayoutConstraintItem(view: view, attribute: .width)
    }

    public var height: LayoutConstraintItem {
        return LayoutConstraintItem(view: view, attribute: .height)
    }
    
    public var centerX: LayoutConstraintItem {
        return LayoutConstraintItem(view: view, attribute: .centerX)
    }

    public var centerY: LayoutConstraintItem {
        return LayoutConstraintItem(view: view, attribute: .centerY)
    }
    
    public var leading: LayoutConstraintItem {
        return LayoutConstraintItem(view: view, attribute: .leading)
    }

    public var trailing: LayoutConstraintItem {
        return LayoutConstraintItem(view: view, attribute: .trailing)
    }

    public var safeArea: LayoutViewConstraintSafeArea {
        return LayoutViewConstraintSafeArea(view: view)
    }

}
