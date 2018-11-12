//
//  Menu.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-20.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

var MenuInstance = MenuViewController()

class MenuViewController: UIViewController, UIScrollViewDelegate {
    
    private var didSetupConstraints = false
    
    private let statusBarWindow = UIApplication.shared.value(forKey: "statusBarWindow") as? UIWindow
    private var statusBarIsDark = Bool()
    
    var currentController = 0
    
    private var currentPlaceName = ""
    
    private lazy var horizontalScrollView: UIScrollView = {
        let view = UIScrollView()
        view.delegate = self
        view.isPagingEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.tag = 10
        view.backgroundColor = .clear
        view.bounces = false
        view.contentSize = CGSize(width: 1, height: 1)
        if #available(iOS 11.0, *) {
            view.contentInsetAdjustmentBehavior = .never
        }
        return view
    }()
    
    
    // MARK: ViewControllers
    private let mainVC = MainViewController() // middle (0)
    private let nearbyPlacesVC = NearbyPlacesViewController() // right (1)
    private let profileVC = ProfileViewController() // left (-1)
    
    
    // MARK: Header
    private lazy var titleLabel: TitleLabel = {
        let view = TitleLabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = currentPlaceName
        view.alpha = 1.0
        view.sizeToFit()
        view.textColor = Color.Menu.Title.mainView
        return view
    }()
    
    // MARK: Navigation Menu
    var profileMenuButton = UIButton()
    var homeMenuButton = MenuHomeButtonView()
    var placesMenuButton = UIButton()
    var selectionMenuBar = UIView()
    
    
    private var colorEffectView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(horizontalScrollView)
        
        addChild(mainVC)
        horizontalScrollView.addSubview(mainVC.view)
        mainVC.didMove(toParent: self)
        
        addChild(nearbyPlacesVC)
        horizontalScrollView.addSubview(nearbyPlacesVC.view)
        nearbyPlacesVC.didMove(toParent: self)
        
        addChild(profileVC)
        horizontalScrollView.addSubview(profileVC.view)
        profileVC.didMove(toParent: self)
        
        horizontalScrollView.contentOffset = CGPoint(x: view.frame.size.width, y: 0)
        horizontalScrollView.contentSize = CGSize(width: view.frame.size.width * 3, height: view.frame.size.height)
        
        colorEffectView.image = #imageLiteral(resourceName: "background_gradient_center")
        colorEffectView.alpha = 0
        mainVC.view.addSubview(colorEffectView)
        
        // MARK: Header
        view.addSubview(titleLabel)
        
        // MARK: Navigation Menu
        let origImage = UIImage(named: "menu_profile")
        let tintedImage = origImage?.withRenderingMode(.alwaysTemplate)
        profileMenuButton.setBackgroundImage(tintedImage, for: .normal)
        
        let origImage2 = UIImage(named: "menu_places")
        let tintedImage2 = origImage2?.withRenderingMode(.alwaysTemplate)
        placesMenuButton.setBackgroundImage(tintedImage2, for: .normal)
        
        profileMenuButton.addTarget(self, action: #selector(didTapProfileButton), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTapHomeButton(_:)))
        homeMenuButton.addGestureRecognizer(tap)
        homeMenuButton.updateCirclesColor(color: Color.Menu.Button.normal)
        let forceTouch = ForceTouchGestureRecognizer(target: self, action: #selector(self.didForceTouchHomeButton(_:)))
        
        if traitCollection.forceTouchCapability == UIForceTouchCapability.available {
            homeMenuButton.addGestureRecognizer(forceTouch)
        }
        
        placesMenuButton.addTarget(self, action: #selector(didTapPlacesButton), for: .touchUpInside)
        
        selectionMenuBar.backgroundColor = Color.Menu.SelectionBar.normal
        selectionMenuBar.layer.cornerRadius = 6
        
        view.addSubview(profileMenuButton)
        view.addSubview(homeMenuButton)
        view.addSubview(placesMenuButton)
        view.addSubview(selectionMenuBar)
        
        view.setNeedsUpdateConstraints()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
    }
}


// MARK: Buttons Actions
extension MenuViewController {
    
    @objc func didTapProfileButton(sender: UIButton) {
        
        if currentController != -1 {
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                
                self.placesMenuButton.snp.updateConstraints { (make) -> Void in
                    make.right.equalTo(self.view.snp.right).offset(-100)
                }
                self.profileMenuButton.snp.updateConstraints { (make) -> Void in
                    make.left.equalTo(self.view.snp.left).offset(100)
                }
                self.selectionMenuBar.snp.remakeConstraints { (make) -> Void in
                    make.height.equalTo(10)
                    make.width.equalTo(self.profileMenuButton.snp.width).multipliedBy(1.15)
                    make.centerX.equalTo(self.profileMenuButton.snp.centerX)
                    make.centerY.equalTo(self.view.snp.bottom)
                }
                self.homeMenuButton.snp.remakeConstraints { (make) -> Void in
                    make.height.equalTo(22)
                    make.width.equalTo(22)
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.bottom.equalTo(self.view.snp.bottom).offset(-30)
                }
                self.profileMenuButton.superview?.layoutIfNeeded()
                
                self.homeMenuButton.updateCirclesColor(color: Color.Menu.Button.normal)
                self.placesMenuButton.tintColor = Color.Menu.Button.normal
                self.profileMenuButton.tintColor = Color.Menu.Button.normal
                self.selectionMenuBar.backgroundColor = Color.Menu.Button.normal
            })
            horizontalScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
    }
    
    @objc func didTapHomeButton(_ sender: UITapGestureRecognizer) {
        
        if currentController != 0 {
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                self.placesMenuButton.snp.updateConstraints { (make) -> Void in
                    make.right.equalTo(self.view.snp.right).offset(-50)
                }
                self.profileMenuButton.snp.updateConstraints { (make) -> Void in
                    make.left.equalTo(self.view.snp.left).offset(50)
                }
                self.selectionMenuBar.snp.remakeConstraints { (make) -> Void in
                    make.height.equalTo(10)
                    make.width.equalTo(self.homeMenuButton.snp.width).multipliedBy(1.15)
                    make.centerX.equalTo(self.homeMenuButton.snp.centerX)
                    make.centerY.equalTo(self.view.snp.bottom)
                }
                self.homeMenuButton.snp.remakeConstraints { (make) -> Void in
                    make.height.equalTo(52)
                    make.width.equalTo(52)
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.bottom.equalTo(self.view.snp.bottom).offset(-30)
                }
                self.profileMenuButton.superview?.layoutIfNeeded()
                
                self.homeMenuButton.updateCirclesColor(color: Color.Menu.Button.normal)
                self.placesMenuButton.tintColor = Color.Menu.Button.normal
                self.profileMenuButton.tintColor = Color.Menu.Button.normal
                self.selectionMenuBar.backgroundColor = Color.Menu.Button.normal
            })
            horizontalScrollView.setContentOffset(CGPoint(x: view.frame.size.width, y: 0), animated: true)
        } else {
            print("Home button pressed in scanner view.")
        }
    }
    
    @objc func didForceTouchHomeButton(_ sender: ForceTouchGestureRecognizer) {
        requestPrivacyChange()
    }
    
    @objc func didTapPlacesButton(sender: UIButton) {
        
        if currentController != 1 {
            
            UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                self.placesMenuButton.snp.updateConstraints { (make) -> Void in
                    make.right.equalTo(self.view).offset(-100)
                }
                self.profileMenuButton.snp.updateConstraints { (make) -> Void in
                    make.left.equalTo(self.view).offset(100)
                }
                self.selectionMenuBar.snp.remakeConstraints { (make) -> Void in
                    make.height.equalTo(10)
                    make.width.equalTo(self.placesMenuButton.snp.width).multipliedBy(1.15)
                    make.centerX.equalTo(self.placesMenuButton.snp.centerX)
                    make.centerY.equalTo(self.view.snp.bottom)
                }
                self.homeMenuButton.snp.remakeConstraints { (make) -> Void in
                    make.height.equalTo(22)
                    make.width.equalTo(22)
                    make.centerX.equalTo(self.view)
                    make.bottom.equalTo(self.view).offset(-30)
                }
                self.profileMenuButton.superview?.layoutIfNeeded()
                
                self.homeMenuButton.updateCirclesColor(color: Color.Menu.Button.nearbyPlacesView)
                self.placesMenuButton.tintColor = Color.Menu.Button.nearbyPlacesView
                self.profileMenuButton.tintColor = Color.Menu.Button.nearbyPlacesView
                self.selectionMenuBar.backgroundColor = Color.Menu.Button.nearbyPlacesView
            })
            horizontalScrollView.setContentOffset(CGPoint(x: view.frame.size.width * 2, y: 0), animated: true)
        }
    }
}

