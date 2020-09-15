//
//  SessionPropertiesTests.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 15/09/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SessionProperties.h"
#import "DefaultTracker.h"

@interface SessionPropertiesTests : XCTestCase
@property NSMutableDictionary *sessionDictionary;
@property SessionProperties *sessionProperties;
@end

@implementation SessionPropertiesTests

- (void)setUp {
    _sessionDictionary = [@{@10: @[@"sessionpar1"]} copy];
    _sessionProperties =  [[SessionProperties alloc] initWitProperties: _sessionDictionary];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testInitWithProperties {
    XCTAssertTrue([_sessionProperties.properties isEqualToDictionary:_sessionDictionary], @"The dicitonary from session properties is not same as it is used for creation!");
}

- (void)testAsQueryItemsForRequest {
    //1. create expected query items
    NSMutableArray<NSURLQueryItem*>* expectedItems = [[NSMutableArray alloc] init];
    if (_sessionDictionary) {
        for(NSString* key in _sessionDictionary) {
            [expectedItems addObject:[[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cs%@",key] value: [_sessionDictionary[key] componentsJoinedByString:@";"]]];
        }
    }
    

    //2.Create tracking request
     TrackingEvent *event = [[TrackingEvent alloc] init];
     [event setPageName:@"testPageName"];
     NSString *everid = [[[DefaultTracker alloc] init] generateEverId];
     Properties *properies = [[Properties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
     TrackerRequest *request = [[TrackerRequest alloc] initWithEvent:event andWithProperties:properies];
     
     //3.get resulted list of query items
     NSMutableArray<NSURLQueryItem*>* result = [_sessionProperties asQueryItemsFor:request];
     
     XCTAssertTrue([expectedItems isEqualToArray:result], @"The expected query is not the same as ones from result!");
}

@end
