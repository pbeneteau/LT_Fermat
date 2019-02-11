//
//  NearbyPlacesUICollectionViewCell.swift
//  LTios
//
//  Created by Paul Bénéteau on 08/10/2017.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class NearbyPlacesUICollectionViewCell: UICollectionViewCell {
    
    let queue = SerialOperationQueue()
    
    let shadowEffectView = UIView()
    let placeImageView = ImageViewWithGradient()
    
    let publicNameLabel = UILabel()
    let distanceIcon = UIImageView()
    let distanceLabel = UILabel()
    let peopleLabel = UILabel()
    let typeLabel = UILabel()
    let peopleIcon = UIImageView()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareForReuse()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        contentView.addSubview(shadowEffectView)
        contentView.addSubview(placeImageView)
        contentView.addSubview(publicNameLabel)
        contentView.addSubview(distanceIcon)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(peopleLabel)
        contentView.addSubview(peopleIcon)
        
        self.updateConstraints()
        
        shadowEffectView.backgroundColor = .white
        shadowEffectView.addShadow(offset: CGSize(width: 0, height: 18.0), color: UIColor.black, radius: 15, opacity: 0.3)
        
        placeImageView.backgroundColor = .clear
        placeImageView.clipsToBounds = true
        placeImageView.contentMode = .scaleAspectFill
        placeImageView.layer.cornerRadius = 15
        
        publicNameLabel.font = LTFont.NearbyPlaces.NearbyPlacesCollectionView.Cell.name
        publicNameLabel.textColor = .white
        
        distanceIcon.image = UIImage(named: "ic_location")
        
        distanceLabel.font = LTFont.NearbyPlaces.NearbyPlacesCollectionView.Cell.distance
        distanceLabel.textColor = .white
        
        typeLabel.font = LTFont.NearbyPlaces.NearbyPlacesCollectionView.Cell.type
        typeLabel.textColor = .white
        
        peopleLabel.font = LTFont.NearbyPlaces.NearbyPlacesCollectionView.Cell.people
        peopleLabel.textColor = .white
        peopleLabel.textAlignment = .right
        
        peopleIcon.image = UIImage(named: "ic_persons")
        
    }
    
}

// MARK: Constraints
extension NearbyPlacesUICollectionViewCell {
    
    override func updateConstraints() {
        
        placeImageView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(contentView).multipliedBy(0.8875)
            make.height.equalTo(contentView).multipliedBy(0.95)
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView)
        }
        
        shadowEffectView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(placeImageView).multipliedBy(0.95)
            make.height.equalTo(placeImageView).multipliedBy(0.95)
            make.center.equalTo(placeImageView)
        }
        
        typeLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(placeImageView).multipliedBy(0.65)
            make.left.equalTo(placeImageView).offset(10)
            make.bottom.equalTo(publicNameLabel.snp.top).inset(-5)
        }
        
        publicNameLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(placeImageView).multipliedBy(0.65)
            make.left.equalTo(typeLabel)
            make.bottom.equalTo(placeImageView).multipliedBy(0.85)
        }
        
        distanceIcon.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(20)
            make.width.equalTo(distanceIcon.snp.height).multipliedBy(0.70683333)
            make.left.equalTo(publicNameLabel)
            make.bottom.equalTo(placeImageView).multipliedBy(0.95)
        }
        
        distanceLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(placeImageView).multipliedBy(0.65)
            make.left.equalTo(distanceIcon).offset(20)
            make.centerY.equalTo(distanceIcon)
        }
        
        peopleLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(30)
            make.height.equalTo(21)
            make.right.equalTo(placeImageView).offset(-15)
            make.centerY.equalTo(distanceIcon)
        }
        
        peopleIcon.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(distanceIcon.snp.height)
            make.height.equalTo(peopleIcon.snp.width)
            make.right.equalTo(peopleLabel.snp.left)
            make.centerY.equalTo(distanceIcon)
        }
        
        super.updateConstraints()
    }
}

