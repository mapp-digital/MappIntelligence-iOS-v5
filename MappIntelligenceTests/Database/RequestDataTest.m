//
//  RequestDataTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 28/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RequestData.h"

@interface RequestDataTest : XCTestCase

@property RequestData* requestData;

@end

@implementation RequestDataTest

- (void)setUp {
    _requestData = [[RequestData alloc] init];
}

- (void)tearDown {
    _requestData = nil;
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
