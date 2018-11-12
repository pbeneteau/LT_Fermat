//
//  UserProfileViewController.swift
//  LTios
//
//  Created by Paul Bénéteau on 25/01/2018.
//  Copyright © 2018 Tastyapp. All rights reserved.
//


import UIKit
import Spring

class UserProfileViewController: InteractiveViewController {
    
    private var containerView = UIView()
    
    private var dismissLineView = RoundView()
    
    var profilePictureView = RoundImageView()
    private let outerView = UIView()
    
    var onlineStatut = RoundView()
    
    var userNameLabel =  UILabel()
    var userTitle = UILabel()
    
    private var contactsButton = SpringButton()
    private var chatButton = SpringButton()
    private var addButton = SpringButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        containerView.backgroundColor = .white
        
        dismissLineView.backgroundColor = .gray
        dismissLineView.alpha = 0.3
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismiss(_:)))
        dismissLineView.addGestureRecognizer(tap)
        view.addGestureRecognizer(tap)
        
        profilePictureView.contentMode = .scaleAspectFill
        
        onlineStatut.backgroundColor = UIColor(red:0.22, green:0.82, blue:0.88, alpha:1.0)
        
        userNameLabel.textColor = .black
        userNameLabel.textAlignment = .center
        userNameLabel.font = UIFont(name: "Roboto-Regular", size: 20)
        
        userTitle.textColor = .gray
        userTitle.alpha = 0.5
        userTitle.textAlignment = .center
        userTitle.font = UIFont(name: "Roboto-Regular", size: 16)
        
        contactsButton.setBackgroundImage(#imageLiteral(resourceName: "contacts_friend"), for: .normal)
        contactsButton.addTarget(self, action: #selector(didTapContactsButton), for: .touchUpInside)
        chatButton.setBackgroundImage(#imageLiteral(resourceName: "chat_friend"), for: .normal)
        chatButton.addTarget(self, action: #selector(didTapChatButton), for: .touchUpInside)
        
        addButton.setBackgroundImage(#imageLiteral(resourceName: "add_friend"), for: .normal)
        addButton.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        view.addSubview(containerView)
        containerView.addSubview(dismissLineView)
        outerView.addSubview(profilePictureView)
        containerView.addSubview(outerView)
        containerView.addSubview(onlineStatut)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(userTitle)
        containerView.addSubview(contactsButton)
        containerView.addSubview(chatButton)
        containerView.addSubview(addButton)
        
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.roundCorners(corners: [.topLeft, .topRight], radius: 15)
        
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.1
        outerView.layer.shadowOffset = CGSize(width: 0, height: 10)
        outerView.layer.shadowRadius = 10
        
        onlineStatut.layer.borderWidth = 5
        onlineStatut.layer.borderColor = UIColor.white.cgColor
        
        addButton.clipsToBounds = false
        addButton.layer.shadowColor = UIColor(red:0.40, green:0.51, blue:0.96, alpha:1.0).cgColor
        addButton.layer.shadowOpacity = 0.3
        addButton.layer.shadowOffset = CGSize(width: 0, height: 15)
        addButton.layer.shadowRadius = 10
        
        
    }
    
    @objc func didTapContactsButton() {
        print("contacts")
        contactsButton.animation = "pop"
        contactsButton.force = 0.2
        contactsButton.duration = 1.5
        contactsButton.animate()
        
    }
    @objc func didTapChatButton() {
        print("chat")
        chatButton.animation = "pop"
        chatButton.force = 0.2
        chatButton.duration = 1.5
        chatButton.animate()
        
    }
    @objc func didTapAddButton() {
        print("add")
        addButton.animation = "pop"
        addButton.force = 0.2
        addButton.duration = 1.5
        addButton.animateTo()
    }
    @objc func dismiss(_ sender: UITapGestureRecognizer) {
        self.dismiss(animated: true)
    }
    
    override func updateViewConstraints() {
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width)
            make.height.equalTo(view.snp.height).multipliedBy(0.45)
            make.centerX.equalTo(view.snp.centerX)
            make.bottom.equalTo(view.snp.bottom)
        }
        dismissLineView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(40)
            make.height.equalTo(5)
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.equalTo(containerView.snp.top).offset(15)
        }
        outerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp.width).multipliedBy(0.3125)
            make.height.equalTo(outerView.snp.width)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(dismissLineView.snp.top).offset(30)
        }
        profilePictureView.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(outerView.snp.width)
            make.center.equalTo(outerView.snp.center)
        }
        onlineStatut.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(23)
            make.height.equalTo(23)
            make.centerX.equalTo(profilePictureView.snp.centerX)
            make.centerY.equalTo(profilePictureView.snp.bottom)
        }
        userNameLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.8)
            make.height.equalTo(22)
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.equalTo(profilePictureView.snp.bottom).offset(20)
        }
        userTitle.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.width).multipliedBy(0.8)
            make.height.equalTo(18)
            make.centerX.equalTo(containerView.snp.centerX)
            make.top.equalTo(userNameLabel.snp.bottom).offset(10)
        }
        contactsButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.right.equalTo(chatButton.snp.left).offset(-20)
            make.centerY.equalTo(chatButton.snp.centerY)
        }
        chatButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.centerX.equalTo(containerView.snp.centerX)
            make.bottom.equalTo(containerView.snp.bottom).offset(-40)
        }
        addButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.left.equalTo(chatButton.snp.right).offset(20)
            make.centerY.equalTo(chatButton.snp.centerY)
        }
        
        super.updateViewConstraints()
    }
    
}
