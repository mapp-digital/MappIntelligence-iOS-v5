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
      [DatabaseManager shared];
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
  return [tracker track:controller];
}
#endif

- (NSError *_Nullable)trackPageWith:(NSString *)name {
    if ([config optOut]) {
         [_logger logObj:@"You are opted-out. No track requests are sent to the server anymore." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        return NULL;
    }
  return [tracker trackWith:name];
}

- (NSError *)trackPageWithEvent:(PageViewEvent *)event {
    if ([config optOut]) {
         [_logger logObj:@"You are opted-out. No track requests are sent to the server anymore." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        return NULL;
    }
    return [tracker trackWithEvent:event];
}

- (void)initWithConfiguration:(NSArray *)trackIDs
                        onTrackdomain:(NSString *)trackDomain
              withAutotrackingEnabled:(BOOL)autoTracking
                       requestTimeout:(NSTimeInterval)requestTimeout
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
  //[config setRequestsInterval:requestTimeout];
  [config logConfig];

  tracker = [DefaultTracker sharedInstance];
  [tracker initializeTracking];
    
    [[DatabaseManager shared] removeOldRequestsWithCompletitionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            [self->_logger logObj:@"Remove older requests from 14 days" forDescription:kMappIntelligenceLogLevelDescriptionDebug];
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
    [self initWithConfiguration:trackIDs onTrackdomain:trackDomain withAutotrackingEnabled:YES requestTimeout:15*60 numberOfRequests:10 batchSupportEnabled:NO viewControllerAutoTrackingEnabled:YES andLogLevel: none];
}

- (void)setRequestTimeout:(NSTimeInterval)requestTimeout {
  [config setRequestsInterval:requestTimeout];
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

- (NSTimeInterval)requestTimeout {
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
    [config logConfig];
    [tracker reset];
}

- (void)optOutWith:(BOOL)status andSendCurrentData:(BOOL)value {
    [config setOptOut:status];
    [_logger logObj: [[NSString alloc] initWithFormat:@"You are opting out with status %d", status] forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    if (value) {
        //send data and remove it from DB
        [tracker sendBatchForRequestWithCompletionHandler:^(NSError * _Nullable error) {
            //error is already obtain in one level lower
        }];
    } else {
        //just remove data from DB, and do not send it
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
