//
//  MappIntelligenceDefaultConfig.m
//  Webrekk
//
//  Created by Vladan Randjelovic on 15/01/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MappIntelligenceDefaultConfig.h"
#import "MappIntelligenceLogger.h"

#define key_trackIDs @"track_ids"
#define key_trackDomain @"track_domain"
#define key_logLevel @"log_level"
#define key_requestsInterval @"requests_interval"
#define key_autoTracking @"auto_tracking"
#define key_requestPerQueue @"request_per_batch"
#define key_batchSupport @"batch_support"
#define key_optOut @"optOut"
#define key_viewControllerAutoTracking @"view_controller_auto_tracking"
#define key_MappIntelligence_default_configuration @"defaultConfiguration"

NSTimeInterval const requestIntervalDefault = 15*60;
BOOL const optOutDefault = NO;
BOOL const batchSupportDefault = NO;
NSInteger const requestPerQueueDefault = 100;
NSInteger const batchSupportSizeDefault = 5000;

@interface MappIntelligenceDefaultConfig ()
@property (nonnull) MappIntelligenceLogger *logger;
@end

@implementation MappIntelligenceDefaultConfig : NSObject



@synthesize autoTracking;
@synthesize batchSupport = _batchSupport;
@synthesize requestPerQueue = _requestPerQueue;
@synthesize requestsInterval = _requestsInterval;
@synthesize optOut = _optOut;
/**  Track domain is a mandatory field */
@synthesize trackDomain;

/** TrackID is a mandatory field. At least one must be entered to start tracking.*/
@synthesize trackIDs;
@synthesize viewControllerAutoTracking;
@synthesize logLevel;

