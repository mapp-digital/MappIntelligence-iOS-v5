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

- (void) setBatchSupportEnabled:(BOOL)batchSupportEnabled {
    [_mappIntelligence setBatchSupportEnabled:batchSupportEnabled];
}

- (NSInteger) requestPerQueue {
    return [_mappIntelligence requestPerQueue];
}

- (void) setRequestPerQueue:(NSInteger)requestPerQueue {
    [_mappIntelligence setRequestPerQueue:requestPerQueue];
}

- (NSError *_Nullable)trackPageWithName: (NSString *_Nonnull) name pageProperties:(MIPageProperties  *_Nullable)properties sessionProperties: (MISessionProperties *_Nullable) sessionProperties userProperties: (MIUserProperties *) userProperties ecommerceProperties: (MIEcommerceProperties *_Nullable) ecommerceProperties  advertisementProperties: (MIAdvertisementProperties *_Nullable) advertisemementProperties {
    return [_mappIntelligence trackPageWithName:name pageProperties:properties  sessionProperties:sessionProperties userProperties:userProperties ecommerceProperties: ecommerceProperties advertisementProperties:advertisemementProperties];
}

- (NSError *_Nullable)trackPageWithViewController:(UIViewController *_Nonnull)controller pageProperties:(MIPageProperties  *_Nullable)pageProperties sessionProperties:(MISessionProperties *_Nullable) sessionProperties userProperties: (MIUserProperties *) userProperties ecommerceProperties: (MIEcommerceProperties *_Nullable) ecommerceProperties  advertisementProperties: (MIAdvertisementProperties *_Nullable) advertisemementProperties {
    return [_mappIntelligence trackPageWithViewController:controller pageProperties:pageProperties sessionProperties:sessionProperties userProperties:userProperties ecommerceProperties: ecommerceProperties advertisementProperties:advertisemementProperties];
}

- (NSError *_Nullable) trackCustomEventWithName:(NSString *_Nonnull) name  actionProperties: (MIActionProperties *_Nullable) actionProperties sessionProperties: (MISessionProperties *_Nullable) sessionProperties userProperties: (MIUserProperties *) userProperties ecommerceProperties:(MIEcommerceProperties * _Nullable)ecommerceProperties advertisementProperties: (MIAdvertisementProperties *_Nullable) advertisemementProperties{
    return [_mappIntelligence trackCustomEventWithName:name actionProperties:actionProperties sessionProperties:sessionProperties userProperties:userProperties ecommerceProperties:ecommerceProperties advertisementProperties:advertisemementProperties];
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
