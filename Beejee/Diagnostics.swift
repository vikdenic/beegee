//
//  Diagnostics.swift
//  DiskoTooth
//
//  Created by Vik Denic on 3/16/17.
//  Copyright © 2017 Vik Denic. All rights reserved.
//

//
//  Diagnostics.swift
//  LlamaWrangler Jr
//
//  Created by Dave Krawczyk on 8/13/15.
//  Copyright (c) 2015 Windy City Lab. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

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
