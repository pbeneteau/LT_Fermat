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

class ProfileViewController: ModalViewViewController {
    
    private var backgroundView = UIView()
    private var containerView = UIView()
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.showsHorizontalScrollIndicator = false
        view.tag = 10
        view.backgroundColor = .clear
        view.bounces = true
        view.contentSize = CGSize(width: 1, height: 1)
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    private var settingsButton = UIButton()
    
    private var profilePictureView = RoundShadowImageView()
    
    private var fullName = UILabel()
    private var publicName = UILabel()
    private var lineView = UIView()
    
    private var notificationsLabel = UILabel()
    private var notificationsBlock = RoundShadowView()
    
    private var contactsLabel = UILabel()
    private var contactsVC = ContactsViewController()
    private var notificationsVC: NotificationsTableView!
    
    var profileShadowBackground = GradientView()
    var menuShadowBackground = GradientView()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuShadowBackground.alpha = 0.5
        menuShadowBackground.setGradientColors(topColor: UIColor(white: 1, alpha: 0), botColor: .white)
        
        profileShadowBackground.alpha = 0
        profileShadowBackground.setGradientColors(topColor: .black, botColor: UIColor(white: 1, alpha: 0))
        
        notificationsVC = NotificationsTableView(style: .plain)
        
        backgroundView.backgroundColor = Color.viewControllerBackground
        containerView.backgroundColor = Color.viewControllerBackground
        scrollView.backgroundColor = Color.viewControllerBackground
        
        profilePictureView.contentMode = .scaleAspectFill
        
        settingsButton.setImage(UIImage(named: "SettingsButton"), for: .normal)
        settingsButton.addTarget(self, action: #selector(didTapSettingsButton), for: .touchUpInside)
        
        fullName.font = UIFont(name: "Roboto-Medium", size: 25)
        fullName.textColor = Color.Profile.publicName
        fullName.textAlignment = .center
        
        publicName.font = UIFont.boldSystemFont(ofSize: 15)
        publicName.textColor = Color.Profile.badge
        publicName.textAlignment = .center
        
        lineView.backgroundColor = Color.separatorLine
        
        notificationsLabel.text = "Notifications"
        notificationsLabel.font = UIFont(name: "Roboto-Regular", size: 20)
        notificationsLabel.textColor = UIColor.lightGray
        notificationsLabel.alpha = 0
        
        notificationsBlock.backgroundColor = Color.blockBackground
        notificationsBlock.alpha = 0
        
        contactsLabel.text = "Contacts"
        contactsLabel.font = UIFont(name: "Roboto-Regular", size: 20)
        contactsLabel.textColor = UIColor.lightGray
        
        view.addSubview(backgroundView)
        view.addSubview(containerView)
        view.addSubview(scrollView)
        view.addSubview(profileShadowBackground)
        view.addSubview(menuShadowBackground)
        
        scrollView.addSubview(notificationsLabel)
        scrollView.addSubview(notificationsBlock)
        scrollView.addSubview(contactsLabel)
        
        containerView.addSubview(settingsButton)
        containerView.addSubview(fullName)
        containerView.addSubview(publicName)
        containerView.addSubview(lineView)
        containerView.addSubview(profilePictureView)
        
        addUserNotificationsTableView()
        
        addContactsVC()
        
        addNotificationsObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: CGFloat(Float(view.frame.height) + contactsVC.getTableViewContentOffset()) + 50)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.roundCorners(corners: [.topLeft , .topRight], radius: 10)
    }
    
    func addContactsVC() {
        
        addChild(contactsVC)
        scrollView.addSubview(contactsVC.view)
    }
    
    func addUserNotificationsTableView() {
        
        addChild(notificationsVC)
        notificationsBlock.addSubview(notificationsVC.view)
    }
    
    @objc func didTapSettingsButton() {
        
        var delay: TimeInterval = 0
        
        if scrollView.contentOffset.y != 0 {
            delay = 0.4
            scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            
            let controller: SettingsViewController = SettingsViewController()
            
            self.prepareSettingsSegue { end in
                
                self.segueToSettingsVC(controller: controller)
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.didCloseSettings), name: Notification.Name(rawValue:"didCloseSettings"), object: nil)
            }
        }
    }
    
    @objc func didCloseSettings() {
        
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue:"didCloseSettings"), object: nil)
        
        settingsButton.isHidden = false
        
        profilePictureView.snp.remakeConstraints { (make) -> Void in
            make.height.equalTo(containerView).multipliedBy(0.4)
            make.width.equalTo(profilePictureView.snp.height)
            make.centerX.equalTo(containerView)
            make.top.equalTo(containerView).offset(40 - 25 * (Float(scrollView.contentOffset.y) / maxContentOffset() * 4))
        }
        
        UIView.animate(withDuration: TimeInterval(0.5), animations: {
            
            self.view.layoutIfNeeded()
            
            self.fullName.alpha = 1
            self.publicName.alpha = 1
            self.lineView.alpha = 1
            self.notificationsBlock.alpha = 1
            self.scrollView.alpha = 1
        })
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
            
            notificationsVC.notifications = notifs
            
            notificationsLabel.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(scrollView).multipliedBy(0.7)
                make.height.equalTo(20)
                make.left.equalTo(notificationsBlock)
                make.top.equalTo(scrollView).offset(20)
            }
            
            notificationsBlock.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(scrollView).multipliedBy(0.9)
                make.height.equalTo(notifs.count * 80)
                make.centerX.equalTo(scrollView)
                make.top.equalTo(notificationsLabel.snp.bottom).offset(15)
            }
            
            notificationsVC.view.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(notificationsBlock)
                make.height.equalTo(notificationsBlock)
                make.center.equalTo(notificationsBlock)
            }
            
            scrollView.contentSize = CGSize(width: view.frame.size.width, height: CGFloat(Float(self.view.frame.height) + contactsVC.getTableViewContentOffset() + notificationsVC.getTableViewContentSize()) + 100)
            
            self.view.layoutSubviews()
            self.notificationsVC.view.layoutSubviews()
            
            UIView.animate(withDuration: 0.4, delay: 0, options: [.curveEaseInOut], animations: {
                
                self.notificationsLabel.alpha = 1
                self.notificationsBlock.alpha = 1
            })
        }
    }
    
}

