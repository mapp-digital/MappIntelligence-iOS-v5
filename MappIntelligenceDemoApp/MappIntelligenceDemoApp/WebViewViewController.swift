//
//  WebViewViewController.swift
//  MappIntelligenceDemoApp
//
//  Created by Miroljub Stoilkovic on 07/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

import UIKit
import WebKit

class WebViewViewController: UIViewController, WKScriptMessageHandler {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        var androidWeb = "var WebtrekkAndroidWebViewCallback ={}; WebtrekkAndroidWebViewCallback.trackCustomEvent = function(name, params){window.webkit.messageHandlers.iOSBridge.postMessage([name, params])};"
        androidWeb += "WebtrekkAndroidWebViewCallback.trackCustomPage = function(name, params){window.webkit.messageHandlers.iOSBridge.postMessage([name, params])};"
        androidWeb += "WebtrekkAndroidWebViewCallback.TAG = \"WebtrekkAndroidWebViewCallback\";"
        androidWeb += "WebtrekkAndroidWebViewCallback.getUserAgent=function(){return \"Tracking Library 5.0.0 (iOS Version 14.0 (Build 18A372); iPhone; en_US))\"};"
        androidWeb += "WebtrekkAndroidWebViewCallback.getEverId = function(){return \"6160683713130920044\"};"

        
        let userScript = WKUserScript(
            source: androidWeb,
            injectionTime: WKUserScriptInjectionTime.atDocumentEnd,
            forMainFrameOnly: true
        )
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addUserScript(userScript)
        configuration.userContentController.add(self,name: "iOSBridge")
        */
        
        let configuration = WKWebViewConfiguration()
        MIWebViewTracker.sharedInstance()?.update(configuration)
        let request = URLRequest(url: URL(string: "http://demoshop.webtrekk.com/web2app/index.html")!)
        let webView = WKWebView(frame: self.view.frame, configuration: configuration)
        self.view.addSubview(webView)
        webView.load(request)
    }
    
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
    }
    
}
