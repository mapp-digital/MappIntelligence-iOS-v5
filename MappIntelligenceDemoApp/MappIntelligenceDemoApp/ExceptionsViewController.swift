//
//  ExceptionsViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Stefan Stevanovic on 27/08/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

import UIKit
import Foundation

class ExceptionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func trackExceptionWithNameAndMessage(_ sender: Any) {
        MappIntelligence.shared()?.trackException(withName: "Test Exception", andWithMessage: "Test Exception Message")
    }
    
    @IBAction func trackUncaughtException(_ sender: Any) throws {
        //fatalError()
        NSException(name: NSExceptionName(rawValue: "Custom Exception"), reason: "Custom reason", userInfo: ["Localized key" : "Unexpected input"]).raise()
    }
    
    @IBAction func TrackError(_ sender: Any) {
        let userInfo: [String : Any] =
                    [
                        NSLocalizedDescriptionKey :  NSLocalizedString("Unauthorized", value: "Please activate your account", comment: "") ,
                        NSLocalizedFailureReasonErrorKey : NSLocalizedString("Unauthorized", value: "Account not activated", comment: "")
                ]
        let error = NSError(domain: "ShiploopHttpResponseErrorDomain", code: 401, userInfo: userInfo)
        MappIntelligence.shared()?.trackException(with: error)
    }

}
