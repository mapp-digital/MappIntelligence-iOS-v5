//
//  WebViewViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 07/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        

        let request = URLRequest(url: URL(string: "http://demoshop.webtrekk.com/web2app/index.html")!)
        
        let configuration = WKWebViewConfiguration()
        MIWebViewTracker.sharedInstance()?.update(configuration)
                
        let webView = WKWebView(frame: self.view.frame, configuration: configuration)
        self.view.addSubview(webView)
        webView.load(request)
    }
}


class TrackingWrapper: NSObject {
    public static let webtrekk = Webtrekk()
    public class Webtrekk: NSObject {
        func updateWKWebViewConfiguration(_ configuration: WKWebViewConfiguration) -> WKWebViewConfiguration {
            return MIWebViewTracker.sharedInstance()?.update(configuration) ?? WKWebViewConfiguration()
        }
    }
}
