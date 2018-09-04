//
//  ExpandableCell.swift
//  ExpandableTableView
//
//  Created by Lucas Nascimento on 19/08/18.
//  Copyright © 2018 Lucas Nascimento. All rights reserved.
//

import UIKit

final class ExpandableCell: UITableViewCell {
    
    private let containerView: UIView
    private var lineView: UIView
    private let titleLabel: UILabel
    private let descriptionLabel: UILabel
    private let arrowImage: UIImageView
    private var bottomConstraintOn, bottomConstraintOff: NSLayoutConstraint?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        containerView = UIView()
        lineView = UIView()
        titleLabel = UILabel()
        descriptionLabel = UILabel()
        arrowImage = UIImageView()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imageRotationAngle: CGFloat = CGFloat.pi {
        didSet{
            arrowImage.transform = CGAffineTransform(rotationAngle: imageRotationAngle)
        }
    }
    
    func update(_ item: Item) {
        titleLabel.text = item.title
        descriptionLabel.text = item.isExpanded ? "\n"+item.description+"\n": ""
        imageRotationAngle = item.isExpanded ? CGFloat.pi*2: CGFloat.pi
        lineView.isHidden = !item.isExpanded ? true : false
        bottomConstraintOn?.isActive = item.isExpanded
        bottomConstraintOff?.isActive = !item.isExpanded
    }
}

extension ExpandableCell: ViewCodable {
    
    func configureView() {
        imageRotationAngle = CGFloat.pi*2
        lineView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        arrowImage.image = UIImage(named: "expand-button")
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor(red: 0/255, green: 109/255, blue: 240/255, alpha: 1)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textColor = UIColor.darkGray
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
    }
    
    func configureHierarchy() {
        containerView.addView(lineView, descriptionLabel)
        contentView.addView(titleLabel, arrowImage, containerView)
    }
    
    func configureConstraints() {
        
        arrowImage.layout.makeConstraints { make in
            make.trailing.equalTo(contentView.layout.trailing, constant: -16)
            make.centerY.equalTo(titleLabel.layout.centerY)
            make.height.equalTo(constant: 25)
            make.width.equalTo(constant: 25)
        }
        
        titleLabel.layout.makeConstraints { make in
            make.top.equalTo(contentView.layout.top, constant: 16)
            make.bottom.equalTo(containerView.layout.top).priority(LayoutPriortizable.low).reference(&bottomConstraintOff)
            make.bottom.equalTo(containerView.layout.top, constant: -16).priority(LayoutPriortizable.high).reference(&bottomConstraintOn)
            make.leading.equalTo(contentView.layout.leading, constant: 16)
            make.trailing.equalTo(arrowImage.layout.leading, constant: -16)
        }
        
        containerView.layout.makeConstraints { make in
            make.leading.equalTo(contentView.layout.leading)
            make.trailing.equalTo(contentView.layout.trailing)
            make.bottom.equalTo(contentView.layout.bottom)
        }
        
        lineView.layout.makeConstraints { make in
            make.top.equalTo(containerView.layout.top)
            make.leading.equalTo(containerView.layout.leading, constant: 16)
            make.trailing.equalTo(containerView.layout.trailing, constant: -16)
            make.height.equalTo(constant: 1)
        }
        
        descriptionLabel.layout.makeConstraints { make in
            make.top.equalTo(lineView.layout.bottom)
            make.bottom.equalTo(containerView.layout.bottom, constant: -16)
            make.leading.equalTo(containerView.layout.leading, constant: 16)
            make.trailing.equalTo(containerView.layout.trailing, constant: -16)
        }
    }
}


