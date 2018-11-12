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

class NearbyPlacesViewController: ModalViewViewController {
    
    private var didSetupConstraints = false
    private var containerView = UIView()
    private var collectionView = NearbyPlacesUICollectionView()
    
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]
    
    private var nearbyPlaces = [[NearbyPlace]]()
    
    private var distanceFilterContainer = RoundShadowView()
    private var hundredMettersLabel = UILabel()
    private var fiveHundredMettersLabel = UILabel()
    private var ThousandLabel = UILabel()
    private var distanceLineContainer = UIView()
    private var distanceLine = UIProgressView()
    private var currentSection = 0
    private var distanceFilterContainerTimer: TimeInterval = 0
    
    var menuShadowBackground = GradientView()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        containerView.roundCorners(corners: [.topLeft , .topRight], radius: 10)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .clear
        
        menuShadowBackground.alpha = 0.4
        menuShadowBackground.setGradientColors(topColor: .clear, botColor: .black)
        
        containerView.backgroundColor = Color.viewControllerBackground
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        distanceFilterContainer.backgroundColor = .white
        distanceFilterContainer.alpha = 0
        
        hundredMettersLabel.textAlignment = .center
        hundredMettersLabel.text = "100m"
        hundredMettersLabel.font = UIFont(name: "Roboto-Medium", size: 35)
        hundredMettersLabel.textColor = Color.NearbyPlaces.Distance.Label.selected
        
        fiveHundredMettersLabel.textAlignment = .center
        fiveHundredMettersLabel.text = "500m"
        fiveHundredMettersLabel.font = UIFont(name: "Roboto-Medium", size: 21)
        fiveHundredMettersLabel.textColor = Color.NearbyPlaces.Distance.Label.normal
        
        ThousandLabel.textAlignment = .center
        ThousandLabel.text = "1000m"
        ThousandLabel.font = UIFont(name: "Roboto-Medium", size: 21)
        ThousandLabel.textColor = Color.NearbyPlaces.Distance.Label.normal
        
        distanceLineContainer.alpha = 1
        
        distanceLine.progress = 0.0015
        distanceLine.progressTintColor = Color.NearbyPlaces.Distance.ProgressView.progress
        distanceLine.trackTintColor = Color.NearbyPlaces.Distance.ProgressView.background
        
        view.addSubview(containerView)
        
        containerView.addSubview(collectionView)
        containerView.addSubview(menuShadowBackground)
        containerView.addSubview(distanceFilterContainer)
        
        distanceFilterContainer.addSubview(hundredMettersLabel)
        distanceFilterContainer.addSubview(fiveHundredMettersLabel)
        distanceFilterContainer.addSubview(ThousandLabel)
        
        distanceLineContainer.addSubview(distanceLine)
        distanceFilterContainer.addSubview(distanceLineContainer)
        
        nearbyPlaces.append([NearbyPlace]())
        nearbyPlaces.append([NearbyPlace]())
        nearbyPlaces.append([NearbyPlace]())
        
        addNotificationsObserver()
        
        view.setNeedsUpdateConstraints()
        
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
        
        self.collectionView.reloadData()
        UIView.animate(views: self.collectionView.visibleCells, animations: self.animations, completion: nil)
        
        return
        
        let asyncOperation = AsyncOperation(numberOfSimultaneousActions: 20, dispatchQueueLabel: "fetchingNearbyPlacesInfo")
        asyncOperation.whenCompleteAll = {
            self.collectionView.reloadData()
            UIView.animate(views: self.collectionView.visibleCells, animations: self.animations, completion: {
            })
        }
        
        LocationService.shared.getCurrentGMSPlaceLikelihoodList { likelihoods in
            
            guard let likelihoods = likelihoods else { print("[Error] while retrieving likelihoods"); return }
            var i = 0
            
            for likelihood in likelihoods {
                
                asyncOperation.run { completeClosure in
                    
                    i += 1
                    let place = likelihood.place
                    
                    LocationService.shared.loadFirstPhotoForPlace(placeID: place.placeID) { photo in
                        
                        guard let photo = photo else { completeClosure(); return }
                        
                        for _ in 0..<20 {
                            self.appendPlaceToNearbyPlaces(place:
                                NearbyPlace(ID: place.placeID,
                                            name: place.name,
                                            status: place.openNowStatus.rawValue,
                                            description: place.description,
                                            distance: 0,
                                            category: place.types.first ?? "",
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
        return nearbyPlaces.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nearbyPlaces[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: NearbyPlacesUICollectionViewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "nearbyPlaceCell", for: indexPath) as? NearbyPlacesUICollectionViewCell
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if let cell = cell as? NearbyPlacesUICollectionViewCell {
            _configureCell(cell, atIndexPath: indexPath)
        }
    }
    
    fileprivate func _configureCell(_ cell: NearbyPlacesUICollectionViewCell, atIndexPath indexPath: IndexPath) {
        
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
    
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
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
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        if nearbyPlaces[section].count == 0 {
            return CGSize(width: 0, height: 0)
        }
        return CGSize(width: UIScreen.main.bounds.width, height: 30)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let currentSection = currentDistanceSection(scrollView: scrollView)
        setCurrentDistanceSection(section: currentSection)
        
        let rowsNumber = nearbyPlaces[0].count + nearbyPlaces[1].count + nearbyPlaces[2].count
        
        let firstSectionOffset = maxContentOffset(scrollView: scrollView) * Float(nearbyPlaces[0].count) / Float(rowsNumber)
        let secondSectionOffset = maxContentOffset(scrollView: scrollView) * Float(nearbyPlaces[1].count) / Float(rowsNumber)
        let thirdSectionOffset = maxContentOffset(scrollView: scrollView) * Float(nearbyPlaces[2].count) / Float(rowsNumber)
        
        var progress: Float = 0
        
        if currentSection == 0 {
            progress = (Float(scrollView.contentOffset.y) / firstSectionOffset)
        } else if currentSection == 1 {
            progress = (Float(scrollView.contentOffset.y) - firstSectionOffset) / secondSectionOffset
        } else {
            progress = (Float(scrollView.contentOffset.y) - firstSectionOffset - secondSectionOffset) / thirdSectionOffset
        }
        
        distanceLine.progress = progress
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hideDistanceFilterView()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        displayDistanceFilterView()
    }
    
    
    
    private func displayDistanceFilterView() {
        
        if MenuInstance.homeMenuButton.alpha != 0 {
            
            MenuInstance.hideMenu { end in
                
                self.distanceFilterContainer.layer.removeAllAnimations()
                
                UIView.animate(withDuration: 0.3, delay: 0.3, options: [.beginFromCurrentState, .curveEaseOut], animations: {
                    self.distanceFilterContainer.alpha = 1
                })
            }
        }
    }
    private func hideDistanceFilterView() {
        
        self.distanceFilterContainer.layer.removeAllAnimations()
        
        UIView.animate(withDuration: 0.4, delay: 2, options: [.beginFromCurrentState, .curveEaseOut], animations: {
            self.distanceFilterContainer.alpha = 0
            
        }, completion: { end in
            
            if MenuInstance.homeMenuButton.alpha != 1 {
                MenuInstance.showMenu()
            }
        })
    }
    
    func maxContentOffset(scrollView: UIScrollView) -> Float {
        return Float(scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
    }
    
    func currentDistanceSection(scrollView: UIScrollView) -> Int {
        
        let rowsNumber = nearbyPlaces[0].count + nearbyPlaces[1].count + nearbyPlaces[2].count
        
        let firstSection = Float(nearbyPlaces[0].count) / Float(rowsNumber)
        let secondSection = Float(nearbyPlaces[1].count) / Float(rowsNumber)
        
        let maxOffset = maxContentOffset(scrollView: scrollView)
        
        if (Float(scrollView.contentOffset.y) < firstSection * maxOffset) {
            return 0
        } else if (Float(scrollView.contentOffset.y) < (firstSection + secondSection) * maxOffset) {
            return 1
        } else {
            return 2
        }
    }
    
    func setCurrentDistanceSection(section: Int) {
        
        if section == 0 && self.currentSection != 0 {
            self.hundredMettersLabel.textColor = Color.NearbyPlaces.Distance.Label.selected
            self.fiveHundredMettersLabel.textColor = Color.NearbyPlaces.Distance.Label.normal
            
            self.hundredMettersLabel.animate(fontSize: 35, duration: 0.2, animateAnchorPoint: LabelAnimateAnchorPoint.centerXCenterY)
            self.fiveHundredMettersLabel.animate(fontSize: 21, duration: 0.2, animateAnchorPoint: LabelAnimateAnchorPoint.centerXCenterY)
            
            distanceLine.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(95)
                make.height.equalTo(3)
                make.centerX.equalTo(distanceLineContainer).multipliedBy(0.4)
                make.top.equalTo(distanceLineContainer)
            }
            self.currentSection = section
            
        } else if section == 1 && self.currentSection != 1 {
            
            self.fiveHundredMettersLabel.textColor = Color.NearbyPlaces.Distance.Label.selected
            self.hundredMettersLabel.textColor = Color.NearbyPlaces.Distance.Label.normal
            self.ThousandLabel.textColor = Color.NearbyPlaces.Distance.Label.normal
            
            self.fiveHundredMettersLabel.animate(fontSize: 35, duration: 0.2, animateAnchorPoint: LabelAnimateAnchorPoint.centerXCenterY)
            self.hundredMettersLabel.animate(fontSize: 21, duration: 0.2, animateAnchorPoint: LabelAnimateAnchorPoint.centerXCenterY)
            self.ThousandLabel.animate(fontSize: 21, duration: 0.2, animateAnchorPoint: LabelAnimateAnchorPoint.centerXCenterY)
            
            distanceLine.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(95)
                make.height.equalTo(3)
                make.centerX.equalTo(distanceLineContainer)
                make.top.equalTo(distanceLineContainer)
            }
            self.currentSection = section
            
        } else if section == 2 && self.currentSection != 2 {
            self.ThousandLabel.textColor = Color.NearbyPlaces.Distance.Label.selected
            self.fiveHundredMettersLabel.textColor = Color.NearbyPlaces.Distance.Label.normal
            
            self.ThousandLabel.animate(fontSize: 35, duration: 0.2, animateAnchorPoint: LabelAnimateAnchorPoint.centerXCenterY)
            self.fiveHundredMettersLabel.animate(fontSize: 21, duration: 0.2, animateAnchorPoint: LabelAnimateAnchorPoint.centerXCenterY)
            
            distanceLine.snp.remakeConstraints { (make) -> Void in
                make.width.equalTo(95)
                make.height.equalTo(3)
                make.centerX.equalTo(distanceLineContainer).multipliedBy(1.6)
                make.top.equalTo(distanceLineContainer)
            }
            self.currentSection = section
        }
        
        UIView.animate(withDuration: TimeInterval(0.2), animations: {
            self.distanceLineContainer.layoutIfNeeded()
        })
        
        
    }
    
    
}

// MARK: Segues
extension NearbyPlacesViewController {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let placeVC = PlaceViewController()
        placeVC.selectedIndex = indexPath
        
        //show(placeVC, sender: nil)
    }
    
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
        
        if !didSetupConstraints {
            
            containerView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view)
                make.height.equalTo(view).multipliedBy(0.9)
                make.centerX.equalTo(view)
                make.bottom.equalTo(view)
            }
            
            collectionView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(containerView)
                make.height.equalTo(containerView)
                make.centerX.equalTo(containerView)
                make.bottom.equalTo(containerView)
            }
            
            menuShadowBackground.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(containerView).multipliedBy(0.1)
                make.width.equalTo(containerView)
                make.centerX.equalTo(containerView)
                make.bottom.equalTo(containerView)
            }
            
            distanceFilterContainer.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(view).multipliedBy(0.92)
                make.height.equalTo(view).multipliedBy(0.08)
                make.centerX.equalTo(view)
                make.bottom.equalTo(view).offset(-30)
            }
            
            fiveHundredMettersLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(95)
                make.height.equalTo(35)
                make.centerX.equalTo(distanceFilterContainer)
                make.bottom.equalTo(distanceFilterContainer.snp.bottom).offset(-15)
            }
            
            hundredMettersLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(95)
                make.height.equalTo(35)
                make.centerX.equalTo(fiveHundredMettersLabel.snp.centerX).multipliedBy(0.4)
                make.bottom.equalTo(fiveHundredMettersLabel)
            }
            
            ThousandLabel.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(95)
                make.height.equalTo(35)
                make.centerX.equalTo(fiveHundredMettersLabel.snp.centerX).multipliedBy(1.6)
                make.bottom.equalTo(fiveHundredMettersLabel)
            }
            
            distanceLineContainer.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(distanceFilterContainer)
                make.height.equalTo(3)
                make.centerX.equalTo(distanceFilterContainer)
                make.bottom.equalTo(distanceFilterContainer).offset(-10)
            }
            
            distanceLine.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(95)
                make.height.equalTo(3)
                make.centerX.equalTo(distanceLineContainer).multipliedBy(0.4)
                make.top.equalTo(distanceLineContainer)
            }
            
            didSetupConstraints = true
        }
        super.updateViewConstraints()
    }
}

