//
//  ContactsTableView.swift
//  LTios
//
//  Created by antoine beneteau on 2017-10-27.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class ContactsTableView: UITableView {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
    override init(frame: CGRect, style: UITableView.Style) {
        let style = UITableView.Style.plain
    super.init(frame: frame, style: style)
    
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    rowHeight = 70
    separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    separatorStyle = .none
    backgroundColor = UIColor(red:0.18, green:0.25, blue:0.31, alpha:0.0)
    allowsMultipleSelection = false
    
    commonInit()
  }
  
  func commonInit() {
    
    allowsMultipleSelection = false
    backgroundColor = .clear
    
    frame = UIScreen.main.bounds
    self.register(ContactsTableViewCell.self, forCellReuseIdentifier: "contactCell")
  }

}
