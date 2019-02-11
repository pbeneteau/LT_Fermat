//
//  DatabaseService.swift
//  LT_Contacts_Manager
//
//  Created by Paul Bénéteau on 30/07/2018.
//  Copyright © 2018 Paul Bénéteau. All rights reserved.
//

import CoreLocation
import FirebaseFirestore
import FirebaseDatabase

// MARK: Firebase database related queries
class DatabaseService {
    
    public static var shared = DatabaseService()
    
    private var nearbyUserListener: ListenerRegistration!
    private var userNotificationListener: ListenerRegistration!
    
    private let db: Firestore!
    private let settings: FirestoreSettings!
    
    init() {
        
        db = Firestore.firestore()
        
        settings = db.settings
        db.settings = settings
    }
    
    deinit {
        stopListeningForNearbyUsers()
    }
}

extension DatabaseService {
    
    func makeUserOnline() {
        
        let userStatusDatabaseRef = Database.database().reference().child("/status/" + mainUserInstance.uid)
        let firestore = Firestore.firestore().collection("users").document(mainUserInstance.uid)
        
        // Set the specific user's online status to true
        firestore.setData(["online": true], merge: true)
        userStatusDatabaseRef.setValue(true)
    }
    
    func setOnDisconnectHandler() {
        
        let presenceRef = Database.database().reference(withPath: "status/\(String(describing: mainUserInstance.uid!))")
        // Write a string when this client loses connection
        presenceRef.onDisconnectSetValue(false)
    }
    
    // Listening for users in the same state
    func listenForNearbyUsers() {
        
        if nearbyUserListener != nil {
            return
        }
        
        nearbyUserListener = db.collection("countries")
            .document((mainUserInstance.address?.ISO)!)
            .collection("states")
            .document((mainUserInstance.address?.state)!)
            .collection("users").addSnapshotListener { documentSnapshot, error in
                
                guard let usersCollection = documentSnapshot?.documents else {
                    print("[Error] listening for nearby users: \(error!.localizedDescription)")
                    return
                }
                
                if usersCollection.count > 0 {
                    
                    var uids = [String]()
                    
                    for doc in usersCollection {
                        uids.append(doc.documentID)
                    }
                    
                    self.fetchUsersProfile(uids: uids) { users in
                        guard let nearbyUsers = users else { print("[Error] unwrapping nearby users profile"); return }
                        
                        self.notifyDidUpdateNearbyUsers(nearbyUsers: nearbyUsers) // Notify viewControllers
                    }
                }
        }
    }
    
    func listenForUserNotifications() {
        
        if userNotificationListener != nil { return }
        
        userNotificationListener = self.db.collection("users").document(String(describing: mainUserInstance.uid!)).collection("notifications").addSnapshotListener { documentSnapshot, error in
            
            guard let userNotificationsCollection = documentSnapshot?.documents else {
                print("[Error] listening for user notifications: \(error!.localizedDescription)")
                return
            }
            
            if userNotificationsCollection.count > 0 {
                
                var userNotifications = [UserNotification]()
                
                let dispatchGroup = DispatchGroup()

                for notification in userNotificationsCollection {
                    
                    dispatchGroup.enter()
                    
                    let data = notification.data()
                    
                    guard let typeString = data["type"] as? String,
                        let type = UserNotificationType(rawValue: typeString),
                        let userSource = data["sourceUser"] as? DocumentReference,
                        let dateTimestamp = data["date"] as? Timestamp
                        else {
                            print("[Error] unwrapping user notifications")
                            dispatchGroup.leave()
                            continue
                    }
                    
                    let date = Date(timeIntervalSince1970: TimeInterval(dateTimestamp.seconds))
                    
                    self.getUserInformation(reference: userSource) { user in
                        
                        guard let user = user else { dispatchGroup.leave(); return }
                        
                        StorageService.shared.downloadUserPicture(uid: user.uid) { photo in
                            
                            guard let photo = photo else {
                                print("[Error] unwrapping user photo")
                                dispatchGroup.leave(); return
                            }
                            user.photo = photo
                            userNotifications.append(UserNotification(type: type, user: user, date: date))
                            dispatchGroup.leave()
                        }
                    }
                }
                dispatchGroup.notify(queue: .main, execute: {
                    self.notifyDidUpdateUserNotifications(userNotifications: userNotifications)
                })
            } else {
                print(0)
            }
        }
    }
    
    func getUserInformation(reference: DocumentReference, completion: @escaping(GlobalUser?) -> Void) {
        
        reference.getDocument { doc, error in
            
            guard let userDocument = doc else {
                print("[Error] retreiving a user information: \(error!.localizedDescription)")
                completion(nil)
                return
            }
            let user = GlobalUser(document: userDocument)
            completion(user)
        }
    }
    
    
    func stopListeningForNearbyUsers() {
        nearbyUserListener.remove()
    }
    
