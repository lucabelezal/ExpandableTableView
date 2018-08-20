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
        containerView.addSubview(lineView)
        containerView.addSubview(descriptionLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImage)
        contentView.addSubview(containerView)
    }
    
    func configureConstraints() {
        
        arrowImage.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        arrowImage
            .trailingAnchor(equalTo: contentView.trailingAnchor, constant: -16)
            .centerYAnchor(equalTo: titleLabel.centerYAnchor)
            .heightAnchor(equalTo: 25)
            .widthAnchor(equalTo: 25)
        
        titleLabel
            .topAnchor(equalTo: contentView.topAnchor, constant: 16)
            .leadingAnchor(equalTo: contentView.leadingAnchor, constant: 16)
            .trailingAnchor(equalTo: arrowImage.leadingAnchor, constant: -16)
        
        containerView
            .leadingAnchor(equalTo: contentView.leadingAnchor)
            .trailingAnchor(equalTo: contentView.trailingAnchor)
            .bottomAnchor(equalTo: contentView.bottomAnchor)
        
        lineView
            .topAnchor(equalTo: containerView.topAnchor)
            .leadingAnchor(equalTo: containerView.leadingAnchor, constant: 16)
            .trailingAnchor(equalTo: containerView.trailingAnchor, constant: -16)
            .heightAnchor(equalTo: 1)
        
        descriptionLabel
            .topAnchor(equalTo: lineView.bottomAnchor)
            .bottomAnchor(equalTo: containerView.bottomAnchor, constant: -16)
            .leadingAnchor(equalTo: containerView.leadingAnchor, constant: 16)
            .trailingAnchor(equalTo: containerView.trailingAnchor, constant: -16)
        
        bottomConstraintOff = self.titleLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: 0)
        bottomConstraintOff?.isActive = false
        
        bottomConstraintOn = self.titleLabel.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -16)
        bottomConstraintOn?.isActive = true
    }
}


