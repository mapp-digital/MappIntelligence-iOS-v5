//
//  MediaViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 29/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func trackMedia1(_ sender: Any) {
        let mediaProperties = MIMediaProperties("TestVideo", action: "view", postion: 12, duration: 120)
        let mediaEvent = MIMediaEvent(mediaProperties)
    }
    
}
