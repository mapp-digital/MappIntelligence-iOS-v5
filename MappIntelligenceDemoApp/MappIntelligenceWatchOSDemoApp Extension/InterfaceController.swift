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
        MappIntelligenceWatchOS.shared()?.requestInterval = 60;
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
        let params:[NSNumber:[String]] = [20: ["cp20Override", "cp21Override", "cp22Override"]]
        let categories:NSMutableDictionary = [10: ["test"]]
        let searchTerm = "testSearchTerm"
        MappIntelligenceWatchOS.shared()?.trackPage(withName: customName, pageProperties: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm), sessionProperties: nil, userProperties: nil, ecommerceProperties: nil)
    }
    @IBAction func reset() {
        MappIntelligenceWatchOS.shared()?.reset()
    }
    @IBAction func InitAgain() {
        MappIntelligenceWatchOS.shared()?.initWithConfiguration([385255285199574 as UInt64], onTrackdomain: "https://q3.webtrekk.net")
    }
    @IBAction func trackAction() {
        let actionProperties = ActionProperties(properties:  [20:["ck20Override","ck21Override"]])
        let sessionProperties = SessionProperties(properties: [10: ["sessionpar1"]])
        let userProperties = UserProperties()
        userProperties.customProperties = [20:["Test"]]
        userProperties.birthday = Birthday(day: 12, month: 0, year: 1993)
        userProperties.city = "Paris"
        userProperties.country = "France"
        userProperties.customerId = "CustomerID"
        userProperties.gender = .female
        let ecommerceProperties = EcommerceProperties()
        ecommerceProperties.cuponValue = 23
        MappIntelligenceWatchOS.shared()?.trackCustomEvent(withName: "TestAction", actionProperties: actionProperties, sessionProperties: sessionProperties, userProperties: userProperties, ecommerceProperties: ecommerceProperties)
    }
    
    @IBAction func trackEcommerce() {
        let ecommerceProperties = EcommerceProperties(customProperties: [450 : ["ecommerce1", "ecommerce2"]])
        let product1 = Product()
        product1.name = "Product1Name"
        product1.price = "20$"
        product1.quantity = 34
        let product2 = Product()
        let product3 = Product()
        product3.price = "348$"
        ecommerceProperties.products = [product1, product2, product3];
        ecommerceProperties.currencyCode = "$"
        ecommerceProperties.paymentMethod = "creditCard"
        MappIntelligenceWatchOS.shared()?.trackPage(withName: "TestEcommerce", pageProperties: nil, sessionProperties: nil, userProperties: nil, ecommerceProperties: ecommerceProperties)
    }
    
    @IBAction func optIn() {
        MappIntelligenceWatchOS.shared()?.optIn()
    }
    @IBAction func optOut() {
        MappIntelligenceWatchOS.shared()?.optOutAndSendCurrentData(true)
    }
}
