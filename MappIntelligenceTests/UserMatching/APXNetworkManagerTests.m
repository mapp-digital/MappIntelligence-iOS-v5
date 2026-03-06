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
- (NSURLRequest *)contentRequestForOperation:(NetworkManagerOperationType)operation withAppID:(NSString *)appID andUDID:(NSString *)udid;
- (void)removeRetryOfOperation:(NetworkManagerOperationType)operation;
- (NSString *)baseURLStringPerEnvoirnment;
- (NSString *)getServerAddress;
- (NSString *)endPointByNetworkOperation:(NetworkManagerOperationType)operation;
- (NSString *)httpMethodForOperation:(NetworkManagerOperationType)operation;

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
    [self.networkManager.retryOperations removeAllObjects];

    NSData *testData = [@"Test retry data" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *retryKey = [NSString stringWithFormat:@"retryKey_%tu", kAPXNetworkManagerOperationTypeFeedback];

    BOOL retrying = [self.networkManager retryOperation:kAPXNetworkManagerOperationTypeFeedback
                                               withData:testData
                                     andCompletionBlock:^(NSError *error, id response) {
    }];

    XCTAssertTrue(retrying, @"Operation should be retrying on first attempt");
    XCTAssertEqualObjects(self.networkManager.retryOperations[retryKey], @(1));

    [self.networkManager retryOperation:kAPXNetworkManagerOperationTypeFeedback
                               withData:testData
                     andCompletionBlock:^(NSError *error, id response) {
    }];
    XCTAssertEqualObjects(self.networkManager.retryOperations[retryKey], @(2));

    [self.networkManager retryOperation:kAPXNetworkManagerOperationTypeFeedback
                               withData:testData
                     andCompletionBlock:^(NSError *error, id response) {
    }];
    XCTAssertEqualObjects(self.networkManager.retryOperations[retryKey], @(3));

    BOOL retryingAfterMax = [self.networkManager retryOperation:kAPXNetworkManagerOperationTypeFeedback
                                                      withData:testData
                                            andCompletionBlock:^(NSError *error, id response) {
    }];

    XCTAssertFalse(retryingAfterMax, @"Operation should stop retrying after max attempts");
    XCTAssertNil(self.networkManager.retryOperations[retryKey]);
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

- (void)testBaseURLStringPerEnvironmentReturnsValue {
    self.networkManager.environment = kAPXNetworkManagerEnvironmentVirginia;
    NSString *baseURL = [self.networkManager baseURLStringPerEnvoirnment];
    XCTAssertNotNil(baseURL);
    XCTAssertTrue([baseURL containsString:@"https://"]);
}

- (void)testEndPointAndHttpMethodForOperation {
    NSString *endpoint = [self.networkManager endPointByNetworkOperation:kAPXNetworkManagerOperationTypeFeedback];
    NSString *method = [self.networkManager httpMethodForOperation:kAPXNetworkManagerOperationTypeFeedback];

    XCTAssertNotNil(endpoint);
    XCTAssertNotNil(method);
    XCTAssertEqualObjects(method, @"PUT");
}

- (void)testGetServerAddressReturnsDefaultOrConfigured {
    NSString *server = [self.networkManager getServerAddress];
    XCTAssertNotNil(server);
    XCTAssertTrue([server containsString:@"https://"]);
}

- (void)testContentRequestForFeedbackIncludesBodyAndEndpoint {
    NSURLRequest *request = [self.networkManager contentRequestForOperation:kAPXNetworkManagerOperationTypeFeedback
                                                                   withAppID:@"app"
                                                                    andUDID:@"udid"];
    NSString *body = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];

    XCTAssertEqualObjects(request.HTTPMethod, @"POST");
    XCTAssertTrue([request.URL.absoluteString containsString:@"feedback/feedback.aspx"]);
    XCTAssertTrue([body containsString:@"appID=app"]);
    XCTAssertTrue([body containsString:@"key=udid"]);
}

- (void)testContentRequestForMoreAppsUsesMoreAppsEndpoint {
    NSURLRequest *request = [self.networkManager contentRequestForOperation:kAPXNetworkManagerOperationTypeMoreApps
                                                                   withAppID:@"myApp"
                                                                    andUDID:@"udid"];

    XCTAssertEqualObjects(request.HTTPMethod, @"POST");
    XCTAssertTrue([request.URL.absoluteString containsString:@"MoreApps/myApp"]);
}

- (void)testGenerateRequestUsesPreferedURLWhenSet {
    self.networkManager.preferedURL = @"https://example.com/";
    NSMutableURLRequest *request = [self.networkManager generateRequestForOperation:kAPXNetworkManagerOperationTypeFeedback];
    XCTAssertTrue([request.URL.absoluteString hasPrefix:@"https://example.com/"]);
    self.networkManager.preferedURL = nil;
}

- (void)testRemoveRetryOfOperationDoesNotCrash {
    [self.networkManager.retryOperations removeAllObjects];
    [self.networkManager retryOperation:kAPXNetworkManagerOperationTypeFeedback
                               withData:[@"data" dataUsingEncoding:NSUTF8StringEncoding]
                     andCompletionBlock:^(NSError *error, id response) {
    }];

    XCTAssertNoThrow([self.networkManager removeRetryOfOperation:kAPXNetworkManagerOperationTypeFeedback]);
}

@end
