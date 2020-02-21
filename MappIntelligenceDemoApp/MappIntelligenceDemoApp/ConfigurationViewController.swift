//
//  ConfigurationViewController.swift
//  DemoWebtrekkApp
//
//  Created by Vladan Randjelovic on 23/01/2020.
//  Copyright © 2020 Vladan Randjelovic. All rights reserved.
//

import UIKit

class ConfigurationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
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
    var selectedLogLevel: String?
    var logLevelIndex = 0
    
    var logLevelList = ["Debug","Warning","Error","Fault","Info","All"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
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
        self.setConfiguration(autoTracking: autoTrackingValue, batchSupport: batchSupportValue, requestsPerBatch: (setNumberOfRequestsPerBatchTF!.text! as NSString).integerValue, requestsInterval: (setRequestsTimeIntervalTF!.text! as NSString).floatValue, logLevel: logLevelIndex+1 , trackingDomain: setTrackingDomainTF.text!, trackingIDs: setTrackingIDsTF.text!, viewControllerAutoTracking: vcAutoTracking)
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }
       
       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return logLevelList.count
       }
    
    func createPickerView() {
           let pickerView = UIPickerView()
           pickerView.delegate = self
           setLogLevelTF.inputView = pickerView
    }
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       setLogLevelTF.inputAccessoryView = toolBar
       setLogLevelTF.resignFirstResponder()
    }
    @objc func action() {
          view.endEditing(true)
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return logLevelList[row] // dropdown item
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    logLevelIndex = row
    selectedLogLevel = logLevelList[row] // selected item
    setLogLevelTF.text = selectedLogLevel
    }
    
}
