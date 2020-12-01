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
        let pageEvent = MIPageViewEvent()
        pageEvent.pageProperties = MIPageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm)
        MappIntelligencetvOS.shared()?.trackPage(with: self, andEvent: pageEvent)
    }
    
    @IBAction func trackCustomString(_ sender: Any) {
        let customName = "the custom name of page"
        let params:[NSNumber:[String]] = [20: ["cp20Override", "cp21Override", "cp22Override"]]
        let categories:NSMutableDictionary = [10: ["test"]]
        let searchTerm = "testSearchTerm"
        let sessionProperties = MISessionProperties(properties: [10: ["sessionpar1"]])
        let pageEvent = MIPageViewEvent(name: customName)
        pageEvent.pageProperties = MIPageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm)
        pageEvent.sessionProperties = sessionProperties
        
        MappIntelligencetvOS.shared()?.trackPage(pageEvent)
    }

    @IBAction func trackAction(_ sender: Any) {
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
        ecommerceProperties.couponValue = 99
        
        let actionEvent = MIActionEvent(name: "TestAction")
        actionEvent.actionProperties = actionProperties
        actionEvent.sessionProperties = sessionProperties
        actionEvent.userProperties = userProperties
        actionEvent.ecommerceProperties = ecommerceProperties
        
        MappIntelligencetvOS.shared()?.trackAction(actionEvent)
    }

    @IBAction func trackEcommerce(_ sender: Any) {
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
        ecommerceProperties.currency = "$"
        ecommerceProperties.paymentMethod = "creditCard"
        
        let pageEvent = MIPageViewEvent()
        pageEvent.ecommerceProperties = ecommerceProperties
        
        MappIntelligencetvOS.shared()?.trackPage(with: self, andEvent: pageEvent)
    }

    @IBAction func trackCampaign(_ sender: Any) {
        let campaignProperties = MICampaignProperties("en.internal.newsletter.2017.05")
        campaignProperties.mediaCode = "abc"
        campaignProperties.oncePerSession = true
        campaignProperties.action = .view
        campaignProperties.customProperties = [1: ["ECOMM"]]
        
        let actionEvent = MIActionEvent(name: "TestCampaign")
        actionEvent.campaignProperties = campaignProperties
        MappIntelligencetvOS.shared()?.trackAction(actionEvent)
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

