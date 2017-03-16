//
//  Simblee.swift
//  Beejee
//
//  Created by Vik Denic on 3/16/17.
//  Copyright © 2017 Vik Denic. All rights reserved.
//

import Foundation

//MARK: Bluetooth
typealias Byte = UInt8
typealias BLEPacket = [Byte]
typealias BLEMessage = [BLEPacket]

class Simblee {
    
    var serialNumber: String?
    var version: String?
    
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
    
    class func extractSerialNumber(advertisementData: [String : Any]) -> String {
        let data = advertisementData["kCBAdvDataManufacturerData"] as! Data
        let value = data[2...5]
        var stringValue = ""
        for byte in value {
            stringValue = stringValue + String(byte, radix: 16)
        }
        return stringValue
    }
}
