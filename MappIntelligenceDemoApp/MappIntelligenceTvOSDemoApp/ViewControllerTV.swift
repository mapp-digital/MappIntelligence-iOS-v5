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
        let params:[NSNumber:String] = [20: "cp20Override"]
        let categories:NSMutableDictionary = [10: "test"]
        let searchTerm = "testSearchTerm"
        let pageEvent = MIPageViewEvent()
        pageEvent.pageParameters = MIPageParameters(pageParams: params, pageCategory: categories, search: searchTerm)
        MappIntelligencetvOS.shared()?.trackPage(with: self, event: pageEvent)
    }
    
    @IBAction func trackCustomString(_ sender: Any) {
        let customName = "the custom name of page"
        let params:[NSNumber:String] = [20: "cp20Override"]
        let categories:NSMutableDictionary = [10: "test"]
        let searchTerm = "testSearchTerm"
        let sessionParameters = MISessionParameters(parameters: [10: "sessionpar1"])
        let pageEvent = MIPageViewEvent(name: customName)
        pageEvent.pageParameters = MIPageParameters(pageParams: params, pageCategory: categories, search: searchTerm)
        pageEvent.sessionParameters = sessionParameters
        
        MappIntelligencetvOS.shared()?.trackPage(pageEvent)
    }

    @IBAction func trackAction(_ sender: Any) {
        let eventParameters = MIEventParameters(parameters: [20:"ck20Override"])
        let sessionParameters = MISessionParameters(parameters: [10: "sessionpar1"])
        let userCategories = MIUserCategories()
        userCategories.customCategories = [20:"Test"]
        userCategories.birthday = MIBirthday(day: 12, month: 0, year: 1993)
        userCategories.city = "Paris"
        userCategories.country = "France"
        userCategories.customerId = "CustomerID"
        userCategories.gender = .female
        let ecommerceParameters = MIEcommerceParameters()
        ecommerceParameters.couponValue = 99
        
        let actionEvent = MIActionEvent(name: "TestAction")
        actionEvent.eventParameters = eventParameters
        actionEvent.sessionParameters = sessionParameters
        actionEvent.userCategories = userCategories
        actionEvent.ecommerceParameters = ecommerceParameters
        
        MappIntelligencetvOS.shared()?.trackAction(actionEvent)
    }

    @IBAction func trackEcommerce(_ sender: Any) {
        let ecommerceParameters = MIEcommerceParameters(customParameters: [540 : "ecommerce1;ecommerce2"])
        let product1 = MIProduct()
        product1.name = "Product1Name"
        product1.cost = 20
        product1.quantity = 34
        let product2 = MIProduct()
        let product3 = MIProduct()
        product3.cost = 348
        ecommerceParameters.status = .purchased
        ecommerceParameters.products = [product1, product2, product3]
        ecommerceParameters.currency = "$"
        ecommerceParameters.paymentMethod = "creditCard"
        
        let pageEvent = MIPageViewEvent()
        pageEvent.ecommerceParameters = ecommerceParameters
        
        MappIntelligencetvOS.shared()?.trackPage(with: self, event: pageEvent)
    }

    @IBAction func trackCampaign(_ sender: Any) {
        let campaignProperties = MICampaignParameters("en.internal.newsletter.2017.05")
        campaignProperties.mediaCode = "abc"
        campaignProperties.oncePerSession = true
        campaignProperties.action = .view
        campaignProperties.customParameters = [1: "ECOMM"]
        
        let actionEvent = MIActionEvent(name: "TestCampaign")
        actionEvent.campaignParameters = campaignProperties
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

