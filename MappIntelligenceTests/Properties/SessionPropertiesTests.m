//
//  SessionPropertiesTests.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 15/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MISessionParameters.h"
#import "MIDefaultTracker.h"
#import "MIProperties.h"
#import "MITrackerRequest.h"

#define key_parameters @"parameters"

@interface SessionPropertiesTests : XCTestCase
@property NSMutableDictionary *sessionDictionary;
@property MISessionParameters *sessionProperties;
@property NSDictionary* dictionary;
@end

@implementation SessionPropertiesTests

- (void)setUp {
    _sessionDictionary = [@{@10: @[@"sessionpar1"]} copy];
    _sessionProperties =  [[MISessionParameters alloc] initWithParameters: _sessionDictionary];
    _dictionary = @{key_parameters: _sessionDictionary};
}

- (void)tearDown {
    _sessionDictionary = NULL;
    _sessionProperties = NULL;
    _dictionary = NULL;
}

- (void)testInitWithProperties {
    XCTAssertTrue([_sessionProperties.parameters isEqualToDictionary:_sessionDictionary], @"The dicitonary from session properties is not same as it is used for creation!");
}

- (void)testInitWithDictionary {
    MISessionParameters* sessionParameter = [[MISessionParameters alloc] initWithDictionary:_dictionary];
    XCTAssertTrue([sessionParameter.parameters isEqualToDictionary:_sessionDictionary], @"The dicitonary from session properties is not same as it is used for creation!");
}

- (void)testAsQueryItemsForRequest {
    //1. create expected query items
    NSMutableArray<NSURLQueryItem*>* expectedItems = [[NSMutableArray alloc] init];
    if (_sessionDictionary) {
        for(NSString* key in _sessionDictionary) {
            [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cs%@",key] value: _sessionDictionary[key]]];
        }
    }
     
     //2.get resulted list of query items
     NSMutableArray<NSURLQueryItem*>* result = [_sessionProperties asQueryItems];
     
     XCTAssertTrue([expectedItems isEqualToArray:result], @"The expected query is not the same as ones from result!");
}

@end
