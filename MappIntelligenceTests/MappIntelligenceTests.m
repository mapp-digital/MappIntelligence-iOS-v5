//
//  MappIntelligenceTests.m
//  MappIntelligenceTests
//
//  Created by Stefan Stevanovic on 4/9/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MappIntelligence.h"
#import "MIDefaultTracker.h"
#import "MIMediaTracker.h"
#import "MIMediaEvent.h"
#import "MIMediaParameters.h"
#import "MIPageViewEvent.h"
#import "MIDeepLink.h"
#import "MIDatabaseManager.h"
#import "MIFormSubmitEvent.h"
#import "MIFormParameters.h"
#import "Reachability.h"

@interface MIDatabaseManager (TestHook)
+ (void)setShared:(MIDatabaseManager *)manager;
@end

@interface MIMediaTrackerTestDouble : NSObject
- (BOOL)shouldTrack:(MIMediaEvent *)event;
@end

@implementation MIMediaTrackerTestDouble

- (BOOL)shouldTrack:(MIMediaEvent *)event {
    (void)event;
    return NO;
}

@end

static IMP MIMediaTrackerSharedInstanceIMP = NULL;
static id MIMediaTrackerSharedInstanceOverride = nil;

@interface MappIntelligence (TestAccess)
- (void)setEnableUserMatching:(BOOL)enableUserMatching;
- (BOOL)enableUserMatching;
- (void)setEnableBackgroundSendout:(BOOL)enableBackgroundSendout;
- (BOOL)enableBackgroundSendout;
- (void)setBatchSupportEnabled:(BOOL)batchSupportEnabled;
- (BOOL)batchSupportEnabled;
- (void)setSendAppVersionInEveryRequest:(BOOL)sendAppVerisonToEveryRequest;
- (BOOL)sendAppVersionInEveryRequest;
@end

@interface MappIntelligenceTests : XCTestCase

@property MappIntelligence *instance;
@property NSString *testTrackDomain;
@property (nonatomic, strong) id trackerMock;
@property (nonatomic, strong) id mediaTrackerClassMock;
@property (nonatomic, strong) id mediaTrackerMock;

@end

@implementation MappIntelligenceTests

- (void)setUp {
    [super setUp];
    _instance = [MappIntelligence shared];
    _testTrackDomain = @"https://test.com";
    self.trackerMock = nil;
    self.mediaTrackerClassMock = nil;
    self.mediaTrackerMock = nil;
}

- (void)tearDown {
    self.trackerMock = nil;
    if (self.mediaTrackerClassMock) {
        [self.mediaTrackerClassMock stopMocking];
        self.mediaTrackerClassMock = nil;
    }
    self.mediaTrackerMock = nil;
    [_instance setValue:[MIDefaultTracker sharedInstance] forKey:@"tracker"];
    [self restoreMediaTrackerSharedInstanceSwizzle];
    [super tearDown];
}

- (void)testExample {
    XCTAssertNotNil(_instance);
}

- (void)testInit {
    [_instance initWithConfiguration:@[@12345464] onTrackdomain:_testTrackDomain];
    XCTAssertTrue([[MappIntelligence getId] isEqualToString:@"12345464"]);
    XCTAssertTrue([[MappIntelligence getUrl] isEqualToString:_testTrackDomain], "track tomain is same");
    [_instance initWithConfiguration:@[@12345464, @6677777777] onTrackdomain:_testTrackDomain];
    XCTAssertTrue([[MappIntelligence getId] isEqualToString:@"12345464,6677777777"]);
}

- (void)testReset {
    NSString *previousEverID = [[MIDefaultTracker sharedInstance] generateEverId];
    [_instance reset];
    NSString *newEverID = [[MIDefaultTracker sharedInstance] generateEverId];
    XCTAssertFalse([previousEverID isEqualToString:newEverID], "after reset, ever ids are different!");
    [_instance initWithConfiguration:@[@12345464, @6677777777] onTrackdomain:_testTrackDomain];
}

- (void)testInitWithInvalidTrackIdsDoesNotUpdateConfig {
    [_instance initWithConfiguration:@[@1111] onTrackdomain:_testTrackDomain];
    NSString *previousId = [MappIntelligence getId];
    NSString *previousUrl = [MappIntelligence getUrl];

    [_instance initWithConfiguration:@[@"bad"] onTrackdomain:@"https://invalid.com"];

    XCTAssertEqualObjects([MappIntelligence getId], previousId);
    XCTAssertEqualObjects([MappIntelligence getUrl], previousUrl);
}

