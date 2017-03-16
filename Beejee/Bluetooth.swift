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
let kTimerFrequency = 1.0
let kMinCutoffTime = -3.3

class Bluetooth: NSObject {
    
    static let sharedInstance = Bluetooth()
    
    var centralManager: CBCentralManager!
    var bgServiceID: CBUUID = CBUUID(string: kBGCustomUUID)
    var simblees = [Simblee]()
    
    var foundSimblee : ((_ simblee: Simblee?) -> ())? = nil
    var lostSimblee : ((_ mirror: Simblee?) -> ())? = nil
    var scanStateChanged : ((_ state: CBManagerState) -> ())? = nil
    var timer = Timer()
    
    override init() {
        super.init()
        
        Diagnostics.writeToPlist("Bluetooth class init")
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options:
            [ CBCentralManagerOptionRestoreIdentifierKey : [kBGRestoreId], CBCentralManagerScanOptionAllowDuplicatesKey : true, CBCentralManagerScanOptionSolicitedServiceUUIDsKey : [bgServiceID] ])
        
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(kTimerFrequency), target: self, selector: #selector(monitorSimblees), userInfo: nil, repeats: true)
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
    
    func monitorSimblees() {
        var theLostSimblee: Simblee?
        for simblee in simblees {
            if (simblee.lastSeen?.timeIntervalSinceNow)! < kMinCutoffTime {
                theLostSimblee = simblee
            }
        }
        
        simblees = simblees.filter() {($0.lastSeen?.timeIntervalSinceNow)! > kMinCutoffTime} //updates array
        
        if let theLostSimblee = theLostSimblee {
            lostSimblee?(theLostSimblee)
        }
    }
    
}

extension Bluetooth: CBCentralManagerDelegate {
    
    //MARK: Scanning
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        Diagnostics.writeToPlist("didDiscover peripheral")
        
        //  If our mirrors array contains a mirror representing that peripheral
        if let existingSimblee = Simblee.getSimblee(simblees: simblees, peripheral: peripheral) {
            existingSimblee.lastSeen = Date()
            print("Simblee already detected")
        } else { //Otherwise, create a new PhysicalMirror out of the discovered peripheral
            let simblee = Simblee(advData: advertisementData, periph: peripheral)
            simblees.append(simblee)
            self.foundSimblee?(simblee)
            print("New Simblee detected")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if let simblee = Simblee.getSimblee(simblees: simblees, peripheral: peripheral) {
            lostSimblee?(simblee)
        }
    }

    @available(iOS 5.0, *)
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        Diagnostics.writeToPlist("centralManagerDidUpdateState: \(central.state)")
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
        Diagnostics.writeToPlist("willRestoreState")
    }
}
