//
//  RequestBatchSupportUrlBuilderTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 04/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIRequestBatchSupportUrlBuilder.h"
#import "MIRequestData.h"
#import "MIDBRequest.h"
#import "MIDatabaseManager.h"
#import "MITrackerRequest.h"
#import <objc/runtime.h>

@interface MIRequestBatchSupportUrlBuilder (TestAccess)
- (NSArray<NSString *> *)createBatchWith:(MIRequestData *)data;
- (NSArray *)getRequestIDs:(MIRequestData *)data;
@end

@interface MITestDBRequest : MIDBRequest
@property (nonatomic, strong) NSURL *testURL;
@end

@implementation MITestDBRequest

- (NSURL *)urlForBatchSupprot:(BOOL)batch {
    return self.testURL;
}

@end

@interface MITestDBManager : MIDatabaseManager
@property (nonatomic, strong) NSError *fetchError;
@property (nonatomic, strong) MIRequestData *fetchData;
@property (nonatomic, strong) NSArray *removedIds;
@property (nonatomic, strong) NSNumber *lastInterval;
@end

@implementation MITestDBManager

- (void)fetchAllRequestsFromInterval:(double)interval
            andWithCompletionHandler:(StorageManagerCompletionHandler)handler {
    self.lastInterval = @(interval);
    handler(self.fetchError, self.fetchData);
}

- (void)removeRequestsDB:(NSArray *)array {
    self.removedIds = array;
}

@end

@interface MITestTrackerRequest : MITrackerRequest
@property (nonatomic, assign) NSInteger sendCount;
@property (nonatomic, assign) NSInteger backgroundCount;
@property (nonatomic, strong) NSURL *lastURL;
@property (nonatomic, copy) NSString *lastBody;
@property (nonatomic, strong) NSError *sendError;
@end

@implementation MITestTrackerRequest

- (void)sendRequestWith:(NSURL *)url
                andBody:(NSString *)body
        andCompletition:(nonnull void (^)(NSError * _Nonnull))handler {
    self.sendCount += 1;
    self.lastURL = url;
    self.lastBody = body;
    if (handler) {
        handler(self.sendError);
    }
}

- (void)sendBackgroundRequestWith:(NSURL *)url andBody:(NSString *)body {
    self.backgroundCount += 1;
    self.lastURL = url;
    self.lastBody = body;
}

@end

@interface MITestBatchUrlBuilder : MIRequestBatchSupportUrlBuilder
@property (nonatomic, strong) NSArray<NSString *> *overrideBodies;
@end

@implementation MITestBatchUrlBuilder

- (NSArray<NSString *> *)createBatchWith:(MIRequestData *)data {
    if (self.overrideBodies) {
        return self.overrideBodies;
    }
    return [super createBatchWith:data];
}

@end

static NSInteger RequestBatchSendCount = 0;
static NSInteger RequestBatchBackgroundCount = 0;
static NSURL *RequestBatchLastURL = nil;
static NSString *RequestBatchLastBody = nil;
static IMP RequestBatchOriginalSendIMP = NULL;
static IMP RequestBatchOriginalBackgroundIMP = NULL;

@interface RequestBatchSupportUrlBuilderTests : XCTestCase

@property MIRequestBatchSupportUrlBuilder* batchUrlBuilder;
@property (nonatomic, assign) IMP originalSharedIMP;
@property (nonatomic, strong) MITestTrackerRequest *testTrackerRequest;

@end

@implementation RequestBatchSupportUrlBuilderTests

- (void)setUp {
    [self resetTrackerCounters];
    _batchUrlBuilder = [[MIRequestBatchSupportUrlBuilder alloc] init];
}

- (void)tearDown {
    [self restoreTrackerMethods];
    _batchUrlBuilder = nil;
}

- (MIDBRequest *)requestWithId:(NSNumber *)requestId
                        domain:(NSString *)domain
                      trackIds:(NSString *)trackIds
                    queryItems:(NSArray<NSURLQueryItem *> *)queryItems {
    MIDBRequest *request = [[MIDBRequest alloc] initWithParamters:queryItems andDomain:domain andTrackIds:trackIds];
    request.uniqueId = requestId;
    return request;
}

- (void)testInitBuildsBaseUrl {
    XCTAssertNotNil(self.batchUrlBuilder.baseUrl);
    XCTAssertTrue([self.batchUrlBuilder.baseUrl containsString:@"/batch?"]);
    XCTAssertTrue([self.batchUrlBuilder.baseUrl containsString:@"X-WT-UA="]);
}

- (void)testCreateBatchWithEmptyRequestsReturnsEmptyArray {
    MIRequestData *data = [[MIRequestData alloc] initWithRequests:@[]];
    NSArray<NSString *> *batchBodies = [self.batchUrlBuilder createBatchWith:data];

    XCTAssertNotNil(batchBodies);
    XCTAssertEqual(batchBodies.count, 0);
}

