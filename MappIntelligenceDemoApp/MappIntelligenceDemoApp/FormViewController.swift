//
//  FormViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Stefan Stevanovic on 26.1.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

class FormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var name1TextField: UITextField!
    @IBOutlet weak var name2TextField: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var name3TextView: UITextView!
    @IBOutlet weak var anonymousSwitch: UISwitch!
    @IBOutlet weak var testPickerView: UIPickerView!
    @IBOutlet weak var testSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ConfirmButton: UIButton!
    
    var items = [["Item1", "Item2", "Item3", "Item4"], ["1", "2", "3", "4", "5"]]
    var isAnonymousSelected = false
    
    //this array will be used to track fields for path anylisis
    var pathAnalysisTags:[Int] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        testSegmentedControl.setTitleColor(.white)
        
        name1TextField.tag = 11
        name2TextField.tag = 22
        name3TextView.tag = 33
        switchButton.tag = 44
        anonymousSwitch.tag = 55
        testPickerView.tag = 66
        testSegmentedControl.tag = 77
        
        //add accessibility labels
        name1TextField.accessibilityLabel = "firstTextField"
        name2TextField.accessibilityLabel = "secondTextField"
        name3TextView.accessibilityLabel = "firstTextView"
        switchButton.accessibilityLabel = "firstSwitchButton"
        testPickerView.accessibilityLabel = "firstPicker"
        testSegmentedControl.accessibilityLabel = "testSegment"
        
        //adding delegates for switch methods
        switchButton.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: UIControl.Event.valueChanged)
        anonymousSwitch.addTarget(self, action: #selector(onSwitchValueChanged(_:)), for: UIControl.Event.valueChanged)
        name1TextField.delegate = self
        name2TextField.delegate = self
        name3TextView.delegate = self
        
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let parameters = MIFormParameters();
        parameters.renameFields = [11:"rename_field1"]
        parameters.changeFieldsValue = [22:"changed_value1"]
        parameters.fullContentSpecificFields = [33]
        parameters.confirmButton = true
        parameters.anonymous = self.anonymousSwitch.isOn as NSNumber
        MappIntelligence.shared()?.formTracking(parameters)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let parameters = MIFormParameters();
        parameters.formName = "testFormName"
        parameters.fieldIds = [11,33]
        parameters.fullContentSpecificFields = [33]
        parameters.confirmButton = false
        parameters.anonymous = self.anonymousSwitch.isOn as NSNumber
        MappIntelligence.shared()?.formTracking(parameters)
    }
    
    @IBAction func pathAnylisesPressed(_ sender: Any) {
        let parameters = MIFormParameters();
        parameters.pathAnalysis = NSMutableArray(array: pathAnalysisTags)
        parameters.confirmButton = true
        parameters.anonymousSpecificFields = [55]
        MappIntelligence.shared()?.formTracking(parameters)
        pathAnalysisTags.removeAll()
        
    }
    // #pragma_mark uipicker dalegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items[component].count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[component][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let pickerLabel = UILabel()
        pickerLabel.textAlignment = NSTextAlignment.center
        pickerLabel.text = items[component][row]
        return pickerLabel
    }
    
    //this delegate methods will be used for path anylisis
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag != 0) {
            pathAnalysisTags.append(pickerView.tag)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.tag != 0) {
            pathAnalysisTags.append(textView.tag)
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.tag != 0) {
            pathAnalysisTags.append(textField.tag)
        }
    }
    @objc func onSwitchValueChanged(_ switchTmp: UISwitch) {
        if(switchTmp.tag != 0) {
            pathAnalysisTags.append(switchTmp.tag)
        }
    }
}


extension UISegmentedControl {

    func setTitleColor(_ color: UIColor, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.foregroundColor] = color
        self.setTitleTextAttributes(attributes, for: state)
    }
    
    func setTitleFont(_ font: UIFont, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.font] = font
        self.setTitleTextAttributes(attributes, for: state)
    }

}
