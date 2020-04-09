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

@end

@implementation MappIntelligenceTests

- (void)setUp {
    [super setUp];
    _instance = [MappIntelligence shared];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    XCTAssertNotNil(_instance);
}

- (void)testInit {
    NSString *trackDomain = @"https://test.com";
    [_instance initWithConfiguration:@[@12345464] onTrackdomain:trackDomain withAutotrackingEnabled:YES requestTimeout:60 numberOfRequests:10 batchSupportEnabled:YES viewControllerAutoTrackingEnabled:YES andLogLevel: all];
    XCTAssertTrue([[MappIntelligence getId] isEqualToString:@"12345464"]);
    XCTAssertTrue([[MappIntelligence getUrl] isEqualToString:trackDomain], "track tomain is same");
}

- (void)testReset {
    NSString *previousEverID = [[DefaultTracker sharedInstance] generateEverId];
    [_instance reset];
    NSString *newEverID = [[DefaultTracker sharedInstance] generateEverId];
    XCTAssertFalse([previousEverID isEqualToString:newEverID], "after reset, ever ids are different!");
}
@end
