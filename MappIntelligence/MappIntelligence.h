//
//  Webrekk.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Stefan Stevanovic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, logLevel) {
  debug = 1,   // The lowest priority that you would normally log, and purely
               // informational in nature.
  warning = 2, // Something is missing and might fail if not corrected
  error = 3,   // Something has failed.
  fault = 4,   // A failure in a key system.
  info = 5, // Informational logs for updating configuration or migrating from
            // older versions of the library.
  all = 6,  // All logs of the above.
};

@interface MappIntelligence : NSObject {
}
/**
 MappIntelignece instance
 @brief Method for gets a singleton instance of MappInteligence.
 <pre><code>
 MappIntelligence *mappIntelligence = [MappIntelligence shared];
 </code></pre>
 @return MappIntelligence an Instance Type of MappIntelligence.
 */
+ (nullable instancetype)shared;
+ (NSString *_Nonnull)version;

- (void)trackPage:(UIViewController *_Nullable)controller;

+ (NSString *_Nonnull)getUrl;
+ (NSString *_Nonnull)getId;

- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs
                        onTrackdomain:(NSString *_Nonnull)trackDomain
              withAutotrackingEnabled:(BOOL)autoTracking
                       requestTimeout:(NSTimeInterval)requestTimeout
                     numberOfRequests:(NSInteger)numberOfRequestInQueue
                  batchSupportEnabled:(BOOL)batchSupport
    viewControllerAutoTrackingEnabled:(BOOL)viewControllerAutoTracking
                          andLogLevel:(logLevel)lv;

@end
