//
//  Bluetooth.swift
//  Beejee
//
//  Created by Vik Denic on 3/16/17.
//  Copyright © 2017 Vik Denic. All rights reserved.
//

import Foundation
import CoreBluetooth
import UserNotifications

let kBGRestoreId = "beegeeCentral"
let kBGCustomUUID = "80988420-2226-4A51-9D1B-402E6F316E3C"
var bgServiceID: CBUUID = CBUUID(string: kBGCustomUUID)

class Bluetooth: NSObject {
    
    static let sharedInstance = Bluetooth()
    
    var centralManager: CBCentralManager!
    var simblees = [Simblee]()
    
    var foundSimblee : ((_ simblee: Simblee?) -> ())? = nil
    var scanStateChanged : ((_ state: CBManagerState) -> ())? = nil
    
    override init() {
        super.init()
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options:
            [ CBCentralManagerOptionRestoreIdentifierKey : [kBGRestoreId], CBCentralManagerScanOptionAllowDuplicatesKey : false, CBCentralManagerScanOptionSolicitedServiceUUIDsKey : [bgServiceID] ])
    }
    
    //MARK: Actions
    func startScan() {
        self.centralManager.scanForPeripherals(withServices: [bgServiceID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true, CBCentralManagerScanOptionSolicitedServiceUUIDsKey : [bgServiceID]])
    }
    
}

extension Bluetooth: CBCentralManagerDelegate {
    
    //MARK: Scanning
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //  If our simblees array contains a mirror representing that peripheral
        if let existingSimblee = Simblee.getSimblee(simblees: simblees, peripheral: peripheral) {
            print("Simblee already detected")
        } else { //Otherwise, create a new Simblee instance from the discovered peripheral
            let simblee = Simblee(periph: peripheral)
            simblees.append(simblee)
            self.foundSimblee?(simblee)
            print("New Simblee detected")
            UNNotification.scheduleNotif(title: "Found new Simblee", body: (simblee.peripheral?.identifier.uuidString)!)
        }
    }

    @available(iOS 5.0, *)
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScan()
        default :
            simblees.removeAll()
        }
        scanStateChanged?(central.state)
    }

    //Restore
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        let _ = Bluetooth.sharedInstance
        Bluetooth.sharedInstance.startScan()
    }
}
