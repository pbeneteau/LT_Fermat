//
//  Extension.swift
//  LTios
//
//  Created by antoine beneteau on 2017-08-01.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

extension UIColor {
  
  struct CustomColor {
    static let blue = UIColor(red:0.09, green:0.18, blue:0.33, alpha:1.0)
  }
}


extension UIButton {
  
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
    
    UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
    UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
    UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
    let colorImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    self.setBackgroundImage(colorImage, for: forState)
  }
}

extension CGFloat {
  
  static func random(_ lower: CGFloat = 0, _ upper: CGFloat = 1) -> CGFloat {
    return CGFloat(Float(arc4random()) / Float(UINT32_MAX)) * (upper - lower) + lower
  }
}

extension CGPoint {
  
  func distance(from point: CGPoint) -> CGFloat {
    return hypot(point.x - x, point.y - y)
  }
}

extension UIView {
  func roundCorners(corners:UIRectCorner, radius: CGFloat) {
    let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
    let mask = CAShapeLayer()
    mask.path = path.cgPath
    self.layer.mask = mask
  }
}

extension UIView {
    
    func setTopCurve() {
        
        let offset = CGFloat(self.frame.size.height * 2)
        let bounds = self.bounds
        let rectBounds = CGRect(x: bounds.origin.x, y: bounds.origin.y + bounds.size.height/2  , width:  bounds.size.width, height: bounds.size.height / 2)
        let rectPath = UIBezierPath(rect: rectBounds)
        let ovalBounds = CGRect(x: bounds.origin.x - offset / 2, y: bounds.origin.y, width: bounds.size.width + offset, height: bounds.size.height)
        let ovalPath = UIBezierPath(ovalIn: ovalBounds)
        rectPath.append(ovalPath)
        
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = bounds
        maskLayer.path = rectPath.cgPath
        self.layer.mask = maskLayer
    }
    
}
