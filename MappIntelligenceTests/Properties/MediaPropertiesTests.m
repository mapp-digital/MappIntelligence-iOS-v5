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

- (void)testInit {
    XCTAssertTrue([_mediaProperties.name isEqualToString:_videoName], @"Video name is not correct!");
    XCTAssertTrue([_mediaProperties.action isEqualToString:_videoAction], @"Video action is not correct!");
    XCTAssertTrue([_mediaProperties.position isEqual:_position], @"Video position is not correct!");
    XCTAssertTrue([_mediaProperties.duration isEqual:_duration], @"Video duration is not correct!");
    XCTAssertTrue([_mediaProperties.customCategories isEqual:_categories], @"Video duration is not correct!");
}

- (void)testinitWithDictionary {
    NSNumber* bandwidth = @56578;
    NSNumber* soundIsMuted = [NSNumber numberWithBool:YES];
    NSNumber* soundVolume = @34;
    XCTAssertTrue([_mediaPropertiesFromDict.name isEqualToString:_videoName], @"Video name is not correct!");
    XCTAssertTrue([_mediaPropertiesFromDict.action isEqualToString:_videoAction], @"Video action is not correct!");
    XCTAssertTrue([_mediaPropertiesFromDict.position isEqual:_position], @"Video position is not correct!");
    XCTAssertTrue([_mediaPropertiesFromDict.duration isEqual:_duration], @"Video duration is not correct!");
    XCTAssertTrue([_mediaPropertiesFromDict.customCategories isEqual:_categories], @"Video duration is not correct!");
    XCTAssertTrue([_mediaPropertiesFromDict.bandwith isEqualToNumber:bandwidth], @"Video bandwidht is not correct!");
    XCTAssertTrue([_mediaPropertiesFromDict.soundIsMuted isEqualToNumber:soundIsMuted], @"Video sound_is_muted is not correct!");
    XCTAssertTrue([_mediaPropertiesFromDict.soundVolume isEqualToNumber:soundVolume], @"Video sound volume is not correct!");
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
