//
//  MediaViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 29/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController {

    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var positionTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func trackMedia1(_ sender: Any) {
//        let mediaProperties = MIMediaParameters("TestVideo", action: "view", position: 12, duration: 120)
//        mediaProperties.customCategories = [20:"mediaCat"]
//        let mediaEvent = MIMediaEvent(pageName: "Test", parameters: mediaProperties)
        let mediaProperties = MIMediaParameters("TestVideo", action: "play", position: 0, duration: 0)
        let mediaEvent = MIMediaEvent(pageName: "Test", parameters: mediaProperties)
        MappIntelligence.shared()?.trackMedia(mediaEvent)
    }
    
    @IBAction func trackMediaPlayer2(_ sender: Any) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "MediaExample")) as! MediaPlayerViewController
        vc.streamUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func playButtonPressed(_ sender: Any) {
        let duration = Double(durationTextField.text ?? "0") ?? 0
        let position = Double(positionTextfield.text ?? "0") ?? 0
        let mediaProperties = MIMediaParameters("TestVideo", action: "play", position: position as NSNumber, duration: duration as NSNumber)
        let mediaEvent = MIMediaEvent(pageName: "Test", parameters: mediaProperties)
        MappIntelligence.shared()?.trackMedia(mediaEvent)
    }
    @IBAction func EOFButtonPressed(_ sender: Any) {
        let duration = Double(durationTextField.text ?? "0") ?? 0
        let position = Double(positionTextfield.text ?? "0") ?? 0
        let mediaProperties = MIMediaParameters("TestVideo", action: "eof", position: position as NSNumber, duration: duration as NSNumber)
        let mediaEvent = MIMediaEvent(pageName: "Test", parameters: mediaProperties)
        MappIntelligence.shared()?.trackMedia(mediaEvent)
    }
}