- (void)testCreateBatchWithValidRequestsCreatesSingleBody {
    NSString *domain = @"https://tracker-int-01.webtrekk.net";
    NSString *trackId = @"794940687426749";

    MIDBRequest *requestOne = [self requestWithId:@1
                                           domain:domain
                                         trackIds:trackId
                                       queryItems:@[
        [NSURLQueryItem queryItemWithName:@"p" value:@"500,page1,0"],
        [NSURLQueryItem queryItemWithName:@"eid" value:@"1111111111111111111"],
        [NSURLQueryItem queryItemWithName:@"X-WT-UA" value:@"Tracking Library"]
    ]];
    MIDBRequest *requestTwo = [self requestWithId:@2
                                           domain:domain
                                         trackIds:trackId
                                       queryItems:@[
        [NSURLQueryItem queryItemWithName:@"p" value:@"500,page2,0"],
        [NSURLQueryItem queryItemWithName:@"nc" value:@"1"]
    ]];

    MIRequestData *data = [[MIRequestData alloc] initWithRequests:@[requestOne, requestTwo]];
    NSArray<NSString *> *batchBodies = [self.batchUrlBuilder createBatchWith:data];

    XCTAssertEqual(batchBodies.count, 1);
    NSString *body = batchBodies.firstObject;
    XCTAssertTrue([body containsString:@"wt?p="]);
    XCTAssertTrue([body containsString:@"page1"]);
    XCTAssertTrue([body containsString:@"page2"]);
    XCTAssertFalse([body containsString:@"eid="]);
    XCTAssertFalse([body containsString:@"X-WT-UA"]);
    XCTAssertFalse([body containsString:@"nc="]);
}

- (void)testCreateBatchSkipsRequestsWithoutQuery {
    NSString *domain = @"https://tracker-int-01.webtrekk.net";
    NSString *trackId = @"794940687426749";

    MIDBRequest *emptyRequest = [self requestWithId:@1
                                             domain:domain
                                           trackIds:trackId
                                         queryItems:@[]];
    MIDBRequest *validRequest = [self requestWithId:@2
                                             domain:domain
                                           trackIds:trackId
                                         queryItems:@[
        [NSURLQueryItem queryItemWithName:@"p" value:@"500,pageValid,0"]
    ]];

    MIRequestData *data = [[MIRequestData alloc] initWithRequests:@[emptyRequest, validRequest]];
    NSArray<NSString *> *batchBodies = [self.batchUrlBuilder createBatchWith:data];

    XCTAssertEqual(batchBodies.count, 1);
    NSString *body = batchBodies.firstObject;
    XCTAssertTrue([body containsString:@"pageValid"]);
}

- (void)testGetRequestIDsReturnsAllIdsInOrder {
    NSString *domain = @"https://tracker-int-01.webtrekk.net";
    NSString *trackId = @"794940687426749";

    MIDBRequest *requestOne = [self requestWithId:@10
                                           domain:domain
                                         trackIds:trackId
                                       queryItems:@[[NSURLQueryItem queryItemWithName:@"p" value:@"500,page1,0"]]];
    MIDBRequest *requestTwo = [self requestWithId:@20
                                           domain:domain
                                         trackIds:trackId
                                       queryItems:@[[NSURLQueryItem queryItemWithName:@"p" value:@"500,page2,0"]]];
    MIRequestData *data = [[MIRequestData alloc] initWithRequests:@[requestOne, requestTwo]];

    NSArray *ids = [self.batchUrlBuilder getRequestIDs:data];

    XCTAssertEqualObjects(ids, (@[@10, @20]));
}

- (void)testCreateBatchSkipsNilUrlAndNilQuery {
    MITestDBRequest *nilUrlRequest = [[MITestDBRequest alloc] init];
    nilUrlRequest.uniqueId = @1;
    nilUrlRequest.testURL = nil;

    MITestDBRequest *nilQueryRequest = [[MITestDBRequest alloc] init];
    nilQueryRequest.uniqueId = @2;
    nilQueryRequest.testURL = [NSURL URLWithString:@"https://example.com/path"];

    MIRequestData *data = [[MIRequestData alloc] initWithRequests:@[nilUrlRequest, nilQueryRequest]];
    NSArray<NSString *> *batchBodies = [self.batchUrlBuilder createBatchWith:data];

    XCTAssertEqual(batchBodies.count, 0);
}

