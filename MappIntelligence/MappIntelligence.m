//
//  Webrekk.m
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MappIntelligence.h"
#import "MappIntelligenceDefaultConfig.h"
#import "MappIntelligenceLogger.h"
#import "DatabaseManager.h"
#import "RequestData.h"
#import <UIKit/UIKit.h>

@interface MappIntelligence ()

@property MappIntelligenceDefaultConfig *configuration;
@property DefaultTracker *tracker;
@property MappIntelligenceLogger *logger;
@property NSTimer* timerForSendRequests;

@end

@implementation MappIntelligence

static MappIntelligence *sharedInstance = nil;
static MappIntelligenceDefaultConfig *config = nil;

@synthesize tracker;

- (id)init {
  if (!sharedInstance) {
    sharedInstance = [super init];
    config = [[MappIntelligenceDefaultConfig alloc] init];
    _logger = [MappIntelligenceLogger shared];
      _batchSupportSize = batchSupportSizeDefault;

  }
  return sharedInstance;
}

+ (nullable instancetype)shared {
  static MappIntelligence *shared = nil;

  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{

    shared = [[MappIntelligence alloc] init];
  });

  return shared;
}

+ (NSString *)version {
  return @"5.0.0";
}

+ (NSString *)getUrl {
  return ([config trackDomain] == NULL) ? @"" : [config trackDomain];;
}

+ (NSString *)getId {
  return ([[config trackIDs] firstObject] == NULL)
             ? @""
             : [NSString
                   stringWithFormat:@"%@", [[config trackIDs] componentsJoinedByString:@","]];
}

