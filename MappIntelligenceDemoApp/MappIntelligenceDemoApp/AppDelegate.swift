//
//  AppDelegate.swift
//  DemoMappIntelligenceApp
//
//  Created by Vladan Randjelovic on 20/01/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//
import UIKit
import AppTrackingTransparency

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Appoxee.shared()?.engageAndAutoIntegrate(launchOptions: launchOptions, andDelegate: nil, with: .L3)
        let bundles = Bundle.allBundles
        var path = ""
        for bundle in bundles {
            if bundle.path(forResource: "SetupForLocalTesting", ofType: "plist") != nil {
                path = bundle.path(forResource: "SetupForLocalTesting", ofType: "plist") ?? ""
            }
        }
        let dict = NSDictionary(contentsOfFile: path) as Dictionary?
        let array = [(dict?["track_ids" as NSObject]?.intValue) ?? 0]
        let domain = dict?["domain" as NSObject]
        let didYouChangeTheStatusFlag = UserDefaults.standard.bool(forKey: "didYouChangeTheStatus")
        MappIntelligence.shared()?.anonymousTracking = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.requestTrackingPermission()
        }
        //didYouChangeTheStatusFlag ? (MappIntelligence.shared()?.anonymousTracking ?? false) : true
        MappIntelligence.shared()?.initWithConfiguration(array, onTrackdomain: domain as! String)
        //MappIntelligence.shared()?.trackPage(MIPageViewEvent(name: "ime_glupo"))
        //MappIntelligence.shared()?.initWithConfiguration(array, onTrackdomain: domain as! String, andWithEverID: "43657756353521")
        MappIntelligence.shared()?.logLevel = .all
        MappIntelligence.shared()?.batchSupportEnabled = false
        MappIntelligence.shared()?.batchSupportSize = 150
        MappIntelligence.shared()?.requestInterval = 1
        MappIntelligence.shared()?.requestPerQueue = 300
        MappIntelligence.shared()?.shouldMigrate = true
        MappIntelligence.shared()?.sendAppVersionInEveryRequest = true
        MappIntelligence.shared()?.enableBackgroundSendout = true
        //MappIntelligence.shared()?.enableUserMatching = true
        //MappIntelligence.shared()?.setTemporarySessionId("user-xyz-123456789")
        MappIntelligence.shared()?.setTemporarySessionId("test123")
        MappIntelligence.shared()?.enableCrashTracking(.allExceptionTypes)
        // Override point for customization after application launch.
        return true
    }
    
    func requestTrackingPermission() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    MappIntelligence.shared()?.anonymousTracking = false
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print("will terminate")
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

    //deep linking
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        MappIntelligence.shared()?.trackUrl(userActivity.webpageURL, withMediaCode: nil)
        return false
    }
    
}

