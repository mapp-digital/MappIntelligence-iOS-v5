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
        MappIntelligence.shared()?.optOut(with: true, andSendCurrentData: true)
    }
    @IBAction func optOutAndDontSendData(_ sender: Any) {
        MappIntelligence.shared()?.optOut(with: true, andSendCurrentData: false)
    }
    
    @IBAction func resetInstance(_ sender: Any) {
        MappIntelligence.shared()?.reset()
    }
    
    @IBAction func optIn(_ sender: Any) {
        MappIntelligence.shared()?.optOut(with: false, andSendCurrentData: false)
    }
    @IBAction func sendActionEvent(_ sender: Any) {
        let actionProperties = ActionProperties(name: "TestAction", andDetails: [20:["ck20Override","ck21Override"]])
        let sessionProperties = SessionProperties(witProperties: [10: ["sessionpar1"]])
        MappIntelligence.shared()?.trackCustomEvent(with: actionProperties, sessionProperties: sessionProperties)
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

