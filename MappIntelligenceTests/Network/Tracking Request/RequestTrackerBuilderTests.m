//
//  RequestTrackerBuilderTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/8/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Properties.h"
#import "TrackingEvent.h"
#import "DefaultTracker.h"
#import "Configuration.h"
#import "RequestTrackerBuilder.h"
#import "TrackerRequest.h"

@interface RequestTrackerBuilderTests : XCTestCase

@property DefaultTracker *tracker;
@property Configuration *configuration;
@property RequestTrackerBuilder *builder;

@end

@implementation RequestTrackerBuilderTests

- (void)setUp {
    [super setUp];
    _tracker = [[DefaultTracker alloc] init];
    _configuration = [[Configuration alloc] init];
    [_configuration setServerUrl:[[NSURL alloc] initWithString:@"https://q3.webtrekk.net"]];
    [_configuration setMappIntelligenceId:@"385255285199574"];
    _builder = [[RequestTrackerBuilder  alloc] initWithConfoguration:_configuration];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
    XCTAssertNotNil(_configuration);
    XCTAssertNotNil(_builder);
    XCTAssertNotNil([_builder configuration]);
}

- (void)testCreateRequestWith {
    TrackingEvent *event = [[TrackingEvent alloc] init];
    NSString *everid = [_tracker generateEverId];
    Properties *properies = [[Properties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
    XCTAssertNotNil(event);
    XCTAssertNotNil(properies);
    XCTAssertNotNil(_builder);
    TrackerRequest *request = [_builder createRequestWith:event andWith:properies];
    XCTAssertNotNil(request);
}

@end
