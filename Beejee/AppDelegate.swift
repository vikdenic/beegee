//
//  AppDelegate.swift
//  Beejee
//
//  Created by Vik Denic on 3/16/17.
//  Copyright © 2017 Vik Denic. All rights reserved.
//

import UIKit
import UserNotifications
import CoreBluetooth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let _ = Bluetooth.sharedInstance //initializes our CBCentralManager
        Bluetooth.sharedInstance.startScan() //begins scanning for peripherals
        
        //Setup notifications
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization.
        }
        
        return true
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    //Configure presentation of notifications; we trigger notifcations when a new peripheral is detected
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler(
            [.alert,
             .sound,
             .badge])
    }
    
}
