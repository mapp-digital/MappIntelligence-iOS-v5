//
//  MappIntelligenceWatchOS.m
//  MappIntelligenceWatchOS
//
//  Created by Stefan Stevanovic on 3/24/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
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

- (void)initWithConfiguration:(NSArray *)trackIDs onTrackdomain:(NSString *)trackDomain requestTimeout:(NSTimeInterval)requestTimeout andLogLevel:(logWatchOSLevel)lv {
    [_mappIntelligence initWithConfiguration:trackIDs onTrackdomain:trackDomain requestTimeout:requestTimeout andLogLevel:(logLevel)lv];
}

-(void)trackPageWith:(NSString *)name {
    [_mappIntelligence trackPageWith:name];
}

- (void)reset {
    [_mappIntelligence reset];
}

@end
