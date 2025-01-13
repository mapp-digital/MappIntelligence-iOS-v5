//
//  MIUsageStatisticsTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 23.6.23..
//  Copyright © 2023 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MIUsageStatistics.h"
#import "MappIntelligenceLogger.h"

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
@property (nonatomic, strong) MIUsageStatistics *usageStatistics;
@property (nonatomic, strong) id mockLogger;
@end

@implementation MIUsageStatisticsTests

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


- (void)setUp {
    [super setUp];
    self.usageStatistics = [[MIUsageStatistics alloc] init];
    [[MappIntelligenceLogger shared] setLogLevel:kMappIntelligenceLogLevelDescriptionAll];
    self.mockLogger = OCMClassMock([MappIntelligenceLogger class]);
    [self.mockLogger setLogLevel:kMappIntelligenceLogLevelDescriptionAll];
    _statisticsObject = [[MIUsageStatistics alloc] init];
    //128 + 64 + 32 + 8 + 4 + 2 + 1 = 239
    XCTAssertEqual([[_statisticsObject getUserStatisticsValue] intValue], 239, "Inital usage statistics is not ok");
}

- (void)tearDown {
    [self.mockLogger stopMocking];
    self.mockLogger = nil;
    self.usageStatistics = nil;
    _statisticsObject = NULL;
    [super tearDown];
}

- (void)testInitialization {
    XCTAssertEqualObjects(self.usageStatistics.activityAutoTracking, @(0), @"activityAutoTracking should be initialized to 0");
    XCTAssertEqualObjects(self.usageStatistics.fragmentsAutoTracking, @(0), @"fragmentsAutoTracking should be initialized to 0");
    XCTAssertEqualObjects(self.usageStatistics.autoTracking, @(128), @"autoTracking should be initialized to 128 (2^7)");
    XCTAssertEqualObjects(self.usageStatistics.backgroundSendout, @(64), @"backgroundSendout should be initialized to 64 (2^6)");
    XCTAssertEqualObjects(self.usageStatistics.userMatching, @(32), @"userMatching should be initialized to 32 (2^5)");
    XCTAssertEqualObjects(self.usageStatistics.webview, @(0), @"webview should be initialized to 0");
    XCTAssertEqualObjects(self.usageStatistics.setEverId, @(8), @"setEverId should be initialized to 8 (2^3)");
    XCTAssertEqualObjects(self.usageStatistics.appVersionInEveryRequest, @(4), @"appVersionInEveryRequest should be initialized to 4 (2^2)");
    XCTAssertEqualObjects(self.usageStatistics.crashTracking, @(2), @"crashTracking should be initialized to 2 (2^1)");
    XCTAssertEqualObjects(self.usageStatistics.batchSupport, @(1), @"batchSupport should be initialized to 1 (2^0)");
}

- (void)testSetters {
    // Test setting autoTracking to 0
    [self.usageStatistics setAutoTracking:@(0)];
    XCTAssertEqualObjects(self.usageStatistics.autoTracking, @(0), @"autoTracking should be set to 0");

    // Test setting autoTracking to non-zero
    [self.usageStatistics setAutoTracking:@(1)];
    XCTAssertEqualObjects(self.usageStatistics.autoTracking, @(128), @"autoTracking should be set to 128 (2^7)");

    // Test other setters similarly...
    [self.usageStatistics setBackgroundSendout:@(0)];
    XCTAssertEqualObjects(self.usageStatistics.backgroundSendout, @(0), @"backgroundSendout should be set to 0");

    [self.usageStatistics setUserMatching:@(0)];
    XCTAssertEqualObjects(self.usageStatistics.userMatching, @(0), @"userMatching should be set to 0");

    [self.usageStatistics setSetEverId:@(0)];
    XCTAssertEqualObjects(self.usageStatistics.setEverId, @(0), @"setEverId should be set to 0");

    [self.usageStatistics setAppVersionInEveryRequest:@(0)];
    XCTAssertEqualObjects(self.usageStatistics.appVersionInEveryRequest, @(0), @"appVersionInEveryRequest should be set to 0");

    [self.usageStatistics setCrashTracking:@(0)];
    XCTAssertEqualObjects(self.usageStatistics.crashTracking, @(0), @"crashTracking should be set to 0");

    [self.usageStatistics setBatchSupport:@(0)];
    XCTAssertEqualObjects(self.usageStatistics.batchSupport, @(0), @"batchSupport should be set to 0");
}

- (void)testPrintUserStatistics {
    // Prepare for logging
    NSString *expectedLog = [NSString stringWithFormat:@"\n===================================================\n===================Usage Statistics================\nActivity Auto Tracking: %i\nFragments Auto Tracking: %i\nAuto Tracking: %i\nBackground Sendout: %i\nUser Matching: %i\nWebview: %i\nSet EverId: %i\nApp Version in every Request: %i\nCrash Tracking: %i\nBatch Support: %i\n===================================================\n",
                             [self.usageStatistics.activityAutoTracking intValue],
                             [self.usageStatistics.fragmentsAutoTracking intValue],
                             [self.usageStatistics.autoTracking intValue],
                             [self.usageStatistics.backgroundSendout intValue],
                             [self.usageStatistics.userMatching intValue],
                             [self.usageStatistics.webview intValue],
                             [self.usageStatistics.setEverId intValue],
                             [self.usageStatistics.appVersionInEveryRequest intValue],
                             [self.usageStatistics.crashTracking intValue],
                             [self.usageStatistics.batchSupport intValue]];

    // Mock logger behavior
    OCMExpect([[self.mockLogger shared] logObj:expectedLog forDescription:kMappIntelligenceLogLevelDescriptionDebug]);
    
    // Call the method under test
    [self.usageStatistics printUserStatistics];

    // Verify that the expected log call was made
    OCMVerifyAll(self.mockLogger);
}

- (void)testGetUserStatisticsValue {
    NSString *expectedValue = [NSString stringWithFormat:@"%i", ([self.usageStatistics.activityAutoTracking intValue] +
                                                               [self.usageStatistics.fragmentsAutoTracking intValue] +
                                                               [self.usageStatistics.autoTracking intValue] +
                                                               [self.usageStatistics.backgroundSendout intValue] +
                                                               [self.usageStatistics.userMatching intValue] +
                                                               [self.usageStatistics.webview intValue] +
                                                               [self.usageStatistics.setEverId intValue] +
                                                               [self.usageStatistics.appVersionInEveryRequest intValue] +
                                                               [self.usageStatistics.crashTracking intValue] +
                                                               [self.usageStatistics.batchSupport intValue])];

    // Calculate the actual value
    NSString *actualValue = [self.usageStatistics getUserStatisticsValue];

    // Verify the returned value matches the expected value
    XCTAssertEqualObjects(actualValue, expectedValue, @"getUserStatisticsValue should return the correct aggregated value.");
}

- (void)testReset {
    // Set some properties to non-zero values
    [self.usageStatistics setBatchSupport:@(1)];
    [self.usageStatistics setUserMatching:@(32)];

    // Call reset method
    [self.usageStatistics reset];

    // Verify that properties have been reset correctly
    XCTAssertEqualObjects(self.usageStatistics.batchSupport, @(0), @"batchSupport should be reset to 0");
    XCTAssertEqualObjects(self.usageStatistics.userMatching, @(0), @"userMatching should be reset to 0");
}


@end