// MARK: Scroll handlers
extension MenuViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.tag == 10 {
            titleManagerHorizontal(scrollX: scrollView.contentOffset.x)
            menuManagerHorizontal(scrollX: scrollView.contentOffset.x)
            
            if scrollView.contentOffset.x > view.frame.size.width {
                let alpha = (scrollView.contentOffset.x  - view.frame.size.width) / (view.frame.size.width)
                colorEffectView.image = #imageLiteral(resourceName: "background_gradient_right")
                colorEffectView.alpha = alpha
                currentController = 1
            } else if scrollView.contentOffset.x < view.frame.size.width {
                let alpha = (scrollView.contentOffset.x / view.frame.size.width)
                colorEffectView.image = #imageLiteral(resourceName: "background_gradient_left")
                colorEffectView.alpha = 1 - alpha
                currentController = -1
            } else {
                currentController = 0
                colorEffectView.image = #imageLiteral(resourceName: "background_gradient_center")
            }
        } else if scrollView.tag == 20 {
            
            if scrollView.contentOffset.y == view.frame.size.height {
                self.horizontalScrollView.isScrollEnabled = false
            } else {
                self.horizontalScrollView.isScrollEnabled = true
            }
            
            if scrollView.contentOffset.y > 0 { // contactsVC
                let alpha = (scrollView.contentOffset.y) / (view.frame.size.height)
                colorEffectView.alpha = alpha
            }
        }
    }
    
    func titleManagerHorizontal(scrollX: CGFloat) {
        
        statusBarHorizontalManager(scrollX: scrollX)
        
        if scrollX > view.frame.size.width { // NearbyPlacesVC
            
            self.titleLabel.snp.updateConstraints { (make) -> Void in
                make.centerX.equalTo(self.view.snp.centerX).offset(((scrollX - view.frame.size.width)/10)*2.5)
            }
            if scrollX < view.frame.size.width * 1.5 {
                self.titleLabel.text = currentPlaceName
                let alpha = ((scrollX - view.frame.width * 1.5) * 4) / (view.frame.width * 2)
                self.titleLabel.alpha = alpha * -1
                self.titleLabel.textColor = Color.Menu.Title.mainView
            } else {
                let alpha = ((scrollX - view.frame.width * 1.5) * 4) / (view.frame.width * 2)
                self.titleLabel.alpha = alpha
                self.titleLabel.text = "Nearby Places"
                self.titleLabel.textColor = Color.Menu.Title.normal
            }
        } else if scrollX < view.frame.size.width { // ProfileVC
            
            self.titleLabel.snp.updateConstraints { (make) -> Void in
                make.centerX.equalTo(self.view.snp.centerX).inset(((scrollX - view.frame.size.width)/10)*3.5)
            }
            if scrollX > view.frame.size.width / 2 {
                self.titleLabel.text = currentPlaceName
                let alpha = 1 - (scrollX * 2) / view.frame.width
                self.titleLabel.alpha = alpha * -1
                self.titleLabel.textColor = Color.Menu.Title.mainView
            } else {
                self.titleLabel.text = "Profile"
                let alpha = 1 - (scrollX * 2) / view.frame.width
                self.titleLabel.alpha = alpha
                self.titleLabel.textColor = Color.Menu.Title.normal
            }
        }
    }
    
    func menuManagerHorizontal(scrollX: CGFloat) {
        
        if horizontalScrollView.isDecelerating || horizontalScrollView.isDragging {
            
            if scrollX < view.frame.size.width { // Profile
                
                let offset = 1 - (scrollX / view.frame.width)
                
                self.placesMenuButton.snp.updateConstraints { (make) -> Void in
                    make.right.equalTo(self.view.snp.right).offset(-50 - 50 * offset)
                }
                self.profileMenuButton.snp.updateConstraints { (make) -> Void in
                    make.left.equalTo(self.view.snp.left).offset(50 + 50 * offset)
                }
                self.selectionMenuBar.snp.remakeConstraints { (make) -> Void in
                    make.height.equalTo(10)
                    make.width.equalTo(65 - offset*35)
                    make.centerX.equalTo(self.homeMenuButton.snp.centerX).offset(-78 * offset)
                    make.centerY.equalTo(self.view.snp.bottom)
                }
                self.homeMenuButton.snp.remakeConstraints { (make) -> Void in
                    make.height.equalTo(52 - 30 * offset) //->22
                    make.width.equalTo(52 - 30 * offset) //->22
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.bottom.equalTo(self.view.snp.bottom).offset(-30)
                }
                
            } else if scrollX > view.frame.size.width { // Places
                
                let offset = ((scrollX - view.frame.width) / view.frame.width)
                
                self.placesMenuButton.snp.updateConstraints { (make) -> Void in
                    make.right.equalTo(self.view.snp.right).offset(-50 - 50 * offset)
                }
                self.profileMenuButton.snp.updateConstraints { (make) -> Void in
                    make.left.equalTo(self.view.snp.left).offset(50 + 50 * offset)
                }
                self.selectionMenuBar.snp.remakeConstraints { (make) -> Void in
                    make.height.equalTo(10)
                    make.width.equalTo(65 - offset*25)
                    make.centerX.equalTo(self.homeMenuButton.snp.centerX).offset(75 * offset)
                    make.centerY.equalTo(self.view.snp.bottom)
                }
                self.homeMenuButton.snp.remakeConstraints { (make) -> Void in
                    make.height.equalTo(52 - 30 * offset) //->22
                    make.width.equalTo(52 - 30 * offset) //->22
                    make.centerX.equalTo(self.view.snp.centerX)
                    make.bottom.equalTo(self.view.snp.bottom).offset(-30)
                }
                
                // update menu color to fit nearby places vc colors
                let color = UIColor(red:0.11 + 0.89 * offset, green:0.20 + 0.8 * offset, blue:0.35 + 0.65 * offset, alpha:1.0)
                
                self.homeMenuButton.updateCirclesColor(color: color)
                self.placesMenuButton.tintColor = color
                self.profileMenuButton.tintColor = color
                self.selectionMenuBar.backgroundColor = color
            }
        }
    }
}


