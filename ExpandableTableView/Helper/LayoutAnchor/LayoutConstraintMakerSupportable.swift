//
//  LayoutConstraintMakerSupport.swift
//  LayoutAnchor
//
//  Created by Vinicius França on 10/05/2018.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import Foundation
import UIKit

internal class LayoutConstraintMakerSupportable {
    
    private let constant: LayoutConstraint?
    
    required init(constant: LayoutConstraint?) {
        self.constant = constant
    }

    @discardableResult
    func priority(_ priority: LayoutPriortizable) -> LayoutConstraintMakerSupportable {
        guard let constant = constant else {
            return LayoutConstraintMakerSupportable(constant: self.constant)
        }
        constant.priority = priority.value
        return LayoutConstraintMakerSupportable(constant: constant)
    }

    @discardableResult
    func reference(_ reference: inout LayoutConstraint?) -> LayoutConstraintMakerSupportable {
        reference = constant
        return LayoutConstraintMakerSupportable(constant: constant)
    }
    
}

internal enum LayoutPriortizable {
    case low
    case medium
    case high
    case required

    var value: LayoutPriority {
        switch self {
        case .low:
            return LayoutPriority(rawValue: 250.0)
        case .medium:
            return LayoutPriority(rawValue: 500.0)
        case .high:
            return LayoutPriority(rawValue: 750.0)
        case .required:
            return LayoutPriority(rawValue: 999.0)
        }
    }
}
