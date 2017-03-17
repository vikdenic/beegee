//
//  Simblee.swift
//  Beejee
//
//  Created by Vik Denic on 3/16/17.
//  Copyright © 2017 Vik Denic. All rights reserved.
//

import Foundation
import CoreBluetooth

typealias Byte = UInt8

class Simblee { //This class represents the peripheral objects we are scanning for
    
    var serialNumber: String?
    var version: String?
    var peripheral: CBPeripheral?
    var lastSeen: Date?

    init(periph: CBPeripheral) {
        self.peripheral = periph
        self.lastSeen = Date()
    }
    
    class func extractSerialNumber(advertisementData: [String : Any]) -> String {
        let data = advertisementData["kCBAdvDataManufacturerData"] as! Data
        let value = data[2...5]
        var stringValue = ""
        for byte in value {
            stringValue = stringValue + String(byte, radix: 16)
        }
        return stringValue
    }
    
    class func getSimblee(simblees : [Simblee], peripheral : CBPeripheral) -> Simblee? {
        let result = simblees.filter{$0.peripheral?.identifier.uuidString == peripheral.identifier.uuidString}
        return result.first
    }
}
