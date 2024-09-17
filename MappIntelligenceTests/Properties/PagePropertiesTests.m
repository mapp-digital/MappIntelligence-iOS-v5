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
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properies];
    
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

// Test initialization with page parameters, category, and search term
- (void)testInitWithPageParams {
    NSDictionary<NSNumber *, NSString *> *pageParams = @{@1: @"value1", @2: @"value2"};
    NSMutableDictionary *category = [@{@"category1": @"value1"} mutableCopy];
    NSString *searchTerm = @"testSearch";
    
    MIPageParameters *pageParamsObj = [[MIPageParameters alloc] initWithPageParams:pageParams pageCategory:category search:searchTerm];
    
    XCTAssertNotNil(pageParamsObj);
    XCTAssertEqualObjects(pageParamsObj.details, pageParams);
    XCTAssertEqualObjects(pageParamsObj.groups, category);
    XCTAssertEqualObjects(pageParamsObj.internalSearch, searchTerm);
}

// Test initialization with a dictionary
- (void)testInitWithDictionary {
    NSDictionary *dictionary = @{
        @"params": @{@1: @"value1", @2: @"value2"},
        @"categories": @{@"category1": @"value1"},
        @"searchTerm": @"testSearch"
    };
    
    MIPageParameters *pageParamsObj = [[MIPageParameters alloc] initWithDictionary:dictionary];
    
    XCTAssertNotNil(pageParamsObj);
    XCTAssertEqualObjects(pageParamsObj.details, dictionary[@"params"]);
    XCTAssertEqualObjects(pageParamsObj.groups, dictionary[@"categories"]);
    XCTAssertEqualObjects(pageParamsObj.internalSearch, dictionary[@"searchTerm"]);
}

// Test asQueryItems method with details, groups, and internal search
- (void)testAsQueryItemsWithDetailsGroupsAndSearch {
    NSDictionary<NSNumber *, NSString *> *details = @{@1: @"value1", @2: @"value2"};
    NSMutableDictionary *groups = [@{@"category1": @"value1"} mutableCopy];
    NSString *searchTerm = @"testSearch";
    
    MIPageParameters *pageParamsObj = [[MIPageParameters alloc] initWithPageParams:details pageCategory:groups search:searchTerm];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [pageParamsObj asQueryItems];
    
    XCTAssertEqual(queryItems.count, 4);
    XCTAssertEqualObjects(queryItems[0].name, @"cp1");
    XCTAssertEqualObjects(queryItems[0].value, @"value1");
    XCTAssertEqualObjects(queryItems[1].name, @"cp2");
    XCTAssertEqualObjects(queryItems[1].value, @"value2");
    XCTAssertEqualObjects(queryItems[2].name, @"cgcategory1");
    XCTAssertEqualObjects(queryItems[2].value, @"value1");
    XCTAssertEqualObjects(queryItems[3].name, @"is");
    XCTAssertEqualObjects(queryItems[3].value, @"testSearch");
}

// Test asQueryItems method with nil details, groups, and search
- (void)testAsQueryItemsWithNilValues {
    MIPageParameters *pageParamsObj = [[MIPageParameters alloc] initWithPageParams:nil pageCategory:nil search:nil];
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [pageParamsObj asQueryItems];
    
    XCTAssertNotNil(queryItems);
    XCTAssertEqual(queryItems.count, 0);
}


@end