// MARK: Status bar manager
extension MenuViewController {
    
    func statusBarHorizontalManager(scrollX: CGFloat) {
        
        if scrollX > view.frame.size.width {
            if scrollX < view.frame.size.width * 1.5 {
                
                if !statusBarIsDark {
                    makeStatusBarDark()
                }
            } else {
                if statusBarIsDark {
                    makeStatusBarLight()
                }
            }
        } else if scrollX < view.frame.size.width { // ProfileVC
            
            if scrollX > view.frame.size.width / 2 {
                if !statusBarIsDark {
                    makeStatusBarDark()
                }
            } else {
                if statusBarIsDark {
                    makeStatusBarLight()
                }
            }
        }
    }
    
    func makeStatusBarDark() {
        
        statusBarIsDark = true
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func makeStatusBarLight() {
        
        statusBarIsDark = false
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        
        if statusBarIsDark {
            return .default
        } else {
            return .lightContent
        }
    }
}

// MARK: External View Controllers utils
extension MenuViewController {
    
    func updatePlaceName(name: String) {
        
        currentPlaceName = name
        if titleLabel.text != "Profile" && titleLabel.text != "Nearby Places" {
            titleLabel.text = name
        }
    }
    
    func startLoadingAnimation() {
        
        homeMenuButton.setCirclesCenters()
        homeMenuButton.startAnimation()
    }
    
