//
//  DefaultTracker.h
//  MappIntelligenceSDK
//
//  Created by Vladan Randjelovic on 10/02/2020.
//  Copyright © 2020 Mapp Digital US, LLC. All rights reserved.
//

#ifndef DefaultTracker_h
#define DefaultTracker_h
#import <UIKit/UIKit.h>
#if TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif

#endif /* DefaultTracker_h */

@interface DefaultTracker : NSObject
@property BOOL isReady;
+ (nullable instancetype)sharedInstance;
- (NSString *_Nullable)generateEverId;
#if !TARGET_OS_WATCH
- (NSError*_Nullable)track:(UIViewController *_Nonnull)controller;
- (void)updateFirstSessionWith: (UIApplicationState) state;
#else
- (void)updateFirstSessionWith: (WKApplicationState) state;
#endif
- (NSError*_Nullable)trackWith:(NSString *_Nonnull)name;
+ (NSUserDefaults *_Nonnull)sharedDefaults;
- (void)initHibernate;
- (void)reset;
- (void)initializeTracking;
- (void)sendRequestFromDatabase;
- (void)sendBatchForRequest;
- (void)removeAllRequestsFromDB;
@end
