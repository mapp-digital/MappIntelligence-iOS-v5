//
//  MIFormSubmitEventTests.m
//  MappIntelligenceTests
//
//  Created by Codex on 2026-03-05.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import "MIFormSubmitEvent.h"

@interface MIFormSubmitEvent (Testing)
+ (void)setTestWindow:(UIWindow *)window;
- (UIViewController *)topViewController;
@end

@interface MIFormSubmitEventTests : XCTestCase
@property (nonatomic, strong) UIWindow *window;
@end

@implementation MIFormSubmitEventTests

- (void)tearDown {
    [MIFormSubmitEvent setTestWindow:nil];
    self.window.hidden = YES;
    self.window = nil;
    [super tearDown];
}

- (void)configureWindowWithRootViewController:(UIViewController *)rootViewController {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
    [MIFormSubmitEvent setTestWindow:self.window];
}

- (void)testInitWithNoWindowDoesNotCrash {
    MIFormSubmitEvent *event = [[MIFormSubmitEvent alloc] init];
    XCTAssertNotNil(event);
    XCTAssertTrue(event.pageName == nil || [event.pageName isKindOfClass:[NSString class]]);
}

- (void)testTopViewControllerReturnsNavigationTopWhenAvailable {
    XCTestExpectation *expectation = [self expectationWithDescription:@"top view controller resolved"]; 

    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [[UIViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];

        [self configureWindowWithRootViewController:navigationController];

        MIFormSubmitEvent *event = [[MIFormSubmitEvent alloc] init];
        UIViewController *topViewController = [event topViewController];

        XCTAssertEqualObjects(topViewController, rootViewController);
        XCTAssertEqualObjects(event.pageName, NSStringFromClass(rootViewController.class));

        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)testTopViewControllerReturnsPresentedViewController {
    XCTestExpectation *expectation = [self expectationWithDescription:@"presented view controller resolved"]; 

    dispatch_async(dispatch_get_main_queue(), ^{
        UIViewController *rootViewController = [[UIViewController alloc] init];
        UIViewController *presentedViewController = [[UIViewController alloc] init];

        [self configureWindowWithRootViewController:rootViewController];
        [rootViewController presentViewController:presentedViewController animated:NO completion:nil];

        MIFormSubmitEvent *event = [[MIFormSubmitEvent alloc] init];
        UIViewController *topViewController = [event topViewController];

        XCTAssertEqualObjects(topViewController, presentedViewController);
        XCTAssertEqualObjects(event.pageName, NSStringFromClass(presentedViewController.class));

        [expectation fulfill];
    });

    [self waitForExpectationsWithTimeout:2.0 handler:nil];
}

- (void)testTopViewControllerReturnsNilWhenNoWindow {
    [MIFormSubmitEvent setTestWindow:nil];

    MIFormSubmitEvent *event = [[MIFormSubmitEvent alloc] init];
    UIViewController *topViewController = [event topViewController];

    XCTAssertNil(topViewController);
}

@end
