//
//  MIRequestUrlBuilderTests.m
//  MappIntelligenceTests
//
//  Created by Mihajlo Jezdic on 25.11.24.
//  Copyright © 2024 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MIProperties.h"
#import "MITrackingEvent.h"
#import "MIDefaultTracker.h"
#import "MIRequestUrlBuilder.h"
#import "MITrackerRequest.h"
#import "MICampaignParameters.h"
#import "MappIntelligence.h"
#import "MIActionEvent.h"
#import "MIFormSubmitEvent.h"
#import "MIFormParameters.h"
#import "MIMediaEvent.h"
#import "MIMediaParameters.h"

@interface MIRequestUrlBuilder (TestAccess)
- (NSString *)codeString:(NSString *)str;
- (BOOL)sendCampaignData:(MICampaignParameters *)campaignProperties;
- (NSMutableArray *)getAnonimousParams:(NSMutableArray *)params;
- (BOOL)containsEmailReceiverId:(NSArray<NSURLQueryItem *> *)parameters;
- (NSMutableArray<NSURLQueryItem *> *)removeDmcUserId:(NSMutableArray<NSURLQueryItem *> *)parameters
                                                   and:(NSArray<NSURLQueryItem *> *)newParameters;
- (NSURL *)createURLFromParametersWith:(NSArray<NSURLQueryItem *> *)parameters;
@end

@interface MIRequestUrlBuilderTests : XCTestCase

@property MIDefaultTracker *tracker;
@property MIRequestUrlBuilder *builder;

@end

@interface MappIntelligence (MIRequestUrlBuilderTestAccess)
- (void)setSendAppVersionInEveryRequest:(BOOL)sendAppVerisonToEveryRequest;
@end

@implementation MIRequestUrlBuilderTests

- (void)setUp {
    [super setUp];
    _tracker = [[MIDefaultTracker alloc] init];
    NSURL *url = [[NSURL alloc] initWithString:@"https://q3.webtrekk.net"];
    _builder = [[MIRequestUrlBuilder  alloc] initWithUrl:url andWithId:@"385255285199574"];
}

- (void)tearDown {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"dmcUserId"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emailReceiverIdUserDefaults"];
    [[MappIntelligence shared] setEnableUserMatching:NO];
    [super tearDown];
}

- (void)testInit {
    XCTAssertNotNil(_builder);
}

- (void)testUrlForRequest {
    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    [event setPageName:@"testPageName"];
    NSString *everid = [_tracker generateEverId];
    MIProperties *properies = [[MIProperties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properies];
    NSURL *url = [_builder urlForRequest:request withCustomData:NO];
    XCTAssertNotNil(url);
}

- (void)testUrlForAnonymousRequest {
    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    [event setPageName:@"testPageName"];
    NSString *everid = [_tracker generateEverId];
    [_tracker setAnonymousTracking:true];
    MIProperties *properies = [[MIProperties alloc] initWithEverID:everid andSamplingRate:0 withTimeZone:[NSTimeZone localTimeZone] withTimestamp:[NSDate date] withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properies];
    NSURL *url = [_builder urlForRequest:request withCustomData:NO];
    XCTAssertFalse([[url absoluteString] containsString:@"eid="]);
    XCTAssertTrue([[url absoluteString] containsString:@"nc=1"]);
}

- (void)testcreateURLFromParametersWith {
    //1. create parameters
    NSURLQueryItem* item1 = [[NSURLQueryItem alloc] initWithName:@"parameter1Name" value:@"parameter1Value"];
    NSURLQueryItem* item2 = [[NSURLQueryItem alloc] initWithName:@"parameter2Name" value:@"parameter2Value"];
    NSArray* array = [NSArray arrayWithObjects:item1, item2, nil];
    
    //2. test url
    NSURL* url = [_builder createURLFromParametersWith:array];
    XCTAssertNotNil(url);
    XCTAssertNotNil(url.scheme);
    XCTAssertNotNil(url.host);
}

- (void)testUrlForRequestWithoutPageNameReturnsNil {
    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    NSString *everid = [_tracker generateEverId];
    MIProperties *properties = [[MIProperties alloc] initWithEverID:everid
                                                   andSamplingRate:0
                                                      withTimeZone:[NSTimeZone localTimeZone]
                                                     withTimestamp:[NSDate date]
                                                     withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properties];

    NSURL *url = [_builder urlForRequest:request withCustomData:NO];
    XCTAssertNil(url);
}

- (void)testCodeStringEncodesReservedCharacters {
    NSString *encoded = [_builder codeString:@"name ?&+"];
    XCTAssertNotNil(encoded);
    XCTAssertTrue([encoded containsString:@"%20"]);
    XCTAssertFalse([encoded containsString:@" "]);
}

- (void)testSendCampaignDataOncePerSessionReturnsYes {
    MICampaignParameters *campaignOne = [[MICampaignParameters alloc] initWith:@"cmp-1"];
    campaignOne.oncePerSession = YES;
    MICampaignParameters *campaignTwo = [[MICampaignParameters alloc] initWith:@"cmp-2"];
    campaignTwo.oncePerSession = YES;

    BOOL first = [_builder sendCampaignData:campaignOne];
    BOOL second = [_builder sendCampaignData:campaignTwo];

    XCTAssertTrue(first);
    XCTAssertTrue(second);
}

- (void)testGetAnonimousParamsFiltersSuppressedAndAddsNc {
    MIDefaultTracker *tracker = [MIDefaultTracker sharedInstance];
    tracker.suppressedParameters = @[ @"p" ];

    NSMutableArray *params = [@[
        [NSURLQueryItem queryItemWithName:@"p" value:@"x"],
        [NSURLQueryItem queryItemWithName:@"eid" value:@"123"],
        [NSURLQueryItem queryItemWithName:@"foo" value:@"bar"]
    ] mutableCopy];

    NSArray *anonParams = [_builder getAnonimousParams:params];
    NSArray *names = [anonParams valueForKey:@"name"];

    XCTAssertFalse([names containsObject:@"p"]);
    XCTAssertFalse([names containsObject:@"eid"]);
    XCTAssertTrue([names containsObject:@"foo"]);
    XCTAssertTrue([names containsObject:@"nc"]);
}

- (void)testContainsEmailReceiverIdStoresValue {
    NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:@"uc701" value:@"receiver"];

    BOOL found = [_builder containsEmailReceiverId:@[ item ]];

    XCTAssertTrue(found);
    XCTAssertEqualObjects([[NSUserDefaults standardUserDefaults] objectForKey:@"emailReceiverIdUserDefaults"], @"receiver");
}

