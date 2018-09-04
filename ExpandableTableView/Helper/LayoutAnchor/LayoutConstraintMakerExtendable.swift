//
//  LayoutConstraintMakerExtendable.swift
//  AnchorConstraints
//
//  Created by Vinicius França on 12/04/2018.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import UIKit

class LayoutConstraintMakerExtendable {
    
    fileprivate let view: LayoutView
    fileprivate let attribute: LayoutAttribute
    
    required init(view: LayoutView, attribute: LayoutAttribute) {
        self.view = view
        self.attribute = attribute
    }
    
}

extension LayoutConstraintMakerExtendable {
        
    fileprivate func configure(layoutX item: LayoutConstraintItemable) -> LayoutXAnchor {
        switch item.attribute {
        case .left:
            if #available(iOS 11.0, *), item.isSafeArea {
                return item.view.safeAreaLayoutGuide.leftAnchor
            }
            return item.view.leftAnchor
        case .right:
            if #available(iOS 11.0, *), item.isSafeArea {
                return item.view.safeAreaLayoutGuide.rightAnchor
            }
            return item.view.rightAnchor
        case .centerX:
            if #available(iOS 11.0, *), item.isSafeArea {
                return item.view.safeAreaLayoutGuide.centerXAnchor
            }
            return item.view.centerXAnchor
        case .leading:
            if #available(iOS 11.0, *), item.isSafeArea {
                return item.view.safeAreaLayoutGuide.leadingAnchor
            }
            return item.view.leadingAnchor
        case .trailing:
            if #available(iOS 11.0, *), item.isSafeArea {
                return item.view.safeAreaLayoutGuide.trailingAnchor
            }
            return item.view.trailingAnchor
        default:
            fatalError("Use LayoutXAnchor only with: left, right, leading, trailing and centerX")
        }
    }
    
    fileprivate func configure(layoutY item: LayoutConstraintItemable) -> LayoutYAnchor {
        switch item.attribute {
        case .top:
            if #available(iOS 11.0, *), item.isSafeArea {
                return item.view.safeAreaLayoutGuide.topAnchor
            }
            return item.view.topAnchor
        case .bottom:
            if #available(iOS 11.0, *), item.isSafeArea {
                return item.view.safeAreaLayoutGuide.bottomAnchor
            }
            return item.view.bottomAnchor
        case .centerY:
            if #available(iOS 11.0, *), item.isSafeArea {
                return item.view.safeAreaLayoutGuide.centerYAnchor
            }
            return item.view.centerYAnchor
        default:
            fatalError("Use LayoutYAnchor only with: top, bottom and centerY")
        }
    }
    
    fileprivate func configure(dimension item: LayoutConstraintItemable) -> LayoutDimensionAnchor {
        switch item.attribute {
        case .height:
            if #available(iOS 11.0, *), item.isSafeArea {
                return item.view.safeAreaLayoutGuide.heightAnchor
            }
            return item.view.heightAnchor
        case .width:
            if #available(iOS 11.0, *), item.isSafeArea {
                return item.view.safeAreaLayoutGuide.widthAnchor
            }
            return item.view.widthAnchor
        default:
            fatalError("Use LayoutDimensionAnchor only with: height and width")
        }
    }
    
}


extension LayoutConstraintMakerExtendable: LayoutConstraintMakerRelatable {
    
    @discardableResult
    func equalTo(_ item: LayoutConstraintItemable, constant: CGFloat = 0) -> LayoutConstraintMakerSupportable {
        var constantAnchor: LayoutConstraint?
        switch attribute {
        case .left:
            constantAnchor = view.leftAnchor.constraint(equalTo: configure(layoutX: item), constant: constant)
        case .right:
            constantAnchor = view.rightAnchor.constraint(equalTo: configure(layoutX: item), constant: constant)
        case .top:
            constantAnchor = view.topAnchor.constraint(equalTo: configure(layoutY: item), constant: constant)
        case .bottom:
            constantAnchor = view.bottomAnchor.constraint(equalTo: configure(layoutY: item), constant: constant)
        case .width:
            constantAnchor = view.widthAnchor.constraint(equalTo: configure(dimension: item), constant: constant)
        case .height:
            constantAnchor = view.heightAnchor.constraint(equalTo: configure(dimension: item), constant: constant)
        case .centerY:
            constantAnchor = view.centerYAnchor.constraint(equalTo: configure(layoutY: item), constant: constant)
        case .centerX:
            constantAnchor = view.centerXAnchor.constraint(equalTo: configure(layoutX: item), constant: constant)
        case .leading:
            constantAnchor = view.leadingAnchor.constraint(equalTo: configure(layoutX: item), constant: constant)
        case .trailing:
            constantAnchor = view.trailingAnchor.constraint(equalTo: configure(layoutX: item), constant: constant)
        default:
            fatalError("Layout attribute not implemented (Yet!)")
        }
        constantAnchor?.priority = LayoutPriority(rawValue: 999)
        constantAnchor?.isActive = true
        return LayoutConstraintMakerSupportable(constant: constantAnchor)
    }
    
    @discardableResult
    func equalTo(constant: CGFloat) -> LayoutConstraintMakerSupportable {
        var constantAnchor: LayoutConstraint?
        switch attribute {
        case .width:
            constantAnchor = view.widthAnchor.constraint(equalToConstant: constant)
        case .height:
            constantAnchor = view.heightAnchor.constraint(equalToConstant: constant)
        default:
            fatalError("Layout attribute not implemented")
        }
        constantAnchor?.priority = LayoutPriority(rawValue: 999)
        constantAnchor?.isActive = true
        return LayoutConstraintMakerSupportable(constant: constantAnchor)
    }
    
