//
//  MappIntelligenceConfigurationTest.m
//  MappIntelligenceTests
//
//  Created by Vladan Randjelovic on 04/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligenceDefaultConfig.h"

@interface MappIntelligenceConfigurationTest : XCTestCase

@property (nonatomic) MappIntelligenceDefaultConfig *configuration;
@property (nonatomic, strong) NSDictionary *testDictionary;
@end

@implementation MappIntelligenceConfigurationTest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.testDictionary = [[NSDictionary alloc] init];
    self.configuration = [[MappIntelligenceDefaultConfig alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    
    _testDictionary = @{};
   
    XCTAssertEqualObjects( self.configuration, [_configuration initWithDictionary:_testDictionary], @"Loaded default config");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
