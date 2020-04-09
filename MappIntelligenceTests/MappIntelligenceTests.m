//
//  MappIntelligenceTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/9/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligence.h"
#import "DefaultTracker.h"


@interface MappIntelligenceTests : XCTestCase

@property MappIntelligence *instance;
@property NSString *testTrackDomain;

@end

@implementation MappIntelligenceTests

- (void)setUp {
    [super setUp];
    _instance = [MappIntelligence shared];
    _testTrackDomain = @"https://test.com";
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    XCTAssertNotNil(_instance);
}

- (void)testInit {
    [_instance initWithConfiguration:@[@12345464] onTrackdomain:_testTrackDomain withAutotrackingEnabled:YES requestTimeout:60 numberOfRequests:10 batchSupportEnabled:YES viewControllerAutoTrackingEnabled:YES andLogLevel: all];
    XCTAssertTrue([[MappIntelligence getId] isEqualToString:@"12345464"]);
    XCTAssertTrue([[MappIntelligence getUrl] isEqualToString:_testTrackDomain], "track tomain is same");
}

- (void)testReset {
    NSString *previousEverID = [[DefaultTracker sharedInstance] generateEverId];
    [_instance reset];
    NSString *newEverID = [[DefaultTracker sharedInstance] generateEverId];
    XCTAssertFalse([previousEverID isEqualToString:newEverID], "after reset, ever ids are different!");
    [_instance initWithConfiguration:@[@12345464] onTrackdomain:_testTrackDomain withAutotrackingEnabled:YES requestTimeout:60 numberOfRequests:10 batchSupportEnabled:YES viewControllerAutoTrackingEnabled:YES andLogLevel: all];
}

- (void)testTrackController {
    UIViewController *controller = [[UIViewController alloc] init];
    XCTAssertNil([_instance trackPage:controller], "There is no error while tracking controller.");
}

- (void)testTrackCustomName {
    XCTAssertNil([_instance trackPageWith:@"customPageName"], "There is no error while tracking custom page name.");
}
@end
