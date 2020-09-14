//
//  MappIntelligencetvOS.m
//  MappIntelligencetvOS
//
//  Created by Stefan Stevanovic on 4/24/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import "MappIntelligencetvOS.h"
#import "MappIntelligence.h"
#import "DefaultTracker.h"

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

- (void)setRequestTimeout:(NSTimeInterval)requestTimeout {
    [_mappIntelligence setRequestTimeout:requestTimeout];
}

- (void)setLogLevelTVOS:(logTvOSLevel)logLevelTVOS {
    [_mappIntelligence setLogLevel: (logLevel)logLevelTVOS];
}

- (NSTimeInterval)requestTimeout {
    return [_mappIntelligence requestTimeout];
}

- (logTvOSLevel)logLevelTVOS {
    return (logTvOSLevel)[_mappIntelligence logLevel];
}

- (NSError *_Nullable)trackPageWithName: (NSString *_Nonnull) name pageProperties:(PageProperties  *_Nullable)properties sessionProperties: (SessionProperties *_Nullable) sessionProperties {
    return [_mappIntelligence trackPageWithName:name pageProperties:pageProperties  sessionProperties:sessionProperties];
}

- (NSError *)trackPageWithViewController:(UIViewController *)controller andWithPageProperties:(PageProperties *)properties {
    return [_mappIntelligence trackPageWithViewController:controller andWithPageProperties:properties];
}

- (void)reset {
    [_mappIntelligence reset];
}
@end
