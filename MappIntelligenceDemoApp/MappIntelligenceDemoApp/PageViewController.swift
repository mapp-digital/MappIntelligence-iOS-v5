//
//  PageViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 02/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func trackPage(_ sender: Any) {
        MappIntelligence.shared()?.trackPage(with: self, event: nil)
    }

    @IBAction func trackProduct(_ sender: Any) {
        let ecommerceParameters = MIEcommerceParameters(customParameters: [540 : "ecommerce1;ecommerce2"])
        let product1 = MIProduct()
        product1.name = "Product1Name"
        product1.cost = 20
        product1.quantity = 34
        product1.categories = [1: "Shorts", 2: "Men", 44: "Clothes"]
        let product2 = MIProduct()
        product2.categories = [1: "T-Shirts", 45: "Jackets"]
        let product3 = MIProduct()
        product3.categories = [2: "Women", 46: "Winter"]
        product3.cost = 348
        ecommerceParameters.status = .addedToBasket
        ecommerceParameters.products = [product1, product2, product3];
        ecommerceParameters.currency = "EUR"
        ecommerceParameters.paymentMethod = "creditCard"
        
        let pageEvent = MIPageViewEvent(name: "TrackProductTest")
        pageEvent.ecommerceParameters = ecommerceParameters
        
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
    
    @IBAction func trackCustomPage(_ sender: Any) {
        
        //page properties
        let params:[NSNumber : String] = [20: "cp20Override;cp21Override;cp22Override"]
        let categories:NSMutableDictionary = [10: "test"]
        let searchTerm = "testSearchTerm"
        let pageParameters = MIPageParameters(pageParams: params, pageCategory: categories, search: searchTerm)
        
        //user properties
        let userCategories = MIUserCategories()
        userCategories.customCategories = [20:"userParam1"]
        userCategories.birthday = MIBirthday(day: 12, month: 1, year: 1993)
        userCategories.city = "Paris"
        userCategories.country = "France"
        userCategories.customerId = "CustomerID"
        userCategories.gender = .female
        
        //sessionproperties
        let sessionParameters = MISessionParameters(parameters: [10: "sessionParam1;sessionParam2"])
              
        let pageEvent = MIPageViewEvent(name: "the custom name of page")
        pageEvent.pageParameters = pageParameters
        pageEvent.userCategories = userCategories
        pageEvent.sessionParameters = sessionParameters
        
        MappIntelligence.shared()?.trackPage(pageEvent)
            
    }
    @IBAction func trackCustomPageData(_ sender: Any) {

        //use predefined tags for convenience
//        let pageParam1 = MIParamType.createCustomParam(MIParamType.pageParam(), value: 2)
//        let pageParam9 = MIParamType.createCustomParam(MIParamType.pageParam(), value: 9)
//        let sessionParam20 = MIParamType.createCustomParam(MIParamType.sessionParam(), value: 20)
//
//        let cparams = [
//            MIParams.internalSearch() : "Search term",
//            pageParam1 : "cp2Value",
//            pageParam9 : "cp9Value",
//            sessionParam20: "cs20Value"
//        ]
        
        //or you can just pass strings
        
        let cparams:[String:String] = ["cp10":"cp10Override",
                                       "cg10": "test"]
        
        
        MappIntelligence.shared()?.trackCustomPage("Test", trackingParams: cparams)
    }
}
