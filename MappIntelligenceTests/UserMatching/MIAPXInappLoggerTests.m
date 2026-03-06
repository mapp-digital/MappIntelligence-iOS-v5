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

- (void)assertError:(NSError *)error domain:(NSString *)domain info:(NSString *)info code:(NSInteger)code {
    XCTAssertEqualObjects(error.domain, domain);
    XCTAssertEqual(error.code, code);
    XCTAssertEqualObjects(error.userInfo[@"info"], info);
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

- (void)testLogObjForDescription_Critical {
    self.logger.logLevel = kAPXLogLevelDescriptionCritical;
    NSString *logOutput = [self.logger logObj:@"Test critical log" forDescription:kAPXLogLevelDescriptionCritical];
    XCTAssertTrue([logOutput containsString:@"[Appoxee Critical]"], @"Log output should contain critical level description");
}

- (void)testLogObjForDescription_Emergency {
    self.logger.logLevel = kAPXLogLevelDescriptionEmergency;
    NSString *logOutput = [self.logger logObj:@"Test emergency log" forDescription:kAPXLogLevelDescriptionEmergency];
    XCTAssertTrue([logOutput containsString:@"[Appoxee Emergency]"], @"Log output should contain emergency level description");
}

- (void)testLogObjForDescription_Ignored {
    self.logger.logLevel = kAPXLogLevelDescriptionCritical;
    NSString *logOutput = [self.logger logObj:@"Test debug log" forDescription:kAPXLogLevelDescriptionDebug];
    XCTAssertNil(logOutput, @"Log output should be nil when log level is higher than the message level");
}

// Test errorWithType: method
- (void)testErrorWithType_Caching {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeCaching];
    [self assertError:error domain:@"APX_PersistanceLayerDomain" info:@"Failed caching object." code:kAPXErrorTypeCaching];
}

- (void)testErrorWithType_UnCaching {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeUnCaching];
    [self assertError:error domain:@"APX_PersistanceLayerDomain" info:@"Failed loading object from cache." code:kAPXErrorTypeUnCaching];
}

- (void)testErrorWithType_ObjectDoesNotExist {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeCachingObjectDoesNotExist];
    [self assertError:error domain:@"APX_PersistanceLayerDomain" info:@"Object does not exist." code:kAPXErrorTypeCachingObjectDoesNotExist];
}

- (void)testErrorWithType_MissingArguments {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeMissingArguments];
    [self assertError:error domain:@"APX_GeneralError" info:@"Missing arguments, can't continue." code:kAPXErrorTypeMissingArguments];
}

- (void)testErrorWithType_Network {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeNetwork];
    [self assertError:error domain:@"APX_NetworkError" info:@"Missing arguments or bad Argumens." code:kAPXErrorTypeNetwork];
}

- (void)testErrorWithType_BadArguments {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeBadArguments];
    [self assertError:error domain:@"APX_GeneralError" info:@"Wrong or unformatted arguments, can't continue." code:kAPXErrorTypeBadArguments];
}

- (void)testErrorWithType_TagExists {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeTagExists];
    [self assertError:error domain:@"APX_DataService" info:@"Tag name already exist in device tags with desired boolean state." code:kAPXErrorTypeTagExists];
}

- (void)testErrorWithType_TagDoesNotExist {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeTagDoesNotExists];
    [self assertError:error domain:@"APX_DataService" info:@"Tag name doesn't exist in device tags, or in application tags." code:kAPXErrorTypeTagDoesNotExists];
}

- (void)testErrorWithType_TagUncompletedArguments {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeTagUncompletedArguments];
    [self assertError:error domain:@"APX_DataService" info:@"Missing arguments, or empry arguments." code:kAPXErrorTypeTagUncompletedArguments];
}

- (void)testErrorWithType_OptionNotAvailable {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeOptionNotAvailable];
    [self assertError:error domain:@"APX_GeneralError" info:@"Option is not available, please contact support." code:kAPXErrorTypeOptionNotAvailable];
}

- (void)testErrorWithType_GeneralError {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeGeneralError];
    [self assertError:error domain:@"APX_GeneralError" info:@"General Error" code:kAPXErrorTypeGeneralError];
}

- (void)testErrorWithType_SilentPush {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeSilentPush];
    [self assertError:error domain:@"APX_PushSender" info:@"Push did not originate from Appoxee. Aborting actions." code:kAPXErrorTypeSilentPush];
}

- (void)testErrorWithType_DMC {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeDMC];
    [self assertError:error domain:@"APX_DMCError" info:@"Error while polling user." code:kAPXErrorTypeDMC];
}

- (void)testErrorWithType_DMCUserDoesntExist {
    NSError *error = [MIAPXInappLogger errorWithType:kAPXErrorTypeDMCUserDoesntExist];
    [self assertError:error domain:@"APX_DMCError" info:@"User doesnt exists." code:kAPXErrorTypeDMCUserDoesntExist];
}

@end
