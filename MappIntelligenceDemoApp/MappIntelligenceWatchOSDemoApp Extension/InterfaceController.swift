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
        let params:[NSNumber:String] = [20: "cp20Override;cp21Override;cp22Override"]
        let categories:NSMutableDictionary = [10: "test"]
        let searchTerm = "testSearchTerm"
        
        let pageEvent = MIPageViewEvent(name: customName)
        pageEvent.pageParameters = MIPageParameters(pageParams: params, pageCategory: categories, search: searchTerm)
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
        let actionProperties = MIEventParameters(parameters: [20:"ck20Override;ck21Override"])
        let sessionParameters = MISessionParameters(parameters: [10: "sessionpar1"])
        
        let userCategories = MIUserCategories()
        userCategories.customCategories = [20:"Test"]
        userCategories.birthday = MIBirthday(day: 12, month: 0, year: 1993)
        userCategories.city = "Paris"
        userCategories.country = "France"
        userCategories.customerId = "CustomerID"
        userCategories.gender = .female
        
        let ecommerceParameters = MIEcommerceParameters()
        ecommerceParameters.couponValue = 23
        
        let actionEvent = MIActionEvent(name: "TestAction")
        actionEvent.eventParameters = actionProperties
        actionEvent.sessionParameters = sessionParameters
        actionEvent.userCategories = userCategories
        actionEvent.ecommerceParameters = ecommerceParameters
        
        MappIntelligenceWatchOS.shared()?.trackAction(actionEvent)
        //MappIntelligenceWatchOS.shared()?.trackCustomEvent(withName: "TestAction", actionProperties: actionProperties, sessionProperties: sessionProperties, userProperties: userProperties, ecommerceProperties: ecommerceProperties, advertisementProperties: nil)
    }
    
    @IBAction func trackEcommerce() {
        let ecommerceParameters = MIEcommerceParameters(customParameters: [540 : "ecommerce1;ecommerce2"])
        let product1 = MIProduct()
        product1.name = "Product1Name"
        product1.cost = 20
        product1.quantity = 34
        let product2 = MIProduct()
        let product3 = MIProduct()
        product3.cost = 348
        ecommerceParameters.status = .addedToBasket
        ecommerceParameters.products = [product1, product2, product3];
        ecommerceParameters.currency = "EUR"
        ecommerceParameters.paymentMethod = "creditCard"
        
        let pageEvent = MIPageViewEvent(name: "TestEcommerce")
        pageEvent.ecommerceParameters = ecommerceParameters
        
        MappIntelligenceWatchOS.shared()?.trackPage(pageEvent)
    }
    
    @IBAction func trackCampaign() {
        let campaignProperties = MICampaignParameters("en.internal.newsletter.2017.05")
        campaignProperties.mediaCode = "abc"
        campaignProperties.oncePerSession = true
        campaignProperties.action = .view
        campaignProperties.customParameters = [1: "ECOMM"]
        
        let actionEvent = MIActionEvent(name: "TestCampaign")
        actionEvent.campaignParameters = campaignProperties
        
        MappIntelligenceWatchOS.shared()?.trackAction(actionEvent)
    }
    @IBAction func optIn() {
        MappIntelligenceWatchOS.shared()?.optIn()
    }
    @IBAction func optOut() {
        MappIntelligenceWatchOS.shared()?.optOutAndSendCurrentData(true)
    }
}
