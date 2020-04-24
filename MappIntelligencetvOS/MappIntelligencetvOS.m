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

- (void)initWithConfiguration:(NSArray *)trackIDs onTrackdomain:(NSString *)trackDomain requestTimeout:(NSTimeInterval)requestTimeout andLogLevel:(logTvOSLevel)lv {
    [_mappIntelligence initWithConfiguration:trackIDs onTrackdomain:trackDomain requestTimeout:requestTimeout andLogLevel:(logLevel)lv];
}

-(void)trackPageWith:(NSString *)name {
    [_mappIntelligence trackPageWith:name];
}

- (void)trackPage:(UIViewController *)controller {
    [_mappIntelligence trackPage:controller];
}

- (void)reset {
    [_mappIntelligence reset];
}
@end
