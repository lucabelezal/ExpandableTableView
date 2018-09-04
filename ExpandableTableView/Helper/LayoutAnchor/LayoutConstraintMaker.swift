//
//  LayoutConstraintMaker.swift
//  AnchorConstraints
//
//  Created by Vinicius França on 12/04/2018.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import Foundation

class LayoutConstraintMaker {
    
    internal let view: LayoutView
    
    required init(view: LayoutView) {
        self.view = view
    }

}

extension LayoutConstraintMaker {
    
    public var left: LayoutConstraintMakerExtendable {
        return LayoutConstraintMakerExtendable(view: view, attribute: .left)
    }
    
    public var right: LayoutConstraintMakerExtendable {
        return LayoutConstraintMakerExtendable(view: view, attribute: .right)
    }
    
    public var top: LayoutConstraintMakerExtendable {
        return LayoutConstraintMakerExtendable(view: view, attribute: .top)
    }
    
    public var bottom: LayoutConstraintMakerExtendable {
        return LayoutConstraintMakerExtendable(view: view, attribute: .bottom)
    }
    
    public var width: LayoutConstraintMakerExtendable {
        return LayoutConstraintMakerExtendable(view: view, attribute: .width)
    }
    
    public var height: LayoutConstraintMakerExtendable {
        return LayoutConstraintMakerExtendable(view: view, attribute: .height)
    }
    
    public var centerX: LayoutConstraintMakerExtendable {
        return LayoutConstraintMakerExtendable(view: view, attribute: .centerX)
    }
    
    public var centerY: LayoutConstraintMakerExtendable {
        return LayoutConstraintMakerExtendable(view: view, attribute: .centerY)
    }
    
    public var leading: LayoutConstraintMakerExtendable {
        return LayoutConstraintMakerExtendable(view: view, attribute: .leading)
    }
    
    public var trailing: LayoutConstraintMakerExtendable {
        return LayoutConstraintMakerExtendable(view: view, attribute: .trailing)
    }
    
}

