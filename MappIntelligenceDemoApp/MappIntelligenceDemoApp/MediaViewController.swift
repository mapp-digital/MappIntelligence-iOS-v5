//
//  MediaViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 29/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class MediaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func trackMedia1(_ sender: Any) {
        let mediaProperties = MIMediaParameters("TestVideo", action: "view", postion: 12, duration: 120)
        let mediaEvent = MIMediaEvent(pageName: "Test", parameters: mediaProperties)
        MappIntelligence.shared()?.trackMedia(mediaEvent)
    }
    
    @IBAction func trackMediaPlayer2(_ sender: Any) {
        let vc = (storyboard?.instantiateViewController(withIdentifier: "MediaExample")) as! MediaPlayerViewController
        vc.streamUrl = URL(string: "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
