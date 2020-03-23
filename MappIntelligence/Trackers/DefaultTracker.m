//
//  DefaultTracker.m
//  MappIntelligenceSDK
//
//  Created by Vladan Randjelovic on 11/02/2020.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefaultTracker.h"
#import "MappIntelligenceLogger.h"
#import "MappIntelligence.h"
#import "Properties.h"
#import "Enviroment.h"
#import "Configuration.h"
#import "RequestTrackerBuilder.h"
#import "TrackerRequest.h"
#import "RequestUrlBuilder.h"
#import "UIFlowObserver.h"

#define appHibernationDate @"appHibernationDate"
#define appVersion @"appVersion"
#define configuration @"configuration"
#define everId @"everId"
#define isFirstEventOfApp @"isFirstEventOfApp"

@interface DefaultTracker ()

@property Configuration *config;
@property TrackingEvent *event;
@property RequestUrlBuilder *requestUrlBuilder;
@property NSUserDefaults* defaults;
@property BOOL isFirstEventOpen;
@property BOOL isFirstEventOfSession;
@property UIFlowObserver *flowObserver;
@property NSCondition *conditionUntilGetFNS;

- (void)enqueueRequestForEvent:(TrackingEvent *)event;
- (Properties *)generateRequestProperties;

@end

@implementation DefaultTracker : NSObject

static DefaultTracker *sharedTracker = nil;
static NSString *everID;
static NSString *userAgent;

+ (nullable instancetype)sharedInstance {

  static DefaultTracker *shared = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    shared = [[DefaultTracker alloc] init];
  });
  return shared;
}

- (instancetype)init {
  if (!sharedTracker) {
    sharedTracker = [super init];
    everID = [sharedTracker generateEverId];
    _config = [[Configuration alloc] init];
    _defaults = [NSUserDefaults standardUserDefaults];
    _flowObserver = [[UIFlowObserver alloc] initWith:self];
    [_flowObserver setup];
    _conditionUntilGetFNS = [[NSCondition alloc] init];
    _isReady = NO;
    [self generateUserAgent];
    [self initializeTracking];
  }
  return sharedTracker;
}

- (void)generateUserAgent {
  Enviroment *env = [[Enviroment alloc] init];
  NSString *properties = [env.operatingSystemName
      stringByAppendingFormat:@" %@; %@; %@", env.operatingSystemVersionString,
                              env.deviceModelString,
                              NSLocale.currentLocale.localeIdentifier];

  userAgent =
      [[NSString alloc] initWithFormat:@"Tracking Library %@ (%@))",
                                       MappIntelligence.version, properties];
}

- (void)initializeTracking {
  _config.serverUrl = [[NSURL alloc] initWithString:[MappIntelligence getUrl]];
  _config.MappIntelligenceId = [MappIntelligence getId];
  _requestUrlBuilder =
      [[RequestUrlBuilder alloc] initWithUrl:_config.serverUrl
                                   andWithId:_config.MappIntelligenceId];
}

- (NSString *)generateEverId {

  NSString *tmpEverId = [[DefaultTracker sharedDefaults] stringForKey:everId];
  // https://nshipster.com/nil/ read for more explanation
  if (tmpEverId != nil) {
    return tmpEverId;
  } else {
    return [self getNewEverID];
  }

  return @"";
}

- (NSString *)getNewEverID {
  NSString *tmpEverId = [[NSString alloc]
      initWithFormat:@"6%010.0f%08u",
                     [[[NSDate alloc] init] timeIntervalSince1970],
                     arc4random_uniform(99999999) + 1];
  [[DefaultTracker sharedDefaults] setValue:tmpEverId forKey:everId];

  if ([everId isEqual:[[NSNull alloc] init]]) {
    @throw @"Can't generate ever id";
  }
  return tmpEverId;
}

- (void)track:(UIViewController *)controller {
  NSString *CurrentSelectedCViewController =
      NSStringFromClass([controller class]);
  [self trackWith:CurrentSelectedCViewController];
}

- (void)trackWith:(NSString *)name {
  if ([_config.MappIntelligenceId isEqual:@""] ||
      [_config.serverUrl isEqual:@""]) {
    [[MappIntelligenceLogger shared]
                logObj:@"Request can not be sent with empty track domain or track id."
        forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    return;
  }
  if (![_defaults stringForKey:isFirstEventOfApp]) {
    [_defaults setBool:YES forKey:isFirstEventOfApp];
    [_defaults synchronize];
    _isFirstEventOpen = YES;
    _isFirstEventOfSession = YES;
  } else {
    _isFirstEventOpen = NO;
  }

  [[MappIntelligenceLogger shared]
              logObj:[[NSString alloc]
                         initWithFormat:@"Content ID is: %@", name]
      forDescription:kMappIntelligenceLogLevelDescriptionDebug];

  // create request with page event
  TrackingEvent *event = [[TrackingEvent alloc] init];
  [event setPageName:name];

  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                 ^(void) {
                   // Background Thread
                   [self->_conditionUntilGetFNS lock];
                   while (!self->_isReady)
                     [self->_conditionUntilGetFNS wait];
                   dispatch_async(dispatch_get_main_queue(), ^(void) {
                     // Run UI Updates
                     [self enqueueRequestForEvent:event];
                     [self->_conditionUntilGetFNS unlock];
                   });
                 });
}

- (void)enqueueRequestForEvent:(TrackingEvent *)event {
  Properties *requestProperties = [self generateRequestProperties];
  requestProperties.locale = [NSLocale currentLocale];

#ifdef TARGET_OS_WATCHOS

#else
// requestProperties.screenSize =
#endif
  [requestProperties setIsFirstEventOfApp:_isFirstEventOpen];
  [requestProperties setIsFirstEventOfSession:_isFirstEventOfSession];
  [requestProperties setIsFirstEventAfterAppUpdate:NO];

  RequestTrackerBuilder *builder =
      [[RequestTrackerBuilder alloc] initWithConfoguration:self.config];

  TrackerRequest *request =
      [builder createRequestWith:event andWith:requestProperties];

  NSURL *requestUrl = [_requestUrlBuilder urlForRequest:request];

  [request sendRequestWith:requestUrl];
  _isFirstEventOfSession = NO;
  _isFirstEventOpen = NO;
}

- (Properties *)generateRequestProperties {
  return [[Properties alloc] initWithEverID:everID
                            andSamplingRate:0
                               withTimeZone:[NSTimeZone localTimeZone]
                              withTimestamp:[NSDate date]
                              withUserAgent:userAgent];
}

+ (NSUserDefaults *)sharedDefaults {
  return [NSUserDefaults standardUserDefaults];
}

- (void)initHibernate {
  NSDate *date = [[NSDate alloc] init];
  [[MappIntelligenceLogger shared]
              logObj:[[NSString alloc] initWithFormat:@"save current date for "
                                                      @"session detection %@ "
                                                      @"with defaults %d",
                                                      date, _defaults == NULL]
      forDescription:kMappIntelligenceLogLevelDescriptionDebug];
  [_defaults setObject:date forKey:appHibernationDate];
  _isReady = NO;
}

- (void)updateFirstSessionWith: (UIApplicationState) state {
    if (state == UIApplicationStateInactive) {
        _isFirstEventOfSession = YES;
    } else {
        _isFirstEventOfSession = NO;
    }
    _isReady = YES;
    [_conditionUntilGetFNS signal];
    [_conditionUntilGetFNS unlock];
}

- (void)reset {
    sharedTracker = NULL;
    sharedTracker = [self init];
    _isReady = YES;
    everID = [self getNewEverID];
}
@end

