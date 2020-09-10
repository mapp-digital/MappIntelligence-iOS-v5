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

- (void)setRequestTimeout:(NSTimeInterval)requestTimeout {
    [_mappIntelligence setRequestTimeout:requestTimeout];
}

- (void)setLogLevelWatchOS:(logWatchOSLevel)logLevelWatchOS {
    [_mappIntelligence setLogLevel: (logLevel)logLevelWatchOS];
}

- (NSTimeInterval)requestTimeout {
    return [_mappIntelligence requestTimeout];
}

- (logWatchOSLevel)logLevelWatchOS {
    return (logWatchOSLevel)[_mappIntelligence logLevel];
}

- (NSError *)trackPageWithName:(NSString *)name andWithPageProperties:(PageProperties *)properties {
    [_mappIntelligence trackPageWithName:name andWithPageProperties:properties];
}

- (void)reset {
    [_mappIntelligence reset];
}

@end
