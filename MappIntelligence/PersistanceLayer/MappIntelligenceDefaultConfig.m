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
#define key_viewControllerAutoTracking @"view_controller_auto_tracking"
#define key_MappIntelligence_default_configuration @"defaultConfiguration"

@interface MappIntelligenceDefaultConfig ()
@property (nonnull) MappIntelligenceLogger *logger;
@end

@implementation MappIntelligenceDefaultConfig : NSObject

@synthesize autoTracking;
@synthesize batchSupport;
@synthesize requestPerQueue;
@synthesize requestsInterval;
/** Tracking domain is MANDATORY field */
@synthesize trackDomain;

/** Track ID is a mandatory field and must be entered at least one for the
 * configuration to be saved */
@synthesize trackIDs;
@synthesize viewControllerAutoTracking;
@synthesize logLevel;

- (instancetype)init {

  self = [super init];
  _logger = [MappIntelligenceLogger shared];
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
  [_logger logObj:([@"Auto Tracking is enabled: "
                      stringByAppendingFormat:self.autoTracking ? @"Yes"
                                                                : @"No"])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
  [_logger logObj:([@"Batch Support is enabled: "
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
  [_logger logObj:([@"Log Level is:  "
                      stringByAppendingFormat:@"%@",
                                              [self getLogLevelFor:[_logger logLevel]]])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
  [self validateTrackingIDs:self.trackIDs];
  [_logger logObj:([@"Tracking IDs: "
                      stringByAppendingFormat:@"%@", self.trackIDs])
      forDescription:kMappIntelligenceLogLevelDescriptionInfo];
  [self trackDomainValidation:self.trackDomain];
  [_logger logObj:([@"Tracking domain is: "
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
    [_logger logObj:@"Number of requests can't be grater than 10000, will be "
                    @"returned to "
                    @"default (10)."
        forDescription:kMappIntelligenceLogLevelDescriptionError];
    self.requestPerQueue = 10;
  }
}

- (void)validateRequestTimeInterval:(NSInteger)timeInterval {
  if (timeInterval > 3600.0) {
    [_logger logObj:@"Request time interval can't be more than 3600 seconds "
                    @"(60 minutes), will be reset to default (15 minutes)."
        forDescription:kMappIntelligenceLogLevelDescriptionError];
    self.requestsInterval = 900.0;
  }
}

- (BOOL)trackDomainValidation:(NSString *)trackingDomain {

  NSURLComponents *components;
  if ([trackDomain length] != 0) {
    components = [[NSURLComponents alloc] initWithString:trackingDomain];
  } else {
    [_logger logObj:@"Tracking domain can not be empty!"
        forDescription:kMappIntelligenceLogLevelDescriptionError];
      return false;
  }
  if (!components) {
    [_logger logObj:@"You must enter a valid url format for tracking domain!"
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
        [_logger logObj:@"You must enter a track IDs, track IDs list can not be empty!"
        forDescription:kMappIntelligenceLogLevelDescriptionError];
    }
  if (validTrackingIDs != nil) {
    tempTrackingIDs = validTrackingIDs;
  }
  if ([[tempTrackingIDs lastObject] isEqual:@""] ||
      [[tempTrackingIDs lastObject] isEqual:@","] ||
      [[tempTrackingIDs lastObject] isEqual:@" "]) {
      [_logger logObj:@"Tracking IDs can not contain blank spaces or empty strings!"
      forDescription:kMappIntelligenceLogLevelDescriptionError];
  }
}

- (void)setLogLevel:(MappIntelligenceLogLevelDescription)logLevel {
  [_logger setLogLevel:logLevel];
}

@end
