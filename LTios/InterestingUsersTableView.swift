//
//  InterestingUsersCollectionView.swift
//  LTios
//
//  Created by Paul Bénéteau on 18/08/2018.
//  Copyright © 2018 Tastyapp. All rights reserved.
//

import UIKit

class InterestingUsersTableView: UITableView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    func commonInit() {
        
        alwaysBounceVertical = false
        bounces = false
        allowsMultipleSelection = false
        backgroundColor = .clear
        separatorStyle = .none
        
        frame = UIScreen.main.bounds
        
        register(InterestingUsersTableViewCell.self, forCellReuseIdentifier: "interestingUserCell")
    }
}

