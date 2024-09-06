//
//  MIAPXInappLoggerTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 04.09.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

// MIAPXInappLoggerTests.m

#import <XCTest/XCTest.h>
#import "MIAPXInappLogger.h"

@interface MIAPXInappLoggerTests : XCTestCase
@property (nonatomic, strong) MIAPXInappLogger *logger;
@end

@implementation MIAPXInappLoggerTests

- (void)setUp {
    [super setUp];
    self.logger = [MIAPXInappLogger shared];
}

- (void)tearDown {
    self.logger = nil;
    [super tearDown];
}

// Test for singleton instance
- (void)testSharedInstance {
    MIAPXInappLogger *sharedInstance1 = [MIAPXInappLogger shared];
    MIAPXInappLogger *sharedInstance2 = [MIAPXInappLogger shared];
    XCTAssertEqual(sharedInstance1, sharedInstance2, @"shared should return the same instance");
}

// Test logObj:forDescription: method
- (void)testLogObjForDescription_Debug {
    self.logger.logLevel = kAPXLogLevelDescriptionDebug;
    NSString *logOutput = [self.logger logObj:@"Test debug log" forDescription:kAPXLogLevelDescriptionDebug];
    XCTAssertTrue([logOutput containsString:@"[Appoxee Debug]"], @"Log output should contain debug level description");
}

- (void)testLogObjForDescription_Warning {
    self.logger.logLevel = kAPXLogLevelDescriptionWarning;
    NSString *logOutput = [self.logger logObj:@"Test warning log" forDescription:kAPXLogLevelDescriptionWarning];
    XCTAssertTrue([logOutput containsString:@"[Appoxee Warning]"], @"Log output should contain warning level description");
}

- (void)testLogObjForDescription_Error {
    self.logger.logLevel = kAPXLogLevelDescriptionError;
    NSString *logOutput = [self.logger logObj:@"Test error log" forDescription:kAPXLogLevelDescriptionError];
    XCTAssertTrue([logOutput containsString:@"[Appoxee Error]"], @"Log output should contain error level description");
}

- (void)testLogObjForDescription_Ignored {
    self.logger.logLevel = kAPXLogLevelDescriptionCritical;
    NSString *logOutput = [self.logger logObj:@"Test debug log" forDescription:kAPXLogLevelDescriptionDebug];
    XCTAssertNil(logOutput, @"Log output should be nil when log level is higher than the message level");
}

// Test errorWithType: method
- (void)testErrorWithType_Caching {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeCaching];
    XCTAssertEqualObjects(error.domain, @"APX_PersistanceLayerDomain");
    XCTAssertEqual(error.code, kAPXErrorTypeCaching);
    XCTAssertEqualObjects(error.userInfo[@"info"], @"Failed caching object.");
}

- (void)testErrorWithType_Network {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeNetwork];
    XCTAssertEqualObjects(error.domain, @"APX_NetworkError");
    XCTAssertEqual(error.code, kAPXErrorTypeNetwork);
    XCTAssertEqualObjects(error.userInfo[@"info"], @"Missing arguments or bad Argumens.");
}

- (void)testErrorWithType_TagExists {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeTagExists];
    XCTAssertEqualObjects(error.domain, @"APX_DataService");
    XCTAssertEqual(error.code, kAPXErrorTypeTagExists);
    XCTAssertEqualObjects(error.userInfo[@"info"], @"Tag name already exist in device tags with desired boolean state.");
}

// Add more tests for other error types as needed

@end

