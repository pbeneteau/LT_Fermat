//
//  LeftViewController.swift
//  LTios
//
//  Created by Paul Bénéteau on 30/01/2019.
//  Copyright © 2019 Tastyapp. All rights reserved.
//

import UIKit
import SwipeMenuViewController


class LeftMenuViewController: SwipeMenuViewController {
    
    private var viewControllers: [UIViewController] = [UIViewController(), ProfileViewController(), ContactsViewController()]
    
    var options = SwipeMenuViewOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.clear
        
        options.tabView.additionView.underline.height = 1
        options.tabView.style = .segmented
        options.tabView.additionView.padding.left = 30
        options.tabView.additionView.padding.right = 30
        
        swipeMenuView.reloadData(options: options)
    }
    
    
// MARK: - SwipeMenuViewDelegate
//
//    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewWillSetupAt currentIndex: Int) {
//        super.swipeMenuView(swipeMenuView, viewWillSetupAt: currentIndex)
//        print("will setup SwipeMenuView")
//    }
//    
//    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewDidSetupAt currentIndex: Int) {
//        super.swipeMenuView(swipeMenuView, viewDidSetupAt: currentIndex)
//        print("did setup SwipeMenuView")
//    }
//
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, willChangeIndexFrom fromIndex: Int, to toIndex: Int) {
        notifyDidChangeMenuIndex(from: fromIndex, to: toIndex)
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, didChangeIndexFrom fromIndex: Int, to toIndex: Int) {        
    }
    
    
// MARK - SwipeMenuViewDataSource
    
    override func numberOfPages(in swipeMenuView: SwipeMenuView) -> Int {
        return viewControllers.count
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, titleForPageAt index: Int) -> String {
        return ""
    }
    
    override func swipeMenuView(_ swipeMenuView: SwipeMenuView, viewControllerForPageAt index: Int) -> UIViewController {
        
        let vc = viewControllers[index]
        vc.didMove(toParent: self)
        vc.view.backgroundColor = .clear
        return vc
    }
}


// MARK: Notification Observers
extension LeftMenuViewController {
    
    func notifyDidChangeMenuIndex(from: Int, to: Int) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "didChangeMenuIndex"), object: nil, userInfo: ["from" : from, "to": to])
    }
}
