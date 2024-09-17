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
    NSDictionary* dict = @{@"campaignId": _campaignId, @"action": @((int)_action), @"mediaCode" : _mediaCode, @"oncePerSession" : [NSNumber numberWithBool:_oncePerSession], @"customParameters" : _customParameters};
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


// Test the basic initialization with campaignId
- (void)testInitWithCampaignId {
    NSString *campaignId = @"testCampaign";
    MICampaignParameters *params = [[MICampaignParameters alloc] initWith:campaignId];
    
    XCTAssertNotNil(params);
    XCTAssertEqualObjects(params.campaignId, campaignId);
    XCTAssertNil(params.mediaCode);
    XCTAssertNil(params.customParameters);
    XCTAssertFalse(params.oncePerSession);
}

// Test initialization with dictionary
- (void)testInitWithDictionary {
    NSDictionary *dict = @{
        @"campaignId": @"testCampaign",
        @"action": @1,
        @"mediaCode": @"testMediaCode",
        @"oncePerSession": @YES,
        @"customParameters": @{@1: @"value1", @2: @"value2"}
    };
    
    MICampaignParameters *params = [[MICampaignParameters alloc] initWithDictionary:dict];
    
    XCTAssertEqualObjects(params.campaignId, @"testCampaign");
    XCTAssertEqual(params.action, click);
    XCTAssertEqualObjects(params.mediaCode, @"testMediaCode");
    XCTAssertEqualObjects(params.customParameters[@1], @"value1");
    XCTAssertTrue(params.oncePerSession);
}

// Test the asQueryItems method
- (void)testAsQueryItems {
    MICampaignParameters *params = [[MICampaignParameters alloc] initWith:@"123"];
    params.mediaCode = @"testCode";
    params.action = click;
    params.customParameters = @{@1: @"value1", @2: @"value2"};
    
    NSMutableArray<NSURLQueryItem *> *queryItems = [params asQueryItems];
    
    XCTAssertEqual(queryItems.count, 4);
    XCTAssertEqualObjects(queryItems[0].name, @"mc");
    XCTAssertEqualObjects(queryItems[0].value, @"testCode%3D123");
    XCTAssertEqualObjects(queryItems[1].name, @"mca");
    XCTAssertEqualObjects(queryItems[1].value, @"c");
    XCTAssertEqualObjects(queryItems[2].name, @"cc1");
    XCTAssertEqualObjects(queryItems[2].value, @"value1");
    XCTAssertEqualObjects(queryItems[3].name, @"cc2");
    XCTAssertEqualObjects(queryItems[3].value, @"value2");
}

// Test encoding and decoding functionality
- (void)testEncodingDecoding {
    NSDictionary *dict = @{
        @"campaignId": @"testCampaign",
        @"action": @2,
        @"mediaCode": @"mediaCodeTest",
        @"oncePerSession": @NO,
        @"customParameters": @{@3: @"value3"}
    };
    
    MICampaignParameters *params = [[MICampaignParameters alloc] initWithDictionary:dict];
    
    NSData *encodedData = [NSKeyedArchiver archivedDataWithRootObject:params requiringSecureCoding:YES error:nil];
    XCTAssertNotNil(encodedData);
    
    MICampaignParameters *decodedParams = [NSKeyedUnarchiver unarchivedObjectOfClass:[MICampaignParameters class] fromData:encodedData error:nil];
    
    XCTAssertEqualObjects(params, decodedParams);
    XCTAssertEqualObjects(decodedParams.customParameters[@3], @"value3");
    XCTAssertEqual(decodedParams.action, view);
}

// Test equality of two MICampaignParameters objects
- (void)testEquality {
    MICampaignParameters *params1 = [[MICampaignParameters alloc] initWith:@"campaign1"];
    params1.mediaCode = @"code1";
    params1.customParameters = @{@1: @"value1"};
    
    MICampaignParameters *params2 = [[MICampaignParameters alloc] initWith:@"campaign1"];
    params2.mediaCode = @"code1";
    params2.customParameters = @{@1: @"value1"};
    
    XCTAssertTrue([params1 isEqual:params2]);
}

@end
