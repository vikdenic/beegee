//
//  Extensions.swift
//  Beejee
//
//  Created by Vik Denic on 3/16/17.
//  Copyright © 2017 Vik Denic. All rights reserved.
//

import Foundation
import UserNotifications

//MARK: Notification
@available(iOS 10.0, *)
extension UNNotification {
    class func scheduleNotif(title: String, body: String) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound(named: "notif.wav")
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1,
                                                        repeats: false)
        
        let identifier = "UYLLocalNotification"
        let request = UNNotificationRequest(identifier: identifier,
                                            content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let _ = error {
                // Something went wrong
            }
        })
    }
}

//MARK: For processing data from our Simblee peripherals
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