- (void)testRemoveDmcUserIdRemovesWhenEmailReceiverAndUserMatchingEnabled {
    [[NSUserDefaults standardUserDefaults] setObject:@"dmc" forKey:@"dmcUserId"];
    [[MappIntelligence shared] initWithConfiguration:@[@1234] onTrackdomain:@"https://test.com"]; 
    [[MappIntelligence shared] setAnonymousTracking:NO];
    [[MappIntelligence shared] setEnableUserMatching:YES];

    NSMutableArray *params = [@[
        [NSURLQueryItem queryItemWithName:@"uc701" value:@"dmc"],
        [NSURLQueryItem queryItemWithName:@"foo" value:@"bar"]
    ] mutableCopy];

    NSArray *newParams = @[
        [NSURLQueryItem queryItemWithName:@"uc701" value:@"receiver"]
    ];

    NSArray *result = [_builder removeDmcUserId:params and:newParams];
    NSArray *names = [result valueForKey:@"name"];

    XCTAssertFalse([names containsObject:@"uc701"]);
    XCTAssertTrue([names containsObject:@"foo"]);
}

- (void)testRemoveDmcUserIdReturnsCopyWhenNotMatched {
    [[MappIntelligence shared] setEnableUserMatching:NO];

    NSMutableArray *params = [@[
        [NSURLQueryItem queryItemWithName:@"uc701" value:@"dmc"],
        [NSURLQueryItem queryItemWithName:@"foo" value:@"bar"]
    ] mutableCopy];

    NSArray *result = [_builder removeDmcUserId:params and:@[]];

    XCTAssertEqual(result.count, 2);
}

- (void)testCreateURLFromParametersWithNilBaseUrlReturnsNil {
    MIRequestUrlBuilder *builder = [[MIRequestUrlBuilder alloc] init];
    NSURLQueryItem *item = [NSURLQueryItem queryItemWithName:@"a" value:@"b"];

    NSURL *url = [builder createURLFromParametersWith:@[ item ]];

    XCTAssertNil(url);
}

- (void)testSendCampaignDataWithOncePerSessionDisabledReturnsYes {
    MICampaignParameters *campaign = [[MICampaignParameters alloc] initWith:@"cmp"];
    campaign.oncePerSession = NO;

    BOOL result = [_builder sendCampaignData:campaign];

    XCTAssertTrue(result);
}

