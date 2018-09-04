//
//  LayoutConstraintItemable.swift
//  LayoutAnchor
//
//  Created by Vinicius França Nunes Silva on 16/05/2018.
//  Copyright © 2018 Vinicius França. All rights reserved.
//

import Foundation

protocol LayoutConstraintItemable {
    var attribute: LayoutAttribute { get }
    var view: LayoutView { get }
    var isSafeArea: Bool { get }
}
