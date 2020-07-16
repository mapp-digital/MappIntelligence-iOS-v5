//
//  Webrekk.h
//  Webrekk
//
//  Created by Stefan Stevanovic on 1/3/20.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, logLevel) {
  all = 1,     // All logs of the above.
  debug = 2,   // The lowest priority that you would normally log, and purely
               // informational in nature.
  warning = 3, // Something is missing and might fail if not corrected
  error = 4,   // Something has failed.
  fault = 5,   // A failure in a key system.
  info = 6, // Informational logs for updating configuration or migrating from
            // older versions of the library.
  none = 7  // None of the logs.
};

@interface MappIntelligence : NSObject {
}

@property (nonatomic, readwrite) NSTimeInterval requestTimeout;
@property (nonatomic, readwrite) logLevel logLevel;
@property (nonatomic, readwrite) BOOL batchSupportEnabled;
@property (nonatomic, readwrite) NSInteger batchSupportSize;
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
+ (NSString *_Nonnull)getUrl;
+ (NSString *_Nonnull)getId;

#if !TARGET_OS_WATCH
- (NSError *_Nullable)trackPage:(UIViewController *_Nullable)controller;
#endif
- (NSError *_Nullable)trackPageWith:(NSString *_Nullable)name;

- (void)initWithConfiguration:(NSArray *_Nonnull)trackIDs
                    onTrackdomain:(NSString *_Nonnull)trackDomain;

- (void)reset;
- (void)optOutWith:(BOOL) status andSendCurrentData:(BOOL) value;

//testable methods
- (void) printAllRequestFromDatabase;
- (void) removeRequestFromDatabaseWithID: (int)ID;

@end
