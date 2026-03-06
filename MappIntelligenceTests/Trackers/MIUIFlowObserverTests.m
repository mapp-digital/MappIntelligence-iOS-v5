//
//  MIUIFlowObserverTests.m
//  MappIntelligenceTests
//
//  Created by Codex on 03/05/2026.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "MIUIFlowObserver.h"
#import "MappIntelligence.h"
#import "MIDefaultTracker.h"
#import "MIExceptionTracker.h"
#import "Reachability.h"

@interface MappIntelligence (MIUIFlowObserverTestAccess)
- (void)setBatchSupportEnabled:(BOOL)batchSupportEnabled;
- (BOOL)batchSupportEnabled;
@end

@interface MIUIFlowObserver (TestAccess)
- (void)sendAllRequestFromDB;
- (void)didBecomeActive;
- (void)willResignActive;
- (void)willTerminate;
- (void)willEnterBckground;
- (void)checkFNS;
- (void)getExceptionFromFileAndSendItAsAnRequest;
- (void)handleNetworkChange:(NSNotification *)notice;
- (void)invalidate;
@end

@interface MIUIFlowObserverTests : XCTestCase
@property (nonatomic, strong) MIDefaultTracker *tracker;
@property (nonatomic, strong) id trackerMock;
@property (nonatomic, strong) id trackerClassMock;
@property (nonatomic, strong) id applicationClassMock;
@property (nonatomic, strong) MIUIFlowObserver *observer;
@end

@implementation MIUIFlowObserverTests

- (NSString *)exceptionFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return [documentsDirectory stringByAppendingPathComponent:@"file.txt"];
}

- (MIUIFlowObserver *)makeObserver {
    self.observer = [[MIUIFlowObserver alloc] initWith:self.trackerMock];
    return self.observer;
}

- (void)setUp {
    [super setUp];
    self.tracker = [MIDefaultTracker sharedInstance];
    self.trackerMock = OCMPartialMock(self.tracker);
    self.trackerClassMock = OCMClassMock([MIDefaultTracker class]);
    OCMStub([self.trackerClassMock sharedInstance]).andReturn(self.trackerMock);
}

- (void)tearDown {
    if (self.observer) {
        [self.observer invalidate];
        self.observer = nil;
    }
    [[MappIntelligence shared] setBatchSupportEnabled:NO];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"FirstOpen"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Background_Time"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"backgroundIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSFileManager defaultManager] removeItemAtPath:[self exceptionFilePath] error:nil];

    if (self.trackerClassMock) {
        [self.trackerClassMock stopMocking];
    }
    if (self.trackerMock) {
        [self.trackerMock stopMocking];
    }
    if (self.applicationClassMock) {
        [self.applicationClassMock stopMocking];
    }
    self.tracker = nil;
    [super tearDown];
}

- (void)testInitSetsBackgroundKey {
    MIUIFlowObserver *observer = [self makeObserver];
    XCTAssertNotNil(observer);

    NSString *key = [observer valueForKey:@"TIME_WHEN_APP_ENTERS_TO_BACKGROUND"];
    XCTAssertEqualObjects(key, @"Background_Time");
}

- (void)testSetupRegistersApplicationNotifications {
    id reachabilityClassMock = OCMClassMock([Reachability class]);
    id reachabilityInstanceMock = OCMClassMock([Reachability class]);
    OCMStub([reachabilityClassMock reachabilityForInternetConnection]).andReturn(reachabilityInstanceMock);
    OCMStub([reachabilityInstanceMock startNotifier]);
    OCMStub([reachabilityInstanceMock currentReachabilityStatus]).andReturn(NotReachable);

    MIUIFlowObserver *observer = [self makeObserver];
    id observerMock = OCMPartialMock(observer);

    XCTestExpectation *willResignExpectation = [self expectationWithDescription:@"willResignActive called"];
    OCMStub([observerMock willResignActive]).andDo(^(NSInvocation *invocation){
        [willResignExpectation fulfill];
    });

    XCTestExpectation *didBecomeExpectation = [self expectationWithDescription:@"didBecomeActive called"];
    OCMStub([observerMock didBecomeActive]).andDo(^(NSInvocation *invocation){
        [didBecomeExpectation fulfill];
    });

    [observerMock setup];

    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationWillEnterForegroundNotification object:nil];

    [self waitForExpectations:@[willResignExpectation, didBecomeExpectation] timeout:1.0];
    [observerMock stopMocking];
    [reachabilityInstanceMock stopMocking];
    [reachabilityClassMock stopMocking];
}