- (instancetype)init {

    if (self = [super init]) {
      _logger = [MappIntelligenceLogger shared];
        self.requestsInterval =
            ([[NSUserDefaults standardUserDefaults]
                 doubleForKey:key_requestsInterval] != 0)
                ? (double)[[NSUserDefaults standardUserDefaults]
                      doubleForKey:key_requestsInterval]
                : requestIntervalDefault;
        self.optOut =
            (![[NSUserDefaults standardUserDefaults] doubleForKey:key_optOut])
                ? optOutDefault
                : [[NSUserDefaults standardUserDefaults]
                      doubleForKey:key_optOut];
        self.batchSupport = (![[NSUserDefaults standardUserDefaults]
                                doubleForKey:key_batchSupport])
                                ? batchSupportDefault
                                : [[NSUserDefaults standardUserDefaults]
                                      doubleForKey:key_batchSupport];
        self.requestPerQueue = (![[NSUserDefaults standardUserDefaults]
                                   doubleForKey:key_requestPerQueue])
                                   ? requestPerQueueDefault
                                   : [[NSUserDefaults standardUserDefaults]
                                         doubleForKey:key_requestPerQueue];
    }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {

  [encoder encodeInt64:self.requestPerQueue forKey:key_requestPerQueue];
  [encoder encodeBool:self.autoTracking forKey:key_autoTracking];
  [encoder encodeBool:self.batchSupport forKey:key_batchSupport];
  [encoder encodeInt64:self.requestsInterval forKey:key_requestsInterval];
  [encoder encodeBool:self.viewControllerAutoTracking
               forKey:key_viewControllerAutoTracking];
  [encoder encodeInt64:self.logLevel forKey:key_logLevel];
  [encoder encodeObject:self.trackIDs forKey:key_trackIDs];
  [encoder encodeObject:self.trackDomain forKey:key_trackDomain];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  if (self = [super init]) {
    self.autoTracking = [coder decodeBoolForKey:key_autoTracking];
    self.batchSupport = [coder decodeBoolForKey:key_batchSupport];
    self.requestPerQueue = [coder decodeIntForKey:key_requestPerQueue];
    self.requestsInterval = [coder decodeIntForKey:key_requestsInterval];
    self.trackDomain = [coder decodeObjectForKey:key_trackDomain];
    self.logLevel = [coder decodeIntForKey:key_logLevel];
    self.trackIDs = [coder decodeObjectForKey:key_trackIDs];
    self.viewControllerAutoTracking =
        [coder decodeBoolForKey:key_viewControllerAutoTracking];
  }
  return self;
}

- (void)logConfig {

  if (trackIDs == nil) {
    return;
  }
  [_logger logObj:([@"Autotracking is enabled: "
                      stringByAppendingFormat:self.autoTracking ? @"Yes"
                                                                : @"No"])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
  [_logger logObj:([@"Batch support is enabled: "
                      stringByAppendingFormat:self.batchSupport ? @"Yes"
                                                                : @"No"])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
  [self validateNumberOfRequestsPerQueue:self.requestPerQueue];
  [_logger logObj:([@"Number of requests in queue: "
                      stringByAppendingFormat:
                          @"%@",
                          [NSString
                              stringWithFormat:@"%ld",
                                               (long)self.requestPerQueue]])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
  [self validateRequestTimeInterval:self.requestsInterval];
  [_logger logObj:([@"Request time interval in minutes: "
                      stringByAppendingFormat:
                          @"%@",
                          [NSString
                              stringWithFormat:@"%f",
                                               (self.requestsInterval / 60.0)]])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
  [_logger logObj:([@"Log level is:  "
                      stringByAppendingFormat:@"%@",
                                              [self getLogLevelFor:[_logger logLevel]]])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
  [self validateTrackingIDs:self.trackIDs];
  [_logger logObj:([@"TrackIDs: "
                      stringByAppendingFormat:@"%@", self.trackIDs])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
  [self trackDomainValidation:self.trackDomain];
  [_logger logObj:([@"Track domain is: "
                      stringByAppendingFormat:@"%@", self.trackDomain])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
  [_logger logObj:([@"View Controller auto tracking is enabbled: "
                      stringByAppendingFormat:self.viewControllerAutoTracking
                                                  ? @"Yes"
                                                  : @"No"])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
}

- (NSString *)getLogLevelFor:(MappIntelligenceLogLevelDescription)description {
  return [_logger logLevelFor:description];
}

- (void)validateNumberOfRequestsPerQueue:(NSInteger)numberOfRequests {
  if (numberOfRequests > 10000) {
    [_logger logObj: [NSString stringWithFormat: @"Number of requests cannot exceed 10000, will be "
                    @"returned to "
                      @"default (%ld).", (long)requestPerQueueDefault]
        forDescription:kMappIntelligenceLogLevelDescriptionError];
    self.requestPerQueue = requestPerQueueDefault;
  }
    if (numberOfRequests < 100) {
      [_logger logObj:[NSString stringWithFormat: @"Number of requests cannot be lower than 100, will be "
                      @"returned to "
                       @"default (%ld).", (long)requestPerQueueDefault]
          forDescription:kMappIntelligenceLogLevelDescriptionError];
      self.requestPerQueue = requestPerQueueDefault;
    }
}

- (void)validateRequestTimeInterval:(NSInteger)timeInterval {
  if (timeInterval > 3600.0) {
    [_logger logObj:[NSString stringWithFormat: @"Request time interval cannot be more than 3600 seconds "
                     @"(60 minutes), will be reset to default (%f minutes).", requestIntervalDefault/60]
        forDescription:kMappIntelligenceLogLevelDescriptionError];
      self.requestsInterval = requestIntervalDefault;
  }
  else if (timeInterval < 5) {
      [_logger logObj:[NSString stringWithFormat: @"Request time interval cannot be less than 60 seconds "
                       @"(1 minute), will be set to 1 minute."]
          forDescription:kMappIntelligenceLogLevelDescriptionError];
        self.requestsInterval = 5;
  }
}

- (BOOL)trackDomainValidation:(NSString *)trackingDomain {

  NSURLComponents *components;
  if ([trackDomain length] != 0) {
    components = [[NSURLComponents alloc] initWithString:trackingDomain];
  } else {
    [_logger logObj:@"You must enter a track domain, track domain cannot be empty!"
        forDescription:kMappIntelligenceLogLevelDescriptionError];
      return false;
  }
  if (!components) {
    [_logger logObj:@"You must enter a valid url format for track domain!"
        forDescription:kMappIntelligenceLogLevelDescriptionError];
  } else if (!components.scheme) {
    if (([trackingDomain rangeOfString:@"https://"].location == NSNotFound) ||
        ([trackingDomain rangeOfString:@"http://"].location == NSNotFound)) {
      self.trackDomain =
          [NSString stringWithFormat:@"https://%@", trackingDomain];
    }
  }

  return components && components.scheme && components.host;
}

- (void)validateTrackingIDs:(NSArray *)validTrackingIDs {
  NSArray *tempTrackingIDs;
    if ([validTrackingIDs count] == 0) {
        [_logger logObj:@"You must enter at least one trackID, trackID list cannot be empty!"
        forDescription:kMappIntelligenceLogLevelDescriptionError];
    }
  if (validTrackingIDs != nil) {
    tempTrackingIDs = validTrackingIDs;
  }
  if ([[tempTrackingIDs lastObject] isEqual:@""] ||
      [[tempTrackingIDs lastObject] isEqual:@","] ||
      [[tempTrackingIDs lastObject] isEqual:@" "]) {
      [_logger logObj:@"TrackIDs cannot contain blank spaces or empty strings!"
      forDescription:kMappIntelligenceLogLevelDescriptionError];
  }
}

- (void)setLogLevel:(MappIntelligenceLogLevelDescription)logLevel {
  [_logger setLogLevel:logLevel];
}
- (void)setRequestsInterval:(NSTimeInterval)requestsInterval {
    _requestsInterval = requestsInterval;
    [[NSUserDefaults standardUserDefaults] setDouble:requestsInterval forKey:key_requestsInterval];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)setOptOut:(BOOL)optOut {
    _optOut = optOut;
    [[NSUserDefaults standardUserDefaults] setBool:optOut forKey:key_optOut];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)optOut {
    return _optOut;
}

- (void)setRequestPerQueue:(NSInteger)requestPerQueue {
    _requestPerQueue = requestPerQueue;
    [[NSUserDefaults standardUserDefaults] setInteger:requestPerQueue forKey:key_requestPerQueue];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setBatchSupport:(BOOL)batchSupport {
    _batchSupport = batchSupport;
    [[NSUserDefaults standardUserDefaults] setBool:batchSupport forKey:key_batchSupport];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) reset {
    self.requestsInterval = requestIntervalDefault;
    self.optOut = optOutDefault;
    self.batchSupport = batchSupportDefault;
    self.requestPerQueue = requestIntervalDefault;
}

- (BOOL) isConfiguredForTracking {
    if (self.trackDomain && self.trackIDs) {
        return YES;
    }
    [_logger logObj:@"Mapp Intelligence is not configured properly for tracking. Missing track domain or trackid!" forDescription:kMappIntelligenceLogLevelDescriptionDebug];

    return NO;
}
@synthesize sendAppVersionToEveryRequest;

@end
