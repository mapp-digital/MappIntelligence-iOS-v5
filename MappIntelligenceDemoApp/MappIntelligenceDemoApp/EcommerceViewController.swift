//
//  EcommerceViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Stefan Stevanovic on 24/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class EcommerceViewController: UIViewController {
    
    let product1: MIProduct = {
            let product = MIProduct()
            product.name = "Product1"
            product.categories = [1: "ProductCat1", 2: "ProductCat2"]
            product.cost = 13
            return product
    }()
    
    let product2: MIProduct = {
        let product = MIProduct()
            product.name = "Product2"
            product.categories = [2: "ProductCat2"]
            product.cost = 50
            return product
        
    }()
    
    let ecommerceParameters: MIEcommerceParameters = {
        MIEcommerceParameters(customParameters: [1 : "ProductParam1;ProductParam1", 2 : "ProductParam2"])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    func trackGoal() {
        let ecommerceParameters: MIEcommerceParameters =
            MIEcommerceParameters(customParameters: [1 : "goal value 1"])
        
        let pageEvent = MIPageViewEvent(name: "page name")
        pageEvent.ecommerceParameters = ecommerceParameters
        
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
        
    
    @IBAction func trackEcommerceViewProduct(_ sender: Any) {
        
        let ecommerceParameters1: MIEcommerceParameters =
            MIEcommerceParameters(customParameters: [1 : "ProductParam1", 2 : "ProductParam2"])
        
        ecommerceParameters1.products = [product1]
        ecommerceParameters1.status = .viewed
        
        let pageEvent = MIPageViewEvent(name: "TrackProductView")
        pageEvent.ecommerceParameters = ecommerceParameters1
        
        MappIntelligence.shared()?.trackPage(pageEvent)
        
        ecommerceParameters1.products = [product2]
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
    
    @IBAction func trackEcommerceAddedToBasket(_ sender: Any) {
        let ecommerceParameters1: MIEcommerceParameters =
            MIEcommerceParameters(customParameters: [1 : "ProductParam1", 2 : "ProductParam2"])
        
        product1.quantity = 3
        product2.quantity = 2
        
        ecommerceParameters1.status = .addedToBasket
        ecommerceParameters1.products = [product1]
        
        let pageEvent = MIPageViewEvent(name: "TrackProductAddedToBasket")
        pageEvent.ecommerceParameters = ecommerceParameters1
        
        MappIntelligence.shared()?.trackPage(pageEvent)
        
        ecommerceParameters1.products = [product2]
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
    
    @IBAction func trackEcommerceConfirmation(_ sender: Any) {
        
        product1.quantity = 3
        product2.quantity = 2
        
        ecommerceParameters.products = [product1, product2]
        ecommerceParameters.currency = "EUR"
        ecommerceParameters.orderID = "1234nb5"
        ecommerceParameters.paymentMethod = "Credit Card"
        ecommerceParameters.shippingServiceProvider = "DHL"
        ecommerceParameters.shippingSpeed = "express"
        ecommerceParameters.shippingCost = 20
        ecommerceParameters.couponValue = 10
        ecommerceParameters.orderValue = calculateOrderValue()
        ecommerceParameters.status = .purchased
        
        let pageEvent = MIPageViewEvent(name: "TrackProductConfirmed")
        pageEvent.ecommerceParameters = ecommerceParameters
        
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
    
    func calculateOrderValue() -> NSNumber {
        var totalCost:NSNumber = 0.0
        for product in ecommerceParameters.products ?? [] {
            totalCost = NSNumber(value: totalCost.doubleValue + ((product.cost?.doubleValue ?? 0) * (product.quantity?.doubleValue ?? 1)))
        }
        totalCost = NSNumber(value: totalCost.doubleValue + (ecommerceParameters.shippingCost?.doubleValue ?? 0) - (ecommerceParameters.couponValue?.doubleValue ?? 0))
        return totalCost
    }

}