- (void)testCreateBatchSkipsBlankQueriesAndReplacesNewlines {
    NSURLComponents *blankComponents = [[NSURLComponents alloc] init];
    blankComponents.scheme = @"https";
    blankComponents.host = @"example.com";
    blankComponents.path = @"/track";
    blankComponents.query = @" ";

    NSURLComponents *newlineComponents = [[NSURLComponents alloc] init];
    newlineComponents.scheme = @"https";
    newlineComponents.host = @"example.com";
    newlineComponents.path = @"/track";
    newlineComponents.query = @"p=500%0Aline";

    MITestDBRequest *blankRequest = [[MITestDBRequest alloc] init];
    blankRequest.uniqueId = @1;
    blankRequest.testURL = blankComponents.URL;

    MITestDBRequest *newlineRequest = [[MITestDBRequest alloc] init];
    newlineRequest.uniqueId = @2;
    newlineRequest.testURL = newlineComponents.URL;

    MIRequestData *data = [[MIRequestData alloc] initWithRequests:@[blankRequest, newlineRequest]];
    NSArray<NSString *> *batchBodies = [self.batchUrlBuilder createBatchWith:data];

    XCTAssertEqual(batchBodies.count, 1);
    XCTAssertTrue([batchBodies.firstObject containsString:@"p=500"]);
    XCTAssertTrue([batchBodies.firstObject containsString:@"line"]);
}

- (void)testCreateBatchLargeRequestsUsesFirstChunk {
    NSString *domain = @"https://tracker-int-01.webtrekk.net";
    NSString *trackId = @"794940687426749";
    NSMutableArray *requests = [[NSMutableArray alloc] initWithCapacity:10001];
    for (NSInteger i = 0; i < 10001; i++) {
        NSString *value = [NSString stringWithFormat:@"500,page%ld,0", (long)i];
        MIDBRequest *request = [self requestWithId:@(i)
                                            domain:domain
                                          trackIds:trackId
                                        queryItems:@[[NSURLQueryItem queryItemWithName:@"p" value:value]]];
        [requests addObject:request];
    }
    MIRequestData *data = [[MIRequestData alloc] initWithRequests:requests];
    NSArray<NSString *> *batchBodies = [self.batchUrlBuilder createBatchWith:data];

    XCTAssertEqual(batchBodies.count, 1);
    NSString *body = batchBodies.firstObject;
    XCTAssertTrue([body containsString:@"page0"]);
    XCTAssertFalse([body containsString:@"page9999"]);
}

