//
//  ViewController.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-19.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit
import FirebaseAuth
import SnapKit
import PhoneNumberKit

class StartViewController: UIViewController {
    
    var didSetupConstraints = false
    var worldIsAnimating = false
    
    let phoneNumberKit = PhoneNumberKit()
    
    let bg = UIImageView(image: #imageLiteral(resourceName: "RegisterationBG"))
    let world = UIImageView(image: #imageLiteral(resourceName: "World"))
    let logo = LogoTitle()
    let slogan = Slogan()
    lazy var countrySelector: CountryButton = {
        let view = CountryButton()
        // view.addTarget...
        return view
    }()
    
    lazy var phoneTextField: PhoneTextField = {
        let view = PhoneTextField()
        return view
    }()
    let phonePlaceHolder = PhonePlaceHolder()
    let phoneTextFieldLine = PhoneTextFieldLine(frame: CGRect())
    let flagArrow = UIImageView(image: #imageLiteral(resourceName: "FlagArrow"))
    let nextButton = RegistrationNextButton()
    
    let countryVC = CountryViewController()
    var countryCodeString = "+33 "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bg)
        view.addSubview(world)
        view.addSubview(logo)
        view.addSubview(slogan)
        view.addSubview(countrySelector)
        view.addSubview(phoneTextField)
        view.addSubview(phonePlaceHolder)
        view.addSubview(phoneTextFieldLine)
        view.addSubview(flagArrow)
        view.addSubview(nextButton)
        
        addChild(countryVC)
        view.addSubview(countryVC.view)
        
        phoneTextField.delegate = self
        phoneTextField.addTarget(self, action: #selector(textFieldChanged), for: .allEditingEvents)
        initTextField(string: "")
        
        countrySelector.addTarget(self, action: #selector(openCountryView), for: .touchUpInside)
        
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
        
        self.view.setNeedsUpdateConstraints()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closeCountryView), name: NSNotification.Name(rawValue: "closeCountryView"), object: nil)
        if !worldIsAnimating {
            animateWorld()
            worldIsAnimating = true
        }
        
        let email = "inesbenett@hotmail.fr"
        let password = "combava"
        let firstname = "Inès"
        let lastname = "Bénéteau"
        
        // [START headless_email_auth]
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            // [START_EXCLUDE]
            
            if let error = error {
                print(error.localizedDescription)
            }
            else if let user = authResult?.user {
                //DatabaseService.shared.createNewUserInDatabase(uid: user.uid, firstname: firstname, lastname: lastname)
            }
            // [END_EXCLUDE]
        }
        // [END headless_email_auth]
    }
    
    
    private func animateWorld() {
        
        UIView.animate(withDuration: 500, delay: 0, options: [.repeat, .curveLinear], animations: { () -> Void in
            self.world.snp.updateConstraints { make in
                make.left.equalTo(self.view.snp.left).offset(-self.world.frame.width)
            }
            self.world.superview?.layoutIfNeeded()
        })
    }
    
    
    @objc func openCountryView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { () -> Void in
            self.countryVC.view.snp.remakeConstraints { make in
                make.width.equalTo(self.view.snp.width)
                make.centerX.equalTo(self.view.snp.centerX)
                make.bottom.equalTo(self.view.snp.bottom)
                make.height.equalTo(self.view.snp.height)
            }
            self.phoneTextField.superview?.layoutIfNeeded()
        })
        disableTextField()
    }
    
    @objc func closeCountryView(notification: NSNotification){
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { () -> Void in
            self.countryVC.view.snp.remakeConstraints { make in
                make.width.equalTo(self.view.snp.width)
                make.centerX.equalTo(self.view.snp.centerX)
                make.bottom.equalTo(self.view.snp.bottom).offset(self.view.frame.height)
                make.height.equalTo(self.view.snp.height)
            }
            self.phoneTextField.superview?.layoutIfNeeded()
        })
        countrySelector.setImage(UIImage(named: selectedCountry), for: .normal)
        let countryCode = Int(phoneNumberKit.countryCode(for: selectedCountry)!)
        countryCodeString = "+\(countryCode) "
        initTextField(string: "")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        disableTextField()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            enableTextField(keyboardHeight: keyboardHeight)
        }
    }
    
    func enableTextField(keyboardHeight: CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { () -> Void in
            self.phoneTextField.snp.remakeConstraints { make in
                make.bottom.equalTo(self.view.snp.bottom).offset(-keyboardHeight - self.nextButton.frame.height - 70)
                make.centerX.equalTo(self.view.snp.centerX).offset(35)
                make.width.equalTo(self.view.snp.width).multipliedBy(0.6)
            }
            self.phoneTextField.superview?.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: { () -> Void in
            self.phonePlaceHolder.alpha = 0.0
        })
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: { () -> Void in
            self.phoneTextFieldLine.snp.updateConstraints { make in
                make.height.equalTo(3)
                make.centerY.equalTo(self.countrySelector.snp.bottom).offset(5)
            }
            self.phoneTextField.superview?.layoutIfNeeded()
        })
    }
    
    func disableTextField() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: { () -> Void in
            self.phoneTextField.snp.remakeConstraints { make in
                make.width.equalTo(self.view.snp.width).multipliedBy(0.6)
                make.top.equalTo(self.view.snp.bottom).multipliedBy(0.75)
                make.centerX.equalTo(self.view.snp.centerX).offset(35)
            }
            self.phoneTextField.superview?.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.1, delay: 0.3, options: [.curveLinear], animations: { () -> Void in
            self.phonePlaceHolder.alpha = 1.0
        })
        UIView.animate(withDuration: 0.2, delay: 0, options: [.curveLinear], animations: { () -> Void in
            self.phoneTextFieldLine.snp.updateConstraints { make in
                make.height.equalTo(1)
                make.centerY.equalTo(self.countrySelector.snp.bottom).offset(5)
            }
            self.phoneTextField.superview?.layoutIfNeeded()
        })
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: { () -> Void in
            self.nextButton.alpha = 0.0
        })
        initTextField(string: "")
    }
    
    @objc func nextButtonPressed() {
        let verificationVC = PhoneVerificationViewController()
        navigationController?.pushViewController(verificationVC, animated: true)
    }
    
}


