//
//  Simblee.swift
//  Beejee
//
//  Created by Vik Denic on 3/16/17.
//  Copyright © 2017 Vik Denic. All rights reserved.
//

import Foundation
import CoreBluetooth

//MARK: Bluetooth
typealias Byte = UInt8
//typealias BLEPacket = [Byte]
//typealias BLEMessage = [BLEPacket]

class Simblee {
    
    var serialNumber: String?
    var version: String?
    var peripheral: CBPeripheral?
    var lastSeen: Date?

    var advertisingData : [String : Any]? = nil {
        didSet {
            if let data = advertisingData?["kCBAdvDataManufacturerData"] as? Data {
                serialNumber = Simblee.extractSerialNumber(advertisementData: advertisingData! as [String : Any])
                let bytes = data.convertToBytes()
                if bytes.count > 8 {
                    version = String(bytes[6]) + "." + String(bytes[7]) + "." + String(bytes[8])
                }
            }
        }
    }
    
    init(advData: [String : Any], periph: CBPeripheral) {
        self.advertisingData = advData
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
