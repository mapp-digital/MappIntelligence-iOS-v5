//
//  ConfigViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 02/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit
import AppTrackingTransparency

class ConfigViewController: UIViewController {

    @IBOutlet weak var EverIDTextField: UITextField!
    @IBOutlet weak var EverIDLabel: UILabel!
    
    @IBOutlet weak var anonymSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let anonymousTracking = MappIntelligence.shared()?.anonymousTracking, anonymousTracking == true {
            anonymSwitch.isOn = true
        }
        
        self.EverIDLabel.text = "Ever ID: " + (MappIntelligence.shared()?.getEverId() ?? "there is no EverID")
    }

    @IBAction func optOut(_ sender: Any) {
        MappIntelligence.shared()?.optOutAndSendCurrentData(false)
    }
    
    @IBAction func optIn(_ sender: Any) {
        MappIntelligence.shared()?.optIn()
    }
    
    @IBAction func reset(_ sender: Any) {
        MappIntelligence.shared()?.reset()
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
        //MappIntelligence.shared()?.anonymousTracking = anonymSwitch.isOn;
        MappIntelligence.shared()?.initWithConfiguration(array, onTrackdomain: domain as! String)
        MappIntelligence.shared()?.requestInterval = 1 * 60
        MappIntelligence.shared()?.logLevel = .all
        if let anonymousTracking = MappIntelligence.shared()?.anonymousTracking, anonymousTracking == true {
            anonymSwitch.isOn = true
        } else {
            anonymSwitch.isOn = false
        }
        EverIDLabel.text = "Ever ID: " + (MappIntelligence.shared()?.getEverId() ?? "there is no EverID")
    }
    
    @IBAction func toggleAnonimousTracking(_ sender: UISwitch) {
        requestTrackingPermission(sender)
    }
    
    func requestTrackingPermission(_ sender: UISwitch) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization { status in
                switch status {
                case .authorized:
                    // Tracking authorization dialog was shown
                    // and we are authorized
                    MappIntelligence.shared()?.anonymousTracking = false
                    UserDefaults.standard.setValue(true, forKey: "didYouChangeTheStatus")
                    
                    if (sender.isOn) {
                        MappIntelligence.shared()?.enableAnonymousTracking(["uc706"])
                        MappIntelligence.shared()?.setTemporarySessionId("user-xyz-123456789")
                    } else {
                        MappIntelligence.shared()?.anonymousTracking = false
                    }
                    self.EverIDLabel.text = "Ever ID: " + (MappIntelligence.shared()?.getEverId() ?? "there is no EverID")
                case .denied:
                    // Tracking authorization dialog was
                    // shown and permission is denied
                    let alert = UIAlertController(title: "Request permisssion", message: "Go to general settings to turn on option for enabling tracking", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                            case .default:
                            print("default")
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                        return
                                    }

                                    if UIApplication.shared.canOpenURL(settingsUrl) {
                                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                            print("Settings opened: \(success)") // Prints true
                                        })
                                    }
                            
                            case .cancel:
                            print("cancel")
                            
                            case .destructive:
                            print("destructive")
                            
                        @unknown default:
                            return
                        }
                    }))
                    self.present(alert, animated: true, completion: nil)
                    sender.isOn = true
                    MappIntelligence.shared()?.anonymousTracking = true
                    print("Denied")
                case .notDetermined:
                    // Tracking authorization dialog has not been shown
                    MappIntelligence.shared()?.anonymousTracking = false
                    print("Not Determined")
                case .restricted:
                    print("Restricted")
                @unknown default:
                    print("Unknown")
                }
            }
        }
    }
    
    @IBAction func initwithEverID(_ sender: Any) {
        guard let everID = self.EverIDTextField.text else {
            print("You must enter everID it can not be empty value!")
            return
        }
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
        MappIntelligence.shared()?.initWithConfiguration(array, onTrackdomain: domain as! String, andWithEverID: everID)
        MappIntelligence.shared()?.logLevel = .all
        MappIntelligence.shared()?.batchSupportEnabled = false
        MappIntelligence.shared()?.batchSupportSize = 150
        MappIntelligence.shared()?.requestInterval = 60
        MappIntelligence.shared()?.requestPerQueue = 300
        MappIntelligence.shared()?.shouldMigrate = true
        MappIntelligence.shared()?.sendAppVersionInEveryRequest = true
        MappIntelligence.shared()?.enableBackgroundSendout = true
        
        self.EverIDLabel.text = "Ever ID: " + (MappIntelligence.shared()?.getEverId() ?? "there is no EverID")
    }
    
    @IBAction func SetUserMatchingToTrue(_ sender: Any) {
        MappIntelligence.shared()?.enableUserMatching = true
    }
    
    
}