- (void)testSetIdsAndDomainUpdatesConfig {
    NSArray *trackIds = @[ @42, @84 ];
    NSString *domain = @"https://example.org";

    [_instance setIdsAndDomain:trackIds onTrackdomain:domain];

    XCTAssertEqualObjects([MappIntelligence getId], @"42,84");
    XCTAssertEqualObjects([MappIntelligence getUrl], domain);
}

- (void)testSetTemporarySessionIdRespectsAnonymousTracking {
    id trackerMock = OCMClassMock([MIDefaultTracker class]);
    OCMStub([trackerMock anonymousTracking]).andReturn(NO);
    [_instance setValue:trackerMock forKey:@"tracker"];

    OCMExpect([trackerMock setTemporaryID:NULL]);
    [_instance setTemporarySessionId:@"temp-id"];
    OCMVerifyAll(trackerMock);

}

- (void)testEnableBackgroundSendoutTogglesConfig {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];

    [_instance setEnableBackgroundSendout:YES];
    XCTAssertTrue([_instance enableBackgroundSendout]);

    [_instance setEnableBackgroundSendout:NO];
    XCTAssertFalse([_instance enableBackgroundSendout]);
}

- (void)testEnableUserMatchingDoesNotEnableWhenAnonymousTracking {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];

    MIDefaultTracker *tracker = [MIDefaultTracker sharedInstance];
    [tracker setAnonymousTracking:YES];

    [_instance setEnableUserMatching:YES];

    XCTAssertFalse([_instance enableUserMatching]);

    [tracker setAnonymousTracking:NO];
    [_instance setEnableUserMatching:NO];
}

- (void)testBatchSupportEnabledTogglesConfig {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];

    [_instance setBatchSupportEnabled:YES];
    XCTAssertTrue([_instance batchSupportEnabled]);

    [_instance setBatchSupportEnabled:NO];
    XCTAssertFalse([_instance batchSupportEnabled]);
}

- (void)testSendAppVersionInEveryRequestTogglesConfig {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];

    [_instance setSendAppVersionInEveryRequest:YES];
    XCTAssertTrue([_instance sendAppVersionInEveryRequest]);

    [_instance setSendAppVersionInEveryRequest:NO];
    XCTAssertFalse([_instance sendAppVersionInEveryRequest]);
}

- (void)testSetTemporarySessionIdSetsIdWhenAnonymousTrackingEnabled {
    id trackerMock = OCMClassMock([MIDefaultTracker class]);
    OCMStub([trackerMock anonymousTracking]).andReturn(YES);
    [_instance setValue:trackerMock forKey:@"tracker"];

    OCMExpect([trackerMock setTemporaryID:@"temp-id"]);
    [_instance setTemporarySessionId:@"temp-id"];
    OCMVerifyAll(trackerMock);

}

- (void)testSetTemporarySessionIdClearsIdWhenEmpty {
    id trackerMock = OCMClassMock([MIDefaultTracker class]);
    OCMStub([trackerMock anonymousTracking]).andReturn(YES);
    [_instance setValue:trackerMock forKey:@"tracker"];

    OCMExpect([trackerMock setTemporaryID:NULL]);
    [_instance setTemporarySessionId:@""];
    OCMVerifyAll(trackerMock);

}

- (void)testOptOutAndSendCurrentDataSendsBatch {
    self.trackerMock = OCMClassMock([MIDefaultTracker class]);
    [_instance setValue:self.trackerMock forKey:@"tracker"];

    OCMExpect([self.trackerMock sendBatchForRequestInBackground:NO withCompletionHandler:[OCMArg any]]);

    [_instance optOutAndSendCurrentData:YES];

    OCMVerifyAll(self.trackerMock);
}

- (void)testOptOutAndSendCurrentDataRemovesRequestsWhenFalse {
    self.trackerMock = OCMClassMock([MIDefaultTracker class]);
    [_instance setValue:self.trackerMock forKey:@"tracker"];

    OCMExpect([self.trackerMock removeAllRequestsFromDBWithCompletionHandler:[OCMArg any]]);

    [_instance optOutAndSendCurrentData:NO];

    OCMVerifyAll(self.trackerMock);
}