- (void)testSendAllRequestFromDBUsesBatchWhenEnabled {
    [[MappIntelligence shared] setBatchSupportEnabled:YES];
    MIUIFlowObserver *observer = [self makeObserver];

    OCMExpect([self.trackerMock sendBatchForRequestInBackground:NO withCompletionHandler:[OCMArg any]]);

    [observer sendAllRequestFromDB];

    OCMVerifyAll(self.trackerMock);
}

- (void)testSendAllRequestFromDBUsesSingleWhenBatchDisabled {
    [[MappIntelligence shared] setBatchSupportEnabled:NO];
    MIUIFlowObserver *observer = [self makeObserver];

    OCMExpect([self.trackerMock sendRequestFromDatabaseWithCompletionHandler:[OCMArg any]]);

    [observer sendAllRequestFromDB];

    OCMVerifyAll(self.trackerMock);
}

- (void)testHandleNetworkChangeTriggersSendWhenReachable {
    id reachabilityMock = OCMClassMock([Reachability class]);
    id reachabilityInstanceMock = OCMPartialMock([Reachability reachabilityForInternetConnection]);
    OCMStub([reachabilityMock reachabilityForInternetConnection]).andReturn(reachabilityInstanceMock);
    OCMStub([reachabilityInstanceMock currentReachabilityStatus]).andReturn(ReachableViaWiFi);

    MIUIFlowObserver *observer = [self makeObserver];
    id observerMock = OCMPartialMock(observer);
    OCMExpect([observerMock didBecomeActive]);
    OCMExpect([observerMock sendAllRequestFromDB]);

    [observerMock handleNetworkChange:[NSNotification notificationWithName:kReachabilityChangedNotification object:reachabilityInstanceMock]];

    OCMVerifyAll(observerMock);
    [observerMock stopMocking];
    [reachabilityInstanceMock stopMocking];
    [reachabilityMock stopMocking];
}

- (void)testDidBecomeActiveSkipsBackgroundHandlingWhenDisabled {
    OCMStub([self.trackerMock isBackgroundSendoutEnabled]).andReturn(NO);
    OCMStub([self.trackerMock isUserMatchingEnabled]).andReturn(NO);
    OCMReject([self.trackerMock removeAllRequestsFromDBWithCompletionHandler:[OCMArg any]]);

    MIUIFlowObserver *observer = [self makeObserver];
    id observerMock = OCMPartialMock(observer);
    OCMStub([observerMock getExceptionFromFileAndSendItAsAnRequest]);
    OCMStub([observerMock checkFNS]);

    [observerMock didBecomeActive];

    [observerMock stopMocking];
}

