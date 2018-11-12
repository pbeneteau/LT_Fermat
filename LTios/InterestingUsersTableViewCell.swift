//
//  InterestingUsersTableViewCell.swift
//  LTios
//
//  Created by Paul Bénéteau on 18/08/2018.
//  Copyright © 2018 Tastyapp. All rights reserved.
//

import UIKit

class InterestingUsersTableViewCell: UITableViewCell {
    
    private var didSetupConstraints = false
    
    let queue = SerialOperationQueue()
    
    var bubble = RoundShadowImageView()
    
    var user = InterestingUser() {
        didSet {
            commonInit()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // add subviews
        contentView.addSubview(bubble)
        
        // constraints
        addConstraint()
        
        // initializations
        contentView.backgroundColor = .clear

        bubble.isUserInteractionEnabled = true
        
        // Layout
        bubble.layoutSubviews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func commonInit() {
        
        bubble.image = user.photo
        
        if !user.known {
        }
    }
    
    private func addConstraint() {
        
        let maxX = Int(contentView.frame.width - contentView.frame.height * 0.8 - 25)
        
        let x = Int.random(in: 25 ..< maxX)
        
        bubble.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(contentView.snp.height).multipliedBy(0.8)
            make.centerY.equalTo(contentView)
            make.left.equalTo(x)
        }
        contentView.layoutIfNeeded()
        bubble.layoutIfNeeded()
    }
    
    
}

