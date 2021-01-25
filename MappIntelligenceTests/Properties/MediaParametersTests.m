//
//  MediaParametersTests.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 13/01/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIMediaParameters.h"

@interface MediaParametersTests : XCTestCase
@property MIMediaParameters *parameters;
@property NSMutableDictionary *testData;
@end

@implementation MediaParametersTests

- (void)setUp {
    _testData[@"videoName"] = @"TestVideo";
    _testData[@"action"] = @"init";
    _testData[@"position"] = 23;
    _testData[@"duration"] = 100;
    _parameters = [[MIMediaParameters alloc] initWith:_testData[@"videoName"] action:_testData[@"action"] postion:_testData[@"position"] duration:_testData[@"duration"]];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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
