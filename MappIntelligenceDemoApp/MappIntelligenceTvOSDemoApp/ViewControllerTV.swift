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
        let params:NSMutableDictionary = [20: ["cp20Override", "cp21Override", "cp22Override"]]
        let categories:NSMutableDictionary = [10: ["test"]]
        let searchTerm = "testSearchTerm"
        MappIntelligencetvOS.shared()?.trackPage(with: self, andWith: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm))
    }
    
    @IBAction func trackCustomString(_ sender: Any) {
        let customName = "the custom name of page"
        let params:NSMutableDictionary = [20: ["cp20Override", "cp21Override", "cp22Override"]]
        let categories:NSMutableDictionary = [10: ["test"]]
        let searchTerm = "testSearchTerm"
        MappIntelligencetvOS.shared()?.trackPage(withName: customName, andWith: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm))
    }
}