    func stopLoadingAnimation() {
        
        homeMenuButton.stopAnimation()
    }
    
    func hideMenu(completion: @escaping(Bool) -> Void) {
        
        self.profileMenuButton.layer.removeAllAnimations()
        self.homeMenuButton.layer.removeAllAnimations()
        self.placesMenuButton.layer.removeAllAnimations()
        self.selectionMenuBar.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.profileMenuButton.alpha = 0
            self.homeMenuButton.alpha = 0
            self.placesMenuButton.alpha = 0
            self.selectionMenuBar.alpha = 0
        }, completion: { end in
            completion(true)
        })
    }
    
    func showMenu() {
        
        self.profileMenuButton.layer.removeAllAnimations()
        self.homeMenuButton.layer.removeAllAnimations()
        self.placesMenuButton.layer.removeAllAnimations()
        self.selectionMenuBar.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.profileMenuButton.alpha = 1
            self.homeMenuButton.alpha = 1
            self.placesMenuButton.alpha = 1
            self.selectionMenuBar.alpha = 1
        })
    }
}

// MARK: Alerts
extension MenuViewController {
    
    func reachabilityDidChange(reachable: Bool) {
        
        if !reachable {
            profileMenuButton.tintColor = Color.Menu.Button.unreachable
            placesMenuButton.tintColor = Color.Menu.Button.unreachable
            selectionMenuBar.backgroundColor = Color.Menu.Button.unreachable
            homeMenuButton.updateCirclesColor(color: Color.Menu.Button.unreachable)
            titleLabel.isHidden = true
        } else {
            profileMenuButton.tintColor = Color.Menu.Button.normal
            placesMenuButton.tintColor = Color.Menu.Button.normal
            selectionMenuBar.backgroundColor = Color.Menu.Button.normal
            homeMenuButton.updateCirclesColor(color: Color.Menu.Button.normal)
            titleLabel.isHidden = false
        }
    }
    
