//
//  Webrekk.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "MappIntelligenceDataService.h"
//#import "DefaultTracker.h"

@interface MappIntelligence : NSObject
{}
/**
 MappIntelignece instance
 @brief Method for gets a singleton instance of MappInteligence.
 <pre><code>
 MappIntelligence *mappIntelligence = [MappIntelligence shared];
 </code></pre>
 @return MappIntelligence an Instance Type of MappIntelligence.
 */
+ (nullable instancetype)shared;

-(void)trackPage:(UIViewController*_Nullable) controller;

+(void) setConfigurationWith: (NSDictionary *_Nullable) dictionary;

-(void)initWithConfiguration:(NSArray *_Nonnull)trackIDs onDomain:(NSString *_Nonnull)trackDomain withAutotrackingEnabled:(BOOL)autoTracking requestTimeout:(NSTimeInterval)requestTimeout numberOfRequests:(NSInteger)numberOfRequestInQueue batchSupportEnabled:(BOOL)batchSupport viewControllerAutoTrackingEnabled:(BOOL)viewControllerAutoTracking andLogLevel:(enum MappIntelligenceLogLevelDescription)logLevel;

@end
