//
//  CampaignParameters.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 9.3.22..
//  Copyright © 2022 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MICampaignParameters.h"

@interface CampaignParameterTests : XCTestCase

@property NSString *campaignId;
@property MICampaignAction action;
@property NSString *mediaCode;
@property BOOL oncePerSession;
@property NSDictionary<NSNumber* ,NSString*>* customParameters;
@property MICampaignParameters* parameters;

@end

@implementation CampaignParameterTests

- (void)setUp {
    _campaignId = @"email.newsletter.nov2020.thursday";
    _mediaCode = @"abc";
    _oncePerSession = true;
    _action = click;
    _customParameters = @{@12: @"camParam1"};
    NSDictionary* dict = @{@"campaignId": _campaignId, @"action": _action, @"mediaCode" : _mediaCode, @"oncePerSession" : [NSNumber numberWithBool:_oncePerSession], @"customParameters" : _customParameters};
    _parameters = [[MICampaignParameters alloc] initWithDictionary:dict];
}

- (void)tearDown {
    _campaignId = NULL;
    _mediaCode = NULL;
    _oncePerSession = NULL;
    _customParameters = NULL;
    _parameters = NULL;
}

- (void)testInitWithCampaignID {
    MICampaignParameters* campaignParameters = [[MICampaignParameters alloc] initWith:_campaignId];
    XCTAssertTrue([campaignParameters.campaignId isEqualToString:_campaignId], @"Campaign ID is not correct!");
    
    campaignParameters.mediaCode = _mediaCode;
    campaignParameters.action = _action;
    campaignParameters.oncePerSession = _oncePerSession;
    campaignParameters.customParameters = _customParameters;
    
    XCTAssertTrue([campaignParameters.mediaCode isEqualToString:_mediaCode], @"Media code is not correct!");
    XCTAssertTrue(campaignParameters.action == _action, @"Action is not correct!");
    XCTAssertTrue([campaignParameters.customParameters isEqualToDictionary:_customParameters], @"Custom parameters is not correct!");
    XCTAssertTrue(campaignParameters.oncePerSession == _oncePerSession, @"Once per session  ID is not correct!");
}

- (void)testInitWithDictionary {
    XCTAssertTrue([_parameters.campaignId isEqualToString:_campaignId], @"Campaign ID is not correct!");
    XCTAssertTrue([_parameters.mediaCode isEqualToString:_mediaCode], @"Media code is not correct!");
    XCTAssertTrue(_parameters.action == _action, @"Action is not correct!");
    XCTAssertTrue([_parameters.customParameters isEqualToDictionary:_customParameters], @"Custom parameters is not correct!");
    XCTAssertTrue(_parameters.oncePerSession == _oncePerSession, @"Once per session  ID is not correct!");
}

- (void)testasQueryItems {
    NSMutableArray<NSURLQueryItem*>* campaignPropertiesQueryItems = [_parameters asQueryItems];
    
    NSString *mediaCode = _parameters.mediaCode ? _parameters.mediaCode : @"wt_mc";
    if (_parameters.campaignId) {
        NSString* mediaCodeValue = [NSString stringWithFormat:@"%@%@%@",mediaCode, @"%3D",_parameters.campaignId];
        XCTAssertTrue([campaignPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mc" value: mediaCodeValue ]], @"There is no media code!");
    } else {
        XCTAssertTrue([campaignPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mc" value:mediaCode]], @"There is no media code!");
    }
    
    if (_parameters.action) {
        NSString *actionString = [NSString stringWithFormat:@"%@", _parameters.action == click ? @"c": @"v"];
        XCTAssertTrue([campaignPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mca" value: actionString]], @"There is no action value for campaign!");
    } else {
        XCTAssertTrue([campaignPropertiesQueryItems containsObject:[[NSURLQueryItem alloc] initWithName:@"mca" value:@"c"]], @"There is no action value for campaign!");

    }
    if (_parameters.customParameters) {
        for(NSNumber* key in _parameters.customParameters) {
            NSURLQueryItem* tempItem = [[NSURLQueryItem alloc] initWithName:[NSString stringWithFormat:@"cc%@",key] value: _parameters.customParameters[key]];
            XCTAssertTrue([campaignPropertiesQueryItems containsObject:tempItem], @"There is no custom paramter in campaign object!");
        }
    }
}

@end
