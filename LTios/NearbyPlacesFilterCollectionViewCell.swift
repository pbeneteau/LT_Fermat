//
//  NearbyPlacesFilterCollectionViewCell.swift
//  LTios
//
//  Created by Paul Bénéteau on 31/01/2019.
//  Copyright © 2019 Tastyapp. All rights reserved.
//

import UIKit

class NearbyPlacesFilterCollectionViewCell: UICollectionViewCell {
    
    let queue = SerialOperationQueue()

    var label = UILabel()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
        label.font = LTFont.NearbyPlaces.FilterCollectionView.label
        label.textColor = Color.NearbyPlaces.FilterCollectionView.Label.normal
        label.textAlignment = .center
        
        contentView.addSubview(label)
        
        setNeedsUpdateConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
        setNeedsUpdateConstraints()
    }
}


// MARK: Constraints
extension NearbyPlacesFilterCollectionViewCell {
    
    override func updateConstraints() {
        
        label.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(contentView)
            make.centerY.equalTo(contentView).offset(1)
            make.height.equalTo(contentView)
            make.width.equalTo(contentView)
        }
        super.updateConstraints()
    }
}
