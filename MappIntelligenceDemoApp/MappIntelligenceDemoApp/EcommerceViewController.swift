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
    
    let ecommerceProperties: MIEcommerceProperties = {
            MIEcommerceProperties(customProperties: [1 : "ProductParam1;ProductParam1", 2 : "ProductParam2"])
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func trackEcommerceViewProduct(_ sender: Any) {
        
        ecommerceProperties.products = [product1, product2]
        ecommerceProperties.status = .viewed
        
        let pageEvent = MIPageViewEvent(name: "TrackProductView")
        pageEvent.ecommerceProperties = ecommerceProperties
        
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
    
    @IBAction func trackEcommerceAddedToBasket(_ sender: Any) {
        
        product1.quantity = 3
        product2.quantity = 2
        
        ecommerceProperties.status = .addedToBasket
        ecommerceProperties.products = [product1, product2]
        
        let pageEvent = MIPageViewEvent(name: "TrackProductAddedToBasket")
        pageEvent.ecommerceProperties = ecommerceProperties
        
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
    
    @IBAction func trackEcommerceConfirmation(_ sender: Any) {
        
        product1.quantity = 3
        product2.quantity = 2
        
        ecommerceProperties.products = [product1, product2]
        ecommerceProperties.currency = "EUR"
        ecommerceProperties.orderID = "1234nb5"
        ecommerceProperties.paymentMethod = "Credit Card"
        ecommerceProperties.shippingServiceProvider = "DHL"
        ecommerceProperties.shippingSpeed = "express"
        ecommerceProperties.shippingCost = 20
        ecommerceProperties.couponValue = 10
        ecommerceProperties.orderValue = calculateOrderValue()
        ecommerceProperties.status = .purchased
        
        let pageEvent = MIPageViewEvent(name: "TrackProductConfirmed")
        pageEvent.ecommerceProperties = ecommerceProperties
        
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
    
    func calculateOrderValue() -> NSNumber {
        var totalCost:NSNumber = 0.0
        for product in ecommerceProperties.products ?? [] {
            totalCost = NSNumber(value: totalCost.doubleValue + ((product.cost?.doubleValue ?? 0) * (product.quantity?.doubleValue ?? 1)))
        }
        totalCost = NSNumber(value: totalCost.doubleValue + (ecommerceProperties.shippingCost?.doubleValue ?? 0) - (ecommerceProperties.couponValue?.doubleValue ?? 0))
        return totalCost
    }

}