- (void)testDidBecomeActiveRemovesRequestsWhenBackgroundTaskInvalid {
    OCMStub([self.trackerMock isBackgroundSendoutEnabled]).andReturn(YES);
    OCMStub([self.trackerMock isUserMatchingEnabled]).andReturn(NO);

    [[NSUserDefaults standardUserDefaults] setInteger:UIBackgroundTaskInvalid forKey:@"backgroundIdentifier"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    id applicationClassMock = OCMClassMock([UIApplication class]);
    self.applicationClassMock = applicationClassMock;
    OCMStub([applicationClassMock sharedApplication]).andReturn(applicationClassMock);
    OCMStub([applicationClassMock endBackgroundTask:UIBackgroundTaskInvalid]);

    MIUIFlowObserver *observer = [self makeObserver];
    id observerMock = OCMPartialMock(observer);
    OCMStub([observerMock getExceptionFromFileAndSendItAsAnRequest]);
    OCMStub([observerMock checkFNS]);

    OCMExpect([self.trackerMock removeAllRequestsFromDBWithCompletionHandler:[OCMArg any]]);

    [observerMock didBecomeActive];

    OCMVerifyAll(self.trackerMock);
    [observerMock stopMocking];
}

- (void)testWillResignActiveUpdatesTrackerWhenInactive {
    id applicationClassMock = OCMClassMock([UIApplication class]);
    self.applicationClassMock = applicationClassMock;
    OCMStub([applicationClassMock sharedApplication]).andReturn(applicationClassMock);
    OCMStub([applicationClassMock applicationState]).andReturn(UIApplicationStateInactive);

    OCMExpect([self.trackerMock initHibernate]);
    OCMExpect([self.trackerMock updateFirstSessionWith:UIApplicationStateInactive]);

    MIUIFlowObserver *observer = [self makeObserver];
    [observer willResignActive];

    OCMVerifyAll(self.trackerMock);
}

- (void)testWillTerminateSetsFirstOpenAndUpdatesTracker {
    id applicationClassMock = OCMClassMock([UIApplication class]);
    self.applicationClassMock = applicationClassMock;
    OCMStub([applicationClassMock sharedApplication]).andReturn(applicationClassMock);
    OCMStub([applicationClassMock applicationState]).andReturn(UIApplicationStateBackground);

    OCMExpect([self.trackerMock updateFirstSessionWith:UIApplicationStateBackground]);

    MIUIFlowObserver *observer = [self makeObserver];
    [observer willTerminate];

    NSNumber *firstOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstOpen"];
    XCTAssertEqualObjects(firstOpen, @1);
    OCMVerifyAll(self.trackerMock);
}

- (void)testWillEnterBackgroundSetsFirstOpenWhenSendoutDisabled {
    OCMStub([self.trackerMock isBackgroundSendoutEnabled]).andReturn(NO);
    OCMStub([self.trackerMock isItFlutter]).andReturn(NO);

    MIUIFlowObserver *observer = [self makeObserver];
    [observer willEnterBckground];

    NSNumber *firstOpen = [[NSUserDefaults standardUserDefaults] objectForKey:@"FirstOpen"];
    XCTAssertEqualObjects(firstOpen, @2);

    NSDate *backgroundDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"Background_Time"];
    XCTAssertNil(backgroundDate);
}

- (void)testWillEnterBackgroundStartsBackgroundTaskWhenEnabled {
    OCMStub([self.trackerMock isBackgroundSendoutEnabled]).andReturn(YES);
    OCMStub([self.trackerMock isItFlutter]).andReturn(NO);

    id applicationClassMock = OCMClassMock([UIApplication class]);
    self.applicationClassMock = applicationClassMock;
    UIApplication *applicationInstance = [UIApplication sharedApplication];
    OCMStub([applicationClassMock sharedApplication]).andReturn(applicationClassMock);

    __block void (^expirationHandler)(void) = nil;
    OCMStub([applicationClassMock beginBackgroundTaskWithName:[OCMArg any] expirationHandler:[OCMArg any]])
        .andDo(^(NSInvocation *invocation) {
            __unsafe_unretained void (^handler)(void) = nil;
            [invocation getArgument:&handler atIndex:3];
            expirationHandler = [handler copy];
        })
        .andReturn(42);

    OCMStub([applicationClassMock endBackgroundTask:42]);

    OCMExpect([self.trackerMock sendBatchForRequestInBackground:YES withCompletionHandler:[OCMArg any]]).andDo(^(NSInvocation *invocation){
        void (^completion)(NSError *) = nil;
        [invocation getArgument:&completion atIndex:3];
        if (completion) {
            completion(nil);
        }
    });

    MIUIFlowObserver *observer = [self makeObserver];
    [observer willEnterBckground];

    NSNumber *backgroundIdentifier = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundIdentifier"];
    XCTAssertEqualObjects(backgroundIdentifier, @42);
    NSDate *backgroundDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"Background_Time"];
    XCTAssertNotNil(backgroundDate);

    if (expirationHandler) {
        expirationHandler();
    }

    OCMVerifyAll(self.trackerMock);
}

