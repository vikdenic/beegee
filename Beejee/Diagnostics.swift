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

let logFileName = "debug.txt"

class Diagnostics {
    
    class func showAlertWithMessage(_ message: String, inVC: UIViewController) {
        
        let controller = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let action = UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil)
        controller.addAction(action)
        
        inVC.present(controller, animated: true, completion: nil)
        
    }
    
    class func clearLogFile() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        var pathURL = URL(string: path)
        pathURL = pathURL?.appendingPathComponent(logFileName)
        
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch _ {
        }
        
        
    }
    class func writeToPlist(_ message:String!) {
        let now = Date()
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss.SSS"
        let stringToWrite = "\(format.string(from: now)) --- \(message)\n"
        
        print(stringToWrite)
        
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let fileName = "\(documentsDirectory)/debug.txt"
        do{
            try stringToWrite.write(toFile: fileName, atomically: false, encoding: String.Encoding.utf8)
        }catch _ {
            print("error writing file to documents directory")
        }
    }
    
    func saveFile() {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        let fileName = "\(documentsDirectory)/debug.txt"
        let content = "Hello World"
        do{
            try content.write(toFile: fileName, atomically: false, encoding: String.Encoding.utf8)
        }catch _ {
            
        }
    }
}

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
