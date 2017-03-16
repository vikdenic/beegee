//
//  Bluetooth.swift
//  Beejee
//
//  Created by Vik Denic on 3/16/17.
//  Copyright © 2017 Vik Denic. All rights reserved.
//

import Foundation
import CoreBluetooth

let kBGRestoreId = "beegeeCentral"
let kBGCustomUUID = "80988420-2226-4A51-9D1B-402E6F316E3C"

class Bluetooth: NSObject {
    
    static let sharedInstance = Bluetooth()
    
    var centralManager: CBCentralManager!
    var bgServiceID: CBUUID = CBUUID(string: kBGCustomUUID)
    var simblees = [Simblee]()
    
    var foundSimblee : ((_ simblee: Simblee?) -> ())? = nil
    
    override init() {
        super.init()
        
        Diagnostics.writeToPlist("Bluetooth class init")
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options:
            [ CBCentralManagerOptionRestoreIdentifierKey : [kBGRestoreId], CBCentralManagerScanOptionAllowDuplicatesKey : true, CBCentralManagerScanOptionSolicitedServiceUUIDsKey : [bgServiceID] ])
    }
    
    //MARK: Actions
    func startScan() {
        Diagnostics.writeToPlist("startScan for peripherals with UUID : \(bgServiceID)")
        
        self.centralManager.scanForPeripherals(withServices: [bgServiceID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : true])
    }
    
    func stopScan() {
        Diagnostics.writeToPlist("Stopping scan")
        self.centralManager.stopScan()
    }
    
}

extension Bluetooth: CBCentralManagerDelegate {
    
    //MARK: Scanning
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        Diagnostics.writeToPlist("didDiscover peripheral")
        
        let simblee = Simblee(advData: advertisementData, periph: peripheral)
        //  If our mirrors array contains a mirror representing that peripheral
        if let _ = Simblee.getSimblee(simblees: simblees, peripheral: peripheral) {
            print("Simblee already detected")
        } else { //Otherwise, create a new PhysicalMirror out of the discovered peripheral
            simblees.append(simblee)
            self.foundSimblee?(simblee)
        }
    }

    @available(iOS 5.0, *)
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Diagnostics.writeToPlist("centralManagerDidUpdateState: \(central.state)")
        
        switch central.state {
        case .poweredOn:
            startScan()
            return
        default :
            return
        }
    }

    //Restore
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        Diagnostics.writeToPlist("willRestoreState")
    }
}
