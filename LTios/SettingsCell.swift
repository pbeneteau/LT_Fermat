//
//  SettingsCell.swift
//  LTios
//
//  Created by Paul Bénéteau on 15/09/2018.
//  Copyright © 2018 Tastyapp. All rights reserved.
//

import UIKit


class SettingsCell: UITableViewCell {
    
    internal var settings: Settings!
    
    @IBOutlet var backgroundImage: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var segueIcon: UIImageView!
    
    @IBOutlet weak var switchButton: UISwitch!
    
    var position: SettingsCellPosition!
    
    var type: SettingsCellType!
    
    func commonInit() {
        
        if position == .first {
            backgroundImage.image = UIImage(named: "CellBackgroundTop")
        } else if position == .last {
            backgroundImage.image = UIImage(named: "CellBackgroundBot")
        } else if position == .middle {
            backgroundImage.image = UIImage(named: "CellBackgroundMid")
        } else {
            backgroundImage.image = UIImage(named: "CellBackgroundSolo")
        }
        
        titleLabel.text = settings.name
        descriptionLabel.text = settings.description
        switchButton.isOn = settings.state
        type = settings.type
        
        if type == .onOff {
            switchButton.isHidden = false
            segueIcon.isHidden = true
        } else if type == .segue {
            switchButton.isHidden = true
            segueIcon.isHidden = false
        }
        
        switchButton.addTarget(self, action: #selector(updateSettings), for: UIControlEvents.valueChanged)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        clipsToBounds = true
        
        descriptionLabel.sizeToFit()
        
        let frame = backgroundImage.frame
        
        if position == .first {
            backgroundImage.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(frame.width)
                make.height.equalTo(frame.height)
                make.bottom.equalTo(containerView)
                make.centerX.equalTo(containerView)
            }
        } else if position == .last {
            backgroundImage.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(frame.width)
                make.height.equalTo(frame.height)
                make.top.equalTo(containerView)
                make.centerX.equalTo(containerView)
            }
        } else {
            backgroundImage.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(frame.width)
                make.height.equalTo(frame.height)
                make.center.equalTo(containerView)
            }
        }
    }
    
    @objc func updateSettings() {
        
        if type == .onOff {
            
            DatabaseService.shared.updateOnOffSettings(section: settings.section.lowercased(), code: settings.code, state: switchButton.isOn) { success in
                
                mainUserInstance.settings.setSettingsValue(category: self.settings.section.lowercased(), self.switchButton.isOn, forKey: self.settings.code)
                
                UserSettings.updateAppSettingsFromCode(self.settings.code, state: self.switchButton.isOn)
            }
        }
    }
    
    
}

enum SettingsCellPosition {
    case first
    case middle
    case last
    case solo
}

enum SettingsCellType {
    case onOff
    case segue
    case link
}




