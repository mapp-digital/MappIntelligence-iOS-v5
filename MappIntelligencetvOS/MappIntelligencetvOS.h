//
//  MappIntelligencetvOS.h
//  MappIntelligencetvOS
//
//  Created by Stefan Stevanovic on 4/24/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, logTvOSLevel) {
  allTvOSLogs = 1,     // All logs of the above.
  debugTvOSLogs = 2,   // The lowest priority that you would normally log, and purely
               // informational in nature.
  warningTvOSLogs = 3, // Something is missing and might fail if not corrected
  errorTvOSLogs = 4,   // Something has failed.
  faultTvOSLogs = 5,   // A failure in a key system.
  infoTvOSLogs = 6, // Informational logs for updating configuration or migrating from
            // older versions of the library.
  noneOfTvOSLogs = 7  // None of the logs.
};

@interface MappIntelligencetvOS : NSObject
/**
 MappIntelignece instance
 @brief Method for gets a singleton instance of MappInteligence.
 <pre><code>
 MappIntelligence *mappIntelligence = [MappIntelligence shared];
 </code></pre>
 @return MappIntelligence an Instance Type of MappIntelligence.
 */
+ (nullable instancetype)shared;
//- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs
//                    onTrackdomain:(NSString *_Nonnull)trackDomain
//          withAutotrackingEnabled:(BOOL)autoTracking
//                   requestTimeout:(NSTimeInterval)requestTimeout
//                 numberOfRequests:(NSInteger)numberOfRequestInQueue
//              batchSupportEnabled:(BOOL)batchSupport
//viewControllerAutoTrackingEnabled:(BOOL)viewControllerAutoTracking
//                      andLogLevel:(logWatchOSLevel)lv;

- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs
                    onTrackdomain:(NSString *_Nonnull)trackDomain
                   requestTimeout:(NSTimeInterval)requestTimeout
                      andLogLevel:(logTvOSLevel)lv;
- (void)trackPageWith:(NSString *_Nullable)name;
- (void)trackPage:(UIViewController *_Nullable)controller;
- (void)reset;

@end
