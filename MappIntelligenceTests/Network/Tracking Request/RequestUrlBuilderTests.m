//
//  RequestUrlBuilderTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/8/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Properties.h"
#import "TrackingEvent.h"
#import "DefaultTracker.h"
#import "RequestUrlBuilder.h"
#import "TrackerRequest.h"

@interface RequestUrlBuilderTests : XCTestCase

@property DefaultTracker *tracker;
@property RequestUrlBuilder *builder;

@end

@implementation RequestUrlBuilderTests

- (void)setUp {
    [super setUp];
    _tracker = [[DefaultTracker alloc] init];
    NSURL *url = [[NSURL alloc] initWithString:@"https://q3.webtrekk.net"];
    _builder = [[RequestUrlBuilder  alloc] initWithUrl:url andWithId:@"385255285199574"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
    XCTAssertNotNil(_builder);
}

- (void)testUrlForRequest {
    TrackingEvent *event = [[TrackingEvent alloc] init];
    [event setPageName:@"testPageName"];
    NSString *everid = [_tracker generateEverId];
    Properties *properies = [[Properties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
    TrackerRequest *request = [[TrackerRequest alloc] initWithEvent:event andWithProperties:properies];
    NSURL *url = [_builder urlForRequest:request];
    XCTAssertNotNil(url);
}
@end
