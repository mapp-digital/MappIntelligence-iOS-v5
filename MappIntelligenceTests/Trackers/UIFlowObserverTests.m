//
//  UIFlowObserverTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "MIDefaultTracker.h"
#import "MIUIFlowObserver.h"


@interface UIFlowObserverTests : XCTestCase

@property MIDefaultTracker *tracker;
@property MIUIFlowObserver *observer;

@end

@implementation UIFlowObserverTests

- (void)setUp {
    [super setUp];
    _tracker = [MIDefaultTracker sharedInstance];
    _observer = [[MIUIFlowObserver alloc] initWith:_tracker];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitWithTracker {
    XCTAssertNotNil(_tracker);
    XCTAssertNotNil(_observer);
}

- (void)testSetup {
    XCTAssertTrue([_observer setup]);
}
@end
