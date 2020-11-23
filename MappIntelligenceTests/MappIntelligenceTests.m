//
//  MappIntelligenceTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/9/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligence.h"
#import "MIDefaultTracker.h"


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
    [_instance initWithConfiguration:@[@12345464] onTrackdomain:_testTrackDomain];
    XCTAssertTrue([[MappIntelligence getId] isEqualToString:@"12345464"]);
    XCTAssertTrue([[MappIntelligence getUrl] isEqualToString:_testTrackDomain], "track tomain is same");
    [_instance initWithConfiguration:@[@12345464, @6677777777] onTrackdomain:_testTrackDomain];
    XCTAssertTrue([[MappIntelligence getId] isEqualToString:@"12345464,6677777777"]);
}

- (void)testReset {
    NSString *previousEverID = [[MIDefaultTracker sharedInstance] generateEverId];
    [_instance reset];
    NSString *newEverID = [[MIDefaultTracker sharedInstance] generateEverId];
    XCTAssertFalse([previousEverID isEqualToString:newEverID], "after reset, ever ids are different!");
    [_instance initWithConfiguration:@[@12345464, @6677777777] onTrackdomain:_testTrackDomain];
}

//- (void)testTrackController {
//    UIViewController *controller = [[UIViewController alloc] init];
//    XCTAssertNil([_instance trackPage:controller], "There is no error while tracking controller.");
//}
//
//- (void)testTrackCustomName {
//    XCTAssertNil([_instance trackPageWith:@"customPageName"], "There is no error while tracking custom page name.");
//}
@end
