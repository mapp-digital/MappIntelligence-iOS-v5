//
//  MIRequestTrackerBuilderTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 25.11.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIProperties.h"
#import "MITrackingEvent.h"
#import "MIDefaultTracker.h"
#import "MIConfiguration.h"
#import "MIRequestTrackerBuilder.h"
#import "MITrackerRequest.h"

@interface MIRequestTrackerBuilderTests : XCTestCase

@property MIDefaultTracker *tracker;
@property MIConfiguration *configuration;
@property MIRequestTrackerBuilder *builder;

@end

@implementation MIRequestTrackerBuilderTests

- (void)setUp {
    [super setUp];
    _tracker = [[MIDefaultTracker alloc] init];
    _configuration = [[MIConfiguration alloc] init];
    [_configuration setServerUrl:[[NSURL alloc] initWithString:@"https://q3.webtrekk.net"]];
    [_configuration setMappIntelligenceId:@"385255285199574"];
    _builder = [[MIRequestTrackerBuilder  alloc] initWithConfoguration:_configuration];
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
    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    NSString *everid = [_tracker generateEverId];
    MIProperties *properies = [[MIProperties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
    XCTAssertNotNil(event);
    XCTAssertNotNil(properies);
    XCTAssertNotNil(_builder);
    MITrackerRequest *request = [_builder createRequestWith:event andWith:properies];
    XCTAssertNotNil(request);
}

@end

