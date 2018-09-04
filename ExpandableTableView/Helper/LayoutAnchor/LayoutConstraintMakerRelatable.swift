//
//  LayoutConstraintMakerRelatable.swift
//  AnchorConstraints
//
//  Created by Vinicius França on 12/04/2018.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import UIKit

protocol LayoutConstraintMakerRelatable {
    func equalTo(_ item: LayoutConstraintItemable, constant: CGFloat) -> LayoutConstraintMakerSupportable
    func equalTo(constant: CGFloat) -> LayoutConstraintMakerSupportable
    func greaterThanOrEqualTo(_ item: LayoutConstraintItemable, constant: CGFloat) -> LayoutConstraintMakerSupportable
    func greaterThanOrEqualTo(constant: CGFloat) -> LayoutConstraintMakerSupportable
    func lessThanOrEqualTo(_ item: LayoutConstraintItemable, constant: CGFloat) -> LayoutConstraintMakerSupportable
    func lessThanOrEqualTo(constant: CGFloat) -> LayoutConstraintMakerSupportable
}
