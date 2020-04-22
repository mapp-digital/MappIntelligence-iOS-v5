//
//  TrackerRequestTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/7/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TrackerRequest.h"
#import "TrackingEvent.h"
#import "Properties.h"

@interface TrackerRequestTests : XCTestCase

@property TrackerRequest *request;

@end

@implementation TrackerRequestTests

- (void)setUp {
    [super setUp];
    _request = [[TrackerRequest alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testExample {
    XCTAssertNotNil(_request);
}

- (void)testInitWithEventAndProperties {
    TrackingEvent *event = [[TrackingEvent alloc] init];
    Properties *properties = [[Properties alloc] init];
    _request = [[TrackerRequest alloc] initWithEvent:event andWithProperties:properties];
    XCTAssertNotNil(_request);
    XCTAssertNotNil([_request event]);
    XCTAssertNotNil([_request properties]);
}

- (void)testSendRequestWith {
    NSURL *url = [[NSURL alloc] initWithString:@"https://q3.webtrekk.net/385255285199574/wt?p=500,MappIntelligenceDemoApp.ViewController,0,1125x2436,32,0,1586272855006,0,0,0&eid=6158627047292181549&fns=1&one=0&X-WT-UA=Tracking%20Library%205.0.0%20(iOS%20Version%2013.3%20(Build%2017C45);%20iPhone;%20en_US))&X-WT-IP=192.168.1.3&la=en&eor=1"];
    [_request sendRequestWith:url andCompletition:^(NSError * _Nonnull error) {
        XCTAssertNotNil(error);
    }];
}

@end
