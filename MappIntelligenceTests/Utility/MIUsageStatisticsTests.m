//
//  MIUsageStatisticsTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 23.6.23..
//  Copyright © 2023 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIUsageStatistics.h"

/*
 SDK feature    Value
 Activity Auto Tracking    2^9 (512)-0 it is Android only
 Fragments Auto Tracking    2^8 (256)-0 it is Android only
 Auto Tracking    2^7 (128)
 Background Sendout    2^6 (64)
 User Matching    2^5 (32)
 Webview    2^4 (16)-0 it is Web only
 Set EverId    2^3 (8)
 AppVersion in every Request    2^2 (4)
 Crash Tracking    2^1 (2)
 Batch Support    2^0 (1)
 */

@interface MIUsageStatisticsTests : XCTestCase

@property MIUsageStatistics* statisticsObject;

@end

@implementation MIUsageStatisticsTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _statisticsObject = [[MIUsageStatistics alloc] init];
    //128 + 64 + 32 + 8 + 4 + 2 + 1 = 239
    XCTAssertEqual([[_statisticsObject getUserStatisticsValue] intValue], 239, "Inital usage statistics is not ok");
}

- (void)testRemoveAutoTracking {
    [_statisticsObject setAutoTracking:[NSNumber numberWithInt:0]];
    //239-128 = 111
    XCTAssertEqual([[_statisticsObject getUserStatisticsValue] intValue], 111, "Usage statistics when auto tracking is dissabled is not ok");
}

- (void)testRemoveBackgroundSendout {
    [_statisticsObject setBackgroundSendout:[NSNumber numberWithInt:0]];
    //239-64 = 175
    XCTAssertEqual([[_statisticsObject getUserStatisticsValue] intValue], 175, "Usage statistics when background sendout is dissabled is not ok");
}

- (void)testRemoveUserMatching {
    [_statisticsObject setUserMatching:[NSNumber numberWithInt:0]];
    //239 - 32 = 207
    XCTAssertEqual([[_statisticsObject getUserStatisticsValue] intValue], 207, "Usage statistics when user matching is dissabled is not ok");
}

- (void)testRemoveSetEverId {
    [_statisticsObject setSetEverId:[NSNumber numberWithInt:0]];
    //239 - 8 = 231
    XCTAssertEqual([[_statisticsObject getUserStatisticsValue] intValue], 231, "Usage statistics when set ever id is dissabled is not ok");
}

- (void)testRemoveSendAppVersionInEveryRequest {
    [_statisticsObject setAppVersionInEveryRequest:[NSNumber numberWithInt:0]];
    //239 - 4 = 235
    XCTAssertEqual([[_statisticsObject getUserStatisticsValue] intValue], 235, "Usage statistics when send app version in every request is dissabled is not ok");
}

- (void)testRemoveCrashTracking {
    [_statisticsObject setCrashTracking:[NSNumber numberWithInt:0]];
    //239 - 2 = 237
    XCTAssertEqual([[_statisticsObject getUserStatisticsValue] intValue], 237, "Usage statistics when crash tracking is dissabled is not ok");
}

- (void)testRemoveBatchSupport {
    [_statisticsObject setBatchSupport:[NSNumber numberWithInt:0]];
    //239 - 1 = 238
    XCTAssertEqual([[_statisticsObject getUserStatisticsValue] intValue], 238, "Usage statistics when batch support is dissabled is not ok");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _statisticsObject = NULL;
}

@end
