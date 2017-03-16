//
//  Extensions.swift
//  Beejee
//
//  Created by Vik Denic on 3/16/17.
//  Copyright © 2017 Vik Denic. All rights reserved.
//

import Foundation

//MARK: Extensions
extension Data {
    func convertToBytes() -> [Byte] {
        let count = self.count / MemoryLayout<Byte>.size
        var result = [Byte](repeating : 0, count : self.count)
        self.copyBytes(to: &result, count: count * MemoryLayout<Byte>.size)
        return result
    }
    
}

extension UInt16 {
    func twoBytes() -> [Byte] {
        var value : [Byte] = Array()
        value.append(Byte(self / UInt16(256)))
        value.append(Byte(self - (UInt16(value[0]) * UInt16(256))))
        return value
    }
}
