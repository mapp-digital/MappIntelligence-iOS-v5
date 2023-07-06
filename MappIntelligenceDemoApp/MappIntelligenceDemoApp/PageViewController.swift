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
        MappIntelligence.shared()?.trackPage(with: self, pageViewEvent: nil)
    }
    
    @IBAction func trackCustomPage(_ sender: Any) {
        
        //page properties
        let params:[NSNumber : String] = [20: "cp20Override"]
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
        let sessionParameters = MISessionParameters(parameters: [10: "sessionParam1"])
              
        let pageEvent = MIPageViewEvent(name: "test page 1")
        pageEvent.pageParameters = pageParameters
        pageEvent.userCategories = userCategories
        pageEvent.sessionParameters = sessionParameters
        
        let pageEvent1 = MIPageViewEvent(name: "test page 2")
        let pageEvent2 = MIPageViewEvent(name: "test page 3")
        
        MappIntelligence.shared()?.trackPage(pageEvent)
        MappIntelligence.shared()?.trackPage(pageEvent1)
        MappIntelligence.shared()?.trackPage(pageEvent2)
            
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
    @IBAction func testBugWithAnonimousTracking(_ sender: Any) {
        MappIntelligence.shared()?.anonymousTracking = true
        MappIntelligence.shared()?.trackPage(MIPageViewEvent(name: "anonymous_bug_tracking"))
    }
}