- (void)testAppVersionIncludedWhenSendEveryRequestEnabled {
    [[MappIntelligence shared] setSendAppVersionInEveryRequest:YES];

    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    [event setPageName:@"testPageName"];
    NSString *everid = [_tracker generateEverId];
    MIProperties *properties = [[MIProperties alloc] initWithEverID:everid
                                                   andSamplingRate:0
                                                      withTimeZone:[NSTimeZone localTimeZone]
                                                     withTimestamp:[NSDate date]
                                                     withUserAgent:@"Tracking Library"];
    properties.isFirstEventOfSession = NO;

    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properties];
    NSURL *url = [_builder urlForRequest:request withCustomData:NO];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSArray<NSURLQueryItem *> *items = components.queryItems;
    BOOL hasAppVersion = NO;
    for (NSURLQueryItem *item in items) {
        if ([item.name isEqualToString:@"cs804"]) {
            hasAppVersion = YES;
            break;
        }
    }

    XCTAssertTrue(hasAppVersion);
}

- (void)testAppVersionIncludedOnlyForFirstSessionWhenDisabled {
    [[MappIntelligence shared] setSendAppVersionInEveryRequest:NO];

    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    [event setPageName:@"testPageName"];
    NSString *everid = [_tracker generateEverId];
    MIProperties *properties = [[MIProperties alloc] initWithEverID:everid
                                                   andSamplingRate:0
                                                      withTimeZone:[NSTimeZone localTimeZone]
                                                     withTimestamp:[NSDate date]
                                                     withUserAgent:@"Tracking Library"];
    properties.isFirstEventOfSession = NO;

    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properties];
    NSURL *url = [_builder urlForRequest:request withCustomData:NO];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSArray<NSURLQueryItem *> *items = components.queryItems;
    BOOL hasAppVersion = NO;
    for (NSURLQueryItem *item in items) {
        if ([item.name isEqualToString:@"cs804"]) {
            hasAppVersion = YES;
            break;
        }
    }

    XCTAssertFalse(hasAppVersion);
}

- (void)testFirstSessionAddsBuildAndFirstOpenFlags {
    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    [event setPageName:@"testPageName"];
    NSString *everid = [_tracker generateEverId];
    MIProperties *properties = [[MIProperties alloc] initWithEverID:everid
                                                   andSamplingRate:0
                                                      withTimeZone:[NSTimeZone localTimeZone]
                                                     withTimestamp:[NSDate date]
                                                     withUserAgent:@"Tracking Library"];
    properties.isFirstEventOfSession = YES;
    properties.isFirstEventOfApp = YES;

    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properties];
    NSURL *url = [_builder urlForRequest:request withCustomData:NO];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    NSArray<NSURLQueryItem *> *items = components.queryItems;
    BOOL hasBuild = NO;
    BOOL hasFirstOpen = NO;
    for (NSURLQueryItem *item in items) {
        if ([item.name isEqualToString:@"cs805"]) {
            hasBuild = YES;
        }
        if ([item.name isEqualToString:@"cs821"] && [item.value isEqualToString:@"1"]) {
            hasFirstOpen = YES;
        }
    }

    XCTAssertTrue(hasBuild);
    XCTAssertTrue(hasFirstOpen);
}

- (void)testSendCampaignDataOncePerSessionReturnsNoOnSecondCall {
    MICampaignParameters *campaign = [[MICampaignParameters alloc] initWith:@"cmp"];
    campaign.oncePerSession = YES;

    BOOL first = [_builder sendCampaignData:campaign];
    BOOL second = [_builder sendCampaignData:campaign];

    XCTAssertTrue(first);
    XCTAssertFalse(second);
}

- (void)testUrlForRequestAddsEmailReceiverIdWhenStored {
    [[NSUserDefaults standardUserDefaults] setObject:@"receiver" forKey:@"emailReceiverIdUserDefaults"];

    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    event.pageName = @"page";
    MIProperties *properties = [[MIProperties alloc] initWithEverID:[_tracker generateEverId]
                                                   andSamplingRate:0
                                                      withTimeZone:[NSTimeZone localTimeZone]
                                                     withTimestamp:[NSDate date]
                                                     withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properties];

    NSURL *url = [_builder urlForRequest:request withCustomData:NO];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    BOOL hasReceiver = NO;
    for (NSURLQueryItem *item in components.queryItems) {
        if ([item.name isEqualToString:@"uc701"] && [item.value isEqualToString:@"receiver"]) {
            hasReceiver = YES;
            break;
        }
    }

    XCTAssertTrue(hasReceiver);
}

