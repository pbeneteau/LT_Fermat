//
//  NearbyPlacesUICollectionView.swift
//  LTios
//
//  Created by Paul Bénéteau on 08/10/2017.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class NearbyPlacesUICollectionView: UICollectionView {
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)!
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 80*3)
    super.init(frame: CGRect(), collectionViewLayout: layout)
    commonInit()
  }
  
  func commonInit() {
    
    allowsMultipleSelection = false
    backgroundColor = .clear
    bounces = false

    frame = UIScreen.main.bounds
    
    self.register(NearbyPlacesUICollectionViewCell.self, forCellWithReuseIdentifier: "nearbyPlaceCell")
    
    register(NearbyPlacesHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NearbyPlaceHeader_0")
    register(NearbyPlacesHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NearbyPlaceHeader_1")
    register(NearbyPlacesHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "NearbyPlaceHeader_2")
  }
}

