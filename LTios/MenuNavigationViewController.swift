//
//  MenuNavigationViewController.swift
//  LTios
//
//  Created by Paul Bénéteau on 30/01/2019.
//  Copyright © 2019 Tastyapp. All rights reserved.
//

import UIKit

class MenuNavigationViewController: UINavigationController {
    
    var icon: UIImage! {
        didSet {
            tabBarItem = UITabBarItem(title: "", image: icon, tag: 1)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isNavigationBarHidden = true

        tabBarController?.tabBar.barTintColor = Color.mainMenu.background
        tabBarController?.tabBar.tintColor = Color.mainMenu.tint
        tabBarController?.tabBar.shadowImage = nil
    }
    
    
    
}
