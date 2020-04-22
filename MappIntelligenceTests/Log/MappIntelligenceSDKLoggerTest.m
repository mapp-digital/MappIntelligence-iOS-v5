//
//  MappIntelligenceSDKLoggerTest.m
//  MappIntelligenceTests
//
//  Created by Vladan Randjelovic on 05/02/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MappIntelligenceLogger.h"

@interface MappIntelligenceSDKLoggerTest : XCTestCase

@end

@implementation MappIntelligenceSDKLoggerTest

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark - Debug

- (void)testMappIntelligenceLoggerInitialization
{
    XCTAssertNotNil([MappIntelligenceLogger shared]);
}

- (void)testLogPrintsAsExpected
{
    [[MappIntelligenceLogger shared] setLogLevel:kMappIntelligenceLogLevelDescriptionAll];
    NSString *log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionDebug];

    XCTAssertTrue([log isEqualToString:@"[MappIntelligence Debug] test"]);

    log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionWarning];

    XCTAssertTrue([log isEqualToString:@"[MappIntelligence Warning] test"]);

    log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionError];

    XCTAssertTrue([log isEqualToString:@"[MappIntelligence Error] test"]);

    log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionFault];

    XCTAssertTrue([log isEqualToString:@"[MappIntelligence Fault] test"]);

    log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionInfo];

    XCTAssertTrue([log isEqualToString:@"[MappIntelligence Info] test"]);
}

- (void)testLogLevels
{
    [[MappIntelligenceLogger shared] setLogLevel:kMappIntelligenceLogLevelDescriptionDebug];

    NSString *log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionDebug];

    XCTAssertTrue([log isEqualToString:@"[MappIntelligence Debug] test"], @"log is: %@", log);

    [[MappIntelligenceLogger shared] setLogLevel:kMappIntelligenceLogLevelDescriptionWarning];

    log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionDebug];

    XCTAssertNil(log);

    [[MappIntelligenceLogger shared] setLogLevel:kMappIntelligenceLogLevelDescriptionError];

    log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionWarning];

    XCTAssertNil(log);

    [[MappIntelligenceLogger shared] setLogLevel:kMappIntelligenceLogLevelDescriptionFault];

    log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionError];

    XCTAssertNil(log);

    [[MappIntelligenceLogger shared] setLogLevel:kMappIntelligenceLogLevelDescriptionInfo];

    log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionFault];

    XCTAssertNil(log);

    [[MappIntelligenceLogger shared] setLogLevel:kMappIntelligenceLogLevelDescriptionDebug];

    log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionDebug];

    XCTAssertNotNil(log);

    XCTAssertTrue([log isEqualToString:@"[MappIntelligence Debug] test"], @"log is: %@", log);
}

@end
