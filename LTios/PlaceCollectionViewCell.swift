//
//  PlaceCollectionViewCell.swift
//  LTios
//
//  Created by Paul Bénéteau on 09/10/2017.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {
    
    var didSetupConstraints = false
    
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
        
        contentView.addSubview(placeImageView)
        contentView.addSubview(publicNameLabel)
        contentView.addSubview(distanceIcon)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(typeLabel)
        contentView.addSubview(peopleLabel)
        contentView.addSubview(peopleIcon)
        
        self.updateConstraints()
        
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
    
    
    override func updateConstraints() {
        
        if !didSetupConstraints {
            
            placeImageView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(contentView)
                make.height.equalTo(contentView.snp.height).multipliedBy(0.5)
                make.centerX.equalTo(contentView)
                make.top.equalTo(contentView)
            }
            
            typeLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(placeImageView.snp.width).multipliedBy(0.65)
                make.left.equalTo(placeImageView.snp.left).offset(10)
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
            
            didSetupConstraints = true
        }
        super.updateConstraints()
    }
}

extension UIView {
    
    func addShadow(offset: CGSize, color: UIColor, radius: CGFloat, opacity: Float) {
        let layer = self.layer
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        //Optional, to improve performance:
        layer.shadowPath = UIBezierPath(rect: layer.bounds).cgPath
        layer.shouldRasterize = true
        
        let backgroundCGColor = self.backgroundColor?.cgColor
        self.backgroundColor = nil
        layer.backgroundColor =  backgroundCGColor
    }
}

