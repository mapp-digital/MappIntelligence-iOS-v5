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
  return [tracker track:controller];
}
#endif

- (NSError *_Nullable)trackPageWith:(NSString *)name {
  return [tracker trackWith:name];
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
  [config setRequestsInterval:requestTimeout];
  [config logConfig];

  tracker = [DefaultTracker sharedInstance];
  [tracker initializeTracking];
    
    [[DatabaseManager shared] removeOldRequestsWithCompletitionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            [self->_logger logObj:@"Remove older requests from 14 days" forDescription:kMappIntelligenceLogLevelDescriptionDebug];
        }
        //TODO: uncoment after test batch support
        //[self->tracker sendRequestFromDatabase];
        [self->tracker sendBatchForRequest];
    }];
}

- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs onTrackdomain:(NSString *_Nonnull)trackDomain  {
    NSPredicate *p = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@",
                                                          [NSNumber class]];
    NSArray *filtered = [trackIDs filteredArrayUsingPredicate:p];
    if(filtered.count != trackIDs.count) {
        [_logger logObj:@"Track Identifiers can only contain NSNumbers. Initialization is stopped!" forDescription:kMappIntelligenceLogLevelDescriptionFault];
        return;
    }
    //default values for tequest timeout is 45 and for log level it is .none
    [self initWithConfiguration:trackIDs onTrackdomain:trackDomain withAutotrackingEnabled:YES requestTimeout:45 numberOfRequests:10 batchSupportEnabled:YES viewControllerAutoTrackingEnabled:YES andLogLevel: none];
}

- (void)setRequestTimeout:(NSTimeInterval)requestTimeout {
  [config setRequestsInterval:requestTimeout];
  [config logConfig];
}

- (void)setLogLevel:(logLevel)logLevel {
  [config setLogLevel:(MappIntelligenceLogLevelDescription)logLevel];
  [config logConfig];
}

- (NSTimeInterval)requestTimeout {
  return [config requestsInterval];
}

- (logLevel)logLevel {
  return (logLevel)[config logLevel];
}

- (void)reset {
    sharedInstance = NULL;
    sharedInstance = [self init];
    [_logger logObj:@"Reset Mapp Inteligence Instance."
        forDescription:kMappIntelligenceLogLevelDescriptionDebug];
    [config logConfig];
    [tracker reset];
}

- (void)printAllRequestFromDatabase {
    [[DatabaseManager shared] fetchAllRequestsWithCompletionHandler:^(NSError * _Nonnull error, id  _Nullable data) {
        if (!error) {
            RequestData* dt = (RequestData*)data;
            [dt print];
        } else {
            NSLog(@"error while fetching requests!");
        }
    }];
}

- (void)removeRequestFromDatabaseWithID: (int)ID; {
    [[DatabaseManager shared] deleteRequest:ID];
}

@end