    func privacyDidChange(ghost: Bool) {
        
        if ghost {
            profileMenuButton.tintColor = Color.Menu.Button.ghost
            placesMenuButton.tintColor = Color.Menu.Button.ghost
            selectionMenuBar.backgroundColor = Color.Menu.Button.ghost
            homeMenuButton.updateCirclesColor(color: Color.Menu.Button.ghost)
            titleLabel.isHidden = true
        } else {
            profileMenuButton.tintColor = Color.Menu.Button.normal
            placesMenuButton.tintColor = Color.Menu.Button.normal
            selectionMenuBar.backgroundColor = Color.Menu.Button.normal
            homeMenuButton.updateCirclesColor(color: Color.Menu.Button.normal)
            titleLabel.isHidden = false
        }
    }
    
    func requestPrivacyChange() {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didRequestPrivacyChange"), object: nil)
    }
}

// MARK: Constraints
extension MenuViewController {
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            horizontalScrollView.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(view)
                make.centerY.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(view)
            }
            mainVC.view.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(view)
                make.top.equalTo(horizontalScrollView)
                make.width.equalTo(view)
                make.height.equalTo(view)
            }
            profileVC.view.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(horizontalScrollView)
                make.bottom.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(view)
            }
            nearbyPlacesVC.view.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(profileVC.view.snp.right).offset(view.frame.size.width)
                make.bottom.equalTo(view)
                make.width.equalTo(view)
                make.height.equalTo(view)
            }
            colorEffectView.snp.makeConstraints { (make) -> Void in
                make.centerX.equalTo(mainVC.view)
                make.centerY.equalTo(mainVC.view)
                make.width.equalTo(mainVC.view)
                make.height.equalTo(mainVC.view)
            }
            
            // MARK: Header
            titleLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view).multipliedBy(0.7)
                make.centerX.equalTo(view)
                make.top.equalTo(view).offset(50)
            }
            
            // MARK: Navigation Menu
            profileMenuButton.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(22)
                make.width.equalTo(18)
                make.left.equalTo(view).offset(50)
                make.bottom.equalTo(view).offset(-30)
            }
            homeMenuButton.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(52)
                make.width.equalTo(52)
                make.centerX.equalTo(view)
                make.bottom.equalTo(view).offset(-30)
            }
            placesMenuButton.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(22)
                make.width.equalTo(25)
                make.right.equalTo(view).offset(-50)
                make.bottom.equalTo(view).offset(-30)
            }
            selectionMenuBar.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(10)
                make.width.equalTo(60)
                make.centerX.equalTo(homeMenuButton)
                make.centerY.equalTo(view.snp.bottom)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}
