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
@property SessionProperties *sessionProperties;
@property UserProperties *userProperties;
@property EcommerceProperties *ecommerceProperties;
@property NSString* internalSearch;
@property NSMutableDictionary* details;
@property NSMutableDictionary* groups;
@property NSMutableDictionary *sessionDictionary;
@end

@implementation PageViewEventTests

- (void)setUp {
    _details = [@{@20: @[@"cp20Override"]} copy];
    _groups = [@{@15: @[@"testGroups"]} copy];
    _internalSearch = @"testSearchTerm";
    _pageProperties = [[PageProperties alloc] initWithPageParams:_details andWithPageCategory:_groups andWithSearch:_internalSearch];
    _sessionDictionary = [@{@10: @[@"sessionpar1"]} copy];
    _sessionProperties =  [[SessionProperties alloc] initWithProperties: _sessionDictionary];
    _userProperties = [[UserProperties alloc] init];
    _userProperties.city = @"Berlin";
    _ecommerceProperties = [[EcommerceProperties alloc] init];
    Product* product1 = [[Product alloc] init];
    product1.name = @"product1";
    product1.price = @"33$";
    product1.quantity = [[NSNumber alloc] initWithInteger:22];
    Product* product2 = [[Product alloc] init];
    product2.name = @"product2";
    _ecommerceProperties.products = [[NSArray alloc] initWithObjects:product1, product2, nil];
    _pageViewEvent = [[PageViewEvent alloc] initWithName:@"test custom name" pageProperties:_pageProperties sessionProperties:_sessionProperties userProperties:_userProperties ecommerceProperties:_ecommerceProperties];
}

- (void)tearDown {
    _pageViewEvent = nil;
    _pageProperties = nil;
    _internalSearch = nil;
    _details = nil;
    _groups = nil;
    _sessionDictionary = nil;
    _sessionProperties = nil;
    _ecommerceProperties = nil;
}

- (void)testInitWithProperties {
    XCTAssertTrue([[_pageViewEvent pageProperties] isEqual:_pageProperties], @"Page properties is not the same as it used for creation of page view event!");
    XCTAssertTrue([[_pageViewEvent sessionProperties] isEqual:_sessionProperties], @"Session properties is not the same as it used for creation of page view event!");

}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
