//
//  User.swift
//  LTios
//
//  Created by antoine beneteau on 2017-07-20.
//  Copyright © 2017 Tastyapp. All rights reserved.
//

import Firebase
import FirebaseAuth
import CoreLocation
import FirebaseFirestore

var mainUserInstance: MainUser!

class MainUser: GlobalUser {
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    private var FIRUser = Auth.auth().currentUser!
    
    var mailAddress: String?
    
    var address: Address?
    
    var location: GeoPoint? {
        didSet {
            notifyDidUpdateLocation()
        }
    }
    
    var place: CLPlacemark? {
        willSet(newPlace) {
            guard let newLocation = newPlace?.location, let lastLocation = self.place?.location else { return }
            if newLocation.horizontalAccuracy <= lastLocation.horizontalAccuracy {
                return
            }
        }
        didSet {
            updateUserLocation(place: place!)
        }
    }
    
    override var photo: UIImage? {
        didSet {
            uploadPhoto()
        }
    }
    
    var settings: UserSettings!
    
    override init() {
        super.init()
        
        // Start menu loading animation
        
        // Firebase login
        authHandle = Auth.auth().addStateDidChangeListener() { (auth, user) in

            if let user = user {
                print("User logged in: \(user.uid)")
                self.uid = user.uid
                DatabaseService.shared.makeUserOnline() // make user state as online in database
                DatabaseService.shared.setOnDisconnectHandler() // init on disconnect handler
                self.getMainInformation(uid: user.uid) // init main user datas and start fetching location
                self.mailAddress = user.email ?? "" // get mail address from firebase auth
            }
        }
    }
    
    // init main user datas and start fetching location
    private func getMainInformation(uid: String) {
        
        // Fetch user data from database
        DatabaseService.shared.getUserInformation(uid: uid) { doc in
            
            guard let information = doc else { print("[Error] while unwrapping main user information"); return }
            self.initMainInformation(document: information) // init local app user information from fetched data
            
            UserSettings.updateAppSettingsFromCode("bgLocation", state: self.settings.getStateFromCode("bgLocation"))
            
            if self.contacts != nil && !self.settings.getStateFromCode("ghost") {
                
                // Start nearby location people scan
                LocationService.shared.startUpdatingLocation()
                
                // Start nearby bluetooth devices scan
                BluetoothServices.shared.updateAdvertisingData()
            }
        }
    }
    
    // Get all user information from Firebase database
    private func initMainInformation(document: DocumentSnapshot) {
        
        guard let data = document.data() else {
            print("[Error] Missing user information during initialization.")
            return
        }
        
        self.uid = document.documentID
        self.publicName = (data["publicName"] as? String)!
        self.pushID = (data["pushID"] as? String)!
        
        if let contacts = data["contacts"] as? [String : String] {
            self.contacts = contacts
        } else {
            ContactsService.shared.updateContacts()
        }
        
        let name = data["name"] as? [String:String]
        self.firstName = (name!["firstName"])!
        self.lastName = (name!["lastName"])!
        
        if let settings = data["settings"] as? [String : [String: Bool]] {
            self.settings = UserSettings(userSettings: settings)
        } else {
            print("[Error] unwrapping user settings")
        }
        
        saveBasicInformation() // save basic information to user default
        notifyDidUpdateUserInformation() // notify the whole app that user has been initiated
    }
    
    // Update user location information from current location place
    private func updateUserLocation(place: CLPlacemark) {
        
        if let location = place.location,
            let iso = place.isoCountryCode,
            let state = place.administrativeArea,
            let country = place.country,
            let city = place.locality,
            let postalCode = place.postalCode {
            
            self.address = Address(country: country, ISO: iso, city: city, state: state, postalCode: postalCode)
            self.location = GeoPoint(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            
            DatabaseService.shared.updateUserDatabaseLocation()
        } else {
            print("[Error] unwrapping values to update location")
        }
    }
    
    private func uploadPhoto() {
        if let image = photo {
            guard let imageData = image.jpegData(compressionQuality: 1) else { return }
            StorageService.shared.uploadUserPicture(imageData: imageData, uid: uid)
        }
    }
    
    private func saveBasicInformation() {
        
        // Setting
        let defaults = UserDefaults.standard
        defaults.set("publicName", forKey: publicName)
        defaults.set("firstName", forKey: fullName)
        defaults.set("lsatName", forKey: fullName)
        defaults.set("pushID", forKey: pushID)
    }
    
    func notifyDidUpdateLocation() {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateLocation"), object: nil, userInfo: nil)
    }
    
    func notifyDidUpdateUserInformation() {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateUserInformation"), object: nil, userInfo: nil)
    }
}


struct Address {
    var country: String
    var ISO: String
    var city: String
    var state: String
    var postalCode: String
}

func ==(lhs: Address, rhs: Address) -> Bool {
    return lhs.country == rhs.country
        && lhs.ISO == rhs.ISO
        && lhs.city == rhs.city
        && lhs.state == rhs.state
        && lhs.postalCode == rhs.postalCode
}
