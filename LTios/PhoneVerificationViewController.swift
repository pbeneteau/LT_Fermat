//
//  PhoneVerificationViewController.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-31.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class PhoneVerificationViewController: UIViewController {
    
    var didSetupConstraints = false
    
    let bg = UIImageView(image: #imageLiteral(resourceName: "RegisterationBG"))
    let backButton = BackButton()
    let mainLabel = verificationCodeLabel()
    
    let maskView = UIView()
    
    let digits = [DigitTextField(),DigitTextField(),DigitTextField(),DigitTextField()]
    
    let lines = [UIImageView(image: #imageLiteral(resourceName: "verificationCodeLine")),UIImageView(image: #imageLiteral(resourceName: "verificationCodeLine")),UIImageView(image: #imageLiteral(resourceName: "verificationCodeLine")),UIImageView(image: #imageLiteral(resourceName: "verificationCodeLine"))]
    
    let successImage = UIImageView(image: #imageLiteral(resourceName: "verificationSuccess"))
    let successLabel = VerificationSuccessLabel()
    
    let stateImage = UIImageView(image: #imageLiteral(resourceName: "registrationState1"))
    let actualState = UIImageView(image: #imageLiteral(resourceName: "actualState"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(bg)
        view.addSubview(backButton)
        view.addSubview(mainLabel)
        
        for digit in digits {
            view.addSubview(digit)
            digit.delegate = self
        }
        
        for line in lines {
            view.addSubview(line)
            line.alpha = 0.5
        }
        
        view.addSubview(successImage)
        view.addSubview(successLabel)
        view.addSubview(stateImage)
        view.addSubview(actualState)
        view.addSubview(maskView)
        
        backButton.addTarget(self, action: #selector(backButtonPressed), for: .touchUpInside)
        
        
        successImage.alpha = 0.0
        
        self.view.setNeedsUpdateConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        digits[0].becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func updateViewConstraints() {
        if !didSetupConstraints {
            
            bg.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height)
                make.centerX.equalTo(view.snp.centerX)
                make.centerY.equalTo(view.snp.centerY)
            }
            
            backButton.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(view.snp.left).offset(28)
                make.top.equalTo(view.snp.top).offset(33)
                make.height.equalTo(24)
                make.width.equalTo(31)
            }
            
            mainLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(view.snp.bottom).multipliedBy(0.17)
                make.centerX.equalTo(view.snp.centerX)
            }
            
            digits[1].snp.makeConstraints { (make) -> Void in
                make.width.equalTo(37)
                make.top.equalTo(view.snp.bottom).multipliedBy(0.3)
                make.right.equalTo(view.snp.centerX).offset(-6)
            }
            
            digits[0].snp.makeConstraints { (make) -> Void in
                make.width.equalTo(37)
                make.top.equalTo(digits[1].snp.top)
                make.right.equalTo(digits[1].snp.left).offset(-12)
            }
            
            
            digits[2].snp.makeConstraints { (make) -> Void in
                make.width.equalTo(37)
                make.top.equalTo(digits[1].snp.top)
                make.left.equalTo(digits[1].snp.right).offset(12)
            }
            
            digits[3].snp.makeConstraints { (make) -> Void in
                make.width.equalTo(37)
                make.top.equalTo(digits[2].snp.top)
                make.left.equalTo(digits[2].snp.right).offset(12)
            }
            
            lines[0].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(digits[0].snp.bottom).offset(3)
                make.centerX.equalTo(digits[0].snp.centerX)
            }
            
            lines[1].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(digits[1].snp.bottom).offset(3)
                make.centerX.equalTo(digits[1].snp.centerX)
            }
            
            lines[2].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(digits[2].snp.bottom).offset(3)
                make.centerX.equalTo(digits[2].snp.centerX)
            }
            
            lines[3].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(digits[3].snp.bottom).offset(3)
                make.centerX.equalTo(digits[3].snp.centerX)
            }
            
            successImage.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(view.snp.bottom).multipliedBy(0.57)
                make.centerX.equalTo(view.snp.centerX)
            }
            
            successLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(successImage.snp.bottom).offset(18)
                make.centerX.equalTo(successImage.snp.centerX)
            }
            
            stateImage.snp.makeConstraints { (make) -> Void in
                make.bottom.equalTo(view.snp.bottom).offset(-11)
                make.centerX.equalTo(successImage.snp.centerX)
            }
            
            actualState.snp.makeConstraints { (make) -> Void in
                make.bottom.equalTo(stateImage.snp.bottom)
                make.left.equalTo(stateImage.snp.left)
            }
            
            maskView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(digits[0].snp.top)
                make.left.equalTo(digits[0].snp.left)
                make.right.equalTo(digits[3].snp.right)
                make.bottom.equalTo(digits[3].snp.bottom)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
    
    func success() {
        view.endEditing(true)
        UIView.animate(withDuration: 0.5) {
            self.successImage.alpha = 1.0
            self.successLabel.alpha = 1.0
        }
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            let registerVC = RegisterationFormViewController()
            self.present(registerVC, animated: false, completion: nil)
        }
    }
    
    @objc func backButtonPressed() {
        _ = navigationController?.popViewController(animated: true)
    }
    
}


extension PhoneVerificationViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" && textField == digits[0] {
            UIView.animate(withDuration: 0.1, animations: {
                self.lines[0].alpha = 1.0
            })
        }
        
        if (textField.text?.count)! == 1 {
            if string == "" {
                if textField == digits[0] {
                    digits[0].text = string
                    digits[0].becomeFirstResponder()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.lines[0].alpha = 0.5
                    })
                } else if textField == digits[1] {
                    digits[1].text = string
                    digits[0].becomeFirstResponder()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.lines[1].alpha = 0.5
                    })
                } else if textField == digits[2] {
                    digits[2].text = string
                    digits[1].becomeFirstResponder()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.lines[2].alpha = 0.5
                    })
                } else if textField == digits[3] {
                    digits[3].text = string
                    digits[2].becomeFirstResponder()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.lines[3].alpha = 0.5
                    })
                }
            } else {
                if textField == digits[0] {
                    digits[1].text = string
                    digits[1].becomeFirstResponder()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.lines[1].alpha = 1.0
                    })
                } else if textField == digits[1] {
                    digits[2].text = string
                    digits[2].becomeFirstResponder()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.lines[2].alpha = 1.0
                    })
                } else if textField == digits[2] {
                    digits[3].text = string
                    digits[3].becomeFirstResponder()
                    UIView.animate(withDuration: 0.1, animations: {
                        self.lines[3].alpha = 1.0
                    })
                    // Finish and need to verify
                    print("\(digits[0].text!)\(digits[1].text!)\(digits[2].text!)\(digits[3].text!)")
                    self.success()
                }
            }
            return false
        }
        
        return true
    }
}





