//
//  PlaceViewController.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-31.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit

class PlaceViewController: UIViewController {
    
    private var didSetupConstraints = false
    
    private var collectionView = NearbyPlacesUICollectionView()
    
    var nearbyPlaces = [[NearbyPlace]]()
    var selectedIndex: IndexPath!
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        view.layoutIfNeeded()
        
        view.addSubview(collectionView)
        
        self.collectionView.reloadData()
        
        view.setNeedsUpdateConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let maskLayer = CAShapeLayer()
        
        let path = UIBezierPath(roundedRect:self.collectionView.bounds,
                                byRoundingCorners:[.topLeft, .topRight],
                                cornerRadii: CGSize(width: 5, height:  5 ))
        
        maskLayer.path = path.cgPath
        collectionView.layer.mask = maskLayer
    }
    
    override func updateViewConstraints() {
        
        if !didSetupConstraints {
            
            collectionView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view.snp.width)
                make.height.equalTo(view.snp.height).multipliedBy(0.98)
                make.center.equalTo(view.snp.center)
            }
            
            didSetupConstraints = true
        }
        
        super.updateViewConstraints()
    }
}

extension PlaceViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearbyPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "nearbyPlaceCell", for: indexPath) as? PlaceCollectionViewCell)!
        cell.publicNameLabel.text = nearbyPlaces[indexPath.section][indexPath.row].name
        
        return cell
    }
    
    
}

