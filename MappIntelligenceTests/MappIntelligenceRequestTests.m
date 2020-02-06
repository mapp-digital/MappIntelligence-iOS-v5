//
//  MappIntelligenceRequestTests.m
//  MappIntelligenceTests
//
//  Created by Vladan Randjelovic on 06/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MappIntelligenceRequest.h"

@interface MappIntelligenceRequestTests : XCTestCase

@end

@implementation MappIntelligenceRequestTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInitialization
{
    XCTAssertNotNil([[MappIntelligenceRequest alloc] init]);
}

- (void)testParsingWithNoAddedKeyes
{
    MappIntelligenceRequest *request = [[MappIntelligenceRequest alloc] init];
    
    NSDictionary *keyedValues = [request dictionaryWithValuesForKeys:@[]];
    
    XCTAssertTrue(([[keyedValues allKeys] count] == 1), @"keys count is: %tu", [[keyedValues allKeys] count]);
}

- (void)testParsingWithAddedKey
{
    MappIntelligenceRequest *request = [[MappIntelligenceRequest alloc] init];
    
    [request addKeyedValues:@{@"key" : @"value", @"key2" : @"value"} forKeyType:kMappIntelligenceRequestKeyTypeRegister];
    
    NSDictionary *keyedValues = [request dictionaryWithValuesForKeys:@[]];
    
    XCTAssertTrue(([[keyedValues allKeys] count] == 1), @"keys count is: %tu", [[keyedValues allKeys] count]);
    
    NSDictionary *registerDic = keyedValues[@"actions"][@"register"];
    
    XCTAssertTrue(([[registerDic allKeys] count] == 2), @"keys count is: %tu", [[registerDic allKeys] count]);
    
    [request addKeyedValues:@{@"key" : @"value", @"key2" : @"value", @"key3" : @"value"} forKeyType:kMappIntelligenceRequestKeyTypeApplicationConfiguration];
    
    
    keyedValues = [request dictionaryWithValuesForKeys:@[]];
    
    XCTAssertTrue(([[keyedValues[@"actions"] allKeys] count] == 2), @"keys count is: %tu", [[keyedValues[@"actions"] allKeys] count]);
    
    NSDictionary *applicationConfigurationDic = keyedValues[@"actions"][@"app_conf"];
    
    XCTAssertTrue(([[applicationConfigurationDic allKeys] count] == 3), @"keys count is: %tu", [[applicationConfigurationDic allKeys] count]);
}

@end
