//
//  ViewController.swift
//  MappIntelligenceTvOSDemoApp
//
//  Created by Stefan Stevanovic on 4/24/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class ViewControllerTV: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func trackViewController(_ sender: Any) {
        MappIntelligencetvOS.shared()?.trackPage(self)
    }
    
    @IBAction func trackCustomString(_ sender: Any) {
        MappIntelligencetvOS.shared()?.trackPage(with:  "customString")
    }
}

