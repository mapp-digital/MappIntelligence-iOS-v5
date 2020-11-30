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
        
        let pageEvent = MIPageViewEvent(name: customName)
        pageEvent.pageProperties = MIPageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm)
        MappIntelligenceWatchOS.shared()?.trackPage(pageEvent)
        //MappIntelligenceWatchOS.shared()?.trackPage(withName: customName, pageProperties: MIPageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm), sessionProperties: nil, userProperties: nil, ecommerceProperties: nil, advertisementProperties: nil)
    }
    @IBAction func reset() {
        MappIntelligenceWatchOS.shared()?.reset()
    }
    @IBAction func InitAgain() {
        MappIntelligenceWatchOS.shared()?.initWithConfiguration([385255285199574 as UInt64], onTrackdomain: "https://q3.webtrekk.net")
    }
    @IBAction func trackAction() {
        let actionProperties = MIActionProperties(properties:  [20:["ck20Override","ck21Override"]])
        let sessionProperties = MISessionProperties(properties: [10: ["sessionpar1"]])
        
        let userProperties = MIUserProperties()
        userProperties.customProperties = [20:["Test"]]
        userProperties.birthday = MIBirthday(day: 12, month: 0, year: 1993)
        userProperties.city = "Paris"
        userProperties.country = "France"
        userProperties.customerId = "CustomerID"
        userProperties.gender = .female
        
        let ecommerceProperties = MIEcommerceProperties()
        ecommerceProperties.couponValue = 23
        
        let actionEvent = MIActionEvent(name: "TestAction")
        actionEvent.actionProperties = actionProperties
        actionEvent.sessionProperties = sessionProperties
        actionEvent.userProperties = userProperties
        actionEvent.ecommerceProperties = ecommerceProperties
        
        MappIntelligenceWatchOS.shared()?.trackAction(actionEvent)
        //MappIntelligenceWatchOS.shared()?.trackCustomEvent(withName: "TestAction", actionProperties: actionProperties, sessionProperties: sessionProperties, userProperties: userProperties, ecommerceProperties: ecommerceProperties, advertisementProperties: nil)
    }
    
    @IBAction func trackEcommerce() {
        let ecommerceProperties = MIEcommerceProperties(customProperties: [540 : ["ecommerce1", "ecommerce2"]])
        let product1 = MIProduct()
        product1.name = "Product1Name"
        product1.cost = 20
        product1.quantity = 34
        let product2 = MIProduct()
        let product3 = MIProduct()
        product3.cost = 348
        ecommerceProperties.status = .addedToBasket
        ecommerceProperties.products = [product1, product2, product3];
        ecommerceProperties.currency = "EUR"
        ecommerceProperties.paymentMethod = "creditCard"
        
        let pageEvent = MIPageViewEvent(name: "TestEcommerce")
        pageEvent.ecommerceProperties = ecommerceProperties
        
        MappIntelligenceWatchOS.shared()?.trackPage(pageEvent)
    }
    
    @IBAction func trackCampaign() {
        let advertisementProperties = MIAdvertisementProperties("en.internal.newsletter.2017.05")
        advertisementProperties.mediaCode = "abc"
        advertisementProperties.oncePerSession = true
        advertisementProperties.action = .view
        advertisementProperties.customProperties = [1: ["ECOMM"]]
        
        let actionEvent = MIActionEvent(name: "TestCampaign")
        actionEvent.advertisementProperties = advertisementProperties
        
        MappIntelligenceWatchOS.shared()?.trackAction(actionEvent)
    }
    @IBAction func optIn() {
        MappIntelligenceWatchOS.shared()?.optIn()
    }
    @IBAction func optOut() {
        MappIntelligenceWatchOS.shared()?.optOutAndSendCurrentData(true)
    }
}
