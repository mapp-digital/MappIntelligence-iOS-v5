//
//  MIDeepLinksTests.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 14/12/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <WebKit/WebKit.h>
#import "MIWebViewTracker.h"


@interface MIMockController : UIViewController<WKScriptMessageHandler>
@property BOOL webViewResponded;
@end

@implementation MIMockController
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    if ([message.name isEqual:@"MappIntelligenceiOSBridge"]) {
        _webViewResponded = YES;
    }
}
@end


@interface MIWebTrackerTests : XCTestCase
@property WKWebView *webView;
@property WKWebViewConfiguration *configuration;
@property MIMockController *viewController;
@end

@implementation MIWebTrackerTests

- (void)setUp {
    _viewController = [[MIMockController alloc] init];
    _configuration = [[WKWebViewConfiguration alloc] init];
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:_configuration];
}

- (void)tearDown {
    _viewController = nil;
    _configuration = nil;
    _webView = nil;
}

- (void) testConfigurationUpdate {
    XCTestExpectation* expectation = [[XCTestExpectation alloc] initWithDescription:@"Wait until callback!"];
    
    _configuration = [[MIWebViewTracker sharedInstance] updateConfiguration:_configuration];
    
    XCTAssertFalse(_viewController.webViewResponded);
    NSString *html = @"<!DOCTYPE html>"
    "<html lang=\"en\">"
    "<head>"
     "   <title>Test</title>"
    "</head>"
    "<body>"
     "   <script>window.onload = function() {WebtrekkAndroidWebViewCallback.trackCustomEvent('test','test');}</script>"
    "</body>"
    "</html>";
    [_webView.configuration.userContentController removeScriptMessageHandlerForName:@"MappIntelligenceiOSBridge"];
    [_webView.configuration.userContentController addScriptMessageHandler:_viewController name:@"MappIntelligenceiOSBridge"];
    [_viewController.view addSubview:_webView];
    [_webView loadHTMLString:html baseURL:nil];
    
    XCTWaiterResult result = [XCTWaiter waitForExpectations: @[expectation] timeout:4];
        if(result == XCTWaiterResultTimedOut) {
            XCTAssertTrue(_viewController.webViewResponded);
    }
}

@end