- (void)testTrackActionCallsTrackerWhenEnabled {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];
    [_instance optIn];

    self.trackerMock = OCMClassMock([MIDefaultTracker class]);
    [_instance setValue:self.trackerMock forKey:@"tracker"];

    OCMExpect([self.trackerMock trackWithEvent:[OCMArg any]]).andReturn(nil);

    NSError *error = [_instance trackAction:[[MIActionEvent alloc] initWithName:@"action"]];

    XCTAssertNil(error);
    OCMVerifyAll(self.trackerMock);
}

- (void)testTrackActionReturnsNilWhenOptedOut {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];
    [_instance optOutAndSendCurrentData:NO];

    NSError *error = [_instance trackAction:[[MIActionEvent alloc] initWithName:@"action"]];

    XCTAssertNil(error);
}

- (void)testTrackCustomEventCallsTrackerWhenEnabled {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];
    [_instance optIn];

    self.trackerMock = OCMClassMock([MIDefaultTracker class]);
    [_instance setValue:self.trackerMock forKey:@"tracker"];

    OCMExpect([self.trackerMock trackWithCustomEvent:[OCMArg any]]).andReturn(nil);

    NSError *error = [_instance trackCustomEvent:@"evt" trackingParams:@{ @"cp1": @"v" }];

    XCTAssertNil(error);
    OCMVerifyAll(self.trackerMock);
}

- (void)testTrackCustomEventReturnsNilWhenOptedOut {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];
    [_instance optOutAndSendCurrentData:NO];

    NSError *error = [_instance trackCustomEvent:@"evt" trackingParams:nil];

    XCTAssertNil(error);
}

- (void)testTrackPageWithViewControllerCreatesEventWhenEnabled {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];
    [_instance optIn];

    self.trackerMock = OCMClassMock([MIDefaultTracker class]);
    [_instance setValue:self.trackerMock forKey:@"tracker"];

    UIViewController *controller = [[UIViewController alloc] init];
    NSString *expectedName = NSStringFromClass([controller class]);

    OCMExpect([self.trackerMock trackWithEvent:[OCMArg checkWithBlock:^BOOL(id obj) {
        if (![obj isKindOfClass:[MIPageViewEvent class]]) {
            return NO;
        }
        MIPageViewEvent *event = (MIPageViewEvent *)obj;
        return [event.pageName isEqualToString:expectedName];
    }]]).andReturn(nil);

    NSError *error = [_instance trackPageWithViewController:controller pageViewEvent:nil];

    XCTAssertNil(error);
    OCMVerifyAll(self.trackerMock);
}

- (void)testTrackPageWithNameCallsTrackerWhenEnabled {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];
    [_instance optIn];

    self.trackerMock = OCMClassMock([MIDefaultTracker class]);
    [_instance setValue:self.trackerMock forKey:@"tracker"];

    OCMExpect([self.trackerMock trackWith:@"TestPage"]).andReturn(nil);

    NSError *error = [_instance trackPageWith:@"TestPage"];

    XCTAssertNil(error);
    OCMVerifyAll(self.trackerMock);
}

- (void)testTrackUrlDelegatesToDeepLink {
    id deepLinkMock = OCMClassMock([MIDeepLink class]);
    OCMStub([deepLinkMock trackFromUrl:[OCMArg any] withMediaCode:[OCMArg any]]).andReturn(nil);

    NSError *error = [_instance trackUrl:[NSURL URLWithString:@"https://example.com"] withMediaCode:@"m"];

    XCTAssertNil(error);
    [deepLinkMock stopMocking];
}

- (void)testTrackMediaReturnsNilWhenShouldTrackFalse {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];
    [_instance optIn];

    self.trackerMock = OCMClassMock([MIDefaultTracker class]);
    [_instance setValue:self.trackerMock forKey:@"tracker"];

    [self swizzleMediaTrackerSharedInstance];

    OCMReject([self.trackerMock trackWithEvent:[OCMArg any]]);

    MIMediaParameters *mediaParameters = [[MIMediaParameters alloc] initWith:@"media" action:@"play" position:@0 duration:@1];
    MIMediaEvent *event = [[MIMediaEvent alloc] initWithPageName:@"media" parameters:mediaParameters];
    NSError *error = [_instance trackMedia:event];

    XCTAssertNil(error);
}

- (void)testSetRequestIntervalResetsTimer {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];
    NSTimer *oldTimer = [_instance valueForKey:@"timerForSendRequests"];
    XCTAssertNotNil(oldTimer);

    [_instance setRequestInterval:2.0];
    NSTimer *newTimer = [_instance valueForKey:@"timerForSendRequests"];

    XCTAssertNotNil(newTimer);
    XCTAssertNotEqual(oldTimer, newTimer);
    [newTimer invalidate];
}

