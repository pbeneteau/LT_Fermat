//
//  NearbyPlacesViewController.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-31.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import UIKit
import CoreLocation
import ViewAnimator

class NearbyPlacesViewController: UIViewController {
    
    // Top Menu
    private var menuContainerView = UIView()
    private let menuLabel = UILabel()
    
    private var filters: [String] = ["BAR", "PARC", "RESTAURANT", "CLUB", "MUSEUM", "THEATRE"]
    
    lazy var filterCollectionView: UICollectionView = {
        let cV = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: FilterLayout())
        cV.backgroundColor = .clear
        cV.showsVerticalScrollIndicator = false
        cV.showsHorizontalScrollIndicator = false
        cV.dataSource = self
        cV.delegate = self
        cV.allowsMultipleSelection = true
        cV.register(NearbyPlacesFilterCollectionViewCell.self, forCellWithReuseIdentifier: "FilterCell")
        return cV
    }()
    
    private var filterMenuAlphaEffectView = HorizontalGradientView()
    
    private var nearbyPlacesCollectionView = NearbyPlacesUICollectionView()
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    private var nearbyPlaces = [[NearbyPlace]]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        menuContainerView.roundCorners(corners: [.bottomLeft], radius: 25)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Color.viewControllerBackground
        menuContainerView.backgroundColor = Color.menuContainerView
        
        menuLabel.font = LTFont.Menu.title
        menuLabel.text = "Nearby Places"
        
        nearbyPlacesCollectionView.dataSource = self
        nearbyPlacesCollectionView.delegate = self
        
        filterMenuAlphaEffectView.setGradientColors(leftColor: .white, rightColor: UIColor(white: 1, alpha: 0))
        
        view.addSubview(menuContainerView)
        view.addSubview(nearbyPlacesCollectionView)
        
        menuContainerView.addSubview(menuLabel)
        menuContainerView.addSubview(filterCollectionView)
        menuContainerView.addSubview(filterMenuAlphaEffectView)
        
        nearbyPlaces.append([NearbyPlace]())
        nearbyPlaces.append([NearbyPlace]())
        nearbyPlaces.append([NearbyPlace]())
        
        view.setNeedsUpdateConstraints()
        
        addNotificationsObserver()
    }
    
    
    @objc func didUpdateLocation(_ notification: NSNotification) {
        getPlaces()
    }
    
    func appendPlaceToNearbyPlaces(place: NearbyPlace) {
        
        let distance = place.distance
        nearbyPlaces.removeAll()
        
        nearbyPlaces.append([NearbyPlace]())
        nearbyPlaces.append([NearbyPlace]())
        nearbyPlaces.append([NearbyPlace]())
        
        if distance <= 100 {
            nearbyPlaces[0].append(place)
            nearbyPlaces[0] = nearbyPlaces[0].sorted(by: { $0.distance < $1.distance })
        } else if distance > 100 && distance <= 1000 {
            nearbyPlaces[1].append(place)
            nearbyPlaces[1] = nearbyPlaces[1].sorted(by: { $0.distance < $1.distance })
        } else {
            nearbyPlaces[2].append(place)
            nearbyPlaces[2] = nearbyPlaces[2].sorted(by: { $0.distance < $1.distance })
        }
    }
    
    
    func getPlaces() {
        
        for _ in 0..<6 {
            self.nearbyPlaces[0].append(
                NearbyPlace(ID: "place.placeID",
                            name: "place.name",
                            status: 1,
                            description: "place.description",
                            distance: 0,
                            category: "place.types.first",
                            city: "",
                            price: 2,
                            averageRating: 3,
                            image: UIImage(named: "barPic")!))
        }
        
        for _ in 0..<3 {
            self.nearbyPlaces[1].append(
                NearbyPlace(ID: "place.placeID",
                            name: "place.name",
                            status: 1,
                            description: "place.description",
                            distance: 0,
                            category: "place.types.first",
                            city: "",
                            price: 2,
                            averageRating: 3,
                            image: UIImage(named: "barPic")!))
        }
        
        for _ in 0..<10 {
            self.nearbyPlaces[2].append(
                NearbyPlace(ID: "place.placeID",
                            name: "place.name",
                            status: 1,
                            description: "place.description",
                            distance: 0,
                            category: "place.types.first",
                            city: "",
                            price: 2,
                            averageRating: 3,
                            image: UIImage(named: "barPic")!))
        }
        
        self.nearbyPlacesCollectionView.reloadData()
        UIView.animate(views: self.nearbyPlacesCollectionView.visibleCells, animations: self.animations, completion: nil)
        
        return
        
        let asyncOperation = AsyncOperation(numberOfSimultaneousActions: 20, dispatchQueueLabel: "fetchingNearbyPlacesInfo")
        asyncOperation.whenCompleteAll = {
            self.nearbyPlacesCollectionView.reloadData()
            UIView.animate(views: self.nearbyPlacesCollectionView.visibleCells, animations: self.animations, completion: {
            })
        }
        
        LocationService.shared.getCurrentGMSPlaceLikelihoodList { likelihoods in
            
            guard let likelihoods = likelihoods else { print("[Error] while retrieving likelihoods"); return }
            var i = 0
            
            for likelihood in likelihoods {
                
                asyncOperation.run { completeClosure in
                    
                    i += 1
                    let place = likelihood.place
                    
                    guard let placeID = place.placeID else { return }
                    
                    LocationService.shared.loadFirstPhotoForPlace(placeID: placeID) { photo in
                        
                        guard let photo = photo else { completeClosure(); return }
                        
                        for _ in 0..<20 {
                            self.appendPlaceToNearbyPlaces(place:
                                NearbyPlace(ID: placeID,
                                            name: place.name ?? "",
                                            status: place.openNowStatus.rawValue,
                                            description: place.description,
                                            distance: 0,
                                            category: place.types?.first ?? "",
                                            city: "", price: place.priceLevel.rawValue,
                                            averageRating: place.rating,
                                            image: photo))
                        }
                        completeClosure()
                    }
                }
            }
        }
    }
    
}