extension StartViewController: UITextFieldDelegate {
    
    func initTextField(string: String) {
        let protectedRange = NSMakeRange(0, countryCodeString.count)
        let attributedString = NSMutableAttributedString(string: countryCodeString)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0), range: protectedRange)
        attributedString.append(NSAttributedString(string: string))
        phoneTextField.attributedText = attributedString
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    @objc func textFieldChanged() {
        let partialFormatter = PartialFormatter(phoneNumberKit: phoneNumberKit, defaultRegion: selectedCountry, withPrefix: false)
        let protectedRange = NSMakeRange(0, countryCodeString.count)
        let substring = phoneTextField.text!.index(phoneTextField.text!.startIndex, offsetBy: protectedRange.length)
        initTextField(string: partialFormatter.formatPartial(phoneTextField.text!.substring(from: substring)))
        
        if (phoneTextField.text?.count)! > protectedRange.length {
            if nextButton.alpha != 1.0 {
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: { () -> Void in
                    self.nextButton.alpha = 1.0
                })
            }
        } else {
            if nextButton.alpha != 0.0 {
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveLinear], animations: { () -> Void in
                    self.nextButton.alpha = 0.0
                })
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let protectedRange = NSMakeRange(0, countryCodeString.count)
        let intersection = NSIntersectionRange(protectedRange, range)
        if intersection.length > 0 {
            
            return false
        }
        
        return true
    }
    
}

//MARK: Constraints
extension StartViewController {
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            bg.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
                make.centerX.equalTo(view.snp.centerX)
                make.centerY.equalTo(view.snp.centerY)
            }
            
            world.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(view.snp.top)
                make.left.equalTo(view.snp.left)
            }
            
            logo.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(view.snp.bottom).multipliedBy(0.12)
                make.centerX.equalTo(view.snp.centerX)
            }
            
            slogan.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(logo.snp.bottom).offset(5)
                make.centerX.equalTo(view.snp.centerX)
            }
            
            phoneTextField.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width).multipliedBy(0.6)
                make.top.equalTo(view.snp.bottom).multipliedBy(0.75)
                make.centerX.equalTo(view.snp.centerX).offset(35)
            }
            
            phonePlaceHolder.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(phoneTextField.snp.width).multipliedBy(0.8)
                make.height.equalTo(21)
                make.centerY.equalTo(phoneTextField.snp.centerY).offset(-1)
                make.right.equalTo(phoneTextField.snp.right)
            }
            
            countrySelector.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(60)
                make.height.equalTo(40)
                make.centerY.equalTo(phoneTextField.snp.centerY)
                make.right.equalTo(phoneTextField.snp.left).offset(-10)
            }
            
            phoneTextFieldLine.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(phoneTextField.snp.width)
                make.height.equalTo(1)
                make.centerY.equalTo(countrySelector.snp.bottom).offset(3)
                make.centerX.equalTo(phoneTextField.snp.centerX)
            }
            
            flagArrow.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(countrySelector.snp.bottom).offset(3)
                make.centerX.equalTo(countrySelector.snp.centerX)
            }
            
            nextButton.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(phoneTextFieldLine.snp.bottom).offset(20)
                make.right.equalTo(view.snp.right).offset(-20)
            }
            
            countryVC.view.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width)
                make.centerX.equalTo(view.snp.centerX)
                make.bottom.equalTo(view.snp.bottom).offset(self.view.frame.height)
                make.height.equalTo(view.snp.height)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}
