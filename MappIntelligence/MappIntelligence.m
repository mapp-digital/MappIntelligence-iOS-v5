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
#import "MIDatabaseManager.h"
#import "MIRequestData.h"
#import "MIDeepLink.h"
#import "MIMediaTracker.h"
#import <UIKit/UIKit.h>

@interface MappIntelligence ()

@property MappIntelligenceDefaultConfig *configuration;
@property MIDefaultTracker *tracker;
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
- (NSError *_Nullable)trackPageWithViewController:(UIViewController *_Nonnull)controller pageViewEvent:(MIPageViewEvent*_Nullable) event {
    if (![self isTrackingEnabled]) {
        return nil;
    }
    NSString* name = NSStringFromClass([controller class]);
    
    if(!event) {
        event = [[MIPageViewEvent alloc] init];
    }
    event.pageName = name;
    return [tracker trackWithEvent:event];
}

#endif

- (NSError *_Nullable)trackPageWith:(NSString *)name {
    if (![self isTrackingEnabled]) {
        return nil;
    }
  return [tracker trackWith:name];
}

- (NSError *_Nullable) trackUrl:(NSURL *) url withMediaCode:(NSString *_Nullable) mediaCode {
    return [MIDeepLink trackFromUrl:url withMediaCode:mediaCode];
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
  [config setSendAppVersionToEveryRequest:NO];
  [config setBackgroundSendout:NO];
  [config logConfig];

  tracker = [MIDefaultTracker sharedInstance];
  [tracker initializeTracking];
    
    [[MIDatabaseManager shared] removeOldRequestsWithCompletitionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            [self->_logger logObj:@"Remove requests that are older than 14 days." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        }
        if (config.batchSupport == YES) {
            //TODO: add timeout to this methods
            [self->tracker sendBatchForRequestInBackground: NO withCompletionHandler:^(NSError * _Nullable error) {
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
        
        BOOL isAppActive = YES;
 #if !TARGET_OS_WATCH
         isAppActive = [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive;
 #else
         isAppActive = YES;
 #endif
        if (!isAppActive)
            return;
        if (config.backgroundSendout == YES && !isAppActive) {
            [self->tracker sendBatchForRequestInBackground: YES withCompletionHandler:^(NSError * _Nullable error) {
                //error is already obtain in one level lower
            }];
            return;
        }
        
        if (config.batchSupport == YES) {
            [self->tracker sendBatchForRequestInBackground: NO withCompletionHandler:^(NSError * _Nullable error) {
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

- (void)setEnableBackgroundSendout:(BOOL)enableBackgroundSendout {
    [config setBackgroundSendout:enableBackgroundSendout];
    [config logConfig];
}

- (BOOL)enableBackgroundSendout {
    return config.backgroundSendout;
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
        [tracker sendBatchForRequestInBackground: NO withCompletionHandler:^(NSError * _Nullable error) {
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
    [[MIDatabaseManager shared] fetchAllRequestsFromInterval:[config requestPerQueue] andWithCompletionHandler: ^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            MIRequestData* dt = (MIRequestData*)data;
            [dt print];
        } else {
            NSLog(@"error while fetching requests from local database!");
        }
    }];
}

- (void)removeRequestFromDatabaseWithID: (int)ID; {
    [[MIDatabaseManager shared] deleteRequest:ID];
}

- (NSError *_Nullable) trackPage:(MIPageViewEvent *_Nonnull) event {
    if (![self isTrackingEnabled]) {
        return nil;
    }
    return [tracker trackWithEvent:event];
}

- (NSError *_Nullable) trackAction:(MIActionEvent *_Nonnull) event {
    if (![self isTrackingEnabled]) {
        return nil;
    }
    return [tracker trackWithEvent:event];
}

- (NSError *_Nullable) trackMedia:(MIMediaEvent *_Nonnull) event {
    if (![self isTrackingEnabled]) {
        return nil;
    }
    if ([[MIMediaTracker sharedInstance] shouldTrack:event]){
        return [tracker trackWithEvent:event];
    } else {
        [_logger logObj:@"Media tracking skipped." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        return nil;
    }
}

-(BOOL) isTrackingEnabled {
    if ([config optOut]) {
         [_logger logObj:@"You are opted-out. No track requests are sent to the server anymore." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        return NO;
    }
    if (![config isConfiguredForTracking]) {
        return NO;
    }
    return YES;
}

- (NSError *_Nullable) trackCustomPage: (NSString *_Nonnull)pageName trackingParams: (NSDictionary<NSString *, NSString*> *_Nullable) trackingParams {
    if (![self isTrackingEnabled]) {
        return nil;
    }
    MIPageViewEvent *event = [[MIPageViewEvent alloc] initWithName:pageName];
    event.trackingParams = trackingParams;
  return [tracker trackWithCustomEvent:event];
}

- (NSError *_Nullable) trackCustomEvent: (NSString *_Nonnull)eventName trackingParams: (NSDictionary<NSString *, NSString*> *_Nullable) trackingParams {
    if (![self isTrackingEnabled]) {
        return nil;
    }
    MIActionEvent *event = [[MIActionEvent alloc] initWithName:eventName];
    event.trackingParams = trackingParams;
  return [tracker trackWithCustomEvent:event];
}

- (void)setShouldMigrate:(BOOL)shouldMigrate {
    if (shouldMigrate) {
        [[MIDefaultTracker sharedInstance] migrateData];
    }
    _shouldMigrate = shouldMigrate;
}

-(BOOL) anonymousTracking {
    return [[MIDefaultTracker sharedInstance] anonymousTracking];
}

-(void) setAnonymousTracking:(BOOL)anonymousTracking {
    NSString *state = anonymousTracking ? @"enabled. Please note that using this option will negatively affect data quality.": @"disabled.";
    [_logger logObj: [NSString stringWithFormat: @"Anonymous tracking %@", state] forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    [[MIDefaultTracker sharedInstance] setAnonymousTracking:anonymousTracking];
    if (!anonymousTracking) {
        [[MIDefaultTracker sharedInstance] setSuppressedParameters:nil];
    }
}

- (void)setSendAppVersionInEveryRequest:(BOOL)sendAppVerisonToEveryRequest {
    [config setSendAppVersionToEveryRequest:sendAppVerisonToEveryRequest];
}

- (BOOL)sendAppVersionInEveryRequest {
    return [config sendAppVersionToEveryRequest];
}

-(void) enableAnonymousTracking:(NSArray<NSString *> *_Nullable) suppressParams {
    [[MIDefaultTracker sharedInstance] setAnonymousTracking:true];
    [[MIDefaultTracker sharedInstance] setSuppressedParameters:suppressParams];
    [_logger logObj: @"Anonymous tracking enabled. Please note that using this option will negatively affect data quality." forDescription:kMappIntelligenceLogLevelDescriptionDebug];
}

- (NSString *_Nonnull)getEverId {
    return [tracker generateEverId];
}


@end
