//
//  ViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Vladan Randjelovic on 20/01/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var requestIDTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.tap)))
        self.view.isUserInteractionEnabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MappIntelligence.shared()?.trackPage(with: self, pageProperties: nil, sessionProperties: nil, userProperties: nil, ecommerceProperties: nil, advertisementProperties: nil)
    }
    @IBAction func removeRequestFromDatabase(_ sender: Any) {
        guard let requestID = Int32(requestIDTextField.text ?? "0") else {return}
        MappIntelligence.shared()?.removeRequestFromDatabase(withID: requestID)
    }
    @IBAction func printAllRequests(_ sender: Any) {
        MappIntelligence.shared()?.printAllRequestFromDatabase()
    }
    
    @IBAction func moveToConfigurationScreen(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "configuration")
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction func optOutAndSendData(_ sender: Any) {
        MappIntelligence.shared()?.optOutAndSendCurrentData(true)
    }
    @IBAction func optOutAndDontSendData(_ sender: Any) {
        MappIntelligence.shared()?.optOutAndSendCurrentData(false)
    }
    
    @IBAction func resetInstance(_ sender: Any) {
        MappIntelligence.shared()?.reset()
        let bundles = Bundle.allBundles
        var path = ""
        for bundle in bundles {
            if bundle.path(forResource: "SetupForLocalTesting", ofType: "plist") != nil {
                path = bundle.path(forResource: "SetupForLocalTesting", ofType: "plist") ?? ""
            }
        }
        let dict = NSDictionary(contentsOfFile: path) as Dictionary?
        let array = [(dict?["track_ids" as NSObject]?.intValue) ?? 0]
        let domain = dict?["domain" as NSObject];
        MappIntelligence.shared()?.initWithConfiguration(array, onTrackdomain: domain as! String);
        MappIntelligence.shared()?.requestInterval = 1 * 60;
    }
    
    @IBAction func optIn(_ sender: Any) {
        MappIntelligence.shared()?.optIn()
    }
    @IBAction func sendActionEvent(_ sender: Any) {
        let actionProperties = MIActionProperties(properties:  [20:["ck20Override","ck21Override"]])
        let sessionProperties = MISessionProperties(properties: [10: ["018", "Over"]])
        let userProperties = MIUserProperties()
        userProperties.customProperties = [20:["Test"]]
        userProperties.birthday = Birthday(day: 12, month: 0, year: 1993)
        userProperties.city = "Paris"
        userProperties.country = "France"
        userProperties.customerId = "CustomerID"
        userProperties.gender = .female
        let ecommerceProperties = MIEcommerceProperties()
        ecommerceProperties.cuponValue = 33
        MappIntelligence.shared()?.trackCustomEvent(withName: "TestAction", actionProperties: actionProperties, sessionProperties: sessionProperties, userProperties: userProperties, ecommerceProperties: ecommerceProperties, advertisementProperties: nil)
    }
    
    @IBAction func sendEcommerceEvent(_ sender: Any) {
        let ecommerceProperties = MIEcommerceProperties(customProperties: [540 : ["ecommerce1", "ecommerce2"]])
        let product1 = Product()
        product1.name = "Product1Name"
        product1.price = "20$"
        product1.quantity = 34
        let product2 = Product()
        let product3 = Product()
        product3.price = "348$"
        ecommerceProperties.products = [product1, product2, product3];
        ecommerceProperties.currencyCode = "$"
        ecommerceProperties.paymentMethod = "creditCard"
        MappIntelligence.shared()?.trackPage(with: self, pageProperties: nil, sessionProperties: nil, userProperties: nil, ecommerceProperties: ecommerceProperties, advertisementProperties: nil)
    }
    
    @IBAction func sendCampaignEvent(_ sender: Any) {
        let advertisementProperties = AdvertisementProperties("en.internal.newsletter.2017.05")
        advertisementProperties.mediaCode = "abc"
        advertisementProperties.oncePerSession = true
        advertisementProperties.action = .view
        advertisementProperties.customProperties = [1: ["ECOMM"]]
        
        MappIntelligence.shared()?.trackCustomEvent(withName: "TestCampaign", actionProperties: nil, sessionProperties: nil, userProperties: nil, ecommerceProperties: nil, advertisementProperties: advertisementProperties)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func tap() {
        self.requestIDTextField.endEditing(true)
    }
}

