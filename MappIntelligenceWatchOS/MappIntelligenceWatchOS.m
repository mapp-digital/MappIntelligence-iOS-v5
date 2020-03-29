//
//  MappIntelligenceWatchOS.m
//  MappIntelligenceWatchOS
//
//  Created by Stefan Stevanovic on 3/24/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import "MappIntelligenceWatchOS.h"
#import <WatchKit/WatchKit.h>
//#import "MappIntelligence.h"
#import "DefaultTracker.h"
//#import "MappIntelligenceLogger.h"
//#import "MappIntelligence.h"
//#import "MappIntelligenceDefaultConfig.h"

@interface MappIntelligenceWatchOS ()

//@property MappIntelligenceDefaultConfig *configuration;
//@property DefaultTracker *tracker;
//@property MappIntelligenceLogger *logger;
//@property MappIntelligence * shared;

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
    //shared = [[MappIntelligence alloc] init];
    
  return shared;
}
//
//-(void)trackPageWith:(NSString *)name {
//  [tracker trackWith:name];
//}
//
//- (void)initWithConfiguration:(NSArray *)trackIDs
//                        onTrackdomain:(NSString *)trackDomain
//              withAutotrackingEnabled:(BOOL)autoTracking
//                       requestTimeout:(NSTimeInterval)requestTimeout
//                     numberOfRequests:(NSInteger)numberOfRequestInQueue
//                  batchSupportEnabled:(BOOL)batchSupport
//    viewControllerAutoTrackingEnabled:(BOOL)viewControllerAutoTracking
//                          andLogLevel:(logLevel)lv {
//
//  [config setLogLevel:(MappIntelligenceLogLevelDescription)lv];
//  [config setTrackIDs:trackIDs];
//  [config setTrackDomain:trackDomain];
//  [config setAutoTracking:autoTracking];
//  [config setBatchSupport:batchSupport];
//  [config setViewControllerAutoTracking:viewControllerAutoTracking];
//  [config setRequestPerQueue:numberOfRequestInQueue];
//  [config setRequestsInterval:requestTimeout];
//  [config logConfig];
//
//  tracker = [DefaultTracker sharedInstance];
//  [tracker initializeTracking];
//}

@end
