//
//  MappIntelligenceSDKLoggerTest.m
//  MappIntelligenceTests
//
//  Created by Vladan Randjelovic on 05/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "MappIntelligence/Log/MappIntelligenceLogger.h"

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

#pragma mark - Errors

- (void)testPersistanceCachingError
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeCaching];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_PersistanceLayerDomain"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 1, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Failed caching object."], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testPersistanceUnCachingError
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeUnCaching];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_PersistanceLayerDomain"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 2, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Failed loading object from cache."], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testObjectDoesNotExist
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeCachingObjectDoesNotExist];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_PersistanceLayerDomain"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 3, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Object does not exist."], @"Error user info is: %@", error.userInfo[@"info"]);
}
- (void)testMissingArgumetsError
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeMissingArguments];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_GeneralError"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 11, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Missing arguments, can't continue."], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testBadArgumetsError
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeBadArguments];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_GeneralError"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 12, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Wrong or unformatted arguments, can't continue."], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testNetworkError
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeNetwork];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_NetworkError"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 20, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Missing arguments or bad Argumens."], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testDeviceTagExist
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeTagExists];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_DataService"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 30, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Tag name already exist in device tags with desired boolean state."], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testDeviceTagDoesntExist
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeTagDoesNotExists];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_DataService"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 31, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Tag name doesn't exist in device tags, or in application tags."], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testDevicDataServiceArgs
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeTagUncompletedArguments];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_DataService"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 32, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Missing arguments, or empry arguments."], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testOptionNotAvaialble
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeOptionNotAvailable];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_GeneralError"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 40, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Option is not available, please contact support."], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testGeneralError
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeGeneralError];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_GeneralError"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 50, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"General Error"], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testSilentPushError
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeSilentPush];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_PushSender"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 60, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Push did not originate from MappIntelligence. Aborting actions."], @"Error user info is: %@", error.userInfo[@"info"]);
}

- (void)testDmcErrors
{
    NSError *error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeDMC];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_DMCError"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 70, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"Error while polling user."], @"Error user info is: %@", error.userInfo[@"info"]);
    
    error = [MappIntelligenceLogger errorWithType:kMappIntelligenceErrorTypeDMCUserDoesntExist];
    
    XCTAssertNotNil(error);
    
    XCTAssertTrue([error.domain isEqualToString:@"MappIntelligence_DMCError"], @"Error domain is: %@", error.domain);
    XCTAssertTrue(error.code == 71, @"Error code is: %tu", error.code);
    XCTAssertNotNil(error.userInfo);
    XCTAssertTrue([error.userInfo[@"info"] isEqualToString:@"User doesnt exists."], @"Error user info is: %@", error.userInfo[@"info"]);
}


@end
