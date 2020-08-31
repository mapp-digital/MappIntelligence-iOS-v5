//
//  PageViewEventTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 31/08/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PageViewEvent.h"

@interface PageViewEventTests : XCTestCase

@property PageViewEvent* pageViewEvent;
@property PageProperties* pageProperties;
@property NSString* internalSearch;
@property NSMutableDictionary* details;
@property NSMutableDictionary* groups;

@end

@implementation PageViewEventTests

- (void)setUp {
    _details = [@{@20: @"cp20Override"} copy];
    _groups = [@{@15: @"testGroups"} copy];
    _internalSearch = @"testSearchTerm";
    _pageProperties = [[PageProperties alloc] initWith:_details andWithGroup:_groups andWithSearch:_internalSearch];
    _pageViewEvent = [[PageViewEvent alloc] initWith:_pageProperties];
}

- (void)tearDown {
    _pageViewEvent = nil;
    _pageProperties = nil;
    _internalSearch = nil;
    _details = nil;
    _groups = nil;
}

- (void)testInitWithProperties {
    XCTAssertTrue([[_pageViewEvent pageProperties] isEqual:_pageProperties], @"Page properties is not the same as it used for creation of page view event!");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
