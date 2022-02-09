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
    
    var items = [["Item1", "Item2", "Item3", "Item4"], ["1", "2", "3", "4", "5"]]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        name1TextField.tag = 11
        name2TextField.tag = 22
        name3TextView.tag = 33
        switchButton.tag = 44
        anynonimusSwitch.tag = 55
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let parameters = MIFormParameters();
        parameters.renameFields = [11:"Zivko"]
        parameters.changeFieldsValue = [22:"zivorad_bekrija"]
        parameters.fullContentSpecificFields = [33]
        MappIntelligence.shared()?.formTracking(parameters)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
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
