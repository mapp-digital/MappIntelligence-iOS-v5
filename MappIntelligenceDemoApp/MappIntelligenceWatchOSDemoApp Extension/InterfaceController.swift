//
//  InterfaceController.swift
//  MappIntelligenceWatchOSDemoApp Extension
//
//  Created by Stefan Stevanovic on 3/25/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        MappIntelligenceWatchOS.shared()?.initWithConfiguration([385255285199574 as UInt64, 5555555555 as UInt64], onTrackdomain: "https://q3.webtrekk.net")
        MappIntelligenceWatchOS.shared()?.logLevelWatchOS = .allWatchOSLogs
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func TrackPage() {
        let customName = "the custom name of page"
        let params:NSMutableDictionary = [20: ["cp20Override", "cp21Override", "cp22Override"]]
        let categories:NSMutableDictionary = [10: ["test"]]
        let searchTerm = "testSearchTerm"
        
        MappIntelligenceWatchOS.shared()?.trackPage(withName: customName, andWith: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm))
    }
    @IBAction func reset() {
        MappIntelligenceWatchOS.shared()?.reset()
    }
    @IBAction func InitAgain() {
        MappIntelligenceWatchOS.shared()?.initWithConfiguration([385255285199574 as UInt64], onTrackdomain: "https://q3.webtrekk.net")
    }
}