- (void)testSetLogLevelUpdatesConfig {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];
    [_instance setLogLevel:debug];

    XCTAssertEqual([_instance logLevel], debug);
}

- (void)testInitWithConfigurationAndEverIdUsesProvidedValue {
    MIDefaultTracker *tracker = [MIDefaultTracker sharedInstance];
    id trackerPartial = OCMPartialMock(tracker);
    id trackerClassMock = OCMClassMock([MIDefaultTracker class]);
    OCMStub([trackerClassMock sharedInstance]).andReturn(trackerPartial);

    OCMExpect([trackerPartial setEverIDFromString:@"ever-id"]);

    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain andWithEverID:@"ever-id"];

    OCMVerifyAll(trackerPartial);
    [trackerPartial stopMocking];
    [trackerClassMock stopMocking];
}

- (void)testInitWithConfigurationAndEmptyEverIdResetsWhenConfigured {
    [_instance initWithConfiguration:@[@1111] onTrackdomain:_testTrackDomain];

    id instanceMock = OCMPartialMock(_instance);
    OCMExpect([instanceMock reset]);
    OCMExpect([instanceMock setIdsAndDomain:@[@2222] onTrackdomain:@"https://new.example"]);

    [instanceMock initWithConfiguration:@[@2222] onTrackdomain:@"https://new.example" andWithEverID:@""];

    OCMVerifyAll(instanceMock);
    [instanceMock stopMocking];
}

- (void)testPrintAllRequestFromDatabaseHandlesError {
    id dbMock = OCMPartialMock([MIDatabaseManager shared]);
    [MIDatabaseManager setShared:dbMock];
    __block BOOL handlerCalled = NO;

    OCMStub([dbMock fetchAllRequestsFromInterval:100 andWithCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation) {
        void (^handler)(NSError *, id) = nil;
        [invocation getArgument:&handler atIndex:3];
        handlerCalled = YES;
        if (handler) {
            handler([NSError errorWithDomain:@"test" code:1 userInfo:nil], nil);
        }
    });

    [_instance printAllRequestFromDatabase];

    XCTAssertTrue(handlerCalled);
    [MIDatabaseManager setShared:nil];
    [dbMock stopMocking];
}

- (void)testRemoveRequestFromDatabaseWithIDCallsDelete {
    id dbMock = OCMPartialMock([MIDatabaseManager shared]);
    [MIDatabaseManager setShared:dbMock];
    OCMExpect([dbMock deleteRequest:42]);

    [_instance removeRequestFromDatabaseWithID:42];

    OCMVerifyAll(dbMock);
    [MIDatabaseManager setShared:nil];
    [dbMock stopMocking];
}

- (void)testSetShouldMigrateCallsTracker {
    MIDefaultTracker *tracker = [MIDefaultTracker sharedInstance];
    id trackerPartial = OCMPartialMock(tracker);
    id trackerClassMock = OCMClassMock([MIDefaultTracker class]);
    OCMStub([trackerClassMock sharedInstance]).andReturn(trackerPartial);

    OCMExpect([trackerPartial migrateData]);

    [_instance setShouldMigrate:YES];

    XCTAssertTrue(_instance.shouldMigrate);
    OCMVerifyAll(trackerPartial);
    [trackerPartial stopMocking];
    [trackerClassMock stopMocking];
}

- (void)testSetAnonymousTrackingClearsTemporaryAndSuppressed {
    MIDefaultTracker *tracker = [MIDefaultTracker sharedInstance];
    id trackerPartial = OCMPartialMock(tracker);
    id trackerClassMock = OCMClassMock([MIDefaultTracker class]);
    OCMStub([trackerClassMock sharedInstance]).andReturn(trackerPartial);
    [_instance setValue:trackerPartial forKey:@"tracker"];

    OCMExpect([trackerPartial setAnonymousTracking:NO]);
    OCMExpect([trackerPartial setSuppressedParameters:nil]);
    OCMExpect([trackerPartial setTemporaryID:NULL]);

    [_instance setAnonymousTracking:NO];

    OCMVerifyAll(trackerPartial);
    [trackerPartial stopMocking];
    [trackerClassMock stopMocking];
}

