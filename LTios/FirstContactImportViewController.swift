//
//  FirstContactImportViewController.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-31.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class FirstContactImportViewController: UIViewController {
  
  var didSetupConstraints = false
  
  let bg = UIImageView(image: #imageLiteral(resourceName: "RegisterationBG"))
  let mainTitle = FirstContactLabel()
  let contactImage = UIImageView(image: #imageLiteral(resourceName: "contactIcon"))
  let importButton = FirstImportButton()
  let agreementsLabel = FirstContactAgreementsLabel()
  
  let successImage = UIImageView(image: #imageLiteral(resourceName: "verificationSuccess"))
  let successLabel = VerificationSuccessLabel()
  
  let stateImage = UIImageView(image: #imageLiteral(resourceName: "registrationState1"))
  let actualState = UIImageView(image: #imageLiteral(resourceName: "actualState"))
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    successImage.alpha = 0.0
    successLabel.alpha = 0.0
    
    view.addSubview(bg)
    view.addSubview(mainTitle)
    view.addSubview(contactImage)
    view.addSubview(importButton)
    view.addSubview(agreementsLabel)
    
    view.addSubview(successImage)
    view.addSubview(successLabel)
    
    view.addSubview(stateImage)
    view.addSubview(actualState)
    
    importButton.addTarget(self, action: #selector(importButtonPressed), for: .touchUpInside)
    
    self.view.setNeedsUpdateConstraints()
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
      
      
      contactImage.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(view.snp.bottom).multipliedBy(0.22)
        make.centerX.equalTo(view.snp.centerX)
        make.width.equalTo(122)
        make.height.equalTo(156)
      }
      
      mainTitle.snp.makeConstraints { (make) -> Void in
        make.bottom.equalTo(contactImage.snp.top).offset(-48)
        make.centerX.equalTo(view.snp.centerX)
      }
      
      importButton.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(contactImage.snp.bottom).offset(87)
        make.centerX.equalTo(view.snp.centerX)
        make.width.equalTo(contactImage.snp.width)
        make.height.equalTo(33)
      }
      
      agreementsLabel.snp.makeConstraints { (make) -> Void in
          make.top.equalTo(importButton.snp.bottom).offset(24)
          make.centerX.equalTo(view.snp.centerX)
          make.width.equalTo(view.snp.width).multipliedBy(0.80)
      }
      
      stateImage.snp.makeConstraints { (make) -> Void in
        make.bottom.equalTo(view.snp.bottom).offset(-11)
        make.centerX.equalTo(view.snp.centerX)
      }
      
      actualState.snp.makeConstraints { (make) -> Void in
        make.bottom.equalTo(stateImage.snp.bottom)
        make.right.equalTo(stateImage.snp.right)
      }
      
      successImage.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(contactImage.snp.bottom).offset(46)
        make.centerX.equalTo(view.snp.centerX)
      }
      
      successLabel.snp.makeConstraints { (make) -> Void in
        make.top.equalTo(successImage.snp.bottom).offset(18)
        make.centerX.equalTo(successImage.snp.centerX)
      }
      
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
    @objc func importButtonPressed() {
    success()
  }
  
  func success() {
    importButton.alpha = 0.0
    agreementsLabel.alpha = 0.0
    UIView.animate(withDuration: 0.5) {
      self.successImage.alpha = 1.0
      self.successLabel.alpha = 1.0
    }
    let when = DispatchTime.now() + 1
    DispatchQueue.main.asyncAfter(deadline: when) {
      //self.present(menuVC, animated: false, completion: nil)
    }
  }
  
}
