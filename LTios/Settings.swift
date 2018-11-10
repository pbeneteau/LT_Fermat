//
//  SettingsModel.swift
//  LTios
//
//  Created by Paul Bénéteau on 17/09/2018.
//  Copyright © 2018 Tastyapp. All rights reserved.
//

import UIKit

struct Settings {
    let sectionId: Int!
    let rowId: Int!
    let code: String!
    let section: String!
    let name: String!
    let description: String!
    let type: SettingsCellType!
    var state: Bool!
    
    init(sectionId: Int, rowId: Int, code: String, section: String, name: String, description: String, type: SettingsCellType, state: Bool) {
        self.sectionId = sectionId
        self.rowId = rowId
        self.code = code
        self.section = section
        self.name = name
        self.description = description
        self.type = type
        self.state = state
    }
}

class UserSettings: NSObject {
    
    var settings = [[
        Settings(sectionId: 0, rowId: 0, code: "push", section: "Notifications", name: "Push Notifications", description: "Receive weekly push notifications", type: SettingsCellType.onOff, state: true),
        Settings(sectionId: 0, rowId: 1, code: "chat", section: "Notifications", name: "Chat Notifications", description: "Receive chat notifications", type: SettingsCellType.onOff, state: true),
        Settings(sectionId: 0, rowId: 2, code: "friends", section: "Notifications", name: "FriendsNotifications", description: "Receive friends notifications", type: SettingsCellType.onOff, state: true)],
        [Settings(sectionId: 1, rowId: 0, code: "ghost", section: "Privacy", name: "Ghost Mode", description: "Be hidden from other users", type: SettingsCellType.onOff, state: true),
        Settings(sectionId: 1, rowId: 1, code: "bgLocation", section: "Privacy", name: "Background Location", description: "Allow Little World to locate you when it's closed", type: SettingsCellType.onOff, state: true)],
        [Settings(sectionId: 2, rowId: 0, code: "snapchat", section: "Social", name: "Snapchat Account", description: "Unlock cool Snapchat stuff", type: SettingsCellType.segue, state: true)]
    ]
    
    init(userSettings: [String : [String: Bool]]) {
        super.init()
                
        for settingsKey in userSettings.keys {
            
            for settings in userSettings[settingsKey]! {
                
                setSettingsValue(category: settingsKey, settings.value, forKey: settings.key)
            }
        }
    }
    
    func setSettingsValue(category: String, _ value: Bool, forKey code: String) {
        
        var index: IndexPath = IndexPath(row: 0, section: 0)
        
        for categories in self.settings {
            
            for settings in categories {
                
                if settings.section.lowercased() == category {
                    
                    if settings.code == code {
                        self.settings[index.section][index.row].state = value
                    }
                } else { break }
                index.row += 1
            }
            index.section += 1
        }
    }
    
    func getStateFromCode(_ code: String) -> Bool {
        
        for categories in self.settings {
            
            for settings in categories {
                
                if settings.code == code {
                    return settings.state
                }
            }
        }
        return true
    }
    
    override init() {
    }
    
    func getSectionName(section: Int) -> String {
        return settings[section][0].section
    }
    
    func getName(section: Int, row: Int) -> String {
        return settings[section][row].name
    }
    
    func getDescription(section: Int, row: Int) -> String {
        return settings[section][row].description
    }
    
    func getState(section: Int, row: Int) -> Bool {
        return settings[section][row].state
    }
    
    func getType(section: Int, row: Int) -> SettingsCellType {
        return settings[section][row].type
    }
    
    func getTotalSections() -> Int {
        return settings.count
    }
    
    func getTotalRows(section: Int) -> Int {
        return settings[section].count
    }
}


extension UserSettings {
    
    static func updateAppSettingsFromCode(_ code: String, state: Bool) {
        
        switch code {
        case "ghost": 
            NotificationCenter.default.post(name: Notification.Name(rawValue:"didRequestPrivacyChange"), object: nil)
            LocationService.shared.locationManager.stopUpdatingLocation()
            break
        case "bgLocation":
            LocationService.shared.locationManager.allowsBackgroundLocationUpdates = state; break
        default: break
        }
    }
    
}

extension Dictionary {
    subscript(i:Int) -> (key:Key,value:Value) {
        get {
            return self[index(startIndex, offsetBy: i)];
        }
    }
}
