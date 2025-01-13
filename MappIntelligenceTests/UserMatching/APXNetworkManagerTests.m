//
//  APXNetworkManagerTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 04.09.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <XCTest/XCTest.h>
#import "APXNetworkManager.h"

@interface MINetworkManager (Test) // Category to expose private methods and properties
- (BOOL)retryOperation:(NetworkManagerOperationType)operation
              withData:(NSData *)data
    andCompletionBlock:(APXNetworkManagerCompletionBlock)block;

- (NSMutableURLRequest *)generateRequestForOperation:(NetworkManagerOperationType)operation;

@property (nonatomic, strong) NSMutableDictionary *retryOperations; // Expose the private property
@end

@interface MINetworkManagerTests : XCTestCase
@property (nonatomic, strong) MINetworkManager *networkManager;
@end

@implementation MINetworkManagerTests

- (void)setUp {
    self.networkManager = [MINetworkManager shared];
    [super setUp];
}

- (void)tearDown {
    self.networkManager = nil;
    [super tearDown];
}

// Test retry operation
- (void)testRetryOperation {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Retry operation expectation"];
    
    NSData *testData = [@"Test retry data" dataUsingEncoding:NSUTF8StringEncoding];
    
    BOOL retrying = [self.networkManager retryOperation:kAPXNetworkManagerOperationTypeFeedback withData:testData andCompletionBlock:^(NSError *error, id response) {
        // Simulate an error to trigger retries
        NSError *simulatedError = [NSError errorWithDomain:@"TestDomain" code:100 userInfo:nil];
        XCTAssertNotNil(simulatedError, @"Simulated error should not be nil");
        [expectation fulfill];
    }];
    
    XCTAssertTrue(retrying, @"Operation should be retrying");
    
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testManagerIsInitialized
{
    XCTAssertNotNil([MINetworkManager shared]);
}

- (void)testNetworkEnviornment
{
    [[MINetworkManager shared] setEnvironment:kAPXNetworkManagerEnvironmentVirginia];
    
    XCTAssertEqual(kAPXNetworkManagerEnvironmentVirginia, [MINetworkManager shared].environment);
    
    [[MINetworkManager shared] setEnvironment:kAPXNetworkManagerEnvironmentQALatest];
    
    XCTAssertEqual(kAPXNetworkManagerEnvironmentQALatest, [MINetworkManager shared].environment);
    
    [[MINetworkManager shared] setEnvironment:kAPXNetworkManagerEnvironmentQAStable];
    
    XCTAssertEqual(kAPXNetworkManagerEnvironmentQAStable, [MINetworkManager shared].environment);
    
    [[MINetworkManager shared] setEnvironment:kAPXNetworkManagerEnvironmentQA2];
    
    XCTAssertEqual(kAPXNetworkManagerEnvironmentQA2, [MINetworkManager shared].environment);
    
    [[MINetworkManager shared] setEnvironment:kAPXNetworkManagerEnvironmentQA3];
    
    XCTAssertEqual(kAPXNetworkManagerEnvironmentQA3, [MINetworkManager shared].environment);
    
    [[MINetworkManager shared] setEnvironment:kAPXNetworkManagerEnvironmentQAFrankfurt];
    
    XCTAssertEqual(kAPXNetworkManagerEnvironmentQAFrankfurt, [MINetworkManager shared].environment);
}

- (void)testCommunicationWithOutSDKID
{
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing SDKID in network operation"];
    
    [[MINetworkManager shared] setSdkID:nil];
    
    NSData *data = [[NSData alloc] init];
    
    [[MINetworkManager shared] performNetworkOperation:kAPXNetworkManagerOperationTypeRegister withData:data andCompletionBlock:^(NSError *error, id data) {
        
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

// Test generate request method
- (void)testGenerateRequestForOperation {
    NSMutableURLRequest *request = [self.networkManager generateRequestForOperation:kAPXNetworkManagerOperationTypeFeedback];
    
    XCTAssertNotNil(request, @"Request should not be nil");
    XCTAssertEqualObjects(request.HTTPMethod, @"PUT", @"HTTP method should be PUT for this operation");
    XCTAssertTrue([request.URL.absoluteString containsString:@"api/v3/device/"], @"URL should contain the correct endpoint");
}

// Test synchronous network operation with nil data
- (void)testPerformSynchronousNetworkOperationWithNilData {
    NSDictionary *response = [self.networkManager performSynchronousNetworkOperation:kAPXNetworkManagerOperationTypeFeedback withData:nil];
    
    XCTAssertNil(response, @"Response should be nil when no data is provided");
}

@end
