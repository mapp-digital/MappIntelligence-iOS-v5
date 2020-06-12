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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func removeRequestFromDatabase(_ sender: Any) {
    }
    @IBAction func printAllRequests(_ sender: Any) {
        MappIntelligence.shared()?.printAllRequestFromDatabase()
    }
    
    @IBAction func moveToConfigurationScreen(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "configuration")
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func resetInstance(_ sender: Any) {
        MappIntelligence.shared()?.reset()
    }
}

