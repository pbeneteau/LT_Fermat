//
//  ScannerViewController.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-31.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit
import FirebaseAuth
import Reachability
import ViewAnimator

class MainViewController: ModalViewViewController {
    
    private var didSetupConstraints = false
    
    private var NearbyInterestingUsers = [InterestingUser]()
    private var bluetoothInterestingUsers = [InterestingUser]()
    
    private var reachability = Reachability()!
    
    private let animations = [AnimationType.from(direction: .bottom, offset: 10)]
    
    private var interestingPeopleNumbersLabel = UILabel()
    
    private var errorIcon = UIImageView()
    private var errorTitle = errorTitleLabel()
    private var errorLabel = errorLabelLabel()
    
    private var tableView = InterestingUsersTableView()
        
    private var closeUserbannerAlertDisplayed = false
    
    enum Alert {
        case reachability
        case lalization
        case privacy
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainUserInstance = MainUser()
        
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        interestingPeopleNumbersLabel.textAlignment = .center
        interestingPeopleNumbersLabel.textColor = .lightGray
        interestingPeopleNumbersLabel.font = UIFont(name: "Roboto-Regular", size: 16)
        interestingPeopleNumbersLabel.numberOfLines = 2
        interestingPeopleNumbersLabel.lineBreakMode = .byWordWrapping
        
        self.view.addSubview(interestingPeopleNumbersLabel)
        self.view.addSubview(tableView)
        
        addConstraints()
        
        self.addNotificationsObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        do {
            try reachability.startNotifier()
        } catch{
            print("[Error] could not start reachability notifier")
        }
    }
}


// MARK: Data Management
extension MainViewController {
    
    @objc func didUpdateUserProfile(_ notification: NSNotification) {
    }
    
    @objc func didFoundNearbyBluetoothUsers(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo {
            print(userInfo)
        }
    }
    
    @objc func didFoundNearbyUsers(_ notification: NSNotification) {
        
        if let userInfo = notification.userInfo, let nearbyUsers = userInfo["closeUsers"] as? [InterestingUser] {
        
            InterestingUsers.shared.getInterestingUsers(nearbyUsers: nearbyUsers) { interestingUsers in
                
                guard let interestingUsers = interestingUsers else { print("[Error] unwrapping nearby users"); return }
                self.addDataToTableView(newInterestingUsers: interestingUsers)
            }
        }
    }
    
    func addDataToTableView(newInterestingUsers: [InterestingUser]) {
        
        MenuInstance.stopLoadingAnimation()
        
        if newInterestingUsers.count > 0 {
            self.NearbyInterestingUsers = newInterestingUsers
            self.interestingPeopleNumbersLabel.text = "\(NearbyInterestingUsers.count) interesting people found close to you"
            if !closeUserbannerAlertDisplayed {
                showAlertBanner(.closePeople)
                closeUserbannerAlertDisplayed = true
            }
            self.tableView.reloadData()
        } else {
            self.interestingPeopleNumbersLabel.text = "Arf... We haven't found anyone around you"
            self.NearbyInterestingUsers.removeAll()
        }
    }
    
    @objc func didUpdateLocation(_ notification: NSNotification) {
        
        MenuInstance.updatePlaceName(name: mainUserInstance.place?.name ?? "")
        DatabaseService.shared.listenForNearbyUsers()
    }
    
    @objc func didRequestPrivacyChange(_ notification: NSNotification) {
        
        if !mainUserInstance.settings.getStateFromCode("ghost") {
            removeAlert()
            MenuInstance.privacyDidChange(ghost: false)
        } else {
            showAlert(alert: .privacy)
            MenuInstance.privacyDidChange(ghost: true)
        }
    }
}

// MARK: Table View Delegates
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NearbyInterestingUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: InterestingUsersTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "interestingUserCell", for: indexPath) as? InterestingUsersTableViewCell
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        if NearbyInterestingUsers[heightForRowAt.row].friendsInCommonNb > 3 {
            return CGFloat(self.tableView.frame.width * (3/8))
        }
        return CGFloat(self.tableView.frame.width) * CGFloat(NearbyInterestingUsers[heightForRowAt.row].friendsInCommonNb/8)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? InterestingUsersTableViewCell {
            _configureCell(cell, atIndexPath: indexPath)
        }
    }
    
    fileprivate func _configureCell(_ cell: InterestingUsersTableViewCell, atIndexPath indexPath: IndexPath) {
        cell.queue.cancelAllOperations()
        
        let operation: BlockOperation = BlockOperation()
        operation.addExecutionBlock { [weak operation] () -> Void in
            
            DispatchQueue.main.sync(execute: { [weak operation] () -> Void in
                
                if let operation = operation, operation.isCancelled { return }
                
                // Initializations
                cell.selectionStyle = .none
                cell.backgroundColor = .clear
                cell.bubble.tag = indexPath.row
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTouchBubble(_:)))
                cell.bubble.addGestureRecognizer(tap)
                
                cell.user = self.NearbyInterestingUsers[indexPath.row]
            })
        }
        cell.queue.addOperation(operation)
    }
}
 
// MARK: Buttons Actions
extension MainViewController {
    
