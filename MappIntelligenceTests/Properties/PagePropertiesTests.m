//
//  PagePropertiesTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 31/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIPageParameters.h"
#import "MITrackerRequest.h"
#import "MIDefaultTracker.h"

#define key_details @"params"
#define key_groups @"categories"
#define key_internal_search @"searchTerm"

@interface PagePropertiesTests : XCTestCase

@property MIPageParameters* pageProperties;
@property NSString* internalSearch;
@property NSMutableDictionary* details;
@property NSMutableDictionary* groups;
@property NSDictionary* dictionary;

@end

@implementation PagePropertiesTests

- (void)setUp {
    _details = [@{@20: @[@"cp20Override"]} copy];
    _groups = [@{@15: @[@"testGroups"]} copy];
    _internalSearch = @"testSearchTerm";
    _pageProperties = [[MIPageParameters alloc] initWithPageParams:_details pageCategory:_groups search:_internalSearch];
    _dictionary = @{key_details: _details, key_groups: _groups, key_internal_search: _internalSearch};
}

- (void)tearDown {
    _pageProperties = nil;
    _internalSearch = nil;
    _details = nil;
    _groups = nil;
}

- (void)testInitWithDetailsAndGroup {
    XCTAssertTrue([_pageProperties.details isEqualToDictionary:_details], @"The details from page properties is not same as it is used for creation!");
    XCTAssertTrue([_pageProperties.groups isEqualToDictionary:_groups], @"The groups from page properties is not same as it is used for creation!");
    XCTAssertTrue([_pageProperties.internalSearch isEqualToString:_internalSearch], @"The internal search from page properties is not same as it is used for creation!");
}

- (void)testInitWithDictionary {
    MIPageParameters* pageParameters = [[MIPageParameters alloc] initWithDictionary:_dictionary];
    XCTAssertTrue([pageParameters.details isEqualToDictionary:_details], @"The details from page properties is not same as it is used for creation!");
    XCTAssertTrue([pageParameters.groups isEqualToDictionary:_groups], @"The groups from page properties is not same as it is used for creation!");
    XCTAssertTrue([pageParameters.internalSearch isEqualToString:_internalSearch], @"The internal search from page properties is not same as it is used for creation!");
}

- (void)testAsQueryItemsForRequest {
    //1. create expected query items
    NSMutableArray<NSURLQueryItem*>* expectedItems = [[NSMutableArray alloc] init];
    if (_details) {
        for(NSString* key in _details) {
            [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cp%@",key] value: _details[key]]];
        }
    }
    if (_groups) {
        for(NSString* key in _groups) {
            [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cg%@",key] value: _groups[key]]];
        }
    }
    [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:@"is" value:_internalSearch]];
    
    //2.Create tracking request
    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    [event setPageName:@"testPageName"];
    NSString *everid = [[[MIDefaultTracker alloc] init] generateEverId];
    MIProperties *properies = [[MIProperties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest alloc] initWithEvent:event andWithProperties:properies];
    
    //3.get resulted list of query items
    NSMutableArray<NSURLQueryItem*>* result = [_pageProperties asQueryItems];
    
    XCTAssertTrue([expectedItems isEqualToArray:result], @"The expected query is not the same as ones from result!");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
