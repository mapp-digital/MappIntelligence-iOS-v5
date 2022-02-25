//
//  FormViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Stefan Stevanovic on 26.1.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

class FormViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var name1TextField: UITextField!
    @IBOutlet weak var name2TextField: UITextField!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var name3TextView: UITextView!
    @IBOutlet weak var anynonimusSwitch: UISwitch!
    @IBOutlet weak var ConfirmButton: UIButton!
    
    var items = [["Item1", "Item2", "Item3", "Item4"], ["1", "2", "3", "4", "5"]]
    var isAnonymusSelected = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        name1TextField.tag = 11
        name2TextField.tag = 22
        name3TextView.tag = 33
        switchButton.tag = 44
        anynonimusSwitch.tag = 55
        view.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let parameters = MIFormParameters();
        parameters.renameFields = [11:"Zivko"]
        parameters.changeFieldsValue = [22:"zivorad_bekrija"]
        parameters.fullContentSpecificFields = [33]
        parameters.confirmButton = true
        parameters.anonymous = self.anynonimusSwitch.isOn
//        let alert = UIAlertController(title: "Alert", message: "IsFocused: \(self.name1TextField.isFocused), \(name3TextView.isFocused), \(name2TextField.isFocused) , \(switchButton.isFocused), \(anynonimusSwitch.isFocused), \(ConfirmButton.isFocused)", preferredStyle: .alert)
//        self.present(alert, animated: true, completion: nil)
        MappIntelligence.shared()?.formTracking(parameters)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let parameters = MIFormParameters();
        parameters.fieldIds = [11,33]
        parameters.fullContentSpecificFields = [33]
        parameters.confirmButton = false
        parameters.anonymous = self.anynonimusSwitch.isOn
        MappIntelligence.shared()?.formTracking(parameters)
    }
    
    @IBAction func pathAnylisesPressed(_ sender: Any) {
        let parameters = MIFormParameters();
        parameters.pathAnalysis = [44,55,33,44,55]
        parameters.confirmButton = true
        parameters.anonymous = self.anynonimusSwitch.isOn
        MappIntelligence.shared()?.formTracking(parameters)
        
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
}
