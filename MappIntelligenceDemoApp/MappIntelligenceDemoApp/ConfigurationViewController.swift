//
//  ConfigurationViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Vladan Randjelovic on 23/01/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
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
    var configurationDetails = [NSString: Any]()
    var autoTrackingValue = true
    var batchSupportValue = false
    var vcAutoTracking = true
    var selectedLogLevel: String?
    var logLevelIndex = 0
    
    var logLevelList = ["All", "Debug","Warning","Error","Fault","Info", "None"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createPickerView()
        dismissPickerView()
        setTrackingDomainTF.delegate = self
        setTrackingIDsTF.delegate = self
        setNumberOfRequestsPerBatchTF.delegate = self
        setRequestsTimeIntervalTF.delegate = self
        setupToolBarForNumberPadKeyboard()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
               self.view.addGestureRecognizer(tapGesture)
        
       // MappIntelligence.shared()?.trackPage(with: PageViewEvent())
        let customName = "the custom name of page"
        let params:NSMutableDictionary = [20: ["cp20Override", "cp21Override", "cp22Override"]]
        let categories:NSMutableDictionary = [10: ["test"]]
        let searchTerm = "testSearchTerm"
        let sessionProperties = SessionProperties(properties: [10: ["sessionpar1"]])

        MappIntelligence.shared()?.trackPage(withName: customName, pageProperties: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm), sessionProperties: sessionProperties)
        //or you can use this
        MappIntelligence.shared()?.trackPage(with: self, pageProperties: PageProperties(pageParams: params, andWithPageCategory: categories, andWithSearch: searchTerm), sessionProperties: sessionProperties)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        setLogLevelTF.resignFirstResponder()
        setNumberOfRequestsPerBatchTF.resignFirstResponder()
        setRequestsTimeIntervalTF.resignFirstResponder()
        setTrackingDomainTF.resignFirstResponder()
        setTrackingIDsTF.resignFirstResponder()

       }
    
    @IBAction func setConfiguration(_ sender: Any) {
        
        MappIntelligence.shared()?.initWithConfiguration(((setTrackingIDsTF.text?.split(separator: ","))!), onTrackdomain: setTrackingDomainTF.text ?? "")
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
        pickerView.accessibilityLabel = "logLevelPicker"
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
        setLogLevelTF.text = logLevelList[row]
        return logLevelList[row] // dropdown item
    }
    
    func setupToolBarForNumberPadKeyboard() {
        let toolBar = UIToolbar(frame: CGRect(origin: .zero, size: .init(width: view.frame.size.width, height: 30)))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolBar.setItems([flexSpace, doneButton], animated: false)
        toolBar.sizeToFit()
        setRequestsTimeIntervalTF.inputAccessoryView = toolBar
        setNumberOfRequestsPerBatchTF.inputAccessoryView = toolBar
    }
    
    @objc func doneButtonAction() {
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.view(forRow: 0, forComponent: component)?.accessibilityLabel = "all"
        pickerView.view(forRow: 1, forComponent: component)?.accessibilityLabel = "debug"
        pickerView.view(forRow: 2, forComponent: component)?.accessibilityLabel = "warning"
        pickerView.view(forRow: 3, forComponent: component)?.accessibilityLabel = "error"
        pickerView.view(forRow: 4, forComponent: component)?.accessibilityLabel = "fault"
        pickerView.view(forRow: 5, forComponent: component)?.accessibilityLabel = "info"
        pickerView.view(forRow: 6, forComponent: component)?.accessibilityLabel = "none"
    selectedLogLevel = logLevelList[row] // selected item
    setLogLevelTF.text = selectedLogLevel
    logLevelIndex = row
    }
    
}
