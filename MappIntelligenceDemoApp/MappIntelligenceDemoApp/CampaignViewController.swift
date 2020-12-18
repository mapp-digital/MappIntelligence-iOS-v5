//
//  CampaignViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 02/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit

class CampaignViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func testCampaign(_ sender: Any) {
        let campaignProperties = MICampaignProperties("email.newsletter.nov2020.thursday")
        campaignProperties.mediaCode = "abc"
        campaignProperties.oncePerSession = true
        campaignProperties.action = .view
        campaignProperties.customProperties = [12: "camParam1"]
        
        let event = MIPageViewEvent(name: "TestCampaign")
        event.campaignProperties = campaignProperties
        MappIntelligence.shared()?.trackPage(event)
    }
    
    @IBAction func testLink1(_ sender: Any) {
        let url = URL(string: "https://testurl.com/?wt_mc=email.newsletter.nov2020.thursday&wt_cc45=parameter45")
        
        MappIntelligence.shared()?.trackUrl(url, withMediaCode: nil)
        MappIntelligence.shared()?.trackPage(with: self, andEvent: nil)
    }
    
    @IBAction func testLink2(_ sender: Any) {
        let url = URL(string: "https://testurl.com/?abc=email.newsletter.nov2020.thursday&wt_cc12=parameter12 13")
        
        MappIntelligence.shared()?.trackUrl(url, withMediaCode: "abc")
        MappIntelligence.shared()?.trackPage(with: self, andEvent: nil)
    }
    
}