// MARK: Collection View Delegate and Datasource
extension NearbyPlacesViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == nearbyPlacesCollectionView {
            return nearbyPlaces.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == nearbyPlacesCollectionView {
            return nearbyPlaces[section].count
        } else {
            return filters.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == nearbyPlacesCollectionView {
            let cell: NearbyPlacesUICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "nearbyPlaceCell", for: indexPath) as? NearbyPlacesUICollectionViewCell
            return cell!
        } else {
            let cell: NearbyPlacesFilterCollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCell", for: indexPath) as? NearbyPlacesFilterCollectionViewCell
            return cell!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == nearbyPlacesCollectionView {
            if let cell = cell as? NearbyPlacesUICollectionViewCell {
                _configureNearbyPlacesCell(cell, atIndexPath: indexPath)
            }
        } else {
            if let cell = cell as? NearbyPlacesFilterCollectionViewCell {
                _configureFilterCell(cell, atIndexPath: indexPath)
            }
        }
    }
    
    fileprivate func _configureNearbyPlacesCell(_ cell: NearbyPlacesUICollectionViewCell, atIndexPath indexPath: IndexPath) {
        
        cell.queue.cancelAllOperations()
        
        let operation: BlockOperation = BlockOperation()
        operation.addExecutionBlock { [weak operation] () -> Void in
            
            DispatchQueue.main.sync(execute: { [weak operation] () -> Void in
                
                if let operation = operation, operation.isCancelled { return }
                
                cell.publicNameLabel.text = self.nearbyPlaces[indexPath.section][indexPath.row].name
                
                let distance = self.nearbyPlaces[indexPath.section][indexPath.row].distance
                cell.distanceLabel.text = "\(String(describing: distance))m"
                
                cell.typeLabel.text = self.nearbyPlaces[indexPath.section][indexPath.row].category
                cell.placeImageView.image = self.nearbyPlaces[indexPath.section][indexPath.row].image
                cell.peopleLabel.text = "4"
                
                cell.backgroundColor = .clear
            })
        }
        
        cell.queue.addOperation(operation)
    }
    
