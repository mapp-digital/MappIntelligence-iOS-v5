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
            product.quantity = 4
            product.productAdvertiseID = 56291;
            product.productSoldOut = 34
            product.productVariant = "variant1"
            return product
    }()
    
    let product2: MIProduct = {
        let product = MIProduct()
            product.name = "Product2"
            product.categories = [2: "ProductCat2"]
            product.cost = 50
            product.productAdvertiseID = 4567585757873737;
            product.productSoldOut = 445
            return product
        
    }()
    
    let product3: MIProduct = {
        let product = MIProduct()
            product.name = "ABC-123"
            product.cost = 99.90
            product.quantity = 2
            product.productSoldOut = false
            product.productVariant = "green"
            product.ecommerceParameters = [1: "product1 param 1"]
            product.categories = [1: "tops", 2 : "noname"]
            return product
        
    }()
    
    let product4: MIProduct = {
        let product = MIProduct()
            product.name = "ABC-456"
            product.cost = 33.33
            product.quantity = 2
            product.productSoldOut = false
            product.productVariant = "blue"
            product.ecommerceParameters = [1: "product2 param 1"]
            product.categories = [1: "t-shirt", 2 : "gucci"]
            return product
        
    }()
    
    let ecommerceParameters1: MIEcommerceParameters = {
        let ecommerceParameter = MIEcommerceParameters()
        ecommerceParameter.customParameters = [2:"goal param 2"]
        return ecommerceParameter
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
        
        ecommerceParameters1.products = [product1, product2]
        ecommerceParameters1.status = .viewed
        ecommerceParameters1.cancellationValue = 2
        ecommerceParameters1.couponValue = 33.899
        ecommerceParameters1.currency = "EUR"
        ecommerceParameters1.markUp = 1
        ecommerceParameters1.orderStatus = "order received"
        ecommerceParameters1.orderID = "ud679adn"
        ecommerceParameters1.orderValue = 456.99
        ecommerceParameters1.paymentMethod = "credit card"
        ecommerceParameters1.returnValue = 3.9
        ecommerceParameters1.returningOrNewCustomer = "new customer"
        ecommerceParameters1.shippingCost = 35.890
        ecommerceParameters1.shippingSpeed = "highest"
        ecommerceParameters1.shippingServiceProvider = "DHL"
        
        let pageEvent = MIPageViewEvent(name: "TrackProductView")
        pageEvent.ecommerceParameters = ecommerceParameters1
        
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
        
        //MappIntelligence.shared()?.trackPage(pageEvent)
        
        let pageEvent1 = MIPageViewEvent(name: "pageName")
        pageEvent1.pageParameters = MIPageParameters(pageParams: [5: "parameter value 5", 777: "this is my page type"], pageCategory: nil, search: nil)
        pageEvent1.ecommerceParameters = ecommerceParameters1
        ecommerceParameters1.products = [product3, product4]
        ecommerceParameters1.status = .addedToBasket
        MappIntelligence.shared()?.trackPage(pageEvent1)
        
    }
    
    func calculateOrderValue() -> NSNumber {
        var totalCost:NSNumber = 0.0
        for product in ecommerceParameters.products ?? [] {
            totalCost = NSNumber(value: totalCost.doubleValue + ((product.cost?.doubleValue ?? 0) * (product.quantity?.doubleValue ?? 1)))
        }
        totalCost = NSNumber(value: totalCost.doubleValue + (ecommerceParameters.shippingCost?.doubleValue ?? 0) - (ecommerceParameters.couponValue?.doubleValue ?? 0))
        return totalCost
    }

    @IBAction func DeleteFromCart(_ sender: Any) {
        let ecommerceParameters1: MIEcommerceParameters =
            MIEcommerceParameters(customParameters: [1 : "ProductParam1", 2 : "ProductParam2"])
        
        product1.quantity = 3
        product2.quantity = 2
        
        ecommerceParameters1.status = .deletedFromBasket
        ecommerceParameters1.products = [product1]
        
        let pageEvent = MIPageViewEvent(name: "TrackProductDeletedToBasket")
        pageEvent.ecommerceParameters = ecommerceParameters1
        
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
    @IBAction func AddToWhishlist(_ sender: Any) {
        let ecommerceParameters1: MIEcommerceParameters =
            MIEcommerceParameters(customParameters: [1 : "ProductParam1", 2 : "ProductParam2"])
        
        product1.quantity = 3
        product2.quantity = 2
        
        ecommerceParameters1.status = .addedToWishlist
        ecommerceParameters1.products = [product1]
        
        let pageEvent = MIPageViewEvent(name: "TrackProductAddedToWhishlist")
        pageEvent.ecommerceParameters = ecommerceParameters1
        
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
    @IBAction func DeleteFromWhishlist(_ sender: Any) {
        let ecommerceParameters1: MIEcommerceParameters =
            MIEcommerceParameters(customParameters: [1 : "ProductParam1", 2 : "ProductParam2"])
        
        product1.quantity = 3
        product2.quantity = 2
        
        ecommerceParameters1.status = .deletedFromWishlist
        ecommerceParameters1.products = [product1]
        
        let pageEvent = MIPageViewEvent(name: "TrackProductDeleteFromBasket")
        pageEvent.ecommerceParameters = ecommerceParameters1
        
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
    @IBAction func Checkout(_ sender: Any) {
        let ecommerceParameters1: MIEcommerceParameters =
            MIEcommerceParameters(customParameters: [1 : "ProductParam1", 2 : "ProductParam2"])
        
        product1.quantity = 3
        product2.quantity = 2
        
        ecommerceParameters1.status = .checkout
        ecommerceParameters1.products = [product1]
        
        let pageEvent = MIPageViewEvent(name: "TrackProductCheckout")
        pageEvent.ecommerceParameters = ecommerceParameters1
        
        MappIntelligence.shared()?.trackPage(pageEvent)
    }
}
