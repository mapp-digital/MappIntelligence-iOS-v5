//
//  ConfigurationViewController.swift
//  DemoWebtrekkApp
//
//  Created by Vladan Randjelovic on 23/01/2020.
//  Copyright © 2020 Vladan Randjelovic. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController {

    @IBOutlet weak var enableAutoTrackingSwitch: UISwitch!
    @IBOutlet weak var enableBatchSupportSwitch: UISwitch!
    @IBOutlet weak var enableViewControllerAutoTracking: UISwitch!
    @IBOutlet weak var setLogLevelTF: UITextField!
    @IBOutlet weak var setNumberOfRequestsPerBatchTF: UITextField!
    @IBOutlet weak var setRequestsTimeIntervalTF: UITextField!
    @IBOutlet weak var setTrackingDomainTF: UITextField!
    @IBOutlet weak var setTrackingIDsTF: UITextField!
    @IBOutlet weak var everID: UILabel!
    var dictionary = [NSString: Any]()
    var autoTrackingValue = true
    var batchSupportValue = false
    var vcAutoTracking = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
               self.view.addGestureRecognizer(tapGesture)
        MappIntelligence.shared()?.trackPage(self)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        setLogLevelTF.resignFirstResponder()
        setNumberOfRequestsPerBatchTF.resignFirstResponder()
        setRequestsTimeIntervalTF.resignFirstResponder()
        setTrackingDomainTF.resignFirstResponder()
        setTrackingIDsTF.resignFirstResponder()

       }

    func setConfiguration(autoTracking: Bool, batchSupport: Bool, requestsPerBatch: Int, requestsInterval: Float, logLevel:Int,
                          trackingDomain: String, trackingIDs: String, viewControllerAutoTracking: Bool) {
        dictionary = ["auto_tracking": autoTracking, "batch_support": batchSupport, "request_per_batch": requestsPerBatch, "requests_interval": requestsInterval, "log_level": logLevel, "track_domain": trackingDomain,
                      "track_ids": trackingIDs, "view_controller_auto_tracking": viewControllerAutoTracking]
//        Webtrekk.init(dictionary: dictionary)
    }
    @IBAction func setConfiguration(_ sender: Any) {
        self.setConfiguration(autoTracking: autoTrackingValue, batchSupport: batchSupportValue, requestsPerBatch: (setNumberOfRequestsPerBatchTF!.text! as NSString).integerValue, requestsInterval: (setRequestsTimeIntervalTF!.text! as NSString).floatValue, logLevel: (setLogLevelTF!.text! as NSString).integerValue , trackingDomain: setTrackingDomainTF.text!, trackingIDs: setTrackingIDsTF.text!, viewControllerAutoTracking: vcAutoTracking)
        MappIntelligence.setConfigurationWith(dictionary)
    }

    @IBAction func enableAutoTracking(_ sender: Any) {
        autoTrackingValue = enableAutoTrackingSwitch.isOn
    }
    @IBAction func enableBatchSupport(_ sender: Any) {
        batchSupportValue = enableBatchSupportSwitch.isOn
    }
    @IBAction func enableVCAutoTracking(_ sender: Any) {
        vcAutoTracking = enableViewControllerAutoTracking.isOn
    }
    @IBAction func setRequestTime(_ sender: Any) {
    }
    @IBAction func setNumberOfRequests(_ sender: Any) {
    }
    @IBAction func setLogLevel(_ sender: Any) {
    }
    @IBAction func setTrackingIDs(_ sender: Any) {
    }
    @IBAction func setTrackDomain(_ sender: Any) {
    }
}
