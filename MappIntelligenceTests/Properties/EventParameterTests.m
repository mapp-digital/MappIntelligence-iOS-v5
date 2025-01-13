//
//  EventParameterTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 9.3.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIEventParameters.h"

#define key_parameters @"parameters"
@interface EventParameterTests : XCTestCase

@property NSDictionary<NSNumber* ,NSString*>* parameters;
@property NSDictionary* dictionary;
@property MIEventParameters* eventParameters;

@end

@implementation EventParameterTests

- (void)setUp {
    _parameters = @{@20:@"ck20Param1"};
    _dictionary = @{key_parameters: _parameters};
    _eventParameters = [[MIEventParameters alloc] initWithDictionary:_dictionary];
}

- (void)tearDown {
    _parameters = NULL;
    _dictionary = NULL;
}

- (void)testasQueryItems {
    NSMutableArray<NSURLQueryItem*>* eventPropertiesQueryItems = [_eventParameters asQueryItems];
    
    if (_eventParameters.parameters) {
        for(NSNumber* key in _eventParameters.parameters) {
            NSURLQueryItem* tempItem = [[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"ck%@",key] value: _eventParameters.parameters[key]];
            XCTAssertTrue([eventPropertiesQueryItems containsObject:tempItem], @"Parameters is wrong for event!");
        }
    }
    
    
}

// Test initialization with parameters
- (void)testInitWithParameters {
    NSDictionary<NSNumber *, NSString *> *parameters = @{@1: @"value1", @2: @"value2"};
    MIEventParameters *eventParams = [[MIEventParameters alloc] initWithParameters:parameters];
    
    XCTAssertNotNil(eventParams);
    XCTAssertEqualObjects(eventParams.parameters, parameters);
}

// Test initialization with a dictionary
- (void)testInitWithDictionary {
    NSDictionary *dictionary = @{key_parameters: @{@1: @"value1", @2: @"value2"}};
    MIEventParameters *eventParams = [[MIEventParameters alloc] initWithDictionary:dictionary];
    
    XCTAssertNotNil(eventParams);
    XCTAssertEqualObjects(eventParams.parameters, dictionary[key_parameters]);
}

// Test asQueryItems method when parameters are provided
- (void)testAsQueryItemsWithParameters {
    NSDictionary<NSNumber *, NSString *> *parameters = @{@1: @"value1", @2: @"value2"};
    MIEventParameters *eventParams = [[MIEventParameters alloc] initWithParameters:parameters];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [eventParams asQueryItems];
    
    XCTAssertEqual(queryItems.count, 2);
    XCTAssertEqualObjects(queryItems[0].name, @"ck1");
    XCTAssertEqualObjects(queryItems[0].value, @"value1");
    XCTAssertEqualObjects(queryItems[1].name, @"ck2");
    XCTAssertEqualObjects(queryItems[1].value, @"value2");
}

// Test asQueryItems method when parameters are nil
- (void)testAsQueryItemsWithNilParameters {
    MIEventParameters *eventParams = [[MIEventParameters alloc] initWithParameters:nil];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [eventParams asQueryItems];
    
    XCTAssertNotNil(queryItems);
    XCTAssertEqual(queryItems.count, 0);  // No parameters, no query items
}

@end
