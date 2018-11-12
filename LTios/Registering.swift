//
//  Registering.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-31.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit
import PhoneNumberKit
import SnapKit


// MARK: - Phone Verification


class LogoTitle: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        text = "Little World"
        font = UIFont(name: "Roboto-Medium", size: 36)
        textColor = .white
        textAlignment = .center
        minimumScaleFactor = 0.5
    }
}

class Slogan: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        text = "Connect the world"
        font = UIFont(name: "Roboto-Light", size: 16)
        textColor = .white
        textAlignment = .center
    }
}


class CountryButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        setImage(#imageLiteral(resourceName: "FR"), for: .normal)
    }
}


class PhoneTextField: PhoneNumberTextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .white
        font = UIFont(name: "Roboto-Regular", size: 20)
        borderStyle = .none
        keyboardType = .phonePad
        keyboardAppearance = .light
        returnKeyType = .go
        autocorrectionType = .no
        isPartialFormatterEnabled = false
    }
}

class PhonePlaceHolder: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        text = " Enter your phone number"
        font = UIFont(name: "Roboto-Light", size: 16)
        textColor = .white
        textAlignment = .center
        minimumScaleFactor = 0.2
        adjustsFontSizeToFitWidth = true
    }
}

class PhoneTextFieldLine: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        image = #imageLiteral(resourceName: "PhoneTextFieldLine")
    }
}

class RegistrationNextButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        setImage(#imageLiteral(resourceName: "nextRegButton"), for: .normal)
        alpha = 0.0
    }
}

// Mark: - Code Verification

class verificationCodeLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        text = "Enter the verification code"
        font = UIFont(name: "Roboto-Light", size: 20)
        textColor = .white
        textAlignment = .center
        minimumScaleFactor = 0.5
    }
}

class DigitTextField: UITextField {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        textColor = .white
        font = UIFont(name: "Roboto-Regular", size: 27)
        textColor = .white
        borderStyle = .none
        keyboardType = .phonePad
        keyboardAppearance = .light
        returnKeyType = .next
        autocorrectionType = .no
        textAlignment = .center
        resignFirstResponder()
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        return CGRect.zero
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
}

class VerificationSuccessLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        text = "Success !"
        font = UIFont(name: "Roboto-Light", size: 14)
        textColor = .white
        textAlignment = .center
        minimumScaleFactor = 0.5
        alpha = 0.0
    }
}

class BackButton: UIButton {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        setImage(#imageLiteral(resourceName: "verificationBackArrow"), for: .normal)
    }
}

// MARK: - Registeration Form

class RegisterFormLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        text = "Fill the form to continue"
        font = UIFont(name: "Roboto-Light", size: 20)
        textColor = .white
        textAlignment = .center
        minimumScaleFactor = 0.5
    }
}

class RegisterForm: UIView {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 5
    }
}

class RegisterButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 5
        clipsToBounds = true
        setBackgroundColor(color: UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0), forState: .highlighted)
        let numberAsString = "REGISTER"
        
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15.0)!, NSAttributedString.Key.foregroundColor: UIColor.CustomColor.blue]
        
        setAttributedTitle(NSAttributedString(string: numberAsString, attributes: attributes), for: .normal)
        
    }
}



class RegisterAgreementsLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        text = "By clicking this button you agree our terms and conditions"
        font = UIFont(name: "Roboto-Light", size: 11)
        textColor = .white
        textAlignment = .center
        minimumScaleFactor = 0.5
    }
}


// MARK: - Import Contacts

class FirstContactLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        text = "Import your contacts"
        font = UIFont(name: "Roboto-Light", size: 20)
        textColor = .white
        textAlignment = .center
        minimumScaleFactor = 0.5
    }
}

class FirstImportButton: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        layer.cornerRadius = 15
        clipsToBounds = true
        setBackgroundColor(color: UIColor(red:0.93, green:0.94, blue:0.95, alpha:1.0), forState: .highlighted)
        let numberAsString = "IMPORT"
        let attributes = [NSAttributedString.Key.font: UIFont(name: "Roboto-Regular", size: 15.0)!, NSAttributedString.Key.foregroundColor: UIColor.CustomColor.blue]
        
        setAttributedTitle(NSAttributedString(string: numberAsString, attributes: attributes), for: .normal)
    }
}

class FirstContactAgreementsLabel: UILabel {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        translatesAutoresizingMaskIntoConstraints = false
        text = "You will be able to manage your contact list in your profile"
        font = UIFont(name: "Roboto-Light", size: 14)
        textColor = .white
        textAlignment = .center
        numberOfLines = 3
        minimumScaleFactor = 0.5
    }
}


