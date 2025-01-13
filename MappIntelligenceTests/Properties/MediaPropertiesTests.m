//
//  MediaPropertiesTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4.3.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIMediaParameters.h"

@interface MediaPropertiesTests : XCTestCase
@property MIMediaParameters* mediaProperties;
@property MIMediaParameters* mediaPropertiesFromDict;
@property NSMutableDictionary* categories;
@property NSString* videoName;
@property NSString* videoAction;
@property NSNumber* position;
@property NSNumber* duration;
@end

@implementation MediaPropertiesTests

- (void)setUp {
    _videoName = @"Test video";
    _videoAction = @"view";
    _position = @12;
    _duration = @120;
    _mediaProperties = [[MIMediaParameters alloc] initWith:_videoName action:_videoAction position:_position duration:_duration];
    _categories = [@{@20: @[@"mediaCat"]} copy];
    _mediaProperties.customCategories = _categories;
    NSNumber* bandwidth = @56578;
    NSNumber* soundIsMuted = [NSNumber numberWithBool:YES];
    NSNumber* soundVolume = @34;
    NSDictionary* dict = @{
        @"name" : _videoName,
        @"action" : _videoAction,
        @"duration" : _duration,
        @"position" : _position,
        @"bandwith" : bandwidth,
        @"soundIsMuted": soundIsMuted,
        @"soundVolume": soundVolume,
        @"customCategories": _categories
    };
    _mediaPropertiesFromDict = [[MIMediaParameters alloc] initWithDictionary:dict];
}

- (void)tearDown {
    _mediaProperties = nil;
    _categories = nil;
    _videoName = nil;
    _videoAction = nil;
    _position = nil;
    _duration = nil;
    _mediaPropertiesFromDict = nil;
}

- (void)testInitWithParameters {
    // Initialize with parameters
    NSString *name = @"testName";
    NSString *action = @"testAction";
    NSNumber *position = @10;
    NSNumber *duration = @20;
    
    MIMediaParameters *parameters = [[MIMediaParameters alloc] initWith:name action:action position:position duration:duration];
    
    XCTAssertEqualObjects(parameters.name, name, @"Name should be set correctly");
    XCTAssertEqualObjects(parameters.action, action, @"Action should be set correctly");
    XCTAssertEqualObjects(parameters.position, position, @"Position should be set correctly");
    XCTAssertEqualObjects(parameters.duration, duration, @"Duration should be set correctly");
}

- (void)testInitWithDictionary {
    // Initialize with dictionary
    NSDictionary *dictionary = @{
        @"name": @"testName",
        @"action": @"testAction",
        @"bandwith": @100,
        @"position": @10,
        @"duration": @20,
        @"soundIsMuted": @YES,
        @"soundVolume": @0.5,
        @"customCategories": @{ @1: @"cat1", @2: @"cat2" }
    };
    
    MIMediaParameters *parameters = [[MIMediaParameters alloc] initWithDictionary:dictionary];
    
    XCTAssertEqualObjects(parameters.name, @"testName", @"Name should be set correctly");
    XCTAssertEqualObjects(parameters.action, @"testAction", @"Action should be set correctly");
    XCTAssertEqualObjects(parameters.bandwith, @100, @"Bandwith should be set correctly");
    XCTAssertEqualObjects(parameters.position, @10, @"Position should be set correctly");
    XCTAssertEqualObjects(parameters.duration, @20, @"Duration should be set correctly");
    XCTAssertEqualObjects(parameters.soundIsMuted, @YES, @"SoundIsMuted should be set correctly");
    XCTAssertEqualObjects(parameters.soundVolume, @0.5, @"SoundVolume should be set correctly");
    XCTAssertEqualObjects(parameters.customCategories, (@{ @1: @"cat1", @2: @"cat2" }), @"CustomCategories should be set correctly");
}

#pragma mark - URL Query Items Tests

- (void)testAsQueryItems {
    // Initialize with parameters
    MIMediaParameters *parameters = [[MIMediaParameters alloc] initWith:_videoName action:_videoAction position:_position duration:_duration];
    [parameters setSoundVolume:@0.5];
    [parameters setBandwith:@100];
    [parameters setSoundIsMuted:@1];
    
    // Generate URL query items
    NSMutableArray<NSURLQueryItem *> *queryItems = [parameters asQueryItems];
    
    // Test if query items are generated correctly
    NSMutableDictionary *queryItemsDict = [NSMutableDictionary dictionary];
    for (NSURLQueryItem *item in queryItems) {
        queryItemsDict[item.name] = item.value;
    }
    
    XCTAssertEqualObjects(queryItemsDict[@"mi"], _videoName, @"Name query item should be set correctly");
    XCTAssertEqualObjects(queryItemsDict[@"mk"], _videoAction, @"Action query item should be set correctly");
    XCTAssertEqualObjects(queryItemsDict[@"mt1"], [_position stringValue], @"Position query item should be set correctly");
    XCTAssertEqualObjects(queryItemsDict[@"mt2"], [_duration stringValue], @"Duration query item should be set correctly");
    XCTAssertEqualObjects(queryItemsDict[@"mut"], @"1", @"SoundIsMuted query item should be set correctly");
    XCTAssertEqualObjects(queryItemsDict[@"vol"], @"0.5", @"SoundVolume query item should be set correctly");
    XCTAssertEqualObjects(queryItemsDict[@"bw"], @"100", @"Bandwith query item should be set correctly");
}

- (void)testasQueryItems {
    NSMutableArray<NSURLQueryItem*>* mediaPropertiesQueryItems = [_mediaPropertiesFromDict asQueryItems];
    XCTAssertTrue([mediaPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mi" value:_mediaPropertiesFromDict.name]], @"Query item with media name does not exist!");
    XCTAssertTrue([mediaPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mk" value:_mediaPropertiesFromDict.action]], @"Query item with media action does not exist!");
    NSString* positionString = [NSString stringWithFormat:@"%ld", (long)[_mediaPropertiesFromDict.position doubleValue]];
    XCTAssertTrue([mediaPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mt1" value: positionString] ], @"Query item with media position does not exist!");
    NSString* durationString = [NSString stringWithFormat:@"%ld", (long)[_mediaPropertiesFromDict.duration doubleValue]];
    XCTAssertTrue([mediaPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mt2" value: durationString] ], @"Query item with media duration does not exist!");
    XCTAssertTrue([mediaPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mut" value: [_mediaPropertiesFromDict.soundIsMuted stringValue]] ], @"Query item with media sound is muted does not exist!");
    XCTAssertTrue([mediaPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"vol" value: [_mediaPropertiesFromDict.soundVolume stringValue]] ], @"Query item with media sound volume does not exist!");
    XCTAssertTrue([mediaPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"bw" value: [_mediaPropertiesFromDict.bandwith stringValue]] ], @"Query item with media bandwidth does not exist!");
    
    for(NSNumber* key in _categories) {
        NSURLQueryItem* tempItem = [[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"mg%@",key] value: _categories[key]];
        XCTAssertTrue([mediaPropertiesQueryItems containsObject: tempItem], @"Query item with media category does not exist!");
    }
}

@end
