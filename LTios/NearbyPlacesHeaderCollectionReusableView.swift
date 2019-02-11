//
//  NearbyPlacesHeaderCollectionReusableView.swift
//  LTios
//
//  Created by Paul Bénéteau on 09/10/2017.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class NearbyPlacesHeaderCollectionReusableView: UICollectionReusableView {
    
    let label = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect())
        commonInit()
    }
    
    func hide() {
        self.frame.size = CGSize(width: 0, height: 0)
    }
    
    func commonInit() {
        
        if self.subviews.count == 0 {
            label.textColor = .gray
            label.font = LTFont.NearbyPlaces.NearbyPlacesCollectionView.headerTitle
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            addHeaderConstraints()
        }
    }
    
    func addHeaderConstraints() {
        
        let views = ["label": label, "view": self]
        
        let horizontallayoutContraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-23-[label]-10-|", options: .alignAllCenterY, metrics: nil, views: views)
        
        self.addConstraints(horizontallayoutContraints)
        
        let verticalLayoutContraint = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        
        self.addConstraint(verticalLayoutContraint)
    }
}

