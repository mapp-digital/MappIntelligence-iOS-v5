//
//  ParameterTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 28/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIParameter.h"

@interface ParameterTest : XCTestCase

@property MIParameter* parameter;

@end

@implementation ParameterTest

- (void)setUp {
    _parameter = [[MIParameter alloc] init];
}

- (void)tearDown {
    _parameter = nil;
}

- (void)testInitWithKeyedValues {
    NSDictionary *keyedValues = @{
        @"id" : @1234,
      @"name" : @"parameterName",
      @"value" : @"parameterValue",
        @"request_table_id" : @123
    };
    _parameter = [[MIParameter alloc] initWithKeyedValues:keyedValues];
    XCTAssertTrue([_parameter.uniqueId isEqualToNumber:@1234], @"Parameter ID is not correct!");
    XCTAssertTrue([_parameter.name isEqualToString:@"parameterName"], @"Parameter name is not correct!");
    XCTAssertTrue([_parameter.value isEqualToString:@"parameterValue"], @"Parameter value is not correct!");
    XCTAssertTrue([_parameter.request_uniqueId isEqualToNumber:@123], @"Parameter request ID is not correct!");
}

- (void)testDictionaryWithValuesForKeys {
    NSDictionary *keyedValues = @{
        @"id" : @1234,
      @"name" : @"parameterName",
      @"value" : @"parameterValue",
        @"request_table_id" : @123
    };
    _parameter = [[MIParameter alloc] initWithKeyedValues:keyedValues];
    NSDictionary *newKeyedValues = [_parameter dictionaryWithValuesForKeys];
    XCTAssertTrue([keyedValues isEqualToDictionary:newKeyedValues], "The created dictictionary is not the same with base one!");
}

- (void)testPrint {
    NSDictionary *keyedValues = @{
        @"id" : @1234,
      @"name" : @"parameterName",
      @"value" : @"parameterValue",
        @"request_table_id" : @123
    };
    _parameter = [[MIParameter alloc] initWithKeyedValues:keyedValues];
    NSString *printDescription = [_parameter print];
    XCTAssertTrue([printDescription isEqualToString: @"\n\n name: parameterName, value: parameterValue"], "The printed description not the same as it initialy setup!");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
