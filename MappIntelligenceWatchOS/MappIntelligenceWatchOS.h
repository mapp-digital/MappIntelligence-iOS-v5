//
//  MappIntelligenceWatchOS.h
//  MappIntelligenceWatchOS
//
//  Created by Stefan Stevanovic on 3/24/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MappIntelligenceWatchOS : NSObject

/**
 MappIntelignece instance
 @brief Method for gets a singleton instance of MappInteligence.
 <pre><code>
 MappIntelligence *mappIntelligence = [MappIntelligence shared];
 </code></pre>
 @return MappIntelligence an Instance Type of MappIntelligence.
 */
+ (nullable instancetype)shared;
- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs
                    onTrackdomain:(NSString *_Nonnull)trackDomain
          withAutotrackingEnabled:(BOOL)autoTracking
                   requestTimeout:(NSTimeInterval)requestTimeout
                 numberOfRequests:(NSInteger)numberOfRequestInQueue
              batchSupportEnabled:(BOOL)batchSupport
viewControllerAutoTrackingEnabled:(BOOL)viewControllerAutoTracking
                      andLogLevel:(NSInteger)lv;
//- (void)trackPageWith:(NSString *_Nullable)name;

@end
