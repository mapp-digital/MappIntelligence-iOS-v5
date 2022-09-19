//
//  ActionViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 02/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func trackAction(_ sender: Any) {
        let eventParameters = MIEventParameters(parameters: [20:"ck20Param1"])

        let event = MIActionEvent(name: "TestAction")
        event.eventParameters = eventParameters

        MappIntelligence.shared()?.trackAction(event)
    }
    
    @IBAction func trackCustomAction(_ sender: Any) {
        let eventParameters = MIEventParameters(parameters:  [20:"ck20Param1"])
        
        //user properties
        let userCategories = MIUserCategories()
        userCategories.customCategories = [20:"( $', /:?@=&+ !.;()-_*"]
        userCategories.birthday = MIBirthday(day: 12, month: 1, year: 1993)
        userCategories.city = "Paris"
        userCategories.country = "France"
        userCategories.customerId = "CustomerID"
        userCategories.gender = .unknown
        userCategories.emailReceiverId = "testd598378532"
        
        //sessionproperties
        let sessionParameters = MISessionParameters(parameters: [10: "sessionParam1"])
        
        let event = MIActionEvent(name: "TestAction")
        event.eventParameters = eventParameters
        event.userCategories = userCategories
        event.sessionParameters = sessionParameters

        MappIntelligence.shared()?.trackAction(event)
    }
}
