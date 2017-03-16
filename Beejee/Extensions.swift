//
//  Extensions.swift
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

//MARK: Extensions
extension Data {
    func convertToBytes() -> [Byte] {
        let count = self.count / MemoryLayout<Byte>.size
        var result = [Byte](repeating : 0, count : self.count)
        self.copyBytes(to: &result, count: count * MemoryLayout<Byte>.size)
        return result
    }
    
}
