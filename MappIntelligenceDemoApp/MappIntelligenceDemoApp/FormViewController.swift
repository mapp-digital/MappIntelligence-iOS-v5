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
    
    var items = ["Item1", "Item2", "Item3", "Item4"]
   
    override func viewDidLoad() {
        super.viewDidLoad()
        name1TextField.tag = 11
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
    }
    
    // #pragma_mark uipicker dalegate methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
}
