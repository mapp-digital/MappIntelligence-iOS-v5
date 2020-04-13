//
//  InterfaceController.swift
//  MappIntelligenceWatchOSDemoApp Extension
//
//  Created by Stefan Stevanovic on 3/25/20.
//  Copyright © 2020 Vladan Randjelovic. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        MappIntelligenceWatchOS.shared()?.initWithConfiguration([385255285199574 as UInt64], onTrackdomain: "https://q3.webtrekk.net", requestTimeout: 45, andLogLevel: .allWatchOSLogs)
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
        MappIntelligenceWatchOS.shared()?.trackPage(with: "trackWatchOSTestPageName")
    }
    @IBAction func reset() {
        MappIntelligenceWatchOS.shared()?.reset()
    }
    @IBAction func InitAgain() {
        MappIntelligenceWatchOS.shared()?.initWithConfiguration([385255285199574 as UInt64], onTrackdomain: "https://q3.webtrekk.net", requestTimeout: 45, andLogLevel: .allWatchOSLogs)
    }
}
