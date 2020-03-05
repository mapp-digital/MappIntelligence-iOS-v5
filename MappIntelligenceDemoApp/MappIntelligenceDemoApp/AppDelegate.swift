//
//  AppDelegate.swift
//  DemoMappIntelligenceApp
//
//  Created by Vladan Randjelovic on 20/01/2020.
//  Copyright © 2020 Vladan Randjelovic. All rights reserved.
//
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        MappIntelligence.shared()?.initWithConfiguration([123,12,1], onDomain: "https://q3.ciciban.net", withAutotrackingEnabled: true, requestTimeout: 45, numberOfRequests: 40, batchSupportEnabled: false, viewControllerAutoTrackingEnabled: true, andLogLevel: .info)
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
       
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

  

}