struct LabelAnimateAnchorPoint {
    
    static let leadingCenterY         = CGPoint.init(x: 0, y: 0.5)
    static let trailingCenterY        = CGPoint.init(x: 1, y: 0.5)
    static let centerXCenterY         = CGPoint.init(x: 0.5, y: 0.5)
    static let leadingTop             = CGPoint.init(x: 0, y: 0)
}

extension UILabel {
    
    func animate(fontSize: CGFloat, duration: TimeInterval, animateAnchorPoint: CGPoint) {
        let startTransform = transform
        let oldFrame = frame
        var newFrame = oldFrame
        let archorPoint = layer.anchorPoint
        let scaleRatio = fontSize / font.pointSize
        
        layer.anchorPoint = animateAnchorPoint
        
        newFrame.size.width *= scaleRatio
        newFrame.size.height *= scaleRatio
        newFrame.origin.x = oldFrame.origin.x - (newFrame.size.width - oldFrame.size.width) * animateAnchorPoint.x
        newFrame.origin.y = oldFrame.origin.y - (newFrame.size.height - oldFrame.size.height) * animateAnchorPoint.y
        frame = newFrame
        
        font = font.withSize(fontSize)
        
        transform = CGAffineTransform.init(scaleX: 1 / scaleRatio, y: 1 / scaleRatio);
        layoutIfNeeded()
        
        UIView.animate(withDuration: duration, animations: {
            self.transform = startTransform
            newFrame = self.frame
        }) { (Bool) in
            self.layer.anchorPoint = archorPoint
            self.frame = newFrame
        }
    }
}



