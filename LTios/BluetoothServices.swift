//
//  BluetoothServices.swift
//  LTios
//
//  Created by Paul Bénéteau on 20/09/2018.
//  Copyright © 2018 Tastyapp. All rights reserved.
//

import UIKit
import CoreBluetooth


class BluetoothServices: NSObject {
    
    public static var shared = BluetoothServices()
    
    static var visibleDevices = Array<Device>()
    static var cachedDevices = Array<Device>()
    static var cachedPeripheralNames = Dictionary<String, String>()
    static var timer = Timer()
    
    var peripheralManager = CBPeripheralManager()
    var centralManager: CBCentralManager?
    
    override init() {
        super.init()
        
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }
    
    func scheduledTimerWithTimeInterval() {
        
        BluetoothServices.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.clearPeripherals), userInfo: nil, repeats: true)
    }
    
    @objc func clearPeripherals() {
        
        BluetoothServices.visibleDevices = BluetoothServices.cachedDevices
        BluetoothServices.cachedDevices.removeAll()
    }
    
    func updateAdvertisingData() {
        
        if (peripheralManager.isAdvertising) {
            peripheralManager.stopAdvertising()
        }
        
        let userData = mainUserInstance
        let advertisementData = String(format: "%@", userData!.uid)
        
        peripheralManager.startAdvertising([CBAdvertisementDataServiceUUIDsKey:[Constants.SERVICE_UUID], CBAdvertisementDataLocalNameKey: advertisementData])
    }
    
    func addOrUpdatePeripheralList(device: Device, list: inout Array<Device>) {
        
        if !list.contains(where: { $0.peripheral.identifier == device.peripheral.identifier }) {
            
            list.append(device)
        }
        else if list.contains(where: { $0.peripheral.identifier == device.peripheral.identifier
            && $0.uid == "unknown"}) && device.uid != "unknown" {
            
            for index in 0..<list.count {
                
                if (list[index].peripheral.identifier == device.peripheral.identifier) {
                    
                    list[index].uid = device.uid
                    break
                }
            }
        }
        
        if (BluetoothServices.visibleDevices.count > 0) {
            
            var uids = [String]()
            
            for device in BluetoothServices.visibleDevices {
                uids.append(device.uid)
            }
            
            DatabaseService.shared.fetchUsersProfile(uids: uids) { users in
                
                guard let interestingUsers = users else {
                    print("[Error] unwrapping nearby bluetooth users")
                    return
                }
                self.notifyDidUpdateNearbyBluetoothDevices(users: interestingUsers)
            }
        }
    }
}

extension BluetoothServices: CBPeripheralManagerDelegate {
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        
        if (peripheral.state == .poweredOn) {
            
            updateAdvertisingData()
        }
    }
}

extension BluetoothServices: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if (central.state == .poweredOn) {
            
            self.centralManager?.scanForPeripherals(withServices: [Constants.SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        var peripheralName = BluetoothServices.cachedPeripheralNames[peripheral.identifier.description] ?? "unknown"
        
        if let advertisementName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            
            peripheralName = advertisementName
            BluetoothServices.cachedPeripheralNames[peripheral.identifier.description] = peripheralName
        }
        
        let device = Device(peripheral: peripheral, uid: peripheralName)
        
        self.addOrUpdatePeripheralList(device: device, list: &BluetoothServices.visibleDevices)
        self.addOrUpdatePeripheralList(device: device, list: &BluetoothServices.cachedDevices)
    }
}

// MARK: Notifications
extension BluetoothServices {
    
    private func notifyDidUpdateNearbyBluetoothDevices(users: [InterestingUser]) {
        NotificationCenter.default.post(name: Notification.Name(rawValue:"didFoundNearbyBluetoothUsers"), object: users)
    }
}
