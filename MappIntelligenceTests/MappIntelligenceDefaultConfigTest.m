//
//  MappIntelligenceDefaultConfigTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligenceDefaultConfig.h"

@interface MappIntelligenceDefaultConfigTests : XCTestCase

@property (nonatomic, strong) MappIntelligenceDefaultConfig *config;
@property (nonatomic, strong) MappIntelligenceLogger *mockLogger;

@end

@implementation MappIntelligenceDefaultConfigTests

- (void)setUp {
    [super setUp];
    self.mockLogger = [MappIntelligenceLogger shared]; // Assume this is a singleton
    self.config = [[MappIntelligenceDefaultConfig alloc] init];
}

- (void)tearDown {
    self.config = nil;
    self.mockLogger = nil;
    [super tearDown];
}

- (void)testlogConfig {
    XCTAssertNotNil(_config);
    [_config logConfig];
}

- (void)testInitialization {
    XCTAssertNotNil(self.config);
    XCTAssertEqual(self.config.requestsInterval, requestIntervalDefault);
    XCTAssertEqual(self.config.optOut, optOutDefault);
    XCTAssertEqual(self.config.batchSupport, batchSupportDefault);
    XCTAssertEqual(self.config.userMatching, userMatchingDefault);
    XCTAssertEqual(self.config.requestPerQueue, requestPerQueueDefault);
}

- (void)testLogConfigWithNoTrackIDs {
    self.config.trackIDs = nil;
    
    // Assuming you have a way to check logs, for example:
    // [self.mockLogger logObj:...] might be replaced with a method to capture logs.
    
    [self.config logConfig];
    // Check if logging for "TrackIDs cannot be empty!" happened
}

- (void)testReset {
    self.config.requestsInterval = 100;
    self.config.optOut = YES;
    self.config.batchSupport = YES;
    self.config.userMatching = YES;
    self.config.requestPerQueue = 200;

    [self.config reset];
    
    XCTAssertEqual(self.config.requestsInterval, requestIntervalDefault);
    XCTAssertEqual(self.config.optOut, optOutDefault);
    XCTAssertEqual(self.config.batchSupport, batchSupportDefault);
    XCTAssertEqual(self.config.userMatching, userMatchingDefault);
    XCTAssertEqual(self.config.requestPerQueue, requestPerQueueDefault);
}

- (void)testIsConfiguredForTracking {
    self.config.trackDomain = @"https://valid.domain.com";
    self.config.trackIDs = @[@"trackID1"];
    
    XCTAssertTrue([self.config isConfiguredForTracking]);
    
    self.config.trackIDs = nil;
    XCTAssertFalse([self.config isConfiguredForTracking]);
    // Verify log for misconfiguration
}


@end