// MARK: Scroll View Delegate
extension ProfileViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y <= view.frame.height * 0.4 && scrollView.contentOffset.y >= 30 {
            
            let multiplicator = (Float(scrollView.contentOffset.y * 2) / Float(view.frame.height))
            
            if multiplicator <= 1 {
                
                containerView.snp.remakeConstraints { (make) -> Void in
                    make.width.equalTo(view)
                    make.height.equalTo(view).multipliedBy(0.3).offset(-160 * multiplicator)
                    make.centerX.equalTo(view)
                    make.top.equalTo(view).offset(90)
                }
                
                profilePictureView.snp.makeConstraints { (make) -> Void in
                    make.height.equalTo(containerView).multipliedBy(0.4)
                    make.width.equalTo(profilePictureView.snp.height)
                    make.centerX.equalTo(containerView)
                    make.top.equalTo(containerView).offset(40 - 25 * multiplicator)
                }
                
                fullName.snp.makeConstraints { (make) -> Void in
                    make.width.equalTo(containerView).multipliedBy(0.7)
                    make.height.equalTo(25)
                    make.centerX.equalTo(containerView)
                    make.top.equalTo(profilePictureView.snp.bottom).offset(15 - 10 * multiplicator)
                }
                
                fullName.font = UIFont(name: "Roboto-Medium", size: CGFloat(25 - 10 * multiplicator))
                
                profileShadowBackground.alpha = CGFloat(multiplicator / 12)
                
                publicName.alpha = CGFloat(1 - multiplicator * 2)
                lineView.alpha = CGFloat(1 - multiplicator * 2)
                
                view.layoutSubviews()
            }
        }
    }
    
    func maxContentOffset() -> Float {
        return Float(scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
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
    
    func prepareSettingsSegue(completion: @escaping(Bool) -> Void) {
        
        settingsButton.isHidden = true
        
        profilePictureView.snp.remakeConstraints { (make) -> Void in
            make.height.width.equalTo(95)
            make.left.equalTo(25)
            make.top.equalTo(25)
        }
        
        UIView.animate(withDuration: TimeInterval(0.5), animations: {
            self.view.layoutIfNeeded()
            
            self.fullName.alpha = 0
            self.publicName.alpha = 0
            self.lineView.alpha = 0
            self.notificationsBlock.alpha = 0
            self.scrollView.alpha = 0
            
        }, completion: { end in
            completion(true)
        })
    }
    
}

// MARK: Constraints
extension ProfileViewController {
    
    override func updateViewConstraints() {
        
        backgroundView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(view)
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(100)
        }
        
        containerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.3)
            make.centerX.equalTo(view)
            make.top.equalTo(view).offset(90)
        }
        
        settingsButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(33)
            make.height.equalTo(33)
            make.right.equalTo(containerView).inset(20)
            make.top.equalTo(containerView).inset(20)
        }
        
        profilePictureView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(containerView).multipliedBy(0.4)
            make.width.equalTo(profilePictureView.snp.height)
            make.centerX.equalTo(containerView)
            make.top.equalTo(containerView).offset(40)
        }
        
        fullName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView.snp.height).multipliedBy(0.7)
            make.height.equalTo(25)
            make.centerX.equalTo(containerView)
            make.top.equalTo(profilePictureView.snp.bottom).offset(15)
        }
        
        publicName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView).multipliedBy(0.7)
            make.height.equalTo(25)
            make.centerX.equalTo(containerView)
            make.top.equalTo(fullName.snp.bottom).offset(3)
        }
        
        lineView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(containerView).multipliedBy(0.3)
            make.height.equalTo(0.5)
            make.centerX.equalTo(containerView)
            make.top.equalTo(publicName.snp.bottom).offset(8)
        }
        
        scrollView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(contactsVC.getTableViewContentOffset())
            make.centerX.equalTo(view)
            make.top.equalTo(containerView.snp.bottom)
        }
        
        notificationsLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(scrollView).multipliedBy(0.7)
            make.height.equalTo(0)
            make.left.equalTo(notificationsBlock)
            make.top.equalTo(scrollView).offset(20)
        }
        
        notificationsBlock.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(scrollView).multipliedBy(0.9)
            make.height.equalTo(0)
            make.centerX.equalTo(scrollView)
            make.top.equalTo(notificationsLabel.snp.bottom).offset(15)
        }
        
        notificationsVC.view.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(notificationsBlock)
            make.height.equalTo(notificationsVC.tableView.contentSize)
            make.center.equalTo(notificationsBlock)
        }
        
        contactsLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(scrollView).multipliedBy(0.7)
            make.height.equalTo(20)
            make.left.equalTo(notificationsBlock)
            make.top.equalTo(notificationsBlock.snp.bottom).offset(20)
        }
        
        let height = Float(view.frame.height) + contactsVC.getTableViewContentOffset()
        
        contactsVC.view.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(scrollView)
            make.height.equalTo(height)
            make.top.equalTo(contactsLabel.snp.bottom).offset(10)
            make.centerX.equalTo(scrollView)
        }
        
        menuShadowBackground.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(view).multipliedBy(0.1)
            make.width.equalTo(view)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        profileShadowBackground.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(view)
            make.centerX.equalTo(view)
            make.top.equalTo(containerView.snp.bottom)
        }
        
        super.updateViewConstraints()
    }
}

// MARK: Segues
extension ProfileViewController {
    
    func segueToSettingsVC(controller: SettingsViewController) {
        
        controller.view.frame = view.bounds
        controller.view.backgroundColor = .clear
        
        self.addChild(controller)
        view.addSubview(controller.view)
    }
    
}




