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
@property (nonatomic, strong) MappIntelligenceLogger *logger;

@end

@implementation MappIntelligenceSDKLoggerTest

- (void)setUp {
    [super setUp];
    self.logger = [MappIntelligenceLogger shared];
}

- (void)tearDown {
    self.logger = nil;
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

    XCTAssertNotNil(log);

    [[MappIntelligenceLogger shared] setLogLevel:kMappIntelligenceLogLevelDescriptionDebug];

    log = [[MappIntelligenceLogger shared] logObj:@"test" forDescription:kMappIntelligenceLogLevelDescriptionDebug];

    XCTAssertNotNil(log);

    XCTAssertTrue([log isEqualToString:@"[MappIntelligence Debug] test"], @"log is: %@", log);
}

- (void)testInitialization {
    XCTAssertNotNil(self.logger);
    XCTAssertEqual(self.logger.logLevel, kMappIntelligenceLogLevelDescriptionNone);
    XCTAssertNotNil(self.logger.formatter);
}

- (void)testSharedInstance {
    MappIntelligenceLogger *anotherLogger = [MappIntelligenceLogger shared];
    XCTAssertEqual(self.logger, anotherLogger);
}

- (void)testLogObjWithMatchingLogLevel {
    self.logger.logLevel = kMappIntelligenceLogLevelDescriptionDebug;
    NSString *logOutput = [self.logger logObj:@"Test message" forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    XCTAssertEqualObjects(logOutput, @"[MappIntelligence Debug] Test message");
}

- (void)testLogObjWithNonMatchingLogLevel {
    self.logger.logLevel = kMappIntelligenceLogLevelDescriptionNone;
    NSString *logOutput = [self.logger logObj:@"Test message" forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    XCTAssertNil(logOutput);
}

- (void)testLogObjWithAllLogLevel {
    self.logger.logLevel = kMappIntelligenceLogLevelDescriptionAll;
    NSString *logOutput = [self.logger logObj:@"Test message" forDescription:kMappIntelligenceLogLevelDescriptionWarning];
    XCTAssertEqualObjects(logOutput, @"[MappIntelligence Warning] Test message");
}

- (void)testLogObjWithFaultLogLevel {
    self.logger.logLevel = kMappIntelligenceLogLevelDescriptionNone;
    NSString *logOutput = [self.logger logObj:@"Fault message" forDescription:kMappIntelligenceLogLevelDescriptionFault];
    XCTAssertEqualObjects(logOutput, @"[MappIntelligence Fault] Fault message");
}

@end
