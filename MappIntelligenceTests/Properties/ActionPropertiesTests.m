//
//  ActionPropertiesTests.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 09/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TrackerRequest.h"
#import "DefaultTracker.h"
#import "ActionProperties.h"


@interface ActionPropertiesTests : XCTestCase
@property ActionProperties* actionProperties;
@property NSMutableDictionary* details;
@property NSString *actionname;
@end

@implementation ActionPropertiesTests

- (void)setUp {
    _details = [@{@20: @[@"1 element"]} copy];
    _actionname = @"TestAction";
    _actionProperties = [[ActionProperties alloc] initWithName:_actionname andDetails:_details];
}

- (void)tearDown {
    _details = nil;
    _actionProperties = nil;
}

- (void)testInitWithNameAndDetails {
    XCTAssertTrue([_actionProperties.name isEqualToString:_actionname], @"The name from action properties is not same as it is used for creation!");
    XCTAssertTrue([_actionProperties.details isEqualToDictionary:_details], @"The details from action properties is not same as it is used for creation!");
}

- (void)testAsQueryItemsForRequest {
    //1. create expected query items
    NSMutableArray<NSURLQueryItem*>* expectedItems = [[NSMutableArray alloc] init];
    [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:@"ct" value:_actionname]];
    if (_details) {
        for(NSString* key in _details) {
            [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"ck%@",key] value: [_details[key] componentsJoinedByString:@";"]]];
        }
    }
    

    //2.Create tracking request
     TrackingEvent *event = [[TrackingEvent alloc] init];
     [event setPageName:@"testPageName"];
     NSString *everid = [[[DefaultTracker alloc] init] generateEverId];
     Properties *properies = [[Properties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
     TrackerRequest *request = [[TrackerRequest alloc] initWithEvent:event andWithProperties:properies];
     
     //3.get resulted list of query items
     NSMutableArray<NSURLQueryItem*>* result = [_actionProperties asQueryItemsFor:request];
     
     XCTAssertTrue([expectedItems isEqualToArray:result], @"The expected query is not the same as ones from result!");
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
