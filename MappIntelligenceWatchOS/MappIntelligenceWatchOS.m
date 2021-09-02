//
//  MappIntelligenceWatchOS.m
//  MappIntelligenceWatchOS
//
//  Created by Stefan Stevanovic on 3/24/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MappIntelligenceWatchOS.h"
#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif
#import "MappIntelligence.h"

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

//- (NSError *_Nullable)trackPageWithName: (NSString *_Nonnull) name pageProperties:(MIPageParameters  *_Nullable)pageProperties sessionProperties: (MISessionProperties *_Nullable) sessionProperties userProperties: (MIUserCategories *_Nullable) userProperties ecommerceProperties:(id)ecommerceProperties advertisementProperties:(MIAdvertisementProperties * _Nullable)advertisemementProperties {
//    return [_mappIntelligence trackPageWithName:name pageProperties:pageProperties sessionProperties:sessionProperties userProperties:userProperties ecommerceProperties:ecommerceProperties advertisementProperties:advertisemementProperties];
//}

//- (NSError *_Nullable) trackCustomEventWithName:(NSString *_Nonnull) name  actionProperties: (MIActionProperties *_Nullable) actionProperties sessionProperties: (MISessionProperties *_Nullable) sessionProperties  userProperties: (MIUserCategories *_Nullable) userProperties ecommerceProperties:(MIEcommerceProperties * _Nullable)ecommerceProperties advertisementProperties:(MIAdvertisementProperties * _Nullable)advertisemementProperties {
//    return [_mappIntelligence trackCustomEventWithName:name actionProperties:actionProperties sessionProperties:sessionProperties userProperties:userProperties ecommerceProperties:ecommerceProperties advertisementProperties:advertisemementProperties];
//}

- (NSError *_Nullable) trackPage:(MIPageViewEvent *_Nonnull) event {
    return [_mappIntelligence trackPage:event];
}

- (NSError *_Nullable) trackAction:(MIActionEvent *_Nonnull) event {
    return [_mappIntelligence trackAction:event];
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

@end
