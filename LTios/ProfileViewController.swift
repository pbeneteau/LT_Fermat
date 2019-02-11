//
//  ProfileViewController.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-31.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit
import FirebaseAuth
import SCSDKLoginKit

class ProfileViewController: UIViewController {
        
    private var profilePictureView = RoundShadowImageView()
    
    private var fullName = UILabel()
    private var publicName = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.viewControllerBackground
        
        profilePictureView.contentMode = .scaleAspectFill
        
        fullName.font = UIFont(name: "Roboto-Medium", size: 25)
        fullName.textColor = Color.Profile.publicName
        fullName.textAlignment = .center
        
        publicName.font = UIFont.boldSystemFont(ofSize: 15)
        publicName.textColor = Color.Profile.publicName
        publicName.textAlignment = .center
        
        view.addSubview(fullName)
        view.addSubview(publicName)
        view.addSubview(profilePictureView)
        
        self.view.setNeedsUpdateConstraints()
        
        addNotificationsObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    
    @objc func didUpdateUserProfile() {
        
        fullName.text = mainUserInstance.fullName
        publicName.text = mainUserInstance.publicName
        
        if mainUserInstance.photo == nil {
            StorageService.shared.downloadUserPicture(uid: mainUserInstance.uid) { photo in
                guard let photo = photo else { print("[Error] unwrapping user photo"); return }
                self.profilePictureView.image = photo
            }
        } else {
            self.profilePictureView.image = mainUserInstance.photo
        }
        
        DatabaseService.shared.listenForUserNotifications()
    }
    
    @objc func didUpdateUserNotifications(_ notification: NSNotification) {
        if let userInfo = notification.userInfo, let notifs = userInfo["userNotifications"] as? [UserNotification] {
        }
    }
    
}


// MARK: Norifications Observer
extension ProfileViewController {
    
    func addNotificationsObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateUserProfile), name: Notification.Name(rawValue:"didUpdateUserInformation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateUserNotifications(_:)), name: Notification.Name(rawValue:"didUpdateUserNotifications"), object: nil)
        
    }
}

// MARK: Animations
extension ProfileViewController {
    
}

// MARK: Constraints
extension ProfileViewController {
    
    override func updateViewConstraints() {
        
        profilePictureView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(100)
            make.height.equalTo(100)
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(40)
        }
        
        fullName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view).multipliedBy(0.7)
            make.height.equalTo(25)
            make.centerX.equalTo(view)
            make.top.equalTo(profilePictureView.snp.bottom).offset(20)
        }
        
        publicName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view).multipliedBy(0.7)
            make.height.equalTo(25)
            make.centerX.equalTo(view)
            make.top.equalTo(fullName.snp.bottom).offset(3)
        }
        super.updateViewConstraints()
    }
}

// MARK: Segues
extension ProfileViewController {
    
}





