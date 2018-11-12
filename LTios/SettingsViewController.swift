//
//  SettingsViewController.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-31.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class SettingsViewController: ModalViewViewController {
    
    private var profilePictureView = RoundImageView()
    
    private let closeButton = UIButton()
    
    private let publicName = UILabel()
    private let email = UILabel()
    
    private var tableView = SettingsTableView()
    
    var userSettings: UserSettings!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        profilePictureView.image = mainUserInstance.photo
        profilePictureView.contentMode = .scaleAspectFill
        
        closeButton.setBackgroundImage(UIImage(named: "CloseButton"), for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        
        publicName.font = UIFont(name: "Roboto-Medium", size: 23)
        publicName.textColor = UIColor(red:0.00, green:0.05, blue:0.25, alpha:1.0)
        publicName.textAlignment = .left
        
        email.font = UIFont(name: "Roboto-Regular", size: 18)
        email.textColor = .gray
        email.textAlignment = .left
        
        profilePictureView.alpha = 0
        publicName.alpha = 0
        email.alpha = 0
        tableView.alpha = 0
        
        initData()
        
        view.addSubview(profilePictureView)
        view.addSubview(closeButton)
        view.addSubview(publicName)
        view.addSubview(email)
        view.addSubview(tableView)
        
        view.setNeedsUpdateConstraints()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: TimeInterval(0.5), animations: {
            self.profilePictureView.alpha = 1
            self.closeButton.alpha = 1
            self.publicName.alpha = 1
            self.email.alpha = 1
            self.tableView.alpha = 1
        })
    }
    
    func initData() {
        
        profilePictureView.image = mainUserInstance.photo
        publicName.text = mainUserInstance.publicName
        email.text = mainUserInstance.mailAddress
        
        guard let settings = mainUserInstance.settings else {
            print("[Error] unwrapping user settings")
            return
        }
        
        userSettings = settings
        
        tableView.reloadData()
    }
    
    @objc func didTapCloseButton() {
        
        UIView.animate(withDuration: TimeInterval(0.5), animations: {
            self.profilePictureView.alpha = 0
            self.closeButton.alpha = 0
            self.publicName.alpha = 0
            self.email.alpha = 0
            self.tableView.alpha = 0
        }, completion: { end in
            self.removeFromParent()
            self.view.removeFromSuperview()
            self.notifyDidTapCloseButton()
        })
    }
    
}

// MARK: Table View Delegate & Datasource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return userSettings.getTotalSections() + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if (userSettings.getTotalSections() == section) { // logout section
            return 1
        }
        
        return userSettings.getTotalRows(section: section)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt: IndexPath) -> CGFloat {
        
        let section = heightForRowAt.section
        let row = heightForRowAt.row

        if section == userSettings.getTotalSections() { // logout cell
            return 40
        }
        
        if userSettings.getTotalRows(section: section) == 1 {
            return 97
        } else if row == 0 {
            return 90
        } else if row == userSettings.getTotalRows(section: section) - 1 {
            return 90
        } else {
            return 80
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let section = indexPath.section
        let row = indexPath.row
        
        if (section == userSettings.getTotalSections()) { // logout cell
            return getLogoutCell(indexPath: indexPath)
        }
        
        let cell: SettingsCell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as! SettingsCell

        
        cell.settings = userSettings.settings[section][row]
        
        if userSettings.getTotalRows(section: section) == 1 {
            cell.position = .solo
        } else if (row == 0) {
            cell.position = .first
        } else if (row == userSettings.getTotalRows(section: section) - 1) {
            cell.position = .last
        } else {
            cell.position = .middle
        }
        
        cell.commonInit()
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == userSettings.getTotalSections() {
            return 0
        }
        return 40
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SettingsHeader") as? SettingsHeaderView else {
            return nil
        }
        
        if section == userSettings.getTotalSections() {
            return nil
        }
        
        header.titleLabel.text = userSettings.getSectionName(section: section)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 2 && indexPath.row == 0) { // Snapchat
            
            let SnapchatVC = SnapchatLoginViewController()
            
            present(SnapchatVC, animated: true, completion: nil)
        }
    }
    
    func getLogoutCell(indexPath: IndexPath) -> UITableViewCell{
     
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingsLogoutCell", for: indexPath)
        
        let logoutButton = UIButton()

        logoutButton.setTitle("Log out", for: .normal)
        logoutButton.setBackgroundColor(color: .clear, forState: .normal)
        logoutButton.titleLabel?.textAlignment = .center
        logoutButton.titleLabel?.font = UIFont(name: "Avenir-Book", size: 19)
        logoutButton.setTitleColor(Color.mainAppColor, for: .normal)

        cell.contentView.addSubview(logoutButton)

        logoutButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(cell.contentView).multipliedBy(0.7)
            make.height.equalTo(24)
            make.center.equalTo(cell.contentView.center)
        }
        
        cell.contentView.layoutSubviews()
        
        return cell
    }
    
}

// MARK: Notifications
extension SettingsViewController {
    
    private func notifyDidTapCloseButton() {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didCloseSettings"), object: nil)
    }
}


// MARK: Constraints
extension SettingsViewController {
    
    override func updateViewConstraints() {
        
        closeButton.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(22)
            make.height.equalTo(22)
            make.right.equalTo(view).inset(20)
            make.top.equalTo(view).offset(115)
        }
        
        profilePictureView.snp.makeConstraints { (make) -> Void in
            make.height.width.equalTo(95)
            make.left.equalTo(25)
            make.top.equalTo(closeButton.snp.centerY)
        }
        
        publicName.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view).multipliedBy(0.7)
            make.height.equalTo(25)
            make.left.equalTo(profilePictureView.snp.right).offset(20)
            make.top.equalTo(profilePictureView).offset(12)
        }
        
        email.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view).multipliedBy(0.7)
            make.height.equalTo(20)
            make.top.equalTo(publicName.snp.bottom).offset(10)
            make.left.equalTo(publicName)
        }
        
        tableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.7)
            make.bottom.equalTo(view)
            make.centerX.equalTo(view)
        }
        
        super.updateViewConstraints()
    }
    
}

enum UIModalTransitionStyle : Int {
    case CoverVertical = 0
    case FlipHorizontal
    case CrossDissolve
    case PartialCurl
}
