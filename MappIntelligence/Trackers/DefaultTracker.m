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
#define isFirstEventAfterAppUpdate @"isFirstEventAfterAppUpdate"
#define isFirstEventOfApp @"isFirstEventOfApp"
#define isSampling @"isSampling"
#define isOptedOut @"isOptedOut"
#define migrationCompleted @"migrationCompleted"
#define samplingRate @"samplingRate"
#define adClearId @"adClearId"
#define crossDeviceProperties @"crossDeviceProperties"
#define isSettingsToAppSpecificConverted @"isSettingsToAppSpecificConverted"
#define productListOrder @"productListOrder"

@interface DefaultTracker ()

@property Configuration *config;
@property TrackingEvent *event;
@property RequestUrlBuilder *requestUrlBuilder;
@property NSUserDefaults* defaults;
@property BOOL isFirstEvenOpen;
@property BOOL isFirstEventOfSession;
@property UIFlowObserver *flowObserver;

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
      [[RequestUrlBuilder alloc] initWithUrl:self.config.serverUrl
                                   andWithId:self.config.MappIntelligenceId];
  [_flowObserver setup];
}

- (NSString *)generateEverId {

  NSString *tmpEverId = [[DefaultTracker sharedDefaults] stringForKey:everId];
  // https://nshipster.com/nil/ read for more explanation
  if (tmpEverId != nil) {
    return tmpEverId;
  } else {
    tmpEverId = [[NSString alloc]
        initWithFormat:@"6%010.0f%08u",
                       [[[NSDate alloc] init] timeIntervalSince1970],
                       arc4random_uniform(99999999) + 1];
    [[DefaultTracker sharedDefaults] setValue:tmpEverId forKey:everId];

    if ([everId isEqual:[[NSNull alloc] init]]) {
      @throw @"Can't generate ever id";
    }
    return tmpEverId;
  }

  return @"";
}

- (void)track:(UIViewController *)controller {

  if (![_defaults stringForKey:isFirstEventOfApp]) {
    [_defaults setBool:YES forKey:isFirstEventOfApp];
    [_defaults synchronize];
    _isFirstEvenOpen = YES;
  } else {
    _isFirstEvenOpen = NO;
  }

  NSString *CurrentSelectedCViewController =
      NSStringFromClass([controller class]);
  [[MappIntelligenceLogger shared]
              logObj:[[NSString alloc]
                         initWithFormat:@"Content ID is: %@",
                                        CurrentSelectedCViewController]
      forDescription:kMappIntelligenceLogLevelDescriptionDebug];

  // create request with page event
  TrackingEvent *event = [[TrackingEvent alloc] init];
  [event setPageName:CurrentSelectedCViewController];
  [self enqueueRequestForEvent:event];
  _isFirstEventOfSession = NO;
}

- (void)enqueueRequestForEvent:(TrackingEvent *)event {
  Properties *requestProperties = [self generateRequestProperties];
  requestProperties.locale = [NSLocale currentLocale];

#ifdef TARGET_OS_WATCHOS

#else
// requestProperties.screenSize =
#endif
  [requestProperties setIsFirstEventOfApp:_isFirstEvenOpen];
  [requestProperties setIsFirstEventOfSession:_isFirstEventOfSession];
  [requestProperties setIsFirstEventAfterAppUpdate:NO];

  RequestTrackerBuilder *builder =
      [[RequestTrackerBuilder alloc] initWithConfoguration:self.config];

  TrackerRequest *request =
      [builder createRequestWith:event andWith:requestProperties];

  NSURL *requestUrl = [_requestUrlBuilder urlForRequest:request];

  [request sendRequestWith:requestUrl];
  _isFirstEventOfSession = NO;
  _isFirstEvenOpen = NO;
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
  [DefaultTracker.sharedDefaults setObject:date forKey:appHibernationDate];
  [_defaults synchronize];
}

- (void)updateFirstSession {
  NSDate *hibernationDateSettings =
      [DefaultTracker.sharedDefaults objectForKey:appHibernationDate];
  [[MappIntelligenceLogger shared]
              logObj:[[NSString alloc]
                         initWithFormat:@"read saved date for session "
                                        @"detection %@, defaults %d value: %@ "
                                        @"timeIntervalSinceNow is: %f)",
                                        hibernationDateSettings,
                                        _defaults == NULL,
                                        hibernationDateSettings,
                                        [hibernationDateSettings
                                            timeIntervalSinceNow]]
      forDescription:kMappIntelligenceLogLevelDescriptionDebug];
  NSTimeInterval resendOnStartEventTime = (30 * 60);
  if ((-[hibernationDateSettings timeIntervalSinceNow]) <
      resendOnStartEventTime) {
    _isFirstEventOfSession = YES;
  } else {
    _isFirstEventOfSession = NO;
  }
}
@end

