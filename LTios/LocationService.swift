//
//  Location.swift
//  LT_Contacts_Manager
//
//  Created by Paul Bénéteau on 26/07/2018.
//  Copyright © 2018 Paul Bénéteau. All rights reserved.
//

import CoreLocation
import GooglePlaces
import Firebase

class LocationService: NSObject, CLLocationManagerDelegate {
    
    public static var shared = LocationService()
    
    private let googleApiKey = "AIzaSyC6HXD576iBNzxAXG7CeUmvSeEzO_qzreM"
    
    let locationManager: CLLocationManager
    private var locationDataArray: [CLLocation]
    private var useFilter: Bool
    
    private let horizontalAccuracy: Double = 200
    
    override init() {
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 5
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationDataArray = [CLLocation]()
        
        useFilter = true
        
        super.init()
        
        locationManager.delegate = self
    }
    
    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        } else {
            //tell view controllers to show an alert
            showTurnOnLocationServiceAlert()
        }
    }
    
    // Filters for location update
    private func filterAndAddLocation(_ location: CLLocation) -> Bool {
        let age = -location.timestamp.timeIntervalSinceNow
        
        if age > 10 {
            return false
        }
        
        if location.horizontalAccuracy < 0 {
            return false
        }
        
        if location.horizontalAccuracy > horizontalAccuracy {
            return false
        }
        
        locationManager.stopUpdatingLocation()
        
        lookUpCurrentLocation(lastLocation: GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) { place in
            guard let place = place else { return }
            mainUserInstance.place = place
        }
        locationDataArray.append(location)
        
        return true
    }
//
    // Get address/place from location
    func lookUpCurrentLocation(lastLocation: GeoPoint, completionHandler: @escaping (CLPlacemark?) -> Void ) {

        let geocoder = CLGeocoder()

        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(CLLocation(latitude: lastLocation.latitude, longitude: lastLocation.longitude), completionHandler: { (placemarks, error) in
            if error == nil {
                guard let firstLocation = placemarks?.first else {
                    completionHandler(nil)
                    return
                }
                completionHandler(firstLocation)
            } else {
                // An error occurred during geocoding.
                completionHandler(nil)
            }
        })
    }
//
    // Distance between 2 locations
    func getDistanceBetweenLocations(location1: CLLocation, location2: CLLocation) -> Int{
        return Int(location1.distance(from: location2).rounded()) // result is in meters
    }
    
}

// MARK: Google Maps/Places SDK
extension LocationService {
    
    func getCurrentGMSPlaceLikelihoodList(completion: @escaping ([GMSPlaceLikelihood]?) -> Void) {
        
        var placesClient: GMSPlacesClient?
        placesClient = GMSPlacesClient.shared()
        
        placesClient?.currentPlace(callback: { (places, error) in
            if let error = error {
                print("[Error] Pick Place \(error.localizedDescription)")
                completion(nil)
                return
            }
            if let placesLikelihoodList = places?.likelihoods {
                completion(placesLikelihoodList)
            } else {
                completion(nil)
            }
        })
    }
    
    func loadFirstPhotoForPlace(placeID: String, completion: @escaping(UIImage?) -> Void) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("[Error] \(error.localizedDescription)")
                completion(nil)
                return
            } else {
                if let firstPhoto = photos?.results.first {
                    self.loadImageForMetadata(photoMetadata: firstPhoto) { photo in
                        guard let photo = photo else { completion(nil); return }
                        completion(photo)
                    }
                } else { completion(nil) }
            }
        }
    }
    
    private func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata, completion: @escaping(UIImage?) -> Void) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("[Error] \(error.localizedDescription)")
                completion(nil)
            } else {
                completion(photo)
            }
        })
    }
}

// MARK: CLLocationManagerDelegate protocol methods
extension LocationService {
    
    internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            if let newLocation = locations.last {
                
                var locationAdded: Bool
                if useFilter {
                    locationAdded = filterAndAddLocation(newLocation)
                } else {
                    locationAdded = true
                }
                if locationAdded {
                    //locationManager.stopUpdatingLocation()
                }
            }
        } else {
            // tell view controllers to show an alert
            showTurnOnLocationServiceAlert()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[Error] Failed to find user's location: \(error.localizedDescription)")
        showTurnOnLocationServiceAlert()
    }
    
    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    
}


// MARK: Notifications
extension LocationService {
    
    private func showTurnOnLocationServiceAlert() {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"showTurnOnLocationServiceAlert"), object: nil)
    }
}
