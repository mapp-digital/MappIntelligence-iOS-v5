//
//  MappIntelligenceWatchOS.m
//  MappIntelligenceWatchOS
//
//  Created by Stefan Stevanovic on 3/24/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MappIntelligenceWatchOS.h"
#import <WatchKit/WatchKit.h>
#import "MappIntelligence.h"
#import "DefaultTracker.h"

@interface MappIntelligenceWatchOS ()

@property MappIntelligence * mappIntelligence;

@end

@implementation MappIntelligenceWatchOS

+ (nullable instancetype)shared {
  static MappIntelligenceWatchOS *shared = nil;

  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{

    shared = [[MappIntelligenceWatchOS alloc] init];
  });
    
  return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _mappIntelligence = [MappIntelligence shared];
    }
    return self;
}

- (void)initWithConfiguration:(NSArray *)trackIDs onTrackdomain:(NSString *)trackDomain {
    //by default log level is set to null and request timeout to 45
    [_mappIntelligence initWithConfiguration:trackIDs onTrackdomain:trackDomain];
}

- (void)setLogLevelWatchOS:(logWatchOSLevel)logLevelWatchOS {
    [_mappIntelligence setLogLevel: (logLevel)logLevelWatchOS];
}

- (logWatchOSLevel)logLevelWatchOS {
    return (logWatchOSLevel)[_mappIntelligence logLevel];
}

- (NSTimeInterval)requestInterval {
    return [_mappIntelligence requestInterval];
}

- (void)setRequestInterval:(NSTimeInterval)requestInterval {
    [_mappIntelligence setRequestInterval:requestInterval];
}

- (BOOL)batchSupportEnabled {
    return [_mappIntelligence batchSupportEnabled];
}

- (void) setBatchSupportEnabled:(BOOL)batchSupportEnabled {
    [_mappIntelligence setBatchSupportEnabled:batchSupportEnabled];
}

- (NSInteger) requestPerQueue {
    return [_mappIntelligence requestPerQueue];
}

- (void) setRequestPerQueue:(NSInteger)requestPerQueue {
    [_mappIntelligence setRequestPerQueue:requestPerQueue];
}

- (NSError *_Nullable)trackPageWithName: (NSString *_Nonnull) name pageProperties:(PageProperties  *_Nullable)pageProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties {
    return [_mappIntelligence trackPageWithName:name pageProperties:pageProperties sessionProperties:sessionProperties];
}

- (NSError *_Nullable) trackCustomEventWithName:(NSString *_Nonnull) name  actionProperties: (ActionProperties *_Nullable) actionProperties sessionProperties: (SessionProperties *_Nullable) sessionProperties {
    return [_mappIntelligence trackCustomEventWithName:name actionProperties:actionProperties sessionProperties:sessionProperties];
}

- (void)reset {
    [_mappIntelligence reset];
}

- (void) optIn {
    [_mappIntelligence optIn];
}

- (void)optOutAndSendCurrentData:(BOOL) value {
    [_mappIntelligence optOutAndSendCurrentData:value];
}

@end
