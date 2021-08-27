//
//  ExceptionsViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Stefan Stevanovic on 27/08/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class ExceptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func trackExceptionWithNameAndMessage(_ sender: Any) {
        MappIntelligence.shared()?.trackException(withName: "Test Exception", andWithMessage: "Test Exception Message")
    }
    

}
