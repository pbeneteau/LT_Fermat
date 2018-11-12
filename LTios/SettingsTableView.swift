//
//  SettingsTableView.swift
//  LTios
//
//  Created by Paul Bénéteau on 18/09/2018.
//  Copyright © 2018 Tastyapp. All rights reserved.
//

import UIKit

class SettingsTableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .grouped)
        commonInit()
    }
    
    func commonInit() {
        
        allowsMultipleSelection = false
        alwaysBounceVertical = true
        backgroundColor = .clear
        separatorStyle = .none
        
        let cellNib = UINib(nibName: "SettingsCell", bundle: nil)
        register(cellNib, forCellReuseIdentifier: "SettingsCell")
        
        register(UITableViewCell.self, forCellReuseIdentifier: "SettingsLogoutCell")
        
        let headerNib = UINib(nibName: "SettingsUITableViewHeader", bundle: nil)
        register(headerNib, forHeaderFooterViewReuseIdentifier: "SettingsHeader")
    }
}
