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
        let actionProperties = MIActionProperties(properties:  [20:["ck20Param1","ck20Param2"]])

        let event = MIActionEvent(name: "TestAction")
        event.actionProperties = actionProperties;

        MappIntelligence.shared()?.trackAction(event);
    }
    
    @IBAction func trackCustomAction(_ sender: Any) {
        let actionProperties = MIActionProperties(properties:  [20:["ck20Param1","ck20Param2"]])
        
        //user properties
        let userProperties = MIUserProperties()
        userProperties.customProperties = [20:["userParam1"]]
        userProperties.birthday = MIBirthday(day: 12, month: 1, year: 1993)
        userProperties.city = "Paris"
        userProperties.country = "France"
        userProperties.customerId = "CustomerID"
        userProperties.gender = .female
        
        //sessionproperties
        let sessionProperties = MISessionProperties(properties: [10: ["sessionParam1", "sessionParam2"]])
        
        let event = MIActionEvent(name: "TestAction")
        event.actionProperties = actionProperties;
        event.userProperties = userProperties
        event.sessionProperties = sessionProperties
        
        MappIntelligence.shared()?.trackAction(event);
    }
}
