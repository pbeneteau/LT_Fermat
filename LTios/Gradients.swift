//
//  ImageVIewWithGradient.swift
//  LTios
//
//  Created by Paul Bénéteau on 19/08/2018.
//  Copyright © 2018 Tastyapp. All rights reserved.
//

import UIKit

class ImageViewWithGradient: UIImageView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor(red:0.00, green:0.00, blue:0.00, alpha:0.7).cgColor]
        gradientLayer.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y + self.frame.height / 2, width: self.frame.width, height: self.frame.height / 2)
        
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale;
        
        self.layer.addSublayer(gradientLayer)
    }
}

class VerticalGradientView: UIView {
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setGradientColors(topColor: UIColor, botColor: UIColor) {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.colors = [topColor.cgColor, botColor.cgColor]
    }
}

class HorizontalGradientView: UIView {
    
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setGradientColors(leftColor: UIColor, rightColor: UIColor) {
        let gradientLayer = layer as! CAGradientLayer
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [rightColor.cgColor, leftColor.cgColor]
    }
}

