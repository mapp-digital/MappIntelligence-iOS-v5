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

- (void)testInitWithParameters {
    MIEventParameters* eventPr = [[MIEventParameters alloc] initWithParameters:_parameters];
    XCTAssertTrue(eventPr.parameters == _parameters, @"Parameters is wrong for event!");
}

- (void)testInitWithDictionary {
    XCTAssertTrue(_eventParameters.parameters == _parameters, @"Parameters is wrong for event!");
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

@end
