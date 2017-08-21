//
//  AppDelegate.swift
//  DemoPrismCore
//
//  Created by Nanang Rafsanjani on 5/24/17.
//  Copyright © 2017 Prism. All rights reserved.
//

import UIKit
import PrismUI
import UserNotifications
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let vc = DemoViewController(nibName: "DemoViewController", bundle: nil)
        window!.rootViewController = vc
        window!.makeKeyAndVisible()
        
        registerForPushNotifications(app: application)
        
        //staging > fc69d550-07fa-44e6-9c03-b35250a7bd43
        //sanbox > 8c31f365-05d2-49fe-8c8d-59c84624c870
        PrismUI.shared.configure(environment: .Staging, merchantID: "6ba2f4a9-e89a-42a0-8f09-ee3de88aa928")
        
        return true
    }
    
    func registerForPushNotifications(app: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                app.registerForRemoteNotifications()
            }
        } else {
            app.registerUserNotificationSettings(UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil))
            app.registerForRemoteNotifications()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print("notif: \(userInfo)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        PrismUI.shared.sendDeviceToken(deviceToken: token)
    }
}

