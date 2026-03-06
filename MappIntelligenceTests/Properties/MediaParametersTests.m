//
//  MediaParametersTests.m
//  MappIntelligenceTests
//
//  Created by Miroljub Stoilkovic on 13/01/2021.
//  Copyright © 2021 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIMediaParameters.h"

@interface MediaParametersTests : XCTestCase
@property MIMediaParameters *parameters;
@property NSDictionary *dictionary;
@end

@implementation MediaParametersTests

- (void)setUp {
    [super setUp];
    _parameters = [[MIMediaParameters alloc] initWith:@"TestVideo" action:@"init" position:@23 duration:@100];
    _parameters.customCategories = @{@1: @"mediaCustom1"};
    _parameters.soundIsMuted = @1;
    _parameters.soundVolume = @50;
    _parameters.bandwith = @1200;

    _dictionary = @{
        @"name": @"VideoFromDict",
        @"action": @"play",
        @"position": @12,
        @"duration": @98,
        @"soundIsMuted": @0,
        @"soundVolume": @80,
        @"bandwith": @512,
        @"customCategories": @{@3: @"dictCustom"}
    };
}

- (void)tearDown {
    _parameters = nil;
    _dictionary = nil;
    [super tearDown];
}

- (void)testInitWithValues {
    XCTAssertEqualObjects(_parameters.name, @"TestVideo");
    XCTAssertEqualObjects(_parameters.action, @"init");
    XCTAssertEqualObjects(_parameters.position, @23);
    XCTAssertEqualObjects(_parameters.duration, @100);
}

- (void)testInitWithDictionary {
    MIMediaParameters *params = [[MIMediaParameters alloc] initWithDictionary:_dictionary];

    XCTAssertEqualObjects(params.name, @"VideoFromDict");
    XCTAssertEqualObjects(params.action, @"play");
    XCTAssertEqualObjects(params.position, @12);
    XCTAssertEqualObjects(params.duration, @98);
    XCTAssertEqualObjects(params.soundIsMuted, @0);
    XCTAssertEqualObjects(params.soundVolume, @80);
    XCTAssertEqualObjects(params.bandwith, @512);
    XCTAssertEqualObjects(params.customCategories[@3], @"dictCustom");
}

- (void)testAsQueryItems {
    NSMutableArray<NSURLQueryItem *> *queryItems = [_parameters asQueryItems];

    XCTAssertTrue([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mi" value:@"TestVideo"]]);
    XCTAssertTrue([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mk" value:@"init"]]);
    XCTAssertTrue([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mt1" value:@"23"]]);
    XCTAssertTrue([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mt2" value:@"100"]]);
    XCTAssertTrue([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mut" value:@"1"]]);
    XCTAssertTrue([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"vol" value:@"50"]]);
    XCTAssertTrue([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"bw" value:@"1200"]]);
    XCTAssertTrue([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mg1" value:@"mediaCustom1"]]);
}

- (void)testAsQueryItemsWithNullCustomCategories {
    MIMediaParameters *params = [[MIMediaParameters alloc] initWithDictionary:@{
        @"name": @"VideoNullCustom",
        @"action": @"play",
        @"position": @1,
        @"duration": @2,
        @"customCategories": [NSNull null]
    }];

    NSMutableArray<NSURLQueryItem *> *queryItems = nil;
    XCTAssertNoThrow(queryItems = [params asQueryItems]);
    XCTAssertNotNil(queryItems);
    XCTAssertTrue([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mi" value:@"VideoNullCustom"]]);
    XCTAssertFalse([queryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mg1" value:@"any"]]);
}

@end
