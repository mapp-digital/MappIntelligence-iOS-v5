//
//  ParameterTest.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 28/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIParameter.h"
#define key_id @"id"
#define key_name @"name"
#define key_value @"value"
#define key_request_id @"request_table_id"

@interface MIParameterTest : XCTestCase

@property MIParameter* parameter;

@end

@implementation MIParameterTest

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

- (void)testInitializationWithValidDictionary {
    NSDictionary *input = @{
        @"id": @1,
        @"name": @"Test Parameter",
        @"value": @"Test Value",
        @"request_table_id": @100
    };
    
    MIParameter *parameter = [[MIParameter alloc] initWithKeyedValues:input];
    
    XCTAssertNotNil(parameter, @"Parameter should be initialized");
    XCTAssertEqual(parameter.uniqueId.integerValue, 1, @"uniqueId should be set correctly");
    XCTAssertEqualObjects(parameter.name, @"Test Parameter", @"Name should be set correctly");
    XCTAssertEqualObjects(parameter.value, @"Test Value", @"Value should be set correctly");
    XCTAssertEqual(parameter.request_uniqueId.integerValue, 100, @"request_uniqueId should be set correctly");
}

- (void)testInitializationWithMissingKeys {
    NSDictionary *input = @{
        @"name": @"Test Parameter"
    };
    
    MIParameter *parameter = [[MIParameter alloc] initWithKeyedValues:input];
    
    XCTAssertNotNil(parameter, @"Parameter should be initialized");
    XCTAssertNil(parameter.uniqueId, @"uniqueId should be nil");
    XCTAssertEqualObjects(parameter.name, @"Test Parameter", @"Name should be set correctly");
    XCTAssertNil(parameter.value, @"Value should be nil");
    XCTAssertNil(parameter.request_uniqueId, @"request_uniqueId should be nil");
}

- (void)testDictionaryWithValuesForKeysUpdate {
    MIParameter *parameter = [[MIParameter alloc] init];
    parameter.uniqueId = @1;
    parameter.name = @"Test Parameter";
    parameter.value = @"Test Value";
    parameter.request_uniqueId = @100;

    NSDictionary *result = [parameter dictionaryWithValuesForKeys];

    XCTAssertNotNil(result, @"Result dictionary should not be nil");
    XCTAssertEqual(result.count, 4, @"Result dictionary should contain 4 keys");
    XCTAssertEqual(result[key_id], parameter.uniqueId, @"uniqueId should be in the dictionary");
    XCTAssertEqualObjects(result[key_name], parameter.name, @"Name should be in the dictionary");
    XCTAssertEqualObjects(result[key_value], parameter.value, @"Value should be in the dictionary");
    XCTAssertEqual(result[key_request_id], parameter.request_uniqueId, @"request_uniqueId should be in the dictionary");
}

- (void)testPrintMethod {
    MIParameter *parameter = [[MIParameter alloc] init];
    parameter.name = @"Test Parameter";
    parameter.value = @"Test Value";

    NSString *result = [parameter print];

    XCTAssertEqualObjects(result, @"\n\n name: Test Parameter, value: Test Value", @"Print method should format correctly");
}

@end
