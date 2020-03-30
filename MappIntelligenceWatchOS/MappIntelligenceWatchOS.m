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
//#import "MappIntelligenceLogger.h"
//#import "MappIntelligence.h"
//#import "MappIntelligenceDefaultConfig.h"

@interface MappIntelligenceWatchOS ()

//@property MappIntelligenceDefaultConfig *configuration;
//@property DefaultTracker *tracker;
//@property MappIntelligenceLogger *logger;
@property MappIntelligence * mappIntelligence;

@end

@implementation MappIntelligenceWatchOS

//static MappIntelligence *sharedInstance = nil;
//static MappIntelligenceDefaultConfig *config = nil;
//@synthesize tracker;
//
//- (id)init {
//  self = [super init];
//  if (!sharedInstance) {
//    sharedInstance = [[MappIntelligence alloc] init];
//    config = [[MappIntelligenceDefaultConfig alloc] init];
//    _logger = [MappIntelligenceLogger shared];
//  }
//  return self;
//}

+ (nullable instancetype)shared {
  static MappIntelligenceWatchOS *shared = nil;

  static dispatch_once_t onceToken;

  dispatch_once(&onceToken, ^{

    shared = [[MappIntelligenceWatchOS alloc] init];
  });
    
  return shared;
}

- (void)initWithConfiguration:(NSArray *)trackIDs onTrackdomain:(NSString *)trackDomain withAutotrackingEnabled:(BOOL)autoTracking requestTimeout:(NSTimeInterval)requestTimeout numberOfRequests:(NSInteger)numberOfRequestInQueue batchSupportEnabled:(BOOL)batchSupport viewControllerAutoTrackingEnabled:(BOOL)viewControllerAutoTracking andLogLevel:(NSInteger)lv {
    _mappIntelligence = [MappIntelligence shared];
    [_mappIntelligence initWithConfiguration:trackIDs onTrackdomain:trackDomain withAutotrackingEnabled:autoTracking requestTimeout:requestTimeout numberOfRequests:numberOfRequestInQueue batchSupportEnabled:batchSupport viewControllerAutoTrackingEnabled:viewControllerAutoTracking andLogLevel: all];
    NSLog(@"Initialisation completed");
}

@end
