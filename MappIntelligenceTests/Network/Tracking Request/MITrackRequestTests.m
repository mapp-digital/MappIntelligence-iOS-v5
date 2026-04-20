//
//  MITrackRequestTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 25.11.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "MITrackerRequest.h"
#import "MITrackingEvent.h"
#import "MIProperties.h"
#import "MITestURLProtocol.h"

@interface MITrackerRequest (TestAccess)
- (NSURLRequest *)createRequest:(NSURL *)url andBody:(NSString *)body;
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data;
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(NSError *)error;
@end

static IMP MITrackerRequestSharedApplicationIMP = NULL;
static id MITrackerRequestTestApplicationInstance = nil;

@interface MITrackerRequestTestApplication : NSObject
@property (nonatomic, assign) UIBackgroundTaskIdentifier lastEndedIdentifier;
@end

@implementation MITrackerRequestTestApplication

- (void)endBackgroundTask:(UIBackgroundTaskIdentifier)identifier {
    self.lastEndedIdentifier = identifier;
}

@end

@interface MITrackerRequestTests : XCTestCase

@property MITrackerRequest *request;
@property (nonatomic, strong) MITrackerRequest *trackerRequest;
@property XCTestExpectation *expectationFirst;
@property XCTestExpectation *expectationSecond;

@end

@implementation MITrackerRequestTests

- (void)setUp {
    [super setUp];
    _request = [MITrackerRequest shared];
    self.trackerRequest = [MITrackerRequest shared];

    [MITestURLProtocol stubWithStatusCode:200 data:[NSData data] error:nil];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    configuration.protocolClasses = @[ [MITestURLProtocol class] ];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    [self.trackerRequest setValue:session forKey:@"urlSession"];
}

- (void)tearDown {
    self.trackerRequest = nil;
    [self restoreSharedApplicationSwizzle];
    [super tearDown];
}

- (void)testExample {
    XCTAssertNotNil(_request);
}

- (void)testInitWithEventAndProperties {
    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    MIProperties *properties = [[MIProperties alloc] init];
    _request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properties];
    XCTAssertNotNil(_request);
    XCTAssertNotNil([_request event]);
    XCTAssertNotNil([_request properties]);
}

