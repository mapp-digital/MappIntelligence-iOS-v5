//
//  PropertiesTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/8/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIProperties.h"
#import "MIDefaultTracker.h"

@interface PropertiesTests : XCTestCase

@property MIProperties *properies;
@property MIDefaultTracker *tracker;

@end

@implementation PropertiesTests

- (void)setUp {
    [super setUp];
    _tracker = [[MIDefaultTracker alloc] init];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInit {
    NSString *everid = [_tracker generateEverId];
    _properies = [[MIProperties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
    XCTAssertNotNil(_properies);
    XCTAssertNotNil([_properies everId]);
    XCTAssertNotNil([_properies timestamp]);
    XCTAssertNotNil([_properies timeZone]);
    XCTAssertNotNil([_properies userAgent]);
    
}
@end
