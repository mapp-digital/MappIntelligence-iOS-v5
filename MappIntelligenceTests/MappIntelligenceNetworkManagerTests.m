//
//  MappIntelligenceNetworkManagerTests.m
//  MappIntelligenceTests
//
//  Created by Vladan Randjelovic on 06/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligenceNetworkManager.h"

@interface MappIntelligenceNetworkManagerTests : XCTestCase

@end

@implementation MappIntelligenceNetworkManagerTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testManagerIsInitialized
{
    XCTAssertNotNil([MappIntelligenceNetworkManager shared]);
}

- (void)testNetworkEnviornment
{
    [[MappIntelligenceNetworkManager shared] setEnvironment:kMappIntelligenceNetworkManagerEnvironmentVirginia];
    
    XCTAssertEqual(kMappIntelligenceNetworkManagerEnvironmentVirginia, [MappIntelligenceNetworkManager shared].environment);
    
    [[MappIntelligenceNetworkManager shared] setEnvironment:kMappIntelligenceNetworkManagerEnvironmentQALatest];
    
    XCTAssertEqual(kMappIntelligenceNetworkManagerEnvironmentQALatest, [MappIntelligenceNetworkManager shared].environment);
    
    [[MappIntelligenceNetworkManager shared] setEnvironment:kMappIntelligenceNetworkManagerEnvironmentQAStable];
    
    XCTAssertEqual(kMappIntelligenceNetworkManagerEnvironmentQAStable, [MappIntelligenceNetworkManager shared].environment);
    
    [[MappIntelligenceNetworkManager shared] setEnvironment:kMappIntelligenceNetworkManagerEnvironmentQA2];
    
    XCTAssertEqual(kMappIntelligenceNetworkManagerEnvironmentQA2, [MappIntelligenceNetworkManager shared].environment);
    
    [[MappIntelligenceNetworkManager shared] setEnvironment:kMappIntelligenceNetworkManagerEnvironmentQA3];
    
    XCTAssertEqual(kMappIntelligenceNetworkManagerEnvironmentQA3, [MappIntelligenceNetworkManager shared].environment);
    
    [[MappIntelligenceNetworkManager shared] setEnvironment:kMappIntelligenceNetworkManagerEnvironmentQAFrankfurt];
    
    XCTAssertEqual(kMappIntelligenceNetworkManagerEnvironmentQAFrankfurt, [MappIntelligenceNetworkManager shared].environment);
}

- (void)testCommunicationWithOutSDKID
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing SDKID in network operation"];
    
    [[MappIntelligenceNetworkManager shared] setSdkID:nil];
    
    NSData *data = [[NSData alloc] init];
    
    [[MappIntelligenceNetworkManager shared] performNetworkOperation:kMappIntelligenceNetworkManagerOperationTypeRegister withData:data andCompletionBlock:^(NSError *error, id data) {
        
        XCTAssertNotNil(error);
        XCTAssertNil(data);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0f handler:^(NSError *error) {
        
        if (error) {
            
            XCTFail(@"Expectation failed with error:%@", error);
        }
    }];
}

- (void)testNilData
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Nil data in network operation"];
    
    [[MappIntelligenceNetworkManager shared] performNetworkOperation:kMappIntelligenceNetworkManagerOperationTypeRegister withData:nil andCompletionBlock:^(NSError *error, id data) {
        
        XCTAssertNotNil(error);
        XCTAssertNil(data);
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0f handler:^(NSError *error) {
        
        if (error) {
            
            XCTFail(@"Expectation failed with error:%@", error);
        }
    }];
}

@end
