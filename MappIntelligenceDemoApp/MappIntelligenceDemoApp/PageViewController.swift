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
        MappIntelligence.shared()?.trackPage(with: self, andEvent: MIPageViewEvent())
    }
    @IBAction func trackCustomPage(_ sender: Any) {
        
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
        
        let pageEvent = MIPageViewEvent()
        pageEvent.ecommerceProperties = ecommerceProperties
    }
}