- (void)testUrlForRequestAddsDmcUserIdWhenUserMatchingEnabled {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"emailReceiverIdUserDefaults"];
    [[NSUserDefaults standardUserDefaults] setObject:@"dmc-id" forKey:@"dmcUserId"];
    [[MappIntelligence shared] initWithConfiguration:@[@1234] onTrackdomain:@"https://test.com"];
    [[MappIntelligence shared] setEnableUserMatching:YES];
    [[MappIntelligence shared] setAnonymousTracking:NO];

    MITrackingEvent *event = [[MITrackingEvent alloc] init];
    event.pageName = @"page";
    MIProperties *properties = [[MIProperties alloc] initWithEverID:[_tracker generateEverId]
                                                   andSamplingRate:0
                                                      withTimeZone:[NSTimeZone localTimeZone]
                                                     withTimestamp:[NSDate date]
                                                     withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properties];

    NSURL *url = [_builder urlForRequest:request withCustomData:NO];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    BOOL hasDmc = NO;
    for (NSURLQueryItem *item in components.queryItems) {
        if ([item.name isEqualToString:@"uc701"] && [item.value isEqualToString:@"dmc-id"]) {
            hasDmc = YES;
            break;
        }
    }

    XCTAssertTrue(hasDmc);
}

- (void)testUrlForFormSubmitEventWithNilPageNameBuildsUrl {
    MIFormSubmitEvent *formEvent = [[MIFormSubmitEvent alloc] init];
    formEvent.pageName = nil;
    formEvent.formParameters = [[MIFormParameters alloc] init];

    MIProperties *properties = [[MIProperties alloc] initWithEverID:[_tracker generateEverId]
                                                   andSamplingRate:0
                                                      withTimeZone:[NSTimeZone localTimeZone]
                                                     withTimestamp:[NSDate date]
                                                     withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:formEvent andWithProperties:properties];

    NSURL *url = [_builder urlForRequest:request withCustomData:NO];

    XCTAssertNotNil(url);
}

- (void)testCustomActionEventAddsTrackingParams {
    MIActionEvent *event = [[MIActionEvent alloc] initWithName:@"action"];
    event.trackingParams = @{ @"cp99": @"custom" };
    MIProperties *properties = [[MIProperties alloc] initWithEverID:[_tracker generateEverId]
                                                   andSamplingRate:0
                                                      withTimeZone:[NSTimeZone localTimeZone]
                                                     withTimestamp:[NSDate date]
                                                     withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:event andWithProperties:properties];

    NSURL *url = [_builder urlForRequest:request withCustomData:YES];
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    BOOL hasCustom = NO;
    for (NSURLQueryItem *item in components.queryItems) {
        if ([item.name isEqualToString:@"cp99"] && [item.value isEqualToString:@"custom"]) {
            hasCustom = YES;
            break;
        }
    }

    XCTAssertTrue(hasCustom);
}

- (void)testCreateURLFromParametersAppendsToExistingQuery {
    NSURL *base = [NSURL URLWithString:@"https://example.com/123/wt?existing=1"]; 
    [_builder setValue:base forKey:@"baseUrl"];

    NSURL *url = [_builder createURLFromParametersWith:@[[NSURLQueryItem queryItemWithName:@"a" value:@"b"]]];
    NSString *absolute = url.absoluteString;

    XCTAssertTrue([absolute containsString:@"existing=1"]);
    XCTAssertTrue([absolute containsString:@"a=b"]);
}

- (void)testCreateURLFromParametersSkipsInvalidItems {
    [_builder setValue:[NSURL URLWithString:@"https://example.com/123/wt"] forKey:@"baseUrl"];
    NSArray *items = @[ @"bad", [NSNull null], [NSURLQueryItem queryItemWithName:@"ok" value:@"1"] ];

    NSURL *url = [_builder createURLFromParametersWith:items];

    XCTAssertTrue([url.absoluteString containsString:@"ok=1"]);
}

- (void)testCodeStringHandlesNonStringInput {
    NSString *encoded = [_builder codeString:@123];
    XCTAssertTrue([encoded isKindOfClass:[NSString class]]);
}

- (void)testUrlForMediaEventBuildsUrl {
    MIMediaParameters *mediaParams = [[MIMediaParameters alloc] initWith:@"media" action:@"play" position:@1 duration:@10];
    MIMediaEvent *mediaEvent = [[MIMediaEvent alloc] initWithPageName:@"media" parameters:mediaParams];
    MIProperties *properties = [[MIProperties alloc] initWithEverID:[_tracker generateEverId]
                                                   andSamplingRate:0
                                                      withTimeZone:[NSTimeZone localTimeZone]
                                                     withTimestamp:[NSDate date]
                                                     withUserAgent:@"Tracking Library"];
    MITrackerRequest *request = [[MITrackerRequest shared] initWithEvent:mediaEvent andWithProperties:properties];

    NSURL *url = [_builder urlForRequest:request withCustomData:NO];

    XCTAssertNotNil(url);
}

@end
