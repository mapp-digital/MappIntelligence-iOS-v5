//
//  MIRequestUrlBuilderTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 25.11.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIProperties.h"
#import "MITrackingEvent.h"
#import "MIDefaultTracker.h"
#import "MIRequestUrlBuilder.h"
#import "MITrackerRequest.h"

@interface MIRequestUrlBuilderTests : XCTestCase

@property MIDefaultTracker *tracker;
@property MIRequestUrlBuilder *builder;

@end

@implementation MIRequestUrlBuilderTests

- (void)setUp {
    [super setUp];
    _tracker = [[MIDefaultTracker alloc] init];
    NSURL *url = [[NSURL alloc] initWithString:@"https://q3.webtrekk.net"];
    _builder = [[MIRequestUrlBuilder  alloc] initWithUrl:url andWithId:@"385255285199574"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
    XCTAssertNotNil(_builder);
}

- (void)testUrlForRequest {
    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    [event setPageName:@"testPageName"];
    NSString *everid = [_tracker generateEverId];
    MIProperties *properies = [[MIProperties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properies];
    NSURL *url = [_builder urlForRequest:request withCustomData:NO];
    XCTAssertNotNil(url);
}

- (void)testUrlForAnonymousRequest {
    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    [event setPageName:@"testPageName"];
    NSString *everid = [_tracker generateEverId];
    [_tracker setAnonymousTracking:true];
    MIProperties *properies = [[MIProperties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properies];
    NSURL *url = [_builder urlForRequest:request withCustomData:NO];
    XCTAssertFalse([[url absoluteString] containsString:@"eid="]);
    XCTAssertTrue([[url absoluteString] containsString:@"nc=1"]);
}

- (void)testcreateURLFromParametersWith {
    //1. create parameters
    NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1Name" value:@"parameter1Value"];
    NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2Value"];
    NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
    
    //2. test url
    NSURL* url = [_builder createURLFromParametersWith:array];
    XCTAssertNotNil(url);
    XCTAssertNotNil(url.scheme);
    XCTAssertNotNil(url.host);
}
@end