- (void)testCheckFNSUpdatesFirstSessionWhenFirstOpenIsOne {
    OCMStub([self.trackerMock isItFlutter]).andReturn(NO);
    [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"FirstOpen"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    OCMExpect([self.trackerMock updateFirstSessionWith:UIApplicationStateInactive]);

    MIUIFlowObserver *observer = [self makeObserver];
    [observer checkFNS];

    OCMVerifyAll(self.trackerMock);
}

- (void)testGetExceptionFromFileAndSendItAsRequestRemovesFile {
    id exceptionTrackerClassMock = OCMClassMock([MIExceptionTracker class]);
    MIExceptionTracker *exceptionTrackerInstance = [MIExceptionTracker sharedInstance];
    id exceptionTrackerInstanceMock = OCMPartialMock(exceptionTrackerInstance);
    OCMStub([exceptionTrackerClassMock sharedInstance]).andReturn(exceptionTrackerInstanceMock);
    OCMStub([exceptionTrackerInstanceMock trackExceptionWithName:[OCMArg any]
                                                      andReason:[OCMArg any]
                                                    andUserInfo:[OCMArg any]
                                         andCallStackReturnAddress:[OCMArg any]
                                               andCallStackSymbols:[OCMArg any]]).andReturn(nil);

    NSString *exceptionText = @"Name,Reason,UserInfo,ReturnAddress,Symbols";
    [exceptionText writeToFile:[self exceptionFilePath] atomically:YES encoding:NSUTF8StringEncoding error:nil];

    MIUIFlowObserver *observer = [self makeObserver];
    [observer getExceptionFromFileAndSendItAsAnRequest];

    BOOL exists = [[NSFileManager defaultManager] fileExistsAtPath:[self exceptionFilePath]];
    XCTAssertFalse(exists);

    [exceptionTrackerInstanceMock stopMocking];
    [exceptionTrackerClassMock stopMocking];
}

- (void)testHandleNetworkChangeDoesNothingWhenNotReachable {
    Reachability *reachabilityInstance = [Reachability reachabilityForInternetConnection];
    id reachabilityInstanceMock = OCMPartialMock(reachabilityInstance);
    id reachabilityMock = OCMClassMock([Reachability class]);
    OCMStub([reachabilityMock reachabilityForInternetConnection]).andReturn(reachabilityInstanceMock);
    OCMStub([reachabilityInstanceMock currentReachabilityStatus]).andReturn(NotReachable);

    MIUIFlowObserver *observer = [self makeObserver];
    id observerMock = OCMPartialMock(observer);
    OCMReject([observerMock didBecomeActive]);
    OCMReject([observerMock sendAllRequestFromDB]);

    [observerMock handleNetworkChange:[NSNotification notificationWithName:kReachabilityChangedNotification object:nil]];

    [observerMock stopMocking];
    [reachabilityInstanceMock stopMocking];
    [reachabilityMock stopMocking];
}

- (void)testDidBecomeActiveRemovesRequestsAfterLongBackground {
    OCMStub([self.trackerMock isBackgroundSendoutEnabled]).andReturn(YES);
    OCMStub([self.trackerMock isUserMatchingEnabled]).andReturn(NO);

    [[NSUserDefaults standardUserDefaults] setInteger:42 forKey:@"backgroundIdentifier"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate dateWithTimeIntervalSinceNow:-35] forKey:@"Background_Time"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    id applicationClassMock = OCMClassMock([UIApplication class]);
    self.applicationClassMock = applicationClassMock;
    OCMStub([applicationClassMock sharedApplication]).andReturn(applicationClassMock);
    OCMStub([applicationClassMock endBackgroundTask:42]);

    MIUIFlowObserver *observer = [self makeObserver];
    id observerMock = OCMPartialMock(observer);
    OCMStub([observerMock getExceptionFromFileAndSendItAsAnRequest]);
    OCMStub([observerMock checkFNS]);

    OCMExpect([self.trackerMock removeAllRequestsFromDBWithCompletionHandler:[OCMArg any]]);

    [observerMock didBecomeActive];

    OCMVerifyAll(self.trackerMock);
    [observerMock stopMocking];
}

- (void)testWillResignActiveDoesNothingWhenActive {
    id applicationClassMock = OCMClassMock([UIApplication class]);
    self.applicationClassMock = applicationClassMock;
    OCMStub([applicationClassMock sharedApplication]).andReturn(applicationClassMock);
    OCMStub([applicationClassMock applicationState]).andReturn(UIApplicationStateActive);

    OCMReject([self.trackerMock initHibernate]);

    MIUIFlowObserver *observer = [self makeObserver];
    [observer willResignActive];
}

@end
