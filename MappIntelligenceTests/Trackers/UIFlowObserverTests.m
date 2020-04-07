//
//  UIFlowObserverTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/6/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import "DefaultTracker.h"
#import "UIFlowObserver.h"


@interface UIFlowObserverTests : XCTestCase

@property DefaultTracker *tracker;
@property UIFlowObserver *observer;

@end

@implementation UIFlowObserverTests

- (void)setUp {
    [super setUp];
    _tracker = [DefaultTracker sharedInstance];
    _observer = [[UIFlowObserver alloc] initWith:_tracker];
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