- (void)testSendBatchForRequestsBackgroundUsesBackgroundRequest {
    MITestDBManager *dbManager = [[MITestDBManager alloc] init];
    NSString *domain = @"https://tracker-int-01.webtrekk.net";
    NSString *trackId = @"794940687426749";
    MIDBRequest *request = [self requestWithId:@1
                                        domain:domain
                                      trackIds:trackId
                                    queryItems:@[[NSURLQueryItem queryItemWithName:@"p" value:@"500,page1,0"]]];
    dbManager.fetchData = [[MIRequestData alloc] initWithRequests:@[request]];

    MIRequestBatchSupportUrlBuilder *builder = [[MIRequestBatchSupportUrlBuilder alloc] init];
    [builder setValue:dbManager forKey:@"dbManager"];
    [builder setValue:dbManager forKey:@"_dbManager"];
    XCTAssertEqual([builder valueForKey:@"dbManager"], dbManager);

    NSArray<NSString *> *bodies = [builder createBatchWith:dbManager.fetchData];
    XCTAssertEqual(bodies.count, 1);

    [self swizzleTrackerMethods];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler should not be called for background"];
    expectation.inverted = YES;

    [builder sendBatchForRequestsInBackground:YES withCompletition:^(NSError *error) {
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    XCTAssertEqual(RequestBatchBackgroundCount, 1);
    XCTAssertEqual(RequestBatchSendCount, 0);
}

- (void)testSendBatchForRequestsForegroundRemovesRequestsOnSuccess {
    MITestDBManager *dbManager = [[MITestDBManager alloc] init];
    NSString *domain = @"https://tracker-int-01.webtrekk.net";
    NSString *trackId = @"794940687426749";
    MIDBRequest *request = [self requestWithId:@1
                                        domain:domain
                                      trackIds:trackId
                                    queryItems:@[[NSURLQueryItem queryItemWithName:@"p" value:@"500,page1,0"]]];
    dbManager.fetchData = [[MIRequestData alloc] initWithRequests:@[request]];

    MIRequestBatchSupportUrlBuilder *builder = [[MIRequestBatchSupportUrlBuilder alloc] init];
    [builder setValue:dbManager forKey:@"dbManager"];
    [builder setValue:dbManager forKey:@"_dbManager"];
    XCTAssertEqual([builder valueForKey:@"dbManager"], dbManager);

    NSArray<NSString *> *bodies = [builder createBatchWith:dbManager.fetchData];
    XCTAssertEqual(bodies.count, 1);

    [self swizzleTrackerMethods];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler called"];
    [builder sendBatchForRequestsInBackground:NO withCompletition:^(NSError *error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1.0 handler:nil];
    XCTAssertEqual(RequestBatchSendCount, 1);
    XCTAssertEqualObjects(dbManager.removedIds, (@[@1]));
}

- (void)testSendBatchForRequestsHandlesErrorAndEmptyBatch {
    MITestDBManager *dbManager = [[MITestDBManager alloc] init];
    dbManager.fetchError = [NSError errorWithDomain:@"Test" code:1 userInfo:nil];
    dbManager.fetchData = [[MIRequestData alloc] initWithRequests:@[]];

    MITestBatchUrlBuilder *builder = [[MITestBatchUrlBuilder alloc] init];
    [builder setValue:dbManager forKey:@"dbManager"];
    [builder setValue:dbManager forKey:@"_dbManager"];
    XCTAssertEqual([builder valueForKey:@"dbManager"], dbManager);
    builder.overrideBodies = @[];

    __block NSInteger handlerCalls = 0;
    [builder sendBatchForRequestsInBackground:NO withCompletition:^(NSError *error) {
        handlerCalls += 1;
    }];

    XCTAssertEqual(handlerCalls, 2);
}

- (void)testSendBatchSkipsWtOnlyBody {
    MITestDBManager *dbManager = [[MITestDBManager alloc] init];
    dbManager.fetchData = [[MIRequestData alloc] initWithRequests:@[]];

    MITestBatchUrlBuilder *builder = [[MITestBatchUrlBuilder alloc] init];
    [builder setValue:dbManager forKey:@"dbManager"];
    [builder setValue:dbManager forKey:@"_dbManager"];
    XCTAssertEqual([builder valueForKey:@"dbManager"], dbManager);
    builder.overrideBodies = @[ @"wt?" ];

    NSArray<NSString *> *bodies = [builder createBatchWith:dbManager.fetchData];
    XCTAssertEqualObjects(bodies, (@[ @"wt?" ]));

    [self swizzleTrackerMethods];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Handler not called for wt? body"];
    expectation.inverted = YES;

    [builder sendBatchForRequestsInBackground:NO withCompletition:^(NSError *error) {
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:0.2 handler:nil];
    XCTAssertEqual(RequestBatchSendCount, 0);
}

#pragma mark - Swizzling

- (void)resetTrackerCounters {
    RequestBatchSendCount = 0;
    RequestBatchBackgroundCount = 0;
    RequestBatchLastURL = nil;
    RequestBatchLastBody = nil;
}

- (void)swizzleTrackerMethods {
    if (RequestBatchOriginalSendIMP != NULL) {
        return;
    }

    Method sendMethod = class_getInstanceMethod([MITrackerRequest class], @selector(sendRequestWith:andBody:andCompletition:));
    RequestBatchOriginalSendIMP = method_getImplementation(sendMethod);
    IMP newSendImp = imp_implementationWithBlock(^void(id _self, NSURL *url, NSString *body, void (^handler)(NSError *error)) {
        RequestBatchSendCount += 1;
        RequestBatchLastURL = url;
        RequestBatchLastBody = body;
        if (handler) {
            handler(nil);
        }
    });
    class_replaceMethod([MITrackerRequest class], @selector(sendRequestWith:andBody:andCompletition:), newSendImp, method_getTypeEncoding(sendMethod));

    Method backgroundMethod = class_getInstanceMethod([MITrackerRequest class], @selector(sendBackgroundRequestWith:andBody:));
    RequestBatchOriginalBackgroundIMP = method_getImplementation(backgroundMethod);
    IMP newBackgroundImp = imp_implementationWithBlock(^void(id _self, NSURL *url, NSString *body) {
        RequestBatchBackgroundCount += 1;
        RequestBatchLastURL = url;
        RequestBatchLastBody = body;
    });
    class_replaceMethod([MITrackerRequest class], @selector(sendBackgroundRequestWith:andBody:), newBackgroundImp, method_getTypeEncoding(backgroundMethod));
}

- (void)restoreTrackerMethods {
    if (RequestBatchOriginalSendIMP == NULL) {
        return;
    }
    Method sendMethod = class_getInstanceMethod([MITrackerRequest class], @selector(sendRequestWith:andBody:andCompletition:));
    class_replaceMethod([MITrackerRequest class], @selector(sendRequestWith:andBody:andCompletition:), RequestBatchOriginalSendIMP, method_getTypeEncoding(sendMethod));

    Method backgroundMethod = class_getInstanceMethod([MITrackerRequest class], @selector(sendBackgroundRequestWith:andBody:));
    class_replaceMethod([MITrackerRequest class], @selector(sendBackgroundRequestWith:andBody:), RequestBatchOriginalBackgroundIMP, method_getTypeEncoding(backgroundMethod));

    RequestBatchOriginalSendIMP = NULL;
    RequestBatchOriginalBackgroundIMP = NULL;
}

@end