#if !TARGET_OS_WATCH
- (NSError *_Nullable)trackPage:(UIViewController *)controller {
    if ([config optOut]) {
        [_logger logObj:@"You are opted-out. No track requests are sent to the server anymore." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        return NULL;
    }
    if (![config isConfiguredForTracking]) {
        return NULL;
    }
  return [tracker track:controller];
}

- (NSError *_Nullable)trackPageWithViewController:(UIViewController *_Nonnull)controller pageProperties:(PageProperties  *_Nullable)pageProperties sessionProperties:(SessionProperties *_Nullable) sessionProperties; {
    if ([config optOut]) {
         [_logger logObj:@"You are opted-out. No track requests are sent to the server anymore." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        return NULL;
    }
    if (![config isConfiguredForTracking]) {
        return NULL;
    }
    NSString* name = NSStringFromClass([controller class]);
    return [tracker trackWithEvent:[[PageViewEvent alloc] initWithName:name pageProperties:pageProperties sessionProperties:sessionProperties]];
}
#endif

- (NSError *_Nullable)trackPageWith:(NSString *)name {
    if ([config optOut]) {
         [_logger logObj:@"You are opted-out. No track requests are sent to the server anymore." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        return NULL;
    }
    if (![config isConfiguredForTracking]) {
        return NULL;
    }
  return [tracker trackWith:name];
}

- (NSError *)trackPageWithEvent:(PageViewEvent *)event {
    if ([config optOut]) {
         [_logger logObj:@"You are opted-out. No track requests are sent to the server anymore." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        return NULL;
    }
    if (![config isConfiguredForTracking]) {
        return NULL;
    }
    return [tracker trackWithEvent:event];
}

- (NSError *_Nullable)trackPageWithName: (NSString *_Nonnull) name pageProperties:(PageProperties  *_Nullable)pageProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties {
    if ([config optOut]) {
         [_logger logObj:@"You are opted-out. No track requests are sent to the server anymore." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        return NULL;
    }
    if (![config isConfiguredForTracking]) {
        return NULL;
    }
    return [tracker trackWithEvent:[[PageViewEvent alloc] initWithName:name pageProperties:pageProperties sessionProperties:sessionProperties]];
}

- (NSError *_Nullable) trackCustomEventWithName:(NSString *_Nonnull) name  actionProperties: (ActionProperties *_Nullable) actionProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties {
    if ([config optOut]) {
         [_logger logObj:@"You are opted out and you have no ability to track anymore." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        return NULL;
    }
    if (![config isConfiguredForTracking]) {
        return NULL;
    }
    ActionEvent *actionEvent = [[ActionEvent alloc] initWithName:name pageName:@"0" actionProperties:actionProperties sessionProperties:sessionProperties];
    return [tracker trackAction: actionEvent];
}

- (void)initWithConfiguration:(NSArray *)trackIDs
                        onTrackdomain:(NSString *)trackDomain
              withAutotrackingEnabled:(BOOL)autoTracking
                       requestInterval:(NSTimeInterval)requestInterval
                     numberOfRequests:(NSInteger)numberOfRequestInQueue
                  batchSupportEnabled:(BOOL)batchSupport
    viewControllerAutoTrackingEnabled:(BOOL)viewControllerAutoTracking
                          andLogLevel:(logLevel)lv {

  [config setLogLevel:(MappIntelligenceLogLevelDescription)lv];
  [config setTrackIDs:trackIDs];
  [config setTrackDomain:trackDomain];
  [config setAutoTracking:autoTracking];
  [config setBatchSupport:batchSupport];
  [config setViewControllerAutoTracking:viewControllerAutoTracking];
  [config setRequestPerQueue:numberOfRequestInQueue];
  //[config setRequestsInterval:requestInterval];
  [config logConfig];

  tracker = [DefaultTracker sharedInstance];
  [tracker initializeTracking];
    
    [[DatabaseManager shared] removeOldRequestsWithCompletitionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            [self->_logger logObj:@"Remove requests that are older than 14 days." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        }
        if (config.batchSupport == YES) {
            //TODO: add timeout to this methods
            [self->tracker sendBatchForRequestWithCompletionHandler:^(NSError * _Nullable error) {
                //error is already obtain at one level lower
            }];
        } else {
            [self->tracker sendRequestFromDatabaseWithCompletionHandler:^(NSError * _Nullable error) {
                //error is already obtain in one level lower
            }];
        }
    }];
    [self initTimerForRequestsSendout];
}

- (void)initTimerForRequestsSendout {
    _timerForSendRequests = [NSTimer scheduledTimerWithTimeInterval: [config requestsInterval] repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (config.batchSupport == YES) {
            [self->tracker sendBatchForRequestWithCompletionHandler:^(NSError * _Nullable error) {
                //error is already obtain in one level lower
            }];
        } else {
            [self->tracker sendRequestFromDatabaseWithCompletionHandler:^(NSError * _Nullable error) {
                //error is already obtain in one level lower
            }];
        }
    }];
}

- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs onTrackdomain:(NSString *_Nonnull)trackDomain  {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@",
                                                          [NSNumber class]];
    NSArray *filtered = [trackIDs filteredArrayUsingPredicate:p];
    if(filtered.count != trackIDs.count) {
        [_logger logObj:@"trackID can only contain NSNumbers. Initialization is stopped!" forDescription:kMappIntelligenceLogLevelDescriptionFault];
        return;
    }
    //default values for tequest timeout is 45 and for log level it is .none
    [self initWithConfiguration:trackIDs onTrackdomain:trackDomain withAutotrackingEnabled:YES requestInterval: requestIntervalDefault numberOfRequests:requestPerQueueDefault
            batchSupportEnabled:batchSupportDefault viewControllerAutoTrackingEnabled:YES andLogLevel: none];
}

- (void)setRequestInterval:(NSTimeInterval)requestInterval {
  [config setRequestsInterval:requestInterval];
  [config logConfig];
  if (_timerForSendRequests) {
    [_timerForSendRequests invalidate];
    _timerForSendRequests = nil;
    [self initTimerForRequestsSendout];
  }
}

- (void)setLogLevel:(logLevel)logLevel {
  [config setLogLevel:(MappIntelligenceLogLevelDescription)logLevel];
  [config logConfig];
}

- (void) setBatchSupportEnabled:(BOOL)batchSupportEnabled {
    [config setBatchSupport:batchSupportEnabled];
    [config logConfig];
}

- (NSInteger) requestPerQueue {
    return config.requestPerQueue;
}

- (void) setRequestPerQueue:(NSInteger)requestPerQueue {
    [config setRequestPerQueue:requestPerQueue];
    [config logConfig];
    [tracker initializeTracking];
}

- (NSTimeInterval)requestInterval {
  return [config requestsInterval];
}

- (logLevel)logLevel {
  return (logLevel)[config logLevel];
}

- (BOOL)batchSupportEnabled {
    return [config batchSupport];
}

- (void)reset {
    sharedInstance = NULL;
    sharedInstance = [self init];
    [_logger logObj:@"Reset Mapp Intelligence Instance."
        forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    [config reset];
    [config logConfig];
    [tracker reset];
    [_logger logObj:@"Resetting the SDK sets all configuration options to the default values. Please initialize tracking by specifying your trackdomain and trackID after calling reset" forDescription:kMappIntelligenceLogLevelDescriptionInfo];
}

- (void)optIn {
    [config setOptOut:NO];
    [_logger logObj: @"You are opted-in. Tracking started." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
}


- (void)optOutAndSendCurrentData:(BOOL)value {
    [config setOptOut:YES];
    if (value) {
        //send data and remove it from DB
        [_logger logObj: @"You are opted-out. Current data is sent to trackserver." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        [tracker sendBatchForRequestWithCompletionHandler:^(NSError * _Nullable error) {
            //error is already obtain in one level lower
        }];
    } else {
        //just remove data from DB, and do not send it
        [_logger logObj: @"You are opted-out. Current data is deleted." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        [tracker removeAllRequestsFromDBWithCompletionHandler:^(NSError * _Nullable error) {
            //error is already obtain in one level lower
        }];
    }
}

- (void)printAllRequestFromDatabase {
    [[DatabaseManager shared] fetchAllRequestsFromInterval:[config requestPerQueue] andWithCompletionHandler: ^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            RequestData* dt = (RequestData*)data;
            [dt print];
        } else {
            NSLog(@"error while fetching requests from local database!");
        }
    }];
}

- (void)removeRequestFromDatabaseWithID: (int)ID; {
    [[DatabaseManager shared] deleteRequest:ID];
}

@end
