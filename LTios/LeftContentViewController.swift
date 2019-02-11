//
//  LeftContentViewController.swift
//  LTios
//
//  Created by Paul Bénéteau on 30/01/2019.
//  Copyright © 2019 Tastyapp. All rights reserved.
//

import UIKit

class LeftContentViewController: UIViewController {
    
    // Top Menu
    private var menuContainerView = UIView()
    private let menuVC = LeftMenuViewController()
    
    private let menuLabel = UILabel()
    
    private let chatMenuButton = UIButton()
    private let profileMenuButton = UIButton()
    private let contactsMenuButton = UIButton()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        menuContainerView.backgroundColor = Color.menuContainerView
        view.backgroundColor = Color.viewControllerBackground
        
        menuLabel.font = LTFont.Menu.title
        menuLabel.text = "Chat"
        
        chatMenuButton.setBackgroundImage(UIImage(named: "chat_icon"), for: .normal)
        profileMenuButton.setBackgroundImage(UIImage(named: "profile_empty_icon"), for: .normal)
        profileMenuButton.alpha = 0.3
        contactsMenuButton.setBackgroundImage(UIImage(named: "contacts_icon"), for: .normal)
        contactsMenuButton.alpha = 0.3

        view.addSubview(menuContainerView)
        view.addSubview(menuVC.view)
        
        menuContainerView.addSubview(menuLabel)
        
        menuContainerView.addSubview(chatMenuButton)
        menuContainerView.addSubview(profileMenuButton)
        menuContainerView.addSubview(contactsMenuButton)

        view.setNeedsUpdateConstraints()
        
        addNotificationsObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuContainerView.roundCorners(corners: [.bottomLeft , .bottomRight], radius: 25)
    }
    
    @objc func didChangeMenuIndex(_ notification: NSNotification) {
        
         if let userInfo = notification.userInfo,
            let fromIndex = userInfo["from"] as? Int,
            let toIndex = userInfo["to"] as? Int {
            
            self.updateMenuLabel(label: self.getMenuLabelFromIndex(index: toIndex))
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut, .beginFromCurrentState], animations: {
            
                self.getMenuButtonFromIndex(index: fromIndex).alpha = 0.3
                self.getMenuButtonFromIndex(index: toIndex).alpha = 1
            })
        }
    }
    
    func getMenuButtonFromIndex(index: Int) -> UIButton {
        
        switch index {
        case 0:
            return chatMenuButton
        case 1:
            return profileMenuButton
        default:
            return contactsMenuButton
        }
    }
    
    func getMenuLabelFromIndex(index: Int) -> String {
        
        switch index {
        case 0:
            return "Chat"
        case 1:
            return "Profile"
        default:
            return "Contacts"
        }
    }
    
    func updateMenuLabel(label: String) {
        // Fade out to set the text
        UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseOut, animations: {
            self.menuLabel.alpha = 0.0
        }, completion: {
            (finished: Bool) -> Void in
            
            // Once the label is completely invisible, set the text and fade it back in
            self.menuLabel.text = label
            
            // Fade in
            UIView.animate(withDuration: 0.15, delay: 0.0, options: .curveEaseIn, animations: {
                self.menuLabel.alpha = 1.0
            }, completion: nil)
        })
    }
}



// MARK: Constraints
extension LeftContentViewController {
    
    override func updateViewConstraints() {
        
        menuContainerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.2)
            make.centerX.equalTo(view)
            make.top.equalTo(view)
        }
        
        menuLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(menuContainerView).multipliedBy(0.7)
            make.height.equalTo(30)
            make.left.equalTo(25)
            make.top.equalTo(menuContainerView).offset(65)
        }
        
        chatMenuButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(30)
            make.height.equalTo(28)
            make.left.equalTo(50)
            make.bottom.equalTo(menuContainerView).offset(-15)
        }
        
        profileMenuButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(25)
            make.height.equalTo(28)
            make.centerX.equalTo(menuContainerView)
            make.bottom.equalTo(menuContainerView).offset(-15)
        }
        
        contactsMenuButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(32)
            make.height.equalTo(28)
            make.right.equalTo(menuContainerView).offset(-50)
            make.bottom.equalTo(menuContainerView).offset(-15)
        }
        
        menuVC.view.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.8 + 44)
            make.centerX.equalTo(view)
            make.top.equalTo(menuContainerView.snp.bottom).offset(-44)
        }
        super.updateViewConstraints()
    }
}

// MARK: Norifications Observer
extension LeftContentViewController {
    
    func addNotificationsObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeMenuIndex(_:)), name: Notification.Name(rawValue: "didChangeMenuIndex"), object: nil)
    }
}
