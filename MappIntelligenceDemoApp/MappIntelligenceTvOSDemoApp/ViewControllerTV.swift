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
        let params:[NSNumber:[String]] = [20: ["cp20Override", "cp21Override", "cp22Override"]]
        let categories:NSMutableDictionary = [10: ["test"]]
        let searchTerm = "testSearchTerm"
        MappIntelligencetvOS.shared()?.trackPage(with: self, pageProperties: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm), sessionProperties: nil)
    }
    
    @IBAction func trackCustomString(_ sender: Any) {
        let customName = "the custom name of page"
        let params:[NSNumber:[String]] = [20: ["cp20Override", "cp21Override", "cp22Override"]]
        let categories:NSMutableDictionary = [10: ["test"]]
        let searchTerm = "testSearchTerm"
        let sessionProperties = SessionProperties(properties: [10: ["sessionpar1"]])

        MappIntelligencetvOS.shared()?.trackPage(withName: customName, pageProperties: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm), sessionProperties: sessionProperties)
    }
    @IBAction func trackAction(_ sender: Any) {
        let actionProperties = ActionProperties(properties:  [20:["ck20Override","ck21Override"]])
        let sessionProperties = SessionProperties(properties: [10: ["sessionpar1"]])
        MappIntelligencetvOS.shared()?.trackCustomEvent(withName: "TestAction", actionProperties: actionProperties, sessionProperties: sessionProperties)
    }
    @IBAction func optIn(_ sender: Any) {
        MappIntelligencetvOS.shared()?.optIn()
    }
    @IBAction func optOut(_ sender: Any) {
        MappIntelligencetvOS.shared()?.optOutAndSendCurrentData(true)
    }
    @IBAction func reset(_ sender: Any) {
        MappIntelligencetvOS.shared()?.reset()
    }
    @IBAction func initAgain(_ sender: Any) {
        MappIntelligencetvOS.shared()?.initWithConfiguration([385255285199574], onTrackdomain: "https://q3.webtrekk.net")
    }
}

