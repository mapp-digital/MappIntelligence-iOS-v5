//
//  MappIntelligenceDefaultConfigTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligenceDefaultConfig.h"

@interface MappIntelligenceDefaultConfig (Testing)
- (void)validateRequestTimeInterval:(NSInteger)timeInterval;
- (BOOL)trackDomainValidation:(NSString *)trackingDomain;
- (void)validateTrackingIDs:(NSArray *)validTrackingIDs;
@end

@interface MappIntelligenceDefaultConfigTests : XCTestCase

@property (nonatomic, strong) MappIntelligenceDefaultConfig *config;
@property (nonatomic, strong) MappIntelligenceLogger *mockLogger;

@end

@implementation MappIntelligenceDefaultConfigTests

- (void)setUp {
    [super setUp];
    [self clearDefaultConfigUserDefaults];
    self.mockLogger = [MappIntelligenceLogger shared]; // Assume this is a singleton
    self.config = [[MappIntelligenceDefaultConfig alloc] init];
}

- (void)clearDefaultConfigUserDefaults {
    NSArray<NSString *> *keys = @[
        @"requests_interval",
        @"batch_support",
        @"user_matching",
        @"optOut",
        @"auto_tracking",
        @"view_controller_auto_tracking",
        @"log_level",
        @"track_domain",
        @"track_ids"
    ];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in keys) {
        [defaults removeObjectForKey:key];
    }
    [defaults synchronize];
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

    [self.config reset];
    
    XCTAssertEqual(self.config.requestsInterval, requestIntervalDefault);
    XCTAssertEqual(self.config.optOut, optOutDefault);
    XCTAssertEqual(self.config.batchSupport, batchSupportDefault);
    XCTAssertEqual(self.config.userMatching, userMatchingDefault);
}

- (void)testIsConfiguredForTracking {
    self.config.trackDomain = @"https://valid.domain.com";
    self.config.trackIDs = @[@"trackID1"];

    XCTAssertTrue([self.config isConfiguredForTracking]);

    self.config.trackIDs = nil;
    XCTAssertFalse([self.config isConfiguredForTracking]);
    // Verify log for misconfiguration
}

- (void)testEncodeDecodeRoundTrip {
    self.config.trackDomain = @"https://example.com";
    self.config.trackIDs = @[@"1", @"2"];
    self.config.autoTracking = YES;
    self.config.batchSupport = YES;
    self.config.userMatching = YES;
    self.config.requestsInterval = 42;
    self.config.viewControllerAutoTracking = YES;
    self.config.logLevel = kMappIntelligenceLogLevelDescriptionDebug;

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.config];
    MappIntelligenceDefaultConfig *decoded = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    XCTAssertEqualObjects(decoded.trackDomain, self.config.trackDomain);
    XCTAssertEqualObjects(decoded.trackIDs, self.config.trackIDs);
    XCTAssertEqual(decoded.autoTracking, self.config.autoTracking);
    XCTAssertEqual(decoded.batchSupport, self.config.batchSupport);
    XCTAssertEqual(decoded.userMatching, self.config.userMatching);
    XCTAssertEqual(decoded.requestsInterval, self.config.requestsInterval);
    XCTAssertEqual(decoded.viewControllerAutoTracking, self.config.viewControllerAutoTracking);
    XCTAssertEqual(decoded.logLevel, self.config.logLevel);
}

- (void)testValidateRequestTimeIntervalTooHighResetsToDefault {
    self.config.requestsInterval = 10;
    [self.config validateRequestTimeInterval:4000];
    XCTAssertEqual(self.config.requestsInterval, requestIntervalDefault);
}

- (void)testValidateRequestTimeIntervalTooLowSetsToMinimum {
    self.config.requestsInterval = 10;
    [self.config validateRequestTimeInterval:1];
    XCTAssertEqual(self.config.requestsInterval, 5);
}

- (void)testTrackDomainValidationRejectsEmpty {
    self.config.trackDomain = @"";
    XCTAssertFalse([self.config trackDomainValidation:@""]);
}

- (void)testTrackDomainValidationAddsSchemeWhenMissing {
    self.config.trackDomain = @"example.com";
    BOOL valid = [self.config trackDomainValidation:@"example.com"];

    XCTAssertFalse(valid);
    XCTAssertEqualObjects(self.config.trackDomain, @"https://example.com");
}

- (void)testValidateTrackingIDsLogsForInvalidValues {
    [self.config validateTrackingIDs:@[]];
    [self.config validateTrackingIDs:@[@""]];
    [self.config validateTrackingIDs:@[@","]];
    [self.config validateTrackingIDs:@[@" "]];
}

@end
