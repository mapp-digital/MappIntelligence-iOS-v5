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
@end

@implementation ActionEventTests

- (void)setUp {
    _details = [@{@20: @"ck20Override"} copy];
    _actionProperties = [[ActionProperties alloc] initWithName: @"TestEvent" andDetails: _details];
    _actionEvent = [[ActionEvent alloc] initWithPageName:@"0" andActionProperties:_actionProperties];
}

- (void)tearDown {

}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