- (void)testSendRequestWith {
    NSURL *url = [[NSURL alloc] initWithString:@"https://q3.webtrekk.net/385255285199574/wt?p=500,MappIntelligenceDemoApp.ViewController,0,1125x2436,32,0,1586272855006,0,0,0&eid=6158627047292181549&fns=1&one=0&X-WT-UA=Tracking%20Library%205.1.1%20(iOS%20Version%2013.3%20(Build%2017C45);%20iPhone;%20en_US))&X-WT-IP=192.168.1.3&la=en&eor=1"];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should complete"];

    [_request sendRequestWith:url andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testSendRequestWithURLAndBody {
    NSURL *url = [[NSURL alloc] initWithString:@"http://tracker-int-01.webtrekk.net/794940687426749/batch?eid=6159533923421872647&X-WT-UA=Tracking%20Library%205.0.4%20(iOS%20Version%2013.6%20(Build%2017G64);%20iPhone;%20en_US"];
    NSString* body = @"wt?p=500,testCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStrin,0,750x1334,32,0,1596547757909,0,0,0&fns=0&one=0&X-WT-IP=192.168.1.6&la=en&eor=1\nwt?p=500,defaultName,0,750x1334,32,0,1596547763110,0,0,0&fns=0&one=0&X-WT-IP=192.168.1.6&la=en&eor=1&cp20=cp20Override&is=testSearchTerm\nwt?p=500,MappIntelligenceDemoApp.ViewController,0,750x1334,32,0,1596548558601,0,0,0&fns=0&one=0&X-WT-IP=192.168.1.6&la=en&eor=1";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should complete"];

    [_request sendRequestWith:url andBody: body andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNil(error);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testSendRequestWithErrorReturnsError {
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    NSError *testError = [NSError errorWithDomain:@"MITrackerRequestTests" code:17 userInfo:nil];
    [MITestURLProtocol stubWithStatusCode:500 data:nil error:testError];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should return error"];
    [self.trackerRequest sendRequestWith:url andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, @"MITrackerRequestTests");
        XCTAssertEqual(error.code, 17);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testSendRequestWithBodyReturnsError {
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    NSString *body = @"body";
    NSError *testError = [NSError errorWithDomain:@"MITrackerRequestTests" code:19 userInfo:nil];
    [MITestURLProtocol stubWithStatusCode:500 data:nil error:testError];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should return error"];
    [self.trackerRequest sendRequestWith:url andBody:body andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, @"MITrackerRequestTests");
        XCTAssertEqual(error.code, 19);
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testSharedInstance {
    MITrackerRequest *anotherInstance = [MITrackerRequest shared];
    XCTAssertEqual(self.trackerRequest, anotherInstance, @"The shared instance should be the same");
}

- (void)testInitWithEventAndPropertiesSecond {
    MITrackingEvent *event = [[MITrackingEvent alloc] init]; // Assuming initializer is available
    MIProperties *properties = [[MIProperties alloc] init]; // Assuming initializer is available
    MITrackerRequest *request = [[MITrackerRequest alloc] initWithEvent:event andWithProperties:properties];
    
    XCTAssertNotNil(request, @"The request should be initialized");
    // Further assertions can be added to check properties are set correctly
}

- (void)testSendRequestWithBody {
    NSURL *url = [NSURL URLWithString:@"http://tracker-int-01.webtrekk.net/794940687426749/batch?eid=6173676774907917685&X-WT-UA=Tracking%20Library%205.q.0%20%28iOS%2018.0%3B%20iPhone%3B%20en_RS%29%29"];
    NSString *body = @"wt?p=500,MappIntelligenceDemoApp.PageViewController,0,750x1334,32,0,1736797465512,0,0,0&fns=1&one=0&cs801=5.1.1&cs802=iOS&pf=71&la=en&cs804=1.0&cs805=3&cs821=0&eor=1";
    
    _expectationSecond = [self expectationWithDescription:@"Request should complete"];
    
    [self.trackerRequest sendRequestWith:url andBody:body andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNil(error, @"Error should be nil on successful request");
        [self->_expectationSecond fulfill];
    }];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testSendRequestWithCompletion {
    NSURL *url = [NSURL URLWithString:@"http://tracker-int-01.webtrekk.net/794940687426749/batch?eid=6173676774907917685&X-WT-UA=Tracking%20Library%205.1.1%20%28iOS%2018.0%3B%20iPhone%3B%20en_RS%29%29"];
    
    _expectationFirst = [self expectationWithDescription:@"Request should complete"];
    
    [self.trackerRequest sendRequestWith:url andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNil(error, @"Error should be nil on successful request");
        [self->_expectationFirst fulfill];
    }];
    [self waitForExpectationsWithTimeout:1.0 handler:nil];
}

- (void)testCreateRequestSetsHeadersAndBody {
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    NSString *body = @"Sample Body";
    NSURLRequest *request = [self.trackerRequest createRequest:url andBody:body];

    XCTAssertNotNil(request);
    XCTAssertEqualObjects(request.HTTPMethod, @"POST");
    XCTAssertEqualObjects([request valueForHTTPHeaderField:@"Content-Type"], @"text/plain; charset=utf-8");
    XCTAssertEqualObjects([request valueForHTTPHeaderField:@"Accept"], @"text/plain; charset=utf-8");
    NSString *bodyString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    XCTAssertEqualObjects(bodyString, body);
}

- (void)testBackgroundRequest {
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    NSString *body = @"Sample Body";

    [self.trackerRequest sendBackgroundRequestWith:url andBody:body];
    
    // Since this method does not have a completion handler,
    // you might want to check internal state or log output
    // or use a mock session if you want to validate network behavior.
}

- (void)testURLSessionDidReceiveDataEndsBackgroundTask {
    MITrackerRequestTestApplication *testApp = [self swizzleSharedApplication];
    [[NSUserDefaults standardUserDefaults] setInteger:42 forKey:@"backgroundIdentifier"];

    [self.trackerRequest URLSession:nil dataTask:nil didReceiveData:[NSData data]];
    XCTAssertEqual(testApp.lastEndedIdentifier, 42);
}

- (void)testURLSessionDidBecomeInvalidEndsBackgroundTask {
    MITrackerRequestTestApplication *testApp = [self swizzleSharedApplication];
    [[NSUserDefaults standardUserDefaults] setInteger:77 forKey:@"backgroundIdentifier"];

    NSError *error = [NSError errorWithDomain:@"MITrackerRequestTests" code:2 userInfo:nil];
    [self.trackerRequest URLSession:nil didBecomeInvalidWithError:error];
    XCTAssertEqual(testApp.lastEndedIdentifier, 77);
}

#pragma mark - Swizzling

- (MITrackerRequestTestApplication *)swizzleSharedApplication {
    if (MITrackerRequestSharedApplicationIMP != NULL) {
        return MITrackerRequestTestApplicationInstance;
    }
    Class metaClass = object_getClass([UIApplication class]);
    Method method = class_getClassMethod([UIApplication class], @selector(sharedApplication));
    IMP newIMP = imp_implementationWithBlock(^id(__unused id _self) {
        return MITrackerRequestTestApplicationInstance;
    });
    if (!method) {
        class_addMethod(metaClass, @selector(sharedApplication), newIMP, "@@:");
        MITrackerRequestTestApplicationInstance = nil;
        MITrackerRequestSharedApplicationIMP = NULL;
        return nil;
    }
    MITrackerRequestSharedApplicationIMP = method_getImplementation(method);
    MITrackerRequestTestApplicationInstance = [[MITrackerRequestTestApplication alloc] init];
    method_setImplementation(method, newIMP);
    return MITrackerRequestTestApplicationInstance;
}

- (void)restoreSharedApplicationSwizzle {
    if (MITrackerRequestSharedApplicationIMP == NULL) {
        return;
    }
    Class metaClass = object_getClass([UIApplication class]);
    Method method = class_getClassMethod([UIApplication class], @selector(sharedApplication));
    if (method) {
        method_setImplementation(method, MITrackerRequestSharedApplicationIMP);
    } else {
        class_addMethod(metaClass, @selector(sharedApplication), MITrackerRequestSharedApplicationIMP, "@@:");
    }
    MITrackerRequestSharedApplicationIMP = NULL;
    MITrackerRequestTestApplicationInstance = nil;
}

@end