    @objc func didTouchBubble(_ gesture: UITapGestureRecognizer) {
                
        if let bubble = gesture.view as? RoundShadowImageView {
            let tag = bubble.tag
            
            //bubble.didTap()
            
            print("Selected: \(String(describing: NearbyInterestingUsers[tag].fullName!)) (\(tag))")
            
            let vc = UserProfileViewController()
            
            vc.allowedDismissDirection = dismissDirection(rawValue: 0)!
            vc.directionLock = true
            vc.maskType = InteractiveMaskType(rawValue: UInt(0))!
            vc.userNameLabel.text = NearbyInterestingUsers[tag].fullName
            vc.userTitle.text = NearbyInterestingUsers[tag].publicName
            vc.profilePictureView.image = NearbyInterestingUsers[tag].photo
            vc.showInteractive()
        }
    }
}

// MARK: Norifications Observer
extension MainViewController {
    
    func addNotificationsObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateUserProfile), name: Notification.Name(rawValue:"didUpdateUserInformation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateLocation(_:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.showTurnOnLocationServiceAlert(_:)), name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFoundNearbyUsers(_:)), name: Notification.Name(rawValue:"didFoundNearbyUsers"), object: nil)
        
           NotificationCenter.default.addObserver(self, selector: #selector(self.didFoundNearbyBluetoothUsers(_:)), name: Notification.Name(rawValue:"didFoundNearbyBluetoothUsers"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didRequestPrivacyChange(_:)), name: Notification.Name(rawValue:"didRequestPrivacyChange"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(_:)), name: .reachabilityChanged, object: reachability)
    }
}


// MARK: Alerts
extension MainViewController {
    
    @objc func showTurnOnLocationServiceAlert(_ notification: NSNotification){
        let alert = UIAlertController(title: "Turn on Location Service", message: "To use location tracking feature of the app, please turn on the location service from the Settings app.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
            let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
            if let url = settingsUrl {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func reachabilityChanged(_ notification: NSNotification) {
        let reachability = notification.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            MenuInstance.reachabilityDidChange(reachable: true)
            removeAlert()
        case .cellular:
            MenuInstance.reachabilityDidChange(reachable: true)
            removeAlert()
        case .none:
            MenuInstance.reachabilityDidChange(reachable: false)
            showAlert(alert: .reachability)
        }
    }
    
    func showAlert(alert: Alert) {
        
        switch alert {
        case .reachability:
            showAlertBanner(.unreachable)
            errorIcon.image = UIImage(named: "wifi_icon")
            errorTitle.text = "Connexion issue"
            errorLabel.text = "Make sure you are connected to the internet"
            self.view.backgroundColor = UIColor(red:0.92, green:0.35, blue:0.35, alpha:1.0)
            self.tableView.alpha = 0
        case .privacy:
            errorIcon.image = UIImage(named: "ghost_icon")
            errorTitle.text = "Ghost mode"
            errorLabel.text = "You are now invisible to other users"
            self.view.backgroundColor = UIColor(red:0.40, green:0.40, blue:0.40, alpha:1.0)
        default:
            errorIcon.image = UIImage(named: "location_icon")
            errorTitle.text = "Localization issue"
            errorLabel.text = "Make sure you have accepted the localization accessibility"
            self.view.backgroundColor = UIColor(red:0.92, green:0.35, blue:0.35, alpha:1.0)
        }
        
        view.addSubview(errorIcon)
        view.addSubview(errorTitle)
        view.addSubview(errorLabel)
        
        self.errorIcon.snp.makeConstraints { (make) -> Void in
            if alert == .reachability {
                make.height.equalTo(111)
                make.width.equalTo(147)
            } else if alert == .privacy {
                make.height.equalTo(111)
                make.width.equalTo(104)
            }
            make.centerX.equalTo(self.view.snp.centerX)
            make.centerY.equalTo(self.view.snp.centerY).multipliedBy(0.8)
        }
        self.errorTitle.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(30)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.7)
            make.centerX.equalTo(errorIcon.snp.centerX)
            make.top.equalTo(errorIcon.snp.bottom).offset(25)
        }
        self.errorLabel.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(60)
            make.width.equalTo(self.view.snp.width).multipliedBy(0.7)
            make.centerX.equalTo(errorTitle.snp.centerX)
            make.top.equalTo(errorTitle.snp.bottom).offset(10)
        }
        
        errorIcon.isHidden = false
        errorTitle.isHidden = false
        errorLabel.isHidden = false
    }
    
    func removeAlert() {
        self.view.backgroundColor = .white
        errorIcon.isHidden = true
        errorTitle.isHidden = true
        errorLabel.isHidden = true
        self.tableView.alpha = 1
    }
    
    func showAlertBanner(_ type: BannerType) {
        
        if (MenuInstance.currentController) != 0 {
            AlertBanner.showBanner(type)
        }
    }
    
}


// MARK: Constraints
extension MainViewController {
    
    private func addConstraints() {
        
        if !didSetupConstraints {
            
            interestingPeopleNumbersLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view).multipliedBy(0.6)
                make.height.equalTo(40)
                make.top.equalTo(view).offset(90)
                make.centerX.equalTo(view)
            }
            
            tableView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height).multipliedBy(0.8)
                make.bottom.equalTo(view)
                make.centerX.equalTo(view)
            }
            
            didSetupConstraints = true
        }
    }
    
    
}