    func stopListeningForUserNotifications() {
        userNotificationListener.remove()
    }
    
    func fetchUsersProfile(uids: [String], completion: @escaping([InterestingUser]?) -> Void) {
        
        if uids.count != 0 {
            
            var nearbyUsers = [InterestingUser]()
            let dispatchGroup = DispatchGroup()
            
            for uid in uids {
                
                if uid != mainUserInstance.uid {
                    
                    dispatchGroup.enter()
                    
                    DatabaseService.shared.getUserInformation(uid: uid) { document in
                        
                        guard let document = document else {
                            print("[Error] unwrapping nearby user information")
                            dispatchGroup.leave(); return
                        }
                        
                        let newUser = InterestingUser(document: document)
                        
                        StorageService.shared.downloadUserPicture(uid: newUser.uid) { photo in
                            
                            guard let photo = photo else {
                                print("[Error] unwrapping user photo")
                                dispatchGroup.leave(); return
                            }
                            newUser.photo = photo
                            nearbyUsers.append(newUser)
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            dispatchGroup.notify(queue: .main, execute: {
                completion(nearbyUsers)
            })
        } else {
            completion(nil)
        }
    }
    
    // upload contacts to database if necessary
    func uploadUserContactsToDatabase(contacts: [String:String]) {
        
        self.db.document("users/\(String(describing: mainUserInstance.uid!))").updateData([
            "contacts" : contacts
        ]) { err in
            if let err = err {
                print("[Error] uploading contacts: \(err.localizedDescription)")
            }
        }
    }
    
    
    // Update user location in database
    func updateUserDatabaseLocation() {
        
        let location = mainUserInstance.location
        let iso = mainUserInstance.address?.ISO
        let state = mainUserInstance.address?.state
        
        self.db.document("countries/\(String(describing: iso!))/states/\(String(describing: state!))/users/\(String(describing: mainUserInstance.uid!))").setData([
            "location": [
                "coordinate": location
            ]
        ]) { err in
            if let err = err {
                print("[Error] updating local location: \(err.localizedDescription)")
            }
        }
        
        self.db.document("users/\(mainUserInstance.uid!)").updateData([
            "last_location": GeoPoint(latitude: (mainUserInstance.location?.latitude)!, longitude: (mainUserInstance.location?.longitude)!)
        ]) { err in
            if let err = err {
                print("[Error] updating last location: \(err.localizedDescription)")
            }
        }
    }
    
    // Get any user profile from his user id
    func getUserInformation(uid: String, completion: @escaping (DocumentSnapshot?) -> Void) {
        
        db.collection("users").document(uid).getDocument { (documentSnapshot, error) in
            guard let document = documentSnapshot else {
                print("[Error] fetching user information: \(error!)")
                completion(nil)
                return
            }
            if (document.exists) {
                completion(document)
            } else {
                completion(nil)
            }
        }
    }
    
    // Creating a new user : add his information in database
    func createNewUserInDatabase(uid: String, firstname: String, lastname: String) {
        
        // Add a new document in collection "cities"
        self.db.document("users/\(uid)").setData([
            "name": [
                "firstName": firstname,
                "lastName": lastname
            ],
            "publicName": "Drope",
            "pushID": uid,
            "settings": [0: [0: false, 1: false, 2: false],
                         1: [0: false, 1: false],
                         2: [0: false]]
        ]) { err in
            if let err = err {
                print("Error creating user: \(err.localizedDescription).")
            }
        }
    }
    
    func updateOnOffSettings(section: String, code: String, state: Bool, completion: @escaping(Bool) -> Void) {
        
        let ref = self.db.document("users/\(String(describing: mainUserInstance.uid!))")
        
        ref.updateData([
            "settings.\(section).\(code)" : state
        ]) { err in
            if let err = err {
                print("[Error] updating notifications settings: \(err.localizedDescription)")
                completion(false)
            } else {
                completion(true)
            }
        }
    }
    
}

// MARK: Notification Observers
extension DatabaseService {
    
    func notifyDidUpdateNearbyUsers(nearbyUsers: [InterestingUser]) {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didFoundNearbyUsers"), object: nil, userInfo: ["closeUsers" : nearbyUsers])
    }
    
    func notifyDidUpdateUserNotifications(userNotifications: [UserNotification]) {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didUpdateUserNotifications"), object: nil, userInfo: ["userNotifications" : userNotifications])
    }
}
