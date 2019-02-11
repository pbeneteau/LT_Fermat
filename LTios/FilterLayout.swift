//
//  filterLayout.swift
//  LTios
//
//  Created by Paul Bénéteau on 31/01/2019.
//  Copyright © 2019 Tastyapp. All rights reserved.
//

import UIKit

class FilterLayout: UICollectionViewFlowLayout {
        
    override init() {
        super.init()
        scrollDirection = .horizontal
        minimumInteritemSpacing = 5
        minimumLineSpacing = 5
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
    }
    
    required init?(coder aDecoder: NSCoder) {
        //fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}
