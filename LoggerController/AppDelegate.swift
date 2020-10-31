//
//  AppDelegate.swift
//  Logger5
//
//  Created by MacBook Air on 2019/10/11.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit
import GameController


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var motionDelegate: ReactToMotionEvents? = nil


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let center = NotificationCenter.default
        center.addObserver(self, selector: Selector(("setupControllers:")), name: NSNotification.Name.GCControllerDidConnect, object: nil)
        center.addObserver(self, selector: Selector(("setupControllers:")), name: NSNotification.Name.GCControllerDidDisconnect, object: nil)
        GCController.startWirelessControllerDiscovery { () -> Void in

        }
        
        return true
    }
    
    func setupControllers(notif: NSNotification) {
        print("controller connection")
        let controllers = GCController.controllers()
        
        for controller in controllers {
            controller.motion?.valueChangedHandler = { (motion: GCMotion)->() in
                if let delegate = self.motionDelegate {
                    delegate.motionUpdate(motion: motion)
                }
            }
        }
        }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

protocol ReactToMotionEvents {
    func motionUpdate(motion: GCMotion) -> Void
}
