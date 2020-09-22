//
//  ActionEventTests.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 10/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActionEvent.h"

@interface ActionEventTests : XCTestCase
@property NSMutableDictionary* details;
@property ActionEvent* actionEvent;
@property ActionProperties* actionProperties;
@property NSMutableDictionary *sessionDictionary;
@property SessionProperties *sessionProperties;

@end

@implementation ActionEventTests

- (void)setUp {
    _details = [@{@20: @"ck20Override"} copy];
    _actionProperties = [[ActionProperties alloc] initWithProperties: _details];
    _sessionDictionary = [@{@10: @[@"sessionpar1"]} copy];
    _sessionProperties =  [[SessionProperties alloc] initWithProperties: _sessionDictionary];
    _actionEvent = [[ActionEvent alloc] initWithName:@"TestAction" pageName:@"0" actionProperties:_actionProperties sessionProperties:_sessionProperties];
}

- (void)tearDown {
    _actionEvent = nil;
    _details = nil;
    _sessionProperties = nil;
    _actionProperties = nil;
    _sessionDictionary = nil;
}

- (void)testInitWithProperties {
    XCTAssertTrue([[_actionEvent actionProperties] isEqual:_actionProperties], @"Action properties is not the same as it used for creation of action event!");
    XCTAssertTrue([[_actionEvent sessionProperties] isEqual:_sessionProperties], @"Session properties is not the same as it used for creation of action event!");

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
