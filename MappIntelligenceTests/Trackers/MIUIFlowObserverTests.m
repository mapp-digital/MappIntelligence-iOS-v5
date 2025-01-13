//
//  UIFlowObserverTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/6/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MIUIFlowObserver.h"
#import "MIDefaultTracker.h"
#import "MappIntelligenceLogger.h"
#import "APXNetworkManager.h"


@interface MIUIFlowObserverTests : XCTestCase

@property MIDefaultTracker *tracker;
@property MIUIFlowObserver *observer;
@property (nonatomic, strong) MIUIFlowObserver *flowObserver;
@property (nonatomic, strong) id mockTracker;

@end

@implementation MIUIFlowObserverTests

- (void)setUp {
    [super setUp];
    _tracker = [MIDefaultTracker sharedInstance];
    _observer = [[MIUIFlowObserver alloc] initWith:_tracker];
    
    self.mockTracker = OCMClassMock([MIDefaultTracker class]);
        
    self.flowObserver = [[MIUIFlowObserver alloc] initWith:self.mockTracker];
}

- (void)tearDown {
    self.flowObserver = nil;
    [self.mockTracker stopMocking];
    
    [super tearDown];
}

- (void)testInitWithTracker {
    XCTAssertNotNil(_tracker);
    XCTAssertNotNil(_observer);
}

- (void)testSetup {
    XCTAssertTrue([_observer setup]);
}

// Test initialization
- (void)testInitialization {
    XCTAssertNotNil(self.flowObserver);
    OCMVerify([self.mockTracker updateFirstSessionWith:[UIApplication sharedApplication].applicationState]);
}

@end