    fileprivate func _configureFilterCell(_ cell: NearbyPlacesFilterCollectionViewCell, atIndexPath indexPath: IndexPath) {
        
        cell.queue.cancelAllOperations()
        
        let operation: BlockOperation = BlockOperation()
        operation.addExecutionBlock { [weak operation] () -> Void in
            
            DispatchQueue.main.sync(execute: { [weak operation] () -> Void in
                
                if let operation = operation, operation.isCancelled { return }
                
                cell.label.text = self.filters[indexPath.row]
            })
        }
        cell.queue.addOperation(operation)
    }
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == nearbyPlacesCollectionView {
            switch kind {
                
            case UICollectionView.elementKindSectionHeader:
                
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "NearbyPlaceHeader_\(indexPath.section)", for: indexPath) as! NearbyPlacesHeaderCollectionReusableView
                
                if nearbyPlaces[indexPath.section].count == 0 {
                    headerView.hide()
                    return headerView
                }
                
                let _ = ["Moins de 100m", "Moins de 1km", "Plus de 1km"]
                
                return headerView
                
            default:
                assert(false, "Unexpected element kind")
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == nearbyPlacesCollectionView {
        if nearbyPlaces[section].count == 0 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 30)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == nearbyPlacesCollectionView {
            return CGSize(width: UIScreen.main.bounds.width, height: 80*3)
        } else {
            let width = filters[indexPath.row].width(withConstrainedHeight: filterCollectionView.frame.height, font: LTFont.NearbyPlaces.FilterCollectionView.label!) + 20
            return CGSize(width: width, height: filterCollectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = filterCollectionView.cellForItem(at: indexPath) as? NearbyPlacesFilterCollectionViewCell {
            cell.contentView.backgroundColor = Color.NearbyPlaces.FilterCollectionView.Background.selected
            cell.label.textColor = Color.NearbyPlaces.FilterCollectionView.Label.selected
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = filterCollectionView.cellForItem(at: indexPath) as? NearbyPlacesFilterCollectionViewCell {
            cell.contentView.backgroundColor = Color.NearbyPlaces.FilterCollectionView.Background.normal
            cell.label.textColor = Color.NearbyPlaces.FilterCollectionView.Label.normal
        }
    }
    
}

// MARK: Segues
extension NearbyPlacesViewController {
    
}

// MARK: Notifications
extension NearbyPlacesViewController {
    
    func addNotificationsObserver() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didUpdateLocation(_:)), name: Notification.Name(rawValue:"didUpdateLocation"), object: nil)
    }
}

// MARK: Constraints
extension NearbyPlacesViewController {
    
    override func updateViewConstraints() {
        
        menuContainerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.2)
            make.centerX.equalTo(view)
            make.top.equalTo(view)
        }
        
        menuLabel.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(menuContainerView).multipliedBy(0.7)
            make.height.equalTo(30)
            make.left.equalTo(25)
            make.top.equalTo(menuContainerView).offset(65)
        }
        
        filterCollectionView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(menuContainerView).offset(-25)
            make.height.equalTo(40)
            make.left.equalTo(25)
            make.bottom.equalTo(menuContainerView).offset(-10)
        }
        
        filterMenuAlphaEffectView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(menuContainerView).multipliedBy(0.1)
            make.height.equalTo(filterCollectionView)
            make.right.equalTo(filterCollectionView)
            make.centerY.equalTo(filterCollectionView)
        }
        
        nearbyPlacesCollectionView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.height.equalTo(view).multipliedBy(0.8)
            make.centerX.equalTo(view)
            make.bottom.equalTo(view)
        }
        super.updateViewConstraints()
    }
}


extension String {
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