    @discardableResult
    func greaterThanOrEqualTo(_ item: LayoutConstraintItemable, constant: CGFloat = 0) -> LayoutConstraintMakerSupportable {
        var constantAnchor: LayoutConstraint?
        switch attribute {
        case .left:
            constantAnchor = view.leftAnchor.constraint(greaterThanOrEqualTo: configure(layoutX: item), constant: constant)
        case .right:
            constantAnchor = view.rightAnchor.constraint(greaterThanOrEqualTo: configure(layoutX: item), constant: constant)
        case .top:
            constantAnchor = view.topAnchor.constraint(greaterThanOrEqualTo: configure(layoutY: item), constant: constant)
        case .bottom:
            constantAnchor = view.bottomAnchor.constraint(greaterThanOrEqualTo: configure(layoutY: item), constant: constant)
        case .width:
            constantAnchor = view.widthAnchor.constraint(greaterThanOrEqualTo: configure(dimension: item), constant: constant)
        case .height:
            constantAnchor = view.heightAnchor.constraint(greaterThanOrEqualTo: configure(dimension: item), constant: constant)
        case .centerY:
            constantAnchor = view.centerYAnchor.constraint(greaterThanOrEqualTo: configure(layoutY: item), constant: constant)
        case .centerX:
            constantAnchor = view.centerXAnchor.constraint(greaterThanOrEqualTo: configure(layoutX: item), constant: constant)
        case .leading:
            constantAnchor = view.leadingAnchor.constraint(greaterThanOrEqualTo: configure(layoutX: item), constant: constant)
        case .trailing:
            constantAnchor = view.trailingAnchor.constraint(greaterThanOrEqualTo: configure(layoutX: item), constant: constant)
        default:
            fatalError("Layout attribute not implemented (Yet!)")
        }
        constantAnchor?.priority = LayoutPriority(rawValue: 999)
        constantAnchor?.isActive = true
        return LayoutConstraintMakerSupportable(constant: constantAnchor)
    }
    
    @discardableResult
    func greaterThanOrEqualTo(constant: CGFloat) -> LayoutConstraintMakerSupportable {
        var constantAnchor: LayoutConstraint?
        switch attribute {
        case .width:
            constantAnchor = view.widthAnchor.constraint(greaterThanOrEqualToConstant: constant)
        case .height:
            constantAnchor = view.heightAnchor.constraint(greaterThanOrEqualToConstant: constant)
        default:
            fatalError("Layout attribute not implemented")
        }
        constantAnchor?.priority = LayoutPriority(rawValue: 999)
        constantAnchor?.isActive = true
        return LayoutConstraintMakerSupportable(constant: constantAnchor)
    }
    
    @discardableResult
    func lessThanOrEqualTo(_ item: LayoutConstraintItemable, constant: CGFloat = 0) -> LayoutConstraintMakerSupportable {
        var constantAnchor: LayoutConstraint?
        switch attribute {
        case .left:
            constantAnchor = view.leftAnchor.constraint(lessThanOrEqualTo: configure(layoutX: item), constant: constant)
        case .right:
            constantAnchor = view.rightAnchor.constraint(lessThanOrEqualTo: configure(layoutX: item), constant: constant)
        case .top:
            constantAnchor = view.topAnchor.constraint(lessThanOrEqualTo: configure(layoutY: item), constant: constant)
        case .bottom:
            constantAnchor = view.bottomAnchor.constraint(lessThanOrEqualTo: configure(layoutY: item), constant: constant)
        case .width:
            constantAnchor = view.widthAnchor.constraint(lessThanOrEqualTo: configure(dimension: item), constant: constant)
        case .height:
            constantAnchor = view.heightAnchor.constraint(lessThanOrEqualTo: configure(dimension: item), constant: constant)
        case .centerY:
            constantAnchor = view.centerYAnchor.constraint(lessThanOrEqualTo: configure(layoutY: item), constant: constant)
        case .centerX:
            constantAnchor = view.centerXAnchor.constraint(lessThanOrEqualTo: configure(layoutX: item), constant: constant)
        case .leading:
            constantAnchor = view.leadingAnchor.constraint(lessThanOrEqualTo: configure(layoutX: item), constant: constant)
        case .trailing:
            constantAnchor = view.trailingAnchor.constraint(lessThanOrEqualTo: configure(layoutX: item), constant: constant)
        default:
            fatalError("Layout attribute not implemented (Yet!)")
        }
        constantAnchor?.priority = LayoutPriority(rawValue: 999)
        constantAnchor?.isActive = true
        return LayoutConstraintMakerSupportable(constant: constantAnchor)
    }
    
    @discardableResult
    func lessThanOrEqualTo(constant: CGFloat) -> LayoutConstraintMakerSupportable {
        var constantAnchor: LayoutConstraint?
        switch attribute {
        case .width:
            constantAnchor = view.widthAnchor.constraint(lessThanOrEqualToConstant: constant)
        case .height:
            constantAnchor = view.heightAnchor.constraint(lessThanOrEqualToConstant: constant)
        default:
            fatalError("Layout attribute not implemented")
        }
        constantAnchor?.priority = LayoutPriority(rawValue: 999)
        constantAnchor?.isActive = true
        return LayoutConstraintMakerSupportable(constant: constantAnchor)
    }
    
}


