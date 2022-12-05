//
//  MappIntelligencetvOS.m
//  MappIntelligencetvOS
//
//  Created by Stefan Stevanovic on 4/24/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MappIntelligencetvOS.h"
#import "MappIntelligence.h"

@interface MappIntelligencetvOS ()

@property MappIntelligence * mappIntelligence;

@end

@implementation MappIntelligencetvOS

+ (nullable instancetype)shared {
  static MappIntelligencetvOS *shared = nil;

  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{

    shared = [[MappIntelligencetvOS alloc] init];
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
    [_mappIntelligence initWithConfiguration:trackIDs onTrackdomain:trackDomain];
}

- (void)setLogLevelTVOS:(logTvOSLevel)logLevelTVOS {
    [_mappIntelligence setLogLevel: (logLevel)logLevelTVOS];
}

- (logTvOSLevel)logLevelTVOS {
    return (logTvOSLevel)[_mappIntelligence logLevel];
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

- (BOOL)enableBackgroundSendout {
    return [_mappIntelligence enableBackgroundSendout];
}

- (void) setBatchSupportEnabled:(BOOL)batchSupportEnabled {
    [_mappIntelligence setBatchSupportEnabled:batchSupportEnabled];
}

- (void)setEnableBackgroundSendout:(BOOL)enableBackgroundSendout {
    [_mappIntelligence setEnableBackgroundSendout:enableBackgroundSendout];
}

- (NSInteger) requestPerQueue {
    return [_mappIntelligence requestPerQueue];
}

- (void) setRequestPerQueue:(NSInteger)requestPerQueue {
    [_mappIntelligence setRequestPerQueue:requestPerQueue];
}

- (NSError *)trackPageWithViewController:(UIViewController *)controller pageViewEvent:(MIPageViewEvent *)event {
    return [_mappIntelligence trackPageWithViewController:controller pageViewEvent:event];
}

- (NSError *_Nullable) trackPage:(MIPageViewEvent *_Nonnull) event {
    return [_mappIntelligence trackPage:event];
}

- (NSError *_Nullable) trackAction:(MIActionEvent *_Nonnull) event {
    return [_mappIntelligence trackAction:event];
}

- (NSError *_Nullable) trackMedia:(MIMediaEvent *_Nonnull) event {
    return [_mappIntelligence trackMedia:event];
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

- (void)setShouldMigrate:(BOOL)shouldMigrate {
    [_mappIntelligence setShouldMigrate:shouldMigrate];
}

-(BOOL) anonymousTracking {
    return [_mappIntelligence anonymousTracking];
}

-(void) setAnonymousTracking:(BOOL)anonymousTracking {
    [_mappIntelligence setAnonymousTracking:anonymousTracking];
}

-(void) enableAnonymousTracking:(NSArray<NSString *> *_Nullable) suppressParams {
    [_mappIntelligence enableAnonymousTracking:suppressParams];
}

- (void)setSendAppVersionInEveryRequest:(BOOL)sendAppVerisonToEveryRequest {
    [_mappIntelligence setSendAppVersionInEveryRequest:sendAppVerisonToEveryRequest];
}

- (BOOL)sendAppVersionInEveryRequest {
    return [_mappIntelligence sendAppVersionInEveryRequest];
}

- (void)enableCrashTracking:(exceptionTypeTVOS)exceptionLogLevel {
    [_mappIntelligence enableCrashTracking:(exceptionType)exceptionLogLevel];
}

@end
