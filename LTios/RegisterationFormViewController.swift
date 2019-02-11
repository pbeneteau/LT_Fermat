//
//  RegisterationFormViewController.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-31.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class RegisterationFormViewController: UIViewController {
  
  var didSetupConstraints = false
  
  let bg = UIImageView(image: #imageLiteral(resourceName: "RegisterationBG"))
  
  let descriptionLabel = RegisterFormLabel()
  let formView = RegisterForm()
  
  let separators = [UIImageView(image: #imageLiteral(resourceName: "Separator")),UIImageView(image: #imageLiteral(resourceName: "Separator")),UIImageView(image: #imageLiteral(resourceName: "Separator"))]
  
  let registerButton = RegisterButton()
  let agreementsLabel = RegisterAgreementsLabel()
  let stateImage = UIImageView(image: #imageLiteral(resourceName: "registrationState1"))
  let actualState = UIImageView(image: #imageLiteral(resourceName: "actualState"))
  
  var formHeight: CGFloat = 0.0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    formHeight = view.frame.height * CGFloat(0.3421052632)
    
    view.addSubview(bg)
    view.addSubview(descriptionLabel)
    view.addSubview(formView)
    
    for separator in separators {
      view.addSubview(separator)
    }
    
    view.addSubview(registerButton)
    view.addSubview(agreementsLabel)
    view.addSubview(stateImage)
    view.addSubview(actualState)
    
    registerButton.addTarget(self, action: #selector(registerButtonPressed), for: .touchUpInside)
    
    self.view.setNeedsUpdateConstraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
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
      
      descriptionLabel.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(view.snp.bottom).multipliedBy(0.2)
        make.centerX.equalTo(view.snp.centerX)
      }
      
      if UIScreen.main.bounds.size.width <= 414 {
        formView.snp.makeConstraints { (make) -> Void in
          make.top.equalTo(view.snp.bottom).multipliedBy(0.26)
          make.centerX.equalTo(view.snp.centerX)
          make.width.equalTo(view.snp.width).multipliedBy(0.875)
          make.height.equalTo(view.snp.height).multipliedBy(0.3421052632)
        }
        
      } else {
        formHeight = 251.66
        formView.snp.makeConstraints { (make) -> Void in
          make.top.equalTo(view.snp.bottom).multipliedBy(0.26)
          make.centerX.equalTo(view.snp.centerX)
          make.width.equalTo(362)
          make.height.equalTo(251.66)
        }
      }
      
      var i : CGFloat = 1
      for separator in separators {
        separator.snp.makeConstraints { (make) -> Void in
          make.centerY.equalTo(formView.snp.top).offset(i * formHeight / 4)
          make.left.equalTo(formView.snp.left)
          make.right.equalTo(formView.snp.right)
        }
        i += 1
      }
      
      separators[0].snp.makeConstraints { (make) -> Void in
        make.centerY.equalTo(formView.snp.top).offset(formHeight / 4)
        make.left.equalTo(formView.snp.left)
        make.right.equalTo(formView.snp.right)
      }
      
      registerButton.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(formView.snp.bottom).offset(17)
        make.centerX.equalTo(view.snp.centerX)
        make.width.equalTo(formView.snp.width)
        make.height.equalTo(56)
      }

      
      agreementsLabel.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(registerButton.snp.bottom).offset(8)
        make.centerX.equalTo(registerButton.snp.centerX)
      }
      
      stateImage.snp.makeConstraints { (make) -> Void in
        make.bottom.equalTo(view.snp.bottom).offset(-11)
        make.centerX.equalTo(view.snp.centerX)
      }
      
      actualState.snp.makeConstraints { (make) -> Void in
        make.bottom.equalTo(stateImage.snp.bottom)
        make.centerX.equalTo(stateImage.snp.centerX)
      }
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
    @objc func registerButtonPressed() {
    let firstContactVC = FirstContactImportViewController()
    present(firstContactVC, animated: false, completion: nil)
  }

}