- (void)testFormTrackingCallsTracker {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];

    self.trackerMock = OCMClassMock([MIDefaultTracker class]);
    [_instance setValue:self.trackerMock forKey:@"tracker"];

    OCMExpect([self.trackerMock trackWithEvent:[OCMArg isKindOfClass:[MIFormSubmitEvent class]]]).andReturn(nil);

    MIFormParameters *params = [[MIFormParameters alloc] init];
    NSError *error = [_instance formTracking:params];

    XCTAssertNil(error);
    OCMVerifyAll(self.trackerMock);
}

- (void)testTimerSendsBatchWhenReachableAndBatchEnabled {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];
    [_instance setBatchSupportEnabled:YES];

    MIDefaultTracker *tracker = [MIDefaultTracker sharedInstance];
    id trackerPartial = OCMPartialMock(tracker);
    [_instance setValue:trackerPartial forKey:@"tracker"];
    OCMExpect([trackerPartial sendBatchForRequestInBackground:NO withCompletionHandler:[OCMArg any]]);

    Reachability *reachabilityInstance = [Reachability reachabilityForInternetConnection];
    id reachabilityInstanceMock = OCMPartialMock(reachabilityInstance);
    id reachabilityClassMock = OCMClassMock([Reachability class]);
    OCMStub([reachabilityClassMock reachabilityForInternetConnection]).andReturn(reachabilityInstanceMock);
    OCMStub([reachabilityInstanceMock currentReachabilityStatus]).andReturn(ReachableViaWiFi);

    id applicationClassMock = OCMClassMock([UIApplication class]);
    OCMStub([applicationClassMock sharedApplication]).andReturn(applicationClassMock);
    OCMStub([applicationClassMock applicationState]).andReturn(UIApplicationStateActive);

    NSTimer *timer = [_instance valueForKey:@"timerForSendRequests"];
    [timer fire];

    OCMVerifyAll(trackerPartial);
    [trackerPartial stopMocking];
    [reachabilityInstanceMock stopMocking];
    [reachabilityClassMock stopMocking];
    [applicationClassMock stopMocking];
}

- (void)testTimerSkipsWhenAppInactive {
    [_instance initWithConfiguration:@[@1234] onTrackdomain:_testTrackDomain];

    id applicationClassMock = OCMClassMock([UIApplication class]);
    OCMStub([applicationClassMock sharedApplication]).andReturn(applicationClassMock);
    OCMStub([applicationClassMock applicationState]).andReturn(UIApplicationStateInactive);

    NSTimer *timer = [_instance valueForKey:@"timerForSendRequests"];
    [timer fire];

    [applicationClassMock stopMocking];
}

#pragma mark - Swizzling

- (void)swizzleMediaTrackerSharedInstance {
    if (MIMediaTrackerSharedInstanceIMP != NULL) {
        return;
    }
    Class metaClass = object_getClass([MIMediaTracker class]);
    Method method = class_getClassMethod([MIMediaTracker class], @selector(sharedInstance));
    IMP newIMP = imp_implementationWithBlock(^id(__unused id _self) {
        return MIMediaTrackerSharedInstanceOverride;
    });
    if (!method) {
        class_addMethod(metaClass, @selector(sharedInstance), newIMP, "@@:");
        MIMediaTrackerSharedInstanceOverride = nil;
        MIMediaTrackerSharedInstanceIMP = NULL;
        return;
    }
    MIMediaTrackerSharedInstanceIMP = method_getImplementation(method);
    MIMediaTrackerSharedInstanceOverride = [[MIMediaTrackerTestDouble alloc] init];
    method_setImplementation(method, newIMP);
}

- (void)restoreMediaTrackerSharedInstanceSwizzle {
    if (MIMediaTrackerSharedInstanceIMP == NULL) {
        return;
    }
    Class metaClass = object_getClass([MIMediaTracker class]);
    Method method = class_getClassMethod([MIMediaTracker class], @selector(sharedInstance));
    if (method) {
        method_setImplementation(method, MIMediaTrackerSharedInstanceIMP);
    } else {
        class_addMethod(metaClass, @selector(sharedInstance), MIMediaTrackerSharedInstanceIMP, "@@:");
    }
    MIMediaTrackerSharedInstanceIMP = NULL;
    MIMediaTrackerSharedInstanceOverride = nil;
}

//- (void)testTrackController {
//    UIViewController *controller = [[UIViewController alloc] init];
//    XCTAssertNil([_instance trackPage:controller], "There is no error while tracking controller.");
//}
//
//- (void)testTrackCustomName {
//    XCTAssertNil([_instance trackPageWith:@"customPageName"], "There is no error while tracking custom page name.");
//}
@end
