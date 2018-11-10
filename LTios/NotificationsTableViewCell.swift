//
//  NotificationsTableViewCell.swift
//  LTios
//
//  Created by Paul Bénéteau on 29/09/2018.
//  Copyright © 2018 Tastyapp. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    var notification: UserNotification! {
        didSet {
            photo.image = notification.user.photo
            fullNameLabel.text = notification.user.fullName
            dateString.text = notification.dateString
            type = notification.type
        }
    }
    
    var type: UserNotificationType! {
        didSet {
            if let type = type {
                switch type {
                case .friendRequest: typeStringLabel.text = "Friend request"
                    break
                case .message: typeStringLabel.text = "Wassup ?"
                    break
                }
            }
        }
    }
    
    var photo = RoundImageView()
    var typeStringLabel = UILabel()
    var fullNameLabel = UILabel()
    var dateString = UILabel()
    
    var actionButton = ActionButton()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        fullNameLabel.textColor = UIColor.gray
        fullNameLabel.font = LTFont.Profile.NotificationCell.userFullName
        
        typeStringLabel.textColor = UIColor.lightGray
        typeStringLabel.font = LTFont.Profile.NotificationCell.type
        
        actionButton.addTarget(self, action: #selector(didTouchActionButton), for: .touchUpInside)
        
        contentView.addSubview(photo)
        contentView.addSubview(fullNameLabel)
        contentView.addSubview(typeStringLabel)
        contentView.addSubview(actionButton)
        
        setNeedsUpdateConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTouchActionButton() {
        
        print(actionButton.state)
        print(UIControlState.highlighted)
        
        if actionButton.isActive {
            actionButton.setNormalState()
        } else {
            actionButton.setHighlightedState()
        }
    }
    
    override func updateConstraints() {
        
        photo.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(contentView).multipliedBy(0.7)
            make.width.equalTo(photo.snp.height)
            make.centerY.equalTo(contentView)
            make.left.equalTo(contentView).offset(10)
        }
        
        fullNameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(photo).offset(10)
            make.left.equalTo(photo.snp.right).offset(11)
            make.height.equalTo(20)
            make.width.equalTo(contentView).multipliedBy(0.7)
        }
        
        typeStringLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(20)
            make.width.equalTo(contentView).multipliedBy(0.7)
            make.top.equalTo(fullNameLabel.snp.bottom).offset(3)
            make.left.equalTo(fullNameLabel)
        }
        
        actionButton.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(25)
            make.width.equalTo(90)
            make.right.equalTo(contentView).offset(-10)
            make.centerY.equalTo(contentView)
        }
        
        super.updateConstraints()
    }
    
}

class ActionButton: UIButton {
    
    var isActive = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitle("Connect", for: .normal)
        layer.borderColor = Color.Button.Border.active.cgColor
        
        setNormalState()
        titleLabel?.font = LTFont.button
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setHighlightedState() {
        
        isActive = true
        isHighlighted = false
        
        setTitleColor(Color.Button.Title.active, for: .normal)

        backgroundColor = Color.Button.Background.active
        setTitle("Connected", for: .normal)
    }
    
    func setNormalState() {
        
        isActive = false
        isHighlighted = false
        
        setTitleColor(Color.Button.Title.normal, for: .normal)
        backgroundColor = Color.Button.Background.normal
        setTitle("Connect", for: .normal)
    }
    
}
