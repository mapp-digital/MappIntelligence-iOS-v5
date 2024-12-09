//
//  TrackerRequestTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MITrackerRequest.h"
#import "MITrackingEvent.h"
#import "MIProperties.h"

@interface TrackerRequestTests : XCTestCase

@property MITrackerRequest *request;
@property (nonatomic, strong) MITrackerRequest *trackerRequest;

@end

@implementation TrackerRequestTests

- (void)setUp {
    [super setUp];
    _request = [MITrackerRequest shared];
    self.trackerRequest = [MITrackerRequest shared];
}

- (void)tearDown {
    self.trackerRequest = nil;
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
    NSURL *url = [[NSURL alloc] initWithString:@"https://q3.webtrekk.net/385255285199574/wt?p=500,MappIntelligenceDemoApp.ViewController,0,1125x2436,32,0,1586272855006,0,0,0&eid=6158627047292181549&fns=1&one=0&X-WT-UA=Tracking%20Library%205.0.4%20(iOS%20Version%2013.3%20(Build%2017C45);%20iPhone;%20en_US))&X-WT-IP=192.168.1.3&la=en&eor=1"];
    [_request sendRequestWith:url andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNotNil(error);
    }];
}

- (void)testSendRequestWithURLAndBody {
    NSURL *url = [[NSURL alloc] initWithString:@"http://tracker-int-01.webtrekk.net/794940687426749/batch?eid=6159533923421872647&X-WT-UA=Tracking%20Library%205.0.4%20(iOS%20Version%2013.6%20(Build%2017G64);%20iPhone;%20en_US"];
    NSString* body = @"wt?p=500,testCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStringNametestCustomStrin,0,750x1334,32,0,1596547757909,0,0,0&fns=0&one=0&X-WT-IP=192.168.1.6&la=en&eor=1\nwt?p=500,defaultName,0,750x1334,32,0,1596547763110,0,0,0&fns=0&one=0&X-WT-IP=192.168.1.6&la=en&eor=1&cp20=cp20Override&is=testSearchTerm\nwt?p=500,MappIntelligenceDemoApp.ViewController,0,750x1334,32,0,1596548558601,0,0,0&fns=0&one=0&X-WT-IP=192.168.1.6&la=en&eor=1";
    [_request sendRequestWith:url andBody: body andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNotNil(error);
    }];
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

- (void)testSendRequestWithCompletion {
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should complete"];
    
    [self.trackerRequest sendRequestWith:url andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNil(error, @"Error should be nil on successful request");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testSendRequestWithBody {
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    NSString *body = @"Sample Body";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Request should complete"];
    
    [self.trackerRequest sendRequestWith:url andBody:body andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNil(error, @"Error should be nil on successful request");
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5 handler:nil];
}

//- (void)testCreateRequest {
//    NSURL *url = [NSURL URLWithString:@"https://example.com"];
//    NSString *body = @"Sample Body";
//    NSURLRequest *request = [self.trackerRequest createRequest:url andBody:body];
//    
//    XCTAssertNotNil(request, @"Request should not be nil");
//    XCTAssertEqualObjects(request.HTTPMethod, @"POST", @"HTTP method should be POST");
//    XCTAssertEqualObjects(request.HTTPBody, [body dataUsingEncoding:NSUTF8StringEncoding], @"HTTP body should match");
//    XCTAssertEqualObjects([request valueForHTTPHeaderField:@"Content-Type"], @"text/plain; charset=utf-8", @"Content-Type header should be set");
//}

- (void)testBackgroundRequest {
    NSURL *url = [NSURL URLWithString:@"https://example.com"];
    NSString *body = @"Sample Body";

    [self.trackerRequest sendBackgroundRequestWith:url andBody:body];
    
    // Since this method does not have a completion handler,
    // you might want to check internal state or log output
    // or use a mock session if you want to validate network behavior.
}

@end
