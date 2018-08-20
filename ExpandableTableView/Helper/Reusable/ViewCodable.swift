//
//  ViewCodable.swift
//  StackViewCellExpandable
//
//  Created by Lucas Nascimento on 04/08/18.
//  Copyright © 2018 Lucas Nascimento. All rights reserved.
//

import Foundation

protocol ViewCodable {
    func setupView()
    func configureView()
    func configureHierarchy()
    func configureConstraints()
}

extension ViewCodable {
    
    func setupView() {
        configureView()
        configureHierarchy()
        configureConstraints()
    }
}
