#import <XCTest/XCTest.h>
#import "MIWebViewTracker.h"
#import <WebKit/WebKit.h>

@interface MIWebViewTrackerTests : XCTestCase
@property (nonatomic, strong) MIWebViewTracker *webViewTracker;
@end

@implementation MIWebViewTrackerTests

- (void)setUp {
    [super setUp];
    // Set up before each test
    self.webViewTracker = [MIWebViewTracker sharedInstance];
}

- (void)tearDown {
    // Clean up after each test
    self.webViewTracker = nil;
    [super tearDown];
}

#pragma mark - Singleton Tests

- (void)testSharedInstance_NotNil {
    // Test that the sharedInstance method returns a non-nil instance
    MIWebViewTracker *instance = [MIWebViewTracker sharedInstance];
    XCTAssertNotNil(instance, @"The shared instance should not be nil");
}

- (void)testSharedInstance_SameInstance {
    // Test that multiple calls to sharedInstance return the same instance
    MIWebViewTracker *instance1 = [MIWebViewTracker sharedInstance];
    MIWebViewTracker *instance2 = [MIWebViewTracker sharedInstance];
    
    XCTAssertEqual(instance1, instance2, @"The shared instance should always return the same object");
}

#pragma mark - WebView Configuration Tests

- (void)testUpdateConfiguration_WithNilConfiguration {
    // Test that a new configuration is created when nil is passed
    WKWebViewConfiguration *updatedConfig = [self.webViewTracker updateConfiguration:nil];
    
    XCTAssertNotNil(updatedConfig, @"The updated configuration should not be nil");
    XCTAssertNotNil(updatedConfig.userContentController, @"The user content controller should not be nil");
}

- (void)testUpdateConfiguration_AddsUserScript {
    // Test that the user script is added to the configuration
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    WKWebViewConfiguration *updatedConfig = [self.webViewTracker updateConfiguration:config];
    
    XCTAssertEqual(updatedConfig.userContentController.userScripts.count, 1, @"The configuration should have 1 user script added");
    
    WKUserScript *userScript = updatedConfig.userContentController.userScripts.firstObject;
    XCTAssertEqual(userScript.injectionTime, WKUserScriptInjectionTimeAtDocumentEnd, @"The user script should be injected at document end");
    XCTAssertTrue(userScript.forMainFrameOnly, @"The user script should be for main frame only");
}

@end

