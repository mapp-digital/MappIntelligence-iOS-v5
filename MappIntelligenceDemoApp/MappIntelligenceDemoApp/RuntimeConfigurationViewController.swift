//
//  RuntimeConfigurationViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Stefan Stevanovic on 23.2.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class RuntimeConfigurationViewController: UIViewController {
    
    @IBOutlet weak var trackDomainTextField: UITextField!
    @IBOutlet weak var trackIDsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackDomainTextField.text = MappIntelligence.getUrl()
        trackIDsTextField.text = MappIntelligence.getId()
    }
    
    @IBAction func InitAtRuntime(_ sender: Any) {
        guard let trackIDs = (trackIDsTextField.text?.components(separatedBy: ",").compactMap { Int($0) }) else {
            print("track ids are not correct")
            return
        }
        guard let trackDomain = trackDomainTextField.text else {
            print("there is no text domain")
            return
        }
        MappIntelligence.shared()?.setIdsAndDomain(trackIDs, onTrackdomain: trackDomain)
    }
}
