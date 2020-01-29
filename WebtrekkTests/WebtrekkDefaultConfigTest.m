//
//  WebtrekkDefaultConfigTest.m
//  WebtrekkTests
//
//  Created by Vladan Randjelovic on 27/01/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface WebtrekkDefaultConfigTest : XCTestCase

@property (nonatomic) WebtrekkDefaultConfig *configuration;

@end

@implementation WebtrekkDefaultConfigTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [super setUp];
    self.configuration = [[WebtrekkDefaultConfig alloc] init];
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
