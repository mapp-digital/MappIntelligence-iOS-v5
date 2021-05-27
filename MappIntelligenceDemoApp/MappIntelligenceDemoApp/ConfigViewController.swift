//
//  ConfigViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 02/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class ConfigViewController: UIViewController {

    @IBOutlet weak var EverIDLabel: UILabel!
    
    @IBOutlet weak var anonymSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let anonymousTracking = MappIntelligence.shared()?.anonymousTracking, anonymousTracking == true {
            anonymSwitch.isOn = true
        }
        EverIDLabel.text = "Ever ID: " + (MappIntelligence.shared()?.getEverId() ?? "there is no EverID")
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
        MappIntelligence.shared()?.initWithConfiguration(array, onTrackdomain: domain as! String)
        MappIntelligence.shared()?.requestInterval = 1 * 60
    }
    
    @IBAction func toggleAnonimousTracking(_ sender: UISwitch) {
        if (sender.isOn) {
            MappIntelligence.shared()?.enableAnonymousTracking(["uc706"])
        } else {
            MappIntelligence.shared()?.anonymousTracking = false
        }
    }

}
