//
//  NotificationsTableView.swift
//  LTios
//
//  Created by Paul Bénéteau on 28/09/2018.
//  Copyright © 2018 Tastyapp. All rights reserved.
//

import UIKit

class NotificationsTableView: UITableViewController {
    
    var notifications = [UserNotification]() {
        didSet {
            tableView.reloadData()
        }
    }

    override init(style: UITableView.Style) {
        super.init(style: style)
        
        view.backgroundColor = .clear
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle  = .none
        tableView.isScrollEnabled = false
        
        tableView.register(NotificationsTableViewCell.self, forCellReuseIdentifier: "NotificationCell")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTableViewContentSize() -> Float {
        return Float(tableView.contentSize.height)
    }
    
}

extension NotificationsTableView {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationsTableViewCell
        
        cell.notification = notifications[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}